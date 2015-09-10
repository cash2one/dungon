package com.ace.ui.notice.message
{
	import com.ace.config.Core;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.notice.child.NoticeIcon;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Message8 extends Sprite
	{
		// 定义图标宽度
		private static const RENDER_WIDTH:int = 40;
		
		// 提示信息队列,显示后删除
		private var noticeInfo:Vector.<TNoticeInfo>;
		
		// 数据队列与提示信息队列对应
		private var noticeData:Vector.<Array>;
		
		// 显示队列
		private var renders:Vector.<NoticeIcon>;
		
		// 是否正在显示
		private var isMoving:Boolean;
		
		public function Message8(){
			init();
		}
		
		private function init():void{
			noticeInfo = new Vector.<TNoticeInfo>();
			renders = new Vector.<NoticeIcon>();
			noticeData = new Vector.<Array>();
			resize();
		}
		
		public function broadcast(info:TNoticeInfo, data:Array):void{
			if(!containsQueue(info, data) && !containsRenders(info, data)){
				noticeInfo.push(info);
				noticeData.push(data);
				showNext();
			}
			selectKillData(info, data);
		}
		
		private function containsQueue(info:TNoticeInfo, data:Array):Boolean{
			// 检测是否重复
			var index:int = noticeInfo.indexOf(info);
			if(index != -1){
				if(noticeData[index] == data){
					return true;
				}
				
				// 特殊处理 待删除
				var content:String=info.content;
				var flag:int=content.indexOf("|");
				var type:int=int(content.substring(0, flag));
				content = noticeInfo[index].content;
				var qf:int = content.indexOf("|");
				var qt:int = int(content.substring(0, qf));
				if(4 == type && qt == type){
					return true;
				}
				
				var qStr:String = noticeData[index].toString();
				var cStr:String = data.toString();
				return (qStr == cStr);
			}
			return false;
		}
		
		private function containsRenders(info:TNoticeInfo, data:Array):Boolean{
			var l:int = renders.length;
			for(var n:int = 0; n < l; n++){
				var render:NoticeIcon = renders[n];
				if(render.id == info.id){
					if(render.data == data){
						return true;
					}
					
					// 特殊处理 待删除
					var content:String=info.content;
					var flag:int=content.indexOf("|");
					var type:int=int(content.substring(0, flag));
					if(4 == type && render.type == type){
						return true;
					}
					
					var qStr:String = render.data.toString();
					var cStr:String = data.toString();
					return (qStr == cStr);
				}
			}
			return false;
		}
		
		public function showNext():void{
			if (!hasNotice() || !hasPos() || isMoving){
				return;
			}
			var render:NoticeIcon = NoticeManager.getInstance().noticeIconReuseDic.getFreeRender() as NoticeIcon;
			render.addEventListener(MouseEvent.CLICK, onMouseClick);
			render.updateInfo(noticeInfo.shift(), noticeData.shift());
			addChild(render);
			renders.push(render);
			render.x = renders.length*RENDER_WIDTH;
			adjustPos();
//			executeGuide(render);
			NoticeManager.getInstance().noticeIconReuseDic.addToUse(render);
		}
		
		private function selectKillData(info:TNoticeInfo, data:Array):void{
			var content:String=info.content;
			var flag:int=content.indexOf("|");
			var type:int=int(content.substring(0, flag));
			if(4 == type && Core.me.info.level >= ConfigEnum.tobeStr1){
				var date:Date = new Date(data[0]*1000);
				var s:String;
				if(0 == data[5]){
					s = DateUtil.formatDate(date, "YYYY-MM-DD HH24:MI:SS") + "\n"+PropUtils.getStringById(1525);
					s = com.leyou.utils.StringUtil_II.translate(s, data[2], com.leyou.utils.StringUtil_II.getColorStr(com.leyou.utils.StringUtil_II.addEventString(data[1], "["+data[1]+"]", true), ChatEnum.COLOR_USER));
					var pl:Array = data[3];
					if(pl.length > 0){
						s+=PropUtils.getStringById(1516);
						var l:int = pl.length;
						for(var n:int = 0; n < l; n++){
							var itemId:int = pl[n][0];
							var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
							var equipInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(itemId);
							var qulity:uint;
							var itemName:String;
							if (null != itemInfo) {
								qulity=uint(itemInfo.quality);
								itemName=itemInfo.name;
							}
							if (null != equipInfo) {
								qulity=uint(equipInfo.quality);
								itemName=equipInfo.name;
							}
							var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
							var reName:String=com.leyou.utils.StringUtil_II.getColorStrByFace(itemName, color, "微软雅黑", 14);
							if(pl[n][1] > 1){
								s += (reName+"×"+pl[n][1])+",";
							}else{
								s += reName+",";
							}
						}
						s+="."
					}else{
						s+=","+PropUtils.getStringById(1517);
					}
				}else if(1 == data[5]){
					s = TableManager.getInstance().getSystemNotice(3904).content;
					var pn:String = StringUtil_II.getColorStr(StringUtil_II.addEventString(data[1], "["+data[1]+"]", true), ChatEnum.COLOR_USER);
					s = StringUtil.substitute(s, data[2], data[1], data[4]);
				}
				UIManager.getInstance().creatWindow(WindowEnum.DIE);
				UIManager.getInstance().dieWnd.pushInfo(s);
			}
		}
		
//		private function executeGuide(render:NoticeIcon):void{
//			var gid:int;
//			switch(render.type){
//				case NoticeEnum.ICON_LINK_TEAM:          //邀请入队
//					gid = 70;
//					break;
//				case NoticeEnum.ICON_LINK_GUILD:         //邀请入帮
//					gid = 75;
//					break;
//				case NoticeEnum.ICON_LINK_MAIL:          //邮件信息
//					gid = 71;
//					break;
//				case NoticeEnum.ICON_LINK_DIE:		     //死亡信息 数据顺序time,name
//					gid = 72;
//					break;
//				case NoticeEnum.ICON_LINK_CHALLENGE:     //竞技场挑战信息
//					gid = 76;
//					break;
//				case NoticeEnum.ICON_LINK_FARM:          //农场信息
//					gid = 74;
//					break;
//				case NoticeEnum.ICON_LINK_FRIEND:
//					gid = 73;
//					break;
//				case NoticeEnum.ICON_LINK_INTEAM:
//					gid = 70;
//					break;
//				default:
//					return;
////					throw new Error("Message8 has unknow case");
//					break;
//			}
//			GuideManager.getInstance().showGuide(gid, render, true);
//		}
		
		protected function onMouseClick(event:Event):void{
			var target:NoticeIcon = event.currentTarget as NoticeIcon;
			renders.splice(renders.indexOf(target), 1);
			removeChild(target);
			adjustPos();
			NoticeManager.getInstance().callBackFun.call(this, NoticeEnum.LINK_ICON, target.type, target.data);
			NoticeManager.getInstance().noticeIconReuseDic.addToFree(target);
//			GuideManager.getInstance().refreshGuide();
		}
		
		public function adjustPos():void{
			var length:int = renders.length;
			for (var n:int = 0; n < length; n++){
				var px:Number = n * RENDER_WIDTH;
				if(px != renders[n].x){
					isMoving = true;
					TweenMax.to(renders[n], 0.5, {x:px, onComplete:onMoveOver});
				}
				function onMoveOver():void{
					isMoving = false;
					showNext();
					GuideManager.getInstance().resize();
				}
			}
		}
		
		/**
		 * <T>是否有可用位置</T>
		 * 
		 * @return 有木有
		 * 
		 */		
		private function hasPos():Boolean{
			return renders.length < NoticeEnum.MESSAGE8_NUM;
		}
		
		/**
		 * <T>是否有待显示信息</T>
		 * 
		 * @return 有木有
		 * 
		 */		
		public function hasNotice():Boolean{
			return (noticeInfo.length != 0);
		}
		
		/**
		 * <T>屏幕尺寸改变,重置坐标</T>
		 * 
		 */		
		public function resize():void{
			x = UIEnum.WIDTH/2 - NoticeEnum.MESSAGE8_PX;
			y = UIEnum.HEIGHT - NoticeEnum.MESSAGE8_PY;
		}
		
	}
}
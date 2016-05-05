package com.ace.manager {
	import com.ace.ICommon.IGuide;
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.GuideEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.guide.GuidePointTipII;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.DebugUtil;
	import com.greensock.TweenMax;
	import com.leyou.net.cmd.Cmd_Guide;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class GuideManager {
		private static var instance:GuideManager;

		public static function getInstance():GuideManager {
			if (!instance) {
				instance=new GuideManager();
			}
			return instance;
		}


		private var freeTips:Vector.<GuidePointTipII>;
		private var addTips:Vector.<GuidePointTipII>;
		private var addEffects:Object={};
		private var delayObj:Object={};
		private var wndNoExist:Object={};


		public function GuideManager():void {
			this.init();

			EventManager.getInstance().addEvent(EventEnum.WINDOW_SHOW, this.autoGuide);
			EventManager.getInstance().addEvent(EventEnum.TASK_CHANGE, this.autoGuide);
		}

		private function init():void {
			this.freeTips=new Vector.<GuidePointTipII>;
			this.addTips=new Vector.<GuidePointTipII>;
		}


		private var tmpGInfo:TGuideInfo;
		private var tmpCon:Sprite;
		private var tmpTip:GuidePointTipII;

		public function show(id:int):Boolean {
			 
			if (id == 49) {
				trace("为什么不显示？");
			}
			tmpGInfo=TableManager.getInstance().getGuideInfo(id);
			if (!tmpGInfo) {
				DebugUtil.throwError("添加引导id不存在：" + id);
			}

			if (!SettingManager.getInstance().assitInfo.needGuide(id)) {
				return false;
			}

			var isOk:Boolean;
			if (tmpGInfo.type == GuideEnum.GUIDE_EFFECT) {
				isOk=this.addEffect(tmpGInfo);
			} else {
				isOk=this.addTip(tmpGInfo);
			}

			if (isOk) {
				SettingManager.getInstance().assitInfo.addGuideTime(id);
				Cmd_Guide.cm_GUD_F(id);
			}
			return isOk;
		}

		private function addTip(info:TGuideInfo, con:Sprite=null, pt:Point=null):Boolean {
			if (this.isExist(tmpGInfo)) {
				if (info.time > 0) { //更新
					this.cancelDelay(info.id);
					this.delayObj[info.id]=setTimeout(this.delayRemove, info.time, info.id);
				}
				return false;
			}

			//面板不存在
			if (!LayerManager.getInstance().hasWnd(info.wndId)) {
				this.wndNoExist[info.id]=info.wndId;
				return false;
			}

			tmpTip=this.getTips();
			tmpTip.update(info);

			tmpCon=con ? con : LayerManager.getInstance().getWnd(info.wndId) as Sprite;
			if (!tmpCon)
				DebugUtil.throwError("引导表错误：" + info.id);
			//			trace("引导表错误：" + info.id);
			tmpCon.addChild(tmpTip);

			//			if (info.uiId == "") {
			//				DebugUtil.throwError("ui为空，检查表格，或手动实现" + info.id);
			//			}


			var ps:Point;
			var dis:DisplayObject=this.getDis(info);
			if (dis) {
				if (tmpCon != dis.parent) {
					ps=dis.parent.localToGlobal(new Point(dis.x, dis.y));
					ps=tmpCon.globalToLocal(ps);
				} else {
					ps=new Point(dis.x, dis.y);
				}
				switch (info.type) {
					case GuideEnum.GUIDE_POINT_UP: //↑
						tmpTip.x=ps.x + dis.width / 2;
						tmpTip.y=ps.y + dis.height;
						break;
					case GuideEnum.GUIDE_POINT_DOWN: //↓
						tmpTip.x=ps.x + dis.width / 2;
						tmpTip.y=ps.y;
						break;
					case GuideEnum.GUIDE_POINT_LEFT: //←
						tmpTip.x=ps.x + dis.width;
						tmpTip.y=ps.y + dis.height / 2;
						break;
					case GuideEnum.GUIDE_POINT_RIGHT: //→
						tmpTip.x=ps.x;
						tmpTip.y=ps.y + dis.height / 2;
						break;
				}
			}

			tmpTip.x+=info.ox;
			tmpTip.y+=info.oy;

			if (pt) {
				tmpTip.x=pt.x, tmpTip.y=pt.y;
			}

			this.addTips.push(tmpTip);
			this.addEvents(info, dis);
			trace("++++指引：", info.id);
			return true;
		}

		//引导是否存在
		private function isExist(info:TGuideInfo):Boolean {
			for each (tmpTip in this.addTips) {
				if (info.id == tmpTip.tInfo.id || (info.groupId != 0 && info.groupId == tmpTip.tInfo.groupId)) {
					return true;
				}
			}

			return false;
		}

		private function findTip(info:TGuideInfo):GuidePointTipII {
			for each (tmpTip in this.addTips) {
				if (info.id == tmpTip.tInfo.id) {
					return tmpTip;
				}
			}
			return null;
		}

		private function cancelDelay(gid:int):void {
			if (this.delayObj[gid]) {
				clearTimeout(this.delayObj[gid]);
				delete this.delayObj[gid];
			}
		}

		private function addEffect(info:TGuideInfo):Boolean {
			if (this.addEffects[info.id]) {
				if (info.time > 0) { //更新
					this.cancelDelay(info.id);
					this.delayObj[info.id]=setTimeout(this.delayRemove, info.time, info.id);
				}
				return false;
			}
			//面板不存在
			if (!LayerManager.getInstance().hasWnd(info.wndId)) {
				this.wndNoExist[info.id]=info.wndId;
				return false;
			}
			var dis:DisplayObject=this.getDis(info);
			if (!dis) {
				DebugUtil.throwError("引导表错误：" + info.id);
			}
			this.addEffects[info.id]=TweenMax.to(dis, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});

			this.addEvents(info, dis);
			trace("++++指引：", info.id);
			return true;
		}

		private function removeEffect(info:TGuideInfo, isAuto:Boolean):Boolean {
			if (!this.addEffects[info.id]) {
				return false;
			}

			var dis:DisplayObject=this.getDis(info);
			if (dis) {
				dis.filters=[];
			}
			trace("----指引：", info.id);
			this.removeEvents(null, dis);
			!isAuto && (this.addEffects[info.id] as TweenMax).kill();
			this.showNext(info);
			return true;
		}

		private function addEvents(info:TGuideInfo, dis:DisplayObject):void {
			if (dis) {
				try {
					(dis as IGuide).removeGuide(info.id, this.remove);

				} catch (error:Error) {
					trace("引导组件不支持：", info.id);
				}
			}

			if (info.time > 0) {
				this.delayObj[info.id]=setTimeout(this.delayRemove, info.time, info.id);
			}
		}

		private function removeEvents(info:TGuideInfo, dis:DisplayObject=null):void {
			if (dis) {
				try {
					(dis as IGuide).removeGuideEvent();

				} catch (error:Error) {

				}
				return;
			}

			if (info && info.time > 0) {
				this.cancelDelay(info.id);
			}
		}

		private function getDis(info:TGuideInfo):DisplayObject {
			if (info.uiId == "")
				return null;
			try {
				var dis:DisplayObject=LayerManager.getInstance().getWnd(info.wndId).getUIbyID(info.uiId);
			} catch (error:Error) {
				DebugUtil.throwError("引导表格ui错误：" + info.id);
			}
			if (dis is TabBar) {
				dis=(dis as TabBar).getTabButton(info.uiIndex);
			}
			return dis;
		}

		private function delayRemove(id:int):void {
			delete this.delayObj[id];
			this.remove(id, true);
		}

		//按个移除
		public function remove(id:int, isAuto:Boolean=false):Boolean {
			if (id == 116) {
				trace("下一个没显示？");
			}
			var isRemove:Boolean;
			tmpGInfo=TableManager.getInstance().getGuideInfo(id);
			if (!tmpGInfo) {
				DebugUtil.throwError("移除引导id不存在：" + id);
			}

			this.removeEvents(tmpGInfo); //必须调用，延迟打开时，可能还没打开又移除
			if (tmpGInfo.type == GuideEnum.GUIDE_EFFECT) {
				return this.removeEffect(tmpGInfo, isAuto);
			} else {
				return this.removeTip(tmpGInfo);
			}

			return false;
		}

		//按组移除
		public function removeByGuide(gId:int):Boolean {
			var isRemove:Boolean;
			for each (tmpTip in this.addTips) {
				if (gId == tmpTip.tInfo.id) {
					isRemove=true;
					this.removeTip(tmpTip.tInfo, tmpTip);
				}
			}
			return isRemove;
		}


		private function removeTip(info:TGuideInfo, tip:GuidePointTipII=null):Boolean {
			tmpTip=tip ? tip : this.findTip(info);
			if (!tmpTip) {
				return false;
			}

			this.addTips.splice(this.addTips.indexOf(tmpTip), 1);
			tmpTip.die();
			this.freeTips.push(tmpTip); //回收

			trace("----指引：", info.id);
			this.removeEvents(null, this.getDis(info));
			this.showNext(info);
			return true;
		}

		//显示组引导的下一个
		private function showNext(info:TGuideInfo):void {
			if (info.nextId != 0) {
				this.show(info.nextId);
			}
		}





		private function getTips():GuidePointTipII {
			if (this.freeTips.length == 0) {
				this.freeTips.push(new GuidePointTipII());
			}
			return this.freeTips.pop();
		}


		//自动任务：任务、等级触发
		public function autoGuide(info:Object=null):void {
			if (info && (info.wndId == "-1" || !info.isShow))
				return;
			var tmpWnd:AutoWindow;
			for each (var tInfo:TGuideInfo in TableManager.getInstance().guideDic) {
				if (tInfo.id == 145) {
					//				if (info.wndId == 212 && tInfo.id == 135) {
					trace("got");
				}

				//-1非常规判断忽略
				if (!tInfo.isGuideFirst || tInfo.act_con == -1)
					continue;
				if (info) {
					tmpWnd=LayerManager.getInstance().getWnd(info.wndId) as AutoWindow;
					if (!(tmpWnd && tmpWnd.isAboutMe(tInfo.wndId))) {
						continue;
					}

					//界面打开
					if (tInfo.act_con == 0) {
						if (tInfo.guideType != 1 && Core.me.info.level >= tInfo.level) {
							this.show(tInfo.id);
						}
					} else {
						//任务判断 一级菜单
						trace("YYY:", Core.me.info.level, MyInfoManager.getInstance().currentTaskId);
						if (tInfo.guideType != 1 && tInfo.level <= Core.me.info.level && tInfo.act_con == MyInfoManager.getInstance().currentTaskId && !MyInfoManager.getInstance().isTaskOk) {
							this.show(tInfo.id);
						}
					}
				} else {
					//等级判断：一级菜单
					if (tInfo.act_con == 0) {
						if (tInfo.guideType == 1 && Core.me.info.level == tInfo.level) {
							this.show(tInfo.id);
						}
					} else {
						//任务判断 一级菜单
						if (tInfo.guideType == 1 && tInfo.level <= Core.me.info.level && tInfo.act_con == MyInfoManager.getInstance().currentTaskId && !MyInfoManager.getInstance().isTaskOk) {
							this.show(tInfo.id);
						}
					}
				}
			}

			if (info) {
				this.checkWndNoExist(info.wndId);
			}
		}



		private function checkWndNoExist(wndId:String):void {
			for (var gId:String in this.wndNoExist) {
				if (this.wndNoExist[gId] == wndId) {
					this.show(int(gId));
					delete this.wndNoExist[gId];
				}
			}
		}



		//===============================================保留以前接口=================================================================


		public function showGuides(ids:Array, displays:Array):void {
			this.show(ids[0]);
		}

		public function showGuide(id:int, display:DisplayObject=null, check:Boolean=false):void {
			this.show(id);
		}

		public function removeGuide(id:int):void {
			this.remove(id);
		}

		public function resize():void {

		}

		public function refreshGuide():void {

		}

		public function checkGuideByLevel(level:int):void {
			//			for each (var tInfo:TGuideInfo in TableManager.getInstance().guideDic) {
			//				if (tInfo.guideType == 1 && Core.me.info.level == tInfo.level) {
			//					this.show(tInfo.id);
			//				}
			//			}
			this.autoGuide();
		}



















		//===========================在线奖励tip提示======================================



		private var _rc:int;
		private var timeArr:Array;
		private var tick:uint;

		public function get rc():int {
			return _rc;
		}

		public function rewardReducing():void {
			_rc--;
			if (_rc > 0)
				this.show(50);
			UIManager.getInstance().rightTopWnd.updateWelfare();
		}

		public function recordTime(obj:Object):void {
			// 福利
			var tl:Array=obj.tl;
			if (null == timeArr) {
				timeArr=[];
			}
			tick=getTimer();
			//			timeArr=timeArr.concat(tl);
			timeArr=tl;
		}

		protected function onTimer():void {
			if (!Core.me || !Core.me.info || Core.me.info.level < 24) {
				return;
			}
			if (null != timeArr) {
				var interval:int=(getTimer() - tick) / 1000;
				// 福利计时部分
				var expRT:int=timeArr[0]; // 经验奖励
				if (0 < expRT) {
					if (interval >= expRT) {
						timeArr[0]=0;
					}
				} else if (0 == expRT) {
					_rc++;
					timeArr[0]=-1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var moneyRT:int=timeArr[1]; // 金钱奖励
				if (0 < moneyRT) {
					if (interval >= moneyRT) {
						timeArr[1]=0;
					}
				} else if (0 == moneyRT) {
					_rc++;
					timeArr[1]=-1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var energyRT:int=timeArr[2]; // 魂力奖励
				if (0 < energyRT) {
					if (interval >= energyRT) {
						timeArr[2]=0;
					}
				} else if (0 == energyRT) {
					_rc++;
					timeArr[2]=-1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var marketRT:int=timeArr[3]; // 商城奖励
				if (0 < marketRT) {
					if (interval >= marketRT) {
						timeArr[3]=0;
					}
				} else if (0 == marketRT) {
					_rc++;
					timeArr[3]=-1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var bybRT:int=timeArr[4]; // 绑定元宝奖励
				if (0 < bybRT) {
					if (interval >= bybRT) {
						timeArr[4]=0;
					}
				} else if (0 == bybRT) {
					_rc++;
					timeArr[4]=-1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
			}
			if (_rc > 0)
				this.show(50);
		}












	}
}


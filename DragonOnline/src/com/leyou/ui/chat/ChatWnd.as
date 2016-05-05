package com.leyou.ui.chat
{
	import com.ace.config.Core;
	import com.ace.enum.KeysEnum;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.UIManager;
	import com.ace.ui.input.children.HideInput;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.ui.chat.child.ChatMessageView;
	import com.leyou.utils.ChatUtil;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class ChatWnd extends ChatWndView
	{
		public function ChatWnd(){
			super();
			this.init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
		}
		
		public function addKeyDownFun():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var target:DisplayObject = event.target as DisplayObject;
			var globalPoint:Point = new Point(event.stageX, event.stageY);
			var screenPoint:Point = UIManager.getInstance().gameScene.foreground.globalToLocal(globalPoint);
			var targetPoint:Point = SceneUtil.screenToTile(screenPoint.x, screenPoint.y);
			if(target is ChatMessageView){
				Core.me.gotoMap(targetPoint,"",false);
			}else if((target is TextField) && !(target is HideInput)){
				var t:TextField = target as TextField;
				var clickPoint:Point = t.globalToLocal(globalPoint);
				var index:int = t.getCharIndexAtPoint(clickPoint.x, clickPoint.y);
				if(-1 == index){
					Core.me.gotoMap(targetPoint,"",false);
				}
			}
		}
		
		/**
		 * <T>按键抬起监听</T>
		 * 
		 * @param event 键盘事件
		 * 
		 */		
		protected function onKeyDown(event:KeyboardEvent):void{
			switch (event.keyCode) {
				case KeysEnum.ENTER:
					if(!controller.isFocus()){
						controller.setFocus();
					}else if(controller.isFocus() && controller.hasContent()){
						controller.sendMsg();
					}else{
						stage.focus = null;
					}
					break;
				case KeysEnum.SPACE:
					if(controller.hasContent()){
						controller.checkContent();
					}
					break;
				case KeysEnum.UP:
					controller.prevContent();
					break;
				case KeysEnum.DOWN:
					controller.nextContent();
					break;
				default:
					break;
			}
		}
		
		/**
		 * <T>进入私聊</T>
		 * 
		 * @param name 私聊角色名称
		 * 
		 */		
		public function privateChat(playerName:String):void{
			controller.privateChat(playerName);
		}
		
		/**
		 * <T>生成一个道具超链接</T>
		 * 
		 * @param name 连接显示名
		 * @param tips 连接展示tips
		 * 
		 */		
		public function generateItemLink(name:String, tips:Object):void{
			var iLink:Object = ChatUtil.generateItemLink(name, tips);
			controller.pushLink(iLink);
//			controller.setFocus();
		}
		
		/**
		 * <T>生成一个地图超链接</T>
		 * 
		 * @param mapId 地图名称
		 * @param xx    横坐标
		 * @param yy    纵坐标
		 * 
		 */		
		public function generateMapLink(mapId:String, mapName:String, xx:int, yy:int):void{
			var mLink:Object = ChatUtil.generateMapLink(mapId, mapName, xx, yy);
			controller.pushLink(mLink);
//			controller.setFocus();
		}
		
		/**
		 * <T>激活聊天焦点</T>
		 * 
		 */		
		public function setFocus():void{
			controller.setFocus();
		}
		
		/**
		 * <T>接收聊天消息</T>
		 * 
		 * @param o 消息数据
		 * 
		 */		
		public function onSay(o:Object):void{
//						registerClassAlias("ChatContentInfo", ChatContentInfo)
			//			var chatContent:ChatContentInfo = ChatUtil.decode(o);
			//			var byteArray:ByteArray = new ByteArray();
			//			byteArray.writeObject(chatContent);
			//			trace(" ++++++++++++++++++++++++++++++++++++++++++++++++++++ onsay begin")
			//			var t:uint = getTimer();
			//			for(var n:int = 0; n < 50; n++){
			//				byteArray.position = 0;
			//				var content:ChatContentInfo = byteArray.readObject();
			//				controller.pushContent(content);
			//			}
			//			var inval:uint = getTimer() - t;
			//			trace(" ++++++++++++++++++++++++++++++++++++++++++++++++++++ onsay end :view chat content one handred cost||||--" + inval);
			//			trace("--------------------test begin");
			var chatContent:ChatContentInfo = ChatUtil.decode(o);
			controller.pushContent(chatContent);
			//			trace("--------------------test end");
			// 是否显示在聊天泡泡
			if(chatContent.isChanel(ChatEnum.CHANNEL_WORLD)){
				SceneUIManager.getInstance().addChat(chatContent.fromUserName,chatContent.nativeStr);
			}
		}
		
		public function chatNotice(content:String):void{
			var o:Object = {i:"", c:content};
			onSay(o);
		}
		
		/**
		 * <T>接收系统提示</T>
		 * 
		 * @param notice 提示数据
		 * 
		 */		
		public function onSysNotice(notice:TNoticeInfo, values:Array=null):void{
			var content:ChatContentInfo = ChatUtil.creatNotice(notice, values);
			controller.pushContent(content);
		}
		
		private var filterTool:TextField = new TextField();
		
		// 获得物品重要提示
		public function onSysNotice_II(obj:Object):void{
			if((null != Core.me) && (null != Core.me.info)){
				var content:ChatContentInfo = ChatUtil.creatNotice_II(obj);
				controller.pushContent(content);
				var msgId:int=obj.msgid;
				var noticeInfo:TNoticeInfo=TableManager.getInstance().getSystemNotice(obj.msgid);
				if((7 == noticeInfo.screenId1) || (7 == noticeInfo.screenId2) || (7 == noticeInfo.screenId3)){
					filterTool.htmlText = content.content.replace(content.channelName, "");
					var systemPostStr:String = filterTool.text;
					NoticeManager.getInstance().ass_II(7, systemPostStr);
				}
			}
		}
		
		/**
		 * <T>添加表情</T>
		 * 
		 * @param value 表情的KEY
		 * 
		 */		
		public function addFace(key:String):void{
			controller.addFace(key);
		}
		
		public function switchToAcross():void{
			controller.switchToAcross();
		}
		
		public function switchToNormal():void{
			controller.switchToNormal();
		}
		
		/**
		 * 反转聊天面板显示状态
		*/
		public function reversePanelVisible(v:Boolean):void{
			if(v){
				showBtn.visible = false;
				sprite.visible = true;
				controller.setVisible(true);
			}else{
				showBtn.visible = true;
				sprite.visible = false;
				controller.setVisible(false);
			}
		}
	}
}
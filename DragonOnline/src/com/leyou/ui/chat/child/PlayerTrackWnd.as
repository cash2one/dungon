package com.leyou.ui.chat.child
{
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.adobe.serialization.json.JSON;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.StyleSheet;
	
	public class PlayerTrackWnd extends AutoWindow implements IMenu 
	{
		private var trackBtn:NormalButton;
		private var findBtn:NormalButton;
		
		private var contentLbl:Label;
		
		private var currPlayer:String;
		private var menuArr:Vector.<MenuInfo>;
		
		private var mapId:String;
		private var mapX:int;
		private var mapY:int;
		
		public function PlayerTrackWnd(){
			super(LibManager.getInstance().getXML("config/ui/system/messagePanel.xml"));
			init();
		}
		
		private function init():void{
			trackBtn=getUIbyID("trackBtn") as NormalButton;
			findBtn=getUIbyID("findBtn") as NormalButton;
			contentLbl=getUIbyID("contentLbl") as Label;
//			contentLbl.x = 14;
//			contentLbl.y = 34;
			contentLbl.width = 212
			contentLbl.multiline = true;
			contentLbl.wordWrap = true;
//			var tf:TextFormat = contentLbl.defaultTextFormat;
//			tf.align = TextFormatAlign.CENTER;
//			contentLbl.defaultTextFormat = tf;
			trackBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			findBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
			contentLbl.addEventListener(TextEvent.LINK, linkHandler);
			contentLbl.mouseEnabled = true;
			var style:StyleSheet = new StyleSheet();
			style.setStyle("body", {leading:3});
			style.setStyle("a:hover", {color:"#ff0000"});
			contentLbl.styleSheet = style;
			
			menuArr=new Vector.<MenuInfo>();
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[3], ChatEnum.ADD_FRIEND));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[4], ChatEnum.ADD_BLACK));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE));
//			clsBtn.x += 5;
//			clsBtn.y += 18;
			hideBg();
		}
		
		protected function linkHandler(event:TextEvent):void{
			var content:String=event.text;
			var type:int=int(content.substring(0, content.indexOf("+")));
			var linkValue:String=content.substring(content.indexOf("{"), content.indexOf("}") + 1);
			var linkData:Object=null;
			switch (type) {
				case ChatEnum.LINK_TYPE_MAP:
					linkData=com.adobe.serialization.json.JSON.decode(linkValue);
					Core.me.gotoMap(new Point(linkData.x, linkData.y), linkData.id, true);
					break;
				case ChatEnum.LINK_TYPE_PLAYER:
					currPlayer=linkValue.substring(1, linkValue.length - 1);
					MenuManager.getInstance().show(menuArr, this);
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "findBtn":
					Core.me.gotoMap(new Point(mapX, mapY), mapId, true);
					break;
				case "trackBtn":
					Cmd_Go.cmGoPoint(int(mapId), mapX, mapY);
					if(!((MyInfoManager.getInstance().VipLastTransterCount > 0) || (null != MyInfoManager.getInstance().getBagItemByID(30102)))){
						UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
						UIManager.getInstance().quickBuyWnd.pushItem(30102, 30103);
					}
					break;
			}
		}
		
		public function updateInfo(content:String, $mapId:String, $x:int, $y:int):void{
			contentLbl.htmlText ="<body>"+content+"</body>";
			mapId = $mapId;
			mapX = $x;
			mapY = $y;
		}
		
		public function onMenuClick(index:int):void{
			switch (index) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, currPlayer);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(currPlayer);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(currPlayer);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(currPlayer);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(currPlayer);
					break;
				case ChatEnum.ADD_BLACK: // 拉黑
					Cmd_Friend.cm_FriendMsg_A(3, currPlayer);
					break;
				case ChatEnum.SUE: // 举报
					//					var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(9961);
					//					NoticeManager.getInstance().broadcast(notice);
					NoticeManager.getInstance().broadcastById(9961);
					break;
				case ChatEnum.COPY: // 复制
					System.setClipboard(currPlayer);
					break;
			}
			
		}
		
	}
}
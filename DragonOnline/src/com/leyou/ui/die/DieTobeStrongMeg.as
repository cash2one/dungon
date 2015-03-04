package com.leyou.ui.die
{
	import com.ace.ICommon.IMenu;
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class DieTobeStrongMeg extends Sprite implements IMenu
	{
		private var text:TextField;
		
		private var menuArr:Vector.<MenuInfo>;

		private var killName:String;
		
		public function DieTobeStrongMeg(){
			super();
			init();
		}
		
		private function init():void{
			var bg:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.getTextScaleInfo("PanelBgOut").imgUrl));
			bg.scale9Grid = FontEnum.getTextScaleInfo("PanelBgOut").rect;
			bg.setSize(320, 66);
			addChild(bg);
			text = new TextField();
			addChild(text);
			text.x = 5;
			text.y = 5;
			text.width = 320;
			text.height = 66;
			text.wordWrap = true;
			text.multiline = true;
			var tff:TextFormat = text.defaultTextFormat;
			tff.color = 0xB89B6F;
			tff.align = TextFormatAlign.LEFT;
			tff.leading = 3;
			text.defaultTextFormat = tff;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.addEventListener(TextEvent.LINK, onTextClick);
		}
		
		protected function onTextClick(event:TextEvent):void{
			if(null == menuArr){
				menuArr = new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			}
			killName = event.text;
			if(-1 != killName.indexOf(".")){
				MenuManager.getInstance().show(menuArr, this);
			}
		}
		
		public function updateinfo(content:String):void{
			text.htmlText = content;
		}
		
		/**
		 * <T>处理菜单的操作</T>
		 *
		 * @param idx 菜单索引
		 *
		 */
		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, killName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(killName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(killName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(killName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(killName);
					break;
			}
		}
	}
}
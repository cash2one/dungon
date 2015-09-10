package com.leyou.ui.friend {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.friend.child.Accordion;
	import com.leyou.utils.ChatUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.system.System;

	public class FriendView extends AutoWindow {

		private var addFriendBtn:ImgButton;
		
		protected var acc:Accordion;
		
		protected var menu1Vec:Vector.<MenuInfo>;
		
		protected var menu2Vec:Vector.<MenuInfo>;
		
		protected var menu3Vec:Vector.<MenuInfo>;

		public function FriendView() {
			super(LibManager.getInstance().getXML("config/ui/FriendWnd.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 *  
		 */
		private function init():void {
			// 生成功能小菜单
			menu1Vec = new Vector.<MenuInfo>();
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT, onChat));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS, onCheck));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM, onTeam));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[8], ChatEnum.REMOVE_FAIEND, removeFriendRequest));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[4], ChatEnum.ADD_BLACK, addBlackRequest));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD, addGuild));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY, copy));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[9], ChatEnum.TRACK, trackPlayer));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL, onDuel));
			menu1Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE, sue));
				
			menu2Vec = new Vector.<MenuInfo>();
			menu2Vec.push(new MenuInfo(PropUtils.getStringById(1711), 0, addFriendRequest));
			menu2Vec.push(new MenuInfo(PropUtils.getStringById(1712), 1, removeFriendRequest));
			menu2Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY, copy));
			menu2Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL, onDuel));
			menu2Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[9], ChatEnum.TRACK, trackPlayer));
			
			menu3Vec = new Vector.<MenuInfo>();
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT, onChat));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS, onCheck));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM, onTeam));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[3], ChatEnum.ADD_FRIEND, addFriendRequest));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[8], ChatEnum.REMOVE_FAIEND, removeFriendRequest));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD, addGuild));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY, copy));
			menu3Vec.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE, sue));
			
			// 添加按钮监听
			addFriendBtn = getUIbyID("addFriendBtn") as ImgButton;
			addFriendBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			// 生成显示结构
			acc = new Accordion(256, 443);
			acc.x = 25;
			acc.y = 52;
			addChild(acc);
			acc.addItem(PropUtils.getStringById(1713), "(0/100)", null, menu1Vec);
			acc.addItem(PropUtils.getStringById(1714), "(0/20)", null, menu2Vec);
			acc.addItem(PropUtils.getStringById(1715), "(0/20)", null, menu3Vec);
		}
		
		private function onDuel(info:FriendInfo):void{
			Cmd_Duel.cm_DUEL_T(info.name);
		}
		
		private function trackPlayer(info:FriendInfo):void{
			ChatUtil.trackPlayer(info.name);
		}
		
		private function sue(info:FriendInfo):void{
//			var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(9961);
//			NoticeManager.getInstance().broadcast(notice);
			NoticeManager.getInstance().broadcastById(9961);
		}
		
		private function copy(info:FriendInfo):void{
			System.setClipboard(info.name);
		}
		
		private function addGuild(info:FriendInfo):void{
			Cmd_Guild.cm_GuildInvite(info.name);
		}
		
		private function onTeam(info:FriendInfo):void{
			Cmd_Tm.cm_teamInvite(info.name);
		}
		
		private function onCheck(info:FriendInfo):void{
			UIManager.getInstance().otherPlayerWnd.showPanel(info.name);
		}
		
		private function onChat(info:FriendInfo):void{
			UIManager.getInstance().chatWnd.privateChat(info.name);
		}
		
		/**
		 * <T>按钮点击监听</T>
		 * 
		 */
		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "searchBtn":
					break;
				case "offlineBtn": //是否在线
					break;
				case "localBtn": //是否显示位置
					break;
				case "messageBtn":
					break;
				case "addFriendBtn":
					UIManager.getInstance().showWindow(WindowEnum.FRIEDN_ADD);
					break;
			}

		}
		
		/**
		 * <T>显示界面</T>
		 * 
		 */	
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
		}
		
		public override function get width():Number{
			return 310;
		}
		
		public override function get height():Number{
			return 526;
		}
		
		public override function hide():void{
			super.hide();
			UIManager.getInstance().hideWindow(WindowEnum.FRIEDN_ADD);
		}
		
		/**
		 * <T>社交角色加入黑名单</T>
		 * 
		 */	
		protected function addBlackRequest(info:FriendInfo):void{
		}
		
		/**
		 * <T>请求添加社交角色</T>
		 * 
		 */	
		protected function addFriendRequest(info:FriendInfo):void{
		}
		
		/**
		 * <T>请求删除社交角色</T>
		 * 
		 */	
		protected function removeFriendRequest(info:FriendInfo):void{
		}
	}
}

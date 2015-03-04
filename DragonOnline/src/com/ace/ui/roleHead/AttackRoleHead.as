package com.ace.ui.roleHead
{
	import com.ace.ICommon.IMenu;
	import com.ace.enum.EventEnum;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class AttackRoleHead extends AutoSprite implements IMenu
	{
		private var userheadImg:Image;
		
		private var lookBtn:ImgButton;
		
		private var closeBtn:ImgButton;
		
		private var nameLbl:Label;
		
		private var attLbl:Label;
		
		private var info:LivingInfo;
		
		private var menuInfo:Vector.<MenuInfo>;
		
		public function AttackRoleHead(){
			super(LibManager.getInstance().getXML("config/ui/scene/OtherHeadWnd2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			mouseEnabled = true;
			userheadImg = getUIbyID("userheadImg") as Image;
			lookBtn = getUIbyID("lookBtn") as ImgButton;
			closeBtn = getUIbyID("closeBtn") as ImgButton;
			nameLbl = getUIbyID("nameLbl") as Label;
			attLbl = getUIbyID("attLbl") as Label;
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lookBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			EventManager.getInstance().addEvent(EventEnum.ON_HURT_WARNING, onAttack);
			visible = false;
		}
		
		private function onAttack(living:LivingModel):void{
			if(null == living){
				return;
			}
			info = living.info;
			nameLbl.text=info.name+"[lv"+info.level+"]";
			userheadImg.updateBmp(PlayerUtil.getPlayerHeadImg(info.profession, info.sex));
			show();
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			event.stopImmediatePropagation();
			switch(event.target.name){
				case "closeBtn":
					hide();
					info = null;
					EventManager.getInstance().dispatchEvent(EventEnum.CANCEL_HURT_WARNING);
					break;
				case "lookBtn":
					if (null == menuInfo) {
						menuInfo=new Vector.<MenuInfo>();
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[3], ChatEnum.ADD_FRIEND));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[4], ChatEnum.ADD_BLACK));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY));
						menuInfo.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE));
					}
					MenuManager.getInstance().show(menuInfo, this);
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null != info){
				EventManager.getInstance().dispatchEvent(EventEnum.SELECT_HURT_WARNING, info.name);
			}
		}
		
		public function onMenuClick(index:int):void {
			if(null == info){
				return;
			}
			var currPlayer:String = info.name;
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
		
		public function resize():void{
			this.x=UIManager.getInstance().toolsWnd.x + 485;
			this.y=UIManager.getInstance().toolsWnd.y - 40;
		}
	}
}
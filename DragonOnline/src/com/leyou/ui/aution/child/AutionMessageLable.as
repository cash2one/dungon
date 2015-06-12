package com.leyou.ui.aution.child {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.TextEvent;
	import flash.geom.Point;

	public class AutionMessageLable extends AutoSprite implements IMenu {

		private static const sellTpl:String=PropUtils.getStringById(1613) + "<Font face='SimSun' size='12' color='#ffd700'>{5}{6}</Font>";

		private static const buyTpl:String=PropUtils.getStringById(1614) + "<Font face='SimSun' size='12' color='#ffd700'>{5}{6}</Font>";

		private static const cancelTpl:String=PropUtils.getStringById(1615);

		private static const confirmTpl:String=PropUtils.getStringById(2145);

		private var msgLbl:TextArea;
		private var grid:AutionSaleItemGrid;
		private var dataLink:AutionItemData;
		private var playerName:String;
		private var bgImg:Image;
		private var menuArr:Vector.<MenuInfo>;

		public function AutionMessageLable() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionMessageLable.xml"));
			this.init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			this.mouseEnabled=true;
			this.mouseChildren=true;
			this.msgLbl=this.getUIbyID("msgLbl") as TextArea;
			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.msgLbl.visibleOfBg=false;
			this.grid=new AutionSaleItemGrid();
			this.grid.mouseEnabled=false;
			this.grid.mouseChildren=false;
			this.grid.setType(ItemEnum.TYPE_GRID_AUTIONBUY);
			this.addChild(this.grid);
			this.msgLbl.addEventListener(TextEvent.LINK, onTextLink);
			menuArr=new Vector.<MenuInfo>();
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
		}

		/**
		 * <T>超链接点击</T>
		 *
		 * @param event 连接事件
		 *
		 */
		protected function onTextLink(event:TextEvent):void {
			playerName=event.text;
			MenuManager.getInstance().show(menuArr, this);
		}

		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, playerName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(playerName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(playerName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(playerName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(playerName);
					break;
			}
		}

		/**
		 * <T>更新显示信息</T>
		 *
		 * @param data 数据
		 *
		 */
		public function updateInfo(data:AutionItemData):void {
			dataLink=data;
			grid.updataInfo(data);
			var content:String;
			switch (dataLink.operate) {
				case 2:
					content=StringUtil_II.translate(cancelTpl, data.tick, /*StringUtil.addEventString(*/ data.itemName /*, data.itemName, true)*/, data.itemCount);
					break;
				case 1:
					content=StringUtil_II.translate(confirmTpl, data.tick, /*StringUtil.addEventString(*/ data.itemName /*, data.itemName, true)*/, data.itemCount);
					break;
				case 3:
					if (Core.me.info.name == dataLink.sellerName) {
						content=StringUtil_II.translate(sellTpl, data.tick, StringUtil_II.addEventString(data.buyName, data.buyName, true), /*StringUtil.addEventString("itemName", */ data.itemName /*, true)*/, data.itemCount, ItemUtil.parseCurrencyStr(data.moneyType), data.price);
					} else {
						content=StringUtil_II.translate(buyTpl, data.tick, StringUtil_II.addEventString(data.sellerName, data.sellerName, true), /*StringUtil.addEventString("itemName", */ data.itemName /*, true)*/, data.itemCount, ItemUtil.parseCurrencyStr(data.moneyType), data.price);
					}
					break;
			}
			msgLbl.setHtmlText(content);
		}

		/**
		 * <T>设置背景图</T>
		 *
		 * @param id 所在列表编号
		 *
		 */
		public function setBackGround(id:int):void {
			var path:String=((id & 1) == 0) ? "ui/aution/sale_log_bg_03.png" : "ui/aution/sale_log_bg_05.png";
			bgImg.updateBmp(path);
		}

		/**
		 * <T>清理供下次使用</T>
		 *
		 */
		public function clear():void {
			dataLink=null;
			grid.clear();
		}
	}
}

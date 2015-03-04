package com.leyou.ui.aution.child {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.utils.StringUtil;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	public class AutionBuyItemLable extends AutoSprite  implements IMenu{
		
		private var nameLbl:Label;
		private var playnameLbl:Label;
		private var lvLbl:Label;
		private var goinLbl:Label;
		private var buyBtn:ImgLabelButton;
		private var grid:AutionSaleItemGrid;
		private var moneyImg:Image;
		private var belongPage:int;
		
		private var moneyType:int;
		public var dataLink:AutionItemData;
		private var bgImg:Object;
		private var playerName:String;

		private var menuArr:Vector.<MenuInfo>;
		
		public function AutionBuyItemLable() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionBuyItemLable.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			mouseChildren = true;
			mouseEnabled = true;
			nameLbl = getUIbyID("nameLbl") as Label;
			playnameLbl = getUIbyID("playnameLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			goinLbl = getUIbyID("goinLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as ImgLabelButton;
			moneyImg = getUIbyID("moneyImg") as Image;
			bgImg = getUIbyID("bgImg") as Image;
			grid = new AutionSaleItemGrid();
			grid.setType(ItemEnum.TYPE_GRID_AUTIONBUY);
			addChild(grid);
			buyBtn.addEventListener(MouseEvent.CLICK, onButtonClick)
			playnameLbl.mouseEnabled = true;
			playnameLbl.addEventListener(TextEvent.LINK, onTextClick);
		}
		
		/**
		 * <T>玩家名点击</T>
		 * 
		 * @param event 点击事件
		 * 
		 */		
		protected function onTextClick(event:TextEvent):void{
			playerName = event.text;
			if(null == menuArr){
				menuArr = new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			}
			MenuManager.getInstance().show(menuArr, this);
		}
		
		
		public function onMenuClick(idx:int):void{
			switch (idx) {
				case ChatEnum.ADD_FRIEND:   //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, playerName);
					break;
				case ChatEnum.ADD_GUILD:    //邀请入帮
					Cmd_Guild.cm_GuildInvite(playerName);
					break;
				case ChatEnum.ADD_TEAM:     //邀请入队
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
		 * <T>设置背景图</T>
		 * 
		 * @param id 所在列表编号
		 * 
		 */
		public function setBackGround(id:int):void{
			var path:String = ((id&1) == 0) ? "ui/aution/sale_log_bg_04.png" : "ui/aution/sale_log_bg_06.png";
			bgImg.updateBmp(path);
		}
		
		/**
		 * <T>购买按钮点击监听<T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onButtonClick(evt:MouseEvent):void {
//			this.buyWnd = new BuyWnd();
//			this.buyWnd.setKeepMode(false);
//			this.buyWnd.updateAution(dataLink);
//			LayerManager.getInstance().addPopWnd(true, this.buyWnd);
//			this.buyWnd.show();
			if(2 == dataLink.moneyType){
				var content:String = TableManager.getInstance().getSystemNotice(1914).content;
				content = com.ace.utils.StringUtil.substitute(content, goinLbl.text, nameLbl.text);
				PopupManager.showConfirm(content, buyCall, null, false, "aution.buy,confirm");
//				var wnd:WindInfo = WindInfo.getConfirmInfo(content, buyCall);
//				PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, wnd, "aution.buy,confirm");
			}else{
				Cmd_Aution.cm_Aution_B(dataLink.id, belongPage);
			}
		}
		
		private function buyCall():void{
			Cmd_Aution.cm_Aution_B(dataLink.id, belongPage);
		}
		
		/**
		 * <T>更新信息</T>
		 * 
		 * @param data 数据信息
		 * 
		 */		
		public function updateInfo(data:AutionItemData, page:int):void {
			belongPage = page;
			dataLink = data;
			var dataId:uint = (0 == dataLink.itemId) ? 65535 : dataLink.itemId;
			var color:uint;
			// 找到物品信息
			var info:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null == info){
				info = TableManager.getInstance().getEquipInfo(dataId);
			}
			var n:String = info.name;
			n = (65535 == dataId) ? ""+n+data.itemCount : ""+n;
			color = ItemUtil.getColorByQuality(parseInt(info.quality));
			nameLbl.htmlText = "<Font face='SimSun' size = '12' color='#"+ color.toString(16).replace("0x") + "'>" + n + "</Font>";
			var tagText:String = com.leyou.utils.StringUtil_II.addEventString(data.sellerName, data.sellerName, true);
			playnameLbl.htmlText = com.leyou.utils.StringUtil_II.getColorStr(tagText, ChatEnum.COLOR_USER);
			if(65535 == dataId){
				lvLbl.text = "1";
			}else{
				lvLbl.text = data.level+"";
			}
			goinLbl.text = com.leyou.utils.StringUtil_II.sertSign(data.price);
//			buyBtn.visible = Boolean(data);
			
			var sourcePath:String = ItemUtil.getExchangeIcon(data.moneyType)
			moneyImg.updateBmp(sourcePath);
			grid.updataInfo(data);
		}
		
	}
}

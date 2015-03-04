package com.leyou.ui.guild.child {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guild;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildShop extends AutoSprite {

		private var fullRd:RadioButton;
		private var equipRd:RadioButton;
		private var itemRd:RadioButton;
		private var otherRd:RadioButton;

		private var shoprender:ScrollPane;

		private var onBuyCb:CheckBox;

		private var shopbarVec:Vector.<GuildShopBar>;

		private var selectIndex:int=-1;

		/**
		 *选择的 类别
		 */
		private var selectType:Array=[];

		public function GuildShop() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildShop.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.fullRd=this.getUIbyID("fullRd") as RadioButton;
			this.equipRd=this.getUIbyID("equipRd") as RadioButton;
			this.itemRd=this.getUIbyID("itemRd") as RadioButton;
			this.otherRd=this.getUIbyID("otherRd") as RadioButton;

			this.shoprender=this.getUIbyID("shoprender") as ScrollPane;
			this.onBuyCb=this.getUIbyID("onBuyCb") as CheckBox;

			this.fullRd.addEventListener(MouseEvent.CLICK, onClick);
			this.equipRd.addEventListener(MouseEvent.CLICK, onClick);
			this.itemRd.addEventListener(MouseEvent.CLICK, onClick);
			this.otherRd.addEventListener(MouseEvent.CLICK, onClick);

			this.shoprender.addEventListener(MouseEvent.CLICK, onItemClick);
			this.shoprender.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.shoprender.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			this.shoprender.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.onBuyCb.addEventListener(MouseEvent.CLICK, onClick);
			this.shopbarVec=new Vector.<GuildShopBar>();

			this.y+=5;
			this.x=-13;
		}

		/**
		 *更新事件调用
		 */
		public function updateData():void {
			this.fullRd.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		private function onItemClick(e:MouseEvent):void {
			if (e.target is GuildShopBar || e.target is GuildShopGrid) {

				var sbar:GuildShopBar;

				if (e.target is GuildShopBar)
					sbar=GuildShopBar(e.target);
				else
					sbar=GuildShopBar(e.target.parent);

				if (sbar.infoXml.@Shop_Level > UIManager.getInstance().guildWnd.guildLv) {
//					trace(GuildShopBar(e.target).infoXml.@Shop_Level, UIManager.getInstance().guildWnd.guildLv, GuildShopBar(e.target).infoXml.@Shop_Level > UIManager.getInstance().guildWnd.guildLv);
					return;
				}

				UIManager.getInstance().buyWnd.show();
				UIManager.getInstance().buyWnd.updateGuild(sbar.infoXml);
			}
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "fullRd":
					this.selectType=[0];
					this.updateInfo();
					break;
				case "equipRd":
					this.selectType=[3];
					this.updateInfo();
					break;
				case "itemRd":
					this.selectType=[2];
					this.updateInfo();
					break;
				case "otherRd":
					this.selectType=[1];
					this.updateInfo();
					break;
				case "onBuyCb":
					this.updateInfo();
					break;
			}

		}

		private function onMouseOver(e:MouseEvent):void {

			if (e.target is GuildShopBar || e.target is GuildShopGrid) {

				var gs:GuildShopBar;

				if (e.target is GuildShopBar)
					gs=GuildShopBar(e.target);
				else if (e.target is GuildShopGrid)
					gs=e.target.parent;

				gs.hight=true;

				gs.tipsInfo.moneyType=ItemEnum.CURRENCY_TYPE_GUILD_MONEY;
				gs.tipsInfo.moneyNum=gs.getPrice();

				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, gs.tipsInfo, new Point(e.stageX, e.stageY));
			}

			e.stopImmediatePropagation();
		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is GuildShopBar) {
				if (selectIndex != this.shopbarVec.indexOf(e.target as GuildShopBar))
					GuildShopBar(e.target).hight=false;
			}

		}

		public function updateInfo():void {

			var shopbar:GuildShopBar;
			for each (shopbar in this.shopbarVec) {
				this.shoprender.delFromPane(shopbar);
			}

			var xml:XML=LibManager.getInstance().getXML("config/table/Union_Shop.xml");

			var xmllist:XMLList=xml.data;
			var xmlInfo:XML;

			this.shopbarVec.length=0;

			for (var i:int=0; i < xmllist.length(); i++) {

				if (selectType[0] != 0 && selectType.indexOf(int(xmllist[i].@U_TagID)) == -1)
					continue;

				if (this.onBuyCb.isOn && UIManager.getInstance().guildWnd != null && int(xmllist[i].@Shop_Level) > UIManager.getInstance().guildWnd.guildLv)
					continue;

				shopbar=new GuildShopBar();
				shopbar.updateInfo(xmllist[i]);

				shopbar.x=int(this.shopbarVec.length % 3) * (195);
				shopbar.y=int(this.shopbarVec.length / 3) * (78);

				this.shoprender.addToPane(shopbar);
				this.shopbarVec.push(shopbar);
			}

			this.shoprender.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.shoprender.updateUI, "updateUI", 4);
		}


	}
}

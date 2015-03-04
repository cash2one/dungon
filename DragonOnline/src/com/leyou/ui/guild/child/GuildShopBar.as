package com.leyou.ui.guild.child {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ItemUtil;

	public class GuildShopBar extends AutoSprite {

		private var nameLbl:Label;
		private var priceLbl:Label;
		private var moneyLbl:Label;

		private var moneyImg:Image;
		private var priceImg:Image;

		private var itemBg:Image;

		private var grid:GuildShopGrid;

		public var itemid:int=-1;
		public var infoXml:XML;
		
		public var tipsInfo:TipsInfo;

		public function GuildShopBar() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildShopBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;

			this.moneyImg=this.getUIbyID("moneyImg") as Image;
			this.priceImg=this.getUIbyID("priceImg") as Image;
			this.itemBg=this.getUIbyID("itemBg") as Image;
			
			this.tipsInfo=new TipsInfo();
			
			this.grid=new GuildShopGrid();
			this.addChild(this.grid);

			this.grid.x=15;
			this.grid.y=19;
		}

		/**
		 *<data Shop_Level="3" U_TagID="3" U_TagName="装备" U_ItemID="4901" U_LPrice="1100" U_DPrice="550"/>
		 * @param xml
		 */
		public function updateInfo(xml:XML):void {

			if (xml == null)
				return;

			this.infoXml=xml;
			this.itemid=xml.@U_ItemID;

			this.tipsInfo.itemid=this.itemid;
			
			var info:Object;
//			if (xml.@U_TagID == 3)
//				info=TableManager.getInstance().getEquipInfo(this.itemid);
//			else
				info=TableManager.getInstance().getItemInfo(this.itemid);

			if(info==null)
				return ;
			
			this.grid.updataInfo(info);
			this.grid.canMove=false;
			
			this.nameLbl.text="" + info.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(info.quality);
			
			this.priceLbl.text="" + xml.@U_LPrice;

			if (UIManager.getInstance().guildWnd != null && int(xml.@Shop_Level) > UIManager.getInstance().guildWnd.guildLv)
				this.grid.hight=true;
			else
				this.grid.hight=false;

		}

		public function getPrice():int {
			return int(this.priceLbl.text);
		}

		public function set hight(v:Boolean):void {
			if (v)
				this.itemBg.updateBmp("ui/guild/guild_shop_bg_1.jpg");
			else
				this.itemBg.updateBmp("ui/guild/guild_shop_bg_0.jpg");
		}

	}
}

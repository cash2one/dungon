package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.monsterInvade.child.MonsterInvadeGrid;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.StringUtil_II;

	public class BuyBuffWnd extends AutoSprite implements ITip {

		private var nameLbl:Label;
		private var descLbl:Label;
		private var getFunLbl:Label;
		private var moneyNameLbl:Label;
		private var priceLbl:Label;

		private var grid:MonsterInvadeGrid;
		
		public function BuyBuffWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/buyBuffWnd.xml"));
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label
			this.descLbl=this.getUIbyID("descLbl") as Label
			this.getFunLbl=this.getUIbyID("getFunLbl") as Label
			this.moneyNameLbl=this.getUIbyID("moneyNameLbl") as Label
			this.priceLbl=this.getUIbyID("priceLbl") as Label

			this.grid=new MonsterInvadeGrid();
			this.addChild(this.grid);
			
			this.grid.x=13;
			this.grid.y=13;
			
		}

		public function updateInfo(tips:Object):void {

			var tipsinfo:TipsInfo=tips as TipsInfo;
			var buff:TBuffInfo=TableManager.getInstance().getBuffInfo(tipsinfo.itemid);

			if (buff!=null && buff.id == ConfigEnum.DemonInvasion4) {
				
				this.grid.updataInfo(buff);
				this.nameLbl.text=""+buff.name;
				this.descLbl.text=""+buff.des;
				this.priceLbl.text=""+ConfigEnum.DemonInvasion6;
				this.moneyNameLbl.text="购买价格:";
				this.getFunLbl.text=""+StringUtil_II.getBreakLineStringByCharIndex(TableManager.getInstance().getSystemNotice(9936).content);
			}



		}

		public function get isFirst():Boolean {
			// TODO Auto Generated method stub
			return false;
		}
	}
}

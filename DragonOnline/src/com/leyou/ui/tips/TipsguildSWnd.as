package com.leyou.ui.tips {


	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	public class TipsguildSWnd extends AutoSprite implements ITip {

		private var iconImg:Image;
		private var priceLbl:Label;
		private var lockLbl:Label;
		private var value1Lbl:Label;
		private var key1Lbl:Label;
		private var valueLbl:Label;
		private var keyLbl:Label;
		private var lvLbl:Label;
		private var nameLbl:Label;

		private var moneyNameLbl:Label;
		private var bgLbl:Label;
		private var moneyIco:Image;
		private var bgico:Image;

		public function TipsguildSWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsguildSWnd.xml"));
			this.init();
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;
			this.lockLbl=this.getUIbyID("lockLbl") as Label;
			this.value1Lbl=this.getUIbyID("value1Lbl") as Label;
			this.key1Lbl=this.getUIbyID("key1Lbl") as Label;
			this.valueLbl=this.getUIbyID("valueLbl") as Label;
			this.keyLbl=this.getUIbyID("keyLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.moneyNameLbl=this.getUIbyID("moneyNameLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;
			this.moneyIco=this.getUIbyID("moneyIco") as Image;
			this.bgico=this.getUIbyID("bgico") as Image;
		}

		public function updateInfo(tips:Object):void {
			var info:TUnion_attribute=tips as TUnion_attribute;

			this.iconImg.fillEmptyBmd();
			this.iconImg.updateBmp("ico/skills/" + info.ico + ".png");
			this.nameLbl.text=info.name + "";
			this.lvLbl.text=info.lv + "";
			this.keyLbl.text=PropUtils.prop2Arr[int(info.att) - 1] + ":";
			this.valueLbl.text=info.uAtt + "";

			var info1:TUnion_attribute=TableManager.getInstance().getguildAttributeNextInfo(info.att, info.lv);

			if (info1 == null) {
				this.lockLbl.text="";
				this.key1Lbl.text="";
				this.value1Lbl.text="";
				this.priceLbl.text="";
				this.bgLbl.text="";
				
				this.moneyNameLbl.visible=false;
				this.moneyIco.visible=false;
				this.bgico.visible=false;
				return;
			}

			if (UIManager.getInstance().guildWnd.guildLv < info1.uLv)
				this.lockLbl.text="行会" + info1.uLv + "级解锁";
			else
				this.lockLbl.text="";

			this.key1Lbl.text=PropUtils.prop2Arr[int(info1.att) - 1] + ":";
			this.value1Lbl.text=info1.uAtt + "";

			this.priceLbl.text=info1.uMoney + "";
			this.bgLbl.text=info1.uCon + "";

			this.moneyNameLbl.visible=true;
			this.moneyIco.visible=true;
			this.bgico.visible=true;
		}

		public function get isFirst():Boolean {

			return false;
		}

	}
}

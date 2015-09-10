package com.leyou.ui.tips {


	import com.ace.ICommon.ITip;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_Bless;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.utils.PropUtils;

	public class GuildSciTips extends AutoSprite implements ITip {

		private var nameLbl:Label;
		private var bgImg:Image;
		private var changeCostLbl:Label;
		private var lockTxtLbl:Label;
		private var lockLvLbl:Label;
		private var upgradeCostLbl:Label;
		private var upgradeTimeLbl:Label;
		private var getPropLbl:Label;
		private var lvLbl:Label;

		public function GuildSciTips() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSciTips.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.changeCostLbl=this.getUIbyID("changeCostLbl") as Label;
			this.lockTxtLbl=this.getUIbyID("lockTxtLbl") as Label;
			this.lockLvLbl=this.getUIbyID("lockLvLbl") as Label;
			this.upgradeCostLbl=this.getUIbyID("upgradeCostLbl") as Label;
			this.upgradeTimeLbl=this.getUIbyID("upgradeTimeLbl") as Label;
			this.getPropLbl=this.getUIbyID("getPropLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;

		}

		public function updateInfo(o:Object):void {

			var tbless:TUnion_Bless=TableManager.getInstance().getGuildblessByID(o as int);

			this.nameLbl.text="" + tbless.build_Name;
			this.bgImg.updateBmp("ui/guild/" + tbless.build_Pic);


			this.changeCostLbl.text="" + tbless.Buff_Spend

			this.lvLbl.text="" + tbless.build_Lv;

			if (tbless.build_Lv > UIManager.getInstance().guildWnd.guildLv) {
//				this.lockTxtLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
//				this.lockLvLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");

				this.lockLvLbl.textColor=0xff0000;
				this.lockTxtLbl.textColor=0xff0000;

			} else {

//				this.lockLvLbl.defaultTextFormat=FontEnum.getTextFormat("White12");
//				this.lockTxtLbl.defaultTextFormat=FontEnum.getTextFormat("White12");

				this.lockLvLbl.textColor=0xffffff;
				this.lockTxtLbl.textColor=0xffffff;
			}

			this.upgradeCostLbl.text="" + tbless.Upgrade_at;
			this.upgradeTimeLbl.text="" + Math.floor(tbless.Upgrade_Time / 60 / 60)+PropUtils.getStringById(2062);

			this.getPropLbl.text="" + TableManager.getInstance().getBuffInfo(tbless.build_Buff).des;

			this.lockLvLbl.text=StringUtil.substitute(PropUtils.getStringById(2190), [UIManager.getInstance().guildWnd.guildLv]) + "";


		}

		public function get isFirst():Boolean {
			// TODO Auto Generated method stub
			return false;
		}

	}
}

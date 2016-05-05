package com.leyou.ui.tips {
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPassivitySkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.vip.TipVipSkillInfo;
	import com.leyou.utils.PropUtils;

	public class TipsVipSkillTip extends AutoSprite implements ITip {
		private var nameLbl:Label;

		private var cdLbl:Label;

		private var openLevelLbl:Label;

		private var desLbl:Label;

		private var icoImg:Image;

		public function TipsVipSkillTip() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsVipSkillWnd.xml"));
			init();
		}

		public function init():void {
			nameLbl=getUIbyID("nameLbl") as Label;
			cdLbl=getUIbyID("cdLbl") as Label;
			openLevelLbl=getUIbyID("openLevelLbl") as Label;
			desLbl=getUIbyID("desLbl") as Label;
			icoImg=new Image();
			icoImg.x=12;
			icoImg.y=12;
			addChild(icoImg);
			desLbl.multiline=true;
			desLbl.wordWrap=true;
		}

		public function updateInfo(info:Object):void {
			var tipInfo:TipVipSkillInfo=info as TipVipSkillInfo;
			var skillId:int=info.skillId;
			var tInfo:TPassivitySkillInfo=TableManager.getInstance().getPassiveSkill(skillId);
			nameLbl.text=tInfo.name;
			cdLbl.text=tInfo.cd / 1000 + PropUtils.getStringById(2146);
			desLbl.htmlText=tInfo.des;
			openLevelLbl.text="VIP" + tInfo.openLv + PropUtils.getStringById(1953)
			icoImg.updateBmp("ico/skills/" + tInfo.ico, null, false, 64, 64);
			openLevelLbl.visible=!tipInfo.isOpen;
		}

		public function get isFirst():Boolean {
			return false;
		}
	}
}

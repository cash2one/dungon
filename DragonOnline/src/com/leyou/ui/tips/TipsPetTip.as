package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	
	public class TipsPetTip extends AutoSprite implements ITip
	{
		private var nameLbl:Label;
		
		private var reviveTimeLbl:Label;
		
		private var increaseLbl:Label;
		
		private var callSkillLbl:Label;
		
		private var raceSkillLbl:Label;
		
		private var callSkillDesLbl:Label;
		
		private var raceSkillDesLbl:Label;
		
		private var raceSkillTitleLbl:Label;
		
		private var autofightLbl:Label;
		
		private var bgImg:ScaleBitmap;
		
		public function TipsPetTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/TipsServentWnd.xml"));
			init();
		}
		
		private function init():void{
			bgImg = getUIbyID("bg") as ScaleBitmap;
			nameLbl = getUIbyID("nameLbl") as Label;
			reviveTimeLbl = getUIbyID("reviveTimeLbl") as Label;
			increaseLbl = getUIbyID("increaseLbl") as Label;
			callSkillLbl = getUIbyID("callSkillLbl") as Label;
			raceSkillLbl = getUIbyID("raceSkillLbl") as Label;
			callSkillDesLbl = getUIbyID("callSkillDesLbl") as Label;
			raceSkillDesLbl = getUIbyID("raceSkillDesLbl") as Label;
			raceSkillTitleLbl = getUIbyID("raceSkillTitleLbl") as Label;
			autofightLbl = getUIbyID("autofightLbl") as Label;
			
			callSkillDesLbl.wordWrap=true;
			callSkillDesLbl.multiline=true;
			
			raceSkillDesLbl.wordWrap=true;
			raceSkillDesLbl.multiline=true;
		}
		
		public function get isFirst():Boolean{
			return false;
		}
		
		public function updateInfo(info:Object):void{
			var petId:int = info as int;
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petId);
			var petData:PetEntryData = DataManager.getInstance().petData.getPetById(petId);
			var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(petData.starLv, petData.level);
			var petStarInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petId, petData.starLv);
			nameLbl.text = StringUtil.substitute("{1}({2}{3})",petInfo.name, petData.level, PropUtils.getStringById(1812));
			reviveTimeLbl.text = (petStarInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			increaseLbl.text = ""+int(ZDLUtil.computation(petInfo.hp, 0, petInfo.phyAtt, petInfo.phyDef, petInfo.magicAtt, petInfo.magicDef, petInfo.crit, petInfo.tenacity, petInfo.hit, petInfo.dodge, petInfo.slay, petInfo.guard, petInfo.fixedAtt, petInfo.fixedDef)*Math.pow((10000 + ConfigEnum.servent20)/10000, (petData.qmdLv-1)));
			
			var skillInfo:TSkillInfo = TableManager.getInstance().getSkillById(petInfo.skill1);
			callSkillLbl.text = skillInfo.name;
			callSkillDesLbl.htmlText = skillInfo.des;
			
			raceSkillTitleLbl.y = callSkillDesLbl.y + callSkillDesLbl.height;
			raceSkillLbl.y = raceSkillTitleLbl.y;
			autofightLbl.y = raceSkillTitleLbl.y;
			raceSkillDesLbl.y = raceSkillTitleLbl.y + raceSkillTitleLbl.height;
			
			skillInfo = TableManager.getInstance().getSkillById(petInfo.raceSkill);
			raceSkillLbl.text = skillInfo.name;
			raceSkillDesLbl.htmlText = skillInfo.des;
			
			bgImg.setSize(bgImg.width, raceSkillDesLbl.y + raceSkillDesLbl.height + 10);
		}
	}
}
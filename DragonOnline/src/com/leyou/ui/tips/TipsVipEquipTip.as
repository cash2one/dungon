package com.leyou.ui.tips {
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.vip.TipVipEquipInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;

	public class TipsVipEquipTip extends AutoSprite implements ITip {
		
		private var nameLbl:Label;
		private var num:RollNumWidget;
		private var movie:SwfLoader;

		private var currentLvLbl:Label;
		private var nextLvLbl:Label;
		
		private var propertyList:Vector.<Label>;
		private var propertyVList:Vector.<Label>;
		private var propertyNList:Vector.<Label>;
		private var propertyNVList:Vector.<Label>;
		
		private var fightingLbl:Label;
		private var currentfightLbl:Label;
		
		private var nfightingLbl:Label;
		private var nextfightLbl:Label;
		private var fightlineImg:Image;
		
		private var passivityLabel:Label;
		private var skillName1:Label;
		private var skill1Lbl:Label;
		private var fightlineImg0:Image;
		
		private var passivityLabel0:Label;
		private var passivityLabel1:Label;
		private var skillName2:Label;
		private var skill2Lbl:Label;
		private var desclineImg:Image;
		
		private var desLbl:Label;
		private var bgSc:ScaleBitmap;
		
		public function TipsVipEquipTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/TipsVipEquipWnd.xml"));
			init();
		}

		private function init():void {
			num=new RollNumWidget();
			num.loadSource("ui/num/{num}_lzs.png");
			num.x=90;
			num.y=91;
			addChild(num);
			movie=new SwfLoader();
			movie.x=41;
			movie.y=110 + 51;
			addChild(movie);
			
			bgSc = getUIbyID("bgSc") as ScaleBitmap;
			nameLbl = getUIbyID("nameLbl") as Label;
			currentLvLbl = getUIbyID("currentLvLbl") as Label;
			nextLvLbl = getUIbyID("nextLvLbl") as Label;
			
			propertyList = new Vector.<Label>();
			propertyVList = new Vector.<Label>();
			propertyNList = new Vector.<Label>();
			propertyNVList = new Vector.<Label>();
			
			propertyList.push(getUIbyID("hpTLbl"));
			propertyVList.push(getUIbyID("bloodLbl"));
			propertyNList.push(getUIbyID("nbloodTLbl"));
			propertyNVList.push(getUIbyID("nbloodLbl"));
			
			propertyList.push(getUIbyID("attTLbl"));
			propertyVList.push(getUIbyID("phyAttLbl"));
			propertyNList.push(getUIbyID("nattTLbl"));
			propertyNVList.push(getUIbyID("nphyAttLbl"));
			
			propertyList.push(getUIbyID("defTLbl"));
			propertyVList.push(getUIbyID("phyDefLbl"));
			propertyNList.push(getUIbyID("ndefTLbl"));
			propertyNVList.push(getUIbyID("nphyDefLbl"));
			
			propertyList.push(getUIbyID("critTLbl"));
			propertyVList.push(getUIbyID("critLbl"));
			propertyNList.push(getUIbyID("ncritTLbl"));
			propertyNVList.push(getUIbyID("ncritLbl"));
			
			propertyList.push(getUIbyID("tenacityTLbl"));
			propertyVList.push(getUIbyID("tenacityLbl"));
			propertyNList.push(getUIbyID("ntenacityTLbl"));
			propertyNVList.push(getUIbyID("ntenacityLbl"));
			
			propertyList.push(getUIbyID("hitTLbl"));
			propertyVList.push(getUIbyID("hitLbl"));
			propertyNList.push(getUIbyID("nhitTLbl"));
			propertyNVList.push(getUIbyID("nhitLbl"));
			
			propertyList.push(getUIbyID("dodgeTLbl"));
			propertyVList.push(getUIbyID("dodgeLbl"));
			propertyNList.push(getUIbyID("ndodgeTLbl"));
			propertyNVList.push(getUIbyID("ndodgeLbl"));
			
			fightingLbl = getUIbyID("fightingLbl") as Label;
			currentfightLbl = getUIbyID("currentfightLbl") as Label;
			nfightingLbl = getUIbyID("nfightingLbl") as Label;
			fightingLbl = getUIbyID("fightingLbl") as Label;
			nextfightLbl = getUIbyID("nextfightLbl") as Label;
			nextfightLbl = getUIbyID("nextfightLbl") as Label;
			fightlineImg = getUIbyID("fightlineImg") as Image;
			passivityLabel = getUIbyID("passivityLabel") as Label;
			skillName1 = getUIbyID("skillName1") as Label;
			skill1Lbl = getUIbyID("skill1Lbl") as Label;
			fightlineImg0 = getUIbyID("fightlineImg0") as Image;
			passivityLabel0 = getUIbyID("passivityLabel0") as Label;
			passivityLabel1 = getUIbyID("passivityLabel1") as Label;
			skillName2 = getUIbyID("skillName2") as Label;
			skill2Lbl = getUIbyID("skill2Lbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			desclineImg = getUIbyID("desclineImg") as Image;
			
			desLbl.multiline = true;
			desLbl.wordWrap = true;
			
			skill1Lbl.wordWrap=true;
			skill1Lbl.multiline=true;
			
			skill2Lbl.wordWrap=true;
			skill2Lbl.multiline=true;
		}

		public function updateInfo(info:Object):void {
			var tipInfo:TipVipEquipInfo = info as TipVipEquipInfo;
			var elementInfo:TElementInfo = TableManager.getInstance().getElementInfo(tipInfo.type, tipInfo.level);
			var nelementInfo:TElementInfo = TableManager.getInstance().getElementInfo(tipInfo.type, tipInfo.level+1);
			if (null == elementInfo){
				return;
			}
			if (null == nelementInfo) {
				elementInfo = nelementInfo;
			}
			var zdl:int = ZDLUtil.computation(elementInfo.extraHp, 0, elementInfo.p_attack, elementInfo.p_defense, 0, 0, elementInfo.crit, elementInfo.tenacity, elementInfo.hit, elementInfo.dodge, elementInfo.slay, elementInfo.guard, 0, 0,0, elementInfo.damageE);
			num.setNum(zdl);
			nameLbl.text = elementInfo.name;
			for each(var lbl:Label in propertyList){
				lbl.visible = false;
			}
			for each(var lblv:Label in propertyVList){
				lblv.visible = false;
			}
			for each(var lblav:Label in propertyNList){
				lblav.visible = false;
			}
			for each(var lblanv:Label in propertyNVList){
				lblanv.visible = false;
			}
			currentLvLbl.text = elementInfo.lv+PropUtils.getStringById(2298);
			nextLvLbl.text = nelementInfo.lv+PropUtils.getStringById(2298);
			var index:int = 0;
			var lastLbl:Label;
			var plbl:Label = propertyList[index];
			var plblV:Label = propertyVList[index];
			var plblN:Label = propertyNList[index];
			var plblNV:Label = propertyNVList[index];
			if(elementInfo.damageE > 0){
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				if(1 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(43);
					plblN.text = PropUtils.getStringEasyById(43);
				}else if(2 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(44);
					plblN.text = PropUtils.getStringEasyById(44);
				}else if(3 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(45);
					plblN.text = PropUtils.getStringEasyById(45);
				}else if(4 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(46);
					plblN.text = PropUtils.getStringEasyById(46);
				}else if(5 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(47);
					plblN.text = PropUtils.getStringEasyById(47);
				}
				plblV.text = "+"+elementInfo.damageE;
				plblNV.text = "+"+nelementInfo.damageE;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.p_attack > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(4);
				plblN.text = PropUtils.getStringEasyById(4);
				plblV.text = "+"+elementInfo.p_attack;
				plblNV.text = "+"+nelementInfo.p_attack;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.p_defense > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(5);
				plblN.text = PropUtils.getStringEasyById(5);
				plblV.text = "+"+elementInfo.p_defense;
				plblNV.text = "+"+nelementInfo.p_defense;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.extraHp > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(1);
				plblN.text = PropUtils.getStringEasyById(1);
				plblV.text = "+"+elementInfo.extraHp;
				plblNV.text = "+"+nelementInfo.extraHp;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.crit > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(8);
				plblN.text = PropUtils.getStringEasyById(8);
				plblV.text = "+"+elementInfo.crit;
				plblNV.text = "+"+nelementInfo.crit;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.tenacity > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(9);
				plblN.text = PropUtils.getStringEasyById(9);
				plblV.text = "+"+elementInfo.tenacity;
				plblNV.text = "+"+nelementInfo.tenacity;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.hit > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(10);
				plblN.text = PropUtils.getStringEasyById(10);
				plblV.text = "+"+elementInfo.hit;
				plblNV.text = "+"+nelementInfo.hit;
				index++;
				lastLbl = plbl;
			}
			
			if(elementInfo.dodge > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(11);
				plblN.text = PropUtils.getStringEasyById(11);
				plblV.text = "+"+elementInfo.dodge;
				plblNV.text = "+"+nelementInfo.dodge;
				index++;
				lastLbl = plbl;
			}
			if(elementInfo.slay > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(12);
				plblN.text = PropUtils.getStringEasyById(12);
				plblV.text = "+"+elementInfo.slay;
				plblNV.text = "+"+nelementInfo.slay;
				index++;
				lastLbl = plbl;
			}
			if(elementInfo.guard > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblN = propertyNList[index];
				plblNV = propertyNVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblN.visible = true;
				plblNV.visible = true;
				plbl.text = PropUtils.getStringEasyById(13);
				plblN.text = PropUtils.getStringEasyById(13);
				plblV.text = "+"+elementInfo.guard;
				plblNV.text = "+"+nelementInfo.guard;
				index++;
				lastLbl = plbl;
			}
			
			currentfightLbl.text = "+"+zdl;
			zdl = ZDLUtil.computation(nelementInfo.extraHp, 0, nelementInfo.p_attack, nelementInfo.p_defense, 0, 0, nelementInfo.crit, nelementInfo.tenacity, nelementInfo.hit, nelementInfo.dodge, nelementInfo.slay, nelementInfo.guard, 0, 0,0, nelementInfo.damageE);
			nextfightLbl.text = "+"+zdl;
			fightingLbl.y = lastLbl.y + 20;
			currentfightLbl.y = fightingLbl.y;
			nfightingLbl.y = fightingLbl.y;
			nextfightLbl.y = fightingLbl.y;
			
			fightlineImg.y = nextfightLbl.y + 27;
			passivityLabel.y = fightlineImg.y + 6;
			
			skillName1.y = passivityLabel.y + 24;
			skill1Lbl.y = skillName1.y + skillName1.height;
			
			skillName1.text=TableManager.getInstance().getPassiveSkill(elementInfo.passiveSkill).name + "：";
			skill1Lbl.htmlText=TableManager.getInstance().getPassiveSkill(elementInfo.passiveSkill).des;
			
			fightlineImg0.y = skill1Lbl.y + skill1Lbl.height + 5;
			passivityLabel0.y = fightlineImg0.y + 5;
			passivityLabel1.y = passivityLabel0.y;
			
			
			skillName2.y = passivityLabel0.y + 24;
			skill2Lbl.y = skillName2.y + skillName2.height;
			
			var lvArr:Array = ConfigEnum.element17.split("|");
			var previousV:int = 0;
			var lv:int = 90;
			var l:int = lvArr.length;
			for(var n:int = 0; n < l; n++){
				if((elementInfo.lv >= previousV) && (elementInfo.lv < lvArr[n])){
					lv = lvArr[n];
					break;
				}
			}
			passivityLabel1.text = "("+StringUtil.substitute(PropUtils.getStringById(2299), lv)+")";
			
			var selementInfo:TElementInfo = TableManager.getInstance().getElementInfo(tipInfo.type, lv);
			
			skillName2.text=TableManager.getInstance().getPassiveSkill(selementInfo.passiveSkill).name + "：";
			skill2Lbl.htmlText=TableManager.getInstance().getPassiveSkill(selementInfo.passiveSkill).des;
			
			desclineImg.y = skill2Lbl.y + skill2Lbl.height + 5;
			
			desLbl.y = desclineImg.y+7;
			
			var tipsId:int;
			switch(elementInfo.type){
				case 1:
					tipsId = 9562;
					break;
				case 2:
					tipsId = 9563;
					break;
				case 3:
					tipsId = 9564;
					break;
				case 4:
					tipsId = 9565;
					break;
				case 5:
					tipsId = 9566;
					break;
			}
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(tipsId).content;
			var bgH:int=desLbl.y + desLbl.height + 10;
			bgSc.setSize(bgSc.width, bgH);
			
			movie.update(elementInfo.pnfId);
			movie.playAct("stand", 4);
			
			
//			var tipInfo:TipVipEquipInfo=info as TipVipEquipInfo;
//			lvLbl.text=tipInfo.lv + PropUtils.getStringById(1812);
//			vipLvLbl.text=tipInfo.vipLv + PropUtils.getStringById(1949);
//			currentLvLbl.text=tipInfo.lv + PropUtils.getStringById(1952);
//			var cqInfo:TVIPAttribute=TableManager.getInstance().getVipAttribute(tipInfo.lv);
//			var nqInfo:TVIPAttribute=TableManager.getInstance().getVipAttribute(tipInfo.lv + 1);
//			var vipDetail:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(tipInfo.vipLv);
//			if (null == cqInfo)
//				return;
//			if (null == nqInfo) {
//				nqInfo=cqInfo;
//			}
// 
//			nextLvLbl.text = nqInfo.lv + PropUtils.getStringById(1952);
//			bloodLbl.text = "+"+int(cqInfo.hp * vipDetail.rate*0.01);          	 nbloodLbl.text = "+"+int(nqInfo.hp * vipDetail.rate*0.01);
//			phyAttLbl.text = "+"+int(cqInfo.phyAtt * vipDetail.rate*0.01);       nphyAttLbl.text = "+"+int(nqInfo.phyAtt * vipDetail.rate*0.01);
////			magicAttLbl.text = "+"+int(cqInfo.maigcAtt * vipDetail.rate*0.01);   nmagicAttLbl.text = "+"+int(nqInfo.maigcAtt * vipDetail.rate*0.01);
//			phyDefLbl.text = "+"+int(cqInfo.phyDef * vipDetail.rate*0.01);       nphyDefLbl.text = "+"+int(nqInfo.phyDef * vipDetail.rate*0.01);
////			magicDefLbl.text = "+"+int(cqInfo.magicDef * vipDetail.rate*0.01);   nmagicDefLbl.text = "+"+int(nqInfo.magicDef * vipDetail.rate*0.01);
//			critLbl.text = "+"+int(cqInfo.crit * vipDetail.rate*0.01);           ncritLbl.text = "+"+int(nqInfo.crit * vipDetail.rate*0.01);
//			tenacityLbl.text = "+"+int(cqInfo.tenacity * vipDetail.rate*0.01);   ntenacityLbl.text = "+"+int(nqInfo.tenacity * vipDetail.rate*0.01);
//			hitLbl.text = "+"+int(cqInfo.hit * vipDetail.rate*0.01);             nhitLbl.text = "+"+int(nqInfo.hit * vipDetail.rate*0.01);
//			dodgeLbl.text = "+"+int(cqInfo.dodge * vipDetail.rate*0.01);         ndodgeLbl.text = "+"+int(nqInfo.dodge * vipDetail.rate*0.01);
//			slayLbl.text = "+"+int(cqInfo.slay * vipDetail.rate*0.01);           nslayLbl.text = "+"+int(nqInfo.slay * vipDetail.rate*0.01);
//			guardLbl.text = "+"+int(cqInfo.guard * vipDetail.rate*0.01);         nguardLbl.text = "+"+int(nqInfo.guard * vipDetail.rate*0.01);
//			var czdl:int = ZDLUtil.computation(cqInfo.hp*vipDetail.rate*0.01, 0, cqInfo.phyAtt*vipDetail.rate*0.01, cqInfo.phyDef*vipDetail.rate*0.01, cqInfo.maigcAtt*vipDetail.rate*0.01, cqInfo.magicDef*vipDetail.rate*0.01, cqInfo.crit*vipDetail.rate*0.01, cqInfo.tenacity*vipDetail.rate*0.01, cqInfo.hit*vipDetail.rate*0.01, cqInfo.dodge*vipDetail.rate*0.01, cqInfo.slay*vipDetail.rate*0.01, cqInfo.guard*vipDetail.rate*0.01, 0, 0);
//			currentfightLbl.text = "+"+czdl;
//			nextfightLbl.text = "+"+ZDLUtil.computation(nqInfo.hp*vipDetail.rate*0.01, 0, nqInfo.phyAtt*vipDetail.rate*0.01, nqInfo.phyDef*vipDetail.rate*0.01, nqInfo.maigcAtt*vipDetail.rate*0.01, nqInfo.magicDef*vipDetail.rate*0.01, nqInfo.crit*vipDetail.rate*0.01, nqInfo.tenacity*vipDetail.rate*0.01, nqInfo.hit*vipDetail.rate*0.01, nqInfo.dodge*vipDetail.rate*0.01, nqInfo.slay*vipDetail.rate*0.01, nqInfo.guard*vipDetail.rate*0.01, 0, 0);
// 
//			num.setNum(czdl);
//			var bottomY:int=fightlineImg.x + fightlineImg.height;
//			var bottomLbl:Label;
//			var movieId:int=TableManager.getInstance().getVipDetailInfo(tipInfo.vipLv).modelSmallId;
//			nameLbl.text=vipDetail.equipName;
//			movie.update(movieId);
//			movie.playAct("stand", 4);
//			skill1Lbl.visible=(0 != vipDetail.skill1);
//			skillName1.visible=skill1Lbl.visible;
//			if (skill1Lbl.visible) {
//				bottomLbl=skill1Lbl;
//				skillName1.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill1).name + "：";
//				skill1Lbl.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill1).des;
//				skill1Lbl.x=skillName1.x + skillName1.width;
//			}
//			skill2Lbl.visible=(0 != vipDetail.skill2);
//			skillName2.visible=skill2Lbl.visible;
//			if (skill2Lbl.visible) {
//				bottomLbl=skill2Lbl;
//				skillName2.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill2).name + "：";
//				skill2Lbl.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill2).des;
//				skill2Lbl.x=skillName2.x + skillName2.width;
//			}
//			skill3Lbl.visible=(0 != vipDetail.skill3);
//			skillName3.visible=skill3Lbl.visible;
//			if (skill3Lbl.visible) {
//				bottomLbl=skill3Lbl;
//				skillName3.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill3).name + "：";
//				skill3Lbl.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill3).des;
//				skill3Lbl.x=skillName3.x + skillName3.width;
//			}
//			skill4Lbl.visible=(0 != vipDetail.skill4);
//			skillName4.visible=skill4Lbl.visible;
//			if (skill4Lbl.visible) {
//				bottomLbl=skill4Lbl;
//				skillName4.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill4).name + "：";
//				skill4Lbl.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill4).des;
//				skill4Lbl.x=skillName4.x + skillName4.width;
//			}
//			skill5Lbl.visible=(0 != vipDetail.skill5);
//			skillName5.visible=skill5Lbl.visible;
//			if (skill5Lbl.visible) {
//				bottomLbl=skill5Lbl;
//				skillName5.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill5).name + "：";
//				skill5Lbl.text=TableManager.getInstance().getPassiveSkill(vipDetail.skill5).des;
//				skill5Lbl.x=skillName5.x + skillName5.width;
//			}
//
//			if (null == bottomLbl) {
//				passivityLabel.visible=false;
//				desclineImg.visible=false;
//				desLbl.y=fightlineImg.y + fightlineImg.height + 5;
//			} else {
//				passivityLabel.visible=true;
//				desclineImg.visible=true;
//				desclineImg.y=bottomLbl.y + bottomLbl.height;
//				desLbl.y=desclineImg.y + desclineImg.height + 5;
//			}
//			var bgH:int=desLbl.y + desLbl.height + 10;
//			bgSc.setSize(bgSc.width, bgH);
		}

		public function get isFirst():Boolean {
			return false;
		}
	}
}

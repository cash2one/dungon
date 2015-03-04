package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPAttribute;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.vip.TipVipEquipInfo;
	import com.leyou.util.ZDLUtil;
	
	public class TipsVipEquipTip extends AutoSprite implements ITip
	{
		private var nameLbl:Label;
		
		private var lvLbl:Label;
		
		private var vipLvLbl:Label;
		
		private var currentLvLbl:Label;
		
		private var bloodLbl:Label;
		
		private var phyAttLbl:Label;
		
		private var magicAttLbl:Label;
		
		private var phyDefLbl:Label;
		
		private var critLbl:Label;
		
		private var tenacityLbl:Label;
		
		private var hitLbl:Label;
		
		private var dodgeLbl:Label;
		
		private var slayLbl:Label;
		
		private var guardLbl:Label;
		
		private var currentfightLbl:Label;
		
		private var nbloodLbl:Label;
		
		private var nphyAttLbl:Label;
		
		private var nmagicAttLbl:Label;
		
		private var nphyDefLbl:Label;
		
		private var ncritLbl:Label;
		
		private var ntenacityLbl:Label;
		
		private var nhitLbl:Label;
		
		private var ndodgeLbl:Label;
		
		private var nslayLbl:Label;
		
		private var nguardLbl:Label;
		
		private var nextfightLbl:Label;
		
		private var skill1Lbl:Label;
		
		private var skill2Lbl:Label;
		
		private var skill3Lbl:Label;
		
		private var skill4Lbl:Label;
		
		private var skill5Lbl:Label;
		
		private var nextLvLbl:Label;
		
		private var desLbl:Label;
		
		private var magicDefLbl:Label;
		
		private var nmagicDefLbl:Label;
		
		private var num:RollNumWidget;
		
		private var movie:SwfLoader;
		
		private var desclineImg:Image;
		
		private var fightlineImg:Image;
		
		private var bgSc:ScaleBitmap;
		
		private var passivityLabel:Label;
		
		private var skillName1:Label;
		
		private var skillName2:Label;
		
		private var skillName3:Label;
		
		private var skillName4:Label;
		
		private var skillName5:Label;
		
		public function TipsVipEquipTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/TipsVipEquipWnd.xml"));
			init();
		}
		
		private function init():void{
			num = new RollNumWidget();
			num.loadSource("ui/num/{num}_lzs.png");
			num.x = 90;
			num.y = 91;
			addChild(num);
			movie = new SwfLoader();
			movie.x = 41;
			movie.y = 110+51;
			addChild(movie);
			skillName1 = getUIbyID("skillName1") as Label;
			skillName2 = getUIbyID("skillName2") as Label;
			skillName3 = getUIbyID("skillName3") as Label;
			skillName4 = getUIbyID("skillName4") as Label;
			skillName5 = getUIbyID("skillName5") as Label;
			passivityLabel = getUIbyID("passivityLabel") as Label;
			bgSc = getUIbyID("bgSc") as ScaleBitmap;
			fightlineImg = getUIbyID("fightlineImg") as Image;
			desclineImg = getUIbyID("desclineImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			vipLvLbl = getUIbyID("vipLvLbl") as Label;
			currentLvLbl = getUIbyID("currentLvLbl") as Label;
			nextLvLbl = getUIbyID("nextLvLbl") as Label;
			bloodLbl = getUIbyID("bloodLbl") as Label;
			phyAttLbl = getUIbyID("phyAttLbl") as Label;
			phyDefLbl  = getUIbyID("phyDefLbl") as Label;
			nphyDefLbl = getUIbyID("nphyDefLbl") as Label;
			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			tenacityLbl = getUIbyID("tenacityLbl") as Label;
			dodgeLbl = getUIbyID("dodgeLbl") as Label;
			slayLbl = getUIbyID("slayLbl") as Label;
			critLbl = getUIbyID("critLbl") as Label;
			guardLbl = getUIbyID("guardLbl") as Label;
			currentfightLbl = getUIbyID("currentfightLbl") as Label;
			nbloodLbl = getUIbyID("nbloodLbl") as Label;
			nphyAttLbl = getUIbyID("nphyAttLbl") as Label;
			nmagicAttLbl = getUIbyID("nmagicAttLbl") as Label;
			nmagicDefLbl = getUIbyID("nmagicDefLbl") as Label;
			ncritLbl = getUIbyID("ncritLbl") as Label;
			ntenacityLbl = getUIbyID("ntenacityLbl") as Label;
			nhitLbl = getUIbyID("nhitLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			ndodgeLbl = getUIbyID("ndodgeLbl") as Label;
			nslayLbl = getUIbyID("nslayLbl") as Label;
			nguardLbl = getUIbyID("nguardLbl") as Label;
			nextfightLbl = getUIbyID("nextfightLbl") as Label;
			skill1Lbl = getUIbyID("skill1Lbl") as Label;
			skill2Lbl = getUIbyID("skill2Lbl") as Label;
			skill3Lbl = getUIbyID("skill3Lbl") as Label;
			skill4Lbl = getUIbyID("skill4Lbl") as Label;
			skill5Lbl = getUIbyID("skill5Lbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(6003).content;
		}
		
		public function updateInfo(info:Object):void{
			var tipInfo:TipVipEquipInfo = info as TipVipEquipInfo;
			lvLbl.text = tipInfo.lv + "级";
			vipLvLbl.text = tipInfo.vipLv + "阶";
			currentLvLbl.text = tipInfo.lv + "级属性";
			var cqInfo:TVIPAttribute = TableManager.getInstance().getVipAttribute(tipInfo.lv);
			var nqInfo:TVIPAttribute = TableManager.getInstance().getVipAttribute(tipInfo.lv+1);
			var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(tipInfo.vipLv);
			if(null == cqInfo) return;
			if(null == nqInfo){
				nqInfo = cqInfo;
			}
			nextLvLbl.text = nqInfo.lv + "级属性";
			bloodLbl.text = "+"+int(cqInfo.hp * vipDetail.rate*0.01);          	 nbloodLbl.text = "+"+int(nqInfo.hp * vipDetail.rate*0.01);
			phyAttLbl.text = "+"+int(cqInfo.phyAtt * vipDetail.rate*0.01);       nphyAttLbl.text = "+"+int(nqInfo.phyAtt * vipDetail.rate*0.01);
			magicAttLbl.text = "+"+int(cqInfo.maigcAtt * vipDetail.rate*0.01);   nmagicAttLbl.text = "+"+int(nqInfo.maigcAtt * vipDetail.rate*0.01);
			phyDefLbl.text = "+"+int(cqInfo.phyDef * vipDetail.rate*0.01);       nphyDefLbl.text = "+"+int(nqInfo.phyDef * vipDetail.rate*0.01);
			magicDefLbl.text = "+"+int(cqInfo.magicDef * vipDetail.rate*0.01);   nmagicDefLbl.text = "+"+int(nqInfo.magicDef * vipDetail.rate*0.01);
			critLbl.text = "+"+int(cqInfo.crit * vipDetail.rate*0.01);           ncritLbl.text = "+"+int(nqInfo.crit * vipDetail.rate*0.01);
			tenacityLbl.text = "+"+int(cqInfo.tenacity * vipDetail.rate*0.01);   ntenacityLbl.text = "+"+int(nqInfo.tenacity * vipDetail.rate*0.01);
			hitLbl.text = "+"+int(cqInfo.hit * vipDetail.rate*0.01);             nhitLbl.text = "+"+int(nqInfo.hit * vipDetail.rate*0.01);
			dodgeLbl.text = "+"+int(cqInfo.dodge * vipDetail.rate*0.01);         ndodgeLbl.text = "+"+int(nqInfo.dodge * vipDetail.rate*0.01);
			slayLbl.text = "+"+int(cqInfo.slay * vipDetail.rate*0.01);           nslayLbl.text = "+"+int(nqInfo.slay * vipDetail.rate*0.01);
			guardLbl.text = "+"+int(cqInfo.guard * vipDetail.rate*0.01);         nguardLbl.text = "+"+int(nqInfo.guard * vipDetail.rate*0.01);
			var czdl:int = ZDLUtil.computation(cqInfo.hp*vipDetail.rate*0.01, 0, cqInfo.phyAtt*vipDetail.rate*0.01, cqInfo.phyDef*vipDetail.rate*0.01, cqInfo.maigcAtt*vipDetail.rate*0.01, cqInfo.magicDef*vipDetail.rate*0.01, cqInfo.crit*vipDetail.rate*0.01, cqInfo.tenacity*vipDetail.rate*0.01, cqInfo.hit*vipDetail.rate*0.01, cqInfo.dodge*vipDetail.rate*0.01, cqInfo.slay*vipDetail.rate*0.01, cqInfo.guard*vipDetail.rate*0.01);
			currentfightLbl.text = "+"+czdl;
			nextfightLbl.text = "+"+ZDLUtil.computation(nqInfo.hp*vipDetail.rate*0.01, 0, nqInfo.phyAtt*vipDetail.rate*0.01, nqInfo.phyDef*vipDetail.rate*0.01, nqInfo.maigcAtt*vipDetail.rate*0.01, nqInfo.magicDef*vipDetail.rate*0.01, nqInfo.crit*vipDetail.rate*0.01, nqInfo.tenacity*vipDetail.rate*0.01, nqInfo.hit*vipDetail.rate*0.01, nqInfo.dodge*vipDetail.rate*0.01, nqInfo.slay*vipDetail.rate*0.01, nqInfo.guard*vipDetail.rate*0.01);
			num.setNum(czdl);
			var bottomY:int = fightlineImg.x + fightlineImg.height;
			var bottomLbl:Label;
			var movieId:int = TableManager.getInstance().getVipDetailInfo(tipInfo.vipLv).modelSmallId;
			nameLbl.text = vipDetail.equipName;
			movie.update(movieId);
			movie.playAct("stand", 4);
			skill1Lbl.visible = (0 != vipDetail.skill1);
			skillName1.visible = skill1Lbl.visible;
			if(skill1Lbl.visible){
				bottomLbl = skill1Lbl;
				skillName1.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill1).name+"：";
				skill1Lbl.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill1).des;
				skill1Lbl.x = skillName1.x + skillName1.width;
			}
			skill2Lbl.visible = (0 != vipDetail.skill2);
			skillName2.visible = skill2Lbl.visible;
			if(skill2Lbl.visible){
				bottomLbl = skill2Lbl;
				skillName2.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill2).name+"：";
				skill2Lbl.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill2).des;
				skill2Lbl.x = skillName2.x + skillName2.width;
			}
			skill3Lbl.visible = (0 != vipDetail.skill3);
			skillName3.visible = skill3Lbl.visible;
			if(skill3Lbl.visible){
				bottomLbl = skill3Lbl;
				skillName3.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill3).name+"：";
				skill3Lbl.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill3).des;
				skill3Lbl.x = skillName3.x + skillName3.width;
			}
			skill4Lbl.visible = (0 != vipDetail.skill4);
			skillName4.visible = skill4Lbl.visible;
			if(skill4Lbl.visible){
				bottomLbl = skill4Lbl;
				skillName4.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill4).name+"：";
				skill4Lbl.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill4).des;
				skill4Lbl.x = skillName4.x + skillName4.width;
			}
			skill5Lbl.visible = (0 != vipDetail.skill5);
			skillName5.visible = skill5Lbl.visible;
			if(skill5Lbl.visible){
				bottomLbl = skill5Lbl;
				skillName5.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill5).name+"：";
				skill5Lbl.text = TableManager.getInstance().getPassiveSkill(vipDetail.skill5).des;
				skill5Lbl.x = skillName5.x + skillName5.width;
			}
			
			if(null == bottomLbl){
				passivityLabel.visible = false;
				desclineImg.visible = false;
				desLbl.y = fightlineImg.y + fightlineImg.height + 5;
			}else{
				passivityLabel.visible = true;
				desclineImg.visible = true;
				desclineImg.y = bottomLbl.y + bottomLbl.height;
				desLbl.y = desclineImg.y + desclineImg.height + 5;
			}
			var bgH:int = desLbl.y + desLbl.height + 10;
			bgSc.setSize(bgSc.width, bgH);
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipBlessInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.vip.TipVipBlessInfo;
	import com.leyou.util.ZDLUtil;
	
	public class TipsVipBlessTip extends AutoSprite implements ITip
	{
		private var nameLbl:Label;
		
		private var lvkeyLbl:Label;
		
		private var lvLbl:Label;
		
		private var desLbl:Label;
		
		private var clvLbl:Label;
		
		private var nlvLbl:Label;
		
		private var bloodLbl:Label;
		
		private var nbloodLbl:Label;
		
		private var phyAttLbl:Label;
		
		private var nphyAttLbl:Label;
		
		private var magicAttLbl:Label;
		
		private var nmagicAttLbl:Label;
		
		private var phyDefLbl:Label;
		
		private var nphyDefLbl:Label;
		
		private var magicDefLbl:Label;
		
		private var nmagicDefLbl:Label;
		
		private var critLbl:Label;
		
		private var ncritLbl:Label;
		
		private var tenacityLbl:Label;
		
		private var ntenacityLbl:Label;
		
		private var hitLbl:Label;
		
		private var nhitLbl:Label;
		
		private var dodgeLbl:Label;
		
		private var ndodgeLbl:Label;
		
		private var slayLbl:Label;
		
		private var nslayLbl:Label;
		
		private var guardLbl:Label;
		
		private var nguardLbl:Label;
		
		private var currentfightLbl:Label;
		
		private var nextfightLbl:Label;
		
		private var iconImg:Image;
		
		public function TipsVipBlessTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/TipsVipBlessWnd.xml"));
			init();
		}
		
		private function init():void{
			iconImg = new Image();
			iconImg.x = 11;
			iconImg.y = 16;
			addChild(iconImg);
			nameLbl = getUIbyID("nameLbl") as Label;
			lvkeyLbl = getUIbyID("lvkeyLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			clvLbl = getUIbyID("clvLbl") as Label;
			nlvLbl = getUIbyID("nlvLbl") as Label;
			bloodLbl = getUIbyID("bloodLbl") as Label;
			nbloodLbl = getUIbyID("nbloodLbl") as Label;
			phyAttLbl = getUIbyID("phyAttLbl") as Label;
			nphyAttLbl = getUIbyID("nphyAttLbl") as Label;
			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			nmagicAttLbl = getUIbyID("nmagicAttLbl") as Label;
			phyDefLbl = getUIbyID("phyDefLbl") as Label;
			nphyDefLbl = getUIbyID("nphyDefLbl") as Label;
			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			nmagicDefLbl = getUIbyID("nmagicDefLbl") as Label;
			critLbl = getUIbyID("critLbl") as Label;
			ncritLbl = getUIbyID("ncritLbl") as Label;
			tenacityLbl = getUIbyID("tenacityLbl") as Label;
			ntenacityLbl = getUIbyID("ntenacityLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			nhitLbl = getUIbyID("nhitLbl") as Label;
			dodgeLbl = getUIbyID("dodgeLbl") as Label;
			ndodgeLbl = getUIbyID("ndodgeLbl") as Label;
			slayLbl = getUIbyID("slayLbl") as Label;
			nslayLbl = getUIbyID("nslayLbl") as Label;
			guardLbl = getUIbyID("guardLbl") as Label;
			nguardLbl = getUIbyID("nguardLbl") as Label;
			currentfightLbl = getUIbyID("currentfightLbl") as Label;
			nextfightLbl = getUIbyID("nextfightLbl") as Label;
		}
		
		public function updateInfo(info:Object):void{
			var tipInfo:TipVipBlessInfo = info as TipVipBlessInfo;
			lvLbl.text = tipInfo.level+"阶";
			if(tipInfo.level < 4){
				tipInfo.level = 4;
			}
			var tinfo:TEquipBlessInfo = TableManager.getInstance().getVipBlessInfo(tipInfo.type, tipInfo.level);
			var url:String = (1 == tipInfo.type) ? "ui/character/icon_zqzf.png" : "ui/character/icon_cbzf.png";
			lvkeyLbl.text = (1 == tipInfo.type) ? "当前坐骑等阶：" : "当前翅膀等阶：";
			var desId:int = (1 == tipInfo.type) ? 6004 : 6005;
			var content:String = TableManager.getInstance().getSystemNotice(desId).content;
			iconImg.updateBmp(url);
			nameLbl.text = tinfo.name;
			desLbl.htmlText = content;
			clvLbl.text = tinfo.name;
			bloodLbl.text = "+"+tinfo.hp;
			phyAttLbl.text = "+"+tinfo.attack;
			magicAttLbl.text = "+"+tinfo.magicAtt;
			phyDefLbl.text = "+"+tinfo.phyDef;
			magicDefLbl.text = "+"+tinfo.magicDef;
			critLbl.text = "+"+tinfo.crit;
			tenacityLbl.text = "+"+tinfo.tenacity;
			hitLbl.text = "+"+tinfo.hit;
			dodgeLbl.text = "+"+tinfo.dodge;
			slayLbl.text = "+"+tinfo.slay;
			guardLbl.text = "+"+tinfo.guard;
			currentfightLbl.text = "+"+ZDLUtil.computation(tinfo.hp, 0, tinfo.attack, tinfo.phyDef, tinfo.magicAtt, tinfo.magicDef, tinfo.crit, tinfo.tenacity, tinfo.hit, tinfo.dodge, tinfo.slay, tinfo.guard);
			var ntinfo:TEquipBlessInfo = TableManager.getInstance().getVipBlessInfo(tipInfo.type, tipInfo.level+1);
			if(null == ntinfo){
				setNextVisible(false);
			}else{
				setNextVisible(true);
				nlvLbl.text = ntinfo.name;
				nbloodLbl.text = "+"+ntinfo.hp;
				nphyAttLbl.text = "+"+ntinfo.attack;
				nmagicAttLbl.text = "+"+ntinfo.magicAtt;
				nphyDefLbl.text = "+"+ntinfo.phyDef;
				nmagicDefLbl.text = "+"+ntinfo.magicDef;
				ncritLbl.text = "+"+ntinfo.crit;
				ntenacityLbl.text = "+"+ntinfo.tenacity;
				nhitLbl.text = "+"+ntinfo.hit;
				ndodgeLbl.text = "+"+ntinfo.dodge;
				nslayLbl.text = "+"+ntinfo.slay;
				nguardLbl.text = "+"+ntinfo.guard;
				nextfightLbl.text = "+"+ZDLUtil.computation(ntinfo.hp, 0, ntinfo.attack, ntinfo.phyDef, ntinfo.magicAtt, ntinfo.magicDef, ntinfo.crit, ntinfo.tenacity, ntinfo.hit, ntinfo.dodge, ntinfo.slay, ntinfo.guard);
			}
		}
		
		private function setNextVisible(value:Boolean):void{
			nlvLbl.visible = value;
			nbloodLbl.visible = value;
			nphyAttLbl.visible = value;
			nmagicAttLbl.visible = value;
			nphyDefLbl.visible = value;
			nmagicDefLbl.visible = value;
			ncritLbl.visible = value;
			ntenacityLbl.visible = value;
			nhitLbl.visible = value;
			ndodgeLbl.visible = value;
			nslayLbl.visible = value;
			nguardLbl.visible = value;
			nextfightLbl.visible = value;
			getUIbyID("propName0Lbl").visible = value;
			getUIbyID("propName1Lbl").visible = value;
			getUIbyID("propName2Lbl").visible = value;
			getUIbyID("propName3Lbl").visible = value;
			getUIbyID("propName0").visible = value;
			getUIbyID("propName1").visible = value;
			getUIbyID("propName2").visible = value;
			getUIbyID("propName3").visible = value;
			getUIbyID("propName4").visible = value;
			getUIbyID("propName5").visible = value;
			getUIbyID("propName6").visible = value;
			getUIbyID("nameLbl1").visible = value;
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
package com.leyou.ui.tips {
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipBlessInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.vip.TipVipBlessInfo;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;

	public class TipsVipBlessTip extends AutoSprite implements ITip {
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

//		private var magicAttLbl:Label;

//		private var nmagicAttLbl:Label;

		private var phyDefLbl:Label;

		private var nphyDefLbl:Label;

//		private var magicDefLbl:Label;

//		private var nmagicDefLbl:Label;

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
 
		
		private var hpTLbl:Label;
		
		private var attTLbl:Label;
		
		private var defTLbl:Label;
		
		private var critTLbl:Label;
		
		private var tenacityTLbl:Label;
		
		private var hitTLbl:Label;
		
		private var dodgeTLbl:Label;
		
		private var slayTLbl:Label;
		
		private var guradTLbl:Label;
		
		private var nhpTLbl:Label;
		
		private var nattTLbl:Label;
		
		private var ndefTLbl:Label;
		
		private var ncritTLbl:Label;
		
		private var ntenacityTLbl:Label;
		
		private var nhitTLbl:Label;
		
		private var ndodgeTLbl:Label;
		
		private var nslayTLbl:Label;
		
		private var nguradTLbl:Label;
		
		public function TipsVipBlessTip(){
 
			super(LibManager.getInstance().getXML("config/ui/tips/TipsVipBlessWnd.xml"));
			init();
		}

		private function init():void {
			iconImg=new Image();
			iconImg.x=11;
			iconImg.y=16;
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
//			magicAttLbl = getUIbyID("magicAttLbl") as Label;
//			nmagicAttLbl = getUIbyID("nmagicAttLbl") as Label;
			phyDefLbl = getUIbyID("phyDefLbl") as Label;
			nphyDefLbl = getUIbyID("nphyDefLbl") as Label;
//			magicDefLbl = getUIbyID("magicDefLbl") as Label;
//			nmagicDefLbl = getUIbyID("nmagicDefLbl") as Label;
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
 
			hpTLbl = getUIbyID("hpTLbl") as Label;
			attTLbl = getUIbyID("attTLbl") as Label;
			defTLbl = getUIbyID("defTLbl") as Label;
			critTLbl = getUIbyID("critTLbl") as Label;
			tenacityTLbl = getUIbyID("tenacityTLbl") as Label;
			hitTLbl = getUIbyID("hitTLbl") as Label;
			dodgeTLbl = getUIbyID("dodgeTLbl") as Label;
			slayTLbl = getUIbyID("slayTLbl") as Label;
			guradTLbl = getUIbyID("guradTLbl") as Label;
			nhpTLbl = getUIbyID("nhpTLbl") as Label;
			nattTLbl = getUIbyID("nattTLbl") as Label;
			ndefTLbl = getUIbyID("ndefTLbl") as Label;
			ncritTLbl = getUIbyID("ncritTLbl") as Label;
			ntenacityTLbl = getUIbyID("ntenacityTLbl") as Label;
			nhitTLbl = getUIbyID("nhitTLbl") as Label;
			ndodgeTLbl = getUIbyID("ndodgeTLbl") as Label;
			nslayTLbl = getUIbyID("nslayTLbl") as Label;
			nguradTLbl = getUIbyID("nguradTLbl") as Label;
		}

		public function updateInfo(info:Object):void {
			var tipInfo:TipVipBlessInfo=info as TipVipBlessInfo;
			lvLbl.text=tipInfo.level + PropUtils.getStringById(1949);
			if (tipInfo.level < 4) {
				tipInfo.level=4;
			}
			var tinfo:TEquipBlessInfo=TableManager.getInstance().getVipBlessInfo(tipInfo.type, tipInfo.level);
			var url:String=(1 == tipInfo.type) ? "ui/character/icon_zqzf.png" : "ui/character/icon_cbzf.png";
			lvkeyLbl.text=(1 == tipInfo.type) ? PropUtils.getStringById(1950) : PropUtils.getStringById(1951);
			var desId:int=(1 == tipInfo.type) ? 6004 : 6005;
			var content:String=TableManager.getInstance().getSystemNotice(desId).content;
 
			iconImg.updateBmp(url);                      
			nameLbl.text = tinfo.name; 
			desLbl.htmlText = content;
			clvLbl.text = tinfo.name;
			bloodLbl.text = "+"+tinfo.hp;
			phyAttLbl.text = "+"+tinfo.attack;
//			magicAttLbl.text = "+"+tinfo.magicAtt;
			phyDefLbl.text = "+"+tinfo.phyDef;
//			magicDefLbl.text = "+"+tinfo.magicDef;
			critLbl.text = "+"+tinfo.crit;
			tenacityLbl.text = "+"+tinfo.tenacity;
			hitLbl.text = "+"+tinfo.hit;
			dodgeLbl.text = "+"+tinfo.dodge;
			slayLbl.text = "+"+tinfo.slay;
			guardLbl.text = "+"+tinfo.guard;
			currentfightLbl.text = "+"+ZDLUtil.computation(tinfo.hp, 0, tinfo.attack, tinfo.phyDef, tinfo.magicAtt, tinfo.magicDef, tinfo.crit, tinfo.tenacity, tinfo.hit, tinfo.dodge, tinfo.slay, tinfo.guard, 0, 0);
			var ntinfo:TEquipBlessInfo = TableManager.getInstance().getVipBlessInfo(tipInfo.type, tipInfo.level+1);
			if(null == ntinfo){
 
				setNextVisible(false);
			} else {
				setNextVisible(true);
 
				nlvLbl.text = ntinfo.name;
				nbloodLbl.text = "+"+ntinfo.hp;
				nphyAttLbl.text = "+"+ntinfo.attack;
//				nmagicAttLbl.text = "+"+ntinfo.magicAtt;
				nphyDefLbl.text = "+"+ntinfo.phyDef;
//				nmagicDefLbl.text = "+"+ntinfo.magicDef;
				ncritLbl.text = "+"+ntinfo.crit;
				ntenacityLbl.text = "+"+ntinfo.tenacity;
				nhitLbl.text = "+"+ntinfo.hit;
				ndodgeLbl.text = "+"+ntinfo.dodge;
				nslayLbl.text = "+"+ntinfo.slay;
				nguardLbl.text = "+"+ntinfo.guard;
				nextfightLbl.text = "+"+ZDLUtil.computation(ntinfo.hp, 0, ntinfo.attack, ntinfo.phyDef, ntinfo.magicAtt, ntinfo.magicDef, ntinfo.crit, ntinfo.tenacity, ntinfo.hit, ntinfo.dodge, ntinfo.slay, ntinfo.guard, 0, 0);
 
			}
		}
 
		
		private function setNextVisible(value:Boolean):void{
			nlvLbl.visible = value;
			nbloodLbl.visible = value;
			nphyAttLbl.visible = value;
//			nmagicAttLbl.visible = value;
			nphyDefLbl.visible = value;
//			nmagicDefLbl.visible = value;
			ncritLbl.visible = value;
			ntenacityLbl.visible = value;
			nhitLbl.visible = value;
			ndodgeLbl.visible = value;
			nslayLbl.visible = value;
			nguardLbl.visible = value;
			nextfightLbl.visible = value;
			
			nhpTLbl.visible = value;
			nattTLbl.visible = value;
			ndefTLbl.visible = value;
			ncritTLbl.visible = value;
			ntenacityTLbl.visible = value;
			nhitTLbl.visible = value;
			ndodgeTLbl.visible = value;
			nslayTLbl.visible = value;
			nguradTLbl.visible = value;
 
		}

		public function get isFirst():Boolean {
			return false;
		}
	}
}

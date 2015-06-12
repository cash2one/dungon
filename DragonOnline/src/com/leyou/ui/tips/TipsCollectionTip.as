package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.enum.GameFileEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.collectioin.CollectionGroupTaskData;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	public class TipsCollectionTip extends AutoSprite implements ITip
	{
		private var bgImg:ScaleBitmap;
		
		private var nameLbl:Label;
		
		private var progressLbl:Label;
		
		private var mapLbl:Label;
		
		private var rewardLbl:Label;
		
		private var expTLbl:Label;
		
		private var expLbl:Label;
		
		private var moneyTLbl:Label;
		
		private var moneyLbl:Label;
		
		private var energyTLbl:Label;
		
		private var energyLbl:Label;
		
		private var lpTLbl:Label;
		
		private var lpLbl:Label;
		
		private var bybTLbl:Label;
		
		private var bybLbl:Label;
		
		private var proLbl:Label;
		
		private var hpTLbl:Label;
		
		private var hpLbl:Label;
		
//		private var mpTLbl:Label;
		
//		private var mpLbl:Label;
		
		private var phyAttTLbl:Label;
		
		private var phyAttLbl:Label;
		
//		private var magicAttTLbl:Label;
		
//		private var magicAttLbl:Label;
		
		private var phyDefTLbl:Label;
		
		private var phyDefLbl:Label;
		
//		private var magicDefTLbl:Label;
		
//		private var magicDefLbl:Label;
		
		private var critTLbl:Label;
		
		private var critLbl:Label;
		
		private var tenacityTLbl:Label;
		
		private var tenacityLbl:Label;
		
		private var hitTLbl:Label;
		
		private var hitLbl:Label;
		
		private var dodgeTLbl:Label;
		
		private var dodgeLbl:Label;
		
		private var slayTLbl:Label;
		
		private var slayLbl:Label;
		
		private var guardTLbl:Label;
		
		private var guardLbl:Label;
		
		private var statusLbl:Label;
		
		private var icon:Image;
		
		public function TipsCollectionTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/mineTips.xml"));
			init();
		}
		
		private function init():void{
			bgImg = getUIbyID("bgImg") as ScaleBitmap;
			nameLbl = getUIbyID("nameLbl") as Label;
			progressLbl = getUIbyID("progressLbl") as Label;
			mapLbl = getUIbyID("mapLbl") as Label;
			
			rewardLbl = getUIbyID("rewardLbl") as Label;
			
			expTLbl = getUIbyID("expTLbl") as Label;
			expLbl = getUIbyID("expLbl") as Label;
			moneyTLbl = getUIbyID("moneyTLbl") as Label;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			energyTLbl = getUIbyID("energyTLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;
			lpTLbl = getUIbyID("lpTLbl") as Label;
			lpLbl = getUIbyID("lpLbl") as Label;
			bybTLbl = getUIbyID("bybTLbl") as Label;
			bybLbl = getUIbyID("bybLbl") as Label;
			
			proLbl = getUIbyID("proLbl") as Label;
			
			hpTLbl = getUIbyID("hpTLbl") as Label;
			hpLbl = getUIbyID("hpLbl") as Label;
//			mpTLbl = getUIbyID("mpTLbl") as Label;
//			mpLbl = getUIbyID("mpLbl") as Label;
			phyAttTLbl = getUIbyID("phyAttTLbl") as Label;
			phyAttLbl = getUIbyID("phyAttLbl") as Label;
//			magicAttTLbl = getUIbyID("magicAttTLbl") as Label;
//			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			phyDefTLbl = getUIbyID("phyDefTLbl") as Label;
			phyDefLbl = getUIbyID("phyDefLbl") as Label;
//			magicDefTLbl = getUIbyID("magicDefTLbl") as Label;
//			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			critTLbl = getUIbyID("critTLbl") as Label;
			critLbl = getUIbyID("critLbl") as Label;
			tenacityTLbl = getUIbyID("tenacityTLbl") as Label;
			tenacityLbl = getUIbyID("tenacityLbl") as Label;
			hitTLbl = getUIbyID("hitTLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			dodgeTLbl = getUIbyID("dodgeTLbl") as Label;
			dodgeLbl = getUIbyID("dodgeLbl") as Label;
			slayTLbl = getUIbyID("slayTLbl") as Label;
			slayLbl = getUIbyID("slayLbl") as Label;
			guardTLbl = getUIbyID("guardTLbl") as Label;
			guardLbl = getUIbyID("guardLbl") as Label;
			statusLbl = getUIbyID("statusLbl") as Label;
			icon = new Image();
			icon.x = 12;
			icon.y = 12;
			addChild(icon);
		}
		
		public function updateInfo(info:Object):void{
			var id:int = int(info);
			var tData:TCollectionPreciousInfo = TableManager.getInstance().getPreciousById(id);
			var data:CollectionGroupTaskData = DataManager.getInstance().collectionData.getTaskData(tData.groupId);
			var url:String = GameFileEnum.URL_ITEM_ICO+tData.toProIcon;
			icon.updateBmp(url);
			nameLbl.text = tData.toProName;
			progressLbl.text = data.getTask(id).cNum +"/"+tData.proMax;
			mapLbl.text = StringUtil.substitute(PropUtils.getStringById(1929), tData.mapName, tData.monsterName);
			var beginY:int = rewardLbl.y;
			rewardLbl.visible = tData.hasReward();
			//			if(tData.hasReward()){
			expLbl.visible = (tData.exp > 0);
			expTLbl.visible = (tData.exp > 0);
			if(tData.exp > 0){
				beginY += 20;
				expLbl.y = beginY;
				expTLbl.y = beginY;
				expLbl.text = tData.exp+"";
			}
			moneyLbl.visible = (tData.money > 0);
			moneyTLbl.visible = (tData.money > 0);
			if(tData.money > 0){
				beginY += 20;
				moneyLbl.y = beginY;
				moneyTLbl.y = beginY;
				moneyLbl.text = tData.money+"";
			}
			energyLbl.visible = (tData.energy > 0);
			energyTLbl.visible = (tData.energy > 0);
			if(tData.energy > 0){
				beginY += 20;
				energyLbl.y = beginY;
				energyTLbl.y = beginY;
				energyLbl.text = tData.energy+"";
			}
			lpLbl.visible = (tData.lp > 0);
			lpTLbl.visible = (tData.lp > 0);
			if(tData.lp > 0){
				beginY += 20;
				lpLbl.y = beginY;
				lpTLbl.y = beginY;
				lpLbl.text = tData.lp+"";
			}
			bybLbl.visible = (tData.byb > 0);
			bybTLbl.visible = (tData.byb > 0);
			if(tData.byb > 0){
				beginY += 20;
				bybLbl.y = beginY;
				bybTLbl.y = beginY;
				bybLbl.text = tData.byb+"";
			}
			//			}
			proLbl.visible = tData.hasPro();
			if(tData.hasPro()){
				if(beginY != rewardLbl.y){
					beginY += 20;
				}
				proLbl.y = beginY;
			}
			hpLbl.visible = (tData.hp > 0);
			hpTLbl.visible = (tData.hp > 0);
			if(tData.hp > 0){
				beginY += 20;
				hpLbl.y = beginY;
				hpTLbl.y = beginY;
				hpLbl.text = "+"+tData.hp;
			}
//			mpLbl.visible = (tData.mp > 0);
//			mpTLbl.visible = (tData.mp > 0);
//			if(tData.mp > 0){
//				beginY += 20;
//				mpLbl.y = beginY;
//				mpTLbl.y = beginY;
//				mpLbl.text = "+"+tData.mp;
//			}
			phyAttLbl.visible = (tData.phyAtt > 0);
			phyAttTLbl.visible = (tData.phyAtt > 0);
			if(tData.phyAtt > 0){
				beginY += 20;
				phyAttLbl.y = beginY;
				phyAttTLbl.y = beginY;
				phyAttLbl.text = "+"+tData.phyAtt;
			}
//			magicAttLbl.visible = (tData.magicAtt > 0);
//			magicAttTLbl.visible = (tData.magicAtt > 0);
//			if(tData.magicAtt > 0){
//				beginY += 20;
//				magicAttLbl.y = beginY;
//				magicAttTLbl.y = beginY;
//				magicAttLbl.text = "+"+tData.magicAtt;
//			}
			phyDefLbl.visible = (tData.phyDef > 0);
			phyDefTLbl.visible = (tData.phyDef > 0);
			if(tData.phyDef > 0){
				beginY += 20;
				phyDefLbl.y = beginY;
				phyDefTLbl.y = beginY;
				phyDefLbl.text = "+"+tData.phyDef
			}
//			magicDefLbl.visible = (tData.magicDef > 0);
//			magicDefTLbl.visible = (tData.magicDef > 0);
//			if(tData.magicDef > 0){
//				beginY += 20;
//				magicDefLbl.y = beginY;
//				magicDefTLbl.y = beginY;
//				magicDefLbl.text = "+"+tData.magicDef;
//			}
			critLbl.visible = (tData.crit > 0);
			critTLbl.visible = (tData.crit > 0);
			if(tData.crit > 0){
				beginY += 20;
				critLbl.y = beginY;
				critTLbl.y = beginY;
				critLbl.text = "+"+tData.crit;
			}
			tenacityLbl.visible = (tData.tenacity > 0);
			tenacityTLbl.visible = (tData.tenacity > 0);
			if(tData.tenacity > 0){
				beginY += 20;
				tenacityLbl.y = beginY;
				tenacityTLbl.y = beginY;
				tenacityLbl.text = "+"+tData.tenacity;
			}
			hitLbl.visible = (tData.hit > 0);
			hitTLbl.visible = (tData.hit > 0);
			if(tData.hit > 0){
				beginY += 20;
				hitLbl.y = beginY;
				hitTLbl.y = beginY;
				hitLbl.text = "+"+tData.hit;
			}
			dodgeLbl.visible = (tData.dodge > 0);
			dodgeTLbl.visible = (tData.dodge > 0);
			if(tData.dodge > 0){
				beginY += 20;
				dodgeLbl.y = beginY;
				dodgeTLbl.y = beginY;
				dodgeLbl.text = "+"+tData.dodge;
			}
			slayLbl.visible = (tData.slay > 0);
			slayTLbl.visible = (tData.slay > 0);
			if(tData.slay > 0){
				beginY += 20;
				slayLbl.y = beginY;
				slayTLbl.y = beginY;
				slayLbl.text = "+"+tData.slay;
			}
			guardLbl.visible = (tData.guard > 0);
			guardTLbl.visible = (tData.guard > 0);
			if(tData.guard > 0){
				beginY += 20;
				guardLbl.y = beginY;
				guardTLbl.y = beginY;
				guardLbl.text = "+"+tData.guard;
			}
			statusLbl.y = beginY + 20;
			var nid:int;
			var cnum:int = data.getTask(id).cNum;
			if(0 == cnum){
				if(0 == data.getTask(id).status){
					id = 4014;
				}else{
					progressLbl.text = tData.proMax +"/"+tData.proMax;
					id = 4016;
				}
			}else if(cnum > 0){
				id = 4015;
			}
			statusLbl.text = TableManager.getInstance().getSystemNotice(id).content;
			bgImg.setSize(this.width, statusLbl.y + 20 + 5);
		}
		
		public override function get height():Number{
			return bgImg.height;
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
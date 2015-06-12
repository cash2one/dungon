package com.leyou.ui.pet.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.ui.pet.PetAttributeUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class PetStarUpgradePage extends AutoSprite
	{
		private var cAttLbl:Label;
		
		private var nAttLbl:Label;
		
		private var cHpLbl:Label;
		
		private var nHpLbl:Label;
		
		private var cSpeedLbl:Label;
		
		private var nSpeedLbl:Label;
		
		private var cSmartLbl:Label;
		
		private var nSmartLbl:Label;
		
		private var cReviveLbl:Label;
		
		private var nReviveLbl:Label;
		
		private var costLbl:Label;
		
		private var cstars:Vector.<Image>;
		
		private var nstars:Vector.<Image>;
		
		private var grid:MarketGrid;
		
		private var costMoneyLbl:Label;
		
		private var lvUpBtn:NormalButton;
		
		private var petTId:int;
		
		public function PetStarUpgradePage(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventSX.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			cAttLbl = getUIbyID("cAttLbl") as Label;
			nAttLbl = getUIbyID("nAttLbl") as Label;
			cHpLbl = getUIbyID("cHpLbl") as Label;
			nHpLbl = getUIbyID("nHpLbl") as Label;
			cSpeedLbl = getUIbyID("cSpeedLbl") as Label;
			nSpeedLbl = getUIbyID("nSpeedLbl") as Label;
			cSmartLbl = getUIbyID("cSmartLbl") as Label;
			nSmartLbl = getUIbyID("nSmartLbl") as Label;
			cReviveLbl = getUIbyID("cReviveLbl") as Label;
			nReviveLbl = getUIbyID("nReviveLbl") as Label;
			lvUpBtn = getUIbyID("lvUpBtn") as NormalButton;
			costLbl = getUIbyID("costLbl") as Label;
			costMoneyLbl = getUIbyID("costMoneyLbl") as Label;
			var maxStar:int = ConfigEnum.servent9;
			cstars = new Vector.<Image>(maxStar);
			nstars = new Vector.<Image>(maxStar);
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = getUIbyID("cstar"+(n+1)+"Img") as Image;
				cstars[n] = star;
				star = getUIbyID("nstar"+(n+1)+"Img") as Image;
				nstars[n] = star;
			}
			
			grid = new MarketGrid();
			grid.isShowPrice = false;
			grid.x = 125 + 11;
			grid.y = 221 + 11;
			addChild(grid);
			addChild(costLbl);
			lvUpBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			Cmd_Pet.cm_PET_U(3, petTId);
		}
		
		private function setCStarLv(lv:int):void{
			var maxStar:int = ConfigEnum.servent9;
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = cstars[n];
				if(lv >= (n+1)){
					star.filters = null;
				}else{
					star.filters = [FilterEnum.enable];
				}
			}
		}
		
		private function setNStarLv(lv:int):void{
			var maxStar:int = ConfigEnum.servent9;
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = nstars[n];
				if(lv >= (n+1)){
					star.filters = null;
				}else{
					star.filters = [FilterEnum.enable];
				}
			}
		}
		
		public function updateInfo($petTId:int):void{
			petTId = $petTId;
			var petEntry:PetEntryData = DataManager.getInstance().petData.getPetById(petTId);
			var level:int = 1;
			var starLv:int = 1;
			if(null != petEntry){
				level = petEntry.level;
				starLv = petEntry.starLv;
			}
			setCStarLv(starLv);
			setNStarLv(starLv+1);
			var cpetStarInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
			var npetStarInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv+1);
			
			var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(starLv, level);
			
			costMoneyLbl.text = npetStarInfo.money+"";
			cHpLbl.text = int(cpetStarInfo.hp*Math.pow(1.15, level/13) + petLvInfo.fixedAtt)+"";
			cAttLbl.text = int(cpetStarInfo.fixedAtt*Math.pow(1.05, level/3) + petLvInfo.fixedAtt)+"";
			cSpeedLbl.text = cpetStarInfo.attSpeed/1000+PropUtils.getStringById(2157);
			cSmartLbl.text = PetAttributeUtil.getSmartLv(cpetStarInfo.skillRate);
			cReviveLbl.text = (cpetStarInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			
			nHpLbl.text = int(npetStarInfo.hp*Math.pow(1.15, level/13) + petLvInfo.fixedAtt)+"";
			nAttLbl.text = int(npetStarInfo.fixedAtt*Math.pow(1.05, level/3) + petLvInfo.fixedAtt)+"";
			nSpeedLbl.text = npetStarInfo.attSpeed/1000+PropUtils.getStringById(2157);
			nSmartLbl.text = PetAttributeUtil.getSmartLv(npetStarInfo.skillRate);
			nReviveLbl.text = (npetStarInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			
			var rnum:int = MyInfoManager.getInstance().getBagItemNumById(npetStarInfo.item);
			grid.updataById(npetStarInfo.item);
			costLbl.text = rnum+"/"+npetStarInfo.itemNum;
		}
	}
}
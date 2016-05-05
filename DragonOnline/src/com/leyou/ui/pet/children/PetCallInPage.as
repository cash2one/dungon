package com.leyou.ui.pet.children
{
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.ZDLUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PetCallInPage extends AutoSprite
	{
		private var attLbl:Label;
		
		private var defenceLbl:Label;
		
		private var hpLbl:Label;
		
		private var critLbl:Label;
		
		private var hitLbl:Label;
		
		private var slayLbl:Label;
		
		private var tenacityLbl:Label;
		
		private var dodgeLbl:Label;
		
		private var guardLbl:Label;
		
		private var costLbl:Label;
		
		public var buyBtn:NormalButton;
		
		private var grid:MarketGrid;
		
		private var numV:RollNumWidget;
		
		private var petTId:int;

		private var petStarInfo:TPetStarInfo;
		
		public function PetCallInPage(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventZM.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			attLbl = getUIbyID("attLbl") as Label;
			defenceLbl = getUIbyID("defenceLbl") as Label;
			hpLbl = getUIbyID("hpLbl") as Label;
			critLbl = getUIbyID("critLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			slayLbl = getUIbyID("slayLbl") as Label;
			tenacityLbl = getUIbyID("tenacityLbl") as Label;
			dodgeLbl = getUIbyID("dodgeLbl") as Label;
			guardLbl = getUIbyID("guardLbl") as Label;
			costLbl = getUIbyID("costLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			grid = new MarketGrid();
			grid.isShowPrice = false;
			grid.x = 125 + 11;
			grid.y = 258 + 11;
			addChild(grid);
			addChild(costLbl);
			
			numV = new RollNumWidget();
			numV.loadSource("ui/num/{num}_lz.png");
			numV.alignRound();
			numV.x = 154+15;
			numV.y = 154;
			addChild(numV);
			
			var tlabel:Label = getUIbyID("attLbl4") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("defLbl5") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("lifeLbl1") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("critLbl8") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("hitLbl10") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("slayLbl12") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("tenacityLbl9") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("dodgeLbl11") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("guardLbl13") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
		}
		
		protected function onTipsOver(event:MouseEvent):void{
			var codeStr:String = event.target.name;
			codeStr = codeStr.match(/\d+/)[0];
			var str:String = TableManager.getInstance().getSystemNotice(9500 + int(codeStr)).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "buyBtn":
//					GuideManager.getInstance().removeGuide(123);
					Cmd_Pet.cm_PET_E(petTId);
					var rnum:int = MyInfoManager.getInstance().getBagItemNumById(petStarInfo.item);
					var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petTId);
					if(rnum < petInfo.itemCount){
						UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
						UIManager.getInstance().quickBuyWnd.pushItem(petStarInfo.item, petStarInfo.item);
					}
					break;
			}
		}
		
		public function updateInfo($petTId:int):void{
			petTId = $petTId;
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petTId);
			var petEntry:PetEntryData = DataManager.getInstance().petData.getPetById(petTId);
			var qmdLv:int = 1;
			var starLv:int = 1;
			if(null != petEntry){
				qmdLv = petEntry.qmdLv;
				starLv = petEntry.starLv;
			}
			
			var rate:Number = Math.pow((10000 + ConfigEnum.servent20)/10000, (qmdLv-1));
			attLbl.text = int(petInfo.phyAtt*rate)+"";
			defenceLbl.text = int(petInfo.phyDef*rate)+"";
			hpLbl.text = int(petInfo.hp*rate)+"";
			critLbl.text = int(petInfo.crit*rate)+"";
			hitLbl.text = int(petInfo.hit*rate)+"";
			slayLbl.text = int(petInfo.slay*rate)+"";
			tenacityLbl.text = int(petInfo.tenacity*rate)+"";
			dodgeLbl.text = int(petInfo.dodge*rate)+"";
			guardLbl.text = int(petInfo.guard*rate)+"";
			
			var zdlNum:int = int(ZDLUtil.computation(petInfo.hp, 0, petInfo.phyAtt, petInfo.phyDef, petInfo.magicAtt, petInfo.magicDef, petInfo.crit, petInfo.tenacity, petInfo.hit, petInfo.dodge, petInfo.slay, petInfo.guard, petInfo.fixedAtt, petInfo.fixedDef)*Math.pow((10000 + ConfigEnum.servent20)/10000, (qmdLv-1)));
			numV.setNum(zdlNum);
			
			petStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
			var rnum:int = MyInfoManager.getInstance().getBagItemNumById(petStarInfo.item);
			grid.updateInfoII(petInfo.activeItem, /*petInfo.itemCount*/0);
			costLbl.text = rnum+"/"+petInfo.itemCount;
		}
	}
}
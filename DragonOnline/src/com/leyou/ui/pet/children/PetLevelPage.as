package com.leyou.ui.pet.children {
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;

	public class PetLevelPage extends AutoSprite {
		private var progressLbl:Label;

		private var progressCImg:ScaleBitmap;

		private var lvLbl:Label;

		private var nLvLbl:Label;

		private var attLbl:Label;

		private var nAttLbl:Label;

		private var hpLbl:Label;

		private var nHpLbl:Label;

		private var reviveLbl:Label;

		private var nReviveLbl:Label;

		private var taskLbl:Label;

		private var rewardLbl:Label;

		private var costLbl:Label;

		private var receiveBtn:NormalButton;

		private var numInput:TextInput;

		private var maxNumBtn:NormalButton;

		private var useBtn:NormalButton;

		private var grid:MarketGrid;

		private var petTId:int

		public function PetLevelPage() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventDJ.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			progressLbl=getUIbyID("progressLbl") as Label;
			progressCImg=getUIbyID("progressCImg") as ScaleBitmap;
			lvLbl=getUIbyID("lvLbl") as Label;
			nLvLbl=getUIbyID("nLvLbl") as Label;
			attLbl=getUIbyID("attLbl") as Label;
			nAttLbl=getUIbyID("nAttLbl") as Label;
			hpLbl=getUIbyID("hpLbl") as Label;
			nHpLbl=getUIbyID("nHpLbl") as Label;
			reviveLbl=getUIbyID("reviveLbl") as Label;
			nReviveLbl=getUIbyID("nReviveLbl") as Label;
			taskLbl=getUIbyID("taskLbl") as Label;
			rewardLbl=getUIbyID("rewardLbl") as Label;
			costLbl=getUIbyID("costLbl") as Label;
			receiveBtn=getUIbyID("receiveBtn") as NormalButton;
			numInput=getUIbyID("numInput") as TextInput;
			maxNumBtn=getUIbyID("maxNumBtn") as NormalButton;
			useBtn=getUIbyID("useBtn") as NormalButton;
			grid=new MarketGrid();
			grid.x=24;
			grid.y=306;
			addChild(grid);
			grid.updataById(ConfigEnum.servent12.split(",")[0]);
			numInput.text="1";

			var style:StyleSheet=new StyleSheet()
			var aHover:Object=new Object();
			aHover.color="#ff0000";
			style.setStyle("a:hover", aHover);
			taskLbl.styleSheet=style;
			taskLbl.mouseEnabled=true;
			taskLbl.addEventListener(MouseEvent.CLICK, onMouseClick);

			useBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			maxNumBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "taskLbl":
					Cmd_Pet.cm_PET_A(1, petTId);
					break;
				case "useBtn":
					Cmd_Pet.cm_PET_U(1, petTId, int(numInput.text));
					break;
				case "receiveBtn":
					Cmd_Pet.cm_PET_A(1, petTId);
					break;
				case "maxNumBtn":
					var num1:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.servent12.split(",")[0]);
					var num2:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.servent12.split(",")[1]);
					var num:int=num1 + num2;
					numInput.text=((num > 0) ? num + "" : "1");
					break;
			}
		}

		public function updateInfo($petTId:int):void {
			petTId=$petTId;
			var level:int=1;
			var starLv:int=1;
			var cExp:int=0;
			var petEntry:PetEntryData=DataManager.getInstance().petData.getPetById(petTId);
			if (null != petEntry) {
				level=petEntry.level;
				starLv=petEntry.starLv;
				cExp=petEntry.exp;
			}
			
			var petStarInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
			
			var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(starLv, level);
			var nPetLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(starLv, level+1);
			progressLbl.text = cExp + "/" + nPetLvInfo.exp;
			progressCImg.scrollRect = new Rectangle(0, 0, 326*cExp/nPetLvInfo.exp, 18);
			lvLbl.text = level+"";
			nLvLbl.text = (level+1)+"";
			
			attLbl.text = int(petStarInfo.hp*Math.pow(1.15, level/13) + petLvInfo.fixedAtt)+"";
			nAttLbl.text = int(petStarInfo.hp*Math.pow(1.15, level/13) + nPetLvInfo.fixedAtt)+"";
			hpLbl.text = int(petStarInfo.fixedAtt*Math.pow(1.05, level/3) + petLvInfo.fixedAtt)+"";
			nHpLbl.text = int(petStarInfo.fixedAtt*Math.pow(1.05, level/3) + nPetLvInfo.fixedAtt)+"";
			reviveLbl.text = (petStarInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			nReviveLbl.text = (petStarInfo.revive+nPetLvInfo.revive)+PropUtils.getStringById(2146);
			
			var petData:PetData = DataManager.getInstance().petData;
			var taskId:int = petData.lvTaskId;
			if(taskId <= 0){
 
				return;
			}
 
			var petTaskInfo:TMissionDate = TableManager.getInstance().getMissionDataByID(taskId);
			var text:String = petTaskInfo.monster_name+"("+petData.lvPogress+"/"+petTaskInfo.monster_num+")";
			text = StringUtil_II.addEventString(text, text, true);
			taskLbl.htmlText = StringUtil_II.getColorStr(text, "#ff00");
			rewardLbl.text = PropUtils.getStringById(2154)+ConfigEnum.servent10;
			costLbl.text = ConfigEnum.servent11+"";
			
			if((0 == petData.lvPetId) || (petData.lvPetId != petTId)){
				receiveBtn.setActive(true, 1, true);
				receiveBtn.text = PropUtils.getStringById(1891);
			}else{
				receiveBtn.text = PropUtils.getStringById(1892);
				receiveBtn.setActive((1 == petData.lvTaskStatus), 1, true);
			}
		}
	}
}

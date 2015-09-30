package com.leyou.ui.pet.children {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
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

		private var petTId:int;
		
		private var finishedImg:Image;
		
		private var nextLbl:Label;

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
			nextLbl=getUIbyID("nextLbl") as Label;
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
			finishedImg=getUIbyID("finishedImg") as Image;
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
			
			var tlabel:Label = getUIbyID("lv6801Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("att6803Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("hp6804Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("call6807Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			EventManager.getInstance().addEvent("petLvUp", onLevelUp);
		}
		
		private function onLevelUp(pid:int):void{
			UIManager.getInstance().petWnd.playLvUpEffect(2);
		}
		
		protected function onTipsOver(event:MouseEvent):void{
			var codeStr:String = event.target.name;
			codeStr = codeStr.match(/\d+/)[0];
			var str:String = TableManager.getInstance().getSystemNotice(int(codeStr)).content;
			str = StringUtil.substitute(str, ConfigEnum.servent2);
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			var petData:PetData = DataManager.getInstance().petData;
			switch (event.target.name) {
				case "taskLbl":
					var petTaskInfo:TMissionDate = TableManager.getInstance().getMissionDataByID(petData.lvTaskId);
					var pt:TPointInfo = TableManager.getInstance().getPointInfo(petTaskInfo.target_point);
					Core.me.gotoMap(new Point(pt.tx, pt.ty), pt.sceneId, true);
//					Cmd_Pet.cm_PET_A(1, petTId);
					break;
				case "useBtn":
					Cmd_Pet.cm_PET_U(1, petTId, int(numInput.text));
					break;
				case "receiveBtn":
					if((petData.lvPetId == petTId) && (1 == petData.lvTaskStatus)){
						Cmd_Pet.cm_PET_D(1);
					}else{
						Cmd_Pet.cm_PET_A(1, petTId);
					}
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
			progressLbl.text = cExp + "/" + petLvInfo.exp;
			progressCImg.scrollRect = new Rectangle(0, 0, 326*cExp/petLvInfo.exp, 18);
			lvLbl.text = level+"";
			nLvLbl.text = (level+1)+"";
			
			attLbl.text = int(petStarInfo.fixedAtt + petLvInfo.fixedAtt)+"";
			hpLbl.text = int(petStarInfo.hp + petLvInfo.hp)+"";
			reviveLbl.text = (petStarInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			if(level < ConfigEnum.servent15){
				nHpLbl.text = int(petStarInfo.hp + nPetLvInfo.hp)+"";
				nAttLbl.text = int(petStarInfo.fixedAtt + nPetLvInfo.fixedAtt)+"";
				nReviveLbl.text = (petStarInfo.revive+nPetLvInfo.revive)+PropUtils.getStringById(2146);
				nextLbl.visible = true;
				nLvLbl.visible = true;
				nAttLbl.visible = true;
				nHpLbl.visible = true;
				nReviveLbl.visible = true;
			}else{
				nextLbl.visible = false;
				nLvLbl.visible = false;
				nAttLbl.visible = false;
				nHpLbl.visible = false;
				nReviveLbl.visible = false;
			}
			
			var petData:PetData = DataManager.getInstance().petData;
			var taskId:int = petData.lvTaskId;
			if(taskId <= 0){
				finishedImg.visible = false;
				return;
			}
 
			var petTaskInfo:TMissionDate = TableManager.getInstance().getMissionDataByID(taskId);
			var text:String = petTaskInfo.monster_name+"("+petData.lvPogress+"/"+petTaskInfo.monster_num+")";
			text = StringUtil_II.addEventString(text, text, true);
			taskLbl.htmlText = StringUtil_II.getColorStr(text, "#ff00");
			rewardLbl.text = PropUtils.getStringById(2154)+ConfigEnum.servent10;
			costLbl.text = ConfigEnum.servent11+"";
			finishedImg.visible = petEntry.lvMissionComplete;
			
			if((0 == petData.lvPetId) || (petData.lvPetId != petTId)){
				receiveBtn.setActive(true, 1, true);
				receiveBtn.text = PropUtils.getStringById(1891);
			}else{
				receiveBtn.text = PropUtils.getStringById(1892);
				receiveBtn.setActive((1 == petData.lvTaskStatus), 1, true);
			}
			if(petEntry.lvMissionComplete){
				receiveBtn.setActive(false, 1, true);
			}
		}
	}
}

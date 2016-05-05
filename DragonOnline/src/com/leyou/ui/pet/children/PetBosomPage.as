package com.leyou.ui.pet.children {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPetFriendlyInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
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
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;

	public class PetBosomPage extends AutoSprite {
		private var progressLbl:Label;

		private var progressCImg:ScaleBitmap;

		private var qmdLbl:Label;

		private var cQmdLbl:Label;

		private var nQmdLbl:Label;

		private var cAddLbl:Label;

		private var nAddLbl:Label;

		private var cAddAttLbl:Label;

		private var nAddAttLbl:Label;

		private var taskLbl:Label;

		private var rewardLbl:Label;

		private var costLbl:Label;

		private var receiveBtn:NormalButton;

		private var numInput:TextInput;

		private var maxNumBtn:NormalButton;

		private var useBtn:NormalButton;

		private var petTId:int;
		private var petTId2:int;

		private var grid:MarketGrid;

		private var finishedImg:Image;

		private var nextLbl:Label;
		private var qmdLevel:int;
		private var qmdCount:int;

		public function PetBosomPage() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventQM.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			progressLbl=getUIbyID("progressLbl") as Label;
			progressCImg=getUIbyID("progressCImg") as ScaleBitmap;
			qmdLbl=getUIbyID("qmdLbl") as Label;
			cQmdLbl=getUIbyID("cQmdLbl") as Label;
			nQmdLbl=getUIbyID("nQmdLbl") as Label;
			cAddLbl=getUIbyID("cAddLbl") as Label;
			nAddLbl=getUIbyID("nAddLbl") as Label;
			nextLbl=getUIbyID("nextLbl") as Label;
			cAddAttLbl=getUIbyID("cAddAttLbl") as Label;
			nAddAttLbl=getUIbyID("nAddAttLbl") as Label;
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
			grid.updataById(ConfigEnum.servent18.split(",")[0]);
			numInput.text="1";

			var style:StyleSheet=new StyleSheet()
			var aHover:Object=new Object();
			aHover.color="#ff0000";
			style.setStyle("a:hover", aHover);
			taskLbl.styleSheet=style;
			taskLbl.mouseEnabled=true;
			taskLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			maxNumBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			useBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var tlabel:Label=getUIbyID("qm6802Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			EventManager.getInstance().addEvent("petQmLvUp", onQmLvUp);
		}

		private function onQmLvUp(id:int):void {
			UIManager.getInstance().petWnd.playLvUpEffect(3);
		}

		protected function onTipsOver(event:MouseEvent):void {
			var codeStr:String=event.target.name;
			codeStr=codeStr.match(/\d+/)[0];
			var str:String=TableManager.getInstance().getSystemNotice(int(codeStr)).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			var petData:PetData=DataManager.getInstance().petData;
			switch (event.target.name) {
				case "taskLbl":
					var petTaskInfo:TMissionDate=TableManager.getInstance().getMissionDataByID(petData.qmdTaskId);
					var pt:TPointInfo=TableManager.getInstance().getPointInfo(petTaskInfo.target_point);
					Core.me.gotoMap(new Point(pt.tx, pt.ty), pt.sceneId, true);
//					Cmd_Pet.cm_PET_A(2, petTId);
					break;
				case "receiveBtn":
					if ((petData.qmdPetId == petTId) && (1 == petData.qmdTaskStatus)) {
						Cmd_Pet.cm_PET_D(2);
					} else {
						Cmd_Pet.cm_PET_A(2, petTId);
					}
					break;
				case "maxNumBtn":
					var num1:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.servent18.split(",")[0]);
					var num2:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.servent18.split(",")[1]);
					var num:int=num1 + num2;
					numInput.text=((num > 0) ? num + "" : "1");
					break;
				case "useBtn":
					Cmd_Pet.cm_PET_U(2, petTId, int(numInput.text));
					var itemId:int=ConfigEnum.servent18.split(",")[0];
					var rnum:int=MyInfoManager.getInstance().getBagItemNumById(itemId);
					if (rnum < int(numInput.text)) {
						UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
						UIManager.getInstance().quickBuyWnd.pushItem(itemId, itemId);
					}
					break;
			}
		}

		public function updateInfo($petTId:int):void {
			petTId=$petTId;
			var petInfo:TPetInfo=TableManager.getInstance().getPetInfo(petTId);
			var petEntry:PetEntryData=DataManager.getInstance().petData.getPetById(petTId);
			var qmd:int=0;
			var qmdLv:int=1;
			if (null != petEntry) {


//				if (this.petTId2 != 0 && this.petTId2 == petTId && qmdLevel != 0 && qmdLevel != petEntry.qmdLv) {
				if (this.petTId2 != 0 && this.petTId2 == petTId && this.qmdCount != 0 && this.qmdCount != petEntry.qmd) {
					var pinfo:TPetInfo=TableManager.getInstance().getPetInfo(petTId);
					SoundManager.getInstance().play(pinfo.sound4);
				}

				this.qmdCount=qmd=petEntry.qmd;
				this.qmdLevel=qmdLv=petEntry.qmdLv;
			}

			this.petTId2=petTId;

			var petQmInfo:TPetFriendlyInfo=TableManager.getInstance().getPetFriendlyInfo(qmdLv);
			progressLbl.text=qmd + "/" + petQmInfo.friendlyNum;
			progressCImg.scrollRect=new Rectangle(0, 0, 326 * qmd / petQmInfo.friendlyNum, 18);
			qmdLbl.text=qmdLv + "";
			cQmdLbl.text=qmdLv + "";
			nQmdLbl.text=(qmdLv + 1) + "";
			var crate:Number=Math.pow((10000 + ConfigEnum.servent20) / 10000, qmdLv) - 1;
			var nrate:Number=Math.pow((10000 + ConfigEnum.servent20) / 10000, qmdLv + 1) - 1;
			cAddLbl.text=StringUtil.substitute("+{1}%", int(crate * 100));
			nAddLbl.text=StringUtil.substitute("+{1}%", int(nrate * 100));
			cAddAttLbl.text="" + int(ZDLUtil.computation(petInfo.hp, 0, petInfo.phyAtt, petInfo.phyDef, petInfo.magicAtt, petInfo.magicDef, petInfo.crit, petInfo.tenacity, petInfo.hit, petInfo.dodge, petInfo.slay, petInfo.guard, petInfo.fixedAtt, petInfo.fixedDef) * Math.pow((10000 + ConfigEnum.servent20) / 10000, (qmdLv - 1)));
			nAddAttLbl.text="" + int(ZDLUtil.computation(petInfo.hp, 0, petInfo.phyAtt, petInfo.phyDef, petInfo.magicAtt, petInfo.magicDef, petInfo.crit, petInfo.tenacity, petInfo.hit, petInfo.dodge, petInfo.slay, petInfo.guard, petInfo.fixedAtt, petInfo.fixedDef) * Math.pow((10000 + ConfigEnum.servent20) / 10000, qmdLv));
			if (qmdLv >= ConfigEnum.servent23) {
				nextLbl.visible=false;
				nQmdLbl.visible=false;
				nAddLbl.visible=false;
				nAddAttLbl.visible=false;
			} else {
				nextLbl.visible=true;
				nQmdLbl.visible=true;
				nAddLbl.visible=true;
				nAddAttLbl.visible=true;
			}

			var petData:PetData=DataManager.getInstance().petData;
			var taskId:int=petData.qmdTaskId;
			if (taskId <= 0) {
				finishedImg.visible=false;
				return;
			}

			var petTaskInfo:TMissionDate=TableManager.getInstance().getMissionDataByID(taskId);
			var text:String=petTaskInfo.monster_name + "(" + petData.qmdPogress + "/" + petTaskInfo.monster_num + ")";
			text=StringUtil_II.addEventString(text, text, true);
			taskLbl.htmlText=StringUtil_II.getColorStr(text, "#ff00");
			rewardLbl.text=PropUtils.getStringById(2149) + ConfigEnum.servent16;
			costLbl.text=ConfigEnum.servent17 + "";
			finishedImg.visible=petEntry.qmMissionComplete;

			if ((0 == petData.qmdPetId) || (petData.qmdPetId != petTId)) {
				receiveBtn.setActive(true, 1, true);
				receiveBtn.text=PropUtils.getStringById(1891);
			} else {
				receiveBtn.text=PropUtils.getStringById(1892);
				receiveBtn.setActive((1 == petData.qmdTaskStatus), 1, true);
			}

			if (petEntry.qmMissionComplete) {
				receiveBtn.setActive(false, 1, true);
			}
		}
	}
}

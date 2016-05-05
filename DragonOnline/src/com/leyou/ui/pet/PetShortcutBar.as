package com.leyou.ui.pet {
	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.pet.children.PetHeadGrid;
	import com.leyou.ui.pet.children.PetIconGird;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class PetShortcutBar extends AutoSprite {
		private static const ICON_NUM:int=3;

		private var icons:Vector.<PetHeadGrid>;

		private var currentIcon:PetHeadGrid;

		public function PetShortcutBar() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventBar.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			icons=new Vector.<PetHeadGrid>();
			for (var n:int=0; n < ICON_NUM; n++) {
				var picon:PetHeadGrid=new PetHeadGrid();
				picon.x=n * 43;
				addChild(picon);
				icons.push(picon);
				picon.addEventListener(MouseEvent.CLICK, onMouseClick);
				if (0 == n) {
					picon.updateKeyImg("q");
				} else if (1 == n) {
					picon.updateKeyImg("w");
				} else if (2 == n) {
					picon.updateKeyImg("e");
				}
			}
			hide();
			KeysManager.getInstance().addKeyFun(Keyboard.Q, onKeyDown, KeyboardEvent.KEY_DOWN);
			KeysManager.getInstance().addKeyFun(Keyboard.W, onKeyDown, KeyboardEvent.KEY_DOWN);
			KeysManager.getInstance().addKeyFun(Keyboard.E, onKeyDown, KeyboardEvent.KEY_DOWN);
			KeysManager.getInstance().addKeyFun(Keyboard.Q, onKeyUp, KeyboardEvent.KEY_UP);
			KeysManager.getInstance().addKeyFun(Keyboard.W, onKeyUp, KeyboardEvent.KEY_UP);
			KeysManager.getInstance().addKeyFun(Keyboard.E, onKeyUp, KeyboardEvent.KEY_UP);
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if (Core.me.info.level < ConfigEnum.servent1) {
				return;
			}
			var petGrid:PetHeadGrid;
			var code:uint=event.keyCode;
			switch (code) {
				case Keyboard.Q:
					petGrid=icons[0];
					break;
				case Keyboard.W:
					petGrid=icons[1];
					break;
				case Keyboard.E:
					petGrid=icons[2];
					break;
			}
			if (petGrid.isDown && petGrid.dataId <= 0) {
				return;
			}
			petGrid.iconDown();
			;
		}

		private function onKeyUp(event:KeyboardEvent):void {
			if (Core.me.info.level < ConfigEnum.servent1) {
				return;
			}
			var petGrid:PetHeadGrid;
			var code:uint=event.keyCode;
			switch (code) {
				case Keyboard.Q:
					petGrid=icons[0];
					break;
				case Keyboard.W:
					petGrid=icons[1];
					break;
				case Keyboard.E:
					petGrid=icons[2];
					break;
			}
			if (!petGrid.isDown && petGrid.dataId <= 0) {
				return;
			}
			petGrid.iconUp();
			callPet(petGrid.content);
		}

		private function callPet(petGrid:PetIconGird):void {
			if (!petGrid.isCDOver()) {
				return;
			}
//			if(petGrid.dataId == DataManager.getInstance().petData.currentPetId){
//				Cmd_Pet.cm_PET_B(petGrid.dataId);
//			}else{
			var petData:PetEntryData=DataManager.getInstance().petData.getPetById(petGrid.dataId);
//				var petStarLvInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petData.id, petData.starLv);
//				var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(petData.starLv, petData.level);
//				var cdt:int = petStarLvInfo.revive+petLvInfo.revive;
//				petGrid.playCD(cdt*1000);
			Cmd_Pet.cm_PET_C(petGrid.dataId);
//			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			if (event.target is ImgButton) {
				Cmd_Pet.cm_PET_L();
				UIManager.getInstance().creatWindow(WindowEnum.PET_SELECT);
				UIManager.getInstance().petSelectWnd.show();
				UIManager.getInstance().petSelectWnd.resize();
				currentIcon=event.target.parent;
			} else {
				if (event.target is PetIconGird) {
					if (event.target.dataId > 0) {
						var petGrid:PetIconGird=event.target as PetIconGird;
						callPet(petGrid);
//						if(!petGrid.isCDOver()){
//							return;
//						}
//						if(event.target.dataId == DataManager.getInstance().petData.currentPetId){
//							Cmd_Pet.cm_PET_B(event.target.dataId);
//						}else{
//							var petData:PetEntryData = DataManager.getInstance().petData.getPetById(event.target.dataId);
//							var petStarLvInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petData.id, petData.starLv);
//							var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(petData.starLv, petData.level);
//							var cdt:int = petStarLvInfo.revive+petLvInfo.revive;
//							petGrid.playCD(cdt*1000);
//							Cmd_Pet.cm_PET_C(event.target.dataId);
//						}
					}
				}
			}

		}

		public function updateCurrentGrid(petId:int):void {
			if (currentIcon.dataId == petId) {
				return;
			}
			var petData:PetEntryData=DataManager.getInstance().petData.getPetById(petId);
			var petStarLvInfo:TPetStarInfo=TableManager.getInstance().getPetStarLvInfo(petData.id, petData.starLv);
			var petLvInfo:TPetAttackInfo=TableManager.getInstance().getPetLvInfo(petData.starLv, petData.level);
			var cdt:int=petStarLvInfo.revive + petLvInfo.revive;
			currentIcon.updatePet(petId);
			if (petData.callt <= 0) {
				currentIcon.playCD(0, 0);
			} else {
				currentIcon.playCD(cdt * 1000, (cdt - petData.callt) * 1000);
			}
			var pos:int=icons.indexOf(currentIcon) + 1;
			Cmd_Pet.cm_PET_K(petId, pos);
		}

		public function updateInfo():void {
			var data:PetData=DataManager.getInstance().petData;
			var length:int=icons.length;
			for (var n:int=0; n < length; n++) {
				var petGrid:PetHeadGrid=icons[n];
				var petInfo:PetEntryData=data.getShortcutPet(n);
				if (0 != petInfo.id) {
					petGrid.updatePet(petInfo.id);
					var petStarLvInfo:TPetStarInfo=TableManager.getInstance().getPetStarLvInfo(petInfo.id, petInfo.starLv);
					var petLvInfo:TPetAttackInfo=TableManager.getInstance().getPetLvInfo(petInfo.starLv, petInfo.level);
					var cdt:int=petStarLvInfo.revive + petLvInfo.revive;
					if (petInfo.callt <= 0) {
						petGrid.playCD(0, 0);
					} else {
						petGrid.playCD(cdt * 1000, (cdt - petInfo.callt) * 1000);
					}
				} else {
					petGrid.clearGrid();
				}
			}
		}

		public function updateFightPet():void {
			var petId:int=DataManager.getInstance().petData.currentPetId;
			var length:int=icons.length;
			for (var n:int=0; n < length; n++) {
				var petGrid:PetHeadGrid=icons[n];
				if ((0 != petId) && (petGrid.dataId == petId)) {
					petGrid.playEffect(ConfigEnum.servent24);
				} else {
					petGrid.stopEffect();
				}
			}
		}

		public function removeFightPet():void {
			var length:int=icons.length;
			for (var n:int=0; n < length; n++) {
				icons[n].stopEffect();
			}
		}

		public function resize():void {
			x=UIEnum.WIDTH / 2 - 355;
			y=UIEnum.HEIGHT - 102;
		}

		public function checkActive():void {
			if (ConfigEnum.servent1 <= Core.me.info.level) {
				show();
			} else {
				hide();
			}
		}
	}
}

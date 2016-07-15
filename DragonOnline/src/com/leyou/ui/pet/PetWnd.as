package com.leyou.ui.pet {

	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetFriendlyInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.pet.children.PetBosomPage;
	import com.leyou.ui.pet.children.PetCallInPage;
	import com.leyou.ui.pet.children.PetDetailRender;
	import com.leyou.ui.pet.children.PetImgRender;
	import com.leyou.ui.pet.children.PetLevelPage;
	import com.leyou.ui.pet.children.PetListRender;
	import com.leyou.ui.pet.children.PetSkillPage;
	import com.leyou.ui.pet.children.PetStarUpgradePage;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PetWnd extends AutoWindow {

		private var petBar:TabBar;

		private var myPetRBtn:RadioButton;

		private var allPetRBtn:RadioButton;

		// 宠物列表
		private var petListPanel:ScrollPane;

		// 宠物影像
		private var petImg:PetImgRender;

		// 宠物信息
		private var petDetail:PetDetailRender;

		// 宠物招募页
		private var petCallPage:PetCallInPage;

		// 宠物升星页
		private var petStarPage:PetStarUpgradePage;

		// 宠物等级页
		private var petLevelPage:PetLevelPage;

		// 宠物亲密度
		private var petBosomPage:PetBosomPage;

		// 宠物技能
		private var petSkillPage:PetSkillPage;

		// 宠物列表项
		private var petList:Vector.<PetListRender>;

		// 当前选中项
		private var selectPet:PetListRender;

		public function PetWnd() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventWnd.xml"));
			init();
		}

		private function init():void {
			petBar=getUIbyID("petBar") as TabBar;
			myPetRBtn=getUIbyID("myPetRBtn") as RadioButton;
			allPetRBtn=getUIbyID("allPetRBtn") as RadioButton;
			petListPanel=getUIbyID("petList") as ScrollPane;
			allPetRBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			myPetRBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			// 宠物影像
			petImg=new PetImgRender();
			petImg.x=215;
			petImg.y=122;
			pane.addChild(petImg);
			petImg.regristerSwitch(onCardSwitch);
			// 宠物信息
			petDetail=new PetDetailRender();
			petDetail.x=215;
			petDetail.y=122;
			pane.addChild(petDetail);
			petDetail.regristerSwitch(onCardSwitch);
			petDetail.visible=false;
			// 宠物招募
			petCallPage=new PetCallInPage();
			petCallPage.x=303;
			// 宠物升星
			petStarPage=new PetStarUpgradePage();
			petStarPage.x=303;
			// 宠物等级
			petLevelPage=new PetLevelPage();
			petLevelPage.x=303;
			// 宠物亲密度
			petBosomPage=new PetBosomPage();
			petBosomPage.x=303;
			// 宠物技能
			petSkillPage=new PetSkillPage();
			petSkillPage.x=303;

			petBar.addToTab(petCallPage, 0);
			petBar.addToTab(petStarPage, 1);
			petBar.addToTab(petLevelPage, 2);
			petBar.addToTab(petBosomPage, 3);
			petBar.addToTab(petSkillPage, 4);
			petBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			allPetRBtn.turnOn(false);
			// 加载所有宠物
			initAllPet();
		}

		protected function onTabChange(event:Event):void {
			if ((2 == petBar.turnOnIndex) || (3 == petBar.turnOnIndex)) {
				Cmd_Pet.cm_PET_T();
			}

			if (selectPet != null)
				showPetPage(selectPet.petTId);
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			if ((2 == petBar.turnOnIndex) || (3 == petBar.turnOnIndex)) {
				Cmd_Pet.cm_PET_T();
			}
			selectItem(petList[0]);

			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 73)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);
		}

		private function autoTaskComplete():void {
			if (this.visible) {
				 this.petCallPage.dispAutoEvent();
			}
		}

		public override function hide():void {
			super.hide();
			selectPet=null;
//			GuideManager.getInstance().removeGuide(123);
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("mercenaryBtn"));
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "allPetRBtn":
					initAllPet();
					break;
				case "myPetRBtn":
					initMyPet();
					break;
			}
		}

		public function playLvUpEffect(type:int):void {
			switch (type) {
				case 1:
					petImg.palyStarLvUpEffect();
					break;
				case 2:
					petImg.palyLvUpEffect();
					break;
				case 3:
					petImg.palyQmLvUpEffect();
					break;
			}
		}

		private function initAllPet():void {
			clearPetListPanel();
			var index:int=0;
			petList=new Vector.<PetListRender>();
			var petDic:Object=TableManager.getInstance().getPetDic();
			for (var key:String in petDic) {
				var petInfo:TPetInfo=petDic[key];
				if (null != petInfo && petInfo.visible) {

					try {
						var petRender:PetListRender=petList[index];
					} catch (error:RangeError) {
						petRender=new PetListRender();
						petList[index]=petRender;
					}

					var data:PetData=DataManager.getInstance().petData;
					petRender.addEventListener(MouseEvent.CLICK, onItemClick);
					petRender.updateByTable(petInfo);
					petRender.y=80 * index;
					petListPanel.addToPane(petRender);
					index++;
					var petEntry:PetEntryData=data.getPetById(petInfo.id);
					if (null != petEntry) {
						petRender.updateByUserData(petEntry);
					}
				}
			}
			petListPanel.scrollTo(0);
			petListPanel.updateUI();
		}

		protected function onItemClick(event:MouseEvent):void {
			var item:PetListRender=event.target as PetListRender;
			selectItem(item);
		}

		private function selectItem(item:PetListRender):void {
			if (null != item) {
				if (null != selectPet) {
					selectPet.setSelection(false);

					var pinfo:TPetInfo=TableManager.getInstance().getPetInfo(item.petTId);
					SoundManager.getInstance().play(pinfo.sound2);
				}

				selectPet=item;
				selectPet.setSelection(true);
				showPetInfo(item.petTId);
			}
		}

		private function initMyPet():void {
			clearPetListPanel();

			var data:PetData=DataManager.getInstance().petData;
			var l:int=data.petListCount;
			for (var n:int=0; n < l; n++) {

				var petEntry:PetEntryData=data.getPetByIdx(n);
				if (null == petEntry)
					continue;

				var petInfo:TPetInfo=TableManager.getInstance().getPetInfo(petEntry.id);
				try {
					var petRender:PetListRender=petList[n];
				} catch (error:RangeError) {
					petRender=new PetListRender();
					petList[n]=petRender;
				}

				petRender.addEventListener(MouseEvent.CLICK, onItemClick);
				petRender.updateByTable(petInfo);
				petRender.updateByUserData(petEntry);
				petRender.y=80 * n;
				petListPanel.addToPane(petRender);

			}
			petListPanel.scrollTo(0);
			petListPanel.updateUI();
		}

		private function showPetInfo(petTId:int):void {
			if (DataManager.getInstance().petData.containsPet(petTId)) {
				var petEntryData:PetEntryData=DataManager.getInstance().petData.getPetById(petTId);
//				if(petEntryData.isInit){
//					showPetCard(petTId);
//					showPetPage(petTId);
//				}else{
				Cmd_Pet.cm_PET_I(petTId);
				Cmd_Pet.cm_PET_T();
//				}
				petBar.setTabVisible(0, false);
				petBar.setTabVisible(1, true);
				petBar.setTabVisible(2, true);
				petBar.setTabVisible(3, true);
				petBar.setTabVisible(4, true);

				var petEntry:PetEntryData=DataManager.getInstance().petData.getPetById(petTId);

				var npetStarInfo:TPetStarInfo=TableManager.getInstance().getPetStarLvInfo(petTId, petEntry.starLv + 1);
//				petBar.setTabActive(1, (null != npetStarInfo));

				var nPetLvInfo:TPetAttackInfo=TableManager.getInstance().getPetLvInfo(petEntry.starLv, petEntry.level + 1);
//				petBar.setTabActive(2, (null != nPetLvInfo));

				var petQmInfo:TPetFriendlyInfo=TableManager.getInstance().getPetFriendlyInfo(petEntry.qmdLv + 1);
//				petBar.setTabActive(3, (null != petQmInfo));

//				if(null != npetStarInfo){
//					petBar.turnToTab(1);
//				}else if(null != nPetLvInfo){
//					petBar.turnToTab(2);
//				}else if(null != petQmInfo){
//					petBar.turnToTab(3);
//				}else{
//					petBar.turnToTab(4);
//				}
				petBar.turnToTab(1);
			} else {
				petBar.turnToTab(0);
				petBar.setTabVisible(0, true);
				petBar.setTabVisible(1, false);
				petBar.setTabVisible(2, false);
				petBar.setTabVisible(3, false);
				petBar.setTabVisible(4, false);
				showPetCard(petTId);
				showPetPage(petTId);
			}
		}

		private function showPetPage(petTId:int):void {
			switch (petBar.turnOnIndex) {
				case 0:
					// 招募页
					petCallPage.updateInfo(petTId);
					break;
				case 1:
					// 星级页
					petStarPage.updateInfo(petTId);
					break;
				case 2:
					// 等级页
					petLevelPage.updateInfo(petTId);
					break;
				case 3:
					// 亲密度
					petBosomPage.updateInfo(petTId);
					break;
				case 4:
					// 技能页
					petSkillPage.updateInfo(petTId);
					break;
			}
		}

		private function showPetCard(petTId:int):void {
			if (petImg.visible) {
				petImg.updateInfo(petTId);
			}
			if (petDetail.visible) {
				petDetail.updateInfo(petTId);
			}
		}

		private function clearPetListPanel():void {
			for each (var petRender:PetListRender in petList) {
				if (null != petRender) {
					if (petRender.hasEventListener(MouseEvent.CLICK)) {
						petRender.removeEventListener(MouseEvent.CLICK, onItemClick);
					}
					if (petListPanel.contains(petRender)) {
						petListPanel.delFromPane(petRender);
					}
				}
			}
		}

		private function onCardSwitch(event:Event):void {
			switch (event.target.name) {
				case "detailLbl":
					petImg.visible=false;
					petDetail.visible=true;
					break;
				case "returnLbl":
					petImg.visible=true;
					petDetail.visible=false;
					break;
			}
			if (null == selectPet)
				return;
			showPetCard(selectPet.petTId);
		}

		public function updatePetList():void {
			var data:PetData=DataManager.getInstance().petData;
			var l:int=petList.length;
			for (var n:int=0; n < l; n++) {
				var petRender:PetListRender=petList[n];
				if ((null != petRender) && data.containsPet(petRender.petTId)) {
					petRender.updateByUserData(data.getPetById(petRender.petTId));
				}
			}
		}

		public function updateCallIn():void {
			showPetInfo(selectPet.petTId);
		}

		public function updatePetInfo():void {
			if (null == selectPet)
				return;
			showPetCard(selectPet.petTId);
			showPetPage(selectPet.petTId);
		}

		public function flyQmGift():void {
			petImg.flyQmGift();
		}

		public function selectPetItem(pid:int):void {

			for each (var petRender:PetListRender in petList) {
				if (null != petRender) {
					if ((pid == 0 && DataManager.getInstance().petData.containsPet(petRender.petTId)) || petRender.petTId == pid) { // || petRender.lvStatus != 2){
						selectItem(petRender);
					} else {
						petRender.setSelection(false);
					}
				}
			}
		}

		public function selectPetTabItem(i:int):void {
			if (petBar.getTabButton(i).visible)
				petBar.turnToTab(i);
		}

		public function updateLv(pid:int):void {

			for each (var petRender:PetListRender in petList) {
				if (null != petRender) {
					if ((pid == 0 && petRender.lvStatus != 2 && DataManager.getInstance().petData.containsPet(petRender.petTId)) || petRender.petTId == pid) { // || petRender.lvStatus != 2){
						selectItem(petRender);
						break;
					}
				}
			}

			TweenLite.delayedCall(0.5, petBar.turnToTab, [2]);
		}

		public function updateQmd(pid:int):void {

			for each (var petRender:PetListRender in petList) {
				if (null != petRender) {
					if ((pid == 0 && petRender.qmStatus != 2 && DataManager.getInstance().petData.containsPet(petRender.petTId)) || petRender.petTId == pid) { // || petRender.qmStatus != 2){
						selectItem(petRender);
						break;
					}
				}
			}

			TweenLite.delayedCall(0.5, petBar.turnToTab, [3]);
		}

		public function changeToIndex(i:int):void {
			this.petBar.turnToTab(i);
		}

		public function getBuyBtn():NormalButton {
			return this.petCallPage.buyBtn;
		}

		public override function get width():Number {
			return 898;
		}

		public override function get height():Number {
			return 544;
		}
	}
}

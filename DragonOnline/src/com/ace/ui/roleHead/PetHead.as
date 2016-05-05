package com.ace.ui.roleHead
{
	import com.ace.ICommon.ILivingHead;
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_Pet;
	
	import flash.events.MouseEvent;
	
	public class PetHead extends AutoSprite implements ILivingHead
	{
		private var headImg:Image;
		
		private var nameLbl:Label;
		
		private var elementImg:Image;
		
		private var hpImg:Image;
		
		private var hpLbl:Label;
		
		private var modeBtn:ImgButton;
		
		private var lvLbl:Label;
		
		public function PetHead(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventHeadWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			modeBtn = getUIbyID("modeBtn") as ImgButton;
			lvLbl = getUIbyID("lvLbl") as Label;
			headImg = getUIbyID("headImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			elementImg = getUIbyID("elementImg") as Image;
			hpImg = getUIbyID("hpImg") as Image;
			hpLbl = getUIbyID("hpLbl") as Label;
			hide();
			modeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			Cmd_Pet.cm_PET_B(DataManager.getInstance().petData.currentPetId);
		}
		
		public function addMyOwnPetEvent():void{
			EventManager.getInstance().addEvent(EventEnum.PET_ADD, onPetAdd);
			EventManager.getInstance().addEvent(EventEnum.PET_DEL, onPetDel);
			EventManager.getInstance().addEvent(EventEnum.PET_UPDATE_HP, updateHp);
		}
		
		private function updateHp():void{
			updataUI(Core.pet.info);
//			var petliving:LivingModel = Core.pet;
//			hpLbl.text = petliving.info.baseInfo.hp + "/" + petliving.info.baseInfo.maxHp;
//			hpImg.scaleX = petliving.info.baseInfo.hp / petliving.info.baseInfo.maxHp;
		}
		
		private function onPetDel():void{
			hide();
			DataManager.getInstance().petData.currentPetId = -1;
			UIManager.getInstance().petIconbar.removeFightPet();
		}
		
		private function onPetAdd():void{
			show();
			var petliving:LivingModel = Core.pet;
			DataManager.getInstance().petData.currentPetId = petliving.info.tId;
			updataUI(petliving.info);
//			nameLbl.text = StringUtil.substitute("LV{1}.{2}", petliving.info.level, petliving.ownerName);
//			hpLbl.text = petliving.info.baseInfo.hp + "/" + petliving.info.baseInfo.maxHp;
//			hpImg.scaleX = petliving.info.baseInfo.hp / petliving.info.baseInfo.maxHp;
//			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petliving.info.tId);
//			headImg.updateBmp("ui/servent/" + petInfo.headUrl);
//			switch (petliving.info.baseInfo.yuanS) {
//				case 0:
//					elementImg.visible=false;
//					break;
//				//0无元素 1金 2木 3水 4火 5土
//				case 1:
//					elementImg.updateBmp("ui/name/el_gold.png");
//					break;
//				case 2:
//					elementImg.updateBmp("ui/name/el_wood.png");
//					break;
//				case 3:
//					elementImg.updateBmp("ui/name/el_water.png");
//					break;
//				case 4:
//					elementImg.updateBmp("ui/name/el_fire.png");
//					break;
//				case 5:
//					elementImg.updateBmp("ui/name/el_dirt.png");
//					break;
//				default:
//					trace("error")
//					break;
//			}
			
			UIManager.getInstance().petIconbar.updateFightPet();
		}
		
		public function onResize($w:Number=0, $h:Number=0):void{
			this.x=500;
			this.y=20;
		}

		public function resize():void{
			y = 175;
		}
		
		public override function set visible(value:Boolean):void{
			super.visible = value;
		}
		
		public function updataHP($info:LivingInfo):void{
			hpLbl.text = $info.baseInfo.hp + "/" + $info.baseInfo.maxHp;
			hpImg.scaleX = $info.baseInfo.hp / $info.baseInfo.maxHp;
			
		}
		
		public function updataUI($info:LivingInfo):void{
			nameLbl.text = StringUtil.substitute("LV{1}.{2}", $info.level, $info.name);
			hpLbl.text = $info.baseInfo.hp + "/" + $info.baseInfo.maxHp;
			hpImg.scaleX = $info.baseInfo.hp / $info.baseInfo.maxHp;
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo($info.tId);
			headImg.updateBmp("ui/servent/" + petInfo.headUrl);
			var id:int = Core.me.info.id;
			modeBtn.visible = ($info.id == Core.me.info.petId);
			lvLbl.visible = ($info.id == Core.me.info.petId);
			switch ($info.baseInfo.yuanS) {
				case 0:
					elementImg.visible=false;
					break;
				//0无元素 1金 2木 3水 4火 5土
				case 1:
					elementImg.updateBmp("ui/name/el_gold.png");
					break;
				case 2:
					elementImg.updateBmp("ui/name/el_wood.png");
					break;
				case 3:
					elementImg.updateBmp("ui/name/el_water.png");
					break;
				case 4:
					elementImg.updateBmp("ui/name/el_fire.png");
					break;
				case 5:
					elementImg.updateBmp("ui/name/el_dirt.png");
					break;
				default:
					trace("error")
					break;
			}
		}
		
	}
}
package com.leyou.ui.pet.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.Living;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetSkillInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.setting.child.AssistSkillGrid;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.pet.PetAttributeUtil;
	import com.leyou.ui.tips.childs.TipsSkillGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class PetImgRender extends AutoSprite
	{
		private var qmdLbl:Label;
		
		private var nameLbl:Label;
		
		private var raceImg:Image;
		
		private var detailLbl:Label;
		
		private var usedBtn:NormalButton;
		
		private var stars:Vector.<Image>;
		
		private var switchMethod:Function;
		
		private var cpetId:int;
		
//		private var petMovie:SwfLoader;
//		
//		private var effectMovie:SwfLoader;
		
//		private var petAvatar:BigAvatar;
		private var living:Living;
		
		private var fInfo:FeatureInfo;

		private var grid1:AssistSkillGrid;

		private var grid2:AssistSkillGrid;

		private var grid3:AssistSkillGrid;

		private var grid4:AssistSkillGrid;

		private var grid5:AssistSkillGrid;

		private var grid6:AssistSkillGrid;
		
		private var bgImg:Image;
		
		private var leftBtn:ImgButton;
		
		private var rightBtn:ImgButton;
		
		private var dir:int = 3;
		
		private var giftBtn:ImgButton;
		
		public function PetImgRender(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventCard.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			bgImg = getUIbyID("bgImg") as Image;
			qmdLbl = getUIbyID("qmdLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			raceImg = getUIbyID("raceImg") as Image;
			detailLbl = getUIbyID("detailLbl") as Label;
			usedBtn = getUIbyID("usedBtn") as NormalButton;
			giftBtn = getUIbyID("giftBtn") as ImgButton;
			giftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			usedBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			var maxStar:int = ConfigEnum.servent9;
			stars = new Vector.<Image>(maxStar);
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = getUIbyID("star"+(n+1)+"Img") as Image;
				stars[n] = star;
			}
			
			var style:StyleSheet = new StyleSheet()
			var aHover:Object = new Object();
			aHover.color = "#ff0000";
			style.setStyle("a:hover", aHover);
			detailLbl.styleSheet = style;
			var text:String = detailLbl.text;
			detailLbl.mouseEnabled = true;
			detailLbl.htmlText = StringUtil_II.addEventString(text, text, true);
			detailLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
//			petMovie = new BigAvatar();
//			petMovie = new SwfLoader();
//			effectMovie = new SwfLoader();
//			addChild(effectMovie);
//			addChild(petMovie);
//			petMovie.x = 147;
//			petMovie.y = 225;
//			effectMovie.x = 147;
//			effectMovie.y = 225;
//			petAvatar = new BigAvatar();
//			petAvatar.x = 147;
//			petAvatar.y = 225;			
//			addChild(petAvatar);
			living = new Living();
			living.initData(LivingInfo.getDefaultInfo(PlayerEnum.RACE_PET), null, false);
			addChild(living);
			living.x = 147;
			living.y = 225;
			addChild(nameLbl);
			
			grid1 = new AssistSkillGrid();
			grid1.isPetSkill = true;
			addChild(grid1);
			grid1.x = 30;
			grid1.y = 349;
			grid1.width = 25;
			grid1.height = 25;
			
			grid2 = new AssistSkillGrid();
			grid2.isPetSkill = true;
			addChild(grid2);
			grid2.x = 60;
			grid2.y = 349;
			grid2.width = 25;
			grid2.height = 25;
			
			grid3 = new AssistSkillGrid();
			grid3.isPetSkill = true;
			addChild(grid3);
			grid3.x = 100;
			grid3.y = 349;
			grid3.width = 25;
			grid3.height = 25;
			
			grid4 = new AssistSkillGrid();
			grid4.isPetSkill = true;
			addChild(grid4);
			grid4.x = 128;
			grid4.y = 349;
			grid4.width = 25;
			grid4.height = 25;
			
			grid5 = new AssistSkillGrid();
			grid5.isPetSkill = true;
			addChild(grid5);
			grid5.x = 155;
			grid5.y = 349;
			grid5.width = 25;
			grid5.height = 25;
			
			grid6 = new AssistSkillGrid();
			grid6.isPetSkill = true;
			addChild(grid6);
			addChild(grid6);
			grid6.x = 183;
			grid6.y = 349;
			grid6.width = 25;
			grid6.height = 25;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "usedBtn":
					var petEntryData:PetEntryData = DataManager.getInstance().petData.getPetById(cpetId);
					if(0 == petEntryData.status){
						Cmd_Pet.cm_PET_C(cpetId)
					}else{
						Cmd_Pet.cm_PET_B(cpetId);
					}
					break;
				case "giftBtn":
					Cmd_Pet.cm_PET_G(cpetId);
					break;
				case "rightBtn":
					dir--;
					if(dir < 0){
						dir = 7;
					}
					living.playAct("stand", dir);
					break;
				case "leftBtn":
					dir++;
					if(dir > 8){
						dir = 0;
					}
					living.playAct("stand", dir);
					break;
			}
		}
		
		public function palyLvUpEffect():void{
			living.addEffect(ConfigEnum.servent30);
		}
		
		public function palyStarLvUpEffect():void{
			living.addEffect(ConfigEnum.servent31);
		}
		
		public function palyQmLvUpEffect():void{
			living.addEffect(ConfigEnum.servent32);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null != switchMethod){
				switchMethod.call(this, event);
			}
		}
		
		private function setStarLv(lv:int):void{
			var maxStar:int = ConfigEnum.servent9;
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = stars[n];
				if(lv >= (n+1)){
					star.filters = null;
				}else{
					star.filters = [FilterEnum.enable];
				}
			}
		}
		
		public function updateInfo(petTId:int):void{
			// 表格数据
			cpetId = petTId;
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petTId);
			nameLbl.text = petInfo.name;
			var raceUrl:String = PetAttributeUtil.getRaceUrl(petInfo.race);
			raceImg.updateBmp(raceUrl);
			
			bgImg.updateBmp("ui/servent/" + petInfo.foreBg);
			
			// 用户数据
			var starLv:int = 1;
			var sysId:int;
			var petEntry:PetEntryData = DataManager.getInstance().petData.getPetById(petTId);
			if(null != petEntry){
				qmdLbl.text = petEntry.qmdLv+"";
				setStarLv(petEntry.starLv);
				usedBtn.visible = true;
				usedBtn.text = (0 == petEntry.status ? PropUtils.getStringById(2152) : PropUtils.getStringById(2153));
				starLv = petEntry.starLv;
				
				if(petEntry.canGetGift){
					if(petEntry.qmGiftReceived){
						sysId = 10091;
						giftBtn.setActive(false, 1, true);
					}else{
						sysId = 10090;
						giftBtn.setActive(true, 1, true);
					}
				}else{
					sysId = 10089;
					giftBtn.setActive(false, 1, true);
				}
			}else{
				sysId = 10089;
				giftBtn.setActive(false, 1, true);
				qmdLbl.text = "1";
				setStarLv(1);
				starLv = 1;
				usedBtn.visible = false;
			}
			var content:String = TableManager.getInstance().getSystemNotice(sysId).content;
			giftBtn.setToolTip(content);
			
			var petStarInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
//			petMovie.update(petStarInfo.pnfId1);
//			petMovie.playAct("stand", 3);
			if (null == fInfo) {
				fInfo = new FeatureInfo();
			}
 			fInfo.clear();
			living.removeAllEffect();
//			petAvatar.clearEffect();
			fInfo.suit = petStarInfo.pnfId1;
			living.changeAvatars(fInfo, true);
			living.playAct("stand", dir);
			if(0 == petStarInfo.pnfId2){
//				effectMovie.visible  = false;
			}else{
//				effectMovie.visible  = true;
//				effectMovie.update(petStarInfo.pnfId2);
				living.addEffect(petStarInfo.pnfId2);
			}
			
//			var raceSID:int;
//			switch(petInfo.race){
//				case 1:
//					raceSID = ConfigEnum.servent24;
//					break;
//				case 2:
//					raceSID = ConfigEnum.servent25;
//					break;
//				case 3:
//					raceSID = ConfigEnum.servent26;
//					break;
//				case 4:
//					raceSID = ConfigEnum.servent27;
//					break;
//				case 5:
//					raceSID = ConfigEnum.servent28;
//					break;
//				
//			}
			grid1.updataInfo(petInfo.skill1);
			grid2.updataInfo(petInfo.raceSkill);
			
			var data:PetData = DataManager.getInstance().petData;
			var petEntryData:PetEntryData = data.getPetById(petTId);
			
			grid3.visible = false;
			grid4.visible = false;
			grid5.visible = false;
			grid6.visible = false;
			
			if(null != petEntryData){
				
				var gpid:int;
				var lv:int;
				var petSkill:TPetSkillInfo;
				var skillId:int;
				var skill:Array = petEntryData.getSkill(0);
				if(skill != null){
					gpid = skill[0];
					lv = skill[1];
					petSkill = TableManager.getInstance().getPetSkill(gpid);
					if(null != petSkill){
						skillId = petSkill["skillId"+lv];
					}
					grid3.visible = true;
					grid3.updataInfo(skillId);
				}
				skillId = 0;
				skill = petEntryData.getSkill(1);
				if(skill != null){
					gpid = skill[0];
					lv = skill[1];
					petSkill = TableManager.getInstance().getPetSkill(gpid);
					if(null != petSkill){
						skillId = petSkill["skillId"+lv];
					}
					grid4.visible = true;
					grid4.updataInfo(skillId);
				}
				skillId = 0;
				skill = petEntryData.getSkill(2);
				if(skill != null){
					gpid = skill[0];
					lv = skill[1];
					petSkill = TableManager.getInstance().getPetSkill(gpid);
					if(null != petSkill){
						skillId = petSkill["skillId"+lv];
					}
					grid5.visible = true;
					grid5.updataInfo(skillId);
				}
				skillId = 0;
				skill = petEntryData.getSkill(3);
				if(skill != null){
					gpid = skill[0];
					lv = skill[1];
					petSkill = TableManager.getInstance().getPetSkill(gpid);
					if(null != petSkill){
						skillId = petSkill["skillId"+lv];
					}
					grid6.visible = true;
					grid6.updataInfo(skillId);
				}
			}
		}
		
		public function regristerSwitch(method:Function):void{
			switchMethod = method;
		}
		
		public function flyQmGift():void{
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(cpetId);
			FlyManager.getInstance().flyBags([petInfo.gift], [giftBtn.localToGlobal(new Point())]);
		}
	}
}
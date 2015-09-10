package com.leyou.ui.pet.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.pet.PetAttributeUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PetListRender extends AutoSprite
	{
		private var bgImg:Image;
		
		private var qmdLbl:Label;
		
		private var usedImg:Image;
		
		private var nameLbl:Label;
		
		private var lvLbl:Label;
		
		private var headImg:Image;
		
		private var raceImg:Image;
		
		private var stars:Vector.<Image>;
		
		private var selected:Boolean;
		
		private var _petTId:int;
		
		private var lvSignImg:Image;
		
		private var qmSignImg:Image;
		
		private var giftImg:Image;
		
		private var lvStatus:int;
		
		private var qmStatus:int;
		
		private var giftStatus:int;
		
		public function PetListRender(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventBtn.xml"));
			init();
		}
		
		public function get petTId():int{
			return _petTId;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			qmdLbl = getUIbyID("qmdLbl") as Label;
			usedImg = getUIbyID("usedImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			headImg = getUIbyID("headImg") as Image;
			raceImg = getUIbyID("raceImg") as Image;
			bgImg = getUIbyID("bgImg") as Image;
			qmSignImg = getUIbyID("qmSignImg") as Image;
			lvSignImg = getUIbyID("lvSignImg") as Image;
			giftImg = getUIbyID("giftImg") as Image;
			
			var spt:Sprite = new Sprite();
			spt.name = qmSignImg.name;
			spt.addChild(qmSignImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			spt = new Sprite();
			spt.name = lvSignImg.name;
			spt.addChild(lvSignImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			spt = new Sprite();
			spt.name = giftImg.name;
			spt.addChild(giftImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			var maxStar:int = ConfigEnum.servent9;
			stars = new Vector.<Image>(maxStar);
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = getUIbyID("star"+(n+1)+"Img") as Image;
				stars[n] = star;
			}
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onTipsOver(event:MouseEvent):void{
			var id:int;
			switch(event.target.name){
				case "qmSignImg":
					if(0 == qmStatus){
						id = 10078;
					}else if(1 == qmStatus){
						id = 10079;
					}else if(2 == qmStatus){
						id = 10080;
					}
					break;
				case "lvSignImg":
					if(0 == lvStatus){
						id = 10075;
					}else if(1 == lvStatus){
						id = 10076;
					}else if(2 == lvStatus){
						id = 10077;
					}
					break;
				case "giftImg":
					if(0 == giftStatus){
						id = 10089;
					}else if(1 == giftStatus){
						id = 10090;
					}else if(2 == giftStatus){
						id = 10091;
					}
					break;
			}
			var content:String = TableManager.getInstance().getSystemNotice(id).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point());
		}
		
		public function onMouseOut(event:MouseEvent):void{
			if(selected){
				return;
			}
			bgImg.updateBmp("ui/servent/yongbing_1.jpg");
		}
		
		public function onMouseOver(event:MouseEvent):void{
			if(selected){
				return;
			}
			bgImg.updateBmp("ui/servent/yongbing_2.jpg");
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
		
		public function updateByUserData(data:PetEntryData):void{
			filters = null;
			qmdLbl.text = data.qmdLv+"";
			lvLbl.text = StringUtil.substitute("LV:{1}", data.level);
			setStarLv(data.starLv);
			usedImg.visible = (1 == data.status);
			var petData:PetData = DataManager.getInstance().petData;
			
			TweenMax.killTweensOf(lvSignImg);
			lvSignImg.filters = null;
			if(data.lvMissionComplete){
				lvStatus = 2;
				lvSignImg.filters = [FilterEnum.enable];
			}else{
				if(_petTId == petData.lvPetId){
					lvStatus = 1;
					TweenMax.to(lvSignImg, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
				}else{
					lvStatus = 0;
					lvSignImg.filters = null;
				}
			}
			
			TweenMax.killTweensOf(qmSignImg);
			qmSignImg.filters = null;
			if(data.qmMissionComplete){
				qmStatus = 2;
				qmSignImg.filters = [FilterEnum.enable];
			}else{
				if(_petTId == petData.qmdPetId){
					qmStatus = 1;
					TweenMax.to(qmSignImg, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
				}else{
					qmStatus = 0;
					qmSignImg.filters = null;
				}
			}
			
			TweenMax.killTweensOf(giftImg);
			giftImg.filters = null;
			if(data.canGetGift){
				if(data.qmGiftReceived){
					giftStatus = 2;
					giftImg.filters = [FilterEnum.enable];
				}else{
					giftStatus = 1;
					TweenMax.to(giftImg, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
				}
			}else{
				giftStatus = 0;
				giftImg.filters = [FilterEnum.enable];
			}
		}
		
		public function updateByTable(petInfo:TPetInfo):void{
			_petTId = petInfo.id;
			nameLbl.text = petInfo.name;
			qmdLbl.text = "1";
			lvLbl.text = "LV:1";
			setStarLv(1);
			var raceUrl:String = PetAttributeUtil.getRaceUrl(petInfo.race);
			raceImg.updateBmp(raceUrl);	
			usedImg.visible = false;
			filters = [FilterEnum.enable];
			headImg.updateBmp("ui/servent/" + petInfo.headUrl);
		}
		
		public function setSelection(status:Boolean):void{
			selected = status;
			if(selected){
				bgImg.updateBmp("ui/servent/yongbing_2.jpg");
			}else{
				bgImg.updateBmp("ui/servent/yongbing_1.jpg");
			}
		}
	}
}
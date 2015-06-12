package com.leyou.ui.pet.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.pet.PetAttributeUtil;
	
	import flash.events.MouseEvent;
	
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
		
		public function PetListRender(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventBtn.xml"));
			init();
		}
		
		public function get petTId():int{
			return _petTId;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = false;
			qmdLbl = getUIbyID("qmdLbl") as Label;
			usedImg = getUIbyID("usedImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			headImg = getUIbyID("headImg") as Image;
			raceImg = getUIbyID("raceImg") as Image;
			bgImg = getUIbyID("bgImg") as Image;
			
			var maxStar:int = ConfigEnum.servent9;
			stars = new Vector.<Image>(maxStar);
			for(var n:int = 0; n < maxStar; n++){
				var star:Image = getUIbyID("star"+(n+1)+"Img") as Image;
				stars[n] = star;
			}
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
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
			lvLbl.text = data.level+"";
			setStarLv(data.starLv);
			usedImg.visible = (1 == data.status);
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
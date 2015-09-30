package com.leyou.ui.pet.children
{
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.StringUtil;
	
	import flash.display.Sprite;
	
	public class PetHeadGrid extends Sprite
	{
		private var grid:PetIconGird;
		
		private var selectBtn:ImgButton;
		
		private var keyImg:Image;
		
		private var _isDown:Boolean;
		
		public function PetHeadGrid(){
			init();
		}
		
		public function get isDown():Boolean{
			return _isDown;
		}

		private function init():void{
			grid = new PetIconGird();
			addChild(grid);
			
			selectBtn = new ImgButton("ui/other/ui_plus.png");
			selectBtn.x = 27;
			addChild(selectBtn);
			
			keyImg = new Image();
			addChild(keyImg);
			keyImg.x = 10;
		}
		
		public function get content():PetIconGird{
			return grid;
		}
		
		public function updateKeyImg(keyCode:String):void{
			keyImg.updateBmp(StringUtil.substitute("ui/mainUI/pic_{code}.png", keyCode))
		}
		
		public function get dataId():int{
			return grid.dataId;
		}
		
		public function updatePet(petId:int):void{
			grid.updatePet(petId);
		}
		
		public function isCDOver():Boolean{
			return grid.isCDOver();
		}
		
		public function playCD($totalTime:int, $startTime:int=0):void{
			grid.playCD($totalTime, $startTime);
		}
		
		public function clearGrid():void{
			grid.clearGrid();
		}
		
		public function setSelectAble(value:Boolean):void{
			selectBtn.visible = value;
		}
		
		public function playEffect(pnfId:int):void{
			grid.stopMc();
			grid.playeMc(pnfId);
		}
		
		public function stopEffect():void{
			grid.stopMc();
		}
		
		public function iconDown():void{
			if(!_isDown){
				grid.iconDown();
				_isDown = true;
			}
		}
		
		public function iconUp():void{
			if(_isDown){
				grid.iconUp();
				_isDown = false;
			}
		}
	}
}
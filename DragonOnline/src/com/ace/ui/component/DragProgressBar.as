package com.ace.ui.component
{
	import com.ace.enum.FilterEnum;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class DragProgressBar extends Sprite
	{
//		private var bgImg:Image;
		
		private var degreeImg:Image;
		
		private var addDegreeImg:Image;
		
		private var dragBtn:ImgButton;
		
		private var degree:Number=0;
		
		private var cDegree:Number=0;
		
		private var dragStatus:int;
		
		private var bgWidth:int = 155;
		
		private var bgHeight:int = 18;
		
//		private var mouseLX:int;
		
//		private var btnX:int;
		
		private var buoyContainer:Sprite;
		
		private var buoyText:TextField;
		
		private var numText:TextField;
		
		private var maxNum:int;
		
		public var limit:int = -1;
		
		private var listener:Function;
		
		private var _addValue:int = 0;
		
		public function DragProgressBar(){
			init();
		}
		
		private function init():void{
//			bgImg = new Image("ui/dragonBall/bg_dragonball_0.jpg");
			mouseEnabled = false;
			degreeImg = new Image("ui/dragonBall/bar_progress_1.jpg");
			addDegreeImg = new Image("ui/dragonBall/bar_progress_2.jpg");
			dragBtn = new ImgButton("ui/dragonBall/btn_lagan.png");
			buoyText = new TextField();
			buoyContainer = new Sprite();
			numText = new TextField();
			buoyText.mouseEnabled = false;
			numText.mouseEnabled = false;
			buoyContainer.mouseEnabled = false;
			buoyContainer.mouseChildren = true;
			numText.defaultTextFormat = new TextFormat(null, 12, 0xffffff, true, null, null, null, null, TextFormatAlign.CENTER);
			buoyText.width = 100;
			buoyText.defaultTextFormat = new TextFormat(null, 12, 0xff00, null, null, null, null, null, TextFormatAlign.CENTER);
//			addChild(bgImg);
			addChild(degreeImg);
			addChild(addDegreeImg);
			addChild(numText);
			buoyContainer.addChild(dragBtn);
			buoyContainer.addChild(buoyText);
			
			buoyText.x = -50;
			buoyText.filters = [FilterEnum.hei_miaobian];
			buoyText.text = "+0";
			
			numText.filters = [FilterEnum.hei_miaobian];
			numText.width = bgWidth;
			numText.text = "0/"+maxNum;
			
			dragBtn.x = -11;
			dragBtn.y = 15;
			buoyContainer.y = -20;
			addChild(buoyContainer);
			
			dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			dragBtn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			dragBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function get addValue():int{
			return _addValue;
		}
		
		public function setMaxNum(num:int):void{
			maxNum = num;
		}
		
		public function registerAddDegree(fun:Function):void{
			listener = fun;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			if(dragBtn.hasEventListener(MouseEvent.MOUSE_MOVE)){
				dragBtn.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		public function setDegree($degree:Number):void{
			if($degree > 1){
				$degree = 1;
			}else if($degree < 0){
				$degree = 0;
			}
			degree = $degree;
			cDegree = degree;
			addDegreeImg.visible = false;
			degreeImg.scrollRect = new Rectangle(0, 0, degree*bgWidth, bgHeight);
			buoyContainer.x = degree*bgWidth;
			numText.text = int(degree*maxNum)+"/"+maxNum;
			buoyText.text = "+0";
			_addValue = 0;
		}
		
		private function setNDegree($degree:Number):void{
			if($degree > 1){
				$degree = 1;
			}else if($degree < 0){
				$degree = 0;
			}
			if($degree < degree){
				return;
			}
			if((-1 != limit) && (limit < Math.round(($degree - degree)*maxNum))){
				$degree = degree+limit/maxNum;
			}
			cDegree = $degree;
			addDegreeImg.visible = true;
			var beginX:int = (cDegree >= degree) ? degree*bgWidth : cDegree*bgWidth;
			var addWidth:int = (cDegree >= degree) ? (cDegree - degree)*bgWidth : (degree - cDegree)*bgWidth;
			degreeImg.scrollRect = new Rectangle(0, 0, degree*bgWidth, bgHeight);
			addDegreeImg.scrollRect = new Rectangle(beginX, 0, addWidth, bgHeight);
			addDegreeImg.x = beginX;
			buoyContainer.x = cDegree*bgWidth;
			var sign:String = ($degree >= degree) ? "+" : "-";
			buoyText.text = sign + Math.round((cDegree - degree)*maxNum);
			_addValue = Math.round((cDegree - degree)*maxNum);
			if(null != listener){
				listener.call(this);
			}
		}
		
		public function trimmingPlus():void{
			_addValue++;
			if((-1 != limit) && (_addValue > limit)){
				_addValue = limit;
			}
			if(-1 == limit){
				_addValue = (1 - degree)*maxNum;
			}
			setNDegree(degree + _addValue/maxNum);
		}
		
		public function trimmingMinus():void{
			_addValue--;
			if(_addValue < 0){
				_addValue = 0;
			}
			setNDegree(degree + _addValue/maxNum);
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			if(dragBtn.hasEventListener(MouseEvent.MOUSE_MOVE)){
				dragBtn.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			var relativeMouseX:int = mouseX;
			if(relativeMouseX < 0){
				relativeMouseX = 0;
			}else if(relativeMouseX > bgWidth){
				relativeMouseX = bgWidth;
			}
			var deltaX:Number = mouseX - degree*bgWidth;
			if(deltaX < 0){
				deltaX = 0;
			}
			var tmpDegree:Number = degree + deltaX/bgWidth;
			setNDegree(tmpDegree);
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			dragBtn.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function setNum(num:int):void{
			setDegree(num/maxNum);
		}
	}
}
package com.leyou.ui.continuous.child
{
	import com.ace.enum.GameFileEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.img.child.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class RollIcon extends Sprite
	{
		private static const IMG_WIDTH:int = 62;
		
		private static const IMG_HEIGHT:int = 62;
		
		private var bgImg:Image;
		
		private var rollImgs:Vector.<Image>;
		
		private var imgsContainer:Sprite;
		
		private var imgCount:int;
		
		private var targetIndex:int;
		
		private var tick:int;
		
		private var speed:int = 500;
		
		private var iconIdArr:Vector.<int>;

		private var listener:Function;
		
		private var icon:Image;
		
		private var _showId:int;
		
		private var effect:SwfLoader;
		
		public function RollIcon(){
			init();
		}
		
		private function init():void{
			mouseChildren = false;
			bgImg = new Image("ui/tips/TIPS_bg_frame.png");
			addChild(bgImg);
			iconIdArr = new Vector.<int>();
			rollImgs = new Vector.<Image>();
			imgsContainer = new Sprite();
			effect = new SwfLoader();
			imgsContainer.scrollRect = new Rectangle(0, 0, IMG_WIDTH, IMG_HEIGHT);
			addChild(imgsContainer);
			imgsContainer.x = 3;
			imgsContainer.y = 3;
			icon = new Image();
			icon.x = 3;
			icon.y = 3;
			icon.visible = false;
			addChild(icon);
			addChild(effect);
		}
		
		public function get showId():int{
			return _showId;
		}
		
		public function loadResource($iconArr:Vector.<int>):void{
			imgCount = $iconArr.length;
			iconIdArr.length = imgCount;
			for(var n:int = 0; n < imgCount; n++){
				var tid:int = $iconArr[n];
				iconIdArr[n] = tid;
				pushImg(tid);
			}
		}
		
		public function loadResourceByArray($iconArr:Array):void{
			imgCount = $iconArr.length;
			iconIdArr.length = imgCount;
			for(var n:int = 0; n < imgCount; n++){
				var tid:int = $iconArr[n];
				iconIdArr[n] = tid;
				pushImg(tid);
			}
		}
		
		public function pushImg(tid:int):void{
			var tb:TBuffInfo = TableManager.getInstance().getBuffInfo(tid);
			var iconUrl:String = null;
			if(null != tb){
				iconUrl = GameFileEnum.URL_SKILL_ICO + tb.icon + ".png";
			}
			var ti:TItemInfo = TableManager.getInstance().getItemInfo(tid);
			if(null != ti){
				iconUrl = GameFileEnum.URL_ITEM_ICO + ti.icon + ".png";
			}
			var img:Image = new Image();
			img.updateBmp(iconUrl, null, false, 62, 62);
			img.y = rollImgs.length * IMG_HEIGHT;
			imgsContainer.addChild(img);
			rollImgs.push(img);
		}
		
		public function rollToImg(tid:int):void{
			effect.visible = false;
			icon.visible = false;
			tick = getTimer();
			_showId = tid;
			targetIndex = iconIdArr.indexOf(tid);
			var rect:Rectangle = imgsContainer.scrollRect;
			rect.y = 0;
			if(!hasEventListener(Event.ENTER_FRAME)){
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		protected function onEnterFrame(event:Event):void{
			var interval:int = getTimer() - tick;
			var posY:int = interval/1000*speed;
			if(posY >= IMG_HEIGHT*imgCount){
				posY = targetIndex*IMG_HEIGHT;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if(null != listener){
					listener.call(this);
				}
				setShowItem(showId);
			}
			var rect:Rectangle = imgsContainer.scrollRect;
			rect.y = posY;
			imgsContainer.scrollRect = rect;
		}
		
		public function setShowItem(tid:int):void{
			_showId = tid;
			effect.visible = true;
			var tb:TBuffInfo = TableManager.getInstance().getBuffInfo(tid);
			var iconUrl:String = null;
			if(null != tb){
				iconUrl = GameFileEnum.URL_SKILL_ICO + tb.icon + ".png";
			}
			var ti:TItemInfo = TableManager.getInstance().getItemInfo(tid);
			if(null != ti){
				iconUrl = GameFileEnum.URL_ITEM_ICO + ti.icon + ".png";
				if (ti.effect != null && ti.effect != "0"){
					effect.update(int(ti.effect1));
				}
			}
			icon.visible = true;
			icon.updateBmp(iconUrl, null, false, 62, 62);
		}
		
		public function registerOverListener(fun:Function):void{
			listener = fun;
		}
		
		public function clear():void{
			effect.visible = false;
			effect.stop();
			rollImgs.length = 0;
			iconIdArr.length = 0;
			while(imgsContainer.numChildren){
				imgsContainer.removeChildAt(0);
			}
		}
	}
}
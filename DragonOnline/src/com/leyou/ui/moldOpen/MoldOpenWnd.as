package com.leyou.ui.moldOpen
{
	import com.ace.ICommon.ILoaderCallBack;
	import com.ace.config.Core;
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFunForcastInfo;
	import com.ace.loaderSync.child.BackObj;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.ui.tools.ToolsWnd;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MoldOpenWnd extends AutoWindow implements ILoaderCallBack
	{
		private static const MOLD_COUNT:int = 18;
		
		private var bgMc:MovieClip;
		
		private var icon:Image;
		
		private var queue:Array;
		
		private var loaded:Boolean;
		
		private var currentId:int;
		
		public function MoldOpenWnd(){
			super(new XML());
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		protected function init():void{
			queue = [];
			mouseEnabled = false;
			mouseChildren = false;
			hideBg();
			clsBtn.visible = false;
		}
		
		public override function onWndMouseMove($x:Number, $y:Number):void{
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(stage.hasEventListener(MouseEvent.CLICK)){
				stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
			if(visible){
				show(true, UIEnum.WND_LAYER_NORMAL, false);
			}
		}
		
		public function lockMoldByLevel():void{
			var toolWnd:ToolsWnd = UIManager.getInstance().toolsWnd;
			for(var n:int = 0; n < MOLD_COUNT; n++){
				var info:TFunForcastInfo = TableManager.getInstance().getFunForcstInfoById(n+1);
				if(info.openLevel > Core.me.info.level){
					toolWnd.lockButton(info.id);
				}
			}
		}
		
		/**
		 * <T>显示下一个</T>
		 * 
		 */		
		private function showNext():void{
			if(!loaded){
				var _info:BackObj = new BackObj();
				_info.owner = this;
				_info.param["url"] = "ui/moldOpen/xgn.lib";
				ReuseManager.getInstance().imgSyLoader.addLoader(_info.param["url"], _info);
				return;
			}
			if(!stage.hasEventListener(MouseEvent.CLICK)){
				stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			if(!visible && (0 < queue.length)){
				currentId = queue.shift();
				openMold(currentId);
			}
		}
		
		/**
		 * <T>开启新功能</T>
		 * 
		 * @param id 功能枚举
		 * 
		 */		
		protected function openMold(id:int):void{
			if(3 == id){
				UIManager.getInstance().openFun(FunOpenEnum.RIDE, onRide);
			}
			show(true, UIEnum.WND_LAYER_NORMAL, false);
			var url:String = getSourceUrl(id);
			icon.updateBmp(url);
			bgMc.gotoAndPlay(1);
			if(!hasEventListener(Event.ENTER_FRAME)){
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
//			trace("-----------------------modl open")
		}
		
		private function onRide():void{
			if(!Core.me.info.isOnMount){
				UIManager.getInstance().roleWnd.mountUpAndDown();
			}
		}
		
		private function getSourceUrl(id:int):String{
			var info:TFunForcastInfo = TableManager.getInstance().getFunForcstInfoById(id);
			return "ico/items/"+info.icon;
		}
		
		/**
		 * <T>帧事件监听</T>
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onEnterFrame(evt:Event):void{
			if(bgMc.currentFrame >= bgMc.totalFrames){
				bgMc.stop();
				if(hasEventListener(Event.ENTER_FRAME)){
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				hide();
				showNext();
			}
			if(103 == bgMc.currentFrame){
				(bgMc.getChildAt(0) as MovieClip).stop();
				flyToBtn(icon, currentId);
			}
		}
		
		protected function flyToBtn($img:Image, id:int):void{
			if(null == $img){
				return;
			}
			var img:Image = new Image();
			img.bitmapData = $img.bitmapData.clone();
			var point:Point = $img.localToGlobal(new Point(0,0));
			img.x = point.x;
			img.y = point.y;
			var endBtn:ImgButton = UIManager.getInstance().toolsWnd.getButtonByType(id);
			if(null == endBtn){
				return;
			}
			var endPt:Point = endBtn.localToGlobal(new Point(0,0));
			LayerManager.getInstance().windowLayer.addChild(img);
			var endW:int = img.bitmapData.width;
			var endH:int = img.bitmapData.height;
			var beginX:int = img.x + img.width*0.5;
			var beginY:int = img.y + img.height*0.5;
			var endX:int = endPt.x + (endBtn.width-endW)*0.5;
			var endY:int = endPt.y + (endBtn.height-endH)*0.5;
			TweenMax.to(img, 3, {bezierThrough: [{x:beginX, y:beginY}, {x: endX, y: endY}], width: endW*0.8, height: endH*0.8, ease: Expo.easeIn(1,10,1,1), onComplete:onMoveOver, onCompleteParams:[img]})
		}
		
		protected function onMoveOver(img:Image):void{
			if(LayerManager.getInstance().windowLayer.contains(img)){
				LayerManager.getInstance().windowLayer.removeChild(img);
			}
		}
		
		/**
		 * <T>调整尺寸</T>
		 * 
		 */		
		public function resize():void{
			x = UIEnum.WIDTH>>1;
			y = 150;
		}
		
		public function checkFunction(level:int):void{
			var toolWnd:ToolsWnd = UIManager.getInstance().toolsWnd;
			for(var n:int = 0; n < MOLD_COUNT; n++){
				var info:TFunForcastInfo = TableManager.getInstance().getFunForcstInfoById(n+1);
				if(info.openLevel == level){
					toolWnd.unlockButton(info.id);
					var index:int = queue.indexOf(info.id);
					if(-1 == index && info.id != currentId){
						queue.push(info.id);
					}
				}
			}
			showNext();
		}
		
		public function callBackFun(obj:Object):void{
			loaded = true;
			bgMc = LibManager.getInstance().getClsMC("ui/moldopen/bg");
			addChild(bgMc);
			visible = false;
			
			if(null == icon){
				icon = new Image();
				icon.x = 26;
				icon.y = -40;
			}
			var mc:MovieClip = bgMc.getChildAt(0) as MovieClip;
			mc.addChildAt(icon, 1);
			showNext();
		}
	}
}
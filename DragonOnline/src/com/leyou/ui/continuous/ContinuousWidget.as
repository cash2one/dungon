package com.leyou.ui.continuous
{
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.gameData.table.TLZItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import com.leyou.net.cmd.Cmd_LZ;
	import com.leyou.ui.continuous.child.RollIcon;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class ContinuousWidget extends Sprite
	{
		private static const IMG_WIDTH:int = 249;
		
		//  分段变量
		private var spanCount:int = 50;
		
		private var killCounter:RollNumWidget;
		
		private var progressImg:Image;
		
		private var progressBg:Image;
		
		private var killImg:Image;
		
		private var itemContainer:Sprite;
		
		private var bgImg:Image;
		
		private var itemNum:RollNumWidget;
		
		private var icon:RollIcon;
		
		private var _tick:int;
		
		private var _time:int;
		
		private var playing:Boolean;
		
		private var itemCount:int;
		
		private var level:int;
		
		private var currentId:int;
		
		public function ContinuousWidget(){
			init();
		}
		
		private function init():void{
			visible = false;
			mouseChildren = false;
			mouseEnabled = false;
			itemContainer = new Sprite();
			itemContainer.x = 10;
			itemContainer.y = 101;
			addChild(itemContainer);
			itemContainer.visible = false;
			
			progressBg = new Image();
			progressBg.updateBmp("ui/lianz/lz_bg_01.png");
			progressBg.x = 22;
			addChild(progressBg);
			progressImg = new Image();
			progressImg.updateBmp("ui/lianz/lz_bg_02.png");
			progressImg.x = 22;
			addChild(progressImg);
			
			killImg = new Image();
			killImg.updateBmp("ui/lianz/icon_kill.png");
			killImg.x = 162;
			killImg.y = 48;
			addChild(killImg);
			
			killCounter = new RollNumWidget();
			killCounter.alingRound();
			killCounter.loadSource("ui/num/{num}_lz.png");
			killCounter.x = 120;
			killCounter.y = 22;
			//			killCounter.visibleOfBg = false;
			addChild(killCounter);
			
			bgImg = new Image();
			bgImg.updateBmp("ui/lianz/lz_bg_hd.png");
			itemContainer.addChild(bgImg);
			
			itemNum = new RollNumWidget();
			itemNum.alignLeft();
			itemNum.addFrontFlag("ui/lianz/icon_plus.png");
			itemNum.loadSource("ui/num/{num}_lzs.png");
			itemNum.addTailFlag("ui/num/percent.png");
			//			itemCounter.visibleOfBg = false;
			itemNum.isPopNum = false;
			itemNum.x = 123;
			itemNum.y = 32;
			itemNum.registerOverListener(onRollOver);
			itemContainer.addChild(itemNum);
			
			icon = new RollIcon();
//			icon.loadResource(ITEM_ID_ARR);
			icon.registerOverListener(onImgRollOver);
			icon.x = 12;
			icon.y = 18;
			itemContainer.addChild(icon);
			killCounter.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var l:int = Math.ceil(killCounter.number/spanCount)*spanCount
			var content:String = "连斩数到达" + l + "时,将获得奖励";
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function startCouner(num:int, timer:int, tid:int=0, itc:int=0):void{
			if(!visible){
				visible = true;
			}
			if(num >= 100){
				spanCount = 100;
			}
			currentId = tid;
			var l:int = Math.ceil(num/spanCount)*spanCount;
			killCounter.setNum(num);
			killCounter.scaleX = 4;
			killCounter.scaleY = 4;
			TweenLite.to(killCounter, 0.2, {scaleX:1, scaleY:1});
			resetProgress(timer);
			if((tid > 0) && !playing){
				if(l != level){
					level = l;
					icon.clear();
					var lzInfo:TLZItemInfo = TableManager.getInstance().getLZInfo(level);
					icon.loadResource(lzInfo.iconsArr);
				}
				itemCount = itc;
				getItem(tid);
			}
		}
		
		public function getItem(tid:int):void{
			playing = true;
			itemContainer.visible = true;
			itemNum.visible = false;
			itemContainer.alpha = 1;
			icon.rollToImg(tid);
//			trace("----------------------rollIcon Begin");
		}
		
		public function resetProgress(timer:int):void{
			_time = timer;
			_tick = getTimer();
			if(progressImg.bitmapData.width > 3){
				var rect:Rectangle = progressImg.scrollRect;
				if(null == rect){
					rect = new Rectangle(0, 0, IMG_WIDTH, progressImg.height);
				}else{
					rect.width = IMG_WIDTH;
				}
				progressImg.scrollRect = rect;
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void{
			var interval:int = getTimer() - _tick;
			var rect:Rectangle = progressImg.scrollRect;
			if(rect){
				rect.width = IMG_WIDTH - interval*IMG_WIDTH/_time;
				if(rect.width <= 0){
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					if(!playing){
						visible = false;
					}
					return;
				}
				progressImg.scrollRect = rect;
			}
		}
		
		public function resize():void{
			x = UIEnum.WIDTH - 270;
			y = 70;
		}
		
		public function onImgRollOver():void{
//			trace("----------------rollIcon end");
//			trace("----------------rollNumber begin");
			itemNum.visible = true;
			itemNum.rollToNum(itemCount, false, 2, true);
			itemNum.tailVisible(isBuff(currentId));
		}
		
		public function isBuff(tid:int):Boolean{
			var tb:TBuffInfo = TableManager.getInstance().getBuffInfo(tid);
			var iconUrl:String = null;
			if(null != tb){
				return true;
			}
			return false;
//			var ti:TItemInfo = TableManager.getInstance().getItemInfo(tid);
//			if(null != ti){
//				iconUrl = GameFileEnum.URL_ITEM_ICO + ti.icon + ".png";
//			}
		}
		
		public function onRollOver():void{
//			trace("----------------rollNumer end");
			TweenLite.to(itemContainer, 2, {alpha:0, onComplete:moveOver});
			function moveOver():void{
				if((null != progressImg.scrollRect) && (progressImg.scrollRect.width <= 0)){
					visible = false;
				}
				Cmd_LZ.cm_LZ_J();
				playing = false;
			}
		}
	}
}
package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class DragonBallPreviewWnd extends AutoWindow
	{
		// 每页显示最大数量
		private static const VIEW_MAX_NUM:int = 20;
		
		// 每页宽度
		private static const VIEW_WIDTH:int = 485;
		
		// 每页高度
		private static const VIEW_HEIGHT:int = 389;
		
		private var pannel:Sprite;
		
		private var grids:Vector.<MarketGrid>;
		
		private var bgImgs:Vector.<Image>;
		
		private var preBtn:ImgButton;
		
		private var nextBtn:ImgButton;
		
		private var threshold:int;
		
		private var currentPage:int;
		
		public function DragonBallPreviewWnd(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall1Win.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			preBtn = getUIbyID("preBtn") as ImgButton;
			nextBtn = getUIbyID("nextBtn") as ImgButton;
			preBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
			
			pannel = new Sprite();
			addChild(pannel);
			pannel.x = 85;
			pannel.y = 36;
			grids = new Vector.<MarketGrid>();
			bgImgs = new Vector.<Image>();
			var index:int;
			var info:XML = LibManager.getInstance().getXML("config/table/Dragon_Draw.xml");
			for each (var cinfo:XML in info.children()) {
				var bgImg:Image = new Image("ui/other/icon_prop_bigframe.png");
				var grid:MarketGrid = new MarketGrid();
				grid.updataById(cinfo.@D_Item);
				grid.isShowPrice = false;
				grids.push(grid);
				
				bgImg.x = int(index/VIEW_MAX_NUM) * VIEW_WIDTH + (index%5)*97;
				bgImg.y = int(index%VIEW_MAX_NUM/5) * 97;
				grid.x = bgImg.x + 11;
				grid.y = bgImg.y + 11;
				pannel.addChild(bgImg);
				pannel.addChild(grid);
				index++;
			}
			pannel.scrollRect = new Rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
			preBtn.visible = (threshold > 0);
			nextBtn.visible = (threshold < (Math.ceil(grids.length/VIEW_MAX_NUM)-1)*VIEW_WIDTH);
		}
		
		public function resize():void {
			x = (UIEnum.WIDTH - width) >> 1;
			y = (UIEnum.HEIGHT - height) >> 1;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "preBtn":
					previousPage();
					break;
				case "nextBtn":
					nextPage();
					break;
			}
		}
		
		protected function nextPage():void{
			if(currentPage < Math.ceil(grids.length/3)-1){
				scrollToX(++currentPage*VIEW_WIDTH);
			}
		}
		
		protected function previousPage():void{
			if(currentPage > 0){
				scrollToX(--currentPage*VIEW_WIDTH);
			}
		}
		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			preBtn.visible = (threshold > 0);
			nextBtn.visible = (threshold < (Math.ceil(grids.length/VIEW_MAX_NUM)-1)*VIEW_WIDTH);
		}
		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = pannel.scrollRect;
			var dValue:int = threshold - rect.x;
			if(Math.abs(dValue) < 21.75){
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}else if(dValue > 21.75){
				rect.x += 21.75;
			}else if(dValue < 21.75){
				rect.x -= 21.75;
			}
			pannel.scrollRect = rect;
		}
		
		public override function get width():Number{
			return 648;
		}
		
		public override function get height():Number{
			return 419;
		}
	}
}
package com.leyou.ui.copy
{
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.ui.copy.child.CopyItem;
	import com.leyou.ui.copy.child.CopyRewardGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class StoryCopyView extends AutoWindow
	{
		protected static const GRID_COUNT:int = 4;
		
		protected static var pointQueue:Array = [new Point(0, 0), new Point(150, 110), new Point(297, 0), new Point(447, 55)];
		
		protected var prevBtn:ImgButton;
		
		protected var nextBtn:ImgButton;
		
		protected var allPastBtn:ImgButton;
		
		protected var copyPannel:Sprite;
		
		protected var items:Vector.<CopyItem>;
		
		protected var currentPage:int;
		
		protected var threshold:int;
		
		protected var grids:Vector.<CopyRewardGrid>;
		
		public function StoryCopyView(){
			super(LibManager.getInstance().getXML("config/ui/dungeonStoryWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			prevBtn = getUIbyID("prevBtn") as ImgButton;
			nextBtn = getUIbyID("nextBtn") as ImgButton;
			allPastBtn = getUIbyID("allPastBtn") as ImgButton;
			prevBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			allPastBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			copyPannel = new Sprite();
			copyPannel.mouseEnabled = false;
			copyPannel.x = 75;
			copyPannel.y = 93;
			copyPannel.scrollRect = new Rectangle(0, 0, 600, 280);
			addChild(copyPannel);
			items = new Vector.<CopyItem>();
			
			grids = new Vector.<CopyRewardGrid>();
			for(var n:int = 0; n < GRID_COUNT; n++){
				var grid:CopyRewardGrid = new CopyRewardGrid();
				grid.x = 190 + n*45;
				grid.y = 425;
				addChild(grid);
				grids.push(grid);
			}
			hideBg();
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			Cmd_SCP.cm_SCP_I();
			GuideManager.getInstance().showGuide(30, this);
			GuideManager.getInstance().removeGuide(28);
			GuideManager.getInstance().removeGuide(29);
			
			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_CopySuccess);
		}
		
		public override function hide():void{
			super.hide();
			GuideManager.getInstance().removeGuide(30);
			
			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_CopySuccess);
		}
		
//		public function startHide():void{
//			GuideManager.getInstance().removeGuide(30);
//		}
		
		/**
		 * <T>下一页</T>
		 * 
		 */		
		protected function nextPage():void{
			if(currentPage < Math.ceil(items.length/4)-1){
				scrollToX(++currentPage*600);
			}
		}
		
		/**
		 * <T>上一页</T>
		 * 
		 */		
		protected function previousPage():void{
			if(currentPage > 0){
				scrollToX(--currentPage*600);
			}
		}
		
		/**
		 * <T>滚动到阀值</T>
		 * 
		 * @param $threshold 阀值
		 * 
		 */		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			prevBtn.visible = (threshold > 0);
			nextBtn.visible = (threshold < (Math.ceil(items.length/4)-1)*600);
		}
		
		/**
		 * <T>帧监听滚动</T>
		 * 
		 * @param event 帧事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = copyPannel.scrollRect;
			if((threshold - rect.x) > 30){
				rect.x += 30;
			}else if((threshold - rect.x) < 30){
				rect.x -= 30;
			}else{
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			copyPannel.scrollRect = rect;
		}
		
		/**
		 * <T>放入一个副本项</T>
		 * 
		 */		
		public function pushItem(item:CopyItem, index:int):void{
			item.x = int(index/4)*600 + pointQueue[index%4].x;
			item.y = pointQueue[index%4].y;
			copyPannel.addChild(item);
			items[item.info.id-1] = item;
		}
		
		protected function onButtonClick(event:MouseEvent):void{
		}
	}
}
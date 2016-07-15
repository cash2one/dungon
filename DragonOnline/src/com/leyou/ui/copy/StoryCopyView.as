package com.leyou.ui.copy {
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.enum.TaskEnum;
	import com.leyou.ui.copy.child.CopyItem;
	import com.leyou.ui.copy.child.CopyRewardGrid;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class StoryCopyView extends AutoSprite {
		protected static const GRID_COUNT:int=3;

		protected static var pointQueue:Array=[new Point(0, 0), new Point(160, 158), new Point(316, 0), new Point(474, 158)];

		protected var prevBtn:ImgButton;

		protected var nextBtn:ImgButton;

		protected var allPastBtn:ImgButton;
		protected var copyRBtn:ImgButton;

		protected var copyPannel:Sprite;

		protected var items:Vector.<CopyItem>;

		protected var currentPage:int;

		protected var threshold:int;

		protected var grids:Vector.<CopyRewardGrid>;

		public function StoryCopyView() {
			super(LibManager.getInstance().getXML("config/ui/dungeonStoryWnd.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			prevBtn=getUIbyID("prevBtn") as ImgButton;
			nextBtn=getUIbyID("nextBtn") as ImgButton;
			allPastBtn=getUIbyID("allPastBtn") as ImgButton;
			this.copyRBtn=this.getUIbyID("copyRBtn") as ImgButton;
			copyRBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			prevBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			allPastBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			copyPannel=new Sprite();
			copyPannel.mouseEnabled=false;
			copyPannel.x=73;
			copyPannel.y=20;
			copyPannel.scrollRect=new Rectangle(0, 0, 615, 333);
			addChild(copyPannel);
			items=new Vector.<CopyItem>();

			grids=new Vector.<CopyRewardGrid>();
			for (var n:int=0; n < GRID_COUNT; n++) {
				var grid:CopyRewardGrid=new CopyRewardGrid();
				grid.x=182 + n * 52;
				grid.y=388;
				addChild(grid);
				grids.push(grid);
			}

			x=3;
			y=3;
		}

//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//			Cmd_SCP.cm_SCP_I();
//			GuideManager.getInstance().showGuide(30, this);
//			GuideManager.getInstance().removeGuide(28);
//			GuideManager.getInstance().removeGuide(29);
//			
//			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_CopySuccess);
//		}

		public function showGuide():void {
//			GuideManager.getInstance().showGuide(30, items[0].beginBtn);
			GuideManager.getInstance().removeGuide(28);
			GuideManager.getInstance().removeGuide(29);
		}

//		public override function hide():void{
//			super.hide();
//		}

		public function removeGuide():void {
//			GuideManager.getInstance().removeGuide(30);
			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_CopySuccess);
		}

//		public function startHide():void{
//			GuideManager.getInstance().removeGuide(30);
//		}

		/**
		 * <T>下一页</T>
		 *
		 */
		protected function nextPage():void {
			if (currentPage < Math.ceil(items.length / 4) - 1) {
				scrollToX(++currentPage * 615);
			}
		}

		/**
		 * <T>上一页</T>
		 *
		 */
		protected function previousPage():void {
			if (currentPage > 0) {
				scrollToX(--currentPage * 615);
			}
		}

		/**
		 * <T>滚动到阀值</T>
		 *
		 * @param $threshold 阀值
		 *
		 */
		protected function scrollToX($threshold:int):void {
			threshold=$threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			prevBtn.visible=(threshold > 0);
			nextBtn.visible=(threshold < (Math.ceil(items.length / 4) - 1) * 615);
		}

		/**
		 * <T>帧监听滚动</T>
		 *
		 * @param event 帧事件
		 *
		 */
		protected function onEnterFrame(event:Event):void {
			var rect:Rectangle=copyPannel.scrollRect;
			if ((threshold - rect.x) > 41) {
				rect.x+=41;
			} else if ((threshold - rect.x) < 41) {
				rect.x-=41;
			} else {
				rect.x=threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			copyPannel.scrollRect=rect;
		}

		/**
		 * <T>放入一个副本项</T>
		 *
		 */
		public function pushItem(item:CopyItem, index:int):void {
			item.x=int(index / 4) * 615 + pointQueue[index % 4].x;
			item.y=pointQueue[index % 4].y;
			copyPannel.addChild(item);
			items[item.info.id - 1]=item;
		}

		protected function onButtonClick(event:MouseEvent):void {


		}

		override public function getUIbyID(id:String):DisplayObject {
			if (id == "beginBtn")
				return this.items[0].beginBtn;

			return super.getUIbyID(id);
		}

	}
}

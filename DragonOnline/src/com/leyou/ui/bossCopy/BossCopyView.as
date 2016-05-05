package com.leyou.ui.bossCopy {
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.copy.BossCopyData;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BCP;
	import com.leyou.ui.bossCopy.child.BossCopyRender;
	import com.leyou.ui.copy.child.CopyRewardGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class BossCopyView extends AutoWindow {
		private static const GRID_COUNT:int=12;

		protected var challengeLbl:Label;

		protected var addBtn:ImgButton;

		protected var hasImg:Image;

		protected var prevBtn:ImgButton;

		protected var nextBtn:ImgButton;

		protected var bossDesLbl:Label;

		protected var enterBtn:ImgButton;

		protected var items:Vector.<BossCopyRender>;

		protected var grids:Vector.<CopyRewardGrid>;

		protected var pannel:Sprite;

		protected var currentPage:int;

		protected var big:SwfLoader;

		protected var threshold:int;

		private var currentBoss:BossCopyData;

		protected var numWidget:RollNumWidget;

		protected var cost:int;

		protected var selectedBoss:BossCopyRender;

		protected var nameLbl:Label;
		protected var loopswf:SwfLoader;

		public function BossCopyView() {
			super(LibManager.getInstance().getXML("config/ui/dungeonBossWnd.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			challengeLbl=getUIbyID("challengeLbl") as Label;
			addBtn=getUIbyID("addBtn") as ImgButton;
			hasImg=getUIbyID("hasImg") as Image;
			prevBtn=getUIbyID("prevBtn") as ImgButton;
			nextBtn=getUIbyID("nextBtn") as ImgButton;
			enterBtn=getUIbyID("enterBtn") as ImgButton;
			loopswf=getUIbyID("loopswf") as SwfLoader;
			bossDesLbl=getUIbyID("bossDesLbl") as Label;
			bossDesLbl.multiline=true;
			bossDesLbl.wordWrap=true;
			bossDesLbl.width=197;
			//			revealImg = getUIbyID("revealImg") as Image;

			big=new SwfLoader();
			big.x=375;
			big.y=284;
			addChild(big);

			//			addBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			//			prevBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			//			nextBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			//			enterBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.CLICK, onMouseClick);

			pannel=new Sprite();
			pannel.mouseEnabled=false;
			pannel.x=150;
			pannel.y=332;
			pannel.scrollRect=new Rectangle(0, 0, 435, 90);
			addChild(pannel);

			items=new Vector.<BossCopyRender>();

			numWidget=new RollNumWidget();
			//			numWidget.visibleOfBg = false;
			numWidget.alignLeft();
			numWidget.loadSource("ui/num/{num}_zdl.png");
			numWidget.x=134;
			numWidget.y=302;
			addChild(numWidget);
			numWidget.setNum(10000);

			hideBg();
			grids=new Vector.<CopyRewardGrid>();
			for (var n:int=0; n < GRID_COUNT; n++) {
				var grid:CopyRewardGrid=new CopyRewardGrid();
				if (n < 4) {
					grid.x=505 + n % 4 * 44;
					grid.y=118;
				} else {
					grid.x=505 + n % 4 * 44;
					grid.y=218 + (int(n / 4) - 1) * 44;
				}
				pane.addChildAt(grid, 1);
				grids[n]=grid;
			}
			nameLbl=new Label();
			addChild(nameLbl);
			
			this.addChild(this.loopswf);
		}

		public function selectBoss(boss:BossCopyRender):void {
			if (null != boss) {
				if (null != selectedBoss) {
					selectedBoss.select=false;
				}
				boss.select=true;
				selectedBoss=boss;
			}
		}

		/**
		 * <T>按钮点击</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			// 处理选中boss项
			var boss:BossCopyRender=event.target as BossCopyRender;
			selectBoss(boss)
			var n:String=event.target.name;
			switch (n) {
				case "addBtn":
					var content:String=TableManager.getInstance().getSystemNotice(4904).content;
					content=StringUtil.substitute(content, cost);
					PopupManager.showConfirm(content, Cmd_BCP.cm_BCP_A, null, false, "bossCpy.add");
					break;
				case "prevBtn":
					previousPage();
					break;
				case "nextBtn":
					nextPage();
					break;
				case "enterBtn":
					Cmd_BCP.cm_BCP_E(currentBoss.id);
					break;
			}
		}

		/**
		 * <T>翻下一页</T>
		 *
		 */
		protected function nextPage():void {
			if (currentPage < Math.ceil(items.length / 3) - 1) {
				scrollToX(++currentPage * 435);
			}
		}

		/**
		 * <T>翻上一页</T>
		 *
		 */
		protected function previousPage():void {
			if (currentPage > 0) {
				scrollToX(--currentPage * 435);
			}
		}

		/**
		 * <T>定位到一个位置</T>
		 * @param param0
		 *
		 */
		protected function setToX($threshold:int):void {
			if ($threshold < 0) {
				return;
			}
			threshold=$threshold;
			prevBtn.visible=(threshold > 0);
			nextBtn.visible=(threshold < (Math.ceil(items.length / 3) - 1) * 435);
			var rect:Rectangle=pannel.scrollRect;
			rect.x=threshold;
//			var item:BossCopyRender = items[currentPage*3];
//			item.select = true;
//			if(null != selectedBoss){
//				selectedBoss.select = false;
//			}
//			item.select = true;
//			selectedBoss = item;
//			showBoss(item.bossData);
			pannel.scrollRect=rect;
		}

		/**
		 * <T>要滚动到的位置</T>
		 *
		 * @param $threshold 滚动位置
		 *
		 */
		protected function scrollToX($threshold:int):void {
			threshold=$threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			prevBtn.visible=(threshold > 0);
			nextBtn.visible=(threshold < (Math.ceil(items.length / 3) - 1) * 435);
		}

		/**
		 * <T>滚动刷新</T>
		 *
		 */
		protected function onEnterFrame(event:Event):void {
			var rect:Rectangle=pannel.scrollRect;
			var dValue:int=threshold - rect.x;
			if (Math.abs(dValue) < 21.75) {
				rect.x=threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				var item:BossCopyRender=items[currentPage * 3];
				item.select=true;
				if (null != selectedBoss) {
					selectedBoss.select=false;
				}
				item.select=true;
				selectedBoss=item;
				showBoss(item.bossData);
			} else if (dValue > 21.75) {
				rect.x+=21.75;
			} else if (dValue < 21.75) {
				rect.x-=21.75;
			}
			pannel.scrollRect=rect;
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			Cmd_BCP.cm_BCP_I();
			GuideManager.getInstance().removeGuide(64);
		}

		public override function hide():void {
			super.hide();
			PopupManager.closeConfirm("bossCpy.add");
		}

		/**
		 * <T>加入一个boss项</T>
		 *
		 */
		public function pushItem(item:BossCopyRender):void {
			item.x=int(items.length / 3) * 435 + items.length % 3 * 145;
			pannel.addChild(item);
			items.push(item);
			item.addEventListener(MouseEvent.CLICK, onItemClick);
		}

		/**
		 * <T>点击boss</T>
		 *
		 */
		protected function onItemClick(event:MouseEvent):void {
			var item:BossCopyRender=event.target as BossCopyRender;
			showBoss(item.bossData);
		}

		/**
		 * <T>展示boss</T>
		 *
		 */
		public function showBoss(bossData:BossCopyData):void {
			currentBoss=bossData;
			bossDesLbl.text=bossData.copyInfo.des;
			numWidget.setNum(bossData.copyInfo.fightEnergy);
			var mInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(bossData.copyInfo.monsterId);
			var radis:int=TableManager.getInstance().getPnfInfo(mInfo.pnfId).radius
			big.update(mInfo.pnfId);
			nameLbl.text=bossData.copyInfo.name;
			nameLbl.x=big.x - nameLbl.width * 0.5;
			nameLbl.y=big.y - 2 * radis;
//			x=Math.round(livingBase.avatarPs.x - nameLblWidth * 0.5 - baseX);
//			y=Math.round(livingBase.avatarPs.y - 2 * livingBase.bInfo.radius - 60);
			big.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_ES);
			hasImg.visible=bossData.isFirst;
			var rc:int=grids.length;
			for (var n:int=0; n < rc; n++) {
				grids[n].clear();
					//				var itemInfo:Object = TableManager.getInstance().getItemInfo(bossData.getItem(n));
					//				if(null == itemInfo){
					//					itemInfo = TableManager.getInstance().getEquipInfo(bossData.getItem(n));
					//				}
					//				grid.updataInfo({itemId:itemInfo.id, count:bossData.getItemCount(n)});
			}
			var index:int=0;
			var copyInfo:TCopyInfo=bossData.copyInfo;
			if (copyInfo.firstEXP > 0) {
				grids[index++].updataInfo({itemId: 65534, count: copyInfo.firstEXP});
			}
			if (copyInfo.firstEnergy > 0) {
				grids[index++].updataInfo({itemId: 65533, count: copyInfo.firstEnergy});
			}
			if (copyInfo.firstMoney > 0) {
				grids[index++].updataInfo({itemId: 65535, count: copyInfo.firstMoney});
			}
			if (copyInfo.firstItem1 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.firstItem1, count: copyInfo.firstItemCount1});
			}
			if (copyInfo.firstItem2 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.firstItem2, count: copyInfo.firstItemCount2});
			}
			index=4;
			if (copyInfo.item1 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item1, count: 0});
			}
			if (copyInfo.item2 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item2, count: 0});
			}
			if (copyInfo.item3 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item3, count: 0});
			}
			if (copyInfo.item4 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item4, count: 0});
			}
			if (copyInfo.item5 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item5, count: 0});
			}
			if (copyInfo.item6 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item6, count: 0});
			}
			if (copyInfo.item7 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item7, count: 0});
			}
			if (copyInfo.item8 > 0) {
				grids[index++].updataInfo({itemId: copyInfo.item8, count: 0});
			}
		}
 
		/**
		 * <T>清除所有boss数据</T>
		 *
		 */
		public function clear():void {
			var length:int=items.length;
			for (var n:int=0; n < length; n++) {
				var item:BossCopyRender=items[n];
				pannel.removeChild(item);
			}
			items.length=0;
		}
	}
}

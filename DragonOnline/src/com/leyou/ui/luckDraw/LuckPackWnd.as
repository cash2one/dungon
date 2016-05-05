package com.leyou.ui.luckDraw {
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.luckDraw.LuckDrawData;
	import com.leyou.data.luckDraw.LuckDrawRewardInfo;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class LuckPackWnd extends AutoWindow {

		private static const COUNT_TIME:int=30;

		private var grids:Vector.<LuckPackGrid>;

		private var gridPanel:ScrollPane;

		private var rearrangeBtn:NormalButton;

		private var extractingBtn:NormalButton;

		private var countLbl:Label;

		private var row:int=20;

		private var col:int=7;

		private var tick:uint;

		public function LuckPackWnd() {
			super(LibManager.getInstance().getXML("config/ui/luckDraw/luckPackWnd.xml"));
			init();
		}

		private function init():void {
			countLbl=getUIbyID("countLbl") as Label;
			gridPanel=getUIbyID("gridPanel") as ScrollPane;
			rearrangeBtn=getUIbyID("rearrangeBtn") as NormalButton;
			extractingBtn=getUIbyID("extractingBtn") as NormalButton;
			rearrangeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			extractingBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			grids=new Vector.<LuckPackGrid>();
			for (var i:int=0; i < row; i++) {
				for (var j:int=0; j < col; j++) {
					var grid:LuckPackGrid=new LuckPackGrid();
					grid.x=5 + j * 44;
					grid.y=i * 44;
					grid.pos=i * col + j;
					grids[grid.pos]=grid;
					gridPanel.addToPane(grid);
				}
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "rearrangeBtn":
					Cmd_LDW.cm_LDW_Z();
					if (!TimeManager.getInstance().hasITick(counter)) {
						tick=getTimer();
						rearrangeBtn.setActive(false, 1, true);
						TimeManager.getInstance().addITick(1000, counter);
					}
					break;
				case "extractingBtn":
					Cmd_LDW.cm_LDW_T(-1);
					break;
			}
		}

		private function counter():void {
			var interval:int=(getTimer() - tick) / 1000;
			var remain:int=COUNT_TIME - interval;
			rearrangeBtn.text=remain + PropUtils.getStringById(2146);
			if ((remain < 0) && TimeManager.getInstance().hasITick(counter)) {
				rearrangeBtn.text=PropUtils.getStringById(1623);
				rearrangeBtn.setActive(true, 1, true);
				TimeManager.getInstance().removeITick(counter);
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_LDW.cm_LDW_B();
		}

		public function updateInfo_B():void {
			clearGrids();
			var data:LuckDrawData=DataManager.getInstance().luckdrawData;
			var l:int=data.storeLength();
			for (var n:int=0; n < l; n++) {
				var rInfo:LuckDrawRewardInfo=data.getStoreItem(n);
				grids[rInfo.pos].updateInfo(rInfo);
			}
			countLbl.text=l + "/" + (row * col);
		}

		public function clearGrids():void {
			var l:int=grids.length;
			for (var n:int=0; n < l; n++) {
				grids[n].clear();
			}
		}

		public override function get height():Number {
			return 544;
		}
	}
}

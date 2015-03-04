package com.leyou.ui.backpack.child {
	
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.NumericStepper;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.net.cmd.Cmd_Bag;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	public class BagSplitPanel extends AutoWindow {
		
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var slider:HSlider;
		private var numStep:NumericStepper;

		private var currentGrid:BackpackGrid;

		private var oldGrid:BackpackGrid;
		private var newGrid:BackpackGrid;

		private var info:Baginfo;

		public function BagSplitPanel() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd02.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.slider=this.getUIbyID("splitHSlider") as HSlider;
			this.numStep=this.getUIbyID("numStep") as NumericStepper;

			this.numStep.input.restrict="0-9";

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.slider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
			this.numStep.addEventListener(Event.CHANGE, onInput);
			this.numStep.text="";
			
			this.currentGrid=new BackpackGrid(-1);
			this.currentGrid.isLock=false;
			this.addChild(this.currentGrid);
			this.currentGrid.x=25;
			this.currentGrid.y=53;

			this.oldGrid=new BackpackGrid(-1);
			this.addChild(this.oldGrid);
			this.oldGrid.x=140;
			this.oldGrid.y=53;

			this.newGrid=new BackpackGrid(-1);
			this.addChild(this.newGrid);
			this.newGrid.x=213;
			this.newGrid.y=53;
			
			

//			this.currentGrid.mouseChildren=false;
//			this.currentGrid.mouseEnabled=false;
//			this.oldGrid.mouseChildren=false;
//			this.newGrid.mouseChildren=false;
//			this.oldGrid.mouseEnabled=false;
//			this.newGrid.mouseEnabled=false;
		}

		private function updateGrid(info:Baginfo):void {
			this.currentGrid.updataInfo(info);
			this.oldGrid.updataInfo(info);
			this.newGrid.updataInfo(info);

			this.currentGrid.setSize(60, 60);
			this.oldGrid.setSize(60, 60);
			this.newGrid.setSize(60, 60);

			this.oldGrid.numLable=0;
			this.newGrid.numLable=0;
			
			this.currentGrid.canMove=false;
			this.oldGrid.canMove=false;
			this.newGrid.canMove=false;
			
			this.currentGrid.enableMouseUpEvent=false;
			this.oldGrid.enableMouseUpEvent=false;
			this.newGrid.enableMouseUpEvent=false;
		}

		public function showPanel(info:Baginfo):void {
			updateGrid(info);
			this.info=info;
			
			super.show();
			
			this.numStep.value=(this.info.num - 1);
			this.slider.progress=1;

			this.numStep.maximum=this.info.num;
			this.numStep.minimum=1;
			this.numStep.stepSize=1;
			this.numStep.value=1;
			
			this.oldGrid.numLable=1;
			this.newGrid.numLable=this.info.num - 1;
		}

		private function onChange(e:Event):void {
//			this.numStep.text=Math.ceil(this.info.num * this.slider.progress) + "";
			this.numStep.value=Math.ceil(this.info.num * this.slider.progress)
			
			this.oldGrid.numLable=this.info.num - int(this.numStep.value);
			this.newGrid.numLable=int(this.numStep.value);
		}

		private function onInput(e:Event):void {

			var num:int=int(this.numStep.value);

			if (num > this.info.num) {
				this.numStep.value=this.info.num;
				this.slider.progress=1;

				this.oldGrid.numLable=0;
				this.newGrid.numLable=this.info.num;

			} else {

				this.slider.progress=num / this.info.num;

				this.oldGrid.numLable=this.info.num - num;
				this.newGrid.numLable=num;
			}

		}

		private function onClick(e:MouseEvent):void {
			
			switch (e.target.name) {
				case "confirmBtn":
					if (this.numStep.text != null && this.numStep.text != "")
						Cmd_Bag.cm_bagSplit(info.pos, int(this.numStep.text));
					break;
				case "cancelBtn":

					break;
			}

			this.hide();
		}
		
		
		override public function hide():void{
			super.hide();
			
			this.currentGrid.enableMouseUpEvent=true;
			this.oldGrid.enableMouseUpEvent=true;
			this.newGrid.enableMouseUpEvent=true;
		}

	}
}

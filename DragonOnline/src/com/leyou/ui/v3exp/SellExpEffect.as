package com.leyou.ui.v3exp {

	import com.ace.gameData.manager.DataManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.net.cmd.Cmd_ddsc;

	import flash.events.MouseEvent;

	public class SellExpEffect extends AutoWindow {

		private var effItems:Array=[];

		private var btnArr:Array=[];

		private var cfst:int=-1;
		private var cst:int=-1;

		public function SellExpEffect() {
			super(new XML());
			this.init();
			this.hideBg();
//			this.clsBtn.visible=false;
			this.mouseChildren=true;
			this.mouseEnabled=false;
			this.allowDrag=false;
		}

		private function init():void {

			var se1:SellExpWnd=new SellExpWnd();
			this.addChild(se1);

			this.effItems.push(se1);

			var se2:SellExpWnd2=new SellExpWnd2();
			this.addChild(se2);

			this.effItems.push(se2);

			var se3:SellExpWnd3=new SellExpWnd3();
			this.addChild(se3);

			this.effItems.push(se3);


			var btn:ImgButton=new ImgButton("ui/ad/tup.png");
			this.addChild(btn);
			this.btnArr.push(btn);

			btn.addEventListener(MouseEvent.CLICK, onClick);
			btn.y=521;

			btn=new ImgButton("ui/ad/tup.png");
			this.addChild(btn);
			this.btnArr.push(btn);

			btn.addEventListener(MouseEvent.CLICK, onClick);
			btn.y=521;

			btn=new ImgButton("ui/ad/tup.png");
			this.addChild(btn);
			this.btnArr.push(btn);

			btn.addEventListener(MouseEvent.CLICK, onClick);
			btn.y=521;

			this.addChild(clsBtn);
			this.clsBtn.x=288 - 40;

		}

		private function onClick(e:MouseEvent):void {

			var index:int=this.btnArr.indexOf(e.target);

			var d:int=0;
			for (var i:int=0; i < this.btnArr.length; i++) {
				if (this.btnArr[i].visible)
					d++;
			}

			var l:int=0;
			var _x:int=(288 - d * 20) / 2;
			for (i=0; i < this.effItems.length; i++) {
				this.effItems[i].visible=false;
				this.btnArr[i].turnOff();

				if (!this.btnArr[i].visible)
					continue;

				this.btnArr[i].x=_x + l * 20;
				l++;
			}

			ImgButton(e.target).turnOn();
			this.effItems[index].visible=true;
		}

		public function updateExp(o:Object):void {

			if (DataManager.getInstance().vipData.status == null || o == null)
				return;
			
			
			if (this.cfst == o.fst && this.cst == DataManager.getInstance().vipData.status[0])
				return;


			if (2 != o.fst || DataManager.getInstance().vipData.status[0] == 0) {

				this.effItems[0].updateInfo(o.fjlist);

				this.effItems[0].setGet1State(o.fst)
				this.effItems[0].setGet2State(DataManager.getInstance().vipData.status[0] == 1)

				this.btnArr[0].visible=true;
				this.btnArr[1].visible=false;

				this.btnArr[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));

			} else {

				this.btnArr[1].visible=true;
				this.btnArr[0].visible=false;

				if (o.st == 2) {
					this.effItems[1].updateInfo(o.mjlist);
				} else
					this.effItems[1].updateInfo(o.jlist);

				this.effItems[1].setGetBtnState((o.st != 2));

				this.btnArr[1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}


			this.cfst=o.fst;
			this.cst=DataManager.getInstance().vipData.status[0];
		}

		public function updateBlackStore(o:Object):void {
			this.btnArr[2].visible=(o.ast == 1);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_ddsc.cm_DdscInit();
		}

		override public function get height():Number {
			return 544;
		}

		override public function get width():Number {
			return 288;
		}

	}
}

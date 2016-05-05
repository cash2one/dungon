package com.leyou.ui.arrow {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAd;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AdWnd extends AutoWindow {

		private var bgSwf:SwfLoader;
		private var gridImg:Image;

		private var btnArr:Vector.<ImgButton>;
		private var items:Vector.<TAd>;
		private var itemState:Array=[];


		private var currentIndex:int=0;
		private var twn:TweenLite;

		private var firstShow:Boolean=true;

		private var bot:Sprite;

		public function AdWnd() {
			super(LibManager.getInstance().getXML("config/ui/arrow/adWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.updataBmd("ui/common/close_type2.png");
//			this.clsBtn.y=0;
//			this.clsBtn.x=this.width - 25;
			this.allowDrag=false;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgSwf=this.getUIbyID("bgSwf") as SwfLoader;
			this.gridImg=this.getUIbyID("gridImg") as Image;

			this.btnArr=new Vector.<ImgButton>();
			this.items=new Vector.<TAd>();

			this.addEventListener(MouseEvent.CLICK, onItemClick);
//			this.addEventListener(MouseEvent.CLICK, onItemClick);

			this.bot=new Sprite();


		}

		public function updateState():void {
//			this.updateInfo();
		}

		private function updateInfo():void {

			var render:ImgButton;
			for each (render in this.btnArr) {
				if (render != null)
					this.removeChild(render);
			}

			this.btnArr.length=0;
			this.items.length=0;

			this.btnArr=new Vector.<ImgButton>();
			this.items=new Vector.<TAd>();

			var data:Object=TableManager.getInstance().getAddAll();
			var item:TAd;
			var lv:int=Core.me.info.level
			var i:int=0;
			var d:int=0;
			var st:int=this.itemState.indexOf(true);

			for each (item in data) {

				if (item.lv > lv)
					continue;

				if (st == -1)
					this.itemState[item.Id]=false;
				else {
					if (this.itemState[item.Id]) {
						continue;
					}
				}

				if (Core.me.info.vipLv != 0 && item.Id == 1) {
					continue;
				}

				if (Core.me.info.vipLv == 0 && item.Id == 2) {
					continue;
				}

				if (MyInfoManager.getInstance().hasWing && item.Id == 4) {
					continue;
				}

				this.items.unshift(item);

				render=new ImgButton("ui/ad/tup.png");
//				render.addEventListener(MouseEvent.CLICK,onClick);
				render.addEventListener(MouseEvent.MOUSE_OVER, onClick);

				this.btnArr.push(render);
				this.addChild(render);

				render.y=this.height - render.height;
				render.x=this.width - 13 - 15 * i;

				i++;
			}


			this.currentIndex=0;
			this.changePage();
		}

		private function onItemClick(e:MouseEvent):void {

			if (e.target == this.clsBtn) {
				return;
			}

			var tad:TAd=this.items[this.btnArr.length - 1 - (this.currentIndex == 0 ? this.currentIndex : this.currentIndex - 1)];
			if (tad != null) {

				if (tad.openId != "") {

					var id:int=-1;
					var tab:int=-1;
					if (tad.openId.indexOf("|") > -1) {

						id=tad.openId.split("|")[0];
						tab=tad.openId.split("|")[1];

						if (!UIManager.getInstance().isCreate(id)) {
							UIManager.getInstance().creatWindow(id);
						}

						UILayoutManager.getInstance().show(id);
						UIManager.getInstance().marketWnd.changeTable(4)

					} else {

						id=int(tad.openId);

						if (!UIManager.getInstance().isCreate(id)) {
							UIManager.getInstance().creatWindow(id);
						}

						if (WindowEnum.LUCKDRAW == id) {
							UIOpenBufferManager.getInstance().open(WindowEnum.LUCKDRAW);
						} else {
							UILayoutManager.getInstance().show(id);
						}

					}

				}

			}

		}

//		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop,$layer,toCenter);
//			
//			this.updateInfo();
//		}


		private function onClick(e:MouseEvent):void {
			this.currentIndex=this.btnArr.length - 1 - this.btnArr.indexOf(e.target as ImgButton);


			if (this.twn != null) {
				this.twn.kill();
			}

			changePage();
		}

		private function changePage():void {

			if (this.currentIndex >= this.items.length)
				this.currentIndex=0;

			var tad:TAd=this.items[this.btnArr.length - 1 - this.currentIndex];

			this.gridImg.fillEmptyBmd();

			if (tad.image != "")
				this.gridImg.updateBmp("ui/ad/" + tad.image);

			if (tad.pnc > 0) {
				this.bgSwf.visible=true;
				this.bgSwf.update(tad.pnc);
			} else {
				this.bgSwf.visible=false;
			}

			for (var i:int=0; i < this.btnArr.length; i++)
				this.btnArr[i].turnOff();

			this.btnArr[this.btnArr.length - 1 - this.currentIndex].turnOn();

			this.currentIndex++;

			if (this.twn != null) {
				this.twn.kill();
			}

//			twn=TweenLite.to(this, 2, {onComplete: changePage});
			twn=TweenLite.to(this, tad.time, {onComplete: changePage});
		}


		public function showPanel():void {
			if (!this.visible && this.firstShow && Core.me != null) {
				this.show();
				this.updateInfo();
				this.resize();

				this.firstShow=false;
			}
		}

		/**
		 *
		 * @param isOpen
		 *
		 */
		public function setStateWing(isOpen:Boolean):void {
			this.itemState[4]=isOpen;
			this.updateInfo();
		}

		/**
		 *
		 * @param isbuy
		 *
		 */
		public function setStateTtsc(isbuy:Boolean):void {
			this.itemState[2]=isbuy;
			this.updateInfo()
		}

		/**
		 * vip充值
		 * @param isbuy
		 *
		 */
		public function setStateVip(isbuy:Boolean):void {
			this.itemState[1]=isbuy;

			this.updateInfo()
		}


		public function resize():void {
			this.x=UIEnum.WIDTH - this.width;

			if (UIEnum.WIDTH - UIManager.getInstance().toolsWnd.x - UIManager.getInstance().toolsWnd.width < this.width) {
				this.y=UIEnum.HEIGHT - this.height - 100;
			} else {
				this.y=UIEnum.HEIGHT - this.height;
			}
		}

		override public function get height():Number {
			return 156;
		}

		override public function get width():Number {
			return 213;
		}

		public function hideClsBtn():void {
			clsBtn.visible=false;
		}

	}
}

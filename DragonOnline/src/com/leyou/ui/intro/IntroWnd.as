package com.leyou.ui.intro {
	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TIntro;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.ui.intro.childs.IntroRender;

	import flash.events.MouseEvent;

	public class IntroWnd extends AutoWindow {


		private var itemList:ScrollPane;

		private var itemBtn:Array=[];
		private var itemBtnArr:Array=[];

		public function IntroWnd() {
			super(LibManager.getInstance().getXML("config/ui/intro/introWnd.xml"));
			init();
		}

		private function init():void {

			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			var arr1:Array=TableManager.getInstance().getIntroType();

			var info:ImgButton;
			var tinfo:TIntro;

			var i:int=0;
			var imgbtn:ImgLabelButton;

			for each (tinfo in arr1) {

				imgbtn=new ImgLabelButton("ui/common/" + tinfo.imgBtn, tinfo.typeName, 0, 0, FontEnum.getTextFormat("message2"));
				this.addChild(imgbtn);
				this.itemBtn.push(imgbtn);

				imgbtn.name="s_" + tinfo.type;

				imgbtn.x=5;
				imgbtn.y=63 + i * 47;

				imgbtn.addEventListener(MouseEvent.CLICK, onClick);

				i++;
			}

		}


		private function onClick(e:MouseEvent):void {

			var imgbtn:ImgLabelButton;

			for each (imgbtn in this.itemBtn) {
				imgbtn.turnOff();
			}

			e.target.turnOn();

			var render:IntroRender;
			for each (render in itemBtnArr) {
				if (render)
					this.itemList.delFromPane(render);
			}

			this.itemBtnArr.length=0;

			var type:int=e.target.name.split("_")[1];

			var i:int=0;
			var tinfo:TIntro;
			var arr2:Array=TableManager.getInstance().getIntroByType(type);

			for each (tinfo in arr2) {

				if (Core.me.info.level < tinfo.lv)
					continue;

				render=new IntroRender();

				render.updateInfo(tinfo);
				this.itemList.addToPane(render);
				this.itemBtnArr.push(render);

//				render.x=152;
				render.y=i * 79;

				i++;
			}

			this.itemList.scrollTo(0);
			this.itemList.updateUI();
//			DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
			DelayCallManager.getInstance().add(this, this.itemList.scrollTo, "updateUI", 4, 0);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			this.itemBtn[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function setTabIndex(i:int):void {

			var imgbtn:ImgLabelButton;

			for each (imgbtn in itemBtn) {

				if (int(imgbtn.name.split("_")[1]) == i) {
					imgbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}

			}

		}


	}
}

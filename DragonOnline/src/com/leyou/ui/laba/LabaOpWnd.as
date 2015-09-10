package com.leyou.ui.laba {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLaba;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.ui.laba.child.LabaOpRender;

	public class LabaOpWnd extends AutoWindow {

		private var itemList:ScrollPane;
		private var descLbl:Label;

		public function LabaOpWnd() {
			super(LibManager.getInstance().getXML("config/ui/laba/labaOpWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
			this.clsBtn.visible=false;
			this.allowDrag=false;
		}

		private function init():void {

			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.descLbl.width=206;
			this.descLbl.wordWrap=true;
			
			
			this.updateInfo();
		}

		public function updateInfo():void {

			var obj:Object=TableManager.getInstance().getLabaAll();

			var render:LabaOpRender;
			var info:TLaba;
			var j:int=0;

			for each (info in obj) {
				if (info.image == "-1")
					continue;

				render=new LabaOpRender();

				render.updateInfo(info);

				this.itemList.addToPane(render);
				render.y=j * render.height;

				j++;
			}

			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(10084).content;
		}


		override public function get height():Number {
			return 412;
		}

		override public function get width():Number {
			return 226;
		}

	}
}

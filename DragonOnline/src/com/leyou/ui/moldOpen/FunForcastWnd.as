package com.leyou.ui.moldOpen {
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFunForcastInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FunForcastWnd extends AutoSprite {

		private var levelLbl:Label;

		//		private var moldLbl:Label;

		private var hideBtn:ImgButton;

		private var newImg:Image;

		private var showBtn:ImgButton;

		private var panel:Sprite;

		private var bgImg:Image;

		private var cLevel:int;

		private var info:TFunForcastInfo;

		private var iconImg:Image;

		private var container:Sprite;

		private var movie:SwfLoader;

		public function FunForcastWnd() {
			super(LibManager.getInstance().getXML("config/ui/funForcastWnd.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			levelLbl=getUIbyID("levelLbl") as Label;
			//			moldLbl=getUIbyID("moldLbl") as Label;
			hideBtn=getUIbyID("hideBtn") as ImgButton;
			bgImg=getUIbyID("bgImg") as Image;
			panel=new Sprite();
			panel.addChild(bgImg);
			panel.addChild(levelLbl);
			//			panel.addChild(moldLbl);
			panel.addChild(hideBtn);
			addChild(panel);
			newImg=getUIbyID("newImg") as Image;
			showBtn=getUIbyID("showBtn") as ImgButton;
			showBtn.visible=false;
			container=new Sprite();

			showBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			visible=false;
		}

		protected function onBtnClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "hideBtn":
					panel.visible=false;
					showBtn.visible=true;
					container.visible=false;
					break;
				case "showBtn":
					container.visible=true;
					panel.visible=true;
					showBtn.visible=false;
					break;
			}
		}

		public function resize():void {
			y=UIManager.getInstance().roleHeadWnd.y + 242;
		}

		public function checkFunction(level:int):void {
			// 找到所属的时间段
			var nInfo:TFunForcastInfo=TableManager.getInstance().getFunForcstInfo(level);
			if (null == nInfo) {
				visible=false;
			} else {
				if (nInfo != info) {
					container.visible=true;
					panel.visible=true;
					showBtn.visible=false;
					info=nInfo;
				}
				visible=true;
				levelLbl.text="LV" + info.openLevel + PropUtils.getStringById(1789);
				//				moldLbl.text=info.name;
				if (null == iconImg) {
					iconImg=new Image();
					movie=new SwfLoader(99946);
					container.addChild(movie);
					container.addChild(iconImg);
					container.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
					container.x=10;
					container.y=12;
					addChild(container);
					iconImg.x=38;
					iconImg.y=12;
					movie.x=32;
					movie.y=2;
				}
				iconImg.updateBmp("ico/items/" + info.icon, null, false, -1, -1, PriorityEnum.FIVE);
			}
		}

		protected function onIconOver(event:MouseEvent):void {
			if (null != info) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, info.tips, new Point(stage.mouseX, stage.mouseY));
			}
		}
	}
}

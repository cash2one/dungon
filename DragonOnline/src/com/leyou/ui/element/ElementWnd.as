package com.leyou.ui.element {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.data.elementAdditional.ElementData;
	import com.leyou.data.elementAdditional.Elementry;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.element.children.ElementElementryRender;
	import com.leyou.ui.element.children.ElementPropertiesRender;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ElementWnd extends AutoWindow {
		private var ruleLbl:Label;
		private var elementries:Vector.<ElementElementryRender>;
		private var propertiesRender:ElementPropertiesRender;

		public function ElementWnd() {
			super(LibManager.getInstance().getXML("config/ui/element/elementWnd.xml"));
			init();
		}

		public override function get width():Number {
			return 896;
		}

		public override function get height():Number {
			return 544;
		}

		private function init():void {
			ruleLbl=getUIbyID("ruleLbl") as Label;
			titleLbl=getUIbyID("titleLbl") as Label;

			elementries=new Vector.<ElementElementryRender>(5);
			for (var n:int=0; n < 5; n++) {
				var element:ElementElementryRender=new ElementElementryRender();
				elementries[n]=element;
				pane.addChild(element);
				element.y=67 + int(n / 3) * 234;
				if (n < 3) {
					element.x=10 + 226 * (n % 3);
				} else {
					element.x=127 + 229 * (n % 3);
				}
			}

			ruleLbl.mouseEnabled=true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onTip);

			propertiesRender=new ElementPropertiesRender();
			pane.addChild(propertiesRender);
			propertiesRender.x=700;
			propertiesRender.y=217;
		}

		protected function onTip(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(10103).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//		}

		public override function hide():void {
			super.hide();
			
			UIManager.getInstance().hideWindow(WindowEnum.ELEMENT_SWITCH);
			UIManager.getInstance().hideWindow(WindowEnum.ELEMENT_UPGRADE);
//			GuideManager.getInstance().removeGuide(11);
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("eleBtn"));
		}

		protected function onBtnClick(event:MouseEvent):void {

		}

		public function updateInfo():void {
			var data:ElementData=DataManager.getInstance().elementData;
			for (var n:int=0; n < 5; n++) {
				var elementry:ElementElementryRender=elementries[n];
				elementry.updateInfo(data.getEntry(n));
				elementry.setBtnValid(data.ctype);
			}

			if (0 == data.ctype) {
				propertiesRender.visible=false;
			} else {
//				GuideManager.getInstance().removeGuide(11);
				propertiesRender.visible=true;
				var elementryData:Elementry=data.getEntryByType(data.ctype);
				var elementInfo:TElementInfo=TableManager.getInstance().getElementInfo(elementryData.type, elementryData.lv);
				var nelementInfo:TElementInfo=TableManager.getInstance().getElementInfo(elementryData.type, elementryData.lv + 1);
				propertiesRender.updateInfo(elementInfo, nelementInfo, elementryData.lv);
			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			var data:ElementData=DataManager.getInstance().elementData;
//			if (ConfigEnum.ElementOpenLv <= Core.me.info.level && data.ctype == 0)
//				GuideManager.getInstance().showGuide(11, this);

			GuideManager.getInstance().removeGuide(9);
		}

		public function resize():void {
			UILayoutManager.getInstance().composingWnd(WindowEnum.ELEMENT);
		}

		public function playCD(skillID:int):void {
			propertiesRender.playCD(skillID);
		}

		public override function toString():String {
			return "";
		}
	}
}

package com.leyou.ui.element.children {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.elementAdditional.Elementry;
	import com.leyou.data.vip.TipVipEquipInfo;
	import com.leyou.net.cmd.Cmd_ELEP;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ElementElementryRender extends AutoSprite {
		private var swfLoader:SwfLoader;

		private var selectBtn:NormalButton;

		private var eleData:Elementry;

		private var currentType:int;

		private var sp:Sprite;

		private var tipsInfo:TipVipEquipInfo;

		private var nameLbl:Label;

		public function ElementElementryRender() {
			super(LibManager.getInstance().getXML("config/ui/element/elementRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			nameLbl=getUIbyID("nameLbl") as Label;
			swfLoader=getUIbyID("swfLoader") as SwfLoader;
			selectBtn=getUIbyID("selectBtn") as NormalButton;
			swfLoader.x=100;
			swfLoader.y=230;

			selectBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			selectBtn.visible=false;

			var hitW:int=60;
			var hitH:int=180;
			sp=new Sprite();
			var g:Graphics=sp.graphics;
			g.beginFill(0, 0);
			g.drawRect(0, 0, 200, 230);
			g.endFill();
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			selectBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			addChild(selectBtn);

			tipsInfo=new TipVipEquipInfo();

		}

		protected function onMouseOut(event:MouseEvent):void {
			if (event.relatedObject != selectBtn) {
				if (currentType != eleData.type) {
					selectBtn.visible=false;
					swfLoader.stop(false);
					swfLoader.filters=[FilterEnum.enable];
				}
			}
		}

		protected function onMouseOver(event:MouseEvent):void {
			if (currentType != eleData.type) {
				selectBtn.visible=true;
				tipsInfo.type=eleData.type;
				tipsInfo.level=eleData.lv;
				ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
				swfLoader.start();
				swfLoader.filters=null;
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
//			Cmd_ELEP.cm_ELEP_S(eleData.type, eleData.exp);

			GuideManager.getInstance().removeGuide(11);

			if (0 == DataManager.getInstance().elementData.ctype) {
				Cmd_ELEP.cm_ELEP_S(eleData.type, 1);
				selectBtn.visible=false;
			} else {
				Cmd_ELEP.cm_ELEP_A(eleData.type);
				UILayoutManager.getInstance().show(WindowEnum.ELEMENT_SWITCH);
				UIManager.getInstance().elementSwitchWnd.updateInfo(eleData.type);
			}
		}

		public function setBtnValid(type:int):void {

			if (currentType != 0 && currentType != type && type == eleData.type) {
				var elementInfo:TElementInfo=TableManager.getInstance().getElementInfo(eleData.type, eleData.lv);
				SoundManager.getInstance().play(elementInfo.sound2);
			}

			currentType=type;
			if (currentType == eleData.type) {
				swfLoader.filters=null;
				swfLoader.start();
			} else {
				swfLoader.filters=[FilterEnum.enable];
				swfLoader.stop(false);
			}
		}

		public function updateInfo(p:Elementry):void {
			eleData=p;
			var elementInfo:TElementInfo=TableManager.getInstance().getElementInfo(p.type, p.lv);
			swfLoader.update(elementInfo.pnfId2);
			swfLoader.playAct("stand", 4);
			nameLbl.text=elementInfo.name;

		}
	}
}

package com.leyou.ui.tools.child {
	import com.ace.enum.FilterEnum;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.StringUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;

	public class RightTopWidget extends Sprite {
		private var numBg1:Image;

		private var numBg2:Image;

		private var numText:TextField;

		private var strText:TextField;

		public var index:int;

		private var effectLoader:SwfLoader;

		private var tick:uint;

		private var remainT:int;

		private var timeLbl:TextField;

		public var overV:String;

		public var display:DisplayObject;

		public function RightTopWidget() {
			super();
			init();
		}

		private function init():void {
			numBg1=new Image();
			numBg2=new Image();
			numText=new TextField();
			strText=new TextField();
			timeLbl=new TextField();
			timeLbl.mouseEnabled=false;
			numText.mouseEnabled=false;
			strText.mouseEnabled=false;
			effectLoader=new SwfLoader();
			// 99974

//			var arr:Array = Font.enumerateFonts(true);
//			arr.sortOn("fontName", Array.CASEINSENSITIVE);
//			for each(var font:Font in arr){
//				trace("---------------"+ font.fontName);
//			}
			var tfm:TextFormat=new TextFormat("微软雅黑", 12, 0xcdb97c, null, null, null, null, null, TextFormatAlign.CENTER);
			numText.defaultTextFormat=tfm;
			strText.defaultTextFormat=tfm;
			timeLbl.defaultTextFormat=tfm;
			numText.filters=[FilterEnum.hei_miaobian];
			strText.filters=[FilterEnum.hei_miaobian];
			timeLbl.filters=[FilterEnum.hei_miaobian];
			timeLbl.textColor=0xff00;
			numText.width=20;
			strText.width=20;
			timeLbl.width=60;
			timeLbl.height=20;
			addChild(numBg1);
			addChild(numBg2);
			addChild(numText);
			addChild(strText);
			addChild(timeLbl);
			addChild(effectLoader);
			numBg1.updateBmp("ui/mainUI/main_num_bg.png");
			numBg2.updateBmp("ui/mainUI/main_num_bg.png");
			numBg1.x=32;
			numText.x=33;
			numText.y=2;
			timeLbl.y=57;
			effectLoader.x=18;
			effectLoader.y=20;
			overV="";

			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		protected function onMouseClick(event:MouseEvent):void {
			if ("onlineBtn" == name) {
				GuideManager.getInstance().removeGuide(23);
			}
		}

		public function pushContent($display:DisplayObject):void {
			display=$display;
			name=display.name;
			addChildAt(display, 0);
			numText.visible=false;
			numBg1.visible=false;
			strText.visible=false;
			numBg2.visible=false;
		}

		public function updateBmp($url:String):void {
			var imgBtn:ImgButton=display as ImgButton;
			if (null != imgBtn) {
				imgBtn.updataBmd($url);
			}
		}

		public function setNum(num:int):void {
			numText.text=num + "";
			numText.visible=(num > 0);
			numBg1.visible=(num > 0);
		}

		public function setText(t:String):void {
			if (null == t || "" == t) {
				strText.visible=false;
				numBg2.visible=false;
				return;
			}
			strText.text=t;
			strText.visible=true;
			numBg2.visible=true;
		}

		public function setEffect(value:Boolean):void {
			if (value) {
				effectLoader.update(99974);
//				effectLoader.playAct();
				effectLoader.visible=true;
			} else {
				effectLoader.stop();
				effectLoader.visible=false;
			}
		}

		public function setRemain(remain:int):void {
			remainT=remain;
			if (remainT <= 0) {
				stopTimeCounter();
			} else {
				tick=getTimer();
				if (!TimeManager.getInstance().hasITick(updateTime)) {
					TimeManager.getInstance().addITick(1000, updateTime);
				}
				updateTime();
			}
		}

		public function stopTimeCounter():void {
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
			timeLbl.text=overV;
			if ("onlineBtn" == name) {
				GuideManager.getInstance().showGuide(23, this, true);
			}
		}

		private function updateTime():void {
			var interval:int=(getTimer() - tick) / 1000;
			var rrt:int=remainT - interval;
			if (rrt >= 0) {
				var dd:int=int(rrt / 60 / 60 / 24);
				var hh:String=StringUtil.fillTheStr(int(rrt / 60 / 60 % 24), 2, "0");
				var mi:String=StringUtil.fillTheStr(int(rrt / 60 % 60), 2, "0");
				var ms:String=StringUtil.fillTheStr(int(rrt % 60), 2, "0");
				if (dd <= 0) {
					timeLbl.text=StringUtil.substitute("{1}:{2}:{3}", hh, mi, ms);
				} else {
					timeLbl.text=StringUtil.substitute(PropUtils.getStringById(1962), dd, hh);
				}
			} else {
				stopTimeCounter();
			}
		}

		public function setActive(value:Boolean):void {
			visible=value;
			setEffect(false);
		}

		public function die():void {
			numBg1.die();
			numBg1=null;
			numText=null;
			effectLoader.die();
			effectLoader=null;
		}

		override public function get height():Number {
			return 60;
		}
	}
}

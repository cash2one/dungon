package com.leyou.ui.shiyi.childs {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Syj;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;

	public class ShizBtn1 extends AutoSprite {

		private var nameLbl:Label;
		private var priceImg:Image;
		private var useCb:CheckBox;
		private var bgImg:Image;

		public var sortIndex:int=0;
		public var sortId:int=0;

		private static var selectStid:ShizBtn1;
		private var info:TTitle;

		public function ShizBtn1() {
			super(LibManager.getInstance().getXML("config/ui/shiyi/shizBtn1.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.priceImg=new Image();
			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.useCb=this.getUIbyID("useCb") as CheckBox;

			this.addChild(this.priceImg);

			this.priceImg.x=36;
			this.priceImg.y=5;

			this.useCb.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOver(e:MouseEvent):void {
//			if (this.filters.length == 0)
			this.setSt(true);
		}

		private function onMouseOut(e:MouseEvent):void {
			if (selectStid != this)
				this.setSt(false);
		}

		private function onClick(e:MouseEvent):void {
			
			if (selectStid != null && selectStid != this)
				selectStid.setSt(false);
			
			selectStid=this;
			this.setSt(true);
			
			if (e.target == this.useCb) {

				if (this.useCb.isOn) {

					var arr:Array=UIManager.getInstance().shiyeWnd.getOtherCount();
					if (arr.length > 0) {
						Cmd_Syj.cmUninstall(arr[0]);
					}

					Cmd_Syj.cmInstall(this.info.typeId);
				} else
					Cmd_Syj.cmUninstall(this.info.typeId);

			} else {
				Cmd_Syj.cmOpen(this.info.typeId);
			}

			e.stopImmediatePropagation();
		}

		public function updateInfo(o:TTitle):void {
			if (o != null)
				this.info=o;

			this.sortId=info.typeId;
			this.nameLbl.text="" + o.name;

			if (o.Bottom_Pic != "" && o.Bottom_Pic != null) {
				this.priceImg.updateBmp("ico/items/" + o.Bottom_Pic + ".png");
			}

		}

		override public function get height():Number {
			return 73;
		}

		public function setBgState(v:Boolean):void {
			if (v)
				this.useCb.turnOn();
			else
				this.useCb.turnOff();

			if (v && info.Sz_type == 7) {

				var pinfo:TPnfInfo=TableManager.getInstance().getPnfInfo(int(info.model2));

				if (pinfo.type == 10) {
					UIManager.getInstance().roleWnd.setBackEffect(int(info.model2));
				} else if (pinfo.type == 3) {
					UIManager.getInstance().roleWnd.setEffect(int(info.model2));
				}
			}

//			this.setSt(v);
		}

		public function set enabel(v:Boolean):void {
			if (v) {
				this.filters=[];
				this.mouseChildren=true;
			} else {
				this.filters=[FilterUtil.enablefilter];
				this.mouseChildren=false;
			}
		}

		public function getTypeId():int {
			return this.info.typeId;
		}

		private function setSt(v:Boolean):void {
			if (v) {
				this.bgImg.updateBmp("ui/title/title_bg.png");
			} else {
				this.bgImg.updateBmp("ui/title/title_bg0.png");
			}
		}

	}
}

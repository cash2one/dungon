package com.leyou.ui.shiyi.childs {

	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Syj;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;

	public class ShizBtn2 extends AutoSprite {

		private var priceImg:Image;
		private var useCb:CheckBox;
		private var bgImg:Image;
		private var swfloader:SwfLoader;

		public var sortIndex:int=0;
		public var sortId:int=0;

		private static var selectStid:ShizBtn2;
		private var info:TTitle;

		public function ShizBtn2() {
			super(LibManager.getInstance().getXML("config/ui/shiyi/shizBtn2.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.priceImg=this.getUIbyID("priceImg") as Image;
			this.useCb=this.getUIbyID("useCb") as CheckBox;
			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.swfloader=this.getUIbyID("swfloader") as SwfLoader;

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
			if (this != selectStid)
				this.setSt(false);
		}

		private function onClick(e:MouseEvent):void {
			
			if (selectStid != null && selectStid != this)
				selectStid.setSt(false);
			
			selectStid=this;
			this.setSt(true);
			
			if (e.target == this.useCb) {

				if (this.useCb.isOn) {

					if (UIManager.getInstance().shiyeWnd.getTitleCount() >= 3) {
						var str:String=StringUtil.substitute(TableManager.getInstance().getSystemNotice(23400).content, [TableManager.getInstance().getVipInfo(27).getVipValue(Core.me.info.vipLv)]);
						PopupManager.showAlert(str, null, false, "shiyialert");
						this.useCb.turnOff();
					} else
						Cmd_Syj.cmInstall(this.info.typeId);
				} else
					Cmd_Syj.cmUninstall(this.info.typeId);

			} else {
				
				Cmd_Syj.cmOpen(this.info.typeId);
			}

			e.stopImmediatePropagation();
		}

		public function updateInfo(info:TTitle):void {

			if (info != null)
				this.info=info;

			this.sortId=info.typeId;

			this.priceImg.fillEmptyBmd();
//			this.titleNameLbl.text="";

			if (int(info.model2) > 0) {

//				var url:String=TableManager.getInstance().getPnfInfo(info.model).imgId;
				this.swfloader.update(int(info.model2));
//				this.swfloader.update("scene/title/" + TableManager.getInstance().getPnfInfo(info.model).imgId, null, info.model);

				if (info.Bottom_Pic != "")
					this.priceImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");

			} else if (info.Bottom_Pic != "") {
				this.priceImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");
			} else {
//				this.titleNameLbl.text="" + info.name;
//				this.titleNameLbl.textColor=uint("0x" + info.fontColour);
//				this.titleNameLbl.filters=[FilterUtil.showBorder(uint("0x" + info.borderColour))];
			}


//			this.timeImg.visible=false;
//			this.useImg.visible=false;
//			this.filters=[FilterUtil.enablefilter];

//			this.mouseChildren=false;

		}

		public function setBgState(v:Boolean):void {
			if (v)
				this.useCb.turnOn();
			else
				this.useCb.turnOff();


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

		override public function get height():Number {
			return 73;
		}
	}
}

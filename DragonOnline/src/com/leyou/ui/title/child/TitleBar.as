package com.leyou.ui.title.child {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.MenuButton;
	import com.leyou.net.cmd.Cmd_Nck;
	import com.leyou.utils.FilterUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class TitleBar extends AutoSprite {

		private var bgImg:Image;
		private var swfloader:SwfLoader;
		private var titleNameLbl:Label;
		private var timeImg:Image;
		private var useImg:Image;
		private var bgeffImg:Image;
		private var openCb:CheckBox;

		private var stateBtn:MenuButton;

		private var info:TTitle;

		private var time:int=0;

		/**
		 *是否激活状态
		 */
		private var state:Boolean=false;

		/**
		 *按下特效处理
		 */
		public var isclick:Boolean=false;


		public function TitleBar() {
			super(LibManager.getInstance().getXML("config/ui/title/titleBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.swfloader=this.getUIbyID("swfloader") as SwfLoader;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.timeImg=this.getUIbyID("timeImg") as Image;
			this.useImg=this.getUIbyID("useImg") as Image;
			this.bgeffImg=this.getUIbyID("bgeffImg") as Image;

			this.openCb=this.getUIbyID("openCb") as CheckBox;

			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);

			this.openCb.addEventListener(MouseEvent.CLICK, onStateClick);

			this.scrollRect=new Rectangle(0,0,238,59)
			this.x=5;
		}

		/**
		 * 更新本地数据
		 * @param info
		 *
		 */
		public function updateInfo(info:TTitle):void {

			if (info != null)
				this.info=info;

			this.bgeffImg.bitmapData=null;
			this.titleNameLbl.text="";

			if (info.model > 0) {

//				var url:String=TableManager.getInstance().getPnfInfo(info.model).imgId;
				this.swfloader.update(info.model);
//				this.swfloader.update("scene/title/" + TableManager.getInstance().getPnfInfo(info.model).imgId, null, info.model);

				if (info.Bottom_Pic != "")
					this.bgeffImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");

			} else if (info.Bottom_Pic != "") {
				this.bgeffImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");
			} else {
				this.titleNameLbl.text="" + info.name;
				this.titleNameLbl.textColor=uint("0x" + info.fontColour);
				this.titleNameLbl.filters=[FilterUtil.showBorder(uint("0x" + info.borderColour))];
			}


			this.timeImg.visible=false;
			this.useImg.visible=false;
			this.filters=[FilterUtil.enablefilter];

			this.mouseChildren=false;
		}

		/**
		 *更新服务器数据
		 * @param o
		 *
		 */
		public function updateData(o:Object=null):void {

			if (o == null) {
				this.enable=false;
			} else {
				this.enable=true;

				if (this.info.time > 0) {
					this.timeImg.visible=true;
					if (o[1] > 0) {
						time=o[1];
					}
				} else
					this.setState(false);
			}
		}


		private function onStateClick(e:MouseEvent):void {

			if (!this.state) {
				Cmd_Nck.cm_NckStart(info.titleId);
			} else {
				Cmd_Nck.cm_NckUninstall(info.titleId);
			}

		}

		private function onRollOver(e:MouseEvent):void {
			this.BgState=true;
		}

		private function onRollOut(e:MouseEvent):void {
			if (!this.state && !this.isclick) {
				this.BgState=false;
			}
		}

		public function set BgState(v:Boolean):void {
			if (v)
				this.bgImg.updateBmp("ui/title/title_bg.png");
			else
				this.bgImg.updateBmp("ui/title/title_bg0.png");
		}

		/**
		 *设置状态
		 * @param v
		 *
		 */
		public function setState(v:Boolean):void {
			this.state=v;

			if (v) {
				this.BgState=true;
//				this.useImg.visible=true;

				this.openCb.turnOn();

				if (this.info.time > 0) {
					this.enable=true;
				}

			} else {

				this.openCb.turnOff();
				//如果是有倒计时的xxxx
				if (this.info.time > 0) {

					var d:Date=new Date();

//					if ((int(d.time / 1000) - (this.time + UIManager.getInstance().roleWnd.titlePanel.serverDiffTime)) > this.info.time) {
					if (this.time <= 0) {
						this.enable=false;
						this.timeImg.visible=false;
					}

					this.useImg.visible=false;
				} else {
					this.BgState=false;
					this.useImg.visible=false;
				}
			}
		}

		public function set enable(v:Boolean):void {
			if (!v) {
				this.filters=[FilterUtil.enablefilter];
				this.mouseChildren=false;
			} else {
				this.filters=[];
				this.mouseChildren=true;
			}
		}

		public function getState():Boolean {
			return this.state;
		}

		public function getTid():int {
			if (this.info == null)
				return -1;

			return this.info.titleId;
		}

		override public function get height():Number {
			return 58;
		}

		public function getTime():int {
			return this.time;
		}

		public function getType():int {
			return this.info.type;
		}

	}
}

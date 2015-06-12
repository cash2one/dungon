package com.leyou.ui.badge {

	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.utils.BadgeUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class BadgeRebud extends AutoWindow {

		private var upgradeBtn:NormalButton;

		private var lock1Cb:CheckBox;
		private var lock2Cb:CheckBox;
		private var lock3Cb:CheckBox;

		private var descLbl:Label;

		private var prop1Lbl:Label;
		private var prop2Lbl:Label;
		private var prop3Lbl:Label;

		private var value1Lbl:Label;
		private var value2Lbl:Label;
		private var value3Lbl:Label;

		private var notice1Lbl:Label;
		private var notice2Lbl:Label;
		private var notice3Lbl:Label;

		private var iconImg:Image;
		private var titleNameLbl:Label;

		public var index:int=0;

		private var descData:Object;

		private var color:Array=[0, 0, 0, 0];

		public function BadgeRebud() {
			super(LibManager.getInstance().getXML("config/ui/badge/badgeRebud.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
			this.hideBg();
		}

		private function init():void {

			this.upgradeBtn=this.getUIbyID("upgradeBtn") as NormalButton;

			this.lock1Cb=this.getUIbyID("lock1Cb") as CheckBox;
			this.lock2Cb=this.getUIbyID("lock2Cb") as CheckBox;
			this.lock3Cb=this.getUIbyID("lock3Cb") as CheckBox;

			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;

			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.prop1Lbl=this.getUIbyID("prop1Lbl") as Label;
			this.prop2Lbl=this.getUIbyID("prop2Lbl") as Label;
			this.prop3Lbl=this.getUIbyID("prop3Lbl") as Label;

			this.value1Lbl=this.getUIbyID("value1Lbl") as Label;
			this.value2Lbl=this.getUIbyID("value2Lbl") as Label;
			this.value3Lbl=this.getUIbyID("value3Lbl") as Label;

			this.notice1Lbl=this.getUIbyID("notice1Lbl") as Label;
			this.notice2Lbl=this.getUIbyID("notice2Lbl") as Label;
			this.notice3Lbl=this.getUIbyID("notice3Lbl") as Label;

			this.iconImg=this.getUIbyID("iconImg") as Image;

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.clsBtn.parent.addChild(this.clsBtn);
			this.titleLbl.parent.addChild(this.titleLbl);

			this.lock1Cb.addEventListener(MouseEvent.CLICK, onLockClick);
			this.lock2Cb.addEventListener(MouseEvent.CLICK, onLockClick);
			this.lock3Cb.addEventListener(MouseEvent.CLICK, onLockClick);

//			this.titleLbl.text="纹章洗练";

			this.clsBtn.y=5;
			this.titleNameLbl.text=PropUtils.getStringById(1637);
		}

		/**
		 * 更新服务器的随机生成的属性值;
		 * @param v
		 */
		public function updateData(o:Object):void {

			color=[0, 0, 0, 0]
			var str:String;
			for (str in o) {
				this["prop" + o[str][1] + "Lbl"].text=PropUtils.propArr[int(str) - 1] + ":";

				this["value" + o[str][1] + "Lbl"].textColor=this["notice" + o[str][1] + "Lbl"].textColor=BadgeUtil.getColorByconfig(this.index, int(str), o[str][0]);
				this["value" + o[str][1] + "Lbl"].text=o[str][0];

				if (this["value" + o[str][1] + "Lbl"].textColor == 0xf6d654)
					color[o[str][1]]=this["value" + o[str][1] + "Lbl"].textColor;

				var arr:Array=BadgeUtil.getColorRect(this.index, int(str));
				this["notice" + o[str][1] + "Lbl"].text="(" + arr[0] + "-" + arr[1] + ")";
				this["notice" + o[str][1] + "Lbl"].textColor=0xffffff;
			}

		}

		/**
		 * ui copy
		 * @param o
		 */
		public function updateUIToUI(o:Array, desc:Object):void {

			color=[0, 0, 0, 0]
			for (var i:int=0; i < o.length; i++) {
				if (i < 3) {
					this["prop" + (i + 1) + "Lbl"].text=o[i] + ":";
				} else {
					this["value" + (i - 2) + "Lbl"].textColor=this["notice" + (i - 2) + "Lbl"].textColor=BadgeUtil.getColorByconfig(this.index, PropUtils.propArr.indexOf(o[i - 3]) + 1, o[i]);
					this["value" + (i - 2) + "Lbl"].text=o[i];

					if (this["value" + (i - 2) + "Lbl"].textColor == 0xf6d654 && !this["lock" + (i - 2) + "Cb"].isOn)
						color[(i - 2)]=this["value" + (i - 2) + "Lbl"].textColor;

					var arr:Array=BadgeUtil.getColorRect(this.index, PropUtils.propArr.indexOf(o[i - 3]) + 1);

					this["notice" + (i - 2) + "Lbl"].text="(" + arr[0] + "-" + arr[1] + ")";
					this["notice" + (i - 2) + "Lbl"].textColor=0xffffff;
				}
			}

			if (UIManager.getInstance().badgeWnd.useCount > 0)
				this.descLbl.text=StringUtil.substitute(PropUtils.getStringById(1638), [UIManager.getInstance().badgeWnd.useCount]);
			else {
				if (desc != null) {
					this.descData=desc;

					i=1;
					if (this.lock1Cb.isOn)
						i++;

					if (this.lock2Cb.isOn)
						i++;

					if (this.lock3Cb.isOn)
						i++;

//					this.descLbl.text="花费金币：" + this.descData["m" + i] + "    魂力：" + this.descData["e" + i];
					this.descLbl.text=StringUtil.substitute(PropUtils.getStringById(1639), [this.descData["m" + i]+"    "]) + this.descData["e" + i];
				}
			}

			if (index == 10) {
				this.iconImg.updateBmp("ui/badge/badge_icon_10.png");
			} else
				this.iconImg.updateBmp("ui/badge/badge_icon_0" + index + ".png");
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show();

			var k:int=1;
			for (k=1; k < 4; k++) {
				this["lock" + k + "Cb"].setActive(true);
			}

			this.lock1Cb.turnOff();
			this.lock2Cb.turnOff();
			this.lock3Cb.turnOff();

			this.x=UIManager.getInstance().badgeWnd.x + (UIManager.getInstance().badgeWnd.width - this.width) / 2;
			this.y=UIManager.getInstance().badgeWnd.y + (UIManager.getInstance().badgeWnd.height - this.height) / 2;

			this.allowDrag=false;

//			UIManager.getInstance().badgeWnd.mouseChildren=false;
			UIManager.getInstance().badgeWnd.mouseEnabled=false;

			GuideManager.getInstance().showGuide(15, this.upgradeBtn);
		}

		override public function hide():void {
			super.hide();

			this.descData=null
			GuideManager.getInstance().removeGuide(15);
			UIManager.getInstance().badgeWnd.mouseChildren=true;
			UIManager.getInstance().badgeWnd.mouseEnabled=true;

			PopupManager.closeConfirm("badageAlert");
		}

		public function showPanel(o:Object):void {
			this.show();

			this.updateData(o.ws);

			var k:int=1;
			for (k=1; k < 4; k++) {
				this["lock" + k + "Cb"].setActive(true);
			}

			if (index == 10) {
				this.iconImg.updateBmp("ui/badge/badge_icon_10.png");
			} else
				this.iconImg.updateBmp("ui/badge/badge_icon_0" + index + ".png");
		}

		/**
		 * 更新描述
		 * @param o
		 *
		 */
		public function updateDesc(o:Object):void {
			this.descData=o;

			if (UIManager.getInstance().badgeWnd.useCount > 0)
				this.descLbl.text=StringUtil.substitute(PropUtils.getStringById(1638), [UIManager.getInstance().badgeWnd.useCount]);
			else {
				var i:int=1;
				if (this.lock1Cb.isOn)
					i++;

				if (this.lock2Cb.isOn)
					i++;

				if (this.lock3Cb.isOn)
					i++;

//				this.descLbl.text="花费金币：" + this.descData["m" + i] + "    魂力：" + this.descData["e" + i];
				this.descLbl.text=StringUtil.substitute(PropUtils.getStringById(1639), [this.descData["m" + i]+"    "]) + this.descData["e" + i];
			}
		}

		private function onLockClick(e:MouseEvent):void {

			var i:int=1;
			var k:int=1;

			if (this.lock1Cb.isOn)
				i++;

			if (this.lock2Cb.isOn)
				i++;

			if (this.lock3Cb.isOn)
				i++;

			if (i >= 3) {
				for (k=1; k < 4; k++) {
					if (!this["lock" + k + "Cb"].isOn) {
						break;
					}
				}

				this["lock" + k + "Cb"].setActive(false);

			} else {

				for (k=1; k < 4; k++) {
					if (!this["lock" + k + "Cb"].isActive) {
						this["lock" + k + "Cb"].setActive(true);
						break;
					}
				}

			}

			for (k=1; k < 4; k++) {

				if (this["value" + k + "Lbl"].textColor == 0xf6d654) {
					if (this["lock" + k + "Cb"].isOn) {
						color[k]=0;
					} else {
						color[k]=0xf6d654;
					}
				}
			}

			if (UIManager.getInstance().badgeWnd.useCount > 0)
				return;

			this.descLbl.text=StringUtil.substitute(PropUtils.getStringById(1639), [this.descData["m" + i]+"    "]) + this.descData["e" + i];
		}

		private function onBtnClick(e:MouseEvent):void {

			if (color.indexOf(0xf6d654) > -1) {
				PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(1512).content, onConfirm, null, false, "badageAlert");
			} else {
				this.onConfirm();
			}

		}

		private function onConfirm():void {
			var lock1arr:Array=[];

			if (this.lock1Cb.isOn)
				lock1arr.push(PropUtils.propArr.indexOf(this.prop1Lbl.text.replace(":", "")) + 1);

			if (this.lock2Cb.isOn)
				lock1arr.push(PropUtils.propArr.indexOf(this.prop2Lbl.text.replace(":", "")) + 1);

			if (this.lock3Cb.isOn)
				lock1arr.push(PropUtils.propArr.indexOf(this.prop3Lbl.text.replace(":", "")) + 1);

//			if (lock1arr.length == 2)
			Cmd_Bld.cm_bldUpgrade(index * 100 + 10, lock1arr[0], lock1arr[1]);
//			else
//				Cmd_Bld.cm_bldUpgrade(index * 100 + 10, lock1arr[0], 0);

			GuideManager.getInstance().removeGuide(15);
		}


	}
}

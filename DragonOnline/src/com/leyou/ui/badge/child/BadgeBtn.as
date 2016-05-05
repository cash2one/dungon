package com.leyou.ui.badge.child {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.GroupButton;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.utils.BadgeUtil;
	import com.leyou.utils.ColorUtil;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class BadgeBtn extends AutoSprite {

		private var key1Lbl:Label;
		private var key2Lbl:Label;
		private var key3Lbl:Label;

		private var value1Lbl:Label;
		private var value2Lbl:Label;
		private var value3Lbl:Label;

		private var arrowImg:Image;
		private var itemIcon:Image;
		private var upgradeBtn:ImgLabelButton;

		private var id:int=0;

		private var imgbg:ImgButton;
		private var activedLbl:Label;
		private var stArr:Array=[];

		public var descData:Object;
		public var o:Object;

		private var st:int=0;
		private var selectst:Boolean=false;

		public function BadgeBtn(id:int) {
			super(LibManager.getInstance().getXML("config/ui/badge/badgeBtn.xml"));
			this.id=id;
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.imgbg=this.getUIbyID("imgbg") as ImgButton;
			this.arrowImg=this.getUIbyID("arrowImg") as Image;

			this.stArr.push(this.getUIbyID("st1Img") as Image);
			this.stArr.push(this.getUIbyID("st2Img") as Image);
			this.stArr.push(this.getUIbyID("st3Img") as Image);

			this.key1Lbl=this.getUIbyID("key1Lbl") as Label;
			this.key2Lbl=this.getUIbyID("key2Lbl") as Label;
			this.key3Lbl=this.getUIbyID("key3Lbl") as Label;

			this.value1Lbl=this.getUIbyID("value1Lbl") as Label;
			this.value2Lbl=this.getUIbyID("value2Lbl") as Label;
			this.value3Lbl=this.getUIbyID("value3Lbl") as Label;

			this.activedLbl=this.getUIbyID("activedLbl") as Label;

			this.upgradeBtn=this.getUIbyID("upgradeBtn") as ImgLabelButton;
			this.itemIcon=this.getUIbyID("itemIcon") as Image;

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);

			if (id >= 10) {
				this.itemIcon.updateBmp("ui/badge/badge_icon_" + id + ".png");
			} else
				this.itemIcon.updateBmp("ui/badge/badge_icon_0" + id + ".png");

//			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.upgradeBtn.visible=false;
			this.arrowImg.visible=false;
		}

		private function onMouseOver(e:MouseEvent):void {
			if (this.st == 2 && this.selectst) {
				this.upgradeBtn.visible=true;
				this.arrowImg.visible=true;
			}
		}

		private function onMouseOut(e:MouseEvent):void {
			this.upgradeBtn.visible=false;
			this.arrowImg.visible=false;
		}

		private function onClick(e:MouseEvent):void {
			this.setMouseDownState();

			UIManager.getInstance().badgeRebudWnd.show();
			this.setRebudData();
		}

		public function setMouseDownState():void {
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.imgbg.turnOn();
		}

		public function setSelectState(v:Boolean):void {
			if (v) {
				this.imgbg.turnOn();
				if (this.st==2) {
					this.upgradeBtn.visible=true;
					this.arrowImg.visible=true;
				}
			} else {
				this.imgbg.turnOff();
				this.upgradeBtn.visible=false;
				this.arrowImg.visible=false;
			}

			this.selectst=v;
			
			if (!UIManager.getInstance().isCreate(WindowEnum.BADGEREBUD))
				UIManager.getInstance().creatWindow(WindowEnum.BADGEREBUD);
			
			if (UIManager.getInstance().badgeRebudWnd.visible)
				this.setRebudData();
			
		}

		/**
		 * 设置 item上的3个属性;
		 * @param o
		 *
		 */
		public function setProp(o:Object):void {

			this.o=o;
			var str:String;

			var i:int=0;
			for (str in o) {
//				this["key" + o[str][1] + "Lbl"].text=PropUtils.propArr[int(str) - 1] + ":";
//
//				this["value" + o[str][1] + "Lbl"].textColor=BadgeUtil.getColorByconfig(this.id, int(str), o[str][0]);
//				this["value" + o[str][1] + "Lbl"].text="+" + o[str][0];

				this.stArr[int(o[str][1]) - 1].updateBmp("ui/badge/star" + BadgeUtil.getItemUrlByconfig(this.id, int(str), o[str][0]) + ".png");

			}

			if (!UIManager.getInstance().isCreate(WindowEnum.BADGEREBUD))
				UIManager.getInstance().creatWindow(WindowEnum.BADGEREBUD);

			if (UIManager.getInstance().badgeRebudWnd.visible && UIManager.getInstance().badgeRebudWnd.index == id)
				this.setRebudData();
		}

		private function setRebudData():void {

			UIManager.getInstance().badgeRebudWnd.index=id;

			var str:String;
			var arr:Array=[];
			var i:int=0;
			for (str in this.o) {
				arr[int(this.o[str][1]) - 1]=PropUtils.propArr[int(str) - 1];
				arr[int(this.o[str][1]) - 1 + 3]=this.o[str][0];
				i++;
			}

			UIManager.getInstance().badgeRebudWnd.updateUIToUI(arr, descData);

		}

		/**
		 * 0,未激活; 1 已激活,2 洗点
		 * @param v
		 *
		 */
		public function set state(v:int):void {

			this.st=v;

			switch (v) {
				case 0:
//					this.activedLbl.visible=false;
//					this.upgradeBtn.visible=false;
					this.mouseChildren=this.mouseEnabled=false;
					this.filters=[FilterUtil.enablefilter];
					break;
				case 1:
//					this.activedLbl.visible=true;
//					this.upgradeBtn.visible=false;
					this.mouseChildren=this.mouseEnabled=true;
					this.filters=[];
					this.setStFilters(true);
					break;
				case 2:
//					this.activedLbl.visible=false;
//					this.upgradeBtn.visible=false;
					this.mouseChildren=this.mouseEnabled=true;
					this.filters=[];
					this.setStFilters(false);
					break;
			}
		}

		public function setStFilters(v:Boolean):void {
			for (var i:int=0; i < this.stArr.length; i++) {
				if (v)
					this.stArr[i].filters=[FilterUtil.enablefilter];
				else
					this.stArr[i].filters=[];
			}
		}

		override public function get width():Number {
			return 59;
		}

	}
}

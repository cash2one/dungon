package com.leyou.ui.badge.child {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.GroupButton;
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

		private var itemIcon:Image;
		private var upgradeBtn:ImgLabelButton;

		private var id:int=0;

		private var imgbg:GroupButton;
		private var activedLbl:Label;

		public var descData:Object;

		public function BadgeBtn(id:int) {
			super(LibManager.getInstance().getXML("config/ui/badge/badgeBtn.xml"));
			this.id=id;
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.imgbg=this.getUIbyID("imgbg") as GroupButton;

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

			if (id == 10) {
				this.itemIcon.updateBmp("ui/badge/badge_icon_10.png");
			} else
				this.itemIcon.updateBmp("ui/badge/badge_icon_0" + id + ".png");
		}

		private function onClick(e:MouseEvent):void {
			this.setMouseDownState();
			
			UIManager.getInstance().badgeRebudWnd.show();
			this.setRebudData();
		}
		
		public function setMouseDownState():void{
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.imgbg.turnOn();
		}

		/**
		 * 设置 item上的3个属性;
		 * @param o
		 *
		 */
		public function setProp(o:Object):void {

			var str:String;

			for (str in o) {
				this["key" + o[str][1] + "Lbl"].text=PropUtils.propArr[int(str) - 1] + ":";

				this["value" + o[str][1] + "Lbl"].textColor=BadgeUtil.getColorByconfig(this.id, int(str), o[str][0]);
				this["value" + o[str][1] + "Lbl"].text="+" + o[str][0];
			}

			if(!UIManager.getInstance().isCreate(WindowEnum.BADGEREBUD))
				UIManager.getInstance().creatWindow(WindowEnum.BADGEREBUD);
			
			if (UIManager.getInstance().badgeRebudWnd.visible && UIManager.getInstance().badgeRebudWnd.index == id)
				this.setRebudData();
		}

		private function setRebudData():void {

			UIManager.getInstance().badgeRebudWnd.index=id;

			//			var o:Object={};
			//			o[this.key1Lbl.text.replace(":","")]=this.value1Lbl.text;
			//			o[this.key2Lbl.text.replace(":","")]=this.value2Lbl.text;
			//			o[this.key3Lbl.text.replace(":","")]=this.value3Lbl.text;

			var arr:Array=[this.key1Lbl.text.replace(":", ""), this.key2Lbl.text.replace(":", ""), this.key3Lbl.text.replace(":", "")];
			arr.push(this.value1Lbl.text);
			arr.push(this.value2Lbl.text);
			arr.push(this.value3Lbl.text);

			UIManager.getInstance().badgeRebudWnd.updateUIToUI(arr, descData);

		}

		/**
		 * 0,未激活; 1 已激活,2 洗点
		 * @param v
		 *
		 */
		public function set state(v:int):void {
			switch (v) {
				case 0:
					this.activedLbl.visible=false;
					this.upgradeBtn.visible=false;
					this.mouseChildren=this.mouseEnabled=false;

					this.filters=[FilterUtil.enablefilter];
					break;
				case 1:
					this.activedLbl.visible=true;
					this.upgradeBtn.visible=false;
					this.mouseChildren=this.mouseEnabled=true;
					this.filters=[];
					break;
				case 2:
					this.activedLbl.visible=false;
					this.upgradeBtn.visible=true;
					this.mouseChildren=this.mouseEnabled=true;
					this.filters=[];
					break;
			}
		}


		override public function get width():Number{
			return 250;
		}
		
	}
}

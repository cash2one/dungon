package com.leyou.ui.backpack {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Store;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class BackAddWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var spaceLbl:Label;
		private var expLbl:Label;

		private var hpLbl:Label;

		private var byb:RadioButton;
		private var yb:RadioButton;

		private var timeLbl:Label;

		private var timer:int=0;

		private var type:int=0;

		public function BackAddWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/BackAddWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.spaceLbl=this.getUIbyID("spaceLbl") as Label;
//			this.expLbl=this.getUIbyID("expLbl") as Label;

			this.hpLbl=this.getUIbyID("hpLbl") as Label;

			this.byb=this.getUIbyID("byb") as RadioButton;
			this.yb=this.getUIbyID("yb") as RadioButton;

			this.yb.turnOn();

//			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					if (this.spaceLbl.text != null) {
						if (this.type == 1)
							Cmd_Bag.cm_bagExtendsGrid(int(this.spaceLbl.text), (this.byb.isOn ? 1 : 0));
						else
							Cmd_Store.cm_storeExtendsGrid(int(this.spaceLbl.text), (this.byb.isOn ? 1 : 0));
					}
					break;
				case "cancelBtn":
					break;
			}

			this.hide();
		}

		public function showPanel(obj:Object):void {
			this.spaceLbl.text=obj.num + "";
//			this.expLbl.text=obj.exp + "";

			this.hpLbl.text=obj.hp + "";
			this.yb.text="   " + obj.yb + "";
			this.byb.text="   " + obj.byb + "";

			timer=obj.time;

			this.type=obj.t;

//			this.timeLbl.text=TimeUtil.getIntToDateTime(obj.time) + "";

//			TimerManager.getInstance().add(exeTime);

			this.show();
		}

		private function exeTime(i:int):void {
			timer-=i;

			if (timer > 0) {
				this.timeLbl.text=TimeUtil.getIntToDateTime(timer) + "";
			} else {
				this.timeLbl.text=TimeUtil.getIntToDateTime(timer) + "";
				TimerManager.getInstance().remove(exeTime);
			}


		}


		override public function hide():void {
			super.hide();
			TimerManager.getInstance().remove(exeTime);

		}


		public function hidewnd(type:int=1):void {
			if (this.type == type)
				this.hide();
		}



	}
}

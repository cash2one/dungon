package com.leyou.ui.guild.child {
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.SOLManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class GuildWarWin extends AutoWindow {

		private var lastTimeLbl:Label;
		private var nameLbl:Label;
		private var countLbl:Label;
		private var numLbl:Label;
		private var bgLbl:Label;

		private var lastTime:int=0;

		private var viewck:CheckBox;

		public function GuildWarWin() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWarWin.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.x=UIEnum.WIDTH / 2 - this.width;
			this.x=UIEnum.HEIGHT / 2;
		}

		private function init():void {

			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.numLbl=this.getUIbyID("numLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;

			this.clsBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function updateInfo(o:Object):void {

			var obj:Object=SOLManager.getInstance().readCookie("guildViewWin");

			if (obj != null && obj.hasOwnProperty("st"))
				if (obj.st == 1)
					this.show(true, 1, false);

			this.lastTime=o.stime;
			this.lastTimeLbl.text="剩余时间: " + TimeUtil.getIntToTime(this.lastTime) + "";

			if (this.lastTime > 0) {
				TimerManager.getInstance().add(exeTime);
			}

			this.nameLbl.text=o.my[0] + "";
			this.bgLbl.text=o.my[1] + "";

			this.countLbl.text=o.un[2] + "";
			this.numLbl.text=o.dun[2] + "";
		}

		public function setViewCk(vst:CheckBox):void {
			this.viewck=vst;
		}

		public function showPanel():void {

			var obj:Object=SOLManager.getInstance().readCookie("guildViewWin");

			if (obj != null && obj.hasOwnProperty("st")) {
				if (obj.st == 1) {
					this.show(true, 1, false);

				} else
					super.hide();
			}
		}

		private function exeTime(i:int):void {

			if (this.lastTime - i > 0) {
				this.lastTimeLbl.text="剩余时间: " + TimeUtil.getIntToTime(this.lastTime - i) + "";
			} else {
				this.lastTime=0;
				TimerManager.getInstance().remove(exeTime);
				this.lastTimeLbl.text="剩余时间: 00:00:00";
			}

		}

		private function onClick(e:MouseEvent):void {

			super.hide();

			if (this.viewck != null)
				this.viewck.turnOff();

			SOLManager.getInstance().saveCookie("guildViewWin", {"st": 0});
		}

		override public function hide():void {

		}

	}
}

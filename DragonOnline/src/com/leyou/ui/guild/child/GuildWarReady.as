package com.leyou.ui.guild.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.utils.TimeUtil;

	public class GuildWarReady extends AutoSprite {

		private var runameLbl:Label;
		private var lunameLbl:Label;
		private var lastTimeLbl:Label;

		private var lpkstImg:Image;
		private var rpkstImg:Image;

		private var lastTime:int=0;

		public function GuildWarReady() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWarReady.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.rpkstImg=this.getUIbyID("rpkstImg") as Image;
			this.lpkstImg=this.getUIbyID("lpkstImg") as Image;

			this.runameLbl=this.getUIbyID("runameLbl") as Label;
			this.lunameLbl=this.getUIbyID("lunameLbl") as Label;
			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;
		}

		public function updateInfo(o:Object):void {

			this.lastTime=o.stime;
			this.lastTimeLbl.text="备战时间: " + TimeUtil.getIntToTime(this.lastTime) + "";

			if (this.lastTime > 0)
				TimerManager.getInstance().add(exeTime);

			this.lunameLbl.text=o.dun[1] + "";
			this.runameLbl.text=o.un[1] + "";

			if (o.ust == 1) {
				this.lpkstImg.updateBmp("ui/guild/font_tzf.png");
				this.rpkstImg.updateBmp("ui/guild/font_yzf.png");
			} else {
				this.lpkstImg.updateBmp("ui/guild/font_yzf.png");
				this.rpkstImg.updateBmp("ui/guild/font_tzf.png");
			}

		}

		private function exeTime(i:int):void {

			if (this.lastTime - i > 0) {
				this.lastTimeLbl.text="备战时间: " + TimeUtil.getIntToTime(this.lastTime - i) + "";

			} else {
				this.lastTime=0;
				TimerManager.getInstance().remove(exeTime);
				this.lastTimeLbl.text="备战时间: 00:00:00";
			}

		}


	}
}

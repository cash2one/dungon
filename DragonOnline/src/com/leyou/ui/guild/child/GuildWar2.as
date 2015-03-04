package com.leyou.ui.guild.child {

	import com.ace.enum.FontEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SOLManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Unw;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;

	public class GuildWar2 extends AutoSprite {

		private var lastTimeLbl:Label;
		private var lunameLbl:Label;
		private var runameLbl:Label;

		private var viewCk:CheckBox;

		private var lpreBtn:ImgButton;
		private var lnextBtn:ImgButton;
		private var rpreBtn:ImgButton;
		private var rnextBtn:ImgButton;

		private var rpageLbl:Label;
		private var lpageLbl:Label;

		private var tipLbl:Label;

		private var item1Arr:Vector.<GuildWar2Render>;
		private var item2Arr:Vector.<GuildWar2Render>;

		private var itemUid:Array=[];

		private var lastTime:int=0;
		private var pkstate:int=0;

		private var currentItem1Page:int=1;
		private var item1Count:int=0;

		private var currentItem2Page:int=1;
		private var item2Count:int=0;

		private var lprogressImg:Image;
		private var rprogressImg:Image;

		private var rarrowimg:Image;
		private var larrowImg:Image;

		private var lpkStImg:Image;
		private var rpkStimg:Image;

		private var lprogressLbl:Label;
		private var rprogressLbl:Label;

		private var meLbl:Label;

		public function GuildWar2() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWar2.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;
			this.lunameLbl=this.getUIbyID("lunameLbl") as Label;
			this.runameLbl=this.getUIbyID("runameLbl") as Label;

			this.tipLbl=this.getUIbyID("tipLbl") as Label;

			this.viewCk=this.getUIbyID("viewCk") as CheckBox;

			this.lpreBtn=this.getUIbyID("lpreBtn") as ImgButton;
			this.lnextBtn=this.getUIbyID("lnextBtn") as ImgButton;
			this.rpreBtn=this.getUIbyID("rpreBtn") as ImgButton;
			this.rnextBtn=this.getUIbyID("rnextBtn") as ImgButton;

			this.rpageLbl=this.getUIbyID("rpageLbl") as Label;
			this.lpageLbl=this.getUIbyID("lpageLbl") as Label;

			this.lprogressImg=this.getUIbyID("lprogressImg") as Image;
			this.rprogressImg=this.getUIbyID("rprogressImg") as Image;

			this.rarrowimg=this.getUIbyID("rarrowimg") as Image;
			this.larrowImg=this.getUIbyID("larrowImg") as Image;

			this.lpkStImg=this.getUIbyID("lpkStImg") as Image;
			this.rpkStimg=this.getUIbyID("rpkStimg") as Image;

			this.lprogressLbl=this.getUIbyID("lprogressLbl") as Label;
			this.rprogressLbl=this.getUIbyID("rprogressLbl") as Label;

			this.meLbl=this.getUIbyID("meLbl") as Label;

			this.viewCk.addEventListener(MouseEvent.CLICK, onClick)
			this.lpreBtn.addEventListener(MouseEvent.CLICK, onClick)
			this.lnextBtn.addEventListener(MouseEvent.CLICK, onClick)
			this.rpreBtn.addEventListener(MouseEvent.CLICK, onClick)
			this.rnextBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.meLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.meLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.meLbl.mouseEnabled=true;

			this.tipLbl.setToolTip(TableManager.getInstance().getSystemNotice(3069).content);

			this.item1Arr=new Vector.<GuildWar2Render>();
			this.item2Arr=new Vector.<GuildWar2Render>();

			var render:GuildWar2Render;
			var i:int=0;
			for (i=0; i < 10; i++) {
				render=new GuildWar2Render();

				render.x=2;
				render.y=134 + i * render.height;

				this.addChild(render);
				this.item1Arr.push(render);

				render.visible=false;

				render=new GuildWar2Render(1);

				render.x=308;
				render.y=134 + i * render.height;

				this.addChild(render);
				this.item2Arr.push(render);

				render.visible=false;
			}

			var obj:Object=SOLManager.getInstance().readCookie("guildViewWin");

			if (obj != null && obj.hasOwnProperty("st")) {
				if (obj.st == 1)
					this.viewCk.turnOn()
				else
					this.viewCk.turnOff();
			}

			if (UIManager.getInstance().isCreate(WindowEnum.GUILD_WAR_WIN))
				UIManager.getInstance().guildWarWin.setViewCk(this.viewCk);

			this.lnextBtn.visible=false;
			this.lpreBtn.visible=false;

			this.rnextBtn.visible=false;
			this.rpreBtn.visible=false;

			this.x=-16;
			this.y=3;

		}

		private function onClick(e:MouseEvent):void {

			var pageCount:int=0;

			switch (e.target.name) {
				case "meLbl":
					Cmd_Unw.cm_GuildPkMe();
					break;
				case "viewCk":

					SOLManager.getInstance().saveCookie("guildViewWin", {"st": (this.viewCk.isOn ? 1 : 0)});
					UIManager.getInstance().guildWarWin.showPanel();

					break;
				case "lpreBtn":
					this.currentItem1Page--;

					if (this.currentItem1Page < 1)
						this.currentItem1Page=1;

					this.lpageLbl.text=this.currentItem1Page + "/" + int(this.item1Count % 10 == 0 ? this.item1Count / 10 : this.item1Count / 10 + 1);
					Cmd_Unw.cm_GuildPkPage(this.itemUid[0], (this.currentItem1Page - 1) * 10 + 1, (this.currentItem1Page - 1) * 10 + 10);
					break;
				case "lnextBtn":
					this.currentItem1Page++;

					pageCount=(this.item1Count % 10 == 0 ? this.item1Count / 10 : this.item1Count / 10 + 1);
					if (this.currentItem1Page > pageCount)
						this.currentItem1Page=pageCount;

					this.lpageLbl.text=this.currentItem1Page + "/" + pageCount;
					Cmd_Unw.cm_GuildPkPage(this.itemUid[0], (this.currentItem1Page - 1) * 10 + 1, (this.currentItem1Page - 1) * 10 + 10);
					break;
				case "rpreBtn":

					this.currentItem2Page--;

					if (this.currentItem2Page < 1)
						this.currentItem2Page=1;

					this.rpageLbl.text=this.currentItem2Page + "/" + int(this.item2Count % 10 == 0 ? this.item2Count / 10 : this.item2Count / 10 + 1);
					Cmd_Unw.cm_GuildPkPage(this.itemUid[1], (this.currentItem2Page - 1) * 10 + 1, (this.currentItem2Page - 1) * 10 + 10);

					break;
				case "rnextBtn":
					this.currentItem2Page++;

					pageCount=(this.item2Count % 10 == 0 ? this.item2Count / 10 : this.item2Count / 10 + 1);
					if (this.currentItem2Page > pageCount)
						this.currentItem2Page=pageCount;

					this.rpageLbl.text=this.currentItem2Page + "/" + pageCount;
					Cmd_Unw.cm_GuildPkPage(this.itemUid[1], (this.currentItem2Page - 1) * 10 + 1, (this.currentItem2Page - 1) * 10 + 10);
					break;
			}
		}


		public function updateListInfo(o:Object):void {

			var render:GuildWar2Render;
			var _i:int=0;
			var i:int=this.itemUid.indexOf(o.uid);

			if (i == 1) {

				this.item2Count=o.znum;

				for (_i=0; _i < this.item2Arr.length; _i++) {
					if (o.rlist.length > _i) {
						this.item2Arr[_i].visible=true;
						this.item2Arr[_i].updateInfo(o.rlist[_i]);
					} else
						this.item2Arr[_i].visible=false;
				}

				if (o.rlist.length > 0) {
					
					this.rnextBtn.visible=true;
					this.rpreBtn.visible=true;

					this.currentItem1Page=int(o.rlist[0][0])%10==0?int(o.rlist[0][0])/10:int(o.rlist[0][0])/10+1;
					this.rpageLbl.text=this.currentItem1Page+ "/" + int(this.item2Count % 10 == 0 ? this.item2Count / 10 : this.item2Count / 10 + 1);

				} else {
					this.rnextBtn.visible=false;
					this.rpreBtn.visible=false;
				}

			} else if (i == 0) {

				this.item1Count=o.znum;

				for (_i=0; _i < this.item1Arr.length; _i++) {
					if (o.rlist.length > _i) {
						this.item1Arr[_i].visible=true;
						this.item1Arr[_i].updateInfo(o.rlist[_i]);
					} else
						this.item1Arr[_i].visible=false;
				}

				if (o.rlist.length > 0) {
					
					this.lnextBtn.visible=true;
					this.lpreBtn.visible=true;
					
					this.currentItem2Page=int(o.rlist[0][0])%10==0?int(o.rlist[0][0])/10:int(o.rlist[0][0])/10+1;
					this.lpageLbl.text=this.currentItem2Page + "/" + int(this.item1Count % 10 == 0 ? this.item1Count / 10 : this.item1Count / 10 + 1);

				} else {
					this.lnextBtn.visible=false;
					this.lpreBtn.visible=false;
				}
			}

		}

		public function updateInfo(o:Object):void {

			this.itemUid=[o.un[0], o.dun[0]];
			this.pkstate=o.st;

			if (this.pkstate == 2) {
				
				this.lpkStImg.visible=true;
				this.rpkStimg.visible=true;
				this.viewCk.turnOff();
				this.viewCk.visible=false;
				this.tipLbl.visible=false;

				if (o.un[2] == o.dun[2]) {
					this.lpkStImg.updateBmp("ui/guild/font_ping.png");
					this.rpkStimg.updateBmp("ui/guild/font_ping.png");
				} else if (o.un[2] > o.dun[2]) {
					this.lpkStImg.updateBmp("ui/guild/font_sheng.png");
					this.rpkStimg.updateBmp("ui/guild/font_bai.png");
				} else {
					this.lpkStImg.updateBmp("ui/guild/font_bai.png");
					this.rpkStimg.updateBmp("ui/guild/font_sheng.png");
				}

				this.lastTime=o.stime;
				this.lastTimeLbl.text="冷却时间: " + TimeUtil.getIntToTime(this.lastTime) + "";

			} else {

				this.lpkStImg.visible=false;
				this.rpkStimg.visible=false;
				this.tipLbl.visible=true;
				this.viewCk.visible=true;

				this.lastTime=o.stime;
				this.lastTimeLbl.text="剩余时间: " + TimeUtil.getIntToTime(this.lastTime) + "";
			}

			if (this.lastTime > 0)
				TimerManager.getInstance().add(exeTime);

			this.lunameLbl.text=o.un[1] + "";

			this.lprogressLbl.text=o.un[2] + "/" + ConfigEnum.union16;
			this.lprogressImg.x=104 + 197;

			this.lprogressImg.scaleX=-int(o.un[2]) / ConfigEnum.union16;
			this.larrowImg.x=this.lprogressImg.x - int(o.un[2]) / ConfigEnum.union16 * 197 - 10;

			this.runameLbl.text=o.dun[1] + "";

			this.rprogressLbl.text=o.dun[2] + "/" + ConfigEnum.union16;
			this.rprogressImg.setWH(int(o.dun[2]) / ConfigEnum.union16 * 197, 14);
			this.rarrowimg.x=this.rprogressImg.x + int(o.dun[2]) / ConfigEnum.union16 * 197 - 3;

			if (UIManager.getInstance().guildWnd.visible && o.st >= 1) {
				Cmd_Unw.cm_GuildPkPage(o.un[0], (this.currentItem1Page - 1) * 10 + 1, (this.currentItem1Page - 1) * 10 + 10);
				Cmd_Unw.cm_GuildPkPage(o.dun[0], (this.currentItem2Page - 1) * 10 + 1, (this.currentItem2Page - 1) * 10 + 10);
			}

		}

		private function exeTime(i:int):void {

			if (this.lastTime-i > 0) {
				
				if (this.pkstate == 2)
					this.lastTimeLbl.text="冷却时间: " + TimeUtil.getIntToTime(this.lastTime-i) + "";
				else
					this.lastTimeLbl.text="剩余时间: " + TimeUtil.getIntToTime(this.lastTime-i) + "";

			} else {
				this.lastTime=0;
				TimerManager.getInstance().remove(exeTime);

				if (this.pkstate == 2)
					this.lastTimeLbl.text="冷却时间: 00:00:00";
				else
					this.lastTimeLbl.text="剩余时间: 00:00:00";
			}

		}



	}
}

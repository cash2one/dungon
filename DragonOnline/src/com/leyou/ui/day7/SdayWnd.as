package com.leyou.ui.day7 {


	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TKeep_7;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.TimeUtil;
	import com.greensock.TweenMax;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Day7;
	import com.leyou.ui.day7.child.Day7Grid;
	import com.leyou.ui.day7.child.SdayBtn;
	import com.leyou.ui.day7.child.SdayPic;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.TimeUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	public class SdayWnd extends AutoWindow {

		private var progressImg:Image;
		private var accpetBtn:ImgButton;
		private var dayImg:Image;
		private var gImgArr:Array=[];

		private var sdayPicArr:Array=[];
		private var dayGridArr:Vector.<Day7Grid>
		private var dayBtnArr:Vector.<SdayBtn>

		private var currentDay:int=0;
		private var selectDay:int=0;
		private var dataobj:Object
		private var tween:TweenMax;

		public function SdayWnd() {
			super(LibManager.getInstance().getXML("config/ui/7day/sdayWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;

			this.clsBtn.y=40;
			this.clsBtn.x-=50;
		}

		private function init():void {

			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.accpetBtn=this.getUIbyID("accpetBtn") as ImgButton;
			this.dayImg=this.getUIbyID("dayImg") as Image;

			this.gImgArr.push(this.getUIbyID("g1Img") as Image);
			this.gImgArr.push(this.getUIbyID("g2Img") as Image);
			this.gImgArr.push(this.getUIbyID("g3Img") as Image);
			this.gImgArr.push(this.getUIbyID("g4Img") as Image);
			this.gImgArr.push(this.getUIbyID("g5Img") as Image);

			this.accpetBtn.addEventListener(MouseEvent.CLICK, onClick);

			var pp:PerspectiveProjection;
			var sdpic:SdayPic;
			for (var i:int=0; i < 7; i++) {
				sdpic=new SdayPic();
				sdpic.updateBgImage(i + 1);

				this.addChild(sdpic);
				this.sdayPicArr.push(sdpic);

				sdpic.x=228 + i * 72;
				sdpic.y=213;

				pp=new PerspectiveProjection();
				pp.fieldOfView=90;
				pp.projectionCenter=new Point(sdpic.x + 3, 229 / 2);

				sdpic.transform.perspectiveProjection=pp;

				sdpic.addEventListener(MouseEvent.CLICK, onItemClick);
			}

			this.dayGridArr=new Vector.<Day7Grid>();

			var g:Day7Grid;
			for (i=0; i < 5; i++) {
				g=new Day7Grid();

				this.addChild(g);
				this.dayGridArr.push(g);

				g.x=293 + i * 72;
				g.y=445;

			}

			this.dayBtnArr=new Vector.<SdayBtn>();

			var btn:SdayBtn;

			for (i=0; i < 7; i++) {
				btn=new SdayBtn();

				btn.updateNumImage(i + 1);

				this.addChild(btn);
				this.dayBtnArr.push(btn);

				btn.x=258 + i * ((this.progressImg.width + btn.width) / 7)
				btn.y=153;

				btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}

		}

		private function onBtnClick(e:MouseEvent):void {

			this.updateEffect(this.dayBtnArr.indexOf(e.target.parent));

			for (var i:int=0; i < this.dayBtnArr.length; i++) {
				this.dayBtnArr[i].setHight(false)
			}

			this.dayBtnArr[this.dayBtnArr.indexOf(e.target.parent)].setHight(true)

			this.updateReward(this.selectDay);
		}

		private function onItemClick(e:MouseEvent):void {
			this.updateEffect(this.sdayPicArr.indexOf(e.target));

			for (var i:int=0; i < this.dayBtnArr.length; i++) {
				this.dayBtnArr[i].setHight(false)
			}

			this.dayBtnArr[this.selectDay - 1].setHight(true)

			this.updateReward(this.selectDay);
		}


		private function onClick(e:MouseEvent):void {
			Cmd_Day7.cmAccpet(this.selectDay);
		}

		override public function sendOpenPanelProtocol(... parameters):void {

			this.dataModel=parameters;

			Cmd_Day7.cmInit();
		}

		public function updateInfo(o:Object):void {

			if (!o.hasOwnProperty("logind"))
				return;

			UIManager.getInstance().showPanelCallback(WindowEnum.KEEP_7);

			if (tween != null) {
				tween.pause();
				tween.kill();
				tween=null;
			}


			if (this.currentDay > 0)
				this.dayBtnArr[this.currentDay - 1].filters=[];

			var ld:int=o.logind;
			if (o.logind > 7)
				ld=7;

			tween=TweenMax.to(this.dayBtnArr[ld - 1], 1, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

			this.currentDay=ld;

			this.dataobj=o;

			if (this.selectDay == 0)
				this.selectDay=this.currentDay;


			var dlist:Array=o.dlist;
			var isfull:Boolean=true;
			for (var i:int=0; i < dlist.length; i++) {
				if (i < this.currentDay)
					this.sdayPicArr[i].setState(dlist[i]);
				else
					this.sdayPicArr[i].setState(2);

				if (i > this.currentDay - 1)
					this.dayBtnArr[i].filters=[FilterUtil.enablefilter];
				else
					this.dayBtnArr[i].filters=[];

				if (dlist[i] == 0)
					isfull=false;
			}

			if (isfull)
				UIManager.getInstance().rightTopWnd.deactive("sevenDayBtn");
			else
				UIManager.getInstance().rightTopWnd.active("sevenDayBtn");

			this.dayImg.updateBmp("ui/num/" + this.currentDay + "_zdl.png");
			this.progressImg.setWH((458 + 64) / 7 * (this.currentDay - 1), 20);

			this.updateEffect(this.selectDay - 1);
			this.updateReward(this.selectDay);
		}

		private function updateReward(d:int):void {

			var kinfo:TKeep_7=TableManager.getInstance().getKeep7ByDay(d);
			if (kinfo == null)
				return;

			var arr:Array=kinfo.getNotEmptyField();

			var i:int=0;
			var str:String;
			for each (str in arr) {

				if (i >= 5)
					break;

				switch (str) {
					case "exp":
						this.dayGridArr[i].updateExp();
						this.dayGridArr[i].setNum(kinfo.exp)
						break;
					case "energy":
						this.dayGridArr[i].updateHun();
						this.dayGridArr[i].setNum(kinfo.energy)
						break;
					case "money":
						this.dayGridArr[i].updateMoney();
						this.dayGridArr[i].setNum(kinfo.money)
						break;
					case "bg":
						this.dayGridArr[i].updateBg()
						this.dayGridArr[i].setNum(kinfo.bg)
						break;
					case "Honor":
						this.dayGridArr[i].updateHounur()
						this.dayGridArr[i].setNum(kinfo.Honor)
						break;
					case "Byb":
						this.dayGridArr[i].updateByb();
						this.dayGridArr[i].setNum(kinfo.Byb)
						break;
					default:
						if (str.indexOf("item") > -1) {

							if (kinfo[str] < 10000)
								this.dayGridArr[i].updataInfo(TableManager.getInstance().getEquipInfo(kinfo[str]));
							else
								this.dayGridArr[i].updataInfo(TableManager.getInstance().getItemInfo(kinfo[str]));

							this.dayGridArr[i].setNum(kinfo["num" + str.charAt(str.length - 1)])
						}
				}


				this.dayGridArr[i].setSize(60, 60);
				this.dayGridArr[i].visible=true;
				this.gImgArr[i].visible=true;
				i++;
			}


			while (i < 5) {
				this.dayGridArr[i].visible=false;
				this.gImgArr[i].visible=false;
				i++;
			}

		}

		private function updateEffect(idx:int):void {

//			this.z=0;

			var i:int=0;
			for (i=0; i < idx; i++) {
				this.sdayPicArr[i].setMask(true)

				this.sdayPicArr[i].z=1;
				this.addChild(this.sdayPicArr[i]);

				TweenMax.to(this.sdayPicArr[i], 0.2, {x: 228 + i * 52, y: 213, scaleY: 0.97, rotationY: -20, onComplete: onComplete, onCompleteParams: [this.sdayPicArr[i]]});
			}


			for (i=6; i > idx; i--) {
				this.sdayPicArr[i].setMask(true)

				this.sdayPicArr[i].z=145 * Math.sin(20 * (Math.PI / 180));

				this.addChild(this.sdayPicArr[i]);

				TweenMax.to(this.sdayPicArr[i], 0.2, {x: 228 + 72 + i * 52, y: 213, scaleY: 0.97, rotationY: 20, onComplete: onComplete, onCompleteParams: [this.sdayPicArr[i]]});

			}

			this.sdayPicArr[idx].setMask(false)
//			this.sdayPicArr[idx].rotationY=0;
//			this.sdayPicArr[idx].rotationX=0;
//			this.sdayPicArr[idx].z=1;
//			this.sdayPicArr[idx].scaleX=1.1;
			this.sdayPicArr[idx].scaleY=1;
//			this.sdayPicArr[idx].scaleZ=1;
			this.addChild(this.sdayPicArr[idx]);
			TweenMax.to(this.sdayPicArr[idx], 0.3, {x: 228 + 25 + idx * 52, y: 203, z: 1, rotationY: 0, rotationX: 0});

			if (this.dataobj.dlist[idx] == 1 || idx > this.currentDay - 1) {
				GuideManager.getInstance().removeGuide(112);
				this.accpetBtn.setActive(false, 0.6, true)
			} else {
				this.accpetBtn.setActive(true, 1, true)
				GuideManager.getInstance().showGuide(112, this.accpetBtn);
			}

			this.selectDay=idx + 1;
		}

		private function onComplete(d:DisplayObjectContainer):void {

			d.mouseEnabled=true;
		}

		public function rewardFlyBag():void {

			var flyArr:Array=[[], []];
			var mgrid:Day7Grid;
			for each (mgrid in this.dayGridArr) {
				if (mgrid != null) {
					flyArr[0].push(mgrid.dataId);
					flyArr[1].push(mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y)));
				}
			}

			FlyManager.getInstance().flyBags(flyArr[0], flyArr[1]);
		}

		override public function hide():void {
			super.hide();
			GuideManager.getInstance().removeGuide(112);
			this.selectDay=0;
		}

	}
}

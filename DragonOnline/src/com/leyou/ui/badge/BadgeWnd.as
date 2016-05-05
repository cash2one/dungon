package com.leyou.ui.badge {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.ui.badge.child.BadgeBg01;
	import com.leyou.ui.badge.child.BadgeBtn;
	import com.leyou.utils.PlayerUtil;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BadgeWnd extends AutoWindow {

		private var gridList:ScrollPane;
		private var badgeBg01:BadgeBg01;
		private var iconImg:Image;
		private var powerTxt:Label;
		private var tbarImg:Image;
		private var Img01:Image;
		private var items:Vector.<BadgeBtn>;

		private var noteLen:int=0;

		/**
		 * 当前开启位置
		 */
		public var currentOpenPoint:int=0;

		/**
		 * 使用次数
		 */
		public var useCount:int=0;
		public var currentIndex:int=0;

		public var rollPower:RollNumWidget;
		private var ws:Object;

		public function BadgeWnd() {
			super(LibManager.getInstance().getXML("config/ui/badgeWnd.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

//			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.powerTxt=this.getUIbyID("powerTxt") as Label;
			this.tbarImg=this.getUIbyID("tbarImg") as Image;
//			this.Img01=this.getUIbyID("Img01") as Image;

			this.badgeBg01=new BadgeBg01();
			this.addChild(this.badgeBg01);
			this.badgeBg01.x=10;
			this.badgeBg01.y=62;

			this.addChild(this.tbarImg);
			this.addChild(this.powerTxt);
			this.addChild(this.iconImg);

			var xmllib:XML=LibManager.getInstance().getXML("config/table/bloodPoint.xml");
			this.noteLen=xmllib.bloodPoint.length();
			this.items=new Vector.<BadgeBtn>();

			var bbg:BadgeBtn;
			for (var i:int=0; i < this.noteLen; i++) {
				bbg=new BadgeBtn(i + 1);

				this.addChild(bbg);
				this.items.push(bbg);

				bbg.x=10 + i * (bbg.width + 11.3);
				bbg.y=412;

				bbg.addEventListener(MouseEvent.CLICK, onItemClick);
			}

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=168;
			this.rollPower.y=72;

//			NetGate.getInstance().send("money|999999999");
//			NetGate.getInstance().send("energy|99999");
		}

		public function updateList(o:Object):void {


			if (o.hasOwnProperty("ls"))
				this.currentOpenPoint=o.ls;

			if (o.hasOwnProperty("wn"))
				this.useCount=o.wn;

			this.ws=o.wt;

			var bbg:BadgeBtn;
			for (var i:int=0; i < this.noteLen; i++) {
				bbg=this.items[i];

				if (o.hasOwnProperty("lk") && o.lk[i + 1])
					bbg.descData=o.lk[i + 1];

				if (o.hasOwnProperty("wt") && o.wt[i + 1])
					bbg.setProp(o.wt[i + 1]);

				if (i >= int(this.currentOpenPoint / 100))
					bbg.state=0;
				else if (i < int(this.currentOpenPoint / 100) - 1) {
					bbg.state=2;
				} else {
					bbg.state=1;
				}

			}

			if (!UIManager.getInstance().isCreate(WindowEnum.BADGEREBUD))
				UIManager.getInstance().creatWindow(WindowEnum.BADGEREBUD);

			if (UIManager.getInstance().badgeRebudWnd.index != 0 && UIManager.getInstance().badgeRebudWnd.visible) {
				this.items[currentIndex - 1].setSelectState(true);
			} else {
				//default
				if (this.currentOpenPoint == (this.noteLen + 1) * 100)
					this.items[0].setMouseDownState();
				else {
					this.items[int(this.currentOpenPoint / 100) - 1].setMouseDownState();
				}
			}

			if (ConfigEnum.BadgeOpenLv <= Core.me.info.level)
				UIManager.getInstance().toolsWnd.wenZBtn.setActive(true, 1, true);
			else
				UIManager.getInstance().toolsWnd.wenZBtn.setActive(false, .6, true);

			this.rollPower.rollToNum(o.zdl);

			if (this.ws != null)
				this.badgeBg01.updateData(this.currentIndex, this.ws[currentIndex]);
			else
				this.badgeBg01.updateData(this.currentIndex);

//			TweenLite.delayedCall(2.2,GuideDirectManager.getInstance().getGuideOrBadgeByType,[2]);
			
			UIManager.getInstance().showPanelCallback(WindowEnum.BADAGE);
		}

		/**
		 * @param o
		 */
		public function updateNode(o:Object):void {
			this.currentOpenPoint=o.nx;
			this.rollPower.rollToNum(o.zdl);

			//default
			if (this.currentOpenPoint % 100 != 0)
				this.items[int(this.currentOpenPoint / 100) - 1].setMouseDownState();

			this.openNodePlay();
			SoundManager.getInstance().play(24);

//			GuideDirectManager.getInstance().getGuideByType(2);
		}

		/**
		 * 更新 点数
		 * @param o
		 *
		 */
		public function updatePoint(o:Object):void {
			if (int(this.currentOpenPoint / 100) - 1 >= 10)
				return;

			this.items[int(this.currentOpenPoint / 100) - 1].setProp(o.ws);

			UIManager.getInstance().badgeRebudWnd.index=int(this.currentOpenPoint / 100);
			UIManager.getInstance().badgeRebudWnd.showPanel(o);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			if (this.currentOpenPoint == 100)
//				GuideManager.getInstance().showGuide(14, this);

			GuideManager.getInstance().removeGuide(12);
			GuideManager.getInstance().removeGuide(13);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_BadgeNodeNum);

			this.iconImg.updateBmp(PlayerUtil.getPlayerHeadImg(Core.me.info.profession, Core.me.info.sex));
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			Cmd_Bld.cm_bldOpen();
		}

		private function onItemClick(e:MouseEvent):void {

			var bbg:BadgeBtn;
			for (var i:int=0; i < this.noteLen; i++) {
				bbg=this.items[i];
				bbg.setSelectState(false);
			}

			this.currentIndex=this.items.indexOf(e.currentTarget as BadgeBtn) + 1;
			var bad:BadgeBtn=e.currentTarget as BadgeBtn;
			bad.setSelectState(true);

			if (this.ws != null)
				this.badgeBg01.updateData(this.currentIndex, this.ws[currentIndex]);
			else
				this.badgeBg01.updateData(this.currentIndex);
		}

		/**
		 *开启节点动画
		 *
		 */
		public function openNodePlay():void {
			this.badgeBg01.openNodeEffect();
		}

		override public function hide():void {
			super.hide();

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.BADAGE + "");

			UIManager.getInstance().hideWindow(WindowEnum.BADGEREBUD);
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.wenZBtn);
//			GuideManager.getInstance().removeGuide(14);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_BadgeNodeNum);
		}

		override public function getUIbyID(id:String):DisplayObject {
			var ds:DisplayObject=super.getUIbyID(id);

			if (ds == null) {

				var ibtn:MovieClip;
				for (var i:int=0; i < 10; i++) {
					ibtn=badgeBg01.getPoint(i) as MovieClip;
					if (ibtn.currentFrame != 3) {
						ds=badgeBg01.getPoint(i);
						break;
					}
				}

			}

			return ds;
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		override public function get width():Number {
			return 854;
		}

		override public function get height():Number {
			return 544;
		}

	}
}

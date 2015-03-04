package com.leyou.ui.badge {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.ui.badge.child.BadgeBg01;
	import com.leyou.ui.badge.child.BadgeBtn;

	import flash.events.MouseEvent;

	public class BadgeWnd extends AutoWindow {

		private var gridList:ScrollPane;
		private var badgeBg01:BadgeBg01;
		private var items:Vector.<BadgeBtn>;

		/**
		 * 当前开启位置
		 */
		public var currentOpenPoint:int=0;

		/**
		 * 使用次数
		 */
		public var useCount:int=0;

		public function BadgeWnd() {
			super(LibManager.getInstance().getXML("config/ui/badgeWnd.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.badgeBg01=new BadgeBg01();
			this.addToPane(this.badgeBg01);

			this.badgeBg01.x=330;
			this.badgeBg01.y=51;

			this.items=new Vector.<BadgeBtn>();

			var bbg:BadgeBtn;
			for (var i:int=0; i < 10; i++) {
				bbg=new BadgeBtn(i + 1);

				this.gridList.addToPane(bbg);
				this.items.push(bbg);

				bbg.x=5;
				bbg.y=-2 + i * bbg.height / 3;

				bbg.addEventListener(MouseEvent.CLICK, onItemClick);
			}

//			NetGate.getInstance().send("money|999999999");
//			NetGate.getInstance().send("energy|99999");
		}

		public function updateList(o:Object):void {

			UIManager.getInstance().showPanelCallback(WindowEnum.BADAGE);

			if (o.hasOwnProperty("ls"))
				this.currentOpenPoint=o.ls;

			if (o.hasOwnProperty("wn"))
				this.useCount=o.wn;

			var bbg:BadgeBtn;
			for (var i:int=0; i < 10; i++) {
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

			} else {
				//default
				if (this.currentOpenPoint == 1100)
					this.items[0].setMouseDownState();
				else
					this.items[int(this.currentOpenPoint / 100) - 1].setMouseDownState();
			}

			if (ConfigEnum.BadgeOpenLv <= Core.me.info.level)
				UIManager.getInstance().toolsWnd.wenZBtn.setActive(true, 1, true);
			else
				UIManager.getInstance().toolsWnd.wenZBtn.setActive(false, .6, true);
		}

		/**
		 * @param o
		 */
		public function updateNode(o:Object):void {
			this.currentOpenPoint=o.nx;

			//default
			this.items[int(this.currentOpenPoint / 100) - 1].setMouseDownState();

			this.openNodePlay();
			SoundManager.getInstance().play(24);
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


			GuideManager.getInstance().showGuide(14, this);
			GuideManager.getInstance().removeGuide(12);
			GuideManager.getInstance().removeGuide(13);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_BadgeNodeNum);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			Cmd_Bld.cm_bldOpen();
		}

		private function onItemClick(e:MouseEvent):void {
			this.badgeBg01.updateData(this.items.indexOf(e.currentTarget as BadgeBtn) + 1);
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

			UIManager.getInstance().hideWindow(WindowEnum.BADGEREBUD);
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.wenZBtn);
			GuideManager.getInstance().removeGuide(14);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_BadgeNodeNum);
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		override public function get width():Number {
			return 810;
		}

		override public function get height():Number {
			return 512;
		}

	}
}

package com.leyou.ui.copyTrack {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_EXPC;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class ExpCopyTrackBar extends AutoSprite {
//		protected var leaveBtn:ImgButton;

		protected var doubleBtn:ImgButton;

		protected var doubleExpLbl:Label;

//		protected var costLbl:Label;

		protected var expLbl:Label;

//		protected var boxLbl:Label;

		protected var timeLbl:Label;

		protected var stayTime:uint;

		protected var expRemain:uint;

		private var doubleCostLbl:Label;

		private var timeLbl0:Label;
		private var timeLbl1:Label;

		protected var tick:uint;

		private var addLbl:Label;

		private var grid:MarketGrid;

		private var cexp:Number=0;

		public function ExpCopyTrackBar() {
			super(LibManager.getInstance().getXML("config/ui/monsterScTrack.xml"));
			init();
		}

		private function init():void {

//			mouseEnabled = true;
			mouseChildren=true;
//			leaveBtn = getUIbyID("leaveBtn") as ImgButton;

			doubleBtn=getUIbyID("doubleBtn") as ImgButton;
			doubleExpLbl=getUIbyID("doubleExpLbl") as Label;
			expLbl=getUIbyID("expLbl") as Label;
//			costLbl = getUIbyID("costLbl") as Label;
//			boxLbl = getUIbyID("boxLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			addLbl=getUIbyID("addLbl") as Label;
			doubleCostLbl=getUIbyID("doubleCostLbl") as Label;

			timeLbl0=getUIbyID("timeLbl0") as Label;
			timeLbl1=getUIbyID("timeLbl1") as Label;


			grid=new MarketGrid();
			grid.x=10;
			grid.y=131;
			grid.isShowPrice=false;
			addChild(grid);
			grid.updataById(21000);

//			leaveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			doubleBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			this.addLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			
			this.addLbl.htmlText="<a href='event:#'>"+this.addLbl.text+"</a>";
			addLbl.addEventListener(MouseEvent.CLICK, onButtonClick);
			addLbl.mouseEnabled=true;
		}

		protected function onButtonClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "leaveBtn":
					Cmd_EXPC.cm_Exp_L();
					break;
				case "addLbl":
					PayUtil.openPayUrl();
					break;
				case "doubleBtn":
					UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
					UIManager.getInstance().quickBuyWnd.pushItem(21000, 21001);
//					var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(5204);
//					if(notice){
//						PopupManager.showConfirm(com.ace.utils.StringUtil.substitute(notice.content, ConfigEnum.ExpCopyCost), Cmd_EXPC.cm_Exp_B, null, false, "expCopy.track.buy");
////						var wndInfo:WindInfo = WindInfo.getConfirmInfo(notice.content, Cmd_EXPC.cm_Exp_B);
////						PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, wndInfo, "expCopy.track.buy");
//					}
					break;
			}
		}

		public function resize():void {
			x=(UIEnum.WIDTH - 271);
			y=((UIEnum.HEIGHT - 246) >> 1) + 13;
		}

		public function updateInfo(obj:Object):void {
			tick=getTimer();
			stayTime=obj.csec;
			expRemain=obj.expsec;
			expLbl.text=obj.cexp ? obj.cexp : "0";
//			costLbl.htmlText = (0 == obj.emoney) ? PropUtils.getStringById(1673) : "<Font size='12' color='#FFD200'>"+obj.cmoney +"</Font><Font size='12' color='#FF00'>(" + obj.emoney + "/"+PropUtils.getStringById(2147)+")</Font>";
//			boxLbl.text = obj.box.cc + "/" + obj.box.cm;
			doubleCostLbl.text=obj.bprice;
		}

		public function updateExpTime():void {

			if (!this.visible)
				return;

			if (Core.me.info.baseInfo.exp == cexp)
				return;

			if (this.cexp == 0) {
				this.cexp=Core.me.info.baseInfo.exp;
				return;
			}

			var t:int=((Core.me.info.baseInfo.maxExp - Core.me.info.baseInfo.exp) / (Core.me.info.baseInfo.exp - cexp) * 3);
			this.timeLbl0.text="" + TimeUtil.getIntToTime(t);

			t=((Core.me.info.baseInfo.maxExp - Core.me.info.baseInfo.exp) / (Core.me.info.baseInfo.exp - cexp) / 1.5 * 3);
			this.timeLbl1.text="" + TimeUtil.getIntToTime(t);

			this.cexp=Core.me.info.baseInfo.exp
		}


		public override function show():void {
			super.show();
			resize();
			if (!TimeManager.getInstance().hasITick(onTimeUpdate)) {
				TimeManager.getInstance().addITick(1000, onTimeUpdate);
			}
		}

		public override function hide():void {
			super.hide();
			if (TimeManager.getInstance().hasITick(onTimeUpdate)) {
				TimeManager.getInstance().removeITick(onTimeUpdate);
			}
		}

		public function addExitEvent():void {
			if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, onExit)) {
				EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onExit);
			}
		}

		private function onExit():void {
			Cmd_EXPC.cm_Exp_L();
		}

		public function removeExitEvent():void {
			if (EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, onExit)) {
				EventManager.getInstance().removeEvent(EventEnum.COPY_QUIT, onExit);
			}
		}

		protected function onTimeUpdate():void {
			var tt:uint=(getTimer() - tick) / 1000;
			var rst:uint=stayTime + tt;
			var hour:int=rst / 3600;
			var minutes:int=rst / 60 % 60;
			var scends:int=rst % 60;
			timeLbl.text=com.leyou.utils.StringUtil_II.lpad(hour + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(minutes + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(scends + "", 2, "0");

			var ert:int=expRemain - tt;
			if (ert < 0) {
				ert=0;
			}
			hour=ert / 3600;
			minutes=ert / 60 % 60;
			scends=ert % 60;
			doubleExpLbl.text=com.leyou.utils.StringUtil_II.lpad(hour + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(minutes + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(scends + "", 2, "0");
		}
	}
}

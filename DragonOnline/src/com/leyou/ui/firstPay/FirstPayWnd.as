package com.leyou.ui.firstPay {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_ddsc;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FirstPayWnd extends AutoWindow {
		private var payBtn:ImgButton;

//		private var sptMovie:SwfLoader;

		private var grids:Vector.<MarketGrid>;

		private var st:int;

		private var effectMovie1:SwfLoader;

//		private var effectMovie2:SwfLoader;
//		
//		private var effectMovie3:SwfLoader;
//		
//		private var effectMovie4:SwfLoader;

		private var flyIds:Array;

		private var starts:Array;

		private var btnImg:Image;

//		private var tipsInfo:TipVipEquipInfo;

		public function FirstPayWnd() {
			super(LibManager.getInstance().getXML("config/ui/xqqdWnd.xml"));
			init();
		}

		private function init():void {
			flyIds=[];
			starts=[];
			btnImg=getUIbyID("btnImg") as Image;
			payBtn=getUIbyID("payBtn") as ImgButton;
			payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBg();

			var vipDetail:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(1);
//			sptMovie = new SwfLoader(vipDetail.modelBigId);
//			addChild(sptMovie);
//			sptMovie.mouseEnabled = true;
//			
//			sptMovie.x = 740;
//			sptMovie.y = 370;

			effectMovie1=getUIbyID("weapon") as SwfLoader;
//			effectMovie2 = getUIbyID("weapon2") as SwfLoader;
//			effectMovie3 = getUIbyID("weapon3") as SwfLoader;
//			effectMovie4 = getUIbyID("weapon4") as SwfLoader;
//			effectMovie2 = new SwfLoader(99949);
//			effectMovie3 = new SwfLoader(99949);
//			effectMovie4 = new SwfLoader(99949);
//			addChild(effectMovie1);
//			addChild(effectMovie2);
//			addChild(effectMovie3);
//			addChild(effectMovie4);
			effectMovie1.x=826 - 85;
			effectMovie1.y=213 - 150;

			if (PlayerEnum.PRO_MASTER == Core.me.info.profession) {
				effectMovie1.update(99956);
			} else if (PlayerEnum.PRO_RANGER == Core.me.info.profession) {
				effectMovie1.update(99958);
			} else if (PlayerEnum.PRO_SOLDIER == Core.me.info.profession) {
				effectMovie1.update(99955);
			} else if (PlayerEnum.PRO_WARLOCK == Core.me.info.profession) {
				effectMovie1.update(99957);
			}
			
//			effectMovie2.x = 260;
//			effectMovie2.y = 260;
//			
//			effectMovie3.x = 410;
//			effectMovie3.y = 260;
//			
//			effectMovie4.x = 520;
//			effectMovie4.y = 260;

			grids=new Vector.<MarketGrid>();
			for (var n:int=0; n < 5; n++) {
				var grid:MarketGrid=new MarketGrid();
				grid.x=320 + n * 82;
				grid.y=281;
				grid.isShowPrice=false;
				addChild(grid);
				grids.push(grid);
			}
			clsBtn.x-=40;
			clsBtn.y+=15;
			
//			tipsInfo = new TipVipEquipInfo();
//			sptMovie.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

//		protected function onMouseOver(event:MouseEvent):void{
//			tipsInfo.lv = Core.me.info.level;
//			tipsInfo.vipLv = 1;
//			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
//		}

		public function flyItem():Boolean {
			if (flyIds.length > 0) {
				FlyManager.getInstance().flyBags(flyIds, starts);
				flyIds.length=0;
				starts.length=0;
				hide();
				return true;
			}
			return false;
		}

		private function setFlyItem():void {
			flyIds.length=0;
			starts.length=0;
			for each (var grid:MarketGrid in grids) {
				if (0 != grid.dataId) {
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "payBtn":
					if (0 == st) {
						PayUtil.openPayUrl();
					} else if (1 == st) {
						Cmd_ddsc.cm_DdscConfirm();
						setFlyItem();
					}
					break;
			}
		}

		public function updateInfo(obj:Object):void {
			st=obj.st;
			var rewardList:Array=obj.fjlist;
			var isVip:Boolean=(int(obj.vst) == 1);
			var count:int=rewardList.length;
			for (var n:int=0; n < count; n++) {
				var reward:Array=rewardList[n];
				grids[n].updataInfo({itemId: reward[0], count: reward[1]});
			}

			if (0 == st) {
				btnImg.x=437;
				btnImg.updateBmp("ui/ttsc/font_cdxqwyw.png");
				payBtn.setActive(true, 1, true);
			} else if (1 == st) {
				btnImg.x=437 + 44;
				btnImg.updateBmp("ui/mission/font_lqjl.png");
				payBtn.setActive(true, 1, true);
				UIManager.getInstance().leftTopWnd.setFirstGift(true);
			} else if (2 == st) {
				btnImg.updateBmp("ui/mission/font_lqjl.png");
				payBtn.setActive(false, 1, true);
			}
		}
	}
}

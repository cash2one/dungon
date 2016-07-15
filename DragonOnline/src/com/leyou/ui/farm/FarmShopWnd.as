package com.leyou.ui.farm {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFarmLvInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.ui.farm.children.FarmBlock;
	import com.leyou.ui.farm.children.FarmShopRender;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class FarmShopWnd extends AutoWindow {
		private var shopRenders:Vector.<FarmShopRender>;

		private var levelLbl:Label;

		private var currentRateLbl:Label;

		private var nextRateLbl:Label;

		private var levelUpBtn:NormalButton;

		private var refreshBtn:NormalButton;

		private var counterLbl:Label;

		private var _block:FarmBlock;

		private var priceLbl:Label;

		private var nextLbl:Label;

		private var costLbl:Label;

		private var iconImg:Image;


		private var remainTime:int;
		private var tick:uint;

		public function FarmShopWnd() {
			super(LibManager.getInstance().getXML("config/ui/farm/farmShop.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			priceLbl=getUIbyID("priceLbl") as Label;
			levelLbl=getUIbyID("levelLbl") as Label;
			currentRateLbl=getUIbyID("currentRateLbl") as Label;
			nextRateLbl=getUIbyID("nextRateLbl") as Label;
			levelUpBtn=getUIbyID("levelUpBtn") as NormalButton;
			refreshBtn=getUIbyID("refreshBtn") as NormalButton;
			counterLbl=getUIbyID("counterLbl") as Label;
			nextLbl=getUIbyID("nextLbl") as Label;
			costLbl=getUIbyID("costLbl") as Label;
			iconImg=getUIbyID("iconImg") as Image;

			levelUpBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			refreshBtn.addEventListener(MouseEvent.CLICK, onButtonClick);

			shopRenders=new Vector.<FarmShopRender>();
			for (var n:int=0; n < 6; n++) {
				var shopRender:FarmShopRender=new FarmShopRender();
				shopRenders.push(shopRender);
				addChild(shopRender);
				if (n < 3) {
					shopRender.x=12 + n * 168;
					shopRender.y=155;
				} else {
					shopRender.x=12 + (n % 3) * 168;
					shopRender.y=315;
				}
			}
//			clsBtn.x-=6;
//			clsBtn.y-=14;
		}

		override public function getUIbyID(id:String):DisplayObject {
			if (id == "growBtn")
				return this.shopRenders[0].getUIbyID(id);
			return super.getUIbyID(id);
		}

		public function get block():FarmBlock {
			return _block;
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			if (!TimeManager.getInstance().hasITick(onTimeUpdate)) {
				TimeManager.getInstance().addITick(1000, onTimeUpdate);
			}
		}

		public override function hide():void {
			super.hide();
			PopupManager.closeConfirm("wind.confirm.blockLevelUp");
			PopupManager.closeConfirm("farm.shop.refresh");
			PopupManager.closeConfirm("farm.shop.grow");
			if (TimeManager.getInstance().hasITick(onTimeUpdate)) {
				TimeManager.getInstance().removeITick(onTimeUpdate);
			}
		}

		protected function onTimeUpdate():void {
			var tt:uint=getTimer() - tick;
			var ert:int=remainTime - tt / 1000;
			if (ert < 0) {
				ert=0;
				refreshBtn.text=PropUtils.getStringById(1645);
			} else if (0 == ert) {
				return;
			}
			var hour:int=ert / 3600;
			var minutes:int=ert / 60 % 60;
			var scends:int=ert % 60;
			counterLbl.text=com.leyou.utils.StringUtil_II.lpad(hour + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(minutes + "", 2, "0") + ":" + com.leyou.utils.StringUtil_II.lpad(scends + "", 2, "0");
		}

		/**
		 * <T>按钮点击响应</T>
		 *
		 * @param event 按钮事件
		 *
		 */
		protected function onButtonClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "levelUpBtn":
					var content:String=TableManager.getInstance().getSystemNotice(2720).content;
					var farmLvInfo:TFarmLvInfo=TableManager.getInstance().getLandLvInfo(_block.level);
					var nextLvInfo:TFarmLvInfo=TableManager.getInstance().getLandLvInfo(_block.level + 1);
					if (null != nextLvInfo) {
						content=com.ace.utils.StringUtil.substitute(content, farmLvInfo.costGold, nextLvInfo.level, nextLvInfo.profitRate);
						PopupManager.showConfirm(content, callbackLevelUp, null, false, "wind.confirm.blockLevelUp");
//						var w:WindInfo=WindInfo.getConfirmInfo(content, callbackLevelUp);
//						PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, w, "wind.confirm.blockLevelUp");
					}
					break;
				case "refreshBtn":
					var tt:uint=getTimer() - tick;
					var ert:int=remainTime - tt / 1000;
					if (ert <= 0) {
						Cmd_Farm.cm_FAM_F(0);
					} else {
						var c:String=TableManager.getInstance().getSystemNotice(2722).content;
//						c=com.ace.utils.StringUtil.substitute(c, ConfigEnum.FarmRefreshCost);
						PopupManager.showRadioConfirm(c, ConfigEnum.FarmRefreshCost.split("|")[0], ConfigEnum.FarmRefreshCost.split("|")[1], onRefresh, null, false, "farm.shop.refresh");
					}
					break;
			}
		}

		private function onRefresh(type:int):void {
			var ctype:int=((0 == type) ? 2 : 1);
			Cmd_Farm.cm_FAM_F(ctype);
		}


		/**
		 * <T>土地升级回调</T>
		 *
		 */
		protected function callbackLevelUp():void {
			Cmd_Farm.cm_FAM_U(_block.blockId);
		}

		/**
		 * <T>加载土地信息</T>
		 *
		 * @param $block 土地块
		 *
		 */
		public function loadBlock($block:FarmBlock):void {
			_block=$block;
			var farmLvInfo:TFarmLvInfo=TableManager.getInstance().getLandLvInfo(_block.level);
			var nextLvInfo:TFarmLvInfo=TableManager.getInstance().getLandLvInfo(_block.level + 1);
			levelLbl.text="LV:" + farmLvInfo.level;
			currentRateLbl.text=farmLvInfo.profitRate + "%";
			if (null != nextLvInfo) {
				nextRateLbl.text=nextLvInfo.profitRate + "%";
				nextLbl.visible=true;
				nextRateLbl.visible=true;
				levelUpBtn.visible=true;
				costLbl.visible=true;
				iconImg.visible=true;
				priceLbl.visible=true;
			} else {
				nextLbl.visible=false;
				nextRateLbl.visible=false;
				levelUpBtn.visible=false;
				costLbl.visible=false;
				iconImg.visible=false;
				priceLbl.visible=false;
					//				nextRateLbl.text = farmLvInfo.profitRate + "%";
			}
			priceLbl.text=farmLvInfo.costGold + "";
			var l:int=shopRenders.length;
			for (var n:int=0; n < l; n++) {
				shopRenders[n].updateProfit();
			}

		}

		/**
		 * <T>当前土地的ID</T>
		 *
		 * @return 土地ID
		 *
		 */
		public function get blockId():int {
			if (null != block) {
				return block.blockId;
			}
			return -1;
		}

		/**
		 * <T>更新普通商店种子信息</T>
		 *
		 * @param arr 种子列表
		 *
		 */
		public function updataInfo(arr:Array):void {
			var length:int=arr.length;
			if (length <= 1) {
				throw new Error("seed less")
			}
			for (var n:int=0; n < length; n++) {
				shopRenders[n].updataInfo(arr[n]);
			}
		}

		/**
		 * <T>更新VIP商店种子信息</T>
		 *
		 * @param arr 种子列表
		 *
		 */
		public function updataVipInfo(arr:Array):void {
			var length:int=arr.length + 3;
			if (length <= 1) {
				throw new Error("seed less")
			}

			for (var n:int=3; n < length; n++) {
				shopRenders[n].updataInfo(arr[n - 3]);
			}
		}

		/**
		 * 农场种子刷新剩余时间
		 *
		 * @param timeRemain 剩余时间
		 *
		 */
		public function updataTime(timeRemain:int):void {
			tick=getTimer();
			if (timeRemain <= 0) {
				remainTime=0;
				refreshBtn.text=PropUtils.getStringById(1645);
			} else {
				remainTime=timeRemain;
				refreshBtn.text=PropUtils.getStringById(1646);
			}
			onTimeUpdate();
		}

		/**
		 * <T>刷新土地信息</T>
		 *
		 */
		public function updateLand():void {
			if (null != _block) {
				loadBlock(_block);
			}
		}
	}
}

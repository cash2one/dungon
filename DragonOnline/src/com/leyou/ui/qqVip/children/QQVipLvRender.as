package com.leyou.ui.qqVip.children {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.table.TQQVipLvRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.qqvip.QQVipData;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class QQVipLvRender extends AutoSprite {
		private var receiveImg:Image;

		private var receiveBtn:ImgButton;

		private var lvLbl:Label;

		private var grids:Vector.<MaillGrid>;

		private var lv:int;

		public function QQVipLvRender() {
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipLvBar.xml"));
			init();
		}

		public function init():void {
			mouseChildren=true;
			grids=new Vector.<MaillGrid>();
			lvLbl=getUIbyID("lvLbl") as Label;
			receiveImg=getUIbyID("receiveImg") as Image;
			receiveBtn=getUIbyID("receiveBtn") as ImgButton;
			for (var n:int=0; n < 4; n++) {
				var grid:MaillGrid=new MaillGrid();
				grid.x=106 + 48 * n;
				grid.y=4;
				addChild(grid);
				grids.push(grid);
			}
			addChild(receiveImg);
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "receiveBtn":
					Cmd_QQVip.cm_TX_Y(lv);
					break;
			}
		}

		public function updateTableInfo(rewardInfo:TQQVipLvRewardInfo):void {
			lv=rewardInfo.lv;
			lvLbl.text=StringUtil.substitute(PropUtils.getStringById(1829), rewardInfo.lv);
			var index:int=0;
			var grid:MaillGrid;
			if (rewardInfo.exp > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, rewardInfo.exp);
			}
			if (rewardInfo.money > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, rewardInfo.money);
			}
			if (rewardInfo.energy > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, rewardInfo.energy);
			}
			if (rewardInfo.byb > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, rewardInfo.byb);
			}
			if (rewardInfo.lp > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, rewardInfo.lp);
			}
			if (rewardInfo.item1 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item1, rewardInfo.item1Num);
			}
			if (rewardInfo.item2 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item2, rewardInfo.item2Num);
			}
			if (rewardInfo.item3 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item3, rewardInfo.item3Num);
			}
			if (rewardInfo.item4 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item4, rewardInfo.item4Num);
			}
		}

		public function setGrid(enable:Boolean):void {
			for each (var grid:MaillGrid in grids) {
				if (null != grid) {
					grid.filters=enable ? null : [FilterEnum.enable];
				}
			}
		}

		public function updateStatus(data:QQVipData):void {
			var st:int=DataManager.getInstance().qqvipData.getLvStatus(lv);
			var r:Boolean=(0 == st) && (Core.me.info.level >= lv);
			receiveBtn.setActive(r, 1, true);
			receiveImg.visible=(1 == st);
			setGrid(!receiveImg.visible);
		}
	}
}

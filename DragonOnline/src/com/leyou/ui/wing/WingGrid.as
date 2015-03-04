package com.leyou.ui.wing {

	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.utils.ItemUtil;
	
	import flash.geom.Point;

	public class WingGrid extends GridBase {

		public var numLbl:Label;

		public var goldNum:int=0;
		public var openLv:int=0;

		public var tips:Object;

		public static var wnd:SimpleWindow;

		public function WingGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_WING;

			this.numLbl=new Label();
			this.numLbl.x=22;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

			this.bgBmp.updateBmp("ui/common/common_icon_bg.png");
			this.iconBmp.updateBmp("ui/backpack/lock.png");
			this.selectBmp.updateBmp("ui/backpack/select.png");

			this.selectBmp.x=-1;
			this.selectBmp.y=-1;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			var table:TEquipInfo=TableManager.getInstance().getEquipInfo(info as int);
			super.updataInfo(table);

			if (table == null)
				return;

			this.iconBmp.updateBmp("ico/items/" + table.icon + ".png");
			this.iconBmp.setWH(40, 40);
		}

		override public function switchHandler(fromItem:GridBase):void {

			if (fromItem.gridType == this.gridType) {
				Cmd_Wig.cm_WigSlotToSlot(fromItem.initId + 1, this.initId + 1);
			} else {
				if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {

					var baginfo:Baginfo=MyInfoManager.getInstance().bagItems[fromItem.dataId];
					if (baginfo == null || baginfo.info == null || baginfo.info.subclassid != 12)
						return;

					Cmd_Wig.cm_WigAddEquipToSlot(baginfo.pos, this.dataId + 1, 2);
				}
			}
		}

		override protected function reset():void {
			super.reset();
			wnd=null;
			this.tips=null;
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			super.mouseUpHandler($x, $y);

			if (this.isEmpty && wnd == null && this.dataId != 0) {

				if (UIManager.getInstance().backpackWnd.yb < goldNum) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1208));
					return;
				}

				var s:String="确定消耗" + goldNum + "钻石开启该槽位？";
				if (Core.me.info.level < this.openLv)
					s="你的等级不足,是否消耗" + goldNum + "钻石开启该槽位？"

				wnd=PopupManager.showConfirm(s, function():void {
					Cmd_Wig.cm_WigOpenSlot(dataId + 1);
				},null,false,"openWingSlot");
			}

		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, ItemUtil.getWingTipsByPos(this.dataId, this.goldNum), new Point($x, $y));
			} else {
				if (this.tips != null) {
					var tipsinfo:TipsInfo=new TipsInfo(this.tips);
					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point($x, $y));
				} else {
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "翅膀装备" + (this.dataId + 1), new Point($x, $y));
				}
			}
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();

		}

		override public function unlocking():void {
			super.unlocking();
		}

		override public function doubleClickHandler():void {
			super.doubleClickHandler();
			var pos:int=MyInfoManager.getInstance().getBagEmptyGridIndex();
			Cmd_Wig.cm_WigAddEquipToSlot(pos, this.initId + 1);
		}



	}
}

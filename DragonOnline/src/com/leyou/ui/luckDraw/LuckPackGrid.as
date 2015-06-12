package com.leyou.ui.luckDraw {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.leyou.data.luckDraw.LuckDrawRewardInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LuckPackGrid extends GridBase {
		private var numLbl:Label;

		private var tips:TipsInfo;

		private var count:int;

		public var pos:int;

		public function LuckPackGrid() {
			super();
			init();
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);
			canMove=true;
			isLock=false;
			gridType=ItemEnum.TYPE_GRID_LUCKDRAW;
			numLbl=new Label();
			addChild(numLbl);
			numLbl.y=25;
			numLbl.autoSize=TextFieldAutoSize.RIGHT;
			numLbl.filters=[FilterEnum.hei_miaobian];
			numLbl.textColor=0xffffff;
			var tf:TextFormat=numLbl.defaultTextFormat;
			tf.size=10;
			numLbl.defaultTextFormat=tf;

			tips=new TipsInfo();
			bgBmp.updateBmp("ui/backpack/bg.png");
			var select:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid=new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData=select.bitmapData;
		}

		override public function switchHandler(fromItem:GridBase):void {
			if (ItemEnum.TYPE_GRID_LUCKDRAW == fromItem.gridType) {
				var grid:LuckPackGrid=fromItem as LuckPackGrid;
				Cmd_LDW.cm_LDW_V(grid.pos, pos);
			}
		}

		/**
		 * <T>鼠标移入显示TIP</T>
		 *
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 *
		 */
		public override function mouseOverHandler($x:Number, $y:Number):void {
			this.selectBmp.visible=true;
			if ((null != tips) && (0 != dataId)) {
				var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(dataId);
				if ((null != itemInfo) && (6 == itemInfo.classid)) {
					var content:String=itemInfo.name;
					if (count > 10) {
						content+=":" + count;
					}
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
				} else {
					var info:TEquipInfo=TableManager.getInstance().getEquipInfo(tips.itemid);
					if (null != info) {
						if (10 == info.classid) {
							ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
							return;
						}
						var wear:Boolean=ItemUtil.showDiffTips(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
						if (!wear) {
							ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
						}
					} else {
						ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					}
				}
			}
		}

		public override function doubleClickHandler():void {
			super.doubleClickHandler();
			if (dataId > 0) {
				Cmd_LDW.cm_LDW_T(pos);
			}
		}

		public function updateInfo(obj:Object):void {
			var info:LuckDrawRewardInfo=obj as LuckDrawRewardInfo;
			count=info.count;
			dataId=info.itemid;
			tips.itemid=dataId;
			var sourceName:String;
			var itemInfo:Object=TableManager.getInstance().getItemInfo(dataId);
			if (null != itemInfo) {
				sourceName=itemInfo.icon + ".png";
			} else {
				itemInfo=TableManager.getInstance().getEquipInfo(dataId);
				if (null != itemInfo) {
					sourceName=itemInfo.icon + ".png";
				} else {
					itemInfo=TableManager.getInstance().getItemInfo(65535);
					sourceName=itemInfo.icon + ".png";
				}
			}
			var iconUrl:String=GameFileEnum.URL_ITEM_ICO + sourceName;
			iconBmp.updateBmp(iconUrl, null, false, 35, 35);
			if (count > 10000) {
				numLbl.text=(count / 10000).toFixed(1) + PropUtils.getStringById(1572);
			} else if (count > 1) {
				numLbl.text=count + "";
			} else {
				numLbl.text="";
			}
			numLbl.x=ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			iconBmp.x=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			if (itemInfo.effect != null && itemInfo.effect != "0") {
				stopMc();
				playeMc(int(itemInfo.effect));
			}
			addChild(numLbl);
		}

		/**
		 * <T>清除现有数据</T>
		 *
		 */
		public function clear():void {
			dataId=0;
			numLbl.htmlText="";
			iconBmp.fillEmptyBmd();
			stopMc();
		}
	}
}

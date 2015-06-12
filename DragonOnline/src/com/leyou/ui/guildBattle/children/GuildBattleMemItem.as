package com.leyou.ui.guildBattle.children {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.table.TGuildBattleInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;

	public class GuildBattleMemItem extends AutoSprite {
		private static const GRID_COUNT:int=4;

		private var bgHightImg:Image;

		private var rankLbl:Label;

		private var watchLbl:Label;

		private var grids:Vector.<MaillGrid>;

		private var gridImgs:Vector.<Image>;

		private var _id:int;

		private var _groupId:String;

		private var listenter:Function;

		private var style:StyleSheet;

		public function GuildBattleMemItem() {
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildAwardRender2.xml"));
			init();
		}

		public function get groupId():String {
			return _groupId;
		}

		public function get id():int {
			return _id;
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			grids=new Vector.<MaillGrid>();
			gridImgs=new Vector.<Image>();
			gridImgs.push(getUIbyID("grid1Img"));
			gridImgs.push(getUIbyID("grid2Img"));
			gridImgs.push(getUIbyID("grid3Img"));
			gridImgs.push(getUIbyID("grid4Img"));
			bgHightImg=getUIbyID("bgHightImg") as Image;
			rankLbl=getUIbyID("rankLbl") as Label;
			watchLbl=getUIbyID("watchLbl") as Label;
			watchLbl.mouseEnabled=true;
			var aHover:Object=new Object();
			aHover.color="#ff0000";
			style=new StyleSheet();
			style.setStyle("a:hover", aHover);
			watchLbl.styleSheet=style;
			watchLbl.htmlText=StringUtil_II.addEventString(watchLbl.text, watchLbl.text, true);
			watchLbl.addEventListener(TextEvent.LINK, linkHandler);

			for (var n:int=0; n < GRID_COUNT; n++) {
				var grid:MaillGrid=new MaillGrid();
				grids.push(grid);
				addChild(grid);
				grid.x=126 + 42 * n;
				grid.y=8;
			}
			bgHightImg.alpha=0;
		}

		public function register(fun:Function):void {
			listenter=fun;
		}

		public function unregister():void {
			listenter=null;
		}

		protected function linkHandler(event:TextEvent):void {
			if (null != listenter) {
				listenter.call(this, this);
			}
		}

		public function onMouseOut(event:MouseEvent):void {
			TweenLite.to(bgHightImg, 0.5, {alpha: 0});
		}

		public function onMouseOver(event:MouseEvent):void {
			TweenLite.to(bgHightImg, 0.5, {alpha: 1});
		}

		public function updateTInfo(info:TGuildBattleInfo):void {
			_id=info.id;
			_groupId=info.groupId;
			var rs:String;
			var flagArr:Array=info.groupId.split("|");
			if (flagArr[2] > 0) {
				rs=StringUtil.substitute(PropUtils.getStringById(1640), flagArr[1], flagArr[2]);
			} else {
				rs=StringUtil.substitute(PropUtils.getStringById(1641), flagArr[1]);
			}
			rankLbl.text=rs;
			var index:int=0;
			var grid:MaillGrid=grids[index];
			if (info.exp > 0) {
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, info.exp);
				index++;
			}
			if (info.money > 0) {
				grid=grids[index];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, info.money);
				index++;
			}
			if (info.energy > 0) {
				grid=grids[index];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, info.energy);
				index++;
			}
			if (info.byb > 0) {
				grid=grids[index];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, info.byb);
				index++;
			}
			if (info.bg > 0) {
				grid=grids[index];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, info.bg);
				index++;
			}
			if (info.item1 > 0) {
				grid=grids[index];
				grid.updateInfo(info.item1, info.item1Count);
				index++;
			}
			if (info.item2 > 0) {
				grid=grids[index];
				grid.updateInfo(info.item2, info.item2Count);
				index++;
			}
			if (info.item3 > 0) {
				grid=grids[index];
				grid.updateInfo(info.item3, info.item3Count);
				index++;
			}
			if (info.item4 > 0) {
				grid=grids[index];
				grid.updateInfo(info.item4, info.item4Count);
				index++;
			}
		}
	}
}

package com.leyou.ui.ttsc.childs {


	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class KfcbRender extends AutoSprite {

		private var iconImg:Image;
		private var titleImg:Image;

		private var nameLbl:Label;
		private var powerLbl:Label;

		private var postLbl:Label;
		private var viewRankLbl:Label;
		private var swfloader:SwfLoader;

		private var kfcbrender2:KfcbRender2;
		private var kfcbrender3:KfcbRender2;
		private var kfcbrender4:KfcbRender2;

		private var pay:TPayPromotion;

		private var gridVec:Vector.<KfcbGrid>;

		private var titleSpr:Sprite;

		private var tipinfo:TipsInfo;

		public function KfcbRender() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/kfcbRender.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.titleImg=this.getUIbyID("titleImg") as Image;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.powerLbl=this.getUIbyID("powerLbl") as Label;

			this.postLbl=this.getUIbyID("postLbl") as Label;
			this.viewRankLbl=this.getUIbyID("viewRankLbl") as Label;


			this.kfcbrender2=new KfcbRender2();
			this.addChild(this.kfcbrender2);

			this.kfcbrender2.x=337;
			this.kfcbrender2.y=0;

			this.kfcbrender3=new KfcbRender2();
			this.addChild(this.kfcbrender3);

			this.kfcbrender3.x=337;
			this.kfcbrender3.y=106;

			this.kfcbrender4=new KfcbRender2();
			this.addChild(this.kfcbrender4);

			this.kfcbrender4.x=337;
			this.kfcbrender4.y=212;

			this.swfloader=new SwfLoader();
			this.addChild(this.swfloader);

			this.swfloader.x=this.titleImg.x;
			this.swfloader.y=this.titleImg.y;

			this.gridVec=new Vector.<KfcbGrid>();

			var grid:KfcbGrid;

			grid=new KfcbGrid();

			grid.x=179;
			grid.y=77;

			this.addChild(grid);
			this.gridVec.push(grid);

			grid=new KfcbGrid();

			grid.x=256;
			grid.y=77;

			this.addChild(grid);
			this.gridVec.push(grid);

			grid=new KfcbGrid();

			grid.x=179;
			grid.y=154;

			this.addChild(grid);
			this.gridVec.push(grid);

			grid=new KfcbGrid();

			grid.x=256;
			grid.y=154;

			this.addChild(grid);
			this.gridVec.push(grid);

			this.titleSpr=new Sprite();
			this.titleSpr.graphics.beginFill(0x000000);
			this.titleSpr.graphics.drawRect(0, 0, 160, 50);
			this.titleSpr.graphics.endFill();

			this.titleSpr.alpha=0;

			this.addChild(this.titleSpr);

			this.titleSpr.x=this.titleImg.x + 10;
			this.titleSpr.y=this.titleImg.y;

			this.titleSpr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.titleSpr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.tipinfo=new TipsInfo();

			this.viewRankLbl.addEventListener(MouseEvent.CLICK, onRank);
			this.viewRankLbl.mouseEnabled=true;
		}

		private function onRank(e:MouseEvent):void {

			var tindex:int=0;

			switch (pay.type) {
				case 27:
					tindex=5;
					break;
				case 28:
					tindex=3;
					break;
				case 29:
					tindex=6;
					break;
				case 30:
					tindex=2;
					break;
				case 31:
					tindex=4;
					break;
				case 32:
					tindex=10;
					break;
				case 33:
					tindex=9;
					break;
				case 34:
					tindex=1;
					break;
			}

			UIManager.getInstance().openWindow(WindowEnum.RANK);
			UIManager.getInstance().rankWnd.selectPageByType(tindex);
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_TITLE, this.tipinfo, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(arr:Array):void {

			var payarr:Array=TableManager.getInstance().getPayPromotionByType(arr[0]);

			payarr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			pay=payarr[0];

			if (arr[1] == "no") {
				this.nameLbl.text="" + PropUtils.getStringEasyById(1642);
				this.iconImg.updateBmp("ui/wybq/none.png");
			} else {
				this.nameLbl.text="" + arr[1];
				this.iconImg.updateBmp(PlayerUtil.getPlayerFullBigHeadImg(arr[2], arr[3]));
			}

			var i:int=0;
			var grid:KfcbGrid;
			var tinfo:Object;
			for each (grid in this.gridVec) {

				if (pay.items.length <= i) {
					grid.clearData();
					break;
				}

				if (pay.items[i] > 10000)
					tinfo=TableManager.getInstance().getItemInfo(pay.items[i]);
				else
					tinfo=TableManager.getInstance().getEquipInfo(pay.items[i]);

				grid.updataInfo(tinfo);
				grid.numLblTxt=pay.itemNums[i] + "";
				i++;
			}

			this.postLbl.visible=(pay.mail > 0);

			this.swfloader.visible=false;
			this.titleImg.visible=false;

			this.tipinfo.itemid=0;
			if (pay.Rp_title > 0) {
				var info:TTitle=TableManager.getInstance().getTitleByID(pay.Rp_title);
				this.tipinfo.itemid=info.typeId;

				if (int(info.model2) > 0) {
					this.swfloader.visible=true;
					this.swfloader.update(int(info.model2));

					if (info.Bottom_Pic != "") {
						this.titleImg.visible=true;
						this.titleImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");
					}
				} else if (info.Bottom_Pic != "") {
					this.titleImg.visible=true;
					this.titleImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");
				} else {
					//				this.titleNameLbl.text="" + info.name;
					//				this.titleNameLbl.textColor=uint("0x" + info.fontColour);
					//				this.titleNameLbl.filters=[FilterUtil.showBorder(uint("0x" + info.borderColour))];
				}


				var power:int=0;

				for (i=0; i < 3; i++) {

					if (int(info["attribute" + (i + 1)]) > 0) {
						power+=TableManager.getInstance().getZdlElement(int(info["attribute" + (i + 1)])).rate * int(info["value" + (i + 1)]);
					}
				}

				this.powerLbl.text=PropUtils.getStringEasyById(1524) + ": " + power;
			}


			this.kfcbrender2.updateInfo(payarr[1]);
			this.kfcbrender3.updateInfo(payarr[2]);
			this.kfcbrender4.updateInfo(payarr[3]);

		}

	}
}

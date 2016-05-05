package com.leyou.ui.ttsc.childs {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;

	public class KfcbRender2 extends AutoSprite {

		private var postLbl:Label;
		private var nameLbl:Label;

		private var gridVec:Vector.<KfcbGrid>;

		public function KfcbRender2() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/kfcbRender2.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {

			this.postLbl=this.getUIbyID("postLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;


			this.gridVec=new Vector.<KfcbGrid>();

			var grid:KfcbGrid;

			grid=new KfcbGrid();

			grid.x=97;
			grid.y=19;

			this.addChild(grid);
			this.gridVec.push(grid);

			grid=new KfcbGrid();

			grid.x=169;
			grid.y=19;

			this.addChild(grid);
			this.gridVec.push(grid);

			grid=new KfcbGrid();

			grid.x=241;
			grid.y=19;

			this.addChild(grid);
			this.gridVec.push(grid);


		}

		public function updateInfo(pay:TPayPromotion):void {

			this.postLbl.visible=(pay.mail > 0);
			this.nameLbl.text="" + pay.des1;

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
				grid.numLblTxt=pay.itemNums[i]+"";
				i++;
			}



		}



	}
}

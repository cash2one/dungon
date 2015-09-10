package com.leyou.ui.laba.child {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLaba;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.tips.TipsInfo;

	public class LabaOpRender extends AutoSprite {

		private var sImgArr:Array=[];

		private var ItemImg:Image;
		private var ItemGrid:LabaGrid;


		public function LabaOpRender() {
			super(LibManager.getInstance().getXML("config/ui/laba/labaOpRender.xml"));
			this.init();
			this.mouseChildren=true;
			//			this.mouseEnabled=true;
		}

		private function init():void {

			this.sImgArr.push(this.getUIbyID("s0Img") as Image);
			this.sImgArr.push(this.getUIbyID("s1Img") as Image);
			this.sImgArr.push(this.getUIbyID("s2Img") as Image);

			this.ItemImg=this.getUIbyID("ItemImg") as Image;
			this.ItemImg.visible=false;


			this.ItemGrid=new LabaGrid(-1);
			this.addChild(this.ItemGrid);

			this.ItemGrid.x=this.ItemImg.x;
			this.ItemGrid.y=this.ItemImg.y;

		}

		public function updateInfo(info:TLaba):void {

			if (info.itemId > 10000)
				this.ItemGrid.updataInfo(TableManager.getInstance().getItemInfo(info.itemId));
			else
				this.ItemGrid.updataInfo(TableManager.getInstance().getEquipInfo(info.itemId));

			this.ItemGrid.canMove=false;
			
			if (info.itemNum > 1)
				this.ItemGrid.setNum("" + info.itemNum);

			for (var i:int=0; i < this.sImgArr.length; i++) {
				this.sImgArr[i].updateBmp("ico/items/" + info.image);
			}

		}

		override public function get height():Number {
			return 40;
		}


	}
}

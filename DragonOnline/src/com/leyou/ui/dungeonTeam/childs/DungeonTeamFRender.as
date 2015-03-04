package com.leyou.ui.dungeonTeam.childs {

	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.ui.ReConnectionWnd;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.role.child.children.ImgRolling;
	import com.leyou.utils.PlayerUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DungeonTeamFRender extends AutoSprite {

		private var nameLbl:Label;
		private var iconImg:Image;

		private var numImg:Image;

		private var countImg:Vector.<Image>;

		private var itemsGrid:Vector.<TeamCopyGrid>;

		private var imgArr:Vector.<Image>;

		private var num0Sp:ImgRolling;
		private var num1Sp:ImgRolling;

		private var snum:int=0;

		private var ad:int=0;
		private var rollArr:Array=[];

		private var succEffect:SwfLoader;

		public function DungeonTeamFRender() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeamFRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.numImg=this.getUIbyID("numImg") as Image;

			this.numImg.visible=false;

			this.imgArr=new Vector.<Image>;

			var img:Image;
			for (var i:int=0; i < 10; i++) {
				new Image("ui/num/" + i + "_lz.png", loadUI);
			}

			this.itemsGrid=new Vector.<TeamCopyGrid>();

			var grid:TeamCopyGrid;

			for (i=0; i < 4; i++) {

				grid=new TeamCopyGrid();

				grid.y=257 + Math.floor(i / 2) * 33;
				grid.x=26 + (i % 2) * 33;

				this.addChild(grid);
				this.itemsGrid.push(grid);

				grid.visible=false;
			}


			this.succEffect=new SwfLoader(99906);
			this.addChild(this.succEffect);
			this.succEffect.x=0 - 16;
			this.succEffect.y=0 - 16;

			this.succEffect.visible=false;

		}

		private function loadUI(e:Image):void {

			snum++;

			this.imgArr.push(e);

			if (snum < 10)
				return;

			this.num0Sp=new ImgRolling(0, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);

			this.num0Sp.x=26;
			this.num0Sp.y=149;
			this.num0Sp.endRole=this.imgEnd;
			this.addChild(this.num0Sp);

			this.num1Sp=new ImgRolling(1, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);

			this.num1Sp.x=58;
			this.num1Sp.y=149;
			this.num1Sp.endRole=this.imgEnd;
			this.addChild(this.num1Sp);

			this.num0Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));
			this.num1Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));
		}

		private function imgEnd(idx:int):void {

			switch (idx) {
				case 0:
					this.num0Sp.setEndImg(new Bitmap(this.imgArr[int(this.ad % 100 / 10)].bitmapData));
					break;
				case 1:
					this.num1Sp.setEndImg(new Bitmap(this.imgArr[int(this.ad % 10)].bitmapData))
					break;
			}

			if (idx == 0)
				this.num1Sp.endRolling(2);

		}

		private function endRoll():void {

			if (this.ad == 0) {

				if (this.num0Sp != null)
					this.num0Sp.setEndImg(new Bitmap(this.imgArr[0].bitmapData));

				if (this.num1Sp != null)
					this.num1Sp.setEndImg(new Bitmap(this.imgArr[0].bitmapData));

			} else {

				if (this.num0Sp != null)
					this.num0Sp.endRolling(9);

				if (this.num1Sp != null)
					this.num1Sp.endRolling(9);

			}
		}

		public function updateInfo(list:Array):void {

			var grid:TeamCopyGrid;
			for each (grid in this.itemsGrid) {
				grid.resetGrid();
			}

			/**
			 *  name -- 玩家名字
			  vocation -- 职业
			  gender  -- 性别
			  [rooll1,...]  -- 点数列表
			 *
			 */
			this.nameLbl.text="" + list[0];
			this.iconImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(list[1], list[2]));

			this.rollArr=list[3];
		}

		public function playEffect():void {

			if (this.rollArr.length > 0)
				this.ad=this.rollArr.shift();

			TweenMax.delayedCall(ConfigEnum.TeamDungeon6, endRoll);

			this.num0Sp.startRoll(12);
			this.num1Sp.startRoll(12);
		}

		public function updateGridList(id:int):void {

			for (var i:int=0; i < this.itemsGrid.length; i++) {
				if (this.itemsGrid[i].isEmpty)
					break;
			}

			this.itemsGrid[i].visible=true;
			this.itemsGrid[i].updataInfo(TableManager.getInstance().getItemInfo(id) || TableManager.getInstance().getEquipInfo(id));
			this.itemsGrid[i].scaleX=this.itemsGrid[i].scaleY=0.75
		}

		public function get PlayName():String {
			return this.nameLbl.text;
		}

		public function playScaleEffect():void {
//			TweenMax.to(this.num0Sp, 0.5, {z: -200});
//			TweenMax.to(this.num1Sp, 0.5, {z: -200, onComplete: Complete});

			var p1:Point=new Point(this.num0Sp.x, this.num0Sp.y);
			var p2:Point=new Point(this.num1Sp.x, this.num1Sp.y);

//			this.num0Sp.x-=(30 / 2)
//			this.num0Sp.y-=(41/ 2);
//			
//			this.num1Sp.x-=(30 / 2)
//			this.num1Sp.y-=(41/ 2);
//			
//			this.num0Sp.scaleX=this.num0Sp.scaleY=2;
//			this.num1Sp.scaleX=this.num1Sp.scaleY=2;
//			
//			TweenMax.delayedCall(0.5, EffectComplete, [p1, p2]);

			this.succEffect.x=p1.x - 16;
			this.succEffect.y=p1.y - 16;

			this.succEffect.visible=true;

			this.succEffect.playAct(PlayerEnum.ACT_STAND, -1, true, function():void {
				succEffect.visible=false;
			});

		}

		private function EffectComplete(p1:Point, p2:Point):void {

			this.num0Sp.x=p1.x;
			this.num0Sp.y=p1.y;

			this.num1Sp.x=p2.x;
			this.num1Sp.y=p2.y;

			this.num0Sp.scaleX=this.num0Sp.scaleY=1;
			this.num1Sp.scaleX=this.num1Sp.scaleY=1;
		}

		private function Complete():void {
			this.num0Sp.z=0
			this.num1Sp.z=0
		}

		public function get GridPoint():Point {

			for (var i:int=0; i < this.itemsGrid.length; i++) {
				if (this.itemsGrid[i].isEmpty) {
					return this.itemsGrid[i].parent.localToGlobal(new Point(this.itemsGrid[i].x, this.itemsGrid[i].y));
				}
			}

			return null;
		}

	}
}

package com.leyou.ui.dungeonTeam {


	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamFRender;
	import com.leyou.ui.dungeonTeam.childs.TeamCopyGrid;
	import com.leyou.ui.role.child.children.ImgRolling;
	import com.leyou.utils.TimeUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	public class DungeonTeamFWnd extends AutoWindow {

		private var itemsList:Vector.<DungeonTeamFRender>;
		private var itemsGrid:Vector.<TeamCopyGrid>;
		private var itemGrid:TeamCopyGrid;

		private var timeLbl:Label;
		private var progressImg:Image;
		private var confirmBtn:NormalButton;
		private var numImg:Image;

		private var myTime:int=0;

		private var itemsIndex:int=0;
		private var items:Array=[];
		private var list:Array=[];

		private var imgArr:Vector.<Image>;

		private var num0Sp:ImgRolling;
		private var num1Sp:ImgRolling;

		private var snum:int=0;

		private var ad:int=0;
		private var rollArr:Array=[];

		private var myClick:Boolean=false;

		private var speed:int=0;
		
		private var succEffect:SwfLoader;

		public function DungeonTeamFWnd() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeamFWnd.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.visible=false;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.numImg=this.getUIbyID("numImg") as Image;
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.numImg.visible=false;

			this.imgArr=new Vector.<Image>;

			var img:Image;
			for (var i:int=0; i < 10; i++) {
				new Image("ui/num/" + i + "_lz.png", loadUI);
			}


			this.itemsList=new Vector.<DungeonTeamFRender>();

			var frender:DungeonTeamFRender;

			for (i=0; i < 3; i++) {

				frender=new DungeonTeamFRender();

				this.addChild(frender);
				this.itemsList.push(frender);

				frender.x=10 + i * 118;
				frender.y=55;

			}

			this.itemsGrid=new Vector.<TeamCopyGrid>();

			var grid:TeamCopyGrid;

			for (i=0; i < 8; i++) {
				grid=new TeamCopyGrid();

				if (i < 4) {
					grid.y=128;
					grid.x=404 + i * 50;
				} else {
					grid.y=331;
					grid.x=431 + (i % 4) * 50;

				}

				this.addChild(grid);
				this.itemsGrid.push(grid);
			}

			this.itemGrid=new TeamCopyGrid();
			this.addChild(this.itemGrid);

			this.itemGrid.x=381;
			this.itemGrid.y=331;
			
			
			this.succEffect=new SwfLoader(99906);
			this.addChild(this.succEffect);
			this.succEffect.x=0 - 16;
			this.succEffect.y=0- 16;
			
			this.succEffect.visible=false;

			this.clsBtn.addEventListener(MouseEvent.CLICK, oncloseClick);
		}

		private function oncloseClick(e:MouseEvent):void {
			Cmd_CpTm.cmTeamCopyTeamExit();
		}


		private function onClick(e:MouseEvent):void {

//			if (this.rollArr.length > 0)
//				this.startEffect();

			this.endRoll();

			this.confirmBtn.setActive(false, .6, true);
			this.myClick=true;
		}

		public function updateInfo(o:Object):void {

			var cpid:int=o.cpid;

			var tcopyinfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(cpid)
			if (tcopyinfo == null)
				return;

			this.itemGrid.resetGrid();
			var t:Object;
			
			if(TableManager.getInstance().getItemInfo(tcopyinfo.M_Item1))
			t=TableManager.getInstance().getItemInfo(tcopyinfo.M_Item1);
			else
			t=TableManager.getInstance().getEquipInfo(tcopyinfo.M_Item1)
			this.itemGrid.updataInfo(t);

			if (tcopyinfo.MI_Num1 > 1)
				this.itemGrid.setNum(tcopyinfo.MI_Num1 + "");

			list=o.jllist;
			items=o.jlitem;

			var l:int=2;
			for (var i:int=0; i < 4; i++) {

				if (i < list.length) {
					if (list[i][0] == MyInfoManager.getInstance().name) {
						this.rollArr=list[i][3];
					} else {
						this.itemsList[l].visible=true;
						this.itemsList[l].updateInfo(list[i]);
						l--;
					}
				}
			}

			while (l >= 0) {

				this.itemsList[l].visible=false;
				l--;
			}

			for (i=0; i < itemsGrid.length; i++) {
				this.itemsGrid[i].resetGrid();
			}

			for (i=0; i < items.length; i++) {
				(t=TableManager.getInstance().getItemInfo(items[i][0])) || (t=TableManager.getInstance().getEquipInfo(items[i][0]))
				this.itemsGrid[i].updataInfo(t);
				this.itemsGrid[i].playName=items[i][2];

				if (int(items[i][1]) > 1)
					this.itemsGrid[i].setNum(items[i][1]);
			}

			this.speed=0;
//			trace(ConfigEnum.TeamDungeon6,ConfigEnum.TeamDungeon7)
			this.myTime=i * (ConfigEnum.TeamDungeon6 + ConfigEnum.TeamDungeon7) - ConfigEnum.TeamDungeon7;
			TimerManager.getInstance().add(exeMyTime);


			this.confirmBtn.setActive(true, 1, true);
		}

		private function exeMyTime(i:int):void {

			//飞
			if (speed != 0 && speed % ConfigEnum.TeamDungeon6 == 0) {
				this.confirmBtn.setActive(false, .6, true);
				this.flyPoint();
			}

			if (i % (ConfigEnum.TeamDungeon6 + ConfigEnum.TeamDungeon7) == 0) {
//				if (!this.myClick)
				this.confirmBtn.setActive(true, 1, true);

				this.progressImg.scaleX=1;
				TweenLite.to(progressImg, ConfigEnum.TeamDungeon6, {scaleX: 0});

				this.speed=0;
				this.startEffect();
			}

			this.speed++;

			if (this.myTime - i <= 0) {
				TimerManager.getInstance().remove(exeMyTime);
				this.myTime=0;

				this.progressImg.scaleX=0
				this.timeLbl.text="00:00";

			} else {

				this.timeLbl.text="" + TimeUtil.getIntToTime(ConfigEnum.TeamDungeon6 - speed);
			}
		}

		private function flyPoint():void {
			var i:int=0;
			var img:Image=new Image();
			var p:Point;
			var l:int=0;

			for (i=0; i < itemsGrid.length; i++) {
				if (!this.itemsGrid[i].isEmpty) {
					img.bitmapData=this.itemsGrid[i].itemBmp;
					this.addChild(img);
					img.x=this.itemsGrid[i].x;
					img.y=this.itemsGrid[i].y;

					img.setWH(40, 40);

					for (var j:int=0; j < this.items.length; j++) {
						if (this.items[j][0] == this.itemsGrid[i].dataId && this.items[j][2] == this.itemsGrid[i].playName) {
							if (this.items[j][2] == MyInfoManager.getInstance().name) {

								for (l=4; l < this.itemsGrid.length; l++) {
									if (this.itemsGrid[l].isEmpty) {
										p=new Point(this.itemsGrid[l].x, this.itemsGrid[l].y);
										break;
									}
								}

								if (p == null)
									return;

								TweenLite.to(img, 1, {x: p.x, y: p.y, onComplete: Complete, onCompleteParams: [img, l, this.items[j][0]]});

								this.playScaleEffect();
								break;
							} else {

								for (l=0; l < this.itemsList.length; l++) {
									if (this.items[j][2] == this.itemsList[l].PlayName && this.itemsList[l].visible) {

										p=this.globalToLocal(this.itemsList[l].GridPoint);
										if (p == null)
											return;

										TweenLite.to(img, 1, {x: p.x, y: p.y, onComplete: Complete, onCompleteParams: [img, l, this.items[j][0]]});
										this.itemsList[l].playScaleEffect();
										break;
									}
								}

								if (p != null)
									break;

							}
						}
					}

					this.itemsGrid[i].resetGrid();
					break;
				}
			}

		}



		private function Complete(img:Image, i:int, j:int):void {
			if (img.parent == this)
				this.removeChild(img);

			
			var t:Object;
			if (i > 3) {
				(t=TableManager.getInstance().getItemInfo(j) || (t=TableManager.getInstance().getEquipInfo(j)));
				this.itemsGrid[i].updataInfo(t);
			} else {
				this.itemsList[i].updateGridList(j);
			}
		}

		public function playScaleEffect():void {

			var p1:Point=new Point(this.num0Sp.x, this.num0Sp.y);
			var p2:Point=new Point(this.num1Sp.x, this.num1Sp.y);

//			TweenMax.to(this.num0Sp, 0.5, {z: -200});
//			TweenMax.to(this.num1Sp, 0.5, {z: -200, onComplete: EffectComplete});

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
//			
			
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

		private function startEffect():void {

			this.itemsList[0].playEffect();
			this.itemsList[1].playEffect();
			this.itemsList[2].playEffect();
			this.playEffect();

		}


		public function showPanel(o:Object):void {
			this.show(true, UIEnum.WND_LAYER_TOP, true);
			this.resize();

			this.updateInfo(o);
		}

		private function get MyGridPoint():Point {

			for (var i:int=4; i < this.itemsGrid.length; i++) {
				if (this.itemsGrid[i].isEmpty)
					return this.itemsGrid[i].parent.localToGlobal(new Point(this.itemsGrid[i].x, this.itemsGrid[i].y));
			}

			return null;
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}


		private function loadUI(e:Image):void {

			snum++;

			this.imgArr.push(e);

			if (snum < 10)
				return;

			this.num0Sp=new ImgRolling(0, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);

			this.num0Sp.x=470;
			this.num0Sp.y=215;
			this.num0Sp.endRole=this.imgEnd;
			this.addChild(this.num0Sp);

			this.num1Sp=new ImgRolling(1, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);

			this.num1Sp.x=500;
			this.num1Sp.y=215;
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

		public function playEffect():void {

			if (this.rollArr.length > 0)
				this.ad=this.rollArr.shift();

			TweenMax.delayedCall(ConfigEnum.TeamDungeon6, endRoll);

			this.num0Sp.startRoll(12);
			this.num1Sp.startRoll(12);
		}


	}
}

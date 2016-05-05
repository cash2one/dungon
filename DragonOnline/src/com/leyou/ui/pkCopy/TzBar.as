package com.leyou.ui.pkCopy {

	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.manager.TimerManager;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TzBar extends AutoSprite {

		private var bgImg:Image;
		private var bgEffImg:Image;
		private var progressImg:Image;
		private var upDownBtn:ImgButton;

		private var progressLbl:Label;
 
		private var currId:int=-1;

		private var twnCore:TweenMax;

		private var uiContiner:Sprite;

		public function TzBar() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/tzBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgEffImg=this.getUIbyID("bgEffImg") as Image;
			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.upDownBtn=this.getUIbyID("upDownBtn") as ImgButton;

			this.bgEffImg.alpha=0;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.upDownBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.uiContiner=new Sprite();
			this.addChild(this.uiContiner);
			
			this.uiContiner.addChild(this.bgImg);
			this.uiContiner.addChild(this.progressImg);
			this.uiContiner.addChild(this.progressLbl);
			this.uiContiner.addChild(this.bgEffImg);
			
			this.addChild(this.upDownBtn);

//			this.upDownBtn.visible=false;
		}

		private function onClick(e:MouseEvent):void {

			var w:int=202;
			var i:int=w - 30;

			if (this.uiContiner.visible) {

				TweenLite.to(this.uiContiner, 1, {x:202-25, onComplete: function():void {
					uiContiner.visible=false;
					upDownBtn.updataBmd("ui/funForcast/btn_left.png");
					bgImg.visible=false;
				}});

//				TweenLite.to(this.upDownBtn, 1, {x: 2});

			} else {

				bgImg.visible=true;
				uiContiner.visible=true;
				TweenLite.to(this.uiContiner, 1, {x: 0, onComplete: function():void {
					upDownBtn.updataBmd("ui/funForcast/btn_right.png");
				}});

//				TweenLite.to(this.upDownBtn, 1, {x: this.width - this.upDownBtn.width - 15});
			}

		}
		
		public function setScalePanel(v:Boolean):void {

			var w:int=202;
			var i:int=w - 30;

			if (!v) {

				TweenLite.to(this.uiContiner, 1, {x:202-25, onComplete: function():void {
					uiContiner.visible=false;
					upDownBtn.updataBmd("ui/funForcast/btn_left.png");
					bgImg.visible=false;
				}});

//				TweenLite.to(this.upDownBtn, 1, {x: 2});

			} else {

				bgImg.visible=true;
				uiContiner.visible=true;
				TweenLite.to(this.uiContiner, 1, {x: 0, onComplete: function():void {
					upDownBtn.updataBmd("ui/funForcast/btn_right.png");
				}});

//				TweenLite.to(this.upDownBtn, 1, {x: this.width - this.upDownBtn.width - 15});
			}

		}

		public function updateInfo(o:Object, o1:Object, o2:Object):void {

			var tinfo:TTzActiive=TableManager.getInstance().getTzActiveByID(int(o));

			if (this.currId != int(o))
				this.bgImg.updateBmp("ui/tz/" + tinfo.mmImage);

			this.currId=int(o);

			var arr:Array=[];
			var arr1:Array=[];
			var arr2:Array=[];

			var date:Date=new Date();
			var date1:Date;
			var date2:Date;
			var date3:Date;

			arr=tinfo.time.split("|");
			arr1=arr[0].split(":");

			date.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;

			date1=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);

			var progress:int=date1.time - date.time;

			if (this.currId == int(o2) && progress > 10 * 60 * 1000)
				this.hide();
			else
				this.show();


			this.progressLbl.text=PropUtils.getStringById(101404) + ":" + TimeUtil.getIntToTime(progress / 1000);

			var tinfo1:TTzActiive=TableManager.getInstance().getTzActiveByID(int(o1));
			arr=tinfo1.time.split("|");
			arr1=arr[1].split(":");

			date3=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);

			if (this.currId == int(o2) && progress < 10 * 60 * 1000)
				this.progressImg.setWH(135 * (progress / (10 * 60 * 1000)), 17);
			else
				this.progressImg.setWH(135 * (progress / (date1.time - date3.time)), 17);
		}

		private function onMouseOver(e:MouseEvent):void {
			if (this.currId != -1)
				ToolTipManager.getInstance().show(TipEnum.TYPE_TZ, this.currId, new Point(e.stageX, e.stageY));
			twnCore=TweenMax.to(this.bgEffImg, 2, {alpha: 1, yoyo: true, repeat: -1});
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();

			if (twnCore != null) {
				twnCore.pause();
				twnCore.kill();
				twnCore=null;
			}

			this.bgEffImg.alpha=0;
		}



	}
}

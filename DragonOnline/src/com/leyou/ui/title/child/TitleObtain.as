package com.leyou.ui.title.child {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.greensock.core.TweenCore;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.leyou.net.cmd.Cmd_Nck;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TitleObtain extends AutoWindow {

		private var titleNameLbl:Label;
		private var bgswf:SwfLoader;

		private var effImg:Image;
		private var bgeffImg:Image;

		private var closeBtn:ImgButton;
		private var openBtn:ImgButton;

		private var propKeyLbl:Array=[];
		private var propValLbl:Array=[];

		private var id:int=-1;

		private var tspr:Sprite;
		private var index:int=0;

		public function TitleObtain() {
			super(LibManager.getInstance().getXML("config/ui/title/titleObtain.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.hideBg();
			this.clsBtn.visible=false;
		}

		private function init():void {

			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.bgswf=this.getUIbyID("bgswf") as SwfLoader;

			this.effImg=this.getUIbyID("effImg") as Image;
			this.bgeffImg=this.getUIbyID("bgeffImg") as Image;

			this.closeBtn=this.getUIbyID("closeBtn") as ImgButton;
			this.openBtn=this.getUIbyID("openBtn") as ImgButton;

			propKeyLbl.push(this.getUIbyID("key0Lbl"));
			propKeyLbl.push(this.getUIbyID("key1Lbl"));
			propKeyLbl.push(this.getUIbyID("key2Lbl"));

			propValLbl.push(this.getUIbyID("val0Lbl"));
			propValLbl.push(this.getUIbyID("val1Lbl"));
			propValLbl.push(this.getUIbyID("val2Lbl"));

			this.closeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.openBtn.addEventListener(MouseEvent.CLICK, onClick);

//			this.clsBtn.visible=false;
//			this.allowDrag=false;

			this.tspr=new Sprite();
			this.addChildAt(this.tspr, 0);

			this.tspr.addChild(this.effImg);
			this.tspr.x=169; //this.effImg.x;
			this.tspr.y=174; //this.effImg.y;

			this.effImg.x-=169;
			this.effImg.y-=174;

			this.hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "closeBtn":

					break;
				case "openBtn":
					Cmd_Nck.cm_NckStart(this.id);
					break;
			}

			this.hide();
		}

		public function showPanel(info:Object):void {
			this.show();
			this.reSize();
			this.updateInfo(info);

//			tcore=TweenLite.to(this.effImg, 3, {transformAroundPoint: {point: new Point(237, 227), rotation: 360}, repeat: -1});
//			tcore=TweenLite.to(this.effImg, 3, {transformAroundPoint: {point: new Point(169, 174), rotation: 360}, repeat: -1});

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			SoundManager.getInstance().play(19);

		}

		private function onEnterFrame(e:Event):void {

			this.index=this.index == 361 ? 0 : this.index;

			this.tspr.rotation=this.index;

			this.index++;
		}

		private function updateInfo(info:Object):void {

			this.id=info.curNckid;
			var tinfo:TTitle=TableManager.getInstance().getTitleByID(info.curNckid);

			this.bgeffImg.bitmapData=null;
			this.titleNameLbl.text="";

			if (tinfo.model > 0) {

				this.bgswf.update(tinfo.model);
				this.bgswf.visible=true;

				if (tinfo.Bottom_Pic != "")
					this.bgeffImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");

			} else if (tinfo.Bottom_Pic != "") {
				this.bgeffImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");
			} else {
				this.titleNameLbl.text="" + tinfo.name;
				this.titleNameLbl.textColor=uint("0x" + tinfo.fontColour);
				this.titleNameLbl.filters=[FilterUtil.showBorder(uint("0x" + tinfo.borderColour))];
				this.bgswf.visible=false;
			}


			for (var i:int=0; i < 3; i++) {
				if (tinfo["attribute" + (i + 1)] > 0) {
					this.propKeyLbl[i].text=PropUtils.prop2Arr[int(tinfo["attribute" + (i + 1)]) - 1] + ":";
					this.propValLbl[i].text="+" + tinfo["value" + (i + 1)];
					this.propValLbl[i].textColor=0x00ff00;
				} else {
					this.propKeyLbl[i].text="";
					this.propValLbl[i].text="";
				}
			}

		}

		override public function hide():void {
			super.hide();
			
			this.close();
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 338 >> 1;
			this.y=UIEnum.HEIGHT - 348 >> 1;
		}


	}
}

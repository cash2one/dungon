package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	public class TitleTips extends AutoSprite implements ITip {

		private var bgsc:ScaleBitmap;
		private var nameLbl:Label;
		private var nameLbl0:Label;
		private var nameLbl1:Label;
		private var nameLbl2:Label;
		private var getLbl:Label;
		private var timeLbl:Label;

		private var effSwf:SwfLoader;
		private var picImg:Image;

		private var descLbl:Label;

		private var propNameArr:Array=[];
		private var propKeyArr:Array=[];

		private var tipsInfo:TipsInfo;

		public function TitleTips() {
			super(LibManager.getInstance().getXML("config/ui/tips/TitleTips.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgsc=this.getUIbyID("bgsc") as ScaleBitmap;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.nameLbl0=this.getUIbyID("nameLbl0") as Label;
			this.nameLbl1=this.getUIbyID("nameLbl1") as Label;
			this.nameLbl2=this.getUIbyID("nameLbl2") as Label;

			this.getLbl=this.getUIbyID("getLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.picImg=this.getUIbyID("picImg") as Image;
			this.effSwf=this.getUIbyID("effSwf") as SwfLoader;

			this.propNameArr.push(this.getUIbyID("propName0Lbl") as Label);
			this.propNameArr.push(this.getUIbyID("propName1Lbl") as Label);
			this.propNameArr.push(this.getUIbyID("propName2Lbl") as Label);

			this.propKeyArr.push(this.getUIbyID("propKey0Lbl") as Label);
			this.propKeyArr.push(this.getUIbyID("propKey1Lbl") as Label);
			this.propKeyArr.push(this.getUIbyID("propKey2Lbl") as Label);

			this.descLbl.width=169;
			this.descLbl.wordWrap=true;
//			this.descLbl.multiline=true;
			
			
		}

		public function updateInfo(o:Object):void {

			this.tipsInfo=o as TipsInfo;

			var info:TTitle=TableManager.getInstance().getTitleByID(this.tipsInfo.itemid);
			if (info == null)
				return;

			this.picImg.fillEmptyBmd();
			this.nameLbl.text="";
			this.effSwf.visible=false;
			
			if (info.model > 0) {
				this.effSwf.visible=true;
				this.effSwf.update(info.model);

				if (info.Bottom_Pic != "")
					this.picImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");

			} else if (info.Bottom_Pic != "") {
				this.picImg.updateBmp("scene/title/" + info.Bottom_Pic + ".png");
			} else {
				this.nameLbl.text="" + info.name;
				this.nameLbl.textColor=uint("0x" + info.fontColour);
				this.nameLbl.filters=[FilterUtil.showBorder(uint("0x" + info.borderColour))];
			}

			this.getLbl.visible=this.tipsInfo.isUse;
			
			this.nameLbl1.visible=false;
			this.nameLbl2.visible=false;

			var p:int=0;

			for (var i:int=0; i < 3; i++) {
				if (int(info["attribute" + (i + 1)]) > 0) {

					this.propNameArr[i].text="" + PropUtils.propArr[int(info["attribute" + (i + 1)])-1] + ":";
					this.propKeyArr[i].text="" + info["value" + (i + 1)];

					p++;
				} else {
					this.propNameArr[i].text="";
					this.propKeyArr[i].text="";
				}

			}


			if (p == 0) {
				this.nameLbl0.visible=false;
				this.nameLbl1.y=this.nameLbl0.y;
			} else {
				this.nameLbl0.visible=true;
				this.nameLbl1.y=this.nameLbl0.y + this.nameLbl1.height + p * this.nameLbl1.height;
			}

			this.descLbl.htmlText="" + info.des;
			this.descLbl.y=this.nameLbl1.y + this.nameLbl1.height;

			if (info.des == "") {
				this.nameLbl1.visible=false;
				this.descLbl.text="";
				this.nameLbl2.y=this.nameLbl1.y;
			} else {
				this.nameLbl1.visible=true;
				this.nameLbl2.y=this.descLbl.y + this.descLbl.height;
			}

			this.timeLbl.text="" + TimeUtil.getIntToDateTime(this.tipsInfo.t);
			this.timeLbl.y=this.nameLbl2.y; // + this.nameLbl2.height;

			if (this.tipsInfo.t == 0 || !this.tipsInfo.isUse) {
				this.nameLbl2.visible=false;
				this.timeLbl.text="";
				this.bgsc.height=this.nameLbl2.y+10;
			} else {
				this.nameLbl2.visible=true;
				this.bgsc.height=this.nameLbl2.y+this.nameLbl2.height+10;
			}
			 
		}

		public function get isFirst():Boolean {
			return false;
		}

		override public function get height():Number{
			return this.bgsc.height;
		}
		
	}
}

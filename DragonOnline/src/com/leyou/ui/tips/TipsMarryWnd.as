package com.leyou.ui.tips {


	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_lv;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.gameData.table.TRing_intensify;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.PropUtils;

	import flash.geom.Rectangle;

	public class TipsMarryWnd extends AutoSprite implements ITip {

		private var nameLbl:Label;
		private var currentfightLbl:Label;
		private var fullfightLbl:Label;
		private var strengLv:Label;
		private var desc1Lbl:Label;
		private var getFunLbl:Label;
		private var qhlvLbl:Label;

		private var nameLbl3:Label;
		private var nameLbl1:Label;
		private var nameLbl7:Label;
		private var nameLbl2:Label;
		private var nameLbl4:Label;

		private var standlineImg:Image;
		private var desclineImg:Image;
		private var bgSc:ScaleBitmap;

		private var gridImg:Image;
		private var gridImgSwf:SwfLoader;

		private var starImgArr:Array=[];

		private var propNameArr:Array=[];
		private var propKeyArr:Array=[];

		private var propQhArr:Array=[];
		private var propAddArr:Array=[];

		private var addpropNameArr:Array=[];
		private var addpropKeyArr:Array=[];

		private var suitpropNameArr:Array=[];
		private var suitpropKeyArr:Array=[];

		public function TipsMarryWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsMarryWnd.xml"));
			this.init();
		}

		private function init():void {

			this.nameLbl3=this.getUIbyID("nameLbl3") as Label;
			this.nameLbl1=this.getUIbyID("nameLbl1") as Label;
			this.nameLbl7=this.getUIbyID("nameLbl7") as Label;
			this.nameLbl2=this.getUIbyID("nameLbl2") as Label;
			this.nameLbl4=this.getUIbyID("nameLbl4") as Label;

			this.bgSc=this.getUIbyID("bgSc") as ScaleBitmap;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.currentfightLbl=this.getUIbyID("currentfightLbl") as Label;
			this.fullfightLbl=this.getUIbyID("fullfightLbl") as Label;
			this.strengLv=this.getUIbyID("strengLv") as Label;
			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.getFunLbl=this.getUIbyID("getFunLbl") as Label;
			this.qhlvLbl=this.getUIbyID("qhlvLbl") as Label;

			this.standlineImg=this.getUIbyID("standlineImg") as Image;
			this.desclineImg=this.getUIbyID("desclineImg") as Image;

			for (var i:int=0; i < 16; i++) {
				this.starImgArr.push(this.getUIbyID("starImg" + i) as Image);
			}

			for (i=0; i < 6; i++) {
				if (i < 3) {
					this.propNameArr.push(this.getUIbyID("propName" + i + "Lbl") as Label);
					this.propKeyArr.push(this.getUIbyID("propKey" + i + "Lbl") as Label);

					this.propQhArr.push(this.getUIbyID("propQh" + i + "Lbl") as Label);
					this.propAddArr.push(this.getUIbyID("propAdd" + i + "Lbl") as Label);

					this.suitpropNameArr.push(this.getUIbyID("suitpropName" + i) as Label);
					this.suitpropKeyArr.push(this.getUIbyID("suitpropKey" + i) as Label);
				}

				this.addpropNameArr.push(this.getUIbyID("addpropName" + i + "Lbl") as Label);
				this.addpropKeyArr.push(this.getUIbyID("addpropKey" + i + "Lbl") as Label);

			}

			this.gridImg=new Image();
			this.addChild(this.gridImg);

			this.gridImg.x=11;
			this.gridImg.y=21;

			this.gridImgSwf=new SwfLoader();
			this.addChild(this.gridImgSwf);

			this.gridImgSwf.x=11;
			this.gridImgSwf.y=21;

		}

		public function updateInfo(o:Object):void {

			var tipinfo:TipsInfo=o as TipsInfo;

			var tinfolv:TMarry_lv=TableManager.getInstance().getMarryLvBylv(tipinfo.zf);
			var tinfo:TMarry_ring=TableManager.getInstance().getMarryRingByid(tipinfo.itemid);

			this.nameLbl.text="" + tinfo.Ring_Name;
			this.gridImg.updateBmp("ico/items/" + tinfo.Ring_Pic);
			this.gridImgSwf.update(tinfo.Ring_Eff2);

			if (tipinfo.qh > 0)
				this.strengLv.text="+" + tipinfo.qh;
			else
				this.strengLv.text="";

			this.qhlvLbl.text="(" + tipinfo.qh + "/16)";

			this.desc1Lbl.width=245;
			this.desc1Lbl.wordWrap=true;

			this.desc1Lbl.htmlText="" + tinfo.Ring_Dic1;

			this.getFunLbl.width=245;
			this.getFunLbl.wordWrap=true;

			this.getFunLbl.htmlText="" + tinfo.Ring_Dic2;

			for (var i:int=0; i < 16; i++) {
				if (i < tipinfo.qh) {
					this.starImgArr[i].updateBmp("ui/tips/icon_xx.png");
				} else {
					this.starImgArr[i].updateBmp("ui/tips/icon_xxx.png");
				}
			}

			var rinfo:TRing_intensify=TableManager.getInstance().getRing_intensifyByLv(tipinfo.qh);
			var rinfo1:TRing_intensify=TableManager.getInstance().getRing_intensifyByLv(16);

			var rate:Number=rinfo.RI_Add / 10000;
			var rate1:Number=rinfo1.RI_Add / 10000;

			var num:int;
			var key:String;
			var frate:Number=0;

			var fight:Number=0;
			var fullfight:Number=0;

			for (i=0; i < 3; i++) {

				switch (i) {
					case 0:
						num=tinfo.Att;
						key=PropUtils.getStringEasyById(4);
						frate=TableManager.getInstance().getZdlElement(4).rate;
						break;
					case 1:
						num=tinfo.Def;
						key=PropUtils.getStringEasyById(5);
						frate=TableManager.getInstance().getZdlElement(5).rate;
						break;
					case 2:
						num=tinfo.Hp;
						key=PropUtils.getStringEasyById(22);
						frate=TableManager.getInstance().getZdlElement(1).rate;
						break;
				}

				this.propNameArr[i].text="" + key + ":";
				this.propKeyArr[i].text="" + num;

				fight+=(num * frate);
				fullfight+=(num * frate);

				this.propQhArr[i].text="" + key + ":";
				this.propAddArr[i].text="" + int((num * rate));

				if (int((num * rate)) == 0) {
					this.propQhArr[i].visible=false;
					this.propAddArr[i].visible=false;
					this.nameLbl3.visible=false;
					this.qhlvLbl.visible=false;

				} else {
					this.propQhArr[i].visible=true;
					this.propAddArr[i].visible=true;
					this.nameLbl3.visible=true;
					this.qhlvLbl.visible=false;
				}

				fight+=((num + (num * rate)) * frate);
				fullfight+=((num + (num * rate1)) * frate);

				this.suitpropNameArr[i].text="" + key + ":";
				this.suitpropKeyArr[i].text="" + int((num * tinfolv.ringAddRate / 10000));

				if (int((num * tinfolv.ringAddRate / 10000)) == 0) {
					this.suitpropNameArr[i].visible=false;
					this.suitpropKeyArr[i].visible=false;
					this.nameLbl7.visible=false;
				} else {

					this.suitpropNameArr[i].visible=true;
					this.suitpropKeyArr[i].visible=true;
					this.nameLbl7.visible=true;
				}


				if (this.nameLbl3.visible) {
					this.nameLbl1.y=this.nameLbl3.y + 15 + 3 * 15;
				} else {
					this.nameLbl1.y=this.nameLbl3.y;
				}

				this.nameLbl7.y=this.nameLbl1.y + 15 + 6 * 15;

				this.suitpropNameArr[i].y=this.suitpropKeyArr[i].y=this.nameLbl7.y + 15 + i * 15;


				fight+=((num + (num * tinfolv.ringAddRate / 10000)) * frate);
				fullfight+=((num + (num * tinfolv.ringAddRate / 10000)) * frate);
			}

			this.addpropNameArr[0].text="" + PropUtils.getStringEasyById(8);
			this.addpropKeyArr[0].text="" + tinfo.Crit;

			fight+=((tinfo.Crit + (tinfo.Crit * rate)) * TableManager.getInstance().getZdlElement(8).rate);
			fullfight+=((tinfo.Crit + (tinfo.Crit * rate1)) * TableManager.getInstance().getZdlElement(8).rate);

			this.addpropNameArr[1].text="" + PropUtils.getStringEasyById(9);
			this.addpropKeyArr[1].text="" + tinfo.Tenacity;

			fight+=((tinfo.Tenacity + (tinfo.Tenacity * rate)) * TableManager.getInstance().getZdlElement(9).rate);
			fullfight+=((tinfo.Tenacity + (tinfo.Tenacity * rate1)) * TableManager.getInstance().getZdlElement(9).rate);

			this.addpropNameArr[2].text="" + PropUtils.getStringEasyById(10);
			this.addpropKeyArr[2].text="" + tinfo.Hit;

			fight+=((tinfo.Hit + (tinfo.Hit * rate)) * TableManager.getInstance().getZdlElement(10).rate);
			fullfight+=((tinfo.Hit + (tinfo.Hit * rate1)) * TableManager.getInstance().getZdlElement(10).rate);

			this.addpropNameArr[3].text="" + PropUtils.getStringEasyById(11);
			this.addpropKeyArr[3].text="" + tinfo.Dodge;

			fight+=((tinfo.Dodge + (tinfo.Dodge * rate)) * TableManager.getInstance().getZdlElement(11).rate);
			fullfight+=((tinfo.Dodge + (tinfo.Dodge * rate1)) * TableManager.getInstance().getZdlElement(11).rate);

			this.addpropNameArr[4].text="" + PropUtils.getStringEasyById(12);
			this.addpropKeyArr[4].text="" + tinfo.Slay;

			fight+=((tinfo.Slay + (tinfo.Slay * rate)) * TableManager.getInstance().getZdlElement(12).rate);
			fullfight+=((tinfo.Slay + (tinfo.Slay * rate1)) * TableManager.getInstance().getZdlElement(12).rate);

			this.addpropNameArr[5].text="" + PropUtils.getStringEasyById(13);
			this.addpropKeyArr[5].text="" + tinfo.Guard;

			fight+=((tinfo.Guard + (tinfo.Guard * rate)) * TableManager.getInstance().getZdlElement(13).rate);
			fullfight+=((tinfo.Guard + (tinfo.Guard * rate1)) * TableManager.getInstance().getZdlElement(13).rate);

			for (i=0; i < 6; i++) {
				this.addpropNameArr[i].y=this.addpropKeyArr[i].y=this.nameLbl1.y + 15 + i * 15;
			}

			this.currentfightLbl.text="" + int(fight);
			this.fullfightLbl.text="" + int(fullfight);

			if (this.nameLbl7.visible) {
				this.standlineImg.y=this.suitpropNameArr[2].y + 20;
			} else {
				this.standlineImg.y=this.nameLbl7.y + 10;
			}

			this.nameLbl2.y=this.currentfightLbl.y=this.standlineImg.y;
			this.nameLbl4.y=this.fullfightLbl.y=this.nameLbl2.y + this.nameLbl2.height;

			this.desclineImg.y=this.nameLbl4.y + 25;

			this.desc1Lbl.y=this.desclineImg.y+5;
			this.getFunLbl.y=this.desc1Lbl.y + this.desc1Lbl.height;

			this.bgSc.height=this.getFunLbl.y + this.getFunLbl.height + 10;

			this.scrollRect=new Rectangle(0, 0, this.width, this.height);
		}

		public function get isFirst():Boolean {
			return false;
		}

		override public function get width():Number {
			return 265;
		}

		override public function get height():Number {
			return this.bgSc.height;
		}

	}
}

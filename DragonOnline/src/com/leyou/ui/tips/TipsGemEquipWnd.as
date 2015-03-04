package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TipsGemEquipWnd extends AutoSprite implements ITip {

		private var posLbl:Label;
		private var descLbl:Label;
		private var name1Lbl:Label;
		private var name2Lbl:Label;
		private var name3Lbl:Label;

		private var bindImg:Image;
		
		private var starImg0:Image;
		private var starImg1:Image;
		private var starImg2:Image;

		private var prop1keyArr:Array=[];
		private var prop1valueArr:Array=[];

		private var prop2keyArr:Array=[];
		private var prop2valueArr:Array=[];

		private var prop3keyArr:Array=[];
		private var prop3valueArr:Array=[];

		private var tipsinfo:TipsInfo;

		public function TipsGemEquipWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsGemEquipWnd.xml"));
			this.init();
		}

		private function init():void {

			this.posLbl=this.getUIbyID("posLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.name1Lbl=this.getUIbyID("name1Lbl") as Label;
			this.name2Lbl=this.getUIbyID("name2Lbl") as Label;
			this.name3Lbl=this.getUIbyID("name3Lbl") as Label;

			this.bindImg=this.getUIbyID("bindImg") as Image;
			
			this.starImg0=this.getUIbyID("starImg0") as Image;
			this.starImg1=this.getUIbyID("starImg1") as Image;
			this.starImg2=this.getUIbyID("starImg2") as Image;

			var j:int=0;
			var lb:Label;

			var keyArr:Array=[];
			var valueArr:Array=[];

			for (var i:int=0; i < 3; i++) {

				keyArr=[];
				valueArr=[];

				for (j=0; j < 2; j++) {

					lb=new Label();

					lb.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
					this.addChild(lb);
					lb.x=120 + j * 78;
					lb.y=132 + i * 25;

//					keyArr.push(lb);
					this["prop" + (i + 1) + "keyArr"].push(lb);

					lb=new Label();
					lb.defaultTextFormat=FontEnum.getTextFormat("Green12");
					this.addChild(lb);
					lb.x=150 + j * 78;
					lb.y=132 + i * 25;

//					valueArr.push(lb);
					this["prop" + (i + 1) + "valueArr"].push(lb);
				}

//				this["prop" + (i + 1) + "keyArr"].push(keyArr);
//				this["prop" + (i + 1) + "valueArr"].push(valueArr);
			}

		}

		public function updateInfo(o:Object):void {

			this.tipsinfo=o as TipsInfo;

			this.posLbl.text="【" + PlayerUtil.PlayPositionStrArr[this.tipsinfo.playPosition] + "】";
			this.descLbl.width=265;
			this.descLbl.wordWrap=true;
			
			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(6401).content;

//			var glist:Array=MyInfoManager.getInstance().gemArr[this.tipsinfo.playPosition];

			var j:int=0;
			var i:int=0;
			var tEquip:TEquipInfo;
			var lv:int=0;
			var slist:Array=[];
			var tmp:Image;
			var k:int=0;

//			for (i=0; i < glist.length; i++) {
			if (!this.tipsinfo.otherPlayer)
				slist=MyInfoManager.getInstance().gemArr[this.tipsinfo.playPosition];
			else
				slist=MyInfoManager.getInstance().othergemArr[this.tipsinfo.playPosition];
			
			if(slist==null)
				return ;
			
			
			lv=0;
			for (j=0; j < slist.length; j++) {
				tEquip=TableManager.getInstance().getEquipInfo(slist[j]);

				for (k=0; k < 2; k++) {
					this["prop" + (j + 1) + "keyArr"][k].text="";
					this["prop" + (j + 1) + "valueArr"][k].text="";
				}
				
				if (tEquip == null) {

					this["starImg" +j].updateBmp("ui/tips/icon_xxx.png");
					
					this["name" + (j + 1) + "Lbl"].text="未镶嵌";
					this["name" + (j + 1) + "Lbl"].textColor=0xff0000
					this["name" + (j + 1) + "Lbl"].filters=[FilterUtil.enablefilter];

					for (k=0; k < 2; k++) {
						this["prop" + (j + 1) + "keyArr"][k].filters=[FilterUtil.enablefilter];
						this["prop" + (j + 1) + "valueArr"][k].filters=[FilterUtil.enablefilter];
					}
					
				} else {

					this["starImg" +j].updateBmp("ui/tips/icon_xx.png");
					
					this["name" + (j + 1) + "Lbl"].text="" + tEquip.name;
					this["name" + (j + 1) + "Lbl"].textColor=ItemUtil.getColorByQuality(tEquip.quality);

					this["name" + (j + 1) + "Lbl"].filters=[];
					
					k=0;
					for (var p:int=0; p < PropUtils.GemEquipTableColumn.length; p++) {
						if (int(tEquip[PropUtils.GemEquipTableColumn[p]]) != 0) {
							this["prop" + (j + 1) + "keyArr"][k].text="" + PropUtils.propArr[PropUtils.GemEquipTableColumnIndex[p]] + "";
							this["prop" + (j + 1) + "valueArr"][k].text="+" + tEquip[PropUtils.GemEquipTableColumn[p]];

							this["prop" + (j + 1) + "keyArr"][k].filters=[];
							this["prop" + (j + 1) + "valueArr"][k].filters=[];
							
							k++;
						}
					}

					lv+=tEquip.level;
				}
			}

			var lvstr:String=lv.toString();
			this.bindImg.bitmapData=new BitmapData(15 * lvstr.length, 21)

			for (j=0; j < lvstr.length; j++) {
				tmp=new Image("ui/num/" + int(lvstr.charAt(j)) + "_zdl.png")
				this.bindImg.bitmapData.copyPixels(tmp.bitmapData, new Rectangle(0, 0, tmp.width, tmp.height), new Point(j * tmp.width, 0));
			}

//			}



		}

		public function get isFirst():Boolean {
			return this.tipsinfo.isUse;
		}

		private function setVisiableProps():void {

			for (var i:int=0; i < 3; i++) {
				this["prop" + (i + 1) + "keyArr"].text="";
				this["prop" + (i + 1) + "valueArr"].text=""
			}

		}


	}
}

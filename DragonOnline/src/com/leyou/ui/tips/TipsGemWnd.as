package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.geom.Rectangle;

	public class TipsGemWnd extends AutoSprite implements ITip {

		private var nameLbl:Label;
		private var bindImg:Image;
		private var descLbl:Label;
		private var desc1Lbl:Label;
		private var desc2Lbl:Label;
		private var priceLbl:Label;
		private var bgSc:ScaleBitmap;

		private var grid:TipsGrid;

		private var nameArr:Array=[];
		private var propsKeyArr:Array=[];
		private var propsValueArr:Array=[];

		private var starArr:Array=[];

		public function TipsGemWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsGemWnd.xml"));
			this.init();
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.bindImg=this.getUIbyID("bindImg") as Image;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.desc2Lbl=this.getUIbyID("desc2Lbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;

			this.bgSc=this.getUIbyID("bgSc") as ScaleBitmap;

			this.grid=new TipsGrid();
			this.addChild(this.grid);
			this.grid.x=11;
			this.grid.y=11;

			var keyArr:Array=[];
			var valueArr:Array=[];

			var lb:Label;
			for (var i:int=0; i < 10; i++) {
				lb=new Label();
				this.addChild(lb);
				lb.defaultTextFormat=FontEnum.getTextFormat("Green12");
				lb.x=28;
				lb.y=173 + i * 20;

				this.nameArr.push(lb);

				keyArr=[];
				valueArr=[];

				for (var j:int=0; j < 2; j++) {
					lb=new Label();
					this.addChild(lb);
					lb.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
					lb.x=120 + j * 78;
					lb.y=173 + i * 20;

					keyArr.push(lb);

					lb=new Label();
					this.addChild(lb);
					lb.defaultTextFormat=FontEnum.getTextFormat("Green12");
					lb.x=150 + j * 78;
					lb.y=173 + i * 20;

					valueArr.push(lb);
				}

				this.propsKeyArr.push(keyArr);
				this.propsValueArr.push(valueArr);

				this.starArr.push(this.getUIbyID("starImg" + i) as Image);
			}


		}

		public function updateInfo(o:Object):void {

			var tequip:TEquipInfo=TableManager.getInstance().getEquipInfo(o.itemid);
			if (tequip == null)
				return;

			this.grid.updataInfo(tequip);

			this.nameLbl.text=tequip.name + "";
			this.nameLbl.textColor=ItemUtil.getColorByQuality(tequip.quality);

			this.descLbl.width=265;
			this.desc1Lbl.width=265;
			this.desc2Lbl.width=265;
			this.descLbl.wordWrap=true;
			this.desc1Lbl.wordWrap=true;
			this.desc2Lbl.wordWrap=true;

			this.descLbl.htmlText=TableManager.getInstance().getSystemNotice(6401).content + "";
			this.desc1Lbl.htmlText=tequip.des + "";
			this.desc2Lbl.htmlText=tequip.desSource + "";
			this.priceLbl.text=tequip.price + "";

			var items:Array=TableManager.getInstance().getEquipListArrByClass(10, tequip.subclassid);
			items.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var tinfo:TEquipInfo;
			var k:int=0;
			var j:int=0
			for (var i:int=0; i < items.length; i++) {

				tinfo=items[i] as TEquipInfo;
				if (tinfo != null) {

					this.nameArr[i].text=tinfo.name + "";

					if (tinfo.id == tequip.id) {
						this.nameArr[i].textColor=ItemUtil.getColorByQuality(tinfo.quality);
						this.starArr[i].updateBmp("ui/tips/icon_xx.png");
					} else {
						this.nameArr[i].textColor=0xcccccc;
						this.starArr[i].updateBmp("ui/tips/icon_xxx.png");
					}

					for (j=0; j < 2; j++) {
						this.propsKeyArr[i][j].text="";
						this.propsValueArr[i][j].text="";
					}

					k=0;
					for (j=0; j < PropUtils.GemEquipTableColumn.length; j++) {

						if (int(tinfo[PropUtils.GemEquipTableColumn[j]]) != 0) {
							this.propsKeyArr[i][k].text=PropUtils.propArr[PropUtils.GemEquipTableColumnIndex[j]] + "";
							this.propsValueArr[i][k].text="+" + tinfo[PropUtils.GemEquipTableColumn[j]] + "";

							if (tinfo.id == tequip.id) {
								this.propsKeyArr[i][k].filters=[]
								this.propsValueArr[i][k].filters=[]
							} else {
								this.propsKeyArr[i][k].filters=[FilterUtil.enablefilter]
								this.propsValueArr[i][k].filters=[FilterUtil.enablefilter]
							}

							k++;
						}

					}

				}

			}


			if (!o.isShowPrice)
				this.scrollRect=new Rectangle(0, 0, this.bgSc.width, this.bgSc.height);
			else
				this.scrollRect=new Rectangle(0, 0, this.bgSc.width, 500);

		}

		public function get isFirst():Boolean {
			return false;
		}

	}
}

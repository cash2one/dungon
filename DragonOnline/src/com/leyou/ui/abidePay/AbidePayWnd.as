package com.leyou.ui.abidePay {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.abidePay.AbidePayData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.ui.abidePay.children.AbidePayRewardBox;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class AbidePayWnd extends AutoWindow {
		private var effect:SwfLoader;

		private var day1Img:Image;

		private var day2Img:Image;

		private var day3Img:Image;

		private var payBtn:ImgButton;

		private var timeLbl:Label;

		private var desLbl:Label;

		private var dayValue1Lbl:Label;

		private var dayValue2Lbl:Label;

		private var dayValue3Lbl:Label;

		private var value1Lbl:Label;

		private var value2Lbl:Label;

		private var value3Lbl:Label;

		private var cpl1Lbl:Label;

		private var cpl2Lbl:Label;

		private var cpl3Lbl:Label;

		private var receive1Btn:NormalButton;

		private var receive2Btn:NormalButton;

		private var receive3Btn:NormalButton;

//		private var lv1Lbl:Label;
//		
//		private var lv2Lbl:Label;
//		
//		private var lv3Lbl:Label;

		private var rateLbl:Label;

		private var ordinationLbl:Label;

		private var lineImg:Image;

		private var lxVlaueLbl:Label;

		private var grids:Vector.<MarketGrid>;

		private var boxes:Vector.<AbidePayRewardBox>;

		private var emask:Shape;

		private var receive1Img:Image;
		private var receive2Img:Image;
		private var receive3Img:Image;

		public function AbidePayWnd() {
			super(LibManager.getInstance().getXML("config/ui/abidePay/lxcz.xml"));
			init();
		}

		private function init():void {
			hideBg();
			ordinationLbl=getUIbyID("timeLbl0") as Label;
			rateLbl=getUIbyID("rateLbl") as Label;
			lineImg=getUIbyID("lineImg") as Image;
			desLbl=getUIbyID("desLbl") as Label;
			effect=getUIbyID("effect") as SwfLoader;
			payBtn=getUIbyID("payBtn") as ImgButton;
			day1Img=getUIbyID("day1Img") as Image;
			day2Img=getUIbyID("day2Img") as Image;
			day3Img=getUIbyID("day3Img") as Image;
			timeLbl=getUIbyID("timeLbl") as Label;
			dayValue1Lbl=getUIbyID("dayValue1Lbl") as Label;
			dayValue2Lbl=getUIbyID("dayValue2Lbl") as Label;
			dayValue3Lbl=getUIbyID("dayValue3Lbl") as Label;
			value1Lbl=getUIbyID("value1Lbl") as Label;
			value2Lbl=getUIbyID("value2Lbl") as Label;
			value3Lbl=getUIbyID("value3Lbl") as Label;
			cpl1Lbl=getUIbyID("cpl1Lbl") as Label;
			cpl2Lbl=getUIbyID("cpl2Lbl") as Label;
			cpl3Lbl=getUIbyID("cpl3Lbl") as Label;
			receive1Btn=getUIbyID("receive1Btn") as NormalButton;
			receive2Btn=getUIbyID("receive2Btn") as NormalButton;
			receive3Btn=getUIbyID("receive3Btn") as NormalButton;
			receive1Img=getUIbyID("receive1Img") as Image;
			receive2Img=getUIbyID("receive2Img") as Image;
			receive3Img=getUIbyID("receive3Img") as Image;

			ordinationLbl.mouseEnabled=true;
			ordinationLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

//			lv1Lbl = getUIbyID("lv1Lbl") as Label;
//			lv2Lbl = getUIbyID("lv2Lbl") as Label;
//			lv3Lbl = getUIbyID("lv3Lbl") as Label;
			lxVlaueLbl=getUIbyID("lxVlaueLbl") as Label;
			boxes=new Vector.<AbidePayRewardBox>();
			grids=new Vector.<MarketGrid>();
			for (var n:int=0; n < 6; n++) {
				var grid:MarketGrid=new MarketGrid();
				pane.addChild(grid);
				grid.x=800 + int(n % 2) * 86;
				grid.y=231 + int(n / 2) * 113;
				grid.isShowPrice=false;
				grids.push(grid);
			}
			addChild(receive1Img);
			addChild(receive2Img);
			addChild(receive3Img);
			var arr:Array=ConfigEnum.lxcz2.split(",");
			for (var m:int=0; m < 9; m++) {
				var box:AbidePayRewardBox=new AbidePayRewardBox();
				pane.addChild(box);
				var tData:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo((m % 3) + 1);
				box.updateContent(tData, arr[int(m / 3)], 1);
				box.x=203 + int(m / 3) * 162;
				box.y=270 + int(m % 3) * 90;
				boxes.push(box);
			}

			day1Img.updateBmp("ui/num/" + arr[0] + "_green.png");
			day2Img.updateBmp("ui/num/" + arr[1] + "_green.png");
			day3Img.updateBmp("ui/num/" + arr[2] + "_green.png");

			var tData1:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(1);
			value1Lbl.text=tData1.ib + "";
			dayValue1Lbl.text=StringUtil.substitute(PropUtils.getStringById(1577), tData1.ib);
			grids[0].updataInfo({itemId: tData1.dayItem1, count: tData1.dayItem1Num});
			grids[1].updataInfo({itemId: tData1.dayItem2, count: tData1.dayItem2Num});
//			lv1Lbl.text = tData1.ib+"";

			var tData2:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(2);
			value2Lbl.text=tData2.ib + "";
			dayValue2Lbl.text=StringUtil.substitute(PropUtils.getStringById(1577), tData2.ib);
			grids[2].updataInfo({itemId: tData2.dayItem1, count: tData2.dayItem1Num});
			grids[3].updataInfo({itemId: tData2.dayItem2, count: tData2.dayItem2Num});
//			lv2Lbl.text = tData2.ib+"";

			var tData3:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(3);
			value3Lbl.text=tData3.ib + "";
			dayValue3Lbl.text=StringUtil.substitute(PropUtils.getStringById(1577), tData3.ib);
			grids[4].updataInfo({itemId: tData3.dayItem1, count: tData3.dayItem1Num});
			grids[5].updataInfo({itemId: tData3.dayItem2, count: tData3.dayItem2Num});
//			lv3Lbl.text = tData3.ib+"";

			payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			receive1Btn.addEventListener(MouseEvent.CLICK, onMouseClick);
			receive2Btn.addEventListener(MouseEvent.CLICK, onMouseClick);
			receive3Btn.addEventListener(MouseEvent.CLICK, onMouseClick);

//			clsBtn.x+=0;
			clsBtn.y+=30;

			emask=new Shape();
			emask.x=effect.x;
			effect.parent.addChild(emask);
			effect.mask=emask;
		}

		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(10009).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			var id:int;
			switch (event.target.name) {
				case "receive1Btn":
					id=1;
					break;
				case "receive2Btn":
					id=2;
					break;
				case "receive3Btn":
					id=3;
					break;
				case "payBtn":
					PayUtil.openPayUrl();
					return;
			}
			var tData:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(id);
			Cmd_CCZ.cm_CCZ_L(tData.ib);
		}

		public function resize():void {
			x=(UIEnum.WIDTH - width) * 0.5;
			y=(UIEnum.HEIGHT - height) * 0.5;
		}

		public function updateInfo():void {
			var data:AbidePayData=DataManager.getInstance().abidePayData;
			var begin:String=DateUtil.formatDate(new Date((data.stime) * 1000), "YYYY" + PropUtils.getStringById(2143) + "MM" + PropUtils.getStringById(1782) + "DD" + PropUtils.getStringById(1783));
			var end:String=DateUtil.formatDate(new Date((data.etime - 1) * 1000), "YYYY" + PropUtils.getStringById(2143) + "MM" + PropUtils.getStringById(1782) + "DD" + PropUtils.getStringById(1783));
			timeLbl.text=StringUtil.substitute(PropUtils.getStringById(1579), begin, end);
			lxVlaueLbl.text=data.cpayValue + "";
			var tData1:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(1);
			if (-1 != data.receiveTypeArr.indexOf(tData1.ib + "")) {
				grids[0].filters=[FilterEnum.enable];
				grids[1].filters=[FilterEnum.enable];
				receive1Btn.text=PropUtils.getStringById(1574);
				receive1Img.visible=true;
				receive1Btn.setActive(false, 1, true);
			} else {
				grids[0].filters=null;
				grids[1].filters=null;
				receive1Img.visible=false;
				if (data.cpayValue < tData1.ib) {
					receive1Btn.text=PropUtils.getStringById(1576);
					receive1Btn.setActive(false, 1, true);
				} else {
					receive1Btn.text=PropUtils.getStringById(1575);
					receive1Btn.setActive(true, 1, true);
				}
			}
			var tData2:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(2);
			if (-1 != data.receiveTypeArr.indexOf(tData2.ib + "")) {
				grids[2].filters=[FilterEnum.enable];
				grids[3].filters=[FilterEnum.enable];
				receive2Btn.text=PropUtils.getStringById(1574);
				receive2Img.visible=true;
				receive2Btn.setActive(false, 1, true);
			} else {
				grids[2].filters=null;
				grids[3].filters=null;
				receive2Img.visible=false;
				if (data.cpayValue < tData2.ib) {
					receive2Btn.text=PropUtils.getStringById(1576);
					receive2Btn.setActive(false, 1, true);
				} else {
					receive2Btn.text=PropUtils.getStringById(1575);
					receive2Btn.setActive(true, 1, true);
				}
			}
			var tData3:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(3);
			if (-1 != data.receiveTypeArr.indexOf(tData3.ib + "")) {
				grids[4].filters=[FilterEnum.enable];
				grids[5].filters=[FilterEnum.enable];
				receive3Btn.text=PropUtils.getStringById(1574);
				receive3Img.visible=true;
				receive3Btn.setActive(false, 1, true);
			} else {
				grids[4].filters=null;
				grids[5].filters=null;
				receive3Img.visible=false;
				if (data.cpayValue < tData3.ib) {
					receive3Btn.text=PropUtils.getStringById(1576);
					receive3Btn.setActive(false, 1, true);
				} else {
					receive3Btn.text=PropUtils.getStringById(1575);
					receive3Btn.setActive(true, 1, true);
				}
			}
			var day:String=StringUtil_II.getColorStr("" + data.getAbideDay(tData1.ib), "#ff00", 13);
			var content:String=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl1Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);

			day=StringUtil_II.getColorStr("" + data.getAbideDay(tData2.ib), "#ff00", 13);
			content=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl2Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);

			day=StringUtil_II.getColorStr("" + data.getAbideDay(tData3.ib), "#ff00", 13);
			content=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl3Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);

			this.checkLing(0, data);
			this.checkLing(3, data);
			this.checkLing(6, data);

			var rate:Number=data.cpayValue / tData1.ib;
			if (rate > 1) {
				rate=1;
			}
			var g:Graphics=emask.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(0, 0, 90, rate * 90);
			g.endFill();
			emask.y=effect.y + (1 - rate) * 90;
			rateLbl.text=data.cpayValue + PropUtils.getStringById(40);
			lineImg.y=emask.y;
			rateLbl.y=lineImg.y - 17 - 4;
		}


		private function checkLing(i:int, data:AbidePayData):void {
			for (var n:int=i; n < 9; n++) {
				var box:AbidePayRewardBox=boxes[n];
				box.reset();
				if (box.updateInfo(data))
					return;
			}
		}

		public override function get width():Number {
			return 988;
		}

		public override function get height():Number {
			return 562;
		}

		public function flyItemByType(type:int):void {
			var tdata1:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(1);
			var tdata2:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(2);
			var tdata3:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(3);
			var arr:Array=ConfigEnum.lxcz2.split(",");
			var ids:Array=[];
			var starts:Array=[];
			if (tdata1.ib == type) {
				ids.push(grids[0].dataId);
				ids.push(grids[1].dataId);
				starts.push(grids[0].localToGlobal(new Point(0, 0)));
				starts.push(grids[1].localToGlobal(new Point(0, 0)));
			} else if (tdata2.ib == type) {
				ids.push(grids[2].dataId);
				ids.push(grids[3].dataId);
				starts.push(grids[2].localToGlobal(new Point(0, 0)));
				starts.push(grids[3].localToGlobal(new Point(0, 0)));
			} else if (tdata3.ib == type) {
				ids.push(grids[4].dataId);
				ids.push(grids[5].dataId);
				starts.push(grids[4].localToGlobal(new Point(0, 0)));
				starts.push(grids[5].localToGlobal(new Point(0, 0)));
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
	}
}

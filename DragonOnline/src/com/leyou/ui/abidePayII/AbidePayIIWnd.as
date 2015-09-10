package com.leyou.ui.abidePayII {
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.abidePay.AbidePayData;
	import com.leyou.data.combineData.CombineData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.ui.abidePay.children.AbidePayRewardBox;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AbidePayIIWnd extends AutoWindow {
		
		private var day1Img:Image;
		
		private var day2Img:Image;
		
		private var day3Img:Image;
		
		private var payBtn:ImgButton;
		
		private var timeLbl:Label;
		
		private var desLbl:Label;
		
		private var value1Lbl:Label;
		
		private var value2Lbl:Label;
		
		private var value3Lbl:Label;
		
		private var cpl1Lbl:Label;
		
		private var cpl2Lbl:Label;
		
		private var cpl3Lbl:Label;
		
		private var ordinationLbl:Label;
		
		private var lineImg:Image;
		
		private var boxes:Vector.<AbidePayRewardBox>;
		
		public function AbidePayIIWnd() {
			super(LibManager.getInstance().getXML("config/ui/abidePay/hflcWnd.xml"));
			init();
		}
		
		private function init():void {
			hideBg();
			ordinationLbl=getUIbyID("timeLbl0") as Label;
			lineImg=getUIbyID("lineImg") as Image;
			desLbl=getUIbyID("desLbl") as Label;
			payBtn=getUIbyID("payBtn") as ImgButton;
			day1Img=getUIbyID("day1Img") as Image;
			day2Img=getUIbyID("day2Img") as Image;
			day3Img=getUIbyID("day3Img") as Image;
			timeLbl=getUIbyID("timeLbl") as Label;
			value1Lbl=getUIbyID("value1Lbl") as Label;
			value2Lbl=getUIbyID("value2Lbl") as Label;
			value3Lbl=getUIbyID("value3Lbl") as Label;
			cpl1Lbl=getUIbyID("cpl1Lbl") as Label;
			cpl2Lbl=getUIbyID("cpl2Lbl") as Label;
			cpl3Lbl=getUIbyID("cpl3Lbl") as Label;
			
			ordinationLbl.mouseEnabled=true;
			ordinationLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			//			lv1Lbl = getUIbyID("lv1Lbl") as Label;
			//			lv2Lbl = getUIbyID("lv2Lbl") as Label;
			//			lv3Lbl = getUIbyID("lv3Lbl") as Label;
			boxes=new Vector.<AbidePayRewardBox>();
			var arr:Array=ConfigEnum.hflc2.split(",");
			for (var m:int=0; m < 9; m++) {
				var box:AbidePayRewardBox=new AbidePayRewardBox();
				pane.addChild(box);
				var tData:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo((m % 3) + 1);
				box.updateContent(tData, arr[int(m / 3)], 2);
				box.x=203 + int(m / 3) * 162;
				box.y=270 + int(m % 3) * 90;
				boxes.push(box);
			}
			
			day1Img.updateBmp("ui/num/" + arr[0] + "_green.png");
			day2Img.updateBmp("ui/num/" + arr[1] + "_green.png");
			day3Img.updateBmp("ui/num/" + arr[2] + "_green.png");
			payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			var tData1:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(1);
			value1Lbl.text=tData1.ib + "";
			
			var tData2:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(2);
			value2Lbl.text=tData2.ib + "";
			
			var tData3:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(3);
			value3Lbl.text=tData3.ib + "";
			
			clsBtn.x+=5;
			clsBtn.y+=15;
			
			desLbl.text = TableManager.getInstance().getSystemNotice(10052).content;
		}
		
		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(10051).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "payBtn":
					PayUtil.openPayUrl();
					return;
			}
		}
		
		public function resize():void {
			x=(UIEnum.WIDTH - width) * 0.5;
			y=(UIEnum.HEIGHT - height) * 0.5;
		}
		
		public function updateInfo():void {
			var data:CombineData=DataManager.getInstance().combineData;
			var begin:String=DateUtil.formatDate(new Date((data.stime) * 1000), "YYYY" + PropUtils.getStringById(2143) + "MM" + PropUtils.getStringById(1782) + "DD" + PropUtils.getStringById(1783));
			var end:String=DateUtil.formatDate(new Date((data.etime - 1) * 1000), "YYYY" + PropUtils.getStringById(2143) + "MM" + PropUtils.getStringById(1782) + "DD" + PropUtils.getStringById(1783));
			timeLbl.text=StringUtil.substitute(PropUtils.getStringById(1579), begin, end);
			var tData1:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(1);
			var tData2:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(2);
			var tData3:TAbidePayInfo=TableManager.getInstance().getCombinePayInfo(3);
			var day:String=StringUtil_II.getColorStr("" + data.getAbideDay(tData1.ib), "#ff00", 13);
			var content:String=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl1Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);
			
			day=StringUtil_II.getColorStr("" + data.getAbideDay(tData2.ib), "#ff00", 13);
			content=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl2Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);
			
			day=StringUtil_II.getColorStr("" + data.getAbideDay(tData3.ib), "#ff00", 13);
			content=StringUtil.substitute(PropUtils.getStringById(1580), day);
			cpl3Lbl.htmlText=StringUtil_II.getColorStr(content, "#ffd200", 13);
			
			for (var n:int=0; n < 9; n++) {
				var box:AbidePayRewardBox=boxes[n];
				box.reset();
				box.updateCombineInfo(data);
			}
		}
		
		public override function get width():Number {
			return 656;
		}
		
		public override function get height():Number {
			return 559;
		}
		
		public function flyItemByType(type:int):void {
//			var tdata1:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(1);
//			var tdata2:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(2);
//			var tdata3:TAbidePayInfo=TableManager.getInstance().getAbidePayInfo(3);
//			var arr:Array=ConfigEnum.lxcz2.split(",");
//			var ids:Array=[];
//			var starts:Array=[];
//			if (tdata1.ib == type) {
//				ids.push(grids[0].dataId);
//				ids.push(grids[1].dataId);
//				starts.push(grids[0].localToGlobal(new Point(0, 0)));
//				starts.push(grids[1].localToGlobal(new Point(0, 0)));
//			} else if (tdata2.ib == type) {
//				ids.push(grids[2].dataId);
//				ids.push(grids[3].dataId);
//				starts.push(grids[2].localToGlobal(new Point(0, 0)));
//				starts.push(grids[3].localToGlobal(new Point(0, 0)));
//			} else if (tdata3.ib == type) {
//				ids.push(grids[4].dataId);
//				ids.push(grids[5].dataId);
//				starts.push(grids[4].localToGlobal(new Point(0, 0)));
//				starts.push(grids[5].localToGlobal(new Point(0, 0)));
//			}
//			FlyManager.getInstance().flyBags(ids, starts);
		}
	}
}

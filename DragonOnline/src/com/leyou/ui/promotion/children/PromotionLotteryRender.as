package com.leyou.ui.promotion.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.game.scene.ui.child.TitleRender;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionData;
	import com.leyou.data.paypromotion.PayPromotionDataII;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class PromotionLotteryRender extends AutoSprite
	{
		private var bybLbl:Label;
		
		private var ybLbl:Label;
		
		private var cost1Lbl:Label;
		
		private var cost2Lbl:Label;
		
		private var bybBtn:ImgButton;
		
		private var ybBtn:ImgButton;
		
		private var title1Img:TitleRender;
		
		private var title2Img:TitleRender;
		
		private var title3Img:TitleRender;
		
		private var title4Img:TitleRender;
		
		private var buy1Btn:NormalButton;
		
		private var buy2Btn:NormalButton;
		
		private var loopOrder:Vector.<int>;
		
		private var grid1Array:Vector.<MarketGrid>;
		
		private var grid2Array:Vector.<MarketGrid>;
		
		private var pos1:int;
		private var num1:int;
		private var speed:int;
		private var isLoop1:Boolean;
		private var cloopCount1:int;
		private var tick1:uint;
		private var totalCount1:int;
		private var selectImg1:Image;
		private var selectImg2:Image;
		private var pos2:int;
		private var num2:int;
		private var cloopCount2:int;
		private var tick2:int;
		private var totalCount2:int;
		private var isLoop2:Boolean;
		private var money1Img:Image;
		private var money2Img:Image;
		
		public function PromotionLotteryRender(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqCjRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			ybLbl = getUIbyID("ybLbl") as Label;
			bybLbl = getUIbyID("bybLbl") as Label;
			ybLbl = getUIbyID("ybLbl") as Label;
			cost1Lbl = getUIbyID("cost1Lbl") as Label;
			cost2Lbl = getUIbyID("cost2Lbl") as Label;
			bybBtn = getUIbyID("bybBtn") as ImgButton;
			ybBtn = getUIbyID("ybBtn") as ImgButton;
			buy1Btn = getUIbyID("buy1Btn") as NormalButton;
			buy2Btn = getUIbyID("buy2Btn") as NormalButton;
			money1Img = getUIbyID("money1Img") as Image;
			money2Img = getUIbyID("money2Img") as Image;
			title1Img = new TitleRender();
			title2Img = new TitleRender();
			title3Img = new TitleRender();
			title4Img = new TitleRender();
			title1Img.scaleX = 150/189;
			title1Img.scaleY = 150/189;
			title2Img.scaleX = 150/189;
			title2Img.scaleY = 150/189;
			title3Img.scaleX = 150/189;
			title3Img.scaleY = 150/189;
			title4Img.scaleX = 150/189;
			title4Img.scaleY = 150/189;
			addChild(title1Img);
			addChild(title2Img);
			addChild(title3Img);
			addChild(title4Img);
			title1Img.x = -16;
			title1Img.y = 250;
			title2Img.x = 191;
			title2Img.y = 236;
			title3Img.x = 300;
			title3Img.y = 250;
			title4Img.x = 507;
			title4Img.y = 236;
			selectImg1=new Image("ui/luckDraw/icon_fz1.png");
			selectImg1.visible=false;
			addChild(selectImg1);
			
			selectImg2=new Image("ui/luckDraw/icon_fz1.png");
			selectImg2.visible=false;
			addChild(selectImg2);
			
			grid1Array = new Vector.<MarketGrid>();
			grid2Array = new Vector.<MarketGrid>();
			var row:int = 3;
			var col:int = 3;
			var count:int;
			for(var n:int = 0; n < row; n++){
				for(var m:int = 0; m < col; m++){
					if ((0 == m) || ((col - 1) == m) || (0 == n) || ((row - 1) == n)) {
						var grid:MarketGrid=new MarketGrid();
						grid1Array[count++]=grid;
						grid.x=20 + m * 107;
						grid.y=10 + n * 72;
						grid.isShowPrice=false;
						addChild(grid);
					}
				}
			}
			selectImg1.x=grid1Array[0].x;
			selectImg1.y=grid1Array[0].y;
			
			count = 0;
			for(var i:int = 0; i < row; i++){
				for(var j:int = 0; j < col; j++){
					if ((0 == j) || ((col - 1) == j) || (0 == i) || ((row - 1) == i)) {
						var grid2:MarketGrid=new MarketGrid();
						grid2Array[count++]=grid2;
						grid2.x=338 + j * 107;
						grid2.y=10 + i * 72;
						grid2.isShowPrice=false;
						addChild(grid2);
					}
				}
			}
			selectImg2.x=grid2Array[0].x;
			selectImg2.y=grid2Array[0].y;
			
			bybLbl.text = StringUtil.substitute(PropUtils.getStringById(2192), ConfigEnum.Sale_Daily1);
			ybLbl.text = StringUtil.substitute(PropUtils.getStringById(2193), ConfigEnum.Sale_Daily2);
			var arr1:Array = ConfigEnum.Sale_Daily11.split("|");
			var arr2:Array = ConfigEnum.Sale_Daily12.split("|");
			var url:String = (int(arr1[1]) > 0) ? "ui/common/zs.png" : "ui/common/bdzs.png";
			money1Img.updateBmp(url);
			url = (int(arr2[1]) > 0) ? "ui/common/zs.png" : "ui/common/bdzs.png";
			money2Img.updateBmp(url);
			cost1Lbl.text = Math.abs(arr1[1])+"";
			cost2Lbl.text = Math.abs(arr2[1])+"";
			var titleInfo1:TTitle = TableManager.getInstance().getTitleByID(arr1[0]);
			var titleInfo2:TTitle = TableManager.getInstance().getTitleByID(arr1[3]);
			var titleInfo3:TTitle = TableManager.getInstance().getTitleByID(arr2[0]);
			var titleInfo4:TTitle = TableManager.getInstance().getTitleByID(arr2[3]);
			title1Img.updateInfo(titleInfo1);
			title2Img.updateInfo(titleInfo2);
			title3Img.updateInfo(titleInfo3);
			title4Img.updateInfo(titleInfo4);
			
			bybBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy1Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy2Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			title1Img.visible = (0 == ConfigEnum.Sale_Daily13);
			title2Img.visible = (0 == ConfigEnum.Sale_Daily13);
			title3Img.visible = (0 == ConfigEnum.Sale_Daily13);
			title4Img.visible = (0 == ConfigEnum.Sale_Daily13);
			buy1Btn.visible = (0 == ConfigEnum.Sale_Daily13);
			buy2Btn.visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("gr1").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("cost1Lbl").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("money1Img").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("gr2").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("gr12").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("cost2Lbl").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("money2Img").visible = (0 == ConfigEnum.Sale_Daily13);
			getUIbyID("gr5").visible = (0 == ConfigEnum.Sale_Daily13);
			
			loopOrder=new Vector.<int>();
			loopOrder.push(0, 1, 2, 4, 7, 6, 5, 3);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "bybBtn":
					if(!isLoop1){
						Cmd_Fanl.cm_Fanl_D(1);
					}
					break;
				case "ybBtn":
					if(!isLoop2){
						Cmd_Fanl.cm_Fanl_D(2);
					}
					break;
				case "buy1Btn":
					var arr1:Array = ConfigEnum.Sale_Daily11.split("|");
					Cmd_Fanl.cm_Fanl_B(arr1[3]);
					break;
				case "buy2Btn":
					var arr2:Array = ConfigEnum.Sale_Daily12.split("|");
					Cmd_Fanl.cm_Fanl_B(arr2[3]);
					break;
			}
		}
		 
		public function rollToPos($type:int,$pos:int, $num:int):void{
			if(1 == $type){
				pos1 = $pos;
				num1 = $num;
				loop1(3, getIndex($type, $pos, $num));
			}else{
				pos2 = $pos;
				num2 = $num;
				loop2(3, getIndex($type, $pos, $num));
			}
		}
		
		private function loop2(count:int=1, index:int=0):void{
			if (!TimeManager.getInstance().hasITick(onLoopChange2)) {
				selectImg2.visible=true;
				speed=40;
				isLoop2=true;
				cloopCount2=0;
				tick2=getTimer();
				totalCount2=count * grid2Array.length + (index + 1); // 循环数量 与索引差1
				//				trace("--------------index = " + index + "totalCount = " + totalCount);
				TimeManager.getInstance().addITick(30, onLoopChange2);
			}
		}
		
		private function onLoopChange2():void{
			var interval:int=getTimer() - tick2;
			if (interval >= speed) {
				tick2=getTimer();
				var cindex:int=cloopCount2 % grid2Array.length;
				var gi:int=loopOrder[cindex];
				//				trace("----------------cindex = "+ cindex + "-----gi = "+ gi)
				cloopCount2++;
				if (totalCount2 <= cloopCount2 + 8) {
					speed+=30;
				}
				if ((totalCount2 <= cloopCount2) && TimeManager.getInstance().hasITick(onLoopChange2)) {
					//					trace("-----------totalCount = "+ totalCount + " -- cloopCount = "+ cloopCount)
					isLoop2=false;
					receiveReward2();
					TimeManager.getInstance().removeITick(onLoopChange2);
				}
				selectImg2.x=grid2Array[gi].x;
				selectImg2.y=grid2Array[gi].y;
			}
		}
		
		private function receiveReward2():void{
			Cmd_Fanl.cm_Fanl_A(2);
			flyItem(2, pos2, num2);
		}
		
		private function getIndex($type:int, $pos:int, $num:int):int{
			var gridArr:Vector.<MarketGrid> = (1 == $type) ? grid1Array : grid2Array;
			var length:int = gridArr.length;
			for(var n:int = 0; n < length; n++){
				var grid:MarketGrid = gridArr[n];
				if(($pos == grid.dataId) && ($num == grid.count)){
					return loopOrder.indexOf(n);
				}
			}
			return 0;
		}
		
		protected function loop1(count:int=1, index:int=0):void {
			if (!TimeManager.getInstance().hasITick(onLoopChange1)) {
				selectImg1.visible=true;
				speed=40;
				isLoop1=true;
				cloopCount1=0;
				tick1=getTimer();
				totalCount1=count * grid1Array.length + (index + 1); // 循环数量 需加1
//				trace("--------------index = " + index + "totalCount = " + totalCount);
				TimeManager.getInstance().addITick(30, onLoopChange1);
			}
		}
		
		private function onLoopChange1():void {
			var interval:int=getTimer() - tick1;
			if (interval >= speed) {
				tick1=getTimer();
				var cindex:int=cloopCount1 % grid1Array.length;
				var gi:int=loopOrder[cindex];
//				trace("----------------cindex = "+ cindex + "-----gi = "+ gi)
				cloopCount1++;
				if (totalCount1 <= cloopCount1 + 8) {
					speed+=30;
				}
				if ((totalCount1 <= cloopCount1) && TimeManager.getInstance().hasITick(onLoopChange1)) {
//					trace("-----------totalCount = "+ totalCount + " -- cloopCount = "+ cloopCount)
					isLoop1=false;
					receiveReward1();
					TimeManager.getInstance().removeITick(onLoopChange1);
				}
				selectImg1.x=grid1Array[gi].x;
				selectImg1.y=grid1Array[gi].y;
			}
		}
		
		private function receiveReward1():void{
			Cmd_Fanl.cm_Fanl_A(1);
			flyItem(1, pos1, num1);
		}
		
		private function flyItem($type:int, $pos:int, $num:int):void{
			var gridArr:Vector.<MarketGrid> = (1 == $type) ? grid1Array : grid2Array;
			var length:int = gridArr.length;
			for(var n:int = 0; n < length; n++){
				var grid:MarketGrid = gridArr[n];
				if(($pos == grid.dataId) && ($num == grid.count)){
					FlyManager.getInstance().flyBags([$pos], [grid.localToGlobal(new Point())]);
					break;
				}
			}
		}
		
		public function updateInfo():void{
			var data:PayPromotionDataII = DataManager.getInstance().payPromotionData_II;
			var list1:Array = data.lotteryData1;
			var list2:Array = data.lotteryData2;
			var length:int = list1.length;
			for(var n:int = 0; n < length; n++){
				grid1Array[n].updataInfo({itemId:list1[n][0], count:list1[n][1]});
				grid2Array[n].updataInfo({itemId:list2[n][0], count:list2[n][1]});
			}
			grid1Array[0].filters = (1 == data.title1Status) ? [FilterEnum.enable] : null;
			title1Img.filters = (0 == data.title1Status) ? [FilterEnum.enable] : null;
			grid2Array[0].filters = (1 == data.title2Status) ? [FilterEnum.enable] : null;
			title2Img.filters = (0 == data.title3Status) ? [FilterEnum.enable] : null;
			title3Img.filters = (0 == data.title2Status) ? [FilterEnum.enable] : null;
			title4Img.filters = (0 == data.title4Status) ? [FilterEnum.enable] : null;
		}
	}
}
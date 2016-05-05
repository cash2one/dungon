package com.leyou.ui.welfare.child.component
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSignGiftInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WelfareLoginRender extends AutoSprite
	{
		private var receiveImg:Image;
		
		private var btnImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var _grids:Vector.<MarketGrid>;
		
		private var signCount:int;
		
		public var readyToFly:Boolean;
		
		public function WelfareLoginRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLoginRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			_grids = new Vector.<MarketGrid>();
			//			vipGrids = new Vector.<MarketGrid>();
			
			for(var n:int = 0; n < 4; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.x = 25 + n * 72;
				grid.y = 15;
				grid.isShowPrice = false;
				addChild(grid);
				_grids.push(grid);
			}
			btnImg = getUIbyID("btnImg") as Image;
			receiveImg = getUIbyID("receiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		public function updateGift($signCount:int, status:int, signedCount:int):void{
			signCount = $signCount;
			var threshold:Boolean = (signedCount >= $signCount);
			//按钮状态处理
			if(!threshold){
				btnImg.visible = false;
				receiveImg.visible = true;
				receiveImg.updateBmp("ui/welfare/btn_lqjl3.png");
			}else{
				receiveImg.updateBmp("ui/welfare/btn_lqjl2.png");
				if(0 == status){
					btnImg.visible = true;
					receiveImg.visible = false;
				}else{
					btnImg.visible = false;
					receiveImg.visible = true;
				}
			}
//			var url:String = threshold ? "ui/welfare/btn_lqjl.png" : "ui/welfare/btn_lqjl3.png";
//			btnImg.updateBmp(url);
//			btnImg.x = receiveBtn.x + (receiveBtn.width - 71) * 0.5;
//			btnImg.y = receiveBtn.y + 13;
//			receiveImg.visible = (1 == status);
//			btnImg.visible = (0 == status);
			
			receiveBtn.setActive((!receiveImg.visible && threshold), 1, true);
			// 奖励处理
			var filters:Array = receiveImg.visible ? [FilterEnum.enable] : null;
			var giftInfo:TSignGiftInfo = TableManager.getInstance().getSignGiftInfo(signCount);
			var index:int = 0;
			var grid:MarketGrid = _grids[index];
			if(giftInfo.bIb > 0){
				index++;
				grid.updataInfo({itemId:65532, count:giftInfo.bIb});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.exp > 0){
				index++;
				grid.updataInfo({itemId:65534, count:giftInfo.exp});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.money > 0){
				index++;
				grid.updataInfo({itemId:65535, count:giftInfo.money});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.energy > 0){
				index++;
				grid.updataInfo({itemId:65533, count:giftInfo.energy});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.item1 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item1, count:giftInfo.itemCount1});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			
			
			grid = _grids[index];
			if(giftInfo.item2 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item2, count:giftInfo.itemCount2});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.item3 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item3, count:giftInfo.itemCount3});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = _grids[index];
			if(giftInfo.item4 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item4, count:giftInfo.itemCount4});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			// 指引
			//			if(!receiveImg.visible && threshold){
			//				GuideManager.getInstance().showGuide(49, receiveBtn);
			//			}
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			var btnName:String = event.target.name;
			switch(btnName){
				case "receiveBtn":
					readyToFly = true;
					Cmd_Welfare.cm_SIGN_J(signCount);
//					GuideManager.getInstance().removeGuide(49);
					break;
			}
		}
		
		public function flyItem():void{
			readyToFly = false;
			var aids:Array = [];
			var starts:Array = [];
			for(var n:int = 0; n < 4; n++){
				var grid:MarketGrid = _grids[n];
				if(0 != grid.dataId){
					aids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(aids, starts);	
		}
		
		public function checkGuide():void{
			receiveBtn.isActive ? GuideManager.getInstance().show(49) : GuideManager.getInstance().remove(49);
		}
	}
}
package com.leyou.ui.welfare.child.component
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSignGiftInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	
	public class WelfareLoginRender extends AutoSprite
	{
		private var receiveImg:Image;
		
		private var vipReceiveImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var vipReceiveBtn:ImgButton;
		
		private var _grids:Vector.<MarketGrid>;
		
		//		private var vipGrids:Vector.<MarketGrid>;
		
		private var btnImg:Image;
		
		private var btnVipImg:Image;
		
		private var signCount:int;
		
		private var _flySignCount:int = - 1;
		
		private var _isVip:Boolean = false;
		
		public function WelfareLoginRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLoginRender.xml"));
			init();
		}
		
		public function get grids():Vector.<MarketGrid>
		{
			return _grids;
		}

		public function get isVip():Boolean{
			return _isVip;
		}

		public function get flySignCount():int{
			return _flySignCount;
		}

		private function init():void{
			mouseChildren = true;
			_grids = new Vector.<MarketGrid>();
			//			vipGrids = new Vector.<MarketGrid>();
			
			for(var n:int = 0; n < 6; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.x = 19 + n * 72;
				grid.y = 23;
				grid.isShowPrice = false;
				addChild(grid);
				grids.push(grid);
			}
			for(var m:int = 0; m < 2; m++){
				var vg:MarketGrid = new MarketGrid();
				vg.x = 491 + m * 90;
				vg.y = 23;
				vg.isShowPrice = false;
				addChild(vg);
				grids.push(vg);
			}
			
			receiveImg = getUIbyID("receiveImg") as Image;
			vipReceiveImg = getUIbyID("vipReceiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			vipReceiveBtn = getUIbyID("vipReceiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			vipReceiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			addChild(receiveImg);
			addChild(vipReceiveImg);
			
			btnImg = getUIbyID("btnImg") as Image;
			btnVipImg = getUIbyID("btnVipImg") as Image;
		}
		
		public function updateGift($signCount:int, status:int, vipStatus:int, signedCount:int):void{
			var threshold:Boolean = (signedCount >= $signCount);
			receiveImg.visible = Boolean(status);
			receiveBtn.setActive((!receiveImg.visible && threshold), 1, true);
			vipReceiveImg.visible  = Boolean(vipStatus);
			var isVip:Boolean = Core.me.info.vipLv > 0;
			vipReceiveBtn.setActive((!vipReceiveImg.visible && threshold && isVip), 1, true);
			var url:String;
			if(receiveImg.visible){
				url = "ui/welfare/btn_lqjl2.png";
			}else{
				url = threshold ? "ui/welfare/btn_lqjl.png" : "ui/welfare/btn_lqjl3.png";
			}
			// 指引
			if(!receiveImg.visible && threshold){
				GuideManager.getInstance().showGuide(49, UIManager.getInstance().welfareWnd);
			}
			btnImg.updateBmp(url);
			var offSet:int;
			if(vipReceiveImg.visible){
				url = "ui/welfare/btn_lqjl2.png";
				offSet = (vipReceiveBtn.width - 71) * 0.5;
			}else{
				url = threshold ? "ui/welfare/btn_vipjl.png" : "ui/welfare/btn_lqjl3.png";
				offSet = threshold ? (vipReceiveBtn.width - 101) * 0.5 : (vipReceiveBtn.width - 71) * 0.5;
			}
			btnVipImg.x = vipReceiveBtn.x + offSet;
			btnVipImg.updateBmp(url);
			// 指引
//			if(!vipReceiveImg.visible && threshold){
//				GuideManager.getInstance().showGuide(49, UIManager.getInstance().welfareWnd);
//			}
			signCount = $signCount;
			var filters:Array = receiveImg.visible ? [FilterEnum.enable] : null;
			var vipFilters:Array = vipReceiveImg.visible ? [FilterEnum.enable] : null;
			var giftInfo:TSignGiftInfo = TableManager.getInstance().getSignGiftInfo(signCount);
			var index:int = 0;
			var grid:MarketGrid = grids[index];
			if(giftInfo.bIb > 0){
				index++;
				grid.updataInfo({itemId:65532, count:giftInfo.bIb});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.exp > 0){
				index++;
				grid.updataInfo({itemId:65534, count:giftInfo.exp});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.money > 0){
				index++;
				grid.updataInfo({itemId:65535, count:giftInfo.money});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.energy > 0){
				index++;
				grid.updataInfo({itemId:65533, count:giftInfo.energy});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.item1 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item1, count:giftInfo.itemCount1});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.item2 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item2, count:giftInfo.itemCount2});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.item3 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item3, count:giftInfo.itemCount3});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.item4 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.item4, count:giftInfo.itemCount4});
				grid.filters = filters;
			}else{
				grid.clear();
			}
			for(var n:int = index; n < 6; n++){
				grids[n].clear();
			}
			index = 6;
			grid = grids[index];
			if(giftInfo.vipItem1 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.vipItem1, count:giftInfo.vipItemCount1});
				grid.filters = vipFilters;
			}else{
				grid.clear();
			}
			grid = grids[index];
			if(giftInfo.vipItem2 > 0){
				index++;
				grid.updataInfo({itemId:giftInfo.vipItem2, count:giftInfo.vipItemCount2});
				grid.filters = vipFilters;
			}else{
				grid.clear();
			}
			var length:int = grids.length;
			for(var m:int = index; m < length; m++){
				grids[n].clear();
			}
		}
		
//		public function checkGuide():void{
//			// 指引
//			if(vipReceiveBtn.isActive){
//				GuideManager.getInstance().showGuide(49, receiveBtn);
//			}
//			// 指引
//			if(vipReceiveBtn.isActive){
//				GuideManager.getInstance().showGuide(49, vipReceiveBtn);
//			}
//		}
		
		protected function onButtonClick(event:MouseEvent):void{
			_flySignCount = signCount;
			var btnName:String = event.target.name;
			switch(btnName){
				case "receiveBtn":
					_isVip = false;
					Cmd_Welfare.cm_SIGN_J(signCount);
					GuideManager.getInstance().removeGuide(49);
					break;
				case "vipReceiveBtn":
					_isVip = true;
					Cmd_Welfare.cm_SIGN_V(signCount);
					break;
			}
		}
	}
}
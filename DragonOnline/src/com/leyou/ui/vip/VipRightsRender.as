package com.leyou.ui.vip
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.vip.TipVipEquipInfo;
	import com.leyou.data.vip.VipData;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class VipRightsRender extends AutoSprite
	{
		private var privilegBtn:ImgButton;
		
		private var promotion1Img:Image;
		
		private var promotion2Img:Image;
		
		private var nameImg:Image;
		
		private var vipTab:TabBar;
		
		private var listener:Function;
		
		private var _currentIdx:int = -1;
		
		private var sptMovie:SwfLoader;
		
		private var grids:Vector.<MarketGrid>;
		
//		private var statusList:Array;
		
		private var receiveBtn:ImgButton;
		
		private var reveiceImg:Image;
		private var flyIds:Array;
		private var starts:Array;
		private var tipsInfo:TipVipEquipInfo;
		
		public function VipRightsRender(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipRightRender.xml"));
			init();
		}
		
		private function init():void{
			flyIds = [];
			starts = [];
//			statusList = [];
			mouseChildren = true;
			tipsInfo = new TipVipEquipInfo();
			sptMovie = new SwfLoader();
			sptMovie.x = 174;
			sptMovie.y = 280;
			addChild(sptMovie);
//			wingMovie.mouseEnabled = true;
//			wingMovie.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			grids = new Vector.<MarketGrid>(5);
			privilegBtn = getUIbyID("privilegBtn") as ImgButton;
			promotion1Img = getUIbyID("promotion1Img") as Image;
			promotion2Img = getUIbyID("promotion2Img") as Image;
			reveiceImg = getUIbyID("reveiceImg") as Image;
			nameImg = getUIbyID("nameImg") as Image;
			vipTab = getUIbyID("vipTab") as TabBar;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			privilegBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			vipTab.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			vipTab.turnToTab(0);
			var hitW:int = 60;
			var hitH:int = 180;
			var sp:Sprite = new Sprite();
			var g:Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRect(0, 0, hitW, hitH);
			g.endFill();
			addChild(sp);
			sp.x = 174 - hitW*0.5;
			sp.y = 280 - hitH;
			sp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tipsInfo.lv = Core.me.info.level;
			tipsInfo.vipLv = _currentIdx+1;
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "receiveBtn":
					Cmd_Vip.cm_VIP_J(_currentIdx+1);
					setFlyItem();
					break;
				case "privilegBtn":
					if(null != listener){
						listener.call(this, event);
					}
					break;
			}
		}
		
		public function updateVipLv(lv:int):void{
			if(lv <= 0 || lv > 10) return;
			for each(var g:MarketGrid in grids){
				if(null != g){
					g.clear();
				}
			}
//			trace("------------------------------trace vip gride count label width begin")
			var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(lv);
			var index:int = 0;
			var grid:MarketGrid;
			if(vipDetail.item1 > 0){
				grid = getGrid(index);
				grid.updataInfo({itemId:vipDetail.item1, count:vipDetail.num1});
				index++;
			}
			if(vipDetail.item2 > 0){
				grid = getGrid(index);
				grid.updataInfo({itemId:vipDetail.item2, count:vipDetail.num2});
				index++;
			}
			if(vipDetail.item3 > 0){
				grid = getGrid(index);
				grid.updataInfo({itemId:vipDetail.item3, count:vipDetail.num3});
				index++;
			}
			if(vipDetail.item4 > 0){
				grid = getGrid(index);
				grid.updataInfo({itemId:vipDetail.item4, count:vipDetail.num4});
				index++;
			}
			if(vipDetail.item5 > 0){
				grid = getGrid(index);
				grid.updataInfo({itemId:vipDetail.item5, count:vipDetail.num5});
				index++;
			}
//			trace("------------------------------trace vip gride count label width end")
		}
		
		public function getGrid(index:int):MarketGrid{
			var grid:MarketGrid = grids[index];
			if(null == grid){
				grid = new MarketGrid();
				grid.isShowPrice = false;
				grid.x = 526 + 65*(index%3);
				grid.y = 51 + 76*int(index/3);
				grids[index] = grid;
				addChild(grid);
				swapChildren(grid, reveiceImg);
			}
			return grid;
		}
		
		protected function onTabBarChangeIndex(event:Event):void{
			if (_currentIdx == vipTab.turnOnIndex){
				return;
			}
			_currentIdx = vipTab.turnOnIndex;
			var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(_currentIdx+1);
			var s1Url:String = "ui/vip/"+vipDetail.show1PicUrl;
			var s2Url:String = "ui/vip/"+vipDetail.show2PicUrl;
			var snUrl:String = "ui/vip/"+vipDetail.equipSourceurl;
			promotion1Img.updateBmp(s1Url);
			promotion2Img.updateBmp(s2Url);
			nameImg.updateBmp(snUrl);
			sptMovie.update(vipDetail.modelBigId);
			sptMovie.playAct("stand", 4);
			updateVipLv(_currentIdx+1);
			updateStatus();
		}
		
		public function register(onSwitchClick:Function):void{
			listener = onSwitchClick;
		}
		
		private function setFlyItem():void{
			flyIds.length = 0;
			starts.length = 0;
			for each(var grid:MarketGrid in grids){
				if(0 != grid.dataId){
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
		}
		
		public function flyItem():void{
			if(0 != flyIds.length){
				FlyManager.getInstance().flyBags(flyIds, starts);
			}
		}
		
		public function updateStatus():void{
			var data:VipData = DataManager.getInstance().vipData;
			if((null == data.status) || (0 == data.status.length)){
				return;
			}
			var statusList:Array = data.status;
			reveiceImg.visible = (1 == statusList[_currentIdx]);
			if(reveiceImg.visible || (Core.me.info.vipLv < _currentIdx+1)){
				receiveBtn.setActive(false, 1, true);
			}else{
				receiveBtn.setActive(true, 1, true);
			}
			for each(var g:MarketGrid in grids){
				if(null != g){
					g.filters = reveiceImg.visible ? [FilterEnum.enable] : null;
				}
			}
		}
		
		public function switchToObtainable():void{
			var statusList:Array = DataManager.getInstance().vipData.status;
			var l:int = statusList.length;
			for(var n:int = 0; n < l; n++){
				if(0 == statusList[n]){
					vipTab.turnToTab(n);
					break;
				}
			}
		}
	}
}
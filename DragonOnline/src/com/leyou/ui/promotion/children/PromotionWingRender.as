package com.leyou.ui.promotion.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PromotionWingRender extends AutoSprite
	{
		private var receiveBtn:NormalButton;
		
		private var lvImg:Image;
		
		private var nameImg:Image;
		
		private var grids:Vector.<MarketGrid>;
		
		private var _id:int;
		
		private var receiveImg:Image;
		
		private var gr1Img:Image;
		
		private var gr2Img:Image;
		
		private var gr3Img:Image;
		
		private var gr4Img:Image;
		
		private var gr5Img:Image;
		
		public function PromotionWingRender(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqWingRender.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			lvImg = getUIbyID("lvImg") as Image;
			nameImg = getUIbyID("nameImg") as Image;
			receiveImg = getUIbyID("receiveImg") as Image;
			grids = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.isShowPrice = false;
				grid.x = 188 + 66*n;
				grid.y = 21;
				grids.push(grid);
				addChild(grid);
			}
			gr1Img = getUIbyID("gr1") as Image;
			gr2Img = getUIbyID("gr2") as Image;
			gr3Img = getUIbyID("gr3") as Image;
			gr4Img = getUIbyID("gr4") as Image;
			gr5Img = getUIbyID("gr5") as Image;
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			Cmd_Fanl.cm_Fanl_J(id);
		}
		
		public function updateInfo(data:PayPromotionItem):void{
			_id = data.id;
			var tinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(data.id);
			lvImg.updateBmp("ui/horse/horse_lv"+tinfo.value+".png");
			nameImg.updateBmp("ui/wing/wing_lv"+tinfo.value+"_name.png");
			for each(var g:MarketGrid in grids){
				if(null != g){
					g.visible = false;
				}
			}
			gr1Img.visible = (tinfo.rItem1 > 0);
			gr2Img.visible = (tinfo.rItem2 > 0);
			gr3Img.visible = (tinfo.rItem3 > 0);
			gr4Img.visible = (tinfo.rItem4 > 0);
			gr5Img.visible = (tinfo.rItem5 > 0);
			var index:int = 0;
			var grid:MarketGrid = grids[index];
			if(tinfo.rItem1 > 0){
				index++;
				grid.visible = true;
				grid.updataInfo({itemId:tinfo.rItem1, count:tinfo.rItemNum1});
				grid.filters = (2 == data.status) ? [FilterEnum.enable] : null;
			}
			grid = grids[index];
			if(tinfo.rItem2 > 0){
				index++;
				grid.visible = true;
				grid.updataInfo({itemId:tinfo.rItem2, count:tinfo.rItemNum2});
				grid.filters = (2 == data.status) ? [FilterEnum.enable] : null;
			}
			grid = grids[index];
			if(tinfo.rItem3 > 0){
				index++;
				grid.visible = true;
				grid.updataInfo({itemId:tinfo.rItem3, count:tinfo.rItemNum3});
				grid.filters = (2 == data.status) ? [FilterEnum.enable] : null;
			}
			grid = grids[index];
			if(tinfo.rItem4 > 0){
				index++;
				grid.visible = true;
				grid.updataInfo({itemId:tinfo.rItem4, count:tinfo.rItemNum4});
				grid.filters = (2 == data.status) ? [FilterEnum.enable] : null;
			}
			grid = grids[index];
			if(tinfo.rItem5 > 0){
				index++;
				grid.visible = true;
				grid.updataInfo({itemId:tinfo.rItem5, count:tinfo.rItemNum5});
				grid.filters = (2 == data.status) ? [FilterEnum.enable] : null;
			}
			receiveImg.visible = false;
			if(0 == data.status){
				receiveBtn.text = "未达成";
				receiveBtn.setActive(false, 1, true);
			}else if(1 == data.status){
				receiveBtn.text = "领取奖励";
				receiveBtn.setActive(true, 1, true);
			}else if(2 == data.status){
				receiveBtn.text = "已领取";
				receiveImg.visible = true;
				addChild(receiveImg);
				receiveBtn.setActive(false, 1, true);
			}
		}
		
		public function flyItem():void{
			var ids:Array = [];
			var point:Array = [];
			for each(var g:MarketGrid in grids){
				if(null != g){
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}
	}
}
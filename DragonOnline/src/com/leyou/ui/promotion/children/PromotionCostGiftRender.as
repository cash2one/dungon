package com.leyou.ui.promotion.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PromotionCostGiftRender extends AutoSprite
	{
		private var titleLbl:Label;
		
		private var receiveImg:Image;
		
		private var repeatLbl:Label;
		
		private var receiveBtn:NormalButton;
		
		private var _id:int;
		
		private var grids:Vector.<MarketGrid>;
		
		private var gr1Img:Image;
		
		private var gr2Img:Image;
		
		private var gr3Img:Image;
		
		private var gr4Img:Image;
		
		public function PromotionCostGiftRender(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqXfRender.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			titleLbl = getUIbyID("titleLbl") as Label;
			receiveImg = getUIbyID("receiveImg") as Image;
			repeatLbl = getUIbyID("repeatLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			gr1Img =getUIbyID("gr5") as Image;
			gr2Img =getUIbyID("gr0") as Image;
			gr3Img =getUIbyID("gr1") as Image;
			gr4Img =getUIbyID("gr2") as Image;
			receiveBtn.addEventListener(MouseEvent.CLICK, onClick);
			repeatLbl.visible = false;
			grids = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 4; n++){
				var grid:MarketGrid=new MarketGrid();
				grid.isShowPrice=false;
				grid.x=192 + 72 * n;
				grid.y=20.65;
				grids.push(grid);
				addChild(grid);
			}
		}
		
		protected function onClick(event:MouseEvent):void{
			switch(event.target.name){
				case "receiveBtn":
					Cmd_Fanl.cm_Fanl_J(_id);
					break;
			}
		}
		
		public function updateInfo(info:PayPromotionItem):void{
			var tinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(info.id);
			titleLbl.text = tinfo.des1;
			_id=info.id;
			for each (var g:MarketGrid in grids) {
				if (null != g) {
					g.visible=false;
				}
			}
			gr1Img.visible=(tinfo.rItem1 > 0);
			gr2Img.visible=(tinfo.rItem2 > 0);
			gr3Img.visible=(tinfo.rItem3 > 0);
			gr4Img.visible=(tinfo.rItem4 > 0);
			var index:int=0;
			var grid:MarketGrid=grids[index];
			if (tinfo.rItem1 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem1, tinfo.rItemNum1);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem2 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem2, tinfo.rItemNum2);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem3 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem3, tinfo.rItemNum3);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem4 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem4, tinfo.rItemNum4);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem5 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem5, tinfo.rItemNum5);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem6 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem6, tinfo.rItemNum6);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem7 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem7, tinfo.rItemNum7);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.rItem8 > 0) {
				index++;
				grid.visible=true;
				grid.updateInfoII(tinfo.rItem8, tinfo.rItemNum8);
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			
			receiveImg.visible=false;
//			repeatLbl.text=StringUtil.substitute(PropUtils.getStringById(1827), info.currentc);
			if (0 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1576);
				receiveBtn.setActive(false, 1, true);
			} else if (1 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1575);
				receiveBtn.setActive(true, 1, true);
			} else if (2 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1574);
				receiveImg.visible=true;
				addChild(receiveImg);
				receiveBtn.setActive(false, 1, true);
			}
			
		}
		
		public function flyItem():void {
			var ids:Array=[];
			var point:Array=[];
			for each (var g:MarketGrid in grids) {
				if (null != g) {
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}
	}
}
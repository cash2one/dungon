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
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PromotionCollectWordRender extends AutoSprite
	{
		private var grids:Vector.<MarketGrid>;
		
		private var receiveBtn:NormalButton;
		
		private var grImg:Image;
		
		private var repeatLbl:Label;
		
		private var _id:int;
		
		private var plus1Img:Image;
		
		private var gr1Img:Image;
		
		private var plus2Img:Image;
		
		private var gr2Img:Image;
		
		public function PromotionCollectWordRender(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqJzRender.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		public function init():void{
			mouseChildren = true;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			repeatLbl = getUIbyID("repeatLbl") as Label;
			grids=new Vector.<MarketGrid>();
			for (var n:int=0; n < 5; n++) {
				var grid:MarketGrid=new MarketGrid();
				grid.isShowPrice=false;
				grid.x=23 + 110 * n;
				grid.y=19;
				grids.push(grid);
				addChild(grid);
				if(n > 3){
					grid.x = 425;
				}
			}
			grImg=getUIbyID("gr7") as Image;
			
			plus1Img=getUIbyID("gr0") as Image;
			gr1Img=getUIbyID("gr2") as Image;
			plus2Img=getUIbyID("gr5") as Image;
			gr2Img=getUIbyID("gr3") as Image;
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			Cmd_Fanl.cm_Fanl_J(_id);
		}
		
		public function updateInfo(data:PayPromotionItem):void{
			repeatLbl.visible = (data.maxc != -1);
			repeatLbl.text=StringUtil.substitute(PropUtils.getStringById(1827), data.currentc);
			_id=data.id;
			var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(data.id);
			var index:int=0;
			var grid:MarketGrid=grids[index];
			if (tinfo.ex_item1 > 0) {
				index++;
				grid.visible=true;
				grid.updataInfo({itemId: tinfo.ex_item1, count: tinfo.ex_item1Num});
//				grid.filters=(2 == data.status) ? [FilterEnum.enable] : null;
			}
			grid=grids[index];
			if (tinfo.ex_item2 > 0) {
				index++;
				plus1Img.visible = true;
				gr1Img.visible = true;
				grid.visible=true;
				grid.updataInfo({itemId: tinfo.ex_item2, count: tinfo.ex_item2Num});
//				grid.filters=(2 == data.status) ? [FilterEnum.enable] : null;
			}else{
				plus1Img.visible = false;
				gr1Img.visible = false;
				grid.visible = false;
			}
			grid=grids[index];
			if (tinfo.ex_item3 > 0) {
				index++;
				plus2Img.visible = true;
				gr2Img.visible = true;
				grid.visible=true;
				grid.updataInfo({itemId: tinfo.ex_item3, count: tinfo.ex_item3Num});
//				grid.filters=(2 == data.status) ? [FilterEnum.enable] : null;
			}else{
				plus2Img.visible = false;
				gr2Img.visible = false;
				grid.visible = false;
			}
			index = 3;
			grid=grids[index];
			grid.updataInfo({itemId: tinfo.rItem1, count: tinfo.rItemNum1});
			grid=grids[index+1];
			grid.visible = (tinfo.rItem2 > 0);
			grImg.visible = (tinfo.rItem2 > 0);
			if(tinfo.rItem2 > 0){
				grid.updataInfo({itemId: tinfo.rItem2, count: tinfo.rItemNum2});
			}
			receiveBtn.setActive((data.currentc > 0), 1, true);
		}
		
		public function flyItem():void{
			var ids:Array=[];
			var point:Array=[];
			for(var n:int = 3; n < 5; n++) {
				var g:MarketGrid = grids[n];
				if ((null != g) && g.visible) {
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}
	}
}
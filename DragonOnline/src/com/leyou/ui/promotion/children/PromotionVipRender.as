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
	
	public class PromotionVipRender extends AutoSprite
	{
		private var gridImgs:Vector.<Image>;
		
		private var receiveBtn:NormalButton;
		
		private var conditionLbl:Label;
		
		private var girds:Vector.<MarketGrid>;
		
//		private var receiveImg:Image;
		
		private var _id:int;
		
		public function PromotionVipRender(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqVipRender.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			gridImgs = new Vector.<Image>();
			girds = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 8; n++){
				gridImgs.push(getUIbyID("gr"+(n+1)+"Img"));
				var grid:MarketGrid = new MarketGrid();
				grid.x = gridImgs[n].x;
				grid.y = gridImgs[n].y;
				girds.push(grid);
				addChild(grid);
			}
//			receiveImg = getUIbyID("receiveImg") as Image;
			conditionLbl = getUIbyID("conditionLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			addChild(receiveImg);
		}
		
		private function resetRewardCount(num:int):void{
			var l:int = gridImgs.length;
			for(var n:int = 0; n < l; n++){
				if((n + 1) > num){
					girds[n].visible = false;
					gridImgs[n].visible = false;
				}else{
					girds[n].visible = true;
					gridImgs[n].visible = true;
				}
			}
		}
		
		public function updateInfo(itemInfo:PayPromotionItem):void{
			_id = itemInfo.id;
//			receiveImg.visible = (2 == itemInfo.status);
			var info:TPayPromotion = TableManager.getInstance().getPayPromotion(itemInfo.id);
			conditionLbl.text = StringUtil.substitute(TableManager.getInstance().getSystemNotice(10047).content, info.value);
			var items:Vector.<int> = info.items;
			var itemNums:Vector.<int> = info.itemNums;
			var length:int = items.length;
			resetRewardCount(length);
			for(var n:int = 0; n < length; n++){
				girds[n].updataInfo({itemId:items[n], count:itemNums[n]});
				girds[n].filters = (2 == itemInfo.status) ? [FilterEnum.enable] : null;
			}
			
			if (0 == itemInfo.status) {
//				receiveBtn.text=PropUtils.getStringById(1576);
				receiveBtn.setActive(false, 1, true);
			} else if (1 == itemInfo.status) {
				receiveBtn.text=PropUtils.getStringById(1575);
				receiveBtn.setActive(true, 1, true);
			} else if (2 == itemInfo.status) {
				receiveBtn.visible = false;
//				receiveBtn.text=PropUtils.getStringById(1574);
//				receiveBtn.setActive(false, 1, true);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			Cmd_Fanl.cm_Fanl_J(_id);
		}
		
		public function flyItem():void{
			var ids:Array=[];
			var point:Array=[];
			for each (var g:MarketGrid in girds) {
				if (null != g && 0 < g.dataId) {
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}
	}
}
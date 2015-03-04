package com.leyou.ui.groupBuy.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TGroupBuyItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.groupBuy.GroupBuyItemData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_GBUY;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class GroupBuyItem extends AutoSprite
	{
		private var nameLbl:Label;
		
		private var npriceLbl:Label;
		
		private var cpriceLbl:Label;
		
		private var buyBtn:NormalButton;
		
		private var pcountLbl:Label;
		
		private var grid:MarketGrid;
		
		private var widgets:Vector.<GroupBuyItemWidget>;
		
		private var _id:int;
		
		private var index:int;
		
		private var data:GroupBuyItemData;
		
		public function GroupBuyItem(){
			super(LibManager.getInstance().getXML("config/ui/groupBuy/groupbuyRender.xml"));
			init();
		}
		
		public function get id():int{
			return _id;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			grid = new MarketGrid();
			grid.x = 32;
			grid.y = 25;
			grid.isShowPrice = false;
			addChild(grid);
			nameLbl = getUIbyID("nameLbl") as Label;
			npriceLbl = getUIbyID("npriceLbl") as Label;
			cpriceLbl = getUIbyID("cpriceLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			pcountLbl = getUIbyID("pcountLbl") as Label;
			widgets = new Vector.<GroupBuyItemWidget>(6);
			for(var n:int = 0; n < 6; n++){
				var widget:GroupBuyItemWidget = widgets[n];
				if(null == widget){
					widget = new GroupBuyItemWidget();
					widgets[n] = widget;
					widget.x = 237 + n*55;
					widget.y = 43;
					addChild(widget);
				}
			}
			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		public function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "buyBtn":
					var tinfo:TGroupBuyItemInfo = TableManager.getInstance().getGroupbuyItemInfo(data.id);
					var content:String = TableManager.getInstance().getSystemNotice(10013).content;
					content = StringUtil.substitute(content, tinfo.cPrice, ItemUtil.getColorName(tinfo.giftItem, 12));
					PopupManager.showConfirm(content, buy, null, false, "group.buy");
					break;
			}
		}
		
		public function buy():void{
			Cmd_GBUY.cm_GBUY_B(id);
		}
		
		public function updateInfo($data:GroupBuyItemData, $index:int):void{
			index = $index;
			data = $data;
			_id = data.id;
			var tinfo:TGroupBuyItemInfo = TableManager.getInstance().getGroupbuyItemInfo(data.id);
			grid.updataById(tinfo.giftItem);
			nameLbl.htmlText = ItemUtil.getColorName(tinfo.giftItem);
			npriceLbl.text = tinfo.nPrice+"";
			cpriceLbl.text = tinfo.cPrice+"";
			pcountLbl.text = data.buyCount+"";
			var countArr:Array = ConfigEnum["groupbuy"+(index+2)].split("|");
			var st:int;
			for(var n:int = 0; n < 6; n++){
				var widget:GroupBuyItemWidget = widgets[n];
				if(null == widget){
					widget = new GroupBuyItemWidget();
					addChild(widget);
				}
				var count:int = countArr[n];
				// 0 -- 未达成 1 -- 可领取 2 -- 已领取 3 -- 可领取但未购买
				if(data.hasReceive(count)){
					st = 2;
				}else{
					if(0 == $data.status){
						st = (data.buyCount >= count) ? 3 : 0;
					}else{
						st = (data.buyCount >= count) ? 1 : 0;
					}
				}
				widget.updateInfo(tinfo.getReward(n), tinfo.getRewardCount(n), count, st, id);
			}
			
			buyBtn.setActive((0 == data.status), 1, true);
			if(0 == data.status){
				buyBtn.text = "购买";
			}else if(1 == data.status){
				buyBtn.text = "已购买";
			}
		}
		
		public function flyGift():void{
			FlyManager.getInstance().flyBags([grid.dataId], [grid.localToGlobal(new Point(0,0))]);
		}
		
		public function flyGroupGift(pcount:int):void{
			for each(var widget:GroupBuyItemWidget in widgets){
				if(widget.pcount == pcount){
					widget.flyGift();
					break;
				}
			}
		}
	}
}
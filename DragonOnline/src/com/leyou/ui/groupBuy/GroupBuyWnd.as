package com.leyou.ui.groupBuy
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.data.groupBuy.GroupBuyData;
	import com.leyou.data.groupBuy.GroupBuyItemData;
	import com.leyou.ui.groupBuy.children.GroupBuyItem;
	import com.leyou.util.DateUtil;
	
	public class GroupBuyWnd extends AutoWindow
	{
		private var remainLbl:Label;
		
		private var desLbl:Label;
		
		private var items:Vector.<GroupBuyItem>;
		
		public function GroupBuyWnd(){
			super(LibManager.getInstance().getXML("config/ui/groupBuy/groupbuyWnd.xml"));
			init();
		}
		
		public function init():void{
			hideBg();
			remainLbl = getUIbyID("remainLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			items = new Vector.<GroupBuyItem>();
//			clsBtn.x += 4;
//			clsBtn.y += 13;
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(10012).content;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		private function updateTime():void{
			var remainTime:int = DataManager.getInstance().groupBuyData.remainTime;
			remainLbl.text = DateUtil.formatTime(remainTime*1000, 2);
		}
		
		public function updateInfo():void{
			var data:GroupBuyData = DataManager.getInstance().groupBuyData;
			updateTime();
			var count:int = data.getItemCount();
			items.length = count;
			for(var n:int = 0; n < count; n++){
				var itemData:GroupBuyItemData = data.getItemData(n);
				var item:GroupBuyItem = items[n];
				if(null == item){
					item = new GroupBuyItem();
					items[n] = item;
					pane.addChildAt(item, 2);
					item.x = 31;
					item.y = 155 + 145*n;
				}
				item.updateInfo(itemData, n);
			}
		}
		
		private function getItemById(id:int):GroupBuyItem{
			for each(var item:GroupBuyItem in items){
				if(item.id == id){
					return item;
				}
			}
			return null;
		}
		
		public function flyGift(id:int):void{
			var giftItem:GroupBuyItem = getItemById(id);
			giftItem.flyGift();
		}
		
		public function flyGroupGift(id:int, pcount:int):void{
			var giftItem:GroupBuyItem = getItemById(id);
			giftItem.flyGroupGift(pcount);
		}
		
		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}
	}
}
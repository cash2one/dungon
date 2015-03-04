package com.leyou.ui.vip
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	import flash.events.MouseEvent;
	
	public class VipListRender extends AutoSprite
	{
		private var listener:Function;
		
		private var backBtn:ImgButton;
		
		private var panel:ScrollPane;
		
		private var itemList:Vector.<VipListItemRender>;
		
		public function VipListRender(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipAllRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			panel = getUIbyID("panel") as ScrollPane;
			backBtn = getUIbyID("backBtn") as ImgButton;
			backBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			itemList = new Vector.<VipListItemRender>();
			var vipDic:Object = TableManager.getInstance().getVipDic();
			var count:int;
			for(var key:String in vipDic){
				var vipinfo:TVIPInfo = vipDic[key];
				if(0 == vipinfo.type){
					continue;
				}
				var item:VipListItemRender = new VipListItemRender();
				item.updateVipInfo(vipinfo);
				panel.addToPane(item);
				item.y = count * 32;
				count++;
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			if(null != listener){
				listener.call(this, event);
			}
		}
		
		public function register(onSwitchClick:Function):void{
			listener = onSwitchClick;
		}
	}
}
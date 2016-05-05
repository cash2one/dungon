package com.leyou.ui.vip
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	public class VipListRender extends AutoSprite
	{
		private var panel:ScrollPane;
		
		private var itemList:Vector.<VipListItemRender>;
		
		public function VipListRender(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipAllRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			panel = getUIbyID("panel") as ScrollPane;
			itemList = new Vector.<VipListItemRender>();
			var vipDic:Object = TableManager.getInstance().getVipDic();
			var count:int;
			for(var n:int = 0; n < 100; n++){
				var vipinfo:TVIPInfo = vipDic[n];
				if((null == vipinfo) || (0 == vipinfo.type)){
					continue;
				}
				var item:VipListItemRender = new VipListItemRender();
				item.updateVipInfo(vipinfo);
				panel.addToPane(item);
				item.y = count * 32;
				count++;
			}
		}
	}
}
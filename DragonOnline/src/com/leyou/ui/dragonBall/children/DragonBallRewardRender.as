package com.leyou.ui.dragonBall.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	public class DragonBallRewardRender extends AutoSprite
	{
		private var panel:ScrollPane;
		
		private var items:Vector.<DragonBallRewardItem>;
		
		public function DragonBallRewardRender(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall4Render.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			panel = getUIbyID("rewardPanel") as ScrollPane;
			items = new Vector.<DragonBallRewardItem>();
			var index:int = 0;
			var rewardDic:Object = TableManager.getInstance().getDragonBallRewardDic();
			for(var key:String in rewardDic){
				if("1" != key){
					var info:TDragonBallRewardInfo = rewardDic[key];
					var item:DragonBallRewardItem = new DragonBallRewardItem();
					item.udpateInfo(info);
					items.push(item);
					panel.addToPane(item);
					item.y = 100*index;
					index++;
				}
			}
			panel.updateUI();
		}
		
		public function updateStatus():void{
			for each(var item:DragonBallRewardItem in items){
				item.updateStatus();
			}
		}
		
		public function flyItem():void{
			var rid:int = DataManager.getInstance().dragonBallData.rid;
			for each(var item:DragonBallRewardItem in items){
				if(rid == item.id){
					item.flyItem();
					return;
				}
			}
		}
	}
}
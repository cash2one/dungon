package com.leyou.ui.guildBattle.children
{
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TGuildBattleInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.guildBattle.GuildBattleTrackData;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	
	import flash.display.Sprite;
	
	public class GuildBattleMemRankRender extends Sprite
	{
		private var guildMembers:Vector.<GuildBattleMemItem>;
		
		private var detailItems:Vector.<GuildBattleRankDetailRender>;
		
		private var detailPanl:ScrollPane;
		
		private var scrollPanel:ScrollPane;
		
		private var chItem:GuildBattleMemItem;
		
		public function GuildBattleMemRankRender(){
			init();
		}
		
		private function init():void{
			guildMembers = new Vector.<GuildBattleMemItem>();
			detailItems = new Vector.<GuildBattleRankDetailRender>();
			scrollPanel = new ScrollPane(404, 382);
			addChild(scrollPanel);
			detailPanl = new ScrollPane(1,1);
			addChild(detailPanl);
			initTableInfo();
			
			scrollPanel.x = 4;
			scrollPanel.y = 4;
			detailPanl.x = 4;
		}
		
		private function initTableInfo():void{
			var count:int = 0;
			var rankDic:Object = TableManager.getInstance().getGuileBattleDic();
			for(var key:String in rankDic){
				var info:TGuildBattleInfo = rankDic[key];
				var idArr:Array = key.split("|");
				if((1 == info.type) && (idArr.length > 2)){
					var item:GuildBattleMemItem = allocItem(count);
					scrollPanel.addToPane(item);
					item.y = count * 59;
					item.updateTInfo(info);
					count++;
				}
			}
			scrollPanel.updateUI();
			adjustItemPostion();
		}
		
		private function adjustItemPostion():void{
			guildMembers.sort(sortFun);
			var count:int = guildMembers.length;
			for(var n:int = 0; n < count; n++){
				var item:GuildBattleMemItem = guildMembers[n];
				item.y = n * 59;
			}
			function sortFun(pi:GuildBattleMemItem, ni:GuildBattleMemItem):int{
				if(pi.id >= ni.id){
					return 1;
				}
				return -1;
			}
		}
		
		private function allocItem(index:int):GuildBattleMemItem{
			if(guildMembers.length < index+1){
				guildMembers.length = index +1;
			}
			var item:GuildBattleMemItem = guildMembers[index];
			if(null == item){
				item = new GuildBattleMemItem();
				guildMembers[index] = item;
				item.register(onDetailClick);
			}
			return item;
		}
		
		private function onDetailClick(item:GuildBattleMemItem):void{
			chItem = item;
			var groupId:String = item.groupId;
			var flagArr:Array = groupId.split("|");
			if(flagArr[2] > 0){
				Cmd_GuildBattle.cm_UNZ_L(1, flagArr[1], flagArr[2]);
			}else{
				Cmd_GuildBattle.cm_UNZ_L(1, flagArr[1], flagArr[1]);
			}
		}
		
		public function updateDetailInfo(data:GuildBattleTrackData):void{
			adjustItemPostion();
			var count:int = data.getCount();
			if(count > 0){
				nvlDetail(count);
				for(var n:int = 0; n < count; n++){
					var item:GuildBattleRankDetailRender = detailItems[n];
					item.updateInfo(data.getItemData(n));
				}
				viewDetail(count);
			}else{
				if(scrollPanel.contains(detailPanl)){
					scrollPanel.delFromPane(detailPanl);
				}
			}
		}
		
		private function viewDetail(count:int):void{
			if(!scrollPanel.contains(detailPanl)){
				scrollPanel.addToPane(detailPanl);
			}
			detailPanl.y = chItem.y + 56;
			var length:int = guildMembers.length;
			var index:int = guildMembers.indexOf(chItem);
			for(var n:int = 0; n < length; n++){
				if(n > index){
					guildMembers[n].y = detailPanl.y + count*20 + (n-index-1)*59;
				}else{
					guildMembers[n].y = 59*n;
				}
			}
		}
		
		private function nvlDetail(count:int):void{
			if(count > detailItems.length){
				detailItems.length = count;
			}else if(count < detailItems.length){
				var ll:int = length;
				for(var n:int = count; n < ll; n++){
					var gi:GuildBattleRankDetailRender = detailItems[n];
					if(detailPanl.contains(gi)){
						detailPanl.delFromPane(gi);
					}
				}
			}
			detailPanl.resize(404, 20*count);
			for(var m:int = 0; m < count; m++){
				var item:GuildBattleRankDetailRender = detailItems[m];
				if(null == item){
					item = new GuildBattleRankDetailRender();
					detailItems[m] = item;
				}
				item.y = m*20;
				if(!detailPanl.contains(item)){
					detailPanl.addToPane(item);
				}
			}
			detailPanl.updateUI();
		}
	}
}
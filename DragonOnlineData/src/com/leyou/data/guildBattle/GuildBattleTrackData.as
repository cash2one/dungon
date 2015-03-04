package com.leyou.data.guildBattle
{
	import com.leyou.data.guildBattle.children.GuildBattleTrackItemData;
	
	import flash.utils.getTimer;

	public class GuildBattleTrackData
	{
		private var _type:int;
		
		private var stime:uint;
		
		private var tick:uint;
		
		public var selfData:GuildBattleTrackItemData = new GuildBattleTrackItemData();
		
		private var items:Vector.<GuildBattleTrackItemData> = new Vector.<GuildBattleTrackItemData>();
		
		public function GuildBattleTrackData(){
		}
		
		public function set type(value:int):void{
			_type = value;
		}

		public function get type():int{
			return _type;
		}
		
		public function get remainTime():int{
			return (stime - (getTimer() - tick)/1000)
		}
		
		public function loadSelf(obj:Object):void{
			selfData.updateInfo(obj.ulist.shift());
			selfData.energy = obj.energy;
			selfData.exp = obj.exp;
		}

		public function loadData(obj:Object):void{
			tick = getTimer();
			stime = obj.stime;
			var ulist:Array = obj.ulist;
			var length:int = ulist.length;
			items.length = length;
			for(var n:int = 0; n < length; n++){
				var sdata:Array = ulist[n];
				var item:GuildBattleTrackItemData = items[n];
				if(null == item){
					item = new GuildBattleTrackItemData();
					items[n] = item;
				}
				item.type = _type;
				item.updateInfo(sdata);
			}
		}
		
		public function getCount():int{
			return items.length;
		}
		
		public function getItemData(index:int):GuildBattleTrackItemData{
			if(index >= 0 && index < items.length){
				return items[index];
			}
			return null;
		}
	}
}
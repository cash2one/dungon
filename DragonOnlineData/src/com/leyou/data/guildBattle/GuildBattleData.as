package com.leyou.data.guildBattle
{
	import com.leyou.enum.ConfigEnum;
	

	public class GuildBattleData
	{
		public static const TRACK_MAX_COUNT:int = 10;
		
		public var hasFirst:Boolean;
		
		public var fistGuild:GuildBattleFirstGuildData = new GuildBattleFirstGuildData();
		
		public var ctype:int = 2;
		
		public var trackData:GuildBattleTrackData = new GuildBattleTrackData();
		
		public var rankData:GuildBattleTrackData = new GuildBattleTrackData();
		
		public var resultData:GuildBattleResultData = new GuildBattleResultData();
		
		public var additionRate:Object = {};
		
		public function GuildBattleData(){
			init();
		}
		
		private function init():void{
			var content:String = ConfigEnum.GUbattle9;
			var arr:Array = content.split("|");
			for each(var data:String in arr){
				var dArr:Array = data.split(",");
				additionRate[dArr[0]] = int(dArr[1]);
			}
		}
		
		public function getRankAdd(rank:int):int{
			if(additionRate.hasOwnProperty(rank)){
				return additionRate[rank]
			}
			return 0;
		}
		
		public function loadData_I(obj:Object):void{
			hasFirst = obj.hasOwnProperty("first");
			if(hasFirst){
				var firstData:Array = obj.first;
				fistGuild.loadGuild(firstData);
			}
		}
		
		public function loadData_L(obj:Object):void{
			rankData.type = obj.ltype;
			rankData.loadData(obj);
		}
		
		public function loadData_U(obj:Object):void{
			trackData.type = obj.utype;
			trackData.loadSelf(obj);
			trackData.loadData(obj);
		}
		
		public function loadData_N(obj:Object):void{
			resultData.loadData(obj);
		}
	}
}
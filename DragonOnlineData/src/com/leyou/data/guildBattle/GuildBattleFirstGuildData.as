package com.leyou.data.guildBattle
{
	public class GuildBattleFirstGuildData
	{
		public var guildName:String;
		
		public var palyerName:String;
		
		public var school:int;
		
		public var gender:int;
		
		public var avt:String;
		
		public function GuildBattleFirstGuildData(){
		}
		
		public function loadGuild(firstData:Array):void{
			guildName = firstData[0];
			palyerName = firstData[1];
			school = firstData[2];
			gender = firstData[3];
			avt = firstData[4];
		}
	}
}
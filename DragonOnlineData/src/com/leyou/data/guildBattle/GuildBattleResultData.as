package com.leyou.data.guildBattle
{
	public class GuildBattleResultData
	{
		public var honour:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var memRank:int;
		
		public var guildRank:int;
		
		public var guildMemRank:int;
		
		public function GuildBattleResultData(){
		}
		
		public function loadData(obj:Object):void{
			exp = obj.exp;
			honour = obj.honour;
			energy = obj.energy;
			memRank = obj.u_rank;
			guildRank = obj.un_rank;
			guildMemRank = obj.f_rank;
		}
	}
}
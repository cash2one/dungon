package com.leyou.data.guildBattle.children
{
	public class GuildBattleTrackItemData
	{
		public var type:int;
		
		public var rank:int;
		
		public var name:String;
		
		public var honour:int;
		
		public var kill:int;
		
		public var dead:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public function GuildBattleTrackItemData(){
		}
		
		public function updateInfo(data:Array):void{
			rank = data[0];
			name = data[1];
			honour = data[2];
			kill = data[3];
			dead = data[4];
		}
	}
}
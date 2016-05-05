package com.leyou.data.cityBattle
{
	public class CityBattleCityData
	{
		public var hostData:Array;
		
		public var hasOwner:Boolean;
		
		public var guildName:String;
		
		public var palyerName:String;
		
		public var school:int;
		
		public var gender:int;
		
		public var avt:String;
		
		public var holdDay:int;
		
		public var cess:int;
		
		public var yesterMoney:int;
		
		public var yesterYB:int;
		
		public var hostMoney:int;
		
		public var hostYB:int;
		
		public var announce:String;
		
		public var duname:String;
		
		public var ddate:uint;
		
		public function CityBattleCityData(){
		}
		
		public function unserialize(obj:Object):void{
			hostData = obj.mlist;
			hasOwner = ((null != hostData) && (hostData.length > 0));
			if(hasOwner){
				guildName = hostData[0][0];
				palyerName = hostData[0][1];
				school = hostData[0][2];
				gender = hostData[0][3];
				avt = hostData[0][4];
			}
//			hostData = obj.cz.concat();
			holdDay = obj.zday;
			cess = obj.cess;
			yesterMoney = obj.ymoney;
			yesterYB = obj.yyb;
			hostMoney = obj.ysmoney;
			hostYB = obj.ysyb;
			announce = obj.notice || "";
			duname = obj.duname || "";
			ddate = obj.ddate;
		}
		
		public function hasChallenge():Boolean{
			return (null != duname) && ("" != duname);
		}
	}
}
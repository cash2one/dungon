package com.ace.gameData.table
{
	public class TDragonBallPropertyInfo
	{
		public var id:int;
		
		public var upper:int;
		
		public var preCost:int;
		
		public var propertyType:int;
		
		public var pic:String;
		
		public function TDragonBallPropertyInfo(xml:XML){
			id = xml.@Lh_AttID;
			upper = xml.@Lh_Upper;
			preCost = xml.@Lh_Cost;
			propertyType = xml.@Lh_Class;
			pic = xml.@Att_Pic;
		}
	}
}
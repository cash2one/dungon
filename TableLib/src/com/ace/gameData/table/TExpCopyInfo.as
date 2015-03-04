package com.ace.gameData.table
{
	

	public class TExpCopyInfo
	{
		public var id:int;
		
		public var name:String;
		
		public var preview:String;
		
		public var sceneId:int;
		
		public var sceneWidth:int;
		
		public var sceneHeight:int;
		
		public var moneyCost:int;
		
		public var reviveTime:int;
		
		public var points:Vector.<int>;
		
		public function TExpCopyInfo(xml:XML=null){
			if(null == xml){
				return;
			}
			id = xml.@Id;
			name = xml.@name;
			sceneId = xml.@sceneId;
			sceneWidth = xml.@sceneX;
			sceneHeight = xml.@sceneY;
			moneyCost = xml.@moneyMin;
			reviveTime = xml.@reviveTime;
			preview =xml.@scenePic;
			points = new Vector.<int>();
			points.push(xml.@point45);
			points.push(xml.@point55);
			points.push(xml.@point65);
			points.push(xml.@point75);
			points.push(xml.@point85);
			points.push(xml.@point95);
		}
	}
}
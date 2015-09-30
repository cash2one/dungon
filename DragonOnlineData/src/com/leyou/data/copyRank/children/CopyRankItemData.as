package com.leyou.data.copyRank.children
{
	public class CopyRankItemData
	{
		public var id:int;
		
		public var name:String;
		
		public var vocation:int;
		
		public var gender:int;
		
		public var time:Number;
		
		public var date:String;
		
		public function CopyRankItemData(){
		}
		
		public function loadData(data:Array):void{
			id = data[0];
			name = data[1];
			vocation = data[2];
			gender = data[3];
			time = data[4];
			date = data[5];
		}
	}
}
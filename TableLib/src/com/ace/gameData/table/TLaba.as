package com.ace.gameData.table
{
	public class TLaba
	{
		 
		public var id:int;
		public var itemId:int;
		public var itemNum:int;
		public var rate:int;
		public var image:String;
		
		public function TLaba(data:XML=null) {
			if (data == null)
				return;
			
			this.id=data.@id;
			this.itemId=data.@itemId;
			this.itemNum=data.@itemNum;
			this.rate=data.@rate;
			this.image=data.@image;
			
		}
		
	}
}
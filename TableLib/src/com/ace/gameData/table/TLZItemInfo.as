package com.ace.gameData.table
{
	public class TLZItemInfo
	{
		public var lzLevel:int;
		
		public var iconsArr:Vector.<int> = new Vector.<int>();
		
		public function TLZItemInfo(info:XML){
			lzLevel = info.@Ma_ID;
			for(var n:int = 0; n < 10; n++){
				var key:String = "Ma_Re"+(n+1);
				var itemId:int = info.attribute(key);
				if(itemId > 0){
					iconsArr.push(itemId);
				}
			}
		}
	}
}
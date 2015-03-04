package com.leyou.data.copy
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;

	public class CopyData
	{
		public var id:int;
		
		public var status:int;
		
		public var convenience:Boolean;
		
		public var pastLvel:int;
		
		public var copyTable:TCopyInfo;
		
		public function init():void{
			copyTable = TableManager.getInstance().getCopyInfo(id);
		}
	}
}
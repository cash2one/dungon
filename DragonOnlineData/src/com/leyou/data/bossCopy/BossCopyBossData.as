package com.leyou.data.bossCopy
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;

	public class BossCopyBossData
	{
		public var id:int;
		
		public var status:int;
		
		
		public var isFirst:Boolean;
		public function BossCopyBossData(){
		}
		
		public function unserialize(obj:Object):void{
			id = obj.cid;
			status = obj.s;
			isFirst = obj.f;
		}
		
		public function get copyInfo():TCopyInfo{
			return TableManager.getInstance().getCopyInfo(id);
		}
	}
}
package com.leyou.data.missinMarket
{
	import flash.utils.getTimer;

	public class MissionMarketData
	{
		private var missionChapter:Vector.<MissionMarketChapterData> = new Vector.<MissionMarketChapterData>();
		
		private var missionTask:Vector.<MissionMarketTaskData> = new Vector.<MissionMarketTaskData>();
		
		private var refreshTime:int;
		
		private var tick:uint;
		
		public function MissionMarketData(){
		}
		
		public function get remainTime():int{
			return (refreshTime - (getTimer() - tick)/1000);
		}
		
		public function loadData_I(obj:Object):void{
			tick = getTimer();
			refreshTime = obj.stime;
			var yinfo:Array = obj.yinfo;
			var length:int = yinfo.length;
			missionChapter.length = length;
			for(var n:int = 0; n < length; n++){
				var odata:Array = yinfo[n];
				var data:MissionMarketChapterData = new MissionMarketChapterData();
				data.type = n+1;
				data.unserialize(odata);
				missionChapter[n] = data;
			}
		}
		
		public function loadData_L(obj:Object):void{
			var tlist:Array = obj.tlist;
			var length:int = tlist.length;
			missionTask.length = length;
			for(var n:int = 0; n < length; n++){
				var odata:Array = tlist[n];
				var data:MissionMarketTaskData = new MissionMarketTaskData();
				data.unserialize(odata);
				missionTask[n] = data;
			}
		}
		
		public function getChapterLength():int{
			return missionChapter.length;
		}
		
		public function getMissionLength():int{
			return missionTask.length;
		}
		
		public function getChapterData(index:int):MissionMarketChapterData{
			if(index < missionChapter.length){
				return missionChapter[index];
			}
			return null;
		}
		
		public function getMissionData(index:int):MissionMarketTaskData{
			if(index < missionTask.length){
				return missionTask[index];
			}
			return null;
		}
		
		public function loadData_J(obj:Object):void{
		}
		
		public function loadData_T(obj:Object):void{
		}
	}
}
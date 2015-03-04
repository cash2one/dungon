package com.leyou.data.achievement
{
	public class AchieveRoleData
	{
		public var serverId:String;
		
		public var name:String;
		
		public var pro:int;
		
		public var sex:int;
		
		public var finishArr:Array;
		
		public function dispose():void{
			name = null;
			finishArr = null;
		}
		
		public function get finishCount():int{
			return finishArr.length;
		}
		
		public function unserialize(data:Object):void{
			name = data.pn;
			pro = data.pro;
			sex = data.sex;
			finishArr = data.fl.concat();
		}
	}
}
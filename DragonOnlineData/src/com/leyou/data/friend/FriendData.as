package com.leyou.data.friend
{
	public class FriendData
	{
		private var blackList:Vector.<String> = new Vector.<String>();

		public function FriendData(){
		}
		
		public function testInBlack(name:String):Boolean{
			return (-1 != blackList.indexOf(name));
		}
		
		public function loadData_I(obj:Object):void{
			var relation:int = obj.relation;
			var list:Array = obj.list;
			blackList.length = 0;
			for each(var obj:Object in list){
				blackList.push(obj[0]);
			}
		}
	}
}
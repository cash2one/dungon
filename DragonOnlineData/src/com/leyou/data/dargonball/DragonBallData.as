package com.leyou.data.dargonball
{
	public class DragonBallData
	{
		public var status:int;
		
		private var items:Array;
		
		public var remainC:int;
		
		private var copyList:Array;
		
		public function DragonBallData(){
		}
		
		public function loadData_I(obj:Object):void{
			status = obj.st;
			items = obj.dlist.concat();
		}
		
		public function collectComplete():Boolean{
			if(0 == status){
				for each(var arr:Array in items){
					if(int(arr[1]) <= 0){
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		public function getItemLength():int{
			return items.length;
		}
		
		public function getItemID(index:int):int{
			return items[index][0];
		}
		
		public function getItemNum(index:int):int{
			return items[index][1];
		}
		
		public function loadData_C(obj:Object):void{
			remainC = obj.ec;
			copyList = obj.cl.concat();
		}
		
		public function getCopyLength():int{
			return copyList.length;
		}
		
		public function getCopyID(index:int):int{
			return copyList[index];
		}
	}
}
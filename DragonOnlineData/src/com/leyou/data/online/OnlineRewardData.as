package com.leyou.data.online
{
	import flash.utils.getTimer;

	public class OnlineRewardData
	{
		private var tick:uint;
		
		private var remain:int;
		
		public var byb:int;
		
		public var money:int;
		
		public var items:Array;
		
		public function OnlineRewardData(){
		}
		
		public function loadData_I(obj:Object):void{
			tick = getTimer();
			remain = obj.stime;
			byb = obj.jl.byb;
			money = obj.jl.money;
			items = obj.jl.items.concat();
		}
		
		public function remianT():int{
			var interval:int = (getTimer() - tick)/1000;
			return (remain - interval)
		}
	}
}
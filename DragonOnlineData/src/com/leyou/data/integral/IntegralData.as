package com.leyou.data.integral
{
	public class IntegralData
	{
		public var act:Boolean;
		
		public var beginT:uint;
		
		public var endT:uint;
		
		public var integral:int;
		
		public var itemId:int;
		
		public function IntegralData(){
		}
		
		public function loadDat_I(obj:Object):void{
			act = (1 == obj.act);
			beginT = obj.stime;
			endT = obj.etime;
			integral = obj.cjf;
		}
	}
}
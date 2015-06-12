package com.ace.gameData.table {

	public class TKeep_7 {

		/**
		 *	累计登陆天数index
		 */
		public var Keep_day:int;

		/**
		 *	奖励经验
		 */
		public var exp:int;

		/**
		 *	奖励魂力
		 */
		public var energy:int;

		/**
		 *	奖励金钱
		 */
		public var money:int;

		/**
		 *	奖励行会贡献
		 */
		public var bg:int;

		/**
		 *	奖励荣誉
		 */
		public var Honor:int;

		/**
		 *	奖励绑钻
		 */
		public var Byb:int;

		/**
		 *	奖励道具1
		 */
		public var item1:int;

		/**
		 *	道具数量1
		 */
		public var num1:int;

		/**
		 *	奖励道具2
		 */
		public var item2:int;

		/**
		 *	道具数量2
		 */
		public var num2:int;

		/**
		 *	奖励道具3
		 */
		public var item3:int;

		/**
		 *	道具数量3
		 */
		public var num3:int;

		/**
		 *	奖励道具4
		 */
		public var item4:int;

		/**
		 *	道具数量4
		 */
		public var num4:int;

		/**
		 *	奖励道具5
		 */
		public var item5:int;

		/**
		 *	道具数量5
		 */
		public var num5:int;



		public function TKeep_7(data:XML=null) {
			if (data == null)
				return;

			this.Keep_day=data.@Keep_day;
			this.exp=data.@exp;
			this.energy=data.@energy;
			this.money=data.@money;
			this.bg=data.@bg;
			this.Honor=data.@Honor;
			this.Byb=data.@Byb;
			this.item1=data.@item1;
			this.num1=data.@num1;
			this.item2=data.@item2;
			this.num2=data.@num2;
			this.item3=data.@item3;
			this.num3=data.@num3;
			this.item4=data.@item4;
			this.num4=data.@num4;
			this.item5=data.@item5;
			this.num5=data.@num5;


		}

		public function getNotEmptyField():Array {

			var arr1:Array=["exp","energy","money","bg","Honor","Byb","item1","item2","item3","item4","item5"];
			var arr:Array=[];
			var str:String;

			for each(str in arr1) {
				if (int(this[str]) > 0)
					arr.push(str);
			}

			return arr;
		}


	}
}

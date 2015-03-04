package com.ace.gameData.table {

	public class TDailytask {

		/**
		*	ID
		*/
		public var id:String;

		/**
		*	等级下限
		*/
		public var lv_min:String;

		/**
		*	全部完成奖励
		*	经验
		*/
		public var exp:String;

		/**
		*	全部完成奖励
		*	魂力
		*/
		public var energy:String;

		/**
		*	全部完成奖励
		*	游戏币
		*/
		public var money:String;

		/**
		*	全部完成奖励
		*	帮贡
		*/
		public var bg:String;

		/**
		 *	绑定钻石
		 */
		public var Bd_Yb:String;

		/**
		*	帮派活跃度
		*/
		public var liveness:String;

		/**
		*	全部完成道具奖励1ID
		*/
		public var item1:String;

		/**
		*	道具名称1
		*	（备注）
		*/
		public var name1:String;

		/**
		*	数量
		*/
		public var num1:String;

		/**
		*	全部完成道具奖励2ID
		*/
		public var item2:String;

		/**
		*	道具名称2
		*	（备注）
		*/
		public var name2:String;

		/**
		*	数量
		*/
		public var num2:String;

		/**
		*	全部完成道具奖励3ID
		*/
		public var item3:String;

		/**
		*	道具名称3
		*	（备注）
		*/
		public var name3:String;

		/**
		*	数量
		*/
		public var num3:String;

		/**
		*	全部完成道具奖励4ID
		*/
		public var item4:String;

		/**
		*	道具名称4
		*	（备注）
		*/
		public var name4:String;

		/**
		*	数量
		*/
		public var num4:String;



		public function TDailytask(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.lv_min=data.@lv_min;
			this.exp=data.@exp;
			this.energy=data.@energy;
			this.money=data.@money;
			this.bg=data.@bg;
			this.Bd_Yb=data.@Bd_Yb;
			this.liveness=data.@liveness;
			this.item1=data.@item1;
			this.name1=data.@name1;
			this.num1=data.@num1;
			this.item2=data.@item2;
			this.name2=data.@name2;
			this.num2=data.@num2;
			this.item3=data.@item3;
			this.name3=data.@name3;
			this.num3=data.@num3;
			this.item4=data.@item4;
			this.name4=data.@name4;
			this.num4=data.@num4;


		}



	}
}

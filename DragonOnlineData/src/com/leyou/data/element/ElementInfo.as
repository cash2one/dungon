package com.leyou.data.element {



	public class ElementInfo {


		/**
		 *摇杆次数
		 */
		public var count:int; //
		/**
		 *免费次数
		 */
		public var freeCount:int; //
		/**
		 *能锁定的个数
		 */
		public var lockNum:int; //
		/**
		 *摇动拉杆需要的道具id
		 */
		public var cItemId:int; //
		/**
		 * 摇动拉杆需要的绑定道具id
		 */
		public var bItemId:int;
		public var lNum:int; //消耗道具的基础个数
		/**
		 * 锁定个数对应的消耗个数倍率（locknum --锁定的个数, beis -- 消耗的倍率） 实际需要消耗是 lnum * beis
		 */
		public var lb:Object; //
		/**
		 *摇杆后的顺序
		 */
		public var result:Array=[]; //

		public var elements:Vector.<Elements>=new Vector.<Elements>();
		/**
		 *守护元素的id
		 */
		public var guildIdx:int; //
		/**
		 *切换守护元素花费的道具 的id
		 */
		public var guildCostItemId:int;
		/**
		 *花费道具的数量
		 */
		public var guildCostItemCost:int;
		/**
		 *是否是播完特效后的结果
		 */
		public var effect:Boolean; //
		/**
		 *单次获得的经验
		 */
		public var preExp:Array=[];

		public function ElementInfo() {

		}

		public function clone():ElementInfo {

			var info:ElementInfo=new ElementInfo();

			info.count=this.count;

			info.freeCount=freeCount;
			info.lockNum=lockNum;
			info.cItemId=cItemId;
			info.bItemId=bItemId;
			info.lNum=lNum
			info.lb={};

			var str:String;
			for (str in this.lb) {
				info.lb[str]=this.lb[str];
			}

			info.result=this.result;

			for (str in this.elements) {
				info.elements[str]=this.elements[str].clone();
			}

			info.guildIdx=this.guildIdx;
			info.guildCostItemId=this.guildCostItemId;
			info.guildCostItemCost=this.guildCostItemCost;
			info.effect=this.effect;
			info.preExp=this.preExp;

			
			

			return info;
		}

	}
}

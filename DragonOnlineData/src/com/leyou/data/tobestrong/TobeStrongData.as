package com.leyou.data.tobestrong
{
	public class TobeStrongData
	{
		//		qz -- 装备战斗力
		//		rz -- 坐骑战斗力
		//		gz -- 帮会技能战斗力
		//		bz -- 纹章战斗力
		//		sz -- 精灵战斗力
		//		wz -- 翅膀战斗力
		//		gemz -- 宝石战斗力
		//		tz -- 总战斗力
		//			
		//		rt -- 坐骑等级(0-10)
		//		gt -- 0.未加入行会         1.已加入行会
		//		bt -- 0.纹章节点未全部开启  1.节点已全部开启
		//		vt -- VIP等级(0-10)
		//		wt -- 翅膀等级(0-10)
		//		
		//		qsc -- 可强化装备数量
		//		qrc -- 可重铸装备数量
		//		qzc -- 紫装数量
		//		qjc -- 金装数量
		//      guc -- 行会数量
		
		public var qz:int;
		public var rz:int;
		public var gz:int;
		public var bz:int;
		public var sz:int;
		public var wz:int;
		public var gemz:int;
		public var tz:int;
		
		public var rt:int;
		public var gt:int;
		public var bt:int;
		public var vt:int;
		public var wt:int;
		
		public var qsc:int;
		public var qrc:int;
		public var qzc:int;
		public var qjc:int;
		public var guc:int;
		
		public function TobeStrongData(){
		}
		
		public function loadData_I(obj:Object):void{
			qz = obj.qz;
			rz = obj.rz;
			tz = obj.tz;
			gz = obj.gz;
			bz = obj.bz;
			sz = obj.sz;
			wz = obj.wz;
			tz = obj.tz;
			gemz = obj.gem;
			
			rt = obj.rt;
			gt = obj.gt;
			bt = obj.bt;
			vt = obj.vt;
			wt = obj.wt;
			
			qsc = obj.qsc;
			qrc = obj.qrc;
			qzc = obj.qzc;
			qjc = obj.qjc;
			guc = obj.guc;
		}
	}
}
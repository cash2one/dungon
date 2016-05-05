package com.ace.gameData.table {

	public class TMissionDate {

		/**
		 *	任务ID号
		 *	数字，建议从小到大排列,同时也以从低至高为依据，在任务表中从低至高排列
		 *	id
		 */
		public var id:int;

		/**
		 *	任务名称
		 *	任务名称
		 *	（类型·名称）
		 *	name
		 */
		public var name:String;

		/**
		 *	任务分类标签
		 *	一般按地区分类
		 *	tag
		 */
		public var tag:String;

		/**
		 *	任务类型ID
		 *	1.主线
		 *	2.日常
		 *	3.活动
		 *	4.引导
		 *	5.节日
		 *	6.帮派
		 *	7.佣兵经验
		 *	8佣兵亲密
		 *	type
		 */
		public var type:int;

		/**
		 *	接任务NPCID
		 *
		 *	anpc
		 */
		public var anpc:String;

		/**
		 *	接任务NPC名称
		 *	注释用
		 *	anpcname
		 */
		public var anpcname:String;

		/**
		 *	交任务NPCID
		 *
		 *	dnpc
		 */
		public var dnpc:int;

		/**
		 *	交任务NPC名称
		 *	注释用
		 *	dnpcname
		 */
		public var dnpcname:String;

		/**
		 *	开启对话
		 *
		 *	anpcText
		 */
		public var anpcText:String;

		/**
		 *	完成对话
		 *
		 *	dnpcText
		 */
		public var dnpcText:String;

		/**
		 *	任务日志描述
		 *
		 *	describ
		 */
		public var describ:String;

		/**
		 *	下个任务ID
		 *
		 *	nextid
		 */
		public var nextid:String;

		/**
		 *	任务方式
		 *	1.npc对话
		 *	2.杀怪
		 *	3.杀怪掉落
		 *	4.采集
		 *	5.送信
		 *	6.物品集换
		 *	7.达到等级
		 *	8.其他（需要调用脚本，特例任务类型）
		 *	9.完成指定数量的日常任务
		 *	10.参与指定次数的竞技场
		 *	11.开启指定数量的纹章节点
		 *	12.坐骑进阶到指定等阶
		 *	13.接受任务后通关指定剧情副本
		 *	14.提升任意装备强化等级数
		 *	15.进行指定次数的元素经验抽取
		 *	dtype
		 */
		public var dtype:int;

		/**
		 *	npcID
		 *	对话npcid/送信npcid/任务完成NPC
		 *	npc_id
		 */
		public var npc_id:String;

		/**
		 *	npc名称
		 *	注释
		 *	npc_name
		 */
		public var npc_name:String;

		/**
		 *	npc对话内容
		 *	对话类型任务的对话内容
		 *	npc_say
		 */
		public var npc_say:String;

		/**
		 *	击败怪物ID
		 *	需击败该ID的NPC才算完成任务
		 *	monster_id
		 */
		public var monster_id:String;

		/**
		 *	怪物名称
		 *	注释
		 *	monster_name
		 */
		public var monster_name:String;

		/**
		 *	怪物数量
		 *	需击败的怪物数量
		 *	monster_num
		 */
		public var monster_num:String;

		/**
		 *	物品ID
		 *	需要获得并上交该ID的物品才能完成任务
		 *	item_id
		 */
		public var item_id:String;

		/**
		 *	物品名称
		 *	注释
		 *	item_name
		 */
		public var item_name:String;

		/**
		 *	物品数量
		 *	获得并上交的物品数量
		 *	item_number
		 */
		public var item_number:String;

		/**
		 *	掉率
		 *	掉落物品的概率
		 *	drop
		 */
		public var drop:String;

		/**
		 *	宝箱ID
		 *	需要开启该ID的宝箱才能完成任务
		 *	box_id
		 */
		public var box_id:String;

		/**
		 *	宝箱名称
		 *	注释
		 *	box_name
		 */
		public var box_name:String;

		/**
		 *	宝箱数量
		 *	需要开启宝箱的数量
		 *	box_num
		 */
		public var box_num:String;

		/**
		 *	等级下限
		 *	人物达到等级可完成任务
		 *	minlevel
		 */
		public var minlevel:String;

		/**
		 *	开启等级下限
		 *	可接取该任务的最低等级
		 *	（日常任务）
		 *	lv_min
		 */
		public var lv_min:String;

		/**
		 *	任务附加脚本ID
		 *	脚本ID
		 *	script
		 */
		public var script:String;

		/**
		 *	目标坐标点
		 *	用于非NPC任务寻路和付费快速传送功能，读取point表
		 *	target_point
		 */
		public var target_point:int;

		/**
		 *	任务传送开启条件
		 *	用于判断任务传送的时间
		 *	1接受
		 *	2交付
		 *	3目标达成
		 *	不填不传送
		 *	travel_pid
		 */
		public var travel_pid:String;

		/**
		 *	任务传送目标点
		 *	任务传送功能目标点，读取point表
		 *	不填不传送
		 *	travel_point
		 */
		public var travel_point:String;

		/**
		 *	完成指定数量的日常任务
		 *
		 */
		public var N_OBJ_Num:String;

		/**
		 *	参与指定次数的竞技场
		 *
		 */
		public var NJJC_Num:String;

		/**
		 *	开启指定数量的纹章节点
		 *
		 */
		public var Y_Blood_Num:String;

		/**
		 *	坐骑进阶到指定等阶
		 *
		 */
		public var Y_Mount_lv:String;

		/**
		 *	通关指定剧情副本
		 *
		 */
		public var Y_Dungeon_ID:String;

		/**
		 *	提升任意装备强化等级数
		 *
		 */
		public var Y_ST_lv:String;

		/**
		 *	进行指定次数的元素升级
		 *
		 */
		public var Y_Ele_Time:String;

		/**
		 *	获得指定ID的佣兵
		 *	NEW
		 */
		public var Y_Servent_Num:String;
		
		/**
		 *	通用引导字段
		 *	NEW
		 */
		public var Y_Currency:String;
		
		/**
		 *	奖励经验
		 *
		 *	exp
		 */
		public var exp:int;

		/**
		 *	奖励真气
		 *
		 *	energy
		 */
		public var energy:int;

		/**
		 *	奖励游戏币
		 *
		 *	money
		 */
		public var money:int;

		/**
		 *	奖励帮贡
		 *
		 *	bg
		 */
		public var bg:int;

		/**
		 *	物品奖励1ID
		 *	分隔符|区分
		 *
		 *	按职业奖励区分顺序：
		 *	战士|法师|术士|游侠
		 *	item1
		 */
		public var item1:String;

		/**
		 *	奖励数1
		 *
		 *	num1
		 */
		public var num1:String;

		/**
		 *	物品奖励2ID
		 *	分隔符区分
		 *	item2
		 */
		public var item2:String;

		/**
		 *	奖励数2
		 *
		 *	num2
		 */
		public var num2:String;

		/**
		 *	物品奖励3ID
		 *	分隔符区分
		 *	item3
		 */
		public var item3:String;

		/**
		 *	奖励数3
		 *
		 *	num3
		 */
		public var num3:String;

		/**
		 *	物品奖励4
		 *	分隔符区分
		 *	item4
		 */
		public var item4:String;

		/**
		 *	奖励数4
		 *
		 *	num4
		 */
		public var num4:String;

		/**
		 *	佣兵经验
		 *
		 *	P_Exp
		 */
		public var P_Exp:String;

		/**
		 *	佣兵亲密
		 *
		 *	P_Love
		 */
		public var P_Love:String;

		/**
		 *	圣器族ID
		 *	按照分隔符读取神器表，第一个数据读为战士职业圣器，之后依次为法师、术士、游侠
		 *	Hallows_TeamID
		 */
		public var Hallows_TeamID:int;

		/**
		 *	触发场景特效id
		 *	触发场景特效
		 *	ef_id
		 */
		public var ef_id:int;



		public function TMissionDate(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.name=data.@name;
			this.tag=data.@tag;
			this.type=data.@type;
			this.anpc=data.@anpc;
			this.anpcname=data.@anpcname;
			this.dnpc=data.@dnpc;
			this.dnpcname=data.@dnpcname;
			this.anpcText=data.@anpcText;
			this.dnpcText=data.@dnpcText;
			this.describ=data.@describ;
			this.nextid=data.@nextid;
			this.dtype=data.@dtype;
			this.npc_id=data.@npc_id;
			this.npc_name=data.@npc_name;
			this.npc_say=data.@npc_say;
			this.monster_id=data.@monster_id;
			this.monster_name=data.@monster_name;
			this.monster_num=data.@monster_num;
			this.item_id=data.@item_id;
			this.item_name=data.@item_name;
			this.item_number=data.@item_number;
			this.drop=data.@drop;
			this.box_id=data.@box_id;
			this.box_name=data.@box_name;
			this.box_num=data.@box_num;
			this.minlevel=data.@minlevel;
			this.lv_min=data.@lv_min;
			this.script=data.@script;
			this.target_point=data.@target_point;
			this.travel_pid=data.@travel_pid;
			this.travel_point=data.@travel_point;
			this.N_OBJ_Num=data.@N_OBJ_Num;
			this.NJJC_Num=data.@NJJC_Num;
			this.Y_Blood_Num=data.@Y_Blood_Num;
			this.Y_Mount_lv=data.@Y_Mount_lv;
			this.Y_Dungeon_ID=data.@Y_Dungeon_ID;
			this.Y_ST_lv=data.@Y_ST_lv;
			this.Y_Ele_Time=data.@Y_Ele_Time;
			this.Y_Servent_Num=data.@Y_Servent_Num;
			this.Y_Currency=data.@Y_Currency;
			this.exp=data.@exp;
			this.energy=data.@energy;
			this.money=data.@money;
			this.bg=data.@bg;
			this.item1=data.@item1;
			this.num1=data.@num1;
			this.item2=data.@item2;
			this.num2=data.@num2;
			this.item3=data.@item3;
			this.num3=data.@num3;
			this.item4=data.@item4;
			this.num4=data.@num4;
			this.P_Exp=data.@P_Exp;
			this.P_Love=data.@P_Love;
			this.Hallows_TeamID=data.@Hallows_TeamID;
			this.ef_id=data.@ef_id;


		}



	}
}

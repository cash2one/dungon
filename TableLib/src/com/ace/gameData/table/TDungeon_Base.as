package com.ace.gameData.table
{

	public class TDungeon_Base
	{
		
		/**
		 *	副本ID
		 *	1~50剧情副本
		 */
		public var Dungeon_ID:int;
		
		/**
		 *	副本地图ID
		 */
		public var Dungeon_Scene:int;
		
		/**
		 *	副本类型
		 *
		 *	1,剧情副本
		 *	2,BOSS挑战副本
		 *	3,单人练级副本
		 *	4,个人竞技场
		 *	5,争霸战副本
		 *	6,帮派参与副本
		 *	7,组队副本
		 *	8,挑战副本
		 *	9，答题副本
		 */
		public var Dungeon_Type:int;
		
		/**
		 *	副本名称
		 *
		 *	(策划标识)
		 */
		public var Dungeon_Name:String;
		
		/**
		 *	副本描述
		 */
		public var Dungeon_Des:String;
		
		/**
		 *	剧情副本组
		 *
		 *	相同组的副本即为同一副本的不同难度的版本
		 */
		public var Dungeon_Group:int;
		
		/**
		 *	人数模式
		 *
		 *	1,单人副本
		 *	2,队伍副本
		 *	3,开放副本
		 */
		public var Dungeon_Pattern:int;
		
		/**
		 *	解锁所需等级
		 *
		 *	如是行会副本，则填写行会等级
		 */
		public var Key_Level:int;
		
		/**
		 *	解锁所需任务
		 *
		 *	填写任务ID，完成该任务才可开启该副本
		 *
		 *	不填则表示无需任务就可开启
		 */
		public var Key_Mission:int;
		
		/**
		 *	解锁所需副本
		 *
		 *	填写副本ID，通关该ID的副本后才能开启该副本
		 *
		 *	不填则表示不需要
		 */
		public var Key_Dungeon:int;
		
		/**
		 *	开启日期
		 *
		 *	1-7，填写星期数，表示在星期几开启；
		 *
		 *	不填则表示每天都开启
		 *
		 *	可填多个数字，如1|2|3 表示周一周二周三开启
		 */
		public var Key_Week:String;
		
		/**
		 *	开启时间
		 *
		 *	-1,不限制开启时间；
		 *	0-23.5,直接填写该范围内的时间设置副本开启时间，如添1则表示1点开启，添1.5则表示1点半开启
		 */
		public var Key_Hour:String;
		
		/**
		 *	PK模式
		 *
		 *	-1或不填，不做限制；
		 *	1，强制全体攻击模式
		 *	2，强制组队PK模式
		 *	3，强制帮派模式
		 *	4，强制阵营模式
		 *	5，强制行会模式
		 *	6，强制和平模式
		 */
		public var Ruler_PK:int;
		
		/**
		 *	通关怪物
		 *
		 *	击杀该一定数量怪物后则算作通关副本，怪物ID和数量用,分隔
		 *
		 *	多个怪物用|分隔
		 *
		 *	如不填则表示需击杀全部怪物
		 */
		public var Hinge_Monster:int;
		
		/**
		 *	首通奖励经验1
		 */
		public var First_Exp:int;
		
		/**
		 *	首通奖励魂力2
		 */
		public var First_energy:int;
		
		/**
		 *	首通奖励金钱3
		 */
		public var First_Money:int;
		
		/**
		 *	首通奖励道具1
		 */
		public var First_Item1:int;
		
		/**
		 *	道具数量1
		 */
		public var Fitem_Num1:int;
		
		/**
		 *	首通奖励道具2
		 */
		public var First_Item2:int;
		
		/**
		 *	道具数量2
		 */
		public var Fitem_Num2:int;
		
		/**
		 *	普通奖励经验
		 */
		public var M_Exp:int;
		
		/**
		 *	普通奖励魂力
		 */
		public var M_Energy:int;
		
		/**
		 *	普通奖励金钱
		 */
		public var M_Money:int;
		
		/**
		 *	普通奖励帮贡
		 */
		public var M_Guild:int;
		
		/**
		 *	普通奖励道具1
		 */
		public var M_Item1:int;
		
		/**
		 *	普通道具数量1
		 */
		public var MI_Num1:int;
		
		/**
		 *	首通奖励道具2
		 */
		public var M_Item2:int;
		
		/**
		 *	普通道具数量2
		 */
		public var MI_Num2:int;
		
		/**
		 *	抽奖引用dropPack表ID
		 */
		public var DropPack:int;
		
		/**
		 *	通关时间D
		 */
		public var TimeD:int;
		
		/**
		 *	通关时间C
		 */
		public var TimeC:int;
		
		/**
		 *	通关时间B
		 */
		public var TimeB:int;
		
		/**
		 *	通关时间A
		 */
		public var TimeA:int;
		
		/**
		 *	通关时间S
		 */
		public var TimeS:int;
		
		/**
		 *	副本图片
		 *
		 *	用于显示剧情&BOSS副本的标题图片
		 */
		public var DB_Pic:String;
		
		/**
		 *	怪物模型
		 */
		public var DB_Monster:String;
		
		/**
		 *	怪物技能1
		 *
		 *	用于在副本界面显示怪物技能的图片资源
		 */
		public var DB_MJ1:String;
		
		/**
		 *	技能TIPS1
		 *
		 *	用于在副本界面显示怪物技能的TIPS
		 */
		public var DB_TIPS1:String;
		
		/**
		 *	怪物技能2
		 */
		public var DB_MJ2:String;
		
		/**
		 *	技能TIPS2
		 */
		public var DB_TIPS2:String;
		
		/**
		 *	怪物技能3
		 */
		public var DB_MJ3:String;
		
		/**
		 *	技能TIPS3
		 */
		public var DB_TIPS3:String;
		
		/**
		 *	怪物技能4
		 */
		public var DB_MJ4:String;
		
		/**
		 *	技能TIPS4
		 */
		public var DB_TIPS4:String;
		
		/**
		 *	副本推荐战斗力
		 *
		 *	用于在副本界面上的战斗力需求显示
		 */
		public var DBN_FC:int;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 */
		public var DBC_ITEM1:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 */
		public var DBC_ITEM2:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 */
		public var DBC_ITEM3:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 *
		 *	宝箱挖掘显示1
		 */
		public var DBC_ITEM4:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 *
		 *	宝箱挖掘显示2
		 */
		public var DBC_ITEM5:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 *
		 *	宝箱挖掘显示3
		 */
		public var DBC_ITEM6:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 */
		public var DBC_ITEM7:String;
		
		/**
		 *	副本奖励
		 *	显示专用
		 *	索引道具表
		 */
		public var DBC_ITEM8:String;
		
		/**
		 *	掉落奖励显示
		 *
		 *	显示专用
		 *	索引道具表
		 *	可最多填写4个
		 */
		public var Base_Drop:String;
		
		/**
		 */
		public var Boss_Drop:String;
		
		
		public var D_Floor:int;

		
		public function TDungeon_Base(data:XML=null)
		{
			if(data==null) return ;
			
			this.Dungeon_ID=data.@Dungeon_ID;
			this.Dungeon_Scene=data.@Dungeon_Scene;
			this.Dungeon_Type=data.@Dungeon_Type;
			this.Dungeon_Name=data.@Dungeon_Name;
			this.Dungeon_Des=data.@Dungeon_Des;
			this.Dungeon_Group=data.@Dungeon_Group;
			this.Dungeon_Pattern=data.@Dungeon_Pattern;
			this.Key_Level=data.@Key_Level;
			this.Key_Mission=data.@Key_Mission;
			this.Key_Dungeon=data.@Key_Dungeon;
			this.Key_Week=data.@Key_Week;
			this.Key_Hour=data.@Key_Hour;
			this.Ruler_PK=data.@Ruler_PK;
			this.Hinge_Monster=data.@Hinge_Monster;
			this.First_Exp=data.@First_Exp;
			this.First_energy=data.@First_energy;
			this.First_Money=data.@First_Money;
			this.First_Item1=data.@First_Item1;
			this.Fitem_Num1=data.@Fitem_Num1;
			this.First_Item2=data.@First_Item2;
			this.Fitem_Num2=data.@Fitem_Num2;
			this.M_Exp=data.@M_Exp;
			this.M_Energy=data.@M_Energy;
			this.M_Money=data.@M_Money;
			this.M_Guild=data.@M_Guild;
			this.M_Item1=data.@M_Item1;
			this.MI_Num1=data.@MI_Num1;
			this.M_Item2=data.@M_Item2;
			this.MI_Num2=data.@MI_Num2;
			this.DropPack=data.@DropPack;
			this.TimeD=data.@TimeD;
			this.TimeC=data.@TimeC;
			this.TimeB=data.@TimeB;
			this.TimeA=data.@TimeA;
			this.TimeS=data.@TimeS;
			this.DB_Pic=data.@DB_Pic;
			this.DB_Monster=data.@DB_Monster;
			this.DB_MJ1=data.@DB_MJ1;
			this.DB_TIPS1=data.@DB_TIPS1;
			this.DB_MJ2=data.@DB_MJ2;
			this.DB_TIPS2=data.@DB_TIPS2;
			this.DB_MJ3=data.@DB_MJ3;
			this.DB_TIPS3=data.@DB_TIPS3;
			this.DB_MJ4=data.@DB_MJ4;
			this.DB_TIPS4=data.@DB_TIPS4;
			this.DBN_FC=data.@DBN_FC;
			this.DBC_ITEM1=data.@DBC_ITEM1;
			this.DBC_ITEM2=data.@DBC_ITEM2;
			this.DBC_ITEM3=data.@DBC_ITEM3;
			this.DBC_ITEM4=data.@DBC_ITEM4;
			this.DBC_ITEM5=data.@DBC_ITEM5;
			this.DBC_ITEM6=data.@DBC_ITEM6;
			this.DBC_ITEM7=data.@DBC_ITEM7;
			this.DBC_ITEM8=data.@DBC_ITEM8;
			this.Base_Drop=data.@Base_Drop;
			this.Boss_Drop=data.@Boss_Drop;
			this.D_Floor=data.@D_Floor;

			
		}
		
		
		
	}
}

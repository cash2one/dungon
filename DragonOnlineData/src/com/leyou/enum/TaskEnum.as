package com.leyou.enum {
	import com.leyou.utils.PropUtils;



	public class TaskEnum {

		/**
		 *  1.主线	一个角色只能完成1次，完成自动弹出下一个任务领取面板，任务追踪显示“领取”按钮，不可放弃
		 */
		public static var taskLevel_mainLine:int=1;

		/**
		 *2.日常	一个角色每日可以完成多次，通过相应系统功能控制每日次数，可放弃
		 */
		public static var taskLevel_switchLine:int=2;

		/**
		 *3.活动	一个角色每日只能完成1次，每天12点刷新，可放弃
		 */
		public static var taskLevel_activeLine:int=3;

		/**
		 *4.引导	一个角色只能完成1次，可放弃
		 */
		public static var taskLevel_guidanceLine:int=4;

		/**
		 *5.节日	一个角色每日只能完成1次，每天12点刷新，可放弃
		 */
		public static var taskLevel_festivalLine:int=5;

		/**
		 *6.帮派	待定
		 */
		public static var taskLevel_factionLine:int=6;

		/**
		 *7.佣兵经验
		 */
		public static var taskLevel_mercenaryExpLine:int=7;

		/**
		 *8佣兵亲密
		 */
		public static var taskLevel_mercenaryCloseLine:int=8;


		/***************************************************************************************************************/

		/**
		 *剧情副本 ------------附加
		 */
		public static var taskLevel_storeCopyLine:int=9;

		/**
		 *boss ------------附加
		 */
		public static var taskLevel_bossCopyLine:int=10;

		/**
		 *野外boss ------------附加
		 */
		public static var taskLevel_fieldbossCopyLine:int=11;

		/**
		 *押运 ------------附加
		 */
		public static var taskLevel_deliveryLine:int=12;

		/**
		 *农场 ------------附加
		 */
		public static var taskLevel_farmLine:int=13;

		/**
		 *竞技场 ------------附加
		 */
		public static var taskLevel_arenaLine:int=14;

		/**
		 *答题 ------------附加
		 */
		public static var taskLevel_questLine:int=15;

		/**
		 *龙穴 ------------附加
		 */
		public static var taskLevel_dragonLine:int=16;

		/**
		 *恶魔 ------------附加
		 */
		public static var taskLevel_monsterLine:int=17;

		/**
		 *练级 ------------附加
		 */
		public static var taskLevel_levelingLine:int=18;

		/**
		 *双倍 ------------附加
		 */
		public static var taskLevel_doubleLine:int=19;

		/**
		 *签到 ------------附加
		 */
		public static var taskLevel_signInLine:int=20;

		/**
		 * 收集----------------附加
		 */
		public static var taskLevel_collectLine:int=21;


		/**=============================================================================================================*/

		/**
		 *1.npc对话
		 */
		public static var taskType_dialogue:int=1;

		/**
		 *2.杀怪
		 */
		public static var taskType_killBoss:int=2;

		/**
		 *3.杀怪掉落
		 */
		public static var taskType_killBossDrop:int=3;

		/**
		 *4.采集
		 */
		public static var taskType_collect:int=4;

		/**
		 *5.送信
		 *
		 * 	"道具ID即为领取任务给予道具，缴纳任务时扣除道具
道具不可放入仓库，不可丢弃，不可摧毁，不可售卖，不可交易
领取任务时需要背包中含有空格，否则领取任务失败，任务快捷面板显示“领取”按钮
"
*/
		public static var taskType_post:int=5;

		/**
		 *6.物品集换（获得道具）
		 */
		public static var taskType_Exchange:int=6;

		/**
		 *7.达到等级
		 */
		public static var taskType_upgrade:int=7;

		/**
		 * 8.其他（需要调用脚本，特例任务类型）
		 *
		 * 1	如果未填写交任务NPCID，任务完成后在任务追踪面板显示“完成”按钮，并直接弹出完成面板
		 */
		public static var taskType_other:int=8;

		/**
		 *完成指定数量的日常任务
		 */
		public static var taskType_TodayTaskSuccessNum:int=9;

		/**
		 * 参与指定次数的竞技场
		 */
		public static var taskType_ArenaPkNum:int=10;

		/**
		 *开启指定数量的纹章节点
		 */
		public static var taskType_BadgeNodeNum:int=11;

		/**
		 * 坐骑进阶到指定等阶
		 */
		public static var taskType_MountLv:int=12;

		/**
		 * 接受任务后通关指定剧情副本
		 */
		public static var taskType_CopySuccess:int=13;

		/**
		 *提升任意装备强化等级数
		 */
		public static var taskType_EquitTopLv:int=14;

		/**
		 *进行指定次数的元素经验抽取
		 */
		public static var taskType_ElementFlagNum:int=15;
		//======================================================================================================


		/**
 <pre>
1	npc对话	和 A 对话	A读取npc_id
2	杀怪	击杀 0/B 个 A	A读取monster_id	B读取monster_num
3	杀怪掉落	击杀 A 获得 0/B 个C	A读取monster_id	B读取item_id	C读取x
4	采集	采集 0/B 个 A	A读取box_id	B读取box_num
5	送信	将 B 送给 A	A读取npc_id	B读取item_id
6	物品集换	收集 0/B 个 A	A读取item_id	B读取x
7	达到等级	等级达到 A	A读取minlevel
8	其他
</pre>
*/
		public static var taskTypeDesc:Array=["和##对话", "击败####", "击败##获得####", "采集##取得####", "将##送给##", "收集####", "等级达到##", "", "完成##个<font color='#00ff00'><u><a href='event:todayTask'>日常任务</a></u></font>", "参与##次<font color='#00ff00'><u><a href='event:arena'>竞技场</a></u></font>", "开启##个<font color='#00ff00'><u><a href='event:badge'>纹章</a></u></font>节点", "<font color='#00ff00'><u><a href='event:mount'>坐骑</a></u></font>等阶达到或超过##", "进入剧情副本##", "将任意<font color='#00ff00'><u><a href='event:equip'>装备</a></u></font>的强化至##级", "进行##次<font color='#00ff00'><u><a href='event:elements'>元素</a></u></font>经验抽取"];
		
		taskTypeDesc[0]=PropUtils.getStringById(2089);
		taskTypeDesc[1]=PropUtils.getStringById(2090);
		taskTypeDesc[2]=PropUtils.getStringById(2091);
		taskTypeDesc[3]=PropUtils.getStringById(2092);
		taskTypeDesc[4]=PropUtils.getStringById(2093);
		taskTypeDesc[5]=PropUtils.getStringById(2094);
		taskTypeDesc[6]=PropUtils.getStringById(2095);
		taskTypeDesc[7]="";
		taskTypeDesc[8]=PropUtils.getStringById(2096);
		taskTypeDesc[9]=PropUtils.getStringById(2097);
		taskTypeDesc[10]=PropUtils.getStringById(2098);
		taskTypeDesc[11]=PropUtils.getStringById(2099);
		taskTypeDesc[12]=PropUtils.getStringById(2100);
		taskTypeDesc[13]=PropUtils.getStringById(2101);
		taskTypeDesc[14]=PropUtils.getStringById(2102);

		
		/**
		 * <pre>
A读取npc_id
A读取monster_id	B读取monster_num
A读取monster_id	B读取item_id	C读取x
A读取box_id	B读取box_num
A读取npc_id	B读取item_id
A读取item_id	B读取x
A读取minlevel
</pre>
*/
//		public static var taskTypeNpcField:Array=[["npc_name"], ["monster_name", "monster_num"], ["monster_name", "item_name", "item_number"], ["box_name", "item_name", "item_number"], ["item_name", "npc_name"], ["item_name", "item_number"], ["minlevel"], ["npc_name"], ["N_OBJ_Num"], ["NJJC_Num"], ["Y_Blood_Num"], ["Y_Mount_lv"], ["Y_Dungeon_ID"], ["Y_ST_lv"], ["Y_Ele_Time"]];
		public static var taskTypeNpcField:Array=[["npc_id"], ["monster_id", "monster_num"], ["monster_id", "item_id", "item_number"], ["box_id", "item_id", "item_number"], ["item_id", "npc_id"], ["item_id", "item_number"], ["minlevel"], ["npc_id"], ["N_OBJ_Num"], ["NJJC_Num"], ["Y_Blood_Num"], ["Y_Mount_lv"], ["Y_Dungeon_ID"], ["Y_ST_lv"], ["Y_Ele_Time"]];


		/**
		1 商店
		 */
		public static var NPC_FUNC_SHOP:int=1;

		/**
		 * 2 仓库
		 */
		public static var NPC_FUNC_STORE:int=2;

		/**
		 * 3 传送
		 */
		public static var NPC_FUNC_TRANSTER:int=3;

		/**
		 * 4 押镖
		 */
		public static var NPC_FUNC_ESCORT:int=4;

		/**
		 * 行会
		 */
		public static var NPC_FUNC_GUILD:int=5;

		/**
		 * 锻造
		 */
		public static var NPC_FUNC_EQUIT:int=6;

		/**
		 * 寄售
		 */
		public static var NPC_FUNC_AUTION:int=7;

		public function TaskEnum() {

		}





	}
}

package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;


	/**
	 *协议列表

	装备强化/转移


装备强化 at：当前装备强化加成表 lv：强化等级
强化转移 sv：源装备强化等级 dv：目标装备强化等级 sp：源装备强化加成 dp：目标装备强化加成

1.强化
  命令：stg|S,bag_type,pos // 背包类型，装备位置
				  返回：stg{["mk"]="S","lv"=lv,"at"=at}


2.转移
  命令：stg|M,source_type,source_pos,dest_type,dest_pos //源装备背包类型，位置，目标装备背包类型，位置
				  返回：stg{["mk"]="M","sv"=sv,"dv"=dv,"sp"=sp,"dp"=dp}

	 * @author Administrator
	 *
	 */
	public class Cmd_Equip {



		public function Cmd_Equip() {

		}


		public static function sm_Equip_S(o:Object):void {
			if (!o.hasOwnProperty("re"))
				return;

			UIManager.getInstance().equipWnd.IntensifyRender.updateSuccess(o);
		}

		/**
		 *1.强化
		 命令：stg|S,bag_type,pos // 背包类型，装备位置
		 返回：stg{["mk"]="S","lv"=lv,"at"=at}
		 *
		 */
		public static function cm_EquipStrengthen(type:int, pos:int, etype:int=0):void {
			NetGate.getInstance().send("stg|S," + type + "," + pos + "," + etype);
		}


		public static function sm_Equip_M(o:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.EQUIP))
				UIManager.getInstance().equipWnd.TransRender.updateSucc();
		}

		/**
		 *2.转移
  命令：stg|M,source_type,source_pos,dest_type,dest_pos //源装备背包类型，位置，目标装备背包类型，位置
返回：stg{["mk"]="M","sv"=sv,"dv"=dv,"sp"=sp,"dp"=dp}
*
*/
		public static function cm_EquipTransfer(s_type:int, s_pos:int, d_type:int, d_pos:int):void {
			NetGate.getInstance().send("stg|M," + s_type + "," + s_pos + "," + d_type + "," + d_pos);
		}

		public static function sm_Equip_R(o:Object):void {
			if (!o.hasOwnProperty("tp"))
				return;

			UIManager.getInstance().equipWnd.RecastRender.updateSuccess(o);
		}

		public static function sm_Equip_Z(o:Object):void {

			if (!o.hasOwnProperty("rst"))
				return;

			UIManager.getInstance().equipWnd.changeState(o.rst);
		}

		/**

	装备重铸

  tp:装备tips表

1.重铸
-- 重铸装备所在容器类型，位置，消耗装备1所在容器类型，位置1，消耗装备2所在容器类型，位置2，是否使用元宝
命令 rec|R,dest_type,dest_pos,ex_type1,ex_pos1,ex_type2,ex_pos2,yuanbao
成功则返回 rec|R{"tp"=tp}

*
*/
		public static function cm_EquipRecast(dest_type:int, dest_pos:int, ex_type:int, ex_pos:int, gold:int):void {
			NetGate.getInstance().send("rec|R," + dest_type + "," + dest_pos + "," + ex_type + "," + ex_pos + "," + gold);
		}

		/**
		 *下行:smelt|{"mk":"S", "dpos":num}
		 * @param o
		 *
		 */
		public static function sm_Equip_rl_S(o:Object):void {
			if (!o.hasOwnProperty("dpos"))
				return;

			UIManager.getInstance().equipWnd.ReclassRender.onSuccess(o);
		}

		/**
		 *装备熔炼
-----------------------------------------------------------------
smelt
上行:smelt|Sdpos,cpos,stype
   dpos  -- 目标装备的背包位置
			 cpoc  -- 消耗装备的背包位置
		   stype -- 熔炼类型（1普通 2至尊）
		   etype -- (0 普通 1元宝 2绑定元宝)
		 * @param dest_pos
		 * @param ex_pos
		 *
		 */
		public static function cm_EquipReclass(dest_pos:int, ex_pos:int, stype:int, etype:int=0):void {
			NetGate.getInstance().send("smelt|S" + dest_pos + "," + ex_pos + "," + stype + "," + etype);
		}

		/**
		 *萃取装备
上行:smelt|Lpos1,pos2,....
   -- pos 萃取装备背包位置列表

		   * @param arr
		 *
		 */
		public static function cm_EquipBreakItemList(arr:Array):void {
			NetGate.getInstance().send("smelt|L" + arr.join(","));
		}

		/**
		 *下行:smelt|{"mk":"L", "addext":num, "additem":num }
		  addext   -- 本次萃取获得的萃取值
		  additem  -- 本次萃取获得的轮回石数量
		 * @param o
		 *
		 */
		public static function sm_Equip_Break_L(o:Object):void {
			if (!o.hasOwnProperty("addext"))
				return;

			if(!UIManager.getInstance().isCreate(WindowEnum.EQUIP))
				UIManager.getInstance().creatWindow(WindowEnum.EQUIP);
			
			UIManager.getInstance().equipWnd.BreakRender.onSuccessEffect(o);
		}

		public static function sm_Equip_Break_I(o:Object):void {
			if (!o.hasOwnProperty("ext"))
				return;

			if (UIManager.getInstance().backpackWnd.isFull) {
				UIManager.getInstance().backpackWnd.isFull=false;
				return;
			}

			UIManager.getInstance().equipWnd.BreakRender.onSuccess(o);
		}

		/**
		 *萃取值信息
上行:smelt|I
下行:smelt|{"mk":"I", "ext":num}
  -- 当前萃取值
		 * @param arr
		 *
		 */
		public static function cm_EquipBreakStart():void {
			NetGate.getInstance().send("smelt|I");
		}


		public static function sm_Equip_Compound_I(o:Object):void {
			UIManager.getInstance().equipWnd.LvupRender.updateSuccess(o);
		}

		/**
		 * <pre>
		 * 装备合成

hc

上行：hc|Idtype,dpos,ctype,cpos,etype
-- dtype 目标背包类型
	-- dpos  目标位置
		-- ctype 消息背包类型
		-- cpos  消耗位置
		-- etype (0普通升级 1钻石自动购买道具升级 2绑定钻石自动购买进化)
下行：hc|{"mk":"I","rst":num}
-- rst (0失败 1成功)

	 * </pre>
		  */
		public static function cm_EquipCompound(dtype:int, dpos:int, ctype:int, cpos:int, etype:int=0):void {
			NetGate.getInstance().send("hc|I" + dtype + "," + dpos + "," + ctype + "," + cpos + "," + etype);
		}

	}
}

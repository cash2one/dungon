package com.leyou.net.cmd {

	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;

	public class Cmd_Mount {

		public function Cmd_Mount() {

		}

		public static function sm_mou_I(o:Object):void {
			if (!o.hasOwnProperty("el"))
				return;

			//其他玩家
			if (o.hasOwnProperty("id"))
				UIManager.getInstance().otherPlayerWnd.updateMount(o)
			else
				UIManager.getInstance().roleWnd.updateMount(o);
		}

		public static function sm_mou_R(o:Object):void {
			if (!o.hasOwnProperty("rd"))
				return;

			UIManager.getInstance().roleWnd.changeMountState(o);
		}

		public static function sm_mou_D(o:Object):void {
			if (!o.hasOwnProperty("dc"))
				return;

			UIManager.getInstance().mountTradeWnd.updateData(o);
		}

		public static function sm_mou_E(o:Object):void {
			if (!o.hasOwnProperty("el"))
				return;

			UIManager.getInstance().roleWnd.updateMount(o);
		}

		public static function sm_mou_S(o:Object):void {
			if (!o.hasOwnProperty("dc"))
				return;

			UIManager.getInstance().roleWnd.updateMountProps(o);
			UIManager.getInstance().mountTradeWnd.changeValue(o);
		}

		public static function sm_mou_Z(o:Object):void {
			if (!o.hasOwnProperty("rst"))
				return;

			UIManager.getInstance().mountLvUpwnd.updateSuccess(o);
		}

		/**
		 * <pre>
		 *0.初始化
  命令：mou|I -- 服务器会加载坐骑静态表
返回：mou|
{
["mk"] = "I",
["rs"] = mou_ride, -- 乘骑状态1上0下
["ev"] = mou_evolution, -- 进化度
["el"] = mount_lv,    -- 进化级别
["ep"] = evolve_add, -- 进化增加值表					如果是0，表示以前未进化过
["dc"] = domestic_add -- 驯养增加值表
}
例子：	mou|{"ev":0,"ep":0,"el":0,"dc":{"1":1,"3":1,"6":1,"5":1,"9":1,"7":1,"10":1},"mk":"I","rs":0}
</pre>
*
*/
		public static function cmMouInit(name:String=""):void {
			if (name != "")
				NetGate.getInstance().send("mou|I," + name);
			else
				NetGate.getInstance().send("mou|I");
		}

		/**
		 * <pre>
		 * 1.上下坐骑按钮
  命令：mou|R
返回：mou|
{
["mk"] = "R",
["ri"] = mou_ride, -- 乘骑状态 1上0下
["dm"] = domc_add,   --驯养属性表
["up"] = evolve_add -- 升阶进化加属性表
}
["up"]升阶进化加属性表
evolve_add["hp"] = maxhp
evolve_add["mp"] = maxmp
evolve_add["pa"] = patk
  evolve_add["pd"] = pdef
					evolve_add["ma"] = matk
	  evolve_add["md"] = mdef
						  evolve_add["cr"] = crit
	  evolve_add["te"] = tenaci
						  evolve_add["hi"] = hit
	  evolve_add["do"] = dodge
						  evolve_add["sl"] = slay
	  evolve_add["gu"] = guard

						["dm"]驯养属性表
	  domc_add["1"]         -- 最大生命值
						domc_add["2"]         -- 最大法力值
	  domc_add["3"]      -- 物理攻击
						domc_add["4"]      -- 物理防御
	  domc_add["5"]      -- 法术攻击
						domc_add["6"]      -- 法术防御
	  domc_add["7"]            -- 暴击
						domc_add["8"]        -- 韧性
	  domc_add["9"]            -- 命中
						domc_add["10"]          -- 闪避
	  domc_add["11"]           -- 必杀
						domc_add["12"]         -- 守护
  </pre>
*
*/
		public static function cmMouUpOrDown(lv:int=0):void {
//			Core.me.onMount(); //必须调用

//			if (lv > -1)
			NetGate.getInstance().send("mou|R," + lv);
//			else
//				NetGate.getInstance().send("mou|R");
		}

		/**
		 * <pre>
		 *2.坐骑进化/升阶
  命令：mou|E,multi,auto //multi：倍率1,2,5					auto：1单次进化0自动进化
返回：mou|
{
["mk"] = "E",
["ev"] = evolution , -- 坐骑进化度
["el"] = mount_lv			 坐骑等级
}
</pre>
*命令：mou|E,multi,etype  (0普通进化 1砖石自动购买道具进化 2绑定砖石自动购买进化)

*/
		public static function cmMouEvo(mult:int, type:int=0):void {
			NetGate.getInstance().send("mou|E," + mult + "," + type);
		}

		/**
		 * <pre>
		 *3.坐骑驯养
  命令：mou|D,type //type = NORMAL,MIDDLE,HEIGHT = 1,2,3 -- 驯养类型
返回：mou|
local msg = {
["mk"] = "D",
["ri"] = rand_prop_index,					三个属性索引表
["rv"] = rand_prop					三个属性值表
}
例子：mou|{"rv":[-2,4,-3],"mk":"D","ri":[1,8,4]}
</pre>
*
*/
		public static function cmMouTrade(type:int):void {
			NetGate.getInstance().send("mou|D," + type);
		}

		/**
		 * <pre>
		 *4.存储驯养属性
  命令：mou|S
返回：mou|
{
["mk"] = "D",
["ri"] = rand_prop_index,					三个属性索引表
["rv"] = rand_prop					三个属性值表
}
</pre>
*/
		public static function cmMouTradeSave():void {
			NetGate.getInstance().send("mou|S");
		}

		/**
		 *脱下坐骑装备
上行：mou|Nmpos
-- mpos 坐骑装备栏位置（0,1,2,3）
下行：mou|{"mk":"N", mlist:[["id":num,"tips":{...}],...]}
-- mlist 装备格子信息 -- 没有为空
*
*/
		public static function cmMouEquip(pos:int):void {
			NetGate.getInstance().send("mou|N" + pos);
		}


		public static function sm_mou_N(o:Object):void {
			if (!o.hasOwnProperty("mlist"))
				return;

			if (o.hasOwnProperty("other"))
				UIManager.getInstance().otherPlayerWnd.updatemountEquip(o.mlist);
			else {
				UIManager.getInstance().roleWnd.updatemountEquip(o.mlist);
 
			}
		}


	}
}

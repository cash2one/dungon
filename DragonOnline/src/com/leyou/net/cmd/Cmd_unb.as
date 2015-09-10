package com.leyou.net.cmd {

	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_unb {

		/**
		 *建筑信息
上行:unb|I
下行:unb|{"mk":I, "blist":[[btype,blv,uptime],...]}
	 blist -- 建筑列表       (无建筑为[])
			btype -- 建筑类型
		   blv   -- 建筑等级
		   uptime -- 建筑升级剩余时间
		 *
		 */
		public static function cmGuildBlessInit():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_I);
		}


		public static function sm_GuildBless_I(o:Object):void {
			if (!o.hasOwnProperty("blist"))
				return;
			
			UIManager.getInstance().guildWnd.updateGuildSci(o);
		}

		/**
				 *加速建造
		上行:unb|Qpos
		 *
		 * 加速建造
上行:unb|Qpos,num
	*/
		public static function cmGuildBlessAddBuild(pos:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_Q + pos + "," + num);
		}

		/**
		 *移除建筑
上行:unb|Dpos
	 * @param pos
		  *
		 */
		public static function cmGuildBlessDeleteBuild(pos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_D + pos);
		}

		/**
		 * 购买建筑buff
上行:unb|Bpos
	 * @param pos
		  *
		 */
		public static function cmGuildBlessBuyBuff(pos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_B + pos);
		}

		/**
		 *-- 建造
上行:unb|Cpos,btype
	 pos -- 建造位置
		  * @param pos
		 *
		 */
		public static function cmGuildBlessBuild(pos:int, type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_C + pos+","+type);
		}


		/**
		 *升级建筑
上行:unb|Upos
	 * @param pos
		  *
		 */
		public static function cmGuildBlessUpgrade(pos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_BLESS_U + pos);
		}


	}
}

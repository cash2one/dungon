package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.EventManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Marry {


		public static function sm_marry_I(o:Object):void {

			if (o.hasOwnProperty("other")) {
				UIManager.getInstance().otherPlayerWnd.updateMarryInfo(o);
			} else
				UIManager.getInstance().roleWnd.updateMarryInfo(o);

		}

		/**
		 *婚姻信息
上行:marry|Iother
下行:marry|{"mk":I, "marry_name":str, "mtype":num, "mmd_l":num, "m_ring":num, "other":str}
marry_name -- 结婚对象名字
	 mtype -- 结婚类型（1黄金 2白金 3钻石）
			mmd_l  -- 美满度等级
		   m_ring  -- 戒指等级
		   other  -- 其他玩家的名字
		 * @param name
		 *
		 */
		public static function cmMarryInit(name:String=""):void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_I + name);
		}

		public static function sm_marry_R(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.MARRY2))
				UIManager.getInstance().creatWindow(WindowEnum.MARRY2);

			UIManager.getInstance().marryWnd2.updateInfo(o);
			UILayoutManager.getInstance().show(WindowEnum.MARRY2);

		}

		/**
		 *发起求婚
上行:marry|Rmarry_name,mtype,gb
下行:marry|{"mk":R, "marry_name":str, "mtype":num, "gb":str, "marry_union":str, "marry_level":num}
marry_name -- 结婚对象名字
mtype -- 结婚类型（1黄金 2白金 3钻石）
	  gb -- 告白内容
			marry_union -- 结婚对象行会
		  marry_level -- 结婚对象等
		 * @param name
		 *
		 */
		public static function cmMarryStart(name:String, type:int, gb:String):void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_R + name + "," + type + "," + gb);
		}


		public static function sm_marry_P(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.MARRY4))
				UIManager.getInstance().creatWindow(WindowEnum.MARRY4);

			UIManager.getInstance().marryWnd4.updateInfo(o);
//			UILayoutManager.getInstance().show(WindowEnum.MARRY2);

		}

		/**
		 *-------------------------------------------------------------------
结婚属性
上行:marry|P
下行:marry|{"mk":P, "mmd_c":num, "mmd_z":num, "m_room":num, "m_x":num, "m_y":num, "m_cd":num , "leave":num ,"buffst":num}
mmd_c  -- 今日获得美满度
	 mmd_z  -- 总美满度
			m_room -- 对象所在房间id
		   m_x -- 坐标x
		   m_y -- 坐标y
		   m_cd -- 传送cd剩余时间
		   leave -- 离开天数
		   buffst -- buff状态是否已激活(1已激活 0未激活)
		 * @param name
		 *
		 */
		public static function cmMarryProp():void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_P);
		}


		public static function sm_marry_Y(o:Object):void {

			if (o.marry_name == Core.me.info.name || o.marry_name2 == Core.me.info.name) {
				if (!UIManager.getInstance().isCreate(WindowEnum.MARRY3))
					UIManager.getInstance().creatWindow(WindowEnum.MARRY3);

				UIManager.getInstance().marryWnd3.updateInfo(o);
				UILayoutManager.getInstance().show(WindowEnum.MARRY3);
			}

			EventManager.getInstance().dispatchEvent(EventEnum.EFFECT_FLOWER);
		}

		/**
		 -------------------------------------------------------------------
是否同意求婚
上行:marry|Yres
res  --（1同意 2拒绝）

-------------------------------------------------------------------
结婚特效
下行:marry|{"mk":Y, "marry_name":str, "marry_name2":str, "mtype":num}
marry_name -- 结婚对象名字
  marry_name2 -- 结婚对象名字
		  mtype -- 结婚类型（1黄金 2白金 3钻石）
		 * @param y
		 *
		 */
		public static function cmMarryAccept(y:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_Y + y);
		}

		/**
		 *升级亲密度
上行:marry|U
*
*/
		public static function cmMarryUpgrade():void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_U);
		}


		/**
		 *-------------------------------------------------------------------
传送
上行:marry|C
*
*/
		public static function cmMarryTransfer():void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_C);
		}

		/**
		 *-------------------------------------------------------------------
离婚
上行:marry|Lltype
ltype -- 离婚类型（1钻石离婚 ,2失踪离婚）
 *
	   */
		public static function cmMarryDivorce(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_L + type);
		}

		/**
		 *-------------------------------------------------------------------
升级戒指
上行:marry|J
*
*/
		public static function cmMarryEquip():void {
			NetGate.getInstance().send(CmdEnum.CM_MARRY_J);
		}



	}
}

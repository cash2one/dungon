package com.leyou.net.cmd {


	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.ui.map.MapWnd;
	import com.leyou.net.NetGate;


	public class Cmd_Tm {


		public function Cmd_Tm() {

		}

		/**
		 *---------------------------------------------------------------------------
队伍信息
上行:tm|I
下行:tm|{"mk":"I","exp":num,"hp":num,"at":num,"av":num,"aa":num,"u":[[name,vocation,level,force,map,state,avt],....]}
exp -- 经验加成
hp  -- 生命加成
at  -- 概率加成
av  -- 自动接收邀请
aa  -- 自动接收入队
u   -- 队员列表
	  name     -- 玩家名字
				vocation -- 职业
			  level    -- 等级
			  force    -- 战斗力
			  map      -- 所在地图
			  state    -- 状态(0 正常状态,1 距离过远)
			  avt      -- avt字符串(p协议中的avt字符串)
		 (u 信息里第一个为队长信息，客户端根据当前玩家的信息，与列表队长信息，判断显示功能按钮状态)

		 *
		 */
		public static function sm_tm_I(o:Object):void {
//			trace(o);
			if (o == null)
				return;

			UIManager.getInstance().teamWnd.updateTeamPlays(o);
		}

		public static function cm_teamInit():void {
			NetGate.getInstance().send("tm|I");
		}

		/**
		 *---------------------------------------------------------------------------
创建队伍
上行:tm|G
下行:tm|{"mk":"I".....}

* @param o
*
*/
		public static function cm_teamCreate():void {
			NetGate.getInstance().send("tm|G");
		}

		/**
		 *---------------------------------------------------------------------------
退出队伍
上行:tm|Q
下行:tm|{"mk":"I".....}

*
*/
		public static function cm_teamQuit():void {
			NetGate.getInstance().send("tm|Q");
		}

		/**
		 *---------------------------------------------------------------------------
查找队伍
上行:tm|T
下行:tm|{"mk":"T","tl":[lname,people,vocation,level,zforce],...}
tl -- 队伍信息
lname -- 队长名字
people -- 队伍人数
vocation -- 职业
		level -- 等级
				zforce -- 队伍总战斗力

		 *
		 */
		public static function sm_tm_T(o:Object):void {
			if (!o.hasOwnProperty("tl"))
				return;

			UIManager.getInstance().teamWnd.teamAddTeamPanel().updateInfo(o);
		}

		public static function cm_teamFind():void {
			NetGate.getInstance().send("tm|T");
		}

		/**
		 *---------------------------------------------------------------------------
查找队员
上行:tm|U
下行:tm|{"mk":"U","ul":[name,vocation,level,force],...}

*
*/
		public static function sm_tm_U(o:Object):void {

			if (!o.hasOwnProperty("ul"))
				return;

			UIManager.getInstance().teamWnd.teamAddPlayPanel().updateInfo(o);

		}

		public static function cm_teamSearch():void {
			NetGate.getInstance().send("tm|U");
		}

		/**
		 *---------------------------------------------------------------------------
踢出队员
上行:tm|Kname
下行:tm|{"mk":"K","name":name}

*
*/
		public static function sm_tm_K(o:Object):void {

		}

		public static function cm_teamKill(name:String):void {
			NetGate.getInstance().send("tm|K" + name);
		}

		/**
		 *---------------------------------------------------------------------------
任命队长
上行:tm|Cname
下行:tm|{"mk":"I",...}

* @param o
*
*/
		public static function cm_teamAppoint(name:String):void {
			NetGate.getInstance().send("tm|C" + name);
		}

		/**
		 *---------------------------------------------------------------------------
申请入队
上行:tm|Alname
下行:tm|{"mk":"A","leaguer":[name,vocation,level,force,map,state,avt]}

* @param o
*
*/
		public static function sm_tm_A(o:Object):void {
			if (!o.hasOwnProperty("leaguer"))
				return;

			UIManager.getInstance().teamWnd.teamInviteWnd.showPanel(o);
		}

		public static function cm_teamApply(name:String):void {
			NetGate.getInstance().send("tm|A" + name);
		}

		/**
		 *---------------------------------------------------------------------------
邀请入队
上行:tm|Wname
下行:tm|{"mk":"W","leader":[lname,vocation,level,force,map,state,avt]}

*
*/
		public static function sm_tm_W(o:Object):void {
			if (!o.hasOwnProperty("leader"))
				return;

			UIManager.getInstance().teamWnd.teamInviteWnd.showPanel(o);
		}


		public static function cm_teamInvite(name:String):void {
			NetGate.getInstance().send("tm|W" + name);
		}

		/**
		 *---------------------------------------------------------------------------
同意拒绝
上行:tm|Ptype,yn,name
type --类型(1邀请, 2申请)
yn   --同意拒绝(1同意, 0拒绝)
name -- 名字(A W 协议里信息的名字)

下行:tm|{"mk":"I",...} (同意成功后 发送)

*
*/
		public static function cm_teamAccept(type:int, yn:int, name:String):void {
			NetGate.getInstance().send("tm|P" + type + "," + yn + "," + name);
		}

		/**
		 *---------------------------------------------------------------------------
	自动设置
	上行:tm|Sstype,yn
	stype -- 设置类型(1 自动接受邀请, 2 自动接受申请)
		yn    -- 是否 (1是,0否)
		 * @param o
		 *
		 */
		public static function cm_teamAutoSetting(type:int, yn:int):void {
			NetGate.getInstance().send("tm|S" + type + "," + yn);
		}

		/**
		 *---------------------------------------------------------------------------
		 请求同地图队伍坐标信息
上行:tm|M
tm|{"mk":M,"list":[[playerid,stag,name,x,y],...]}
-- playerid -- 玩家id
-- x y 玩家当前像素坐标
* @param o
*
   */
		public static function cm_tmM():void {
			NetGate.getInstance().send("tm|M");
		}

		public static function sm_tm_M(o:Object):void {
			if (o == null)
				return;
			
			MapWnd.getInstance().bigMap.updataTeamPs(o.list as Array);
		}


	}
}

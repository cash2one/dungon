package com.leyou.net.cmd {


	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.NetGate;

	public class Cmd_Role {

		public function Cmd_Role() {
		}

		/**
		 *
请求自己人物属性面板信息
上行：att|M
下行：att|{na:"",ti:"",...}


请求其他人物属性面板信息
上行：att|Oname
下行：att|{na:"",ti:"",...}


t   -- 查看类型 （M自己，O别人）

na  -- 玩家名字
ti  -- 玩家当前称号
ge  -- 玩家性别
vo  -- 职业
le  -- 等级
hp  -- 当前生命
mhp -- 最大生命
mp  -- 当前法力
mmp -- 最大法力
so  -- 当前魂力
mso -- 最大魂力
pa  -- 物理攻击
pd  -- 物理防御
ma  -- 法术攻击
md  -- 法术防御
cr  -- 暴击
te  -- 韧性
hi  -- 命中
do  -- 闪避
sl  -- 必杀
gu  -- 守护
pk  -- pk值
fo  -- 战斗力
el  -- 元素 (0当前守护元素 1金 2木 3水 4火 5土) {"0":1,"1":1,"2":1,"3":1,"4":1,"5":1}  "element":num

当人物属性变化时服务器主动下发人物所有属性信息

* @param o
*
*/
		public static function sm_att(o:Object):void {
			if (o == null)
				return;

			var info:RoleInfo=new RoleInfo();

			info.n=o.na //-- 玩家名字
			info.title=o.ti; //  -- 玩家当前称号
			info.sex=o.ge; //  -- 玩家性别
			info.race=o.vo; //  -- 职业
			info.lv=o.le; //  -- 等级
			info.hp=o.hp; //  -- 当前生命
			info.mHp=o.mhp; // -- 最大生命
			info.mp=o.mp; //  -- 当前法力
			info.mMp=o.mmp; // -- 最大法力
			info.soul=o.sp; //  -- 当前魂力
			info.mSoul=o.msp; // -- 最大魂力
			info.phAtt=o.pa; //  -- 物理攻击
			info.phDef=o.pd; //  -- 物理防御
			info.magicAtt=o.ma; //  -- 法术攻击
			info.magicDef=o.md; //  -- 法术防御
			info.crit=o.cr; //  -- 暴击
			info.tenacity=o.te; //  -- 韧性
			info.hit=o.hi; //  -- 命中
			info.dodge=o.dou; //  -- 闪避
			info.slay=o.sl; //--必杀
			info.guaid=o.gu; //--守护
			info.pk=o.pk; //  -- pk值
			info.fight=o.fo; //  -- 战斗力
			info.guildName=o.un; //---行会
			info.vipLv=o.vip; //----vip
			info.avt=o.avt;
			info.absAttLbl=o.f_a;
			info.absDefLbl=o.f_d;
			
			var obj:Object=o.el; //  -- 元素 (0当前守护元素 1金 2木 3水 4火 5土) {"0":1,"1":1,"2":1,"3":1,"4":1,"5":1}  "element":num
			info.currentElement=obj["0"];
			info.elementArr=new Array();

			for (var i:int=1; i < 6; i++) {
				info.elementArr.push(obj[i]);
			}

			if (o.mk == "M") //自己的信息
				UIManager.getInstance().roleWnd.updateInfo(info);
			else {
//			别人的信息
				UIManager.getInstance().otherPlayerWnd.show();
				UIManager.getInstance().otherPlayerWnd.updateInfo(info);
			}

		}

		/**
		 *
上行：eqp|M
下行：eqp|{"t":M,"0":{"id":10001,"tips":{"itemid":10001,"qh":1,....}},"1":{...}}


请求其他人物装备面板信息
上行：eqp|Oname
下行：eqp|{"t":O,"0":{"id":10001,"tips":{"itemid":10001,"qh":1,....}},"1":{...}}
tips协议
物品属性

itemid   --物品id
qh       --强化等级
bd       --绑定
wg       --物攻
wf       --物防
fg       --法攻
ff       --法防
sm       --生命
fl       --法力
bj       --暴击
rx       --韧性
mz       --命中
sb       --闪避
bs       --必杀
ch       --守护
zdl      --战斗力
* @param o
*
*/
		public static function sm_eqp(o:Object):void {
			if (o == null)
				return;

			var equip:Object=new Object();
			var info:EquipInfo;

			for (var i:int=0; i < 14; i++) {

				if (o[i] == null)
					continue;

				var obj:Object=o[i].tips;
				info=new EquipInfo();
				info.id=obj.itemid; //  --物品id
				info.tips=new TipsInfo(obj);
				info.tips.bd=1;

				if (obj.qh != null)
					info.strengthLv=obj.qh; // --强化等级

				if (obj.bd != null)
					info.bind=obj.bd; //    --绑定
				
				if (obj.wg != null)
					info.phAtt=obj.wg; //   --物攻

				if (obj.wf != null)
					info.phDef=obj.wf; //   --物防

				if (obj.fg != null)
					info.magicAtt=obj.fg; //   --法攻

				if (obj.ff != null)
					info.magicDef=obj.ff; //    --法防

				if (obj.sm != null)
					info.hp=obj.sm; //      --生命

				if (obj.fl != null)
					info.mp=obj.fl; //       --法力

				if (obj.bj != null)
					info.crit=obj.bj; //       --暴击

				if (obj.rx != null)
					info.tenacity=obj.rx; //       --韧性

				if (obj.mz != null)
					info.hit=obj.mz; //       --命中

				if (obj.sb != null)
					info.dodge=obj.sb; //       --闪避

				if (obj.bs != null)
					info.slay=obj.bs; //      --必杀

				if (obj.ch != null)
					info.guaid=obj.ch; //      --守护

				if (obj.adl != null)
					info.fight=obj.zdl; //    --战斗力

				info.position=i;
				info.info=TableManager.getInstance().getEquipInfo(info.id);
				equip[i]=info;
			}

			if (o.mk == "M") {
				MyInfoManager.getInstance().equips=equip;
				UIManager.getInstance().roleWnd.updateEquip(); //自己的装备信息
				
			} else {
				MyInfoManager.getInstance().otherEquips=equip;
				//他人的装备信息
				UIManager.getInstance().otherPlayerWnd.updateEquip();
			}
		}

		/**
		 *请求查看玩家属性信息 上行：att|Oname
		 * @param n 玩家名字
		 *
		 */
		public static function cm_role(n:String=null):void {
			var o:Object=new Object();
			if (n == null)
				o="att" + "|M";
			else
				o="att" + "|O" + n;
			NetGate.getInstance().send(o);
		}

		/**
		 *请求查看玩家装备信息
		 * @param n
		 *
		 */
		public static function cm_equip(n:String=null):void {
			var o:Object=new Object();
			if (n == null)
				o="eqp" + "|M";
			else
				o="eqp" + "|O" + n;
			NetGate.getInstance().send(o);
		}

		/**
		 *卸下装备
上行：eqp|Upos
下行：eqp|{"D": pos}

pos ：装备位置信息
D   ：卸下装备时，删除某位置的装备信息
* @return
*
*/
		public static function sm_offEquip(o:Object):void {
			if (o == null)
				return;

			if (o.D != null) {
				delete MyInfoManager.getInstance().equips[o.D];

				UIManager.getInstance().roleWnd.deleteEquip(int(o.D));
				
				if (UIManager.getInstance().isCreate(WindowEnum.EQUIP))
					UIManager.getInstance().equipWnd.clearItem()
				
			}

		}

		/**
		 *脱下装备
		 * @param pos 装备的位置
		 *
		 */
		public static function cm_offEquip(pos:int):void {
			var o:Object=new Object();
			o="eqp" + "|U" + pos;
			NetGate.getInstance().send(o);
		}

	}
}

package com.leyou.net.cmd {


	import com.ace.manager.UIManager;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.element.Elements;
	import com.leyou.net.NetGate;

	public class Cmd_Element {

		public function Cmd_Element() {
		}

		/**
		 *元素的各个信息
		 * ele

mk (S --元素界面信息, C -- 守护元素信息)

eid 元素id(1金 2木 3水 4火 5土)


请求元素界面显示信息
上行：ele|S
下行：ele|{mk:S,ei:[{eid,lvl,cexp,zexp},{eid,lvl,cexp,zexp},...],count:11,fcount:8,lock:3,litemid:123,lnum:1,bl:[{locknum,beis},{locknum,beis},...],ret:[eid,eid,...],rexp:[{eid,exp},{eid,exp},...]}

ei      -- 各元素信息(eid --元素id, lvl --元素等级, cexp --元素当前经验, zexp --元素经验上限)
count   -- 随机次数
fcount  -- 免费次数
lock    -- 此玩家能锁定的元素个数
litemid -- 随机拉杆需要消耗的道具id
lnum    -- 随机拉杆需要消耗的道具基础个数
lb      -- 锁定个数对应的消耗个数倍率（locknum --锁定的个数, beis -- 消耗的倍率） 实际需要消耗是 lnum * beis
ret     -- 随机拉杆的结果按顺序位置 eid ,...
rexp    -- 随机拉杆结果对应的元素获得经验
* @return
*
*/
		public static function sm_ele_s(o:Object):void {
			if (o == null)
				return;

			var info:ElementInfo=UIManager.getInstance().roleWnd.elementInfo;

			if (o.mk == "S")
				info.effect=false;
			else if (o.mk == "L")
				info.effect=true;

			info.count=o.count;

			info.cItemId=o.litemid;
			info.bItemId=o.litemid2;

			info.freeCount=o.fcount;
			info.lb=o.bl;
			info.lNum=o.lnum;
			info.lockNum=o.lock;

			var i:int;
			//if (info.result == null)
			info.result.length=0;

			for (i=0; i < 5; i++)
				info.result.push(o.ret[i] - 1);

//			if (info.preExp == null)
			info.preExp.length=0;

			info.preExp=o.rexp;

//			if (info.elements == null)
			info.elements.length=0;

			for (i=0; i < 5; i++) {
				var e:Elements=new Elements();
				e.exp=o.ei[i][1];
				e.id=i;
				e.lv=o.ei[i][0];
				e.sumExp=o.ei[i][2];
				info.elements.push(e);
			}

			UIManager.getInstance().roleWnd.updateElement(info);
		}

		/**
		 *请求元素信息
		 */
		public static function cm_ele_s():void {
			NetGate.getInstance().send("ele|S");
		}

		/**
		 *下行：ele|{mk:C,eid:1,sitemid:1111,snum:1}
eid     -- 当前守护的元素id
sitemid -- 切换选择守护元素需要消耗的道具id
snum    -- 切换需要消耗的数量
* @return
*
*/
		public static function sm_ele_c(o:Object):void {
			if (o == null)
				return;

			var info:ElementInfo=UIManager.getInstance().roleWnd.elementInfo;
			info.guildIdx=o.eid - 1;
			info.guildCostItemId=o.sitemid;
			info.guildCostItemCost=o.snum;

			UIManager.getInstance().roleWnd.updateGuildElement(info);

		}

		/**
		 *拉动随机拉杆
上行：ele|Lp1,p2,p3,p4,p5
下行：ele|{mk:L...其他内容同S}

p1 p2 (0,1) --对应的位置是否锁定 0锁定 1未锁定

* @return
*
*/
		public static function cm_ele_l(arr:Array, etype:int=0):void {
			if (arr == null)
				return;

			NetGate.getInstance().send("ele|L" + arr[0] + "," + arr[1] + "," + arr[2] + "," + arr[3] + "," + arr[4] + "," + etype);
		}

		/**
		 *请求守护元素信息
上行：ele|C
*
*/
		public static function cm_ele_c():void {
			NetGate.getInstance().send("ele|C");
		}

		/**
		 *切换守护元素
		 * 上行：ele|Meid
下行：ele|{mk:M,eid:1,sitemid:1111,snum:1}
eid  --想要切换成的元素id(1金 2木 3水 4火 5土)
* @return
*
*/
		public static function cm_ele_m(id:int, type:int=0):void {
			NetGate.getInstance().send("ele|M" + id + "," + type);
		}

		public static function sm_ele_Z(o:Object):void {
			UIManager.getInstance().roleWnd.elementschangeState(o.rst);
		}

		public static function sm_ele_M(o:Object):void {
			sm_ele_c(o);
		}


	}
}

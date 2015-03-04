package com.leyou.net.cmd {

	import com.ace.config.Core;
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.convenientuse.ConvenientUseManager;

	/**
	 *下行指令：
  物品信息：  bag#{"mk":"S","t":1,"o":num,s:[{"id":id,"num":num,"pos":pos,"k":k}...],"k":k};
																												  加入新的物品：bag#{"mk":"L","t":1,s:[{"id":id,"num":num,"pos":pos,"k":k}...]}
  设置背包格子数量：bag#{"mk":"L","t":1,"o":num}
																												  金钱信息： bag#{"mk":"G","t":1,"g":"num","s":num,"l":num,"b":num,"bs":num};
  销毁物品： bag#{"mk":"D","t":1,"pos":pos};
																												  打开背包： bag#{"mk":"X","t":1};
  清空背包： bag#{"mk":"R","t":1};
																												  卖出物品： bag#{"mk":"O","t":1,"pos":pos};

上行：
   挪动物品：bag|1|Mpos1,pos2
																																										   移动到另一容器：bag|1|Vpos1,container2,pos2
   拆分物品：bag|1|Spos,num
																																										   销毁物品：bag|1|Dpos
   重排背包：bag|1|R
																																										   使用物品(普通物品)：bag|1|Upos
   扩展容器：bag|1|E
																																										   请求数据：bag|2|F
   卖出物品：bag|1|Lpos
																																							*
   *
																																						 mk: 操作标示 t： 背包类型 1：背包 2：仓库 3：人物装备 6:任务 15：卡片 30：药园
	 *
	 */
	public class Cmd_Bag {

		public static var movePos:int=-1;
		public static var movePos2:int=-1;
		public static var moveTPos:int=-1;
		public static var moveTPos2:Array=[];

		public function Cmd_Bag() {

		}

		public static function sm_bag(o:Object):void {
			var obj:Object=o;
			if (obj == null)
				return;

			if (obj.mk == null)
				return;

			if (o.t == CmdEnum.CMD_BAG_TYPE_BAG) {
				Cmd_Bag["sm_bag_" + obj.mk](obj);
			} else if (o.t == CmdEnum.CMD_BAG_TYPE_STOREGE) {
				Cmd_Store["sm_store_" + obj.mk](obj);
			} else if (o.t == CmdEnum.CMD_BAG_TYPE_ROLE_EQUIP) {

			} else if (o.t == CmdEnum.CMD_BAG_TYPE_TASK) {

			}

		}

		/**
		 * 返回一个和多个物品
		 * @param o
		 *
		 */
		public static function sm_bag_S(o:Object):void {
			//			trace("s", o)
			/**如果设置密码*/
			if (o.k == 1) {

			} else {

				if (o.t == CmdEnum.CMD_BAG_TYPE_BAG) {

				} else if (o.t == CmdEnum.CMD_BAG_TYPE_STOREGE) {

				} else if (o.t == CmdEnum.CMD_BAG_TYPE_ROLE_EQUIP) {

				} else if (o.t == CmdEnum.CMD_BAG_TYPE_TASK) {

				}

			}
		}

		/**
		 *  物品列表
标志	—————–意义—————–	——————————–备注——————————–
mk	mk=L,物品列表
o	背包开启的格子数量
s	物品数组	s:[{“id”:“10010”,”num”:“1”,”pos”:“1”，”k”：”0”},{“id”:“10010”,”num”:“1”,”pos”:“1”，”k”：”0”}]
k	是否设置了密码锁，1：是 0：否
物品数组的格式
标志	—————–意义—————–	——————————–备注——————————–
id	物品ID
num	数量
pos	位置	背包的从0开始，总共6页，前四页为普通背包，第五页为任务物品 ，第六页为卡片,每页36个格子
k	是否已加锁
金钱

* @param o
*
*/
		public static function sm_bag_L(o:Object):void {
			if (o.s != null) {

				MyInfoManager.getInstance().bagItems.length=0;

				var arr:Array=o.s as Array;

				UIManager.getInstance().backpackWnd.currentItemCount=arr.length;
				UIManager.getInstance().backpackWnd.updateItemCount();

				var obj:Object;
				var tips:TipsInfo;
				for (var i:int=0; i < arr.length; i++) {
					obj=arr[i];

					if (obj != null) {

						var tinfo:Baginfo=new Baginfo();

						tinfo.aid=obj.id;
						tinfo.pos=obj.pos;
						tinfo.num=obj.num;
						tinfo.tips=new TipsInfo(obj.tips);

						MyInfoManager.getInstance().addItems(tinfo);

						UIManager.getInstance().toolsWnd.setActiveCurrentItem(MyInfoManager.getInstance().bagItems[obj.pos]);
					}
				}

				UIManager.getInstance().backpackWnd.refresh();

				UIManager.getInstance().backpackWnd.setPlayGuideMountItem();
				UIManager.getInstance().backpackWnd.setPlayGuideWingItem();
				UIManager.getInstance().backpackWnd.setPlayGuideEquipItem();
				UIManager.getInstance().backpackWnd.setPlayGuideLuckItem();

				if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV))
					UIManager.getInstance().gemLvWnd.updateList();

			} else if (o.yb != null) {
				sm_bag_J(o);
			}
		}

		/**
		 * 金钱类型
		 * @param o
		 * 下行：bag|{"mk":"J","t":1,"jb":"num","bjb":num,"yb":num,"byb":num}
		 */
		public static function sm_bag_J(o:Object):void {

			UIManager.getInstance().backpackWnd.jb=o.jb;
			UIManager.getInstance().backpackWnd.bjb=o.bjb;
			UIManager.getInstance().backpackWnd.yb=o.yb;
			UIManager.getInstance().backpackWnd.byb=o.byb;
			UIManager.getInstance().backpackWnd.zq=o.zq;
			UIManager.getInstance().backpackWnd.honour=o.honour;

			UIManager.getInstance().backpackWnd.updataMoney();


			if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
				UIManager.getInstance().marketWnd.updataMoney();
			}

			if (UIManager.getInstance().isCreate(WindowEnum.AUTION)) {
				UIManager.getInstance().autionWnd.updataMoney();
			}

			if (UIManager.getInstance().isCreate(WindowEnum.MYSTORE)) {
				UIManager.getInstance().myStore.updateItemNum();
			}
			
			if (UIManager.getInstance().isCreate(WindowEnum.VENDUE)) {
				UIManager.getInstance().vendueWnd.updataMoney();
			}

			UIManager.getInstance().roleHeadWnd.updateCurrce();
			SoundManager.getInstance().play(9);
		}

		/**
		 * 标志	—————–意义—————–	——————————–备注——————————–
mk	mk=G,金钱
g	元宝
s	银两
l	礼金
b	帮贡
bs	银票
销毁某个物品
* @param o
*
*/
		public static function sm_bag_G(o:Object):void {
			if (o.o != null) {

				if (UIManager.getInstance().backpackWnd.itemCount != o.o)
					UIManager.getInstance().backpackWnd.updateOneGrid(UIManager.getInstance().backpackWnd.itemCount);

				UIManager.getInstance().backpackWnd.itemCount=o.o;
				UIManager.getInstance().backpackWnd.updateItemCount();

				//重新请求
				Cmd_Bag.cm_bagOpenGrid();
			}

		}

		/**
		 *销毁物品
		 * 标志	—————–意义—————–	——————————–备注——————————–
mk	mk=D,销毁
pos	删除的位置
注释： 对应于服务器的删除物品操作，即当真正需要销毁一个物品时所进行的操作
* @param o
*
*/
		public static function sm_bag_D(o:Object):void {

//			trace(moveTPos, "==", o.pos)
//
//			if (moveTPos == o.pos) {
//				moveTPos=-1;
//				return;
//			} else {
//				moveTPos=-1;
//			}

			var item:Baginfo=MyInfoManager.getInstance().bagItems[o.pos];

			if (item != null && item.info.sound != "0")
				SoundManager.getInstance().play(int(item.info.sound));

			if (item != null && item.info.classid == ItemEnum.ITEM_TYPE_YAOSHUI) {
				if (item.info.subclassid == ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE || item.info.subclassid == ItemEnum.TYPE_YAOSHUI_MOMENT_RED) {
					UIManager.getInstance().toolsWnd.clearEmptyItem(item);
				}
			}

			MyInfoManager.getInstance().bagItems[o.pos]=null;
			UIManager.getInstance().backpackWnd.updateOneGrid(o.pos);

			UIManager.getInstance().backpackWnd.setPlayGuideMountItem();
			UIManager.getInstance().backpackWnd.setPlayGuideWingItem();
			UIManager.getInstance().backpackWnd.setPlayGuideEquipItem();
			UIManager.getInstance().backpackWnd.setPlayGuideLuckItem();

			UIManager.getInstance().selectWnd.updateList();

			if (UIManager.getInstance().isCreate(WindowEnum.EQUIP))
				UIManager.getInstance().equipWnd.clearItem()

			ToolTipManager.getInstance().hide();

			UIManager.getInstance().backpackWnd.currentItemCount=MyInfoManager.getInstance().getBagNum();
			UIManager.getInstance().backpackWnd.updateItemCount();

			// 有销毁物品,检测是否存在快捷换装
			if (null != item) {
				ConvenientUseManager.getInstance().checkUseQueue(item.tips.uid);
			}
		}

		/**
		 *  打开背包
		 * 标志	—————–意义—————–	——————————–备注——————————–
mk	mk=X,打开背包
指定位置高亮，其余蒙灰
* @param o
*/
		public static function sm_bag_X(o:Object):void {
//			trace(o.t, "open bag")
		}

		/**
		 *  清空背包
		 * @param o
		 */
		public static function sm_bag_R(o:Object):void {
//			trace("清空背包");
		}

		/**
		 *	卖出物品
		 * @param o
		 */
		public static function sm_bag_O(o:Object):void {
//			trace("卖出物品");
		}

		/**
		 *更新格子
		 */
		public static function sm_bag_U(o:Object):void {

//			UIManager.getInstance().backpackWnd.updateItemData();

			var tinfo:Baginfo;
			var barr:Array=MyInfoManager.getInstance().bagItems;
			var oitem:Baginfo;

			for (var i:int=0; i < o.s.length; i++) {

				tinfo=new Baginfo();
				tinfo.aid=o.s[i].id;
				tinfo.pos=o.s[i].pos;
				tinfo.num=o.s[i].num;
				tinfo.tips=new TipsInfo(o.s[i].tips);

				oitem=barr[movePos];

				if (o.s.length == 1 && oitem != null && movePos > -1) {
					movePos=-1;

					MyInfoManager.getInstance().updateItems(tinfo);
					UIManager.getInstance().toolsWnd.updateYaoshuiData(tinfo.pos);

					MyInfoManager.getInstance().bagItems[oitem.pos]=null;
					UIManager.getInstance().backpackWnd.updateOneGrid(oitem.pos);

				} else {

					if (o.s.length == 2) {
						movePos=-1;
//						moveTPos2=moveTPos=movePos2=-1;
					}

					MyInfoManager.getInstance().updateItems(tinfo);
					UIManager.getInstance().toolsWnd.setActiveCurrentItem(tinfo);

				}

			}


			UIManager.getInstance().backpackWnd.currentItemCount=MyInfoManager.getInstance().getBagNum();
			UIManager.getInstance().backpackWnd.updateItemCount();

			var item:Baginfo=MyInfoManager.getInstance().bagItems[o.s[0].pos];
			if (item != null && item.info.sound != "0")
				SoundManager.getInstance().play(int(item.info.sound));

			UIManager.getInstance().backpackWnd.refresh();
			UIManager.getInstance().backpackWnd.setPlayGuideMountItem();
			UIManager.getInstance().backpackWnd.setPlayGuideEquipItem();
			UIManager.getInstance().backpackWnd.setPlayGuideWingItem();
			UIManager.getInstance().backpackWnd.setPlayGuideLuckItem();

			UIManager.getInstance().selectWnd.updateList();

			if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV))
				UIManager.getInstance().gemLvWnd.updateList();
		}

		public static function sm_bag_Q(o:Object):void {

			if (o != null) {

				if (UIManager.getInstance().backpackWnd.openGrid) {
					UIManager.getInstance().backAddWnd.showPanel(o);
					UIManager.getInstance().backpackWnd.openGrid=false;
				} else {
					UIManager.getInstance().backpackWnd.openGridTime=o.time;
					UIManager.getInstance().backpackWnd.updateOpenGrid();
				}
			}

		}

		/**
		 *背包中获得了新的物品
下行：bag|{"mk":"N","pos":pos}
pos  -- 道具在背包中的位置
* @param o
*
*/
		public static function sm_bag_N(o:Object):void {
			if (o != null) {
				var bagInfo:Baginfo=MyInfoManager.getInstance().bagItems[o.pos];
				if (null == bagInfo) {
					return;
				}

				ConvenientUseManager.getInstance().checkNewBagId(bagInfo.tips.uid);

//				if (1 == bagInfo.info.classid) {
//					// 新获得装备
//					if (bagInfo.info.level > Core.me.info.level) { // 不匹配等级
//						return;
//					}
//					if ((0 != bagInfo.info.limit) && (bagInfo.info.limit != Core.me.info.profession)) { // 不匹配职业
//						return;
//					}
//					var olist:Array=ItemEnum.ItemToRolePos[bagInfo.info.subclassid];
//					for each (var roleIndex:int in olist) {
//						var einfo:EquipInfo=MyInfoManager.getInstance().equips[roleIndex];
//						if (null != einfo) {
//							// 比较装备基础品质
//							if (einfo.strengthZdl(0) < bagInfo.tips.strengthZdl(0)) {
//								// 是否有强化
//								if (einfo.tips.qh > 0) {
//									var increase:int=bagInfo.tips.strengthZdl(einfo.tips.qh) - einfo.tips.strengthZdl(einfo.tips.qh);
////									ConvenientUseManager.getInstance().pushItem(bagInfo, 2, einfo.id, increase, bagInfo.info.dc, einfo);
//								} else {
////									ConvenientUseManager.getInstance().pushItem(bagInfo, 1, bagInfo.info.id, bagInfo.tips.zdl - einfo.tips.zdl);
//								}
//							}
//							break;
//						} else {
////							ConvenientUseManager.getInstance().pushItem(bagInfo, 1, bagInfo.info.id, bagInfo.tips.zdl);
//							break;
//						}
//
//					}
//				} else if (2 == bagInfo.info.classid) {
//					// 新获得道具
//					var id:String=bagInfo.info.id;
//					var convenientItems:Array=ItemEnum.CONVENIENT_ITEMS;
//					for each (var str:String in convenientItems) {
//						var index:int=id.indexOf(str);
//						if (0 == index) {
////							ConvenientUseManager.getInstance().pushItem(bagInfo, 3);
//							break;
//						}
//					}
//				}
			}
		}

		/**
		 *--------------------------------------------------------------------------------
开启格子成功
下行:bag|{"mk":"Z",  "t":num, "hp":num, "exp":num}
--  t： 背包类型 (1 :人物背包  2：仓库)
-- hp 生命
-- exp 经验

* @param o
*
*/
		public static function sm_bag_Z(o:Object):void {
			if (o != null) {
				UIManager.getInstance().openFun(FunOpenEnum.BACKPACK_GRID); //,openFunc);

//				function openFunc():void{
//					UILayoutManager.getInstance().show(WindowEnum.BACKPACK);
//				}
			}
		}

		/**
		 * 扩展格子
		 *
		 */
		public static function cm_bagOpenGrid(num:int=1):void {
			NetGate.getInstance().send("bag|1|Q" + num);
		}

		/**
		 * 确认扩充
		 * @param num
		 *@param st 0,非绑定元宝;1,绑定元宝
		 */
		public static function cm_bagExtendsGrid(num:int=1, st:int=0):void {
			NetGate.getInstance().send("bag|1|K" + num + "," + st);
		}

		/**
		 * 整理
		 * 整理背包

标志	—————–意义—————–	——————————–备注——————————–
背包类型
R
* @param o
*
*/
		public static function cm_bagNeatan():void {
			NetGate.getInstance().send("bag|1|R");
		}

		/**
		 *使用物品

标志	—————–意义—————–	——————————–备注——————————–
mk	mk=U,使用物品
pos	使用物品的位置
上行指令
*/
		public static function cm_bagUse(pos:int, num:int=1):void {
			moveTPos=-1;
			movePos=-1;
			NetGate.getInstance().send("bag|1|U" + pos + "," + num);
		}

		/**
请求金钱数据

标志	—————–意义—————–	——————————–备注——————————–
背包类型
G	请求金钱数据
*/
		public static function cm_bagGold():void {
			NetGate.getInstance().send("bag|1|G");
		}


		/**
请求物品数据

标志	—————–意义—————–	——————————–备注——————————–
背包类型
L	请求物品数据

移动位置

标志	—————–意义—————–	——————————–备注——————————–
背包类型
M	英文逗号分割 原来的位置,目标位置

*/
		public static function cm_bagMove(Opos:int, Tpos:int):void {
			movePos2=movePos=Opos;
			moveTPos=Tpos;
//			moveTPos2.push(Opos);
			NetGate.getInstance().send("bag|1|M" + Opos + "," + Tpos);
		}

		/**
		 * 移动到其他容器
标志	—————–意义—————–	——————————–备注——————————–
背包类型
V	英文逗号分割 移动前的位置，目标容器，目标位置
* */
		public static function cm_bagMoveTo(Opos:int, Tcon:int, Tpos:int):void {
			moveTPos=-1;
			movePos=-1;
			NetGate.getInstance().send("bag|1|V" + Opos + "," + Tcon + "," + Tpos);
		}

		/**
销毁物品

标志	—————–意义—————–	——————————–备注——————————–
背包类型
D	销毁的位置
* */
		public static function cm_bagDelete(Opos:int):void {
			moveTPos=-1;
//			movePos=Opos;
			NetGate.getInstance().send("bag|1|D" + Opos);
		}

		/**
 *
*
使用物品

标志	—————–意义—————–	——————————–备注——————————–
背包类型
U	位置
拓展格子

标志	—————–意义—————–	——————————–备注——————————–
背包类型
E	*/
		public static function cm_bagOpen():void {
			NetGate.getInstance().send("bag|1|E");
		}

		/**
拆分物品

标志	—————–意义—————–	——————————–备注——————————–
背包类型
S	英文逗号分割 位置，拆分出的数量
*/
		public static function cm_bagSplit(pos:int, num:int):void {
			NetGate.getInstance().send("bag|1|S" + pos + "," + num);
		}

		/**
		 * 请求背包数据
		 *
		 */
		public static function cm_bagData():void {
			NetGate.getInstance().send("bag|1|F");
		}


		/**
		 *----------------------------------------------------------------------------------
出售背包里的物品
上行：bag|1|Cpos
下行：bag|{"mk":"C","t":1,"pos":pos}
下行：bag|{"mk":"J","t":1,"jb":"num","bjb":num,"yb":num,"byb":num}
----------------------------------------------------------------------------------

*
*/
		public static function cm_bagSell(pos:int):void {
			moveTPos=-1;
			NetGate.getInstance().send("bag|1|C" + pos);
		}

		/**
		 *特殊道具使用
上行:bag|Tpos,vargs
-- pos道具位置
-- 使用参数 (如定位道具 为玩家的名字)
* @param pos
	   * @param name
			*
		 */
		public static function cm_bagUseOf(pos:int, name:String):void {
			NetGate.getInstance().send("bag|1|T" + pos + "," + name);
		}

	}
}

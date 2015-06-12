package com.leyou.net.cmd {

	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.store.StoreInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.NetGate;

	public class Cmd_Store {

		private static var movePos:int=-1;
		public static var moveTPos:int=-1;
		
		public function Cmd_Store() {

		}

		public static function sm_store(obj:Object):void {

			if (obj == null || obj.t != 2)
				return;

			Cmd_Store["sm_store_" + obj.mk](obj);
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
		public static function sm_store_L(o:Object):void {
			if (o.s != null) {

				var arr:Array=o.s as Array;

				UIManager.getInstance().storageWnd.currentItemCount=arr.length;
				UIManager.getInstance().storageWnd.updateItemCount();

				MyInfoManager.getInstance().storeItems.length=0;

				var obj:Object;
				for (var i:int=0; i < arr.length; i++) {
					obj=arr[i];

					if (obj != null) {

						var tinfo:StoreInfo=new StoreInfo();

						tinfo.aid=obj.id;
						tinfo.pos=obj.pos;
						tinfo.num=obj.num;
						tinfo.tips=new TipsInfo(obj.tips);

						MyInfoManager.getInstance().addStore(tinfo);

					}
				}

				UIManager.getInstance().storageWnd.refresh();

			} else if (o.yb != null) {
				sm_store_J(o);
			}
		}

		/**
		 * 金钱类型
		 * @param o
		 * 下行：bag|{"mk":"J","t":1,"jb":"num","bjb":num,"yb":num,"byb":num}
		 */
		public static function sm_store_J(o:Object):void {
//			trace(o.jb, o.bjb, o.yb, o.byb, "jb");

			UIManager.getInstance().storageWnd.jb=o.jb;
			UIManager.getInstance().storageWnd.bjb=o.bjb;
			UIManager.getInstance().storageWnd.yb=o.yb;
			UIManager.getInstance().storageWnd.byb=o.byb;
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
		public static function sm_store_G(o:Object):void {
//			trace(o.o, "count");
			if (o.o != null) {

				if (!UIManager.getInstance().isCreate(WindowEnum.STOREGE))
					UIManager.getInstance().creatWindow(WindowEnum.STOREGE);

				if (UIManager.getInstance().storageWnd.itemCount != o.o)
					UIManager.getInstance().storageWnd.updatOneGrid(UIManager.getInstance().storageWnd.itemCount);

				UIManager.getInstance().storageWnd.itemCount=o.o;
				UIManager.getInstance().storageWnd.updateItemCount();

				cm_storeOpenGrid();
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
		public static function sm_store_D(o:Object):void {

			MyInfoManager.getInstance().storeItems[o.pos]=null;
			UIManager.getInstance().storageWnd.updatOneGrid(o.pos);

			//减去数量
			UIManager.getInstance().storageWnd.currentItemCount--;
			UIManager.getInstance().storageWnd.updateItemCount();
		}

		/**
		 *  打开背包
		 * 标志	—————–意义—————–	——————————–备注——————————–
		 mk	mk=X,打开背包
		 指定位置高亮，其余蒙灰
		 * @param o
		 */
		public static function sm_store_X(o:Object):void {
//			trace(o.t, "open bag")
		}

		/**
		 *  清空背包
		 * @param o
		 */
		public static function sm_store_R(o:Object):void {
//			trace("清空背包");
		}

		/**
		 *	卖出物品
		 */
		public static function sm_store_O(o:Object):void {
//			trace("卖出物品");
		}

		/**
		 *更新格子
		 */
		public static function sm_store_U(o:Object):void {

			var tinfo:StoreInfo;
			var barr:Array=MyInfoManager.getInstance().storeItems;

			for (var i:int=0; i < o.s.length; i++) {

				tinfo=new StoreInfo();
				tinfo.aid=o.s[i].id;
				tinfo.pos=o.s[i].pos;
				tinfo.num=o.s[i].num;
				tinfo.tips=new TipsInfo(o.s[i].tips);

//				var tmpItem:Array=barr.filter(function(item:StoreInfo, i:int, arr:Array):Boolean {
//					if (item != null && item.pos != tinfo.pos && item.aid == tinfo.aid) {
//						return true;
//					}
//					return false;
//				});

				var oitem:StoreInfo=barr[movePos];

				if (o.s.length == 1 && oitem != null && movePos > -1) {
					movePos=-1;

					MyInfoManager.getInstance().storeItems[oitem.pos]=null;
					UIManager.getInstance().storageWnd.updatOneGrid(oitem.pos);
				}

				MyInfoManager.getInstance().addStore(tinfo);
				UIManager.getInstance().storageWnd.updatOneGrid(tinfo.pos);
			}

			UIManager.getInstance().storageWnd.currentItemCount=MyInfoManager.getInstance().getStoreNum();
			UIManager.getInstance().storageWnd.updateItemCount();

//			UIManager.getInstance().storageWnd.refresh();
		}

		public static function sm_store_Q(o:Object):void {
			if (o != null) {
				if (UIManager.getInstance().storageWnd.openGrid) {
					UIManager.getInstance().backAddWnd.showPanel(o);
					UIManager.getInstance().storageWnd.openGrid=false;
				} else {
//					UIManager.getInstance().storageWnd.openGridTime=o.time;
//					UIManager.getInstance().storageWnd.updateOpenGrid();
				}
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
		public static function sm_store_Z(o:Object):void {
			if (o != null) {
				UIManager.getInstance().openFun(FunOpenEnum.STORAGE_GRID); //,openFunc);
				
//				function openFunc():void{
//					UILayoutManager.getInstance().show(WindowEnum.STOREGE);
//				}
			}
		}

		/**
		 * 扩展格子
		 *
		 */
		public static function cm_storeOpenGrid(num:int=1):void {
			NetGate.getInstance().send("bag|2|Q" + num);
		}

		/**
		 * 确认扩充
		 * @param num
		 *@param st 0,非绑定元宝;1,绑定元宝
		 */
		public static function cm_storeExtendsGrid(num:int=1,st:int=0):void {
			NetGate.getInstance().send("bag|2|K" + num+","+st);
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
		public static function cm_storeNeatan():void {
			NetGate.getInstance().send("bag|2|R");
		}

		/**
		 *使用物品

		 标志	—————–意义—————–	——————————–备注——————————–
		 mk	mk=U,使用物品
		 pos	使用物品的位置
		 上行指令
		 */
		public static function cm_storeUse(pos:int):void {
			NetGate.getInstance().send("bag|2|U" + pos);
		}

		/**
		 请求金钱数据

		 标志	—————–意义—————–	——————————–备注——————————–
		 背包类型
		 G	请求金钱数据
		 */
		public static function cm_storeGold():void {
			NetGate.getInstance().send("bag|2|G");
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
		public static function cm_storeMove(Opos:int, Tpos:int):void {
			movePos=Opos;
			moveTPos=Tpos;
			NetGate.getInstance().send("bag|2|M" + Opos + "," + Tpos);
		}

		/**
		 * 移动到其他容器
		 标志	—————–意义—————–	——————————–备注——————————–
		 背包类型
		 V	英文逗号分割 移动前的位置，目标容器，目标位置
		 * */
		public static function cm_storeMoveTo(Opos:int, Tcon:int, Tpos:int):void {
			moveTPos=Tpos;
			NetGate.getInstance().send("bag|2|V" + Opos + "," + Tcon + "," + Tpos);
		}

		/**
		 销毁物品

		 标志	—————–意义—————–	——————————–备注——————————–
		 背包类型
		 D	销毁的位置
		 * */
		public static function cm_storeDelete(Opos:int):void {
			NetGate.getInstance().send("bag|2|D" + Opos);
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
		 E	*
		 */
		public static function cm_storeOpen():void {
			NetGate.getInstance().send("bag|2|E");
		}

		/**
		 拆分物品

		 标志	—————–意义—————–	——————————–备注——————————–
		 背包类型
		 S	英文逗号分割 位置，拆分出的数量
		 */
		public static function cm_storeSplit(pos:int, num:int):void {
			NetGate.getInstance().send("bag|2|S" + pos + "," + num);
		}

		/**
		 * 请求背包数据
		 *
		 */
		public static function cm_storeData():void {
			NetGate.getInstance().send("bag|2|F");
		}

	}
}

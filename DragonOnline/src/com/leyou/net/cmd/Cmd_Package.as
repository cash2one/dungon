package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TRed_package;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Package {


		public static function sm_package_I(obj:Object):void {

//			trace(obj)
			UIManager.getInstance().redPackWnd.updateInfo(obj);

		}

		/**
		 * 红包列表
上行：hb|Ibegin,eend
下行: hb|{"mk":"I", "hblist":[hbinfo,hbinfo,...], cc}
begin -- 翻页用开始记录数
eend  -- 翻页用结束记录数
cc    -- 可领取次数
*
   */
		public static function cm_package_I(bi:int, end:int):void {
			NetGate.getInstance().send(CmdEnum.CM_PACKAGE_I + bi + "," + end);
		}


		public static function sm_package_D(obj:Object):void {

			UILayoutManager.getInstance().hide(WindowEnum.REDPACKAGE_OPEN);
			
			if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE_OPENLIST))
				UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE_OPENLIST);

			UILayoutManager.getInstance().show(WindowEnum.REDPACKAGE_OPENLIST);

			UIManager.getInstance().redPackObWnd.updateInfo(obj.hbinfo);

		}

		/**
		 *拆红包
上行：hb|Did
下行: hb|{"mk":"D", "hbinfo":[id, hb_tid, fname, school, gender, dc, [[fval,name,gtime],[fval,name,gtime],...] ]}

id      -- 红包唯一id
hb_tid  -- 红包类型id
fname   -- 红包英雄名
school  -- 职业
gender  -- 性别
dc      -- 已领取次数

fval    -- 分配数值
name    -- 获得人名
gtime   -- 领取红包时间
*
   */
		public static function cm_package_D(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_PACKAGE_D + id);
		}

		public static function cm_package_H(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_PACKAGE_H + id);
		}

		/**
		 * 红包通知
下行: hb|{"mk":"H","hbinfo":[id, hb_tid, fname, school, gender, dc, [[fval,name,gtime],[fval,name,gtime],...] ]}
 * @param obj
	   *
			*/
		public static function sm_package_H(o:Object):void {

			var isOpen:Boolean=false;
			var list:Array=o.hbinfo;
			var list1:Array=list[6];

			for (var i:int=0; i < list1.length; i++) {
				if (MyInfoManager.getInstance().name == list1[i][1]) {
					isOpen=true;
					break;
				}
			}

			var tinfo:TRed_package=TableManager.getInstance().getRedPackageById(list[1]);

			if (int(list[5]) != int(tinfo.Red_Num) && (!isOpen || list1.length == 0) ) {

				UILayoutManager.getInstance().hide(WindowEnum.REDPACKAGE_OPENLIST);

				if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE_OPEN))
					UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE_OPEN);

				UILayoutManager.getInstance().show(WindowEnum.REDPACKAGE_OPEN);
				UIManager.getInstance().redPackOpenWnd.updateInfo(list);

			} else {

				UILayoutManager.getInstance().hide(WindowEnum.REDPACKAGE_OPEN);

				if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE_OPENLIST))
					UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE_OPENLIST);

				UILayoutManager.getInstance().show(WindowEnum.REDPACKAGE_OPENLIST);

				UIManager.getInstance().redPackObWnd.updateInfo(list);
			}

		}


	}
}

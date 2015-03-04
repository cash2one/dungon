package com.leyou.net.cmd {

	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;

	public class Cmd_Link {

		public static var isfirst:Boolean=false;

		public function Cmd_Link() {

		}

		public static function cm_linkSearch():void {
			NetGate.getInstance().send("link|I");
		}

		/**
		 *
		 * @param i
		 * @param type
		 * @param id
		 *
		 */
		public static function cm_linkSet(i:int, type:int, id:int):void {
			NetGate.getInstance().send("link|S" + i + "," + type + "," + id);
		}

		/**
		 *
		 * @param i
		 *
		 */
		public static function cm_linkClear(i:int):void {
			NetGate.getInstance().send("link|C" + i);
		}

		/**
		 *查询快捷栏信息
上行：link|I
下行：link|{mk:I,lindex:[type,id],.......}

lindex -- 快捷栏的位置序号(从0开始)
type -- 快捷栏的类型（1技能 2道具）
id   -- 技能的id/道具的id(当type==1时 id为技能的实际skillid ，当type==2 id为道具的itemid)

* @param o
*
*/
		public static function sm_link_i(o:Object):void {
			if (o == null)
				return;

			UIManager.getInstance().toolsWnd.toolsKey=o;

			var key:String;
			var value:Object;
			for (key in o) {
				if (key.match(/[0-9]+/g).length > 0) {
					
					if (int(o[key][0]) == 1) {
						
						UIManager.getInstance().toolsWnd.updateSkillKey(int(key), int(o[key][1]));
					} else if (int(o[key][0]) == 2)
						UIManager.getInstance().backpackWnd.setToolsKey([int(key), int(o[key][1])]);
					
				}
			}

			//如果有
			UIManager.getInstance().toolsWnd.reUpdateMenuList();
		}

		/**
		 *设置快捷栏
上行：link|Slindex,type,id
下行：link|{mk:S,lindex:[type,id]}

* @param o
*
*/
		public static function sm_link_s(o:Object):void {
			//trace(o);

			if (o == null)
				return;

			var key:String;
			var value:Object;
			for (key in o) {
				if (key.match(/[0-9]+/g).length > 0) {
					value=o[key];
					break;
				}
			}

//			if (value != null)
//				UIManager.getInstance().skillWnd.setSkillShortCut(int(key), int(value[1]));
		}

		/**
		 *清空快捷栏
上行：link|Clindex
下行：link|{mk:C,cl:lindex}

-- cl 清空的快捷栏位置

* @param o
*
*/
		public static function sm_link_c(o:Object):void {
			UIManager.getInstance().toolsWnd.delGrid(o.cl);
		}


	}
}

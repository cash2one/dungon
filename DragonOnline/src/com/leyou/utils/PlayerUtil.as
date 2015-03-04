package com.leyou.utils {


	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.leyou.data.role.EquipInfo;

	public class PlayerUtil {

		/**
		 * <pre>
		 *1	武器
2	戒指
3	手镯
4	头盔
5	衣服
6	手套
7	鞋子
8	腰带
9	裤子
10	项链
11	护符
12	翅膀
13	待定
14	待定
15	待定
16	待定
17	待定
18	待定
19	待定
20	待定

</pre>
*/
		public static var AvatarPartStrArr:Array=["武器", "戒指", "手镯", "头盔", "衣服", "手套", "鞋子", "腰带", "裤子", "项链", "护符", "翅膀", "鞍具", "蹬具", "缰绳", "蹄铁", "待定", "待定", "待定", "待定"];
		
		
		public static var PlayPositionStrArr:Array=["武器", "项链", "手套", "裤子", "护符", "手镯", "戒指", "头盔", "衣服", "腰带", "鞋子", "护符", "手镯", "戒指", "缰绳", "蹄铁", "待定", "待定", "待定", "待定"];
		
		
		
		public function PlayerUtil() {
		}

		/**
		 *根据玩家的 职业 性别 返回头像的路径
		 * @param race
		 * @param sex
		 * @return
		 *
		 */
		public static function getPlayerHeadImg(race:int, sex:int):String {
			var url:String;
			if (race == PlayerEnum.PRO_SOLDIER) { //战士
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_zhans.png";
				else
					url="ui/login/icon_f_zhans.png";
			} else if (race == PlayerEnum.PRO_MASTER) { //法师
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_fas.png";
				else
					url="ui/login/icon_f_fas.png";
			} else if (race == PlayerEnum.PRO_WARLOCK) { //道士
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_daos.png";
				else
					url="ui/login/icon_f_daos.png";
			} else if (race == PlayerEnum.PRO_RANGER) {
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_youx.png";
				else
					url="ui/login/icon_f_youx.png";
			}
			return url;
		}
		
		public static function getPlayerFullHeadImg(race:int, sex:int):String {
			var url:String;
			if (race == PlayerEnum.PRO_SOLDIER) { //战士
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/history/his_zs_m.png";
				else
					url="ui/history/his_zs_f.png";
			} else if (race == PlayerEnum.PRO_MASTER) { //法师
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/history/his_fs_m.png";
				else
					url="ui/history/his_fs_f.png";
			} else if (race == PlayerEnum.PRO_WARLOCK) { //道士
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/history/his_ss_m.png";
				else
					url="ui/history/his_ss_f.png";
			} else if (race == PlayerEnum.PRO_RANGER) {
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/history/his_yx_m.png";
				else
					url="ui/history/his_yx_f.png";
			}
			return url;
		}

		/**
		 *通过职业编号 返回职业名字
		 * @param raceIdx
		 * @param flag 0 返回职业全名 1 返回职业简称
		 * @return
		 *
		 */
		public static function getPlayerRaceByIdx(raceIdx:int, flag:int=0):String {
			var race:String;
			if (raceIdx == PlayerEnum.PRO_SOLDIER) {
				//if (flag == 0)
				race="战士";
					//else
					//	race="战";
			} else if (raceIdx == PlayerEnum.PRO_MASTER) {
				//if (flag == 10)
				race="法师";
					//else
					//	race="法";
			} else if (raceIdx == PlayerEnum.PRO_WARLOCK)
				//if (flag == 0)
				race="术士";
			//else
			//	race="术";
			else if (raceIdx == PlayerEnum.PRO_RANGER)
				//if (flag == 0)
				race="游侠";
			//else
			//	race="游";
			else if (raceIdx == 0)
				race="不限制";
			else
				race="";
			return race;
		}

		/**
		 *人物身上是否穿了这件装备
		 * @param info
		 * @return
		 *
		 */
		public static function getEquipToBody(info:Object):Boolean {

			if (info.classid != 1)
				return false;

			if (info.subclassid < 13) {

				var olist:Array=ItemEnum.ItemToRolePos[info.subclassid];

				var st:Boolean=false;
				var roleIndex:int;
				var einfo:EquipInfo;

				for each (roleIndex in olist) {
					einfo=MyInfoManager.getInstance().equips[roleIndex];

					if (einfo != null) {
						return true;
					}
				}
			} else {
				return (MyInfoManager.getInstance().mountEquipArr[info.subclassid - 13] != null);
			}

			return false;
		}


	}
}

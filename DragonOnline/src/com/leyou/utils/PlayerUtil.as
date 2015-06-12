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

		AvatarPartStrArr[0]=PropUtils.getStringById(2024);
		AvatarPartStrArr[1]=PropUtils.getStringById(2025);
		AvatarPartStrArr[2]=PropUtils.getStringById(2026);
		AvatarPartStrArr[3]=PropUtils.getStringById(2027);
		AvatarPartStrArr[4]=PropUtils.getStringById(2028);
		AvatarPartStrArr[5]=PropUtils.getStringById(2029);
		AvatarPartStrArr[6]=PropUtils.getStringById(2030);
		AvatarPartStrArr[7]=PropUtils.getStringById(2031);
		AvatarPartStrArr[8]=PropUtils.getStringById(2032);
		AvatarPartStrArr[9]=PropUtils.getStringById(2033);
		AvatarPartStrArr[10]=PropUtils.getStringById(2034);
		AvatarPartStrArr[11]=PropUtils.getStringById(1786);
		AvatarPartStrArr[12]=PropUtils.getStringById(2035);
		AvatarPartStrArr[13]=PropUtils.getStringById(2036);
		AvatarPartStrArr[14]=PropUtils.getStringById(2037);
		AvatarPartStrArr[15]=PropUtils.getStringById(2038);
		AvatarPartStrArr[16]=PropUtils.getStringById(2039);

		public static var PlayPositionStrArr:Array=["武器", "项链", "手套", "裤子", "护符", "手镯", "戒指", "头盔", "衣服", "腰带", "鞋子", "护符", "手镯", "戒指", "缰绳", "蹄铁", "待定", "待定", "待定", "待定"];


		PlayPositionStrArr[0]=PropUtils.getStringById(2024);
		PlayPositionStrArr[1]=PropUtils.getStringById(2033);
		PlayPositionStrArr[2]=PropUtils.getStringById(2029);
		PlayPositionStrArr[3]=PropUtils.getStringById(2032);
		PlayPositionStrArr[4]=PropUtils.getStringById(2034);
		PlayPositionStrArr[5]=PropUtils.getStringById(2026);
		PlayPositionStrArr[6]=PropUtils.getStringById(2025);
		PlayPositionStrArr[7]=PropUtils.getStringById(2027);
		PlayPositionStrArr[8]=PropUtils.getStringById(2028);
		PlayPositionStrArr[9]=PropUtils.getStringById(2031);
		PlayPositionStrArr[10]=PropUtils.getStringById(2030);
		PlayPositionStrArr[11]=PropUtils.getStringById(2034);
		PlayPositionStrArr[12]=PropUtils.getStringById(2026);
		PlayPositionStrArr[13]=PropUtils.getStringById(2027);
		PlayPositionStrArr[14]=PropUtils.getStringById(2037);
		PlayPositionStrArr[15]=PropUtils.getStringById(2038);
		PlayPositionStrArr[16]=PropUtils.getStringById(2039);



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
				race=PropUtils.getStringById(1528);
					//else
					//	race="战";
			} else if (raceIdx == PlayerEnum.PRO_MASTER) {
				//if (flag == 10)
				race=PropUtils.getStringById(1526);
					//else
					//	race="法";
			} else if (raceIdx == PlayerEnum.PRO_WARLOCK)
				//if (flag == 0)
				race=PropUtils.getStringById(1529);
			//else
			//	race="术";
			else if (raceIdx == PlayerEnum.PRO_RANGER)
				//if (flag == 0)
				race=PropUtils.getStringById(1527);
			//else
			//	race="游";
			else if (raceIdx == 0)
				race=PropUtils.getStringById(2044);
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
		public static function getEquipToBody(info:Object, self:Boolean=false):Boolean {

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
						if (self) {
							if (einfo.id == info.id)
								return true;
						} else {
							return true;
						}
					}
				}
			} else {
				return (MyInfoManager.getInstance().mountEquipArr[info.subclassid - 13] != null);
			}

			return false;
		}


	}
}

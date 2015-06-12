package com.leyou.utils {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TNpcFunction;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.greensock.TweenLite;
	import com.leyou.enum.TaskEnum;

	import flash.media.ID3Info;


	public class TaskUtil {

		public static var taskDailyLoop:int=20;

		public function TaskUtil() {
		}

		/**
		 *"100-199，战士专属圣器
200-299，法师专属圣器
300-399，术士专属圣器
400-499，游侠专属圣器"
* @param id
*
*/
		public static function getProfessById(id:int):int {

			if (id > 100 && id < 200) {
				return 1;
			} else if (id > 200 && id < 299) {
				return 2;
			} else if (id > 300 && id < 399) {
				return 3;
			} else if (id > 400 && id < 499) {
				return 4;
			}

			return 0;
		}

		public static function getProfessID(id:int):void {


		}

		/**
		 *任务状态(0：未完成 1：已完成 -1：可领取)
		 * @param s
		 * @return
		 *
		 */
		public static function getStringByState(s:int):String {

			if (s == 0)
				return PropUtils.getStringById(2054);
			else if (s == 1)
				return PropUtils.getStringById(1584);
			else if (s == -1)
				return PropUtils.getStringById(1567);

			return "";
		}


		/**
		 *1.主线
2.日常
3.活动
4.引导
5.节日
6.帮派
* @param type
   *
		   */
		public static function getStringByType(type:int):String {

			switch (type) {
				case 1:
					return PropUtils.getStringById(2056);
				case 2:
					return PropUtils.getStringById(2057);
				case 3:
					return PropUtils.getStringById(2058);
				case 4:
					return PropUtils.getStringById(2059);
				case 5:
					return PropUtils.getStringById(2060);
				case 6:
					return PropUtils.getStringById(2061);
				case 7:
					return PropUtils.getStringById(2168);
				case 8:
					return PropUtils.getStringById(2169);

			}

			return "";

		}

		/**
		 * 单击npc 开启相应功能
		 * @param living
		 */
		public static function openNpcFuncPanel(living:int):void {

			var livinfo:TLivingInfo=TableManager.getInstance().getLivingInfo(living);
			if (livinfo != null && livinfo.NPCfunction > 0) {

				var npcaFunc:TNpcFunction=TableManager.getInstance().getNpcFuncInfo(livinfo.NPCfunction);

				if (npcaFunc != null) {

					switch (npcaFunc.funid) {
						case TaskEnum.NPC_FUNC_SHOP:
							UILayoutManager.getInstance().show(WindowEnum.SHOP);
							break;
						case TaskEnum.NPC_FUNC_STORE:
							UILayoutManager.getInstance().show_II(WindowEnum.BACKPACK);

							TweenLite.delayedCall(.3, function():void {
								UILayoutManager.getInstance().show(WindowEnum.STOREGE);
								UILayoutManager.getInstance().composingWnd(WindowEnum.STOREGE);
							});
							break;
						case TaskEnum.NPC_FUNC_TRANSTER:

							break;
						case TaskEnum.NPC_FUNC_ESCORT:
							UIManager.getInstance().deliveryWnd.show();
							break;
						case TaskEnum.NPC_FUNC_GUILD:
							UILayoutManager.getInstance().show_II(WindowEnum.GUILD);
							break;
						case TaskEnum.NPC_FUNC_EQUIT:
							UILayoutManager.getInstance().show_II(WindowEnum.EQUIP);
							break;
						case TaskEnum.NPC_FUNC_AUTION:
							UILayoutManager.getInstance().show(WindowEnum.AUTION);
							break;
					}
				}
			}
		}


		public static function ChangeObjectToArray(obj:Object):Array {
			var a:Array=[];
			var str:String;
			for (str in obj) {
				a[int(str)]=obj[str];
			}

			return a;
		}


	}
}

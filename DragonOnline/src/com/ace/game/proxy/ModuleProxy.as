/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-1-3 下午2:34:22
 */
package com.ace.game.proxy {
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.setting.AssistWnd;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Shp;
	
	import flash.utils.getTimer;

	/**
	 * 模块功能代理
	 * @author ace
	 *
	 */
	public class ModuleProxy {


		//道具数量
		static public function itemNum(id:int):int {
			return MyInfoManager.getInstance().getBagItemNumById(id);
		}


		/**
		 * 自动吃hp药
		 * @return 是否成功
		 */
		static public function itemEathHP():Boolean {
//			PreExecutManager.getInstance().execute(ModuleProxy.itemEathHP);
//			trace("自动吃hp药时间：",getTimer());


			var arr:Vector.<TItemInfo>=TableManager.getInstance().getItemListByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_CONTINUE_RED);
			var item:TItemInfo;
			var baginfo:Baginfo;

			arr.reverse();

			var lv:int=Core.me.info.level;
			var exist:Boolean=false;
			for each (item in arr) {
				baginfo=MyInfoManager.getInstance().getBagItemPosByID(int(item.id));

				if (baginfo != null) {

//					trace("道具cd时间",UIManager.getInstance().backpackWnd.getGridsCD(baginfo.pos),//
//						baginfo.pos,MyInfoManager.getInstance().bagItems[baginfo.pos].info.name)

					if (UIManager.getInstance().backpackWnd.getGridsCD(baginfo.pos) <= 0 && int(item.level) <= lv) {
						Cmd_Bag.cm_bagUse(baginfo.pos);
						exist=true;
						return exist;
					}

				}
			}

			if (!exist) {
				if (!SettingManager.getInstance().assitInfo.isAutoBuyHP)
					GuideManager.getInstance().showGuide(45, UIManager.getInstance().toolsWnd.getUIbyID("guaJBtn"));
			}

			return false;
		}

		/**
		 * 自动吃mp药
		 * @return 是否成功
		 *
		 */
		static public function itemEathMP():Boolean {
//			PreExecutManager.getInstance().execute(ModuleProxy.itemEathMP);
			var arr:Vector.<TItemInfo>=TableManager.getInstance().getItemListByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_CONTINUE_BLUE);
			var item:TItemInfo;
			var baginfo:Baginfo;

			arr.reverse();

			var lv:int=Core.me.info.level;
			for each (item in arr) {
				baginfo=MyInfoManager.getInstance().getBagItemPosByID(int(item.id));
				if (baginfo != null && int(item.level) <= lv) {
					Cmd_Bag.cm_bagUse(baginfo.pos);
					return true;
				}
			}

			return false;
		}

		/**
		 * 自动购买一组指定的道具
		 * @param id
		 * @return  是否购买成功，客户端判断，先判断金钱是否足够
		 *
		 */
		static public function itemBuy(id:int):Boolean {

			if (id <= 0)
				return false;

			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
			var xmllist:XMLList=infoXml.shop;
			var xml:XML;
			var index:int=0;
			var exist:Boolean=false;

			for each (xml in xmllist) {
				if (xml.@itemId == id && xml.@shopId == 1) {
					exist=true;
					break;
				}
				
				index++;
			}

			if (!exist)
				return false;

			var table:TItemInfo=TableManager.getInstance().getItemInfo(id);
			if (table == null)
				return false;

			Cmd_Shp.cm_shpBuy(1, index, int(table.maxgroup));
			return true;
		}

		//技能是否在cd
		static public function skillIsCD(id:int):Boolean {
			return false;
		}

		/**
		 * 返回当前任务怪物id
		 * @return，如果是打怪任务，则返回怪物id，其他则返回-1，怪物数量够了的话，也返回-1
		 *
		 */
		static public function taskMonstId():int {
			var miss:TMissionDate=TableManager.getInstance().getMissionDataByID(UIManager.getInstance().taskTrack.taskID);
			if (miss == null)
				return -1;
			if ((int(miss.dtype) == TaskEnum.taskType_killBoss || int(miss.dtype) == TaskEnum.taskType_killBossDrop) && UIManager.getInstance().taskTrack.taskOneInfo.st == 0)
				return int(miss.monster_id)
			return -1;
		}

		/**
		 * 返回当前任务采集id
		 * @return，如果是采集任务，则返回采集id，其他则返回-1，采集数量够了的话，也返回-1
		 *
		 */
		static public function taskCollectId():int {
			var miss:TMissionDate=TableManager.getInstance().getMissionDataByID(UIManager.getInstance().taskTrack.taskID);
			if (miss == null)
				return -1;

			if (int(miss.dtype) == TaskEnum.taskType_collect && UIManager.getInstance().taskTrack.taskOneInfo.st == 0)
				return int(miss.box_id);

			return -1;
		}

		/**
		 * 返回当前怪物的位置
		 * @return {sceneId:"场景id",pt:"怪物格子坐标点"}
		 *
		 */
		static public function taskMonstPs():TPointInfo {
			var miss:TMissionDate=TableManager.getInstance().getMissionDataByID(UIManager.getInstance().taskTrack.taskID);
			if (miss == null)
				return null;

			if ((int(miss.dtype) == TaskEnum.taskType_killBoss || int(miss.dtype) == TaskEnum.taskType_killBossDrop)) {
//				var info:TPointInfo=TableManager.getInstance().getPointInfo(miss.target_point);
				return TableManager.getInstance().getPointInfo(int(miss.target_point));
			}
			return null;
		}

		/**开启关闭自动挂机*/
		static public function assistOpen():void {
			AssistWnd.getInstance().onButtonClick(null);
		}

		/**
		 * 自动做任务
		 * @return 如果没有任务可以做，则false
		 *
		 */
		static public function autoTask():Boolean {

			var miss:TMissionDate=TableManager.getInstance().getMissionDataByID(UIManager.getInstance().taskTrack.taskID);
			if (miss == null)
				return false;

//			if ((int(miss.dtype) == TaskEnum.taskType_killBoss || int(miss.dtype) == TaskEnum.taskType_killBossDrop) && UIManager.getInstance().taskTrack.taskOneInfo.st != 1)
//				return false;

			UIManager.getInstance().taskTrack.autoComplete();

			return true;
		}

		/**提示信息*/
		static public function broadcastMsg(id:int, arr:Array=null):void {
			NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(id), arr);
		}

		static public function showChatMsg(str:String):void {
			UIManager.getInstance().chatWnd.chatNotice(str);
		}

		static public function isBackpackFull():Boolean {
			return MyInfoManager.getInstance().getBagEmptyNum() == 0;
		}
	}
}

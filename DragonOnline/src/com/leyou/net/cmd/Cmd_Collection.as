package com.leyou.net.cmd
{
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Collection
	{
		public static function sm_COL_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.COLLECTION, CmdEnum.SM_COL_I);
			DataManager.getInstance().collectionData.loadData_I(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.COLLECTION)){
				UIManager.getInstance().collectionWnd.updateMapInfo();
			}
			if(Core.me.info.level < ConfigEnum.setin1){
				return;
			}
			
			var count:int = DataManager.getInstance().collectionData.rewardCount;
			var groupId:int = DataManager.getInstance().collectionData.cgroupId;
			if(-1 == groupId && count <= 0){
				UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_collectLine);
			}else{
				var remianTask:int = DataManager.getInstance().collectionData.remainTask(groupId);
				var cc1:String="";
				if(-1 == groupId){
					cc1="已全部收集完成";
				}else{
					var tData:TCollectionPreciousInfo = TableManager.getInstance().getPreciousByGroup(groupId);
					cc1="<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>地图中还有{2}个宝藏没有收集";
					cc1=StringUtil.substitute(cc1, tData.mapName, remianTask);
				}
				var cc2:String="您有<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>个收集宝藏未领取";
				cc2=StringUtil.substitute(cc2, count);
				if(count <= 0){
					cc2 = "";
				}
				var arr:Array=["[收集]", cc1, cc2, "", callback];
				UIManager.getInstance().taskTrack.updateOhterTrack(TaskEnum.taskLevel_collectLine, arr);
			}
		}
		
		public static function callback(type:String):void{
			UIOpenBufferManager.getInstance().open(WindowEnum.COLLECTION);
		}
		
		public static function cm_COL_I():void{
			NetGate.getInstance().send(CmdEnum.CM_COL_I);
		}
		
		public static function sm_COL_G(obj:Object):void{
			DataManager.getInstance().collectionData.loadData_G(obj);
			UIManager.getInstance().collectionWnd.updateItemInfo();
		}
		
		public static function cm_COL_G(group:int):void{
			NetGate.getInstance().send(CmdEnum.CM_COL_G+group);
		}
		
		public static function cm_COL_T(sid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_COL_T+sid);
		}
	}
}
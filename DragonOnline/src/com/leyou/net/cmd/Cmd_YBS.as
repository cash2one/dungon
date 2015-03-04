package com.leyou.net.cmd
{
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;
	
	import flash.geom.Point;

	public class Cmd_YBS
	{
		public static function sm_YBS_I(obj:Object):void{
//			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.FIELDBOSS, CmdEnum.SM_YBS_I);
			DataManager.getInstance().fieldBossData.loadData_I(obj);
			UIManager.getInstance().bossWnd.updateWorldBoss();
//			UIManager.getInstance().fieldBossWnd.updateView();
		}
		
		public static function cm_YBS_I():void{
			NetGate.getInstance().send(CmdEnum.CM_YBS_I);
		}
		
		public static function sm_YBS_R(obj:Object):void{
			DataManager.getInstance().fieldBossData.loadData_R(obj);
			if(!UIManager.getInstance().isCreate(WindowEnum.FIELD_BOSS_TRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.FIELD_BOSS_TRACK);
			}
			if(!UIManager.getInstance().fieldBossTrack.visible){
				UIManager.getInstance().fieldBossTrack.show();
			}
			UIManager.getInstance().fieldBossTrack.updateInfo();
		}
		
		public static function sm_YBS_J(obj:Object):void{
			UILayoutManager.getInstance().show(WindowEnum.FIELD_BOSS_REWARD);
			UIManager.getInstance().fieldBossReward.updateInfo(obj.rank, obj.ybid, obj.damage);
		}
		
		public static function sm_YBS_X(obj:Object):void{
			if(UIManager.getInstance().isCreate(WindowEnum.FIELD_BOSS_REWARD)){
				if(DataManager.getInstance().fieldBossData.damBossId == obj.ybid){
					UIManager.getInstance().fieldBossTrack.hide();
				}
			}
		}
		
		public static function callBack(type:String):void{
			var bossId:int = DataManager.getInstance().fieldBossData.getRemindId();
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(bossId);
			var point:TPointInfo = TableManager.getInstance().getPointInfo(bossInfo.pointId);
			if("9" == type){
				Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
			}else{
				Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
			}
		}
		
		public static function sm_YBS_L(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.BOSS, CmdEnum.SM_YBS_L);
			DataManager.getInstance().fieldBossData.loadData_L(obj);
			UIManager.getInstance().bossWnd.updateLowBoss();
		}
		
		public static function cm_YBS_L():void{
			NetGate.getInstance().send(CmdEnum.CM_YBS_L);
		}
		
		public static function sm_YBS_T(obj:Object):void{
			var bossId:int = obj.ybid;
			var type:int = obj.ttype; // 0开始显示 1关闭显示
			var rbid:int = DataManager.getInstance().fieldBossData.getRemindId();
			if(bossId == rbid){
				var arr:Array;
				var content:String;
				var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(bossId);
				var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
				if(1 == type){
					UILayoutManager.getInstance().show(WindowEnum.FIELD_BOSS_REMIND);
					UIManager.getInstance().fieldBossRemind.loadInfo(bossId);
					
					content="        {1}<font color='#ff00'><u><a href='event:other_ycp--{2}'>前往击杀</a></u></font>";
					content=StringUtil.substitute(content, monsterInfo.name, bossId);
					arr = ["[野外BOSS]", content, "", "", callBack, "", callBack];
					UIManager.getInstance().taskTrack.updateOhterTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
				}else{
					UILayoutManager.getInstance().hide(WindowEnum.FIELD_BOSS_REMIND);
					
					content="        {1}<font color='#ff0000'><u><a href='event:other_ycp--{2}'>未刷新</a></u></font>";
					content=StringUtil.substitute(content, monsterInfo.name, bossId);
					arr = ["[野外BOSS]", content, "", "", callBack, "", callBack];
					UIManager.getInstance().taskTrack.updateOhterTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
				}
			}
		}
	}
}
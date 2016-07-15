package com.leyou.net.cmd {
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
	import com.greensock.TweenLite;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;
	import com.leyou.utils.PropUtils;

	import flash.geom.Point;

	public class Cmd_YBS {
		
		
		public static function sm_YBS_I(obj:Object):void {
//			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.FIELDBOSS, CmdEnum.SM_YBS_I);
			DataManager.getInstance().fieldBossData.loadData_I(obj);
			UIManager.getInstance().bossWnd.updateWorldBoss();
//			UIManager.getInstance().fieldBossWnd.updateView();
			
			
		}

		public static function cm_YBS_I():void {
			NetGate.getInstance().send(CmdEnum.CM_YBS_I);
		}

		public static function sm_YBS_R(obj:Object):void {
			DataManager.getInstance().fieldBossData.loadData_R(obj);
			if (!UIManager.getInstance().isCreate(WindowEnum.FIELD_BOSS_TRACK)) {
				UIManager.getInstance().creatWindow(WindowEnum.FIELD_BOSS_TRACK);
			}
			if (!UIManager.getInstance().fieldBossTrack.visible) {
				UIManager.getInstance().fieldBossTrack.show();
			}
			UIManager.getInstance().fieldBossTrack.updateInfo();
		}

		public static function sm_YBS_J(obj:Object):void {
			UILayoutManager.getInstance().show(WindowEnum.FIELD_BOSS_REWARD);
			UIManager.getInstance().fieldBossReward.updateInfo(obj.rank, obj.ybid, obj.damage);
		}

		public static function sm_YBS_X(obj:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.FIELD_BOSS_TRACK)) {
				if (DataManager.getInstance().fieldBossData.damBossId == obj.ybid) {
					UIManager.getInstance().fieldBossTrack.hide();
				}
			}
		}

		public static function callBack(type:String):void {
			var bossId:int=DataManager.getInstance().fieldBossData.getRemindId();
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(bossId);
			var point:TPointInfo=TableManager.getInstance().getPointInfo(bossInfo.pointId);
			if ("17" == type) {
				Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
			} else {
				Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
			}
		}

		public static function sm_YBS_L(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.BOSS, CmdEnum.SM_YBS_L);
			DataManager.getInstance().fieldBossData.loadData_L(obj);
			UIManager.getInstance().bossWnd.updateLowBoss();
			 
		}

		public static function cm_YBS_L():void {
			NetGate.getInstance().send(CmdEnum.CM_YBS_L);
		}

		public static function sm_YBS_T(obj:Object):void {
			var bossId:int=obj.ybid;
			var type:int=obj.ttype; // 0开始显示 1关闭显示
			var rbid:int=DataManager.getInstance().fieldBossData.getRemindId();
			if (bossId == rbid) {
				var arr:Array;
				var content:String;
				var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(bossId);
				var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
				if (1 == type) {
					UILayoutManager.getInstance().show(WindowEnum.FIELD_BOSS_REMIND);
					UIManager.getInstance().fieldBossRemind.loadInfo(bossId);

//					content=PropUtils.getStringById(1570) + "</a></u></font>";
					content=StringUtil.substitute(PropUtils.getStringById(2452), DataManager.getInstance().fieldBossData.lastCount);
					arr=[PropUtils.getStringById(2423), "<a href='event:other_ycp--" + monsterInfo.name + "'>" + PropUtils.getStringById(2439) + "</a>", content, "", callBack2, "", callBack];
					UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
				} else {
					UILayoutManager.getInstance().hide(WindowEnum.FIELD_BOSS_REMIND);

//					content="        {1}<font color='#ff0000'><u><a href='event:other_ycp--{2}'>" + PropUtils.getStringById(1572) + "</a></u></font>";
//					content=StringUtil.substitute(content, monsterInfo.name, bossId);
					arr=[PropUtils.getStringById(2423), "<a href='event:other_ycp--" + monsterInfo.name + "'>" + PropUtils.getStringById(2439) + "</a>", PropUtils.getStringById(2454), "",callBack2, "", callBack];
					UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
				}
			}
		}


		public static function sm_YBS_Y(obj:Object):void {

//			trace(obj)

			var ylist:Array=obj.yblist;
			var arr:Array=[];
			var count:int=0;
			for each (arr in ylist) {
				if (null != arr) {
					var tbInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(arr[0]);
					if (tbInfo.openLv <= Core.me.info.level && arr[1] == 1) {
						count++;
					}
				}
			}

			if (count > 0) {
				var content:String=StringUtil.substitute(PropUtils.getStringById(2452), count);
				arr=[PropUtils.getStringById(2423), "<a href='event:other_ycp--ycps'>" + PropUtils.getStringById(2438) + "</a>", content, "", callBack1, "", callBack];
				UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_bosStandLine, arr);
			} else {
				arr=[PropUtils.getStringById(2423), "<a href='event:other_ycp--ycps'>" + PropUtils.getStringById(2438) + "</a>", PropUtils.getStringById(2454), "", callBack1, "", callBack];
				UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_bosStandLine, arr);
			}


		}


		public static function callBack1(type:String):void {
			UIOpenBufferManager.getInstance().open(WindowEnum.BOSS);
			TweenLite.delayedCall(0.6, UIManager.getInstance().bossWnd.changeToIndex, [1]);
		}
		
		public static function callBack2(type:String):void {
			UIOpenBufferManager.getInstance().open(WindowEnum.BOSS);
			TweenLite.delayedCall(0.6, UIManager.getInstance().bossWnd.changeToIndex, [2]);
		}
		
		public static function cm_YBS_Y():void {
			NetGate.getInstance().send(CmdEnum.CM_YBS_Y);
		}

	}
}

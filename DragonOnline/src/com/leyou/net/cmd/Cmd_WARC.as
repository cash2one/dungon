package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.map.MapWnd;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_WARC
	{
		public static function sm_WARC_I(obj:Object):void{
			DataManager.getInstance().cityBattleData.loadData_I(obj);
			UIManager.getInstance().guildBattleWnd.updateCityBattleInfo();
		}
		
		public static function cm_WARC_I():void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_I);
		}
		
		// 修改宣言
		public static function cm_WARC_N(notice:String):void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_N+notice);
		}
		
		// 进入战场
		public static function cm_WARC_E():void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_E);
		}
		
		// 离开战场
		public static function cm_WARC_Q():void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_Q);
		}
		
		// 设置税率
		public static function cm_WARC_C(rate:int):void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_C+rate);
		}
		
		// 发放双倍
		public static function cm_WARC_S():void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_S);
		}
		
		// 追踪信息
		public static function sm_WARC_T(obj:Object):void{
			DataManager.getInstance().cityBattleData.loadData_T(obj);
			if(!UIManager.getInstance().isCreate(WindowEnum.CITY_BATTLE_TRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.CITY_BATTLE_TRACK)
			}
			UIManager.getInstance().cityBattleTrack.show();
			UIManager.getInstance().cityBattleTrack.updateInfo();
			MapWnd.getInstance().bigMap.updateRing(DataManager.getInstance().cityBattleData.trackData.stag);
		}
		
		// 结算信息
		public static function sm_WARC_J(obj:Object):void{
			DataManager.getInstance().cityBattleData.loadData_J(obj);
			UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_FINAL);
			UIManager.getInstance().cityBattleMeg.updateInfo();
		}
		
		// 领取税费
		public static function cm_WARC_D():void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_D);
		}
		
		// 发起挑战
		public static function cm_WARC_Z(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_Z+type);
		}
		
		// 购买BUFF
		public static function cm_WARC_B(buffid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_B+buffid);
		}
		
		// 领取占领奖励
		public static function cm_WARC_M(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_WARC_M+id);
		}
		
		// 领取占领奖励
		public static function sm_WARC_M(obj:Object):void{
			var id:int = obj.wjlid;
			if(UIManager.getInstance().cityBattleReward){
				UIManager.getInstance().cityBattleReward.flyItem(id);
			}
		}
	}
}
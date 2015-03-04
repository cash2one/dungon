package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.data.guildBattle.GuildBattleData;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_GuildBattle
	{
		public static function sm_UNZ_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.GUILD_BATTLE, CmdEnum.SM_UNZ_I);
			DataManager.getInstance().guildBattleData.loadData_I(obj);
			UIManager.getInstance().guildBattleWnd.updateGuildBattleInfo();
		}
		
		public static function cm_UNZ_I():void{
			NetGate.getInstance().send(CmdEnum.CM_UNZ_I);
		}
		
		public static function sm_UNZ_L(obj:Object):void{
			DataManager.getInstance().guildBattleData.loadData_L(obj);
			UIManager.getInstance().guildBattleRankWnd.updateInfo();
		}
		
		public static function cm_UNZ_L(type:int, begin:int, end:int):void{
			NetGate.getInstance().send(CmdEnum.CM_UNZ_L + type + "," + begin + "," + end);
		}
		
		public static function sm_UNZ_U(obj:Object):void{
			if(DataManager.getInstance().guildBattleData.ctype == obj.utype){
				DataManager.getInstance().guildBattleData.loadData_U(obj);
				if(!UIManager.getInstance().isCreate(WindowEnum.GUILD_BATTLE_TRACK)){
					UIManager.getInstance().creatWindow(WindowEnum.GUILD_BATTLE_TRACK)
				}
				UIManager.getInstance().guildBattleRankTrack.show();
				UIManager.getInstance().guildBattleRankTrack.updateInfo();
			}else{
				cm_UNZ_U(DataManager.getInstance().guildBattleData.ctype, 1, GuildBattleData.TRACK_MAX_COUNT);
			}
		}
		
		public static function cm_UNZ_U(type:int, begin:int, end:int):void{
			NetGate.getInstance().send(CmdEnum.CM_UNZ_U + type + "," + begin + "," + end);
		}
		
		public static function cm_UNZ_E():void{
			NetGate.getInstance().send(CmdEnum.CM_UNZ_E);
		}
		
		public static function cm_UNZ_Q():void{
			NetGate.getInstance().send(CmdEnum.CM_UNZ_Q);
		}
		
		public static function sm_UNZ_N(obj:Object):void{
			DataManager.getInstance().guildBattleData.loadData_N(obj);
			UILayoutManager.getInstance().show(WindowEnum.GUILD_MESSAGE);
			UIManager.getInstance().guildBattleMegWnd.updateInfo();
		}
	}
}
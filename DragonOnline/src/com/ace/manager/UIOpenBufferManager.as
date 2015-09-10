package com.ace.manager
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.leyou.data.payrank.PayRankData;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.cmd.Cmd_Achievement;
	import com.leyou.net.cmd.Cmd_Active;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.net.cmd.Cmd_BlackStore;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.net.cmd.Cmd_CLI;
	import com.leyou.net.cmd.Cmd_Collection;
	import com.leyou.net.cmd.Cmd_FCZ;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_GBUY;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.net.cmd.Cmd_HCCZ;
	import com.leyou.net.cmd.Cmd_Invest;
	import com.leyou.net.cmd.Cmd_KF;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.net.cmd.Cmd_Mail;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.net.cmd.Cmd_PM;
	import com.leyou.net.cmd.Cmd_PayRank;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.net.cmd.Cmd_Rank;
	import com.leyou.net.cmd.Cmd_Seven;
	import com.leyou.net.cmd.Cmd_TaskMarket;
	import com.leyou.net.cmd.Cmd_TobeStrong;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.net.cmd.Cmd_Worship;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.ui.collection.CollectionWnd;
	
	import flash.display.DisplayObject;
	

	public class UIOpenBufferManager
	{
		//------------------------------------------------------------
		// 协议缓冲  windowEnum -- [CmdEnum]
		private var protocolDic:Object = {};
		
		private var waitWndPageIndex:Object = {};
		
		private static var instance:UIOpenBufferManager;
		
		public static function getInstance():UIOpenBufferManager{
			if(null == instance){
				instance = new UIOpenBufferManager();
			}
			return instance;
		}
		
		public function open(wndKey:int, pageIndex:int=-1):void{
			var wnd:Object=UIManager.getInstance().creatWindow(wndKey);
			if(wnd.visible) {
				UILayoutManager.getInstance().hide(wndKey);
//				trace("-----------wnd visible is true");
				return;
			}
			if(-1 != pageIndex){
				waitWndPageIndex[wndKey] = pageIndex;
			}
			switch(wndKey){
				case WindowEnum.MAILL:
					if(!contains(wndKey, CmdEnum.SM_SMA_I)){
						Cmd_Mail.cm_MailMsg_I();
						addCmd(wndKey, CmdEnum.SM_SMA_I);
					}
					break;
				case WindowEnum.MARKET:
					if(!contains(wndKey, CmdEnum.SM_MAK_I)){
						Cmd_Market.cm_Mak_I(1);
						addCmd(wndKey, CmdEnum.SM_MAK_I);
					}
					break;
				case WindowEnum.AUTION:
					if(!contains(wndKey, CmdEnum.SM_CGT_I)){
						Cmd_Aution.cm_Aution_I(0);
						addCmd(wndKey, CmdEnum.SM_CGT_I);
					}
					break;
				case WindowEnum.FRIEND:
					if(!contains(wndKey, CmdEnum.SM_FND_I)){
						Cmd_Friend.cm_FriendMsg_I(1);
						Cmd_Friend.cm_FriendMsg_I(2);
						Cmd_Friend.cm_FriendMsg_I(3);
						addCmd(wndKey, CmdEnum.SM_FND_I);
					}
					break;
				case WindowEnum.ACTIVE:
					if(!contains(wndKey, CmdEnum.SM_HYD_I)){
						Cmd_Active.cm_HYD_I();
						addCmd(wndKey, CmdEnum.SM_HYD_I);
					}
					break;
				case WindowEnum.GUILD_BATTLE:
					if(!contains(wndKey, CmdEnum.SM_UNZ_I)){
						Cmd_GuildBattle.cm_UNZ_I();
						addCmd(wndKey, CmdEnum.SM_UNZ_I);
					}
					break;
//				case WindowEnum.EXPCOPY:
//					if(!contains(wndKey, CmdEnum.SM_EXPC_I)){
//						Cmd_EXPC.cm_Exp_I();
//						addCmd(wndKey, CmdEnum.SM_EXPC_I);
//					}
//					break;
//				case WindowEnum.FIELDBOSS:
//					if(!contains(wndKey, CmdEnum.SM_YBS_I)){
//						Cmd_YBS.cm_YBS_I();
//						addCmd(wndKey, CmdEnum.SM_YBS_I);
//					}
//					break;
//				case WindowEnum.BOSSCOPY:
//					if(!contains(wndKey, CmdEnum.SM_BCP_I)){
//						Cmd_BCP.cm_BCP_I();
//						addCmd(wndKey, CmdEnum.SM_BCP_I);
//					}
//					break;
//				case WindowEnum.STORYCOPY:
//					if(!contains(wndKey, CmdEnum.SM_SCP_I)){
//						Cmd_SCP.cm_SCP_I();
//						addCmd(wndKey, CmdEnum.SM_SCP_I);
//					}
//					break;
				case WindowEnum.TOBE_STRONG:
					if(!contains(wndKey, CmdEnum.SM_RISE_I)){
						Cmd_TobeStrong.cm_RISE_I();
						addCmd(wndKey, CmdEnum.SM_RISE_I);
					}
					break;
				case WindowEnum.WELFARE:
					if(!contains(wndKey, CmdEnum.SM_SIGN_I)){
						Cmd_Welfare.cm_SIGN_I();
						Cmd_Welfare.cm_OL_I();
						Cmd_Welfare.cm_ULV_I();
						addCmd(wndKey, CmdEnum.SM_SIGN_I);
					}
					break;
				case WindowEnum.WORSHIP:
					if(!contains(wndKey, CmdEnum.SM_WSP_I)){
						Cmd_Worship.cm_WSP_I();
						addCmd(wndKey, CmdEnum.SM_WSP_I);
					}
					break;
				case WindowEnum.LUCKDRAW:
					if(!contains(wndKey, CmdEnum.SM_LBOX_I)){
						Cmd_LDW.cm_LDW_I();
						Cmd_LDW.cm_LDW_H(1);
						Cmd_LDW.cm_LDW_H(2);
						addCmd(wndKey, CmdEnum.SM_LBOX_I);
					}
					break;
				case WindowEnum.FARM:
					if(!contains(wndKey, CmdEnum.SM_FAM_I)){
						Cmd_Farm.cm_FAM_I();
						addCmd(wndKey, CmdEnum.SM_FAM_I);
					}
					break;
				case WindowEnum.RANK:
					if(!contains(wndKey, CmdEnum.SM_RAK_Y)){
						Cmd_Rank.cm_RAK_Y();
						addCmd(wndKey, CmdEnum.SM_RAK_Y);
					}
					break;
				case WindowEnum.ACHIEVEMENT:
					var serverId:String = DataManager.getInstance().achievementData.serverId;
					if((null != serverId) && ("" != serverId)){
						if(!contains(wndKey, CmdEnum.SM_HSY_I)){
							Cmd_Achievement.cm_HSY_I(serverId);
							addCmd(wndKey, CmdEnum.SM_HSY_I);
						}
					}else{
						if(!contains(wndKey, CmdEnum.SM_HSY_S)){
							Cmd_Achievement.cm_HSY_S();
							addCmd(wndKey, CmdEnum.SM_HSY_S);
						}
					}
					break;
				case WindowEnum.FIRST_RETURN:
					if(!contains(wndKey, CmdEnum.SM_FCZ_I)){
						Cmd_FCZ.cm_FCZ_I();
						addCmd(wndKey, CmdEnum.SM_FCZ_I);
					}
					break;
				case WindowEnum.PAY_RANK:
					if(!contains(wndKey, CmdEnum.SM_CRANK_I)){
						Cmd_PayRank.cm_PayRank_I(1, 1, PayRankData.RANK_MAX_NUM);
						addCmd(wndKey, CmdEnum.SM_CRANK_I);
					}
					break;
				case WindowEnum.AREA_CELEBRATE:
					if(!contains(wndKey, CmdEnum.SM_KF_I)){
						Cmd_KF.cm_KF_I(1);
						Cmd_KF.cm_KF_I(2);
						Cmd_KF.cm_KF_I(3);
						Cmd_KF.cm_KF_I(4);
						Cmd_KF.cm_KF_I(5);
						addCmd(wndKey, CmdEnum.SM_KF_I);
					}
					break;
				case WindowEnum.SEVENDAY:
					if(!contains(wndKey, CmdEnum.SM_SEVD_I)){
						var showDay:int = DataManager.getInstance().sevenDayData.currentDay;
						Cmd_Seven.cm_SEVD_I(showDay);
						addCmd(wndKey, CmdEnum.SM_SEVD_I);
					}
					break;
				case WindowEnum.PAY_PROMOTION:
					if(!contains(wndKey, CmdEnum.SM_FANL_I)){
						Cmd_Fanl.cm_Fanl_I();
						addCmd(wndKey, CmdEnum.SM_FANL_I);
					}
					break;
				case WindowEnum.INVEST:
					if(!contains(wndKey, CmdEnum.SM_TZ_I)){
						Cmd_Invest.cm_TZ_I();
						addCmd(wndKey, CmdEnum.SM_TZ_I);
					}
					break;
				case WindowEnum.VIP:
					if(contains(wndKey, CmdEnum.SM_VIP_I)){
						addCmd(wndKey, CmdEnum.SM_VIP_I);
						Cmd_Vip.cm_VIP_I();
					}
					break;
				case WindowEnum.COLLECTION:
					if(!contains(WindowEnum.COLLECTION, CmdEnum.SM_COL_I)){
						Cmd_Collection.cm_COL_I();
						(UIManager.getInstance().creatWindow(WindowEnum.COLLECTION) as CollectionWnd).showCollectionMap();
						addCmd(wndKey, CmdEnum.SM_COL_I);
					}
					break;
				case WindowEnum.INTEGRAL:
					if(!contains(WindowEnum.INTEGRAL, CmdEnum.SM_CLI_I)){
						Cmd_CLI.cm_CLI_I();
						addCmd(wndKey, CmdEnum.SM_CLI_I);
					}
					break;
				case WindowEnum.ABIDE_PAY:
					if(!contains(WindowEnum.ABIDE_PAY, CmdEnum.SM_CCZ_I)){
						Cmd_CCZ.cm_CCZ_I();
						addCmd(wndKey, CmdEnum.SM_CCZ_I);
					}
					break;
				case WindowEnum.GROUP_BUY:
					if(!contains(WindowEnum.GROUP_BUY, CmdEnum.SM_GBUY_I)){
						Cmd_GBUY.cm_GBUY_I();
						addCmd(wndKey, CmdEnum.SM_GBUY_I);
					}
					break;
				case WindowEnum.VENDUE:
					if(!contains(WindowEnum.VENDUE, CmdEnum.SM_PM_I)){
						Cmd_PM.cm_PM_I();
						addCmd(wndKey, CmdEnum.SM_PM_I);
					}
					break;
				case WindowEnum.BOSS:
					if(!contains(WindowEnum.BOSS, CmdEnum.SM_YBS_L)){
						Cmd_YBS.cm_YBS_L();
						addCmd(wndKey, CmdEnum.SM_YBS_L);
					}
					break;
				case WindowEnum.DRAGON_BALL:
					if(!contains(WindowEnum.DRAGON_BALL, CmdEnum.SM_LONGZ_I)){
						Cmd_Longz.cm_Longz_I();
						addCmd(wndKey, CmdEnum.SM_LONGZ_I);
					}
					break;
				case WindowEnum.BLACK_STROE:
					if(!contains(WindowEnum.BLACK_STROE, CmdEnum.SM_BMAK_I)){
						Cmd_BlackStore.cm_BMAK_I(0);
						addCmd(wndKey, CmdEnum.SM_BMAK_I);
					}
					break;
				case WindowEnum.PET:
					if(!contains(WindowEnum.PET, CmdEnum.SM_PET_L)){
						Cmd_Pet.cm_PET_L();
						addCmd(wndKey, CmdEnum.SM_PET_L);
					}
					break;
				case WindowEnum.TASK_MARKET:
					if(!contains(WindowEnum.TASK_MARKET, CmdEnum.SM_YD_I)){
						Cmd_TaskMarket.cm_TaskMarket_I();
						addCmd(wndKey, CmdEnum.SM_YD_I);
					}
					break;
				case WindowEnum.COMBINE_RECHARGE:
					if(!contains(WindowEnum.COMBINE_RECHARGE, CmdEnum.SM_HCCZ_I)){
						Cmd_HCCZ.cm_HCCZ_I();
						addCmd(wndKey, CmdEnum.SM_HCCZ_I);
					}
					break;
			}
		}
		
		public function addCmd(wndKey:int, ...cmds):void{
//			trace("--------------send cmd wndKey = "+ wndKey +"--cmds = ("+ cmds+")");
			var cmdArr:Array = protocolDic[wndKey];
			if(null == cmdArr){
				cmdArr = [];
				protocolDic[wndKey] = cmdArr;
			}
			for each(var cmd:String in cmds){
				if(!contains(wndKey, cmd)){
					cmdArr.push(cmd);
				}
			}
			checkLoadingWnd();
		}
		
		private function contains(wndKey:int, cmd:String):Boolean{
			var cmdArr:Array = protocolDic[wndKey];
			if(null == cmdArr){
				return false;
			}
			return (-1 != cmdArr.indexOf(cmd));
		}
		
		public function removeCmd(wndKey:int, cmd:String):void{
			var cmdArr:Array = protocolDic[wndKey];
			if(null == cmdArr){
				return; // 未添加请求
			}
			var index:int = cmdArr.indexOf(cmd);
			if(-1 == index){
				return; // 未添加请求
			}
			cmdArr.splice(index, 1);
			checkLoadingWnd();
			if(cmdArr.length <= 0){
				UILayoutManager.getInstance().show(wndKey);
				if(waitWndPageIndex.hasOwnProperty(wndKey)){
					var pidx:int = waitWndPageIndex[wndKey];
					delete waitWndPageIndex[wndKey];
					var wnd:DisplayObject = UIManager.getInstance().creatWindow(wndKey);
					if(wnd.hasOwnProperty("changeToIndex")){
						wnd["changeToIndex"](pidx);
					}
				}
			}
		}
		
		private function checkLoadingWnd():void{
			var loading:Boolean = false;
			for(var key:String in protocolDic){
				var cmds:Array = protocolDic[key];
				if((null != cmds) && (0 != cmds.length)){
					loading = true;
					break;
				}
			}
			UIManager.getInstance().loadingWnd.visible = loading;
		}
	}
}

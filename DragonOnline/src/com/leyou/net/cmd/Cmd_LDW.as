package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_LDW
	{
//		--------------------------------------------------------------------------------
//		抽奖信息
//		上行:lbox|I
//		下行:lbox|{"mk":"I", "item_d":[cc,mc,cnum,mnum],"dlist":[[itemid,num],[itemid,num]...]}  
//			item_d    -- 道具抽奖信息
//				cc    -- 当前次数
//				mc    -- 总次数
//				cnum  -- 当前道具数量
//				mnum  -- 消耗道具数量
//			dlist -- 抽奖列表 14个固定
//			itemid -- 道具id
//			num    -- 道具数量
		public static function sm_LDW_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.LUCKDRAW, CmdEnum.SM_LBOX_I);
			DataManager.getInstance().luckdrawData.loadData_I(obj);
			UIManager.getInstance().luckDrawWnd.updateInfo_I();
		}
		
		public static function cm_LDW_I():void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_I);
		}
		
		
//		--------------------------
//		开始抽奖
//		上行: lbox|Ddtype
//		下行: lbox|{"mk":"D", jlpos:[pos, ...] }
//			jlpos -- 中奖道具位置 1 或 10个
//			pos 位置 从1-14
//		    type -- 抽奖类型(1道具抽奖 2元宝1次 3元宝10次)
		public static function sm_LDW_D(obj:Object):void{
			DataManager.getInstance().luckdrawData.loadData_D(obj);
			UIManager.getInstance().luckDrawWnd.startLuckDraw();
		}
		
		public static function cm_LDW_D(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_D+type);
		}
		
//		--------------------------
//		领取奖励
//		上行: lbox|J
		public static function cm_LDW_J():void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_J);
		}
		
//		--------------------------
//		抽奖历史信息
//		上行：lbox|Hhtype
//		下行: lbox|{"mk":"H", "htype":num,"hlist":[[dtime,name,itemid,num],...]}
//			htype  -- 记录类型 (1 个人 2全服)
//				hlist  -- 记录信息列表 最多20条
//			dtime -- 抽奖时间
//				name  -- 抽奖人名字
//				itemid -- 中奖道具
//				num    --  道具数量
		public static function sm_LDW_H(obj:Object):void{
			DataManager.getInstance().luckdrawData.loadData_H(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.LUCKDRAW)){
				UIManager.getInstance().luckDrawWnd.updateInfo_H();
			}
		}
		
		public static function cm_LDW_H(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_H+type);
		}
		
//		--------------------------
//		打开巨龙仓库
//		上行：lbox|B
//		下行：lbox|{"mk":"B",,"s":[{pos,itemid,num},...]}
//		pos --格子位置 从1开始
		public static function sm_LDW_B(obj:Object):void{
			DataManager.getInstance().luckdrawData.loadData_B(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.LUCKDRAW_STORE)){
				UIManager.getInstance().luckPackWnd.updateInfo_B();
			}
		}
		
		public static function cm_LDW_B():void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_B);
		}
		
//		--------------------------
//		整理巨龙仓库
//		上行：lbox|Z
		public static function cm_LDW_Z():void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_Z);
		}
		
//		--------------------------
//		提取巨龙仓库道具
//		上行：lbox|Tpos,dpos 
//			pos --(0 提取全部 其他为对应格子道具)
//			dpos  -- 目标位置 如果没有表示服务器默认位置
		public static function cm_LDW_T(pos:int, dpos:int=-1):void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_T + pos + ","+ dpos);
		}
		
//		--------------------------
//		移动巨龙仓库道具
//		上行：lbox|Vpos1,pos2 
//			pos1 移动到 pos2
		public static function cm_LDW_V(pos1:int, pos2:int):void{
			NetGate.getInstance().send(CmdEnum.CM_LBOX_V + pos1 + ","+ pos2);
		}
		
		public static function sm_LDW_U(obj:Object):void{
			if(UIManager.getInstance().isCreate(WindowEnum.LUCKDRAW)){
				if(UIManager.getInstance().luckDrawWnd.visible){
					DataManager.getInstance().luckdrawData.loadData_U(obj);
					UIManager.getInstance().luckDrawWnd.updateInfo_H();
				}
			}
		}
		
	}
}
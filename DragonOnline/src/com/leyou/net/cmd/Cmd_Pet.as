package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	
	public class Cmd_Pet
	{
		public static function sm_PET_L(obj:Object):void{
			DataManager.getInstance().petData.loadData_L(obj);
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.PET, CmdEnum.SM_PET_L);
			UIManager.getInstance().petWnd.updatePetList();
		}
		
		public static function cm_PET_L():void{
			NetGate.getInstance().send(CmdEnum.CM_PET_L);
		}
		
		public static function sm_PET_I(obj:Object):void{
			DataManager.getInstance().petData.loadData_I(obj);
			UIManager.getInstance().petWnd.updatePetInfo();
		}
		
		public static function cm_PET_I(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_I+pid);
		}
		
		// 招募
		public static function sm_PET_E(obj:Object):void{
			var pid:int = obj.rst;
			UIManager.getInstance().petWnd.updateCallIn();
		}
		
		public static function cm_PET_E(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_E+pid);
		}
		
		// 出战
		public static function sm_PET_C(obj:Object):void{
			var pid:int = obj.rst;
		}
		
		public static function cm_PET_C(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_C+pid);
		}
		
		// 收回
		public static function sm_PET_B(obj:Object):void{
			var pid:int = obj.rst;
		}
		
		public static function cm_PET_B(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_B+pid);
		}
		
		// 任务
		public static function sm_PET_T(obj:Object):void{
			DataManager.getInstance().petData.loadData_T(obj);
			UIManager.getInstance().petWnd.updatePetInfo();
		}
		
		public static function cm_PET_T():void{
			NetGate.getInstance().send(CmdEnum.CM_PET_T);
		}
		
		// 接取任务 1-经验 2-亲密度
		public static function cm_PET_A(type:int, pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_A+type+","+pid);
		}
		
		// 交任务
		public static function cm_PET_D(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_D+pid);
		}
		
		// 使用道具 1-经验 2-亲密度 3-升星
		public static function cm_PET_U(type:int, pid:int, num:int=0):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_U+type+","+pid+","+num);
		}
		
		// 宠物亲密度礼物
		public static function cm_PET_G(pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_G+pid);
		}
		
		//		佣兵技能学习/升级
		//		-------------------------------------------------------------------------------- 
		//		上行：pet|Spid,psklid,sklpos
		//		psklid -- 宠物技能组id
		//		sklpos -- 技能位置（1开始）
		public static function cm_PET_S(pid:int, sid:int, spos:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_S+pid+","+sid+","+spos);
		}
		
		//		佣兵遗忘技能
		//		上行：pet|Fpid,sklpos
		public static function cm_PET_F(pid:int, spos:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PET_F+pid+","+spos);
		}
	}
}
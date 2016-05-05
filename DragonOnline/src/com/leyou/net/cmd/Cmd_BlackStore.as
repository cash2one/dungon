package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_BlackStore {
		public static function cm_BMAK_A():void {
			NetGate.getInstance().send(CmdEnum.CM_BMAK_A);
		}

		public static function sm_BMAK_A(obj:Object):void {
			DataManager.getInstance().blackStoreData.loadData_A(obj);
			if (DataManager.getInstance().blackStoreData.isActive()) {
				UIManager.getInstance().rightTopWnd.active("blackStoreBtn");
			} else {
				UIManager.getInstance().rightTopWnd.deactive("blackStoreBtn");
				if (UIManager.getInstance().isCreate(WindowEnum.BLACK_STROE)) {
					UILayoutManager.getInstance().hide(WindowEnum.BLACK_STROE);
				}
			}
			
			if (!UIManager.getInstance().isCreate(WindowEnum.SELLEXPEFFECT)) {
				UIManager.getInstance().creatWindow(WindowEnum.SELLEXPEFFECT);
			}

			UIManager.getInstance().sellExpEffect.updateBlackStore(obj);
		}

		public static function cm_BMAK_I(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_BMAK_I + type);
		}

		public static function sm_BMAK_I(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.BLACK_STROE, CmdEnum.SM_BMAK_I);
			DataManager.getInstance().blackStoreData.loadData_I(obj);
			if (!UIManager.getInstance().isCreate(WindowEnum.BLACK_STROE)) {
				UIManager.getInstance().creatWindow(WindowEnum.BLACK_STROE);
			}

			UIManager.getInstance().blackStoreWnd.updateInfo();
		}

		public static function cm_BMAK_B(type:int, pos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_BMAK_B + type + "," + pos);
		}

		public static function sm_BMAK_B(obj:Object):void {
			var type:int=obj.ltype;
			var pos:int=obj.pos;
			UIManager.getInstance().blackStoreWnd.flyItem(type, pos);
		}

		public static function cm_BMAK_F(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_BMAK_F + type);
		}
	}
}

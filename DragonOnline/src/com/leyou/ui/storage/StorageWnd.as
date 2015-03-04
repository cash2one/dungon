package com.leyou.ui.storage {
	
	
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.net.cmd.Cmd_Store;

	public class StorageWnd extends StorageWndView {


		public function StorageWnd() {
			super();
			this.init();
			this.initData(MyInfoManager.getInstance().storeItems);
		}

		private function init():void {

			//			for (var i:int=1; i < 10; i++) {
			//				var tinfo:StoreInfo=new StoreInfo();
			//				tinfo.info=new TItem();
			//				tinfo.info.id=i;
			//				tinfo.info.icon=i;
			//				tinfo.info.name=i*1000;
			//				
			//				tinfo.aid=i;
			//				tinfo.pos=i;
			//				
			//				MyInfoManager.getInstance().storeItems.push(tinfo);
			//			}

			//			NetGate.getInstance().send("bag|2|A10001,6");
			//			NetGate.getInstance().send("bag|2|A10002,2");
			//			NetGate.getInstance().send("bag|2|A10003,3");
			//			NetGate.getInstance().send("bag|2|A10004,2");

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			
			UIManager.getInstance().hideWindow(WindowEnum.EQUIP);
			UIManager.getInstance().hideWindow(WindowEnum.ROLE);
			UIManager.getInstance().hideWindow(WindowEnum.SHOP);
			
			Cmd_Store.cm_storeData();
			Cmd_Store.cm_storeOpenGrid();

//			if (null != UIManager.getInstance().shopWnd)
//				UIManager.getInstance().shopWnd.hide();
//
//			if (null != UIManager.getInstance().autionWnd)
//				UIManager.getInstance().autionWnd.hide();
//			
//			UIManager.getInstance().roleWnd.hide();
		}

		override public function hide():void{
			super.hide();
			
//			UILayoutManager.getInstance().composingWnd(WindowEnum.STOREGE);
			UILayoutManager.getInstance().composingWnd(WindowEnum.BACKPACK);
		}

		override public function get height():Number{
			return 525;
		}

	}
}

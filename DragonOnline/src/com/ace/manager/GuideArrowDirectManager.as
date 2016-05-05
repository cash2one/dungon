package com.ace.manager {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.table.TSeGuild;
	import com.ace.ui.auto.AutoWindow;
	import com.leyou.ui.message.child.GuidePointExt;
	import com.leyou.ui.welfare.WelfareWnd;

	import flash.display.DisplayObjectContainer;

	public class GuideArrowDirectManager {


		private var arrowArr:Array=[];

		private static var _instance:GuideArrowDirectManager;

		public static function getInstance():GuideArrowDirectManager {
			if (_instance == null)
				_instance=new GuideArrowDirectManager();

			return _instance;
		}

		public function addArrow(tinfo:TSeGuild, dis:AutoWindow):void {

			if (this.arrowArr[tinfo.uiId] == null && dis.visible) {
				var gp:GuidePointExt=new GuidePointExt("config/ui/introduction/arrowWnd.xml", int(tinfo.arrowType));

				if (int(tinfo.uiId) == WindowEnum.WELFARE && int(tinfo.tagId) == 2)
					gp.updateInfoExt(tinfo, WelfareWnd(dis).getUIbyID2(tinfo.closeAct));
				else
					gp.updateInfoExt(tinfo, dis.getUIbyID(tinfo.closeAct));

//				gp.addToContainer(LayerManager.getInstance().guildeLayer);
				gp.addToContainer(dis);

				this.arrowArr[tinfo.uiId]=(gp);
			}

		}

		public function delArrow(uid:String):void {
			if (this.arrowArr[uid] == null)
				return;

//			LayerManager.getInstance().guildeLayer.removeChild(this.arrowArr[uid]);
			this.arrowArr[uid].parent.removeChild(this.arrowArr[uid]);
			this.arrowArr[uid]=null;
			delete this.arrowArr[uid];
		}

		public function reSize():void {

			var gm:GuidePointExt;
			for each (gm in this.arrowArr) {
				gm.resize();
			}

		}
	}
}

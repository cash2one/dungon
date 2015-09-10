package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.pkCopy.child.DungeonTZRender;
	import com.leyou.ui.pkCopy.child.DungeonTzGrid;

	public class TipsTzWnd extends AutoSprite implements ITip {

		private var timeLbl:Label;
		private var ruleLbl:Label;

		private var gridList:Vector.<DungeonTzGrid>;

		public function TipsTzWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsTzWnd.xml"));
			this.init();
			 
		}

		private function init():void {

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.ruleLbl.height=139;
			this.ruleLbl.width=256;
			this.ruleLbl.wordWrap=true;
			this.ruleLbl.multiline=true;
			
			this.gridList=new Vector.<DungeonTzGrid>();

		}


		public function updateInfo(o:Object):void {


			var tinfo:TTzActiive=TableManager.getInstance().getTzActiveByID(int(o));

			this.ruleLbl.htmlText=tinfo.des1 + "";
			this.timeLbl.text=tinfo.time.replace("|", "\-").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2");

			var dgrid:DungeonTzGrid;
			for each (dgrid in this.gridList) {
				this.removeChild(dgrid);
			}

			this.gridList.length=0;

			var i:int=0;
			for (i=0; i < 5; i++) {

				if (tinfo["item" + (i + 1)] == 0)
					continue;

				dgrid=new DungeonTzGrid();
				dgrid.updataInfo(TableManager.getInstance().getItemInfo(tinfo["item" + (i + 1)]));

				dgrid.y=37;
				dgrid.x=42 + i * dgrid.width;

				this.addChild(dgrid);
				this.gridList.push(dgrid);
			}


		}

		public function get isFirst():Boolean {
			return true;
		}

		override public function get width():Number {
			return 280;
		}

		override public function get height():Number {
			return 302;
		}


	}
}

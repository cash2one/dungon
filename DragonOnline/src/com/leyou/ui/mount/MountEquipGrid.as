package com.leyou.ui.mount {

	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.ui.role.child.children.EquipGrid;

	import flash.geom.Point;

	public class MountEquipGrid extends EquipGrid {

		public function MountEquipGrid() {
			super();
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_MOUNT;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.bgBmp.alpha=0;

			this.mouseEnabled=true;
			this.mouseChildren=true;

			this.doubleClickEnabled=true;
		}

		override public function updataInfo(info:Object):void {
			super.updataInfo(info);
			this.doubleClickEnabled=true;
		}

		override public function switchHandler(fromItem:GridBase):void {
			if(!this.doubleClickEnabled)
				return ;
			
			
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (fromItem.dataId == -1)
					return;

				if (fromItem.data.info.classid != ItemEnum.ITEM_TYPE_EQUIP)
					return;

				if (fromItem.data.info.subclassid != this.dataId)
					return;

				var tArr:Array=[13, 14, 15, 16];
				var tpos:int=tArr.indexOf(fromItem.data.info.subclassid)

				Cmd_Bag.cm_bagMoveTo(fromItem.dataId, 40, tpos);
			}

		}

		override public function doubleClickHandler():void {

			if (this.isEmpty == true)
				return;

			if(!this.doubleClickEnabled)
				return ;
			
			var i:int=MyInfoManager.getInstance().getBagEmptyGridIndex();

			if (i == -1) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
				return;
			}

			Cmd_Mount.cmMouEquip([13, 14, 15, 16].indexOf(this.dataId));

		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if(!this.doubleClickEnabled)
				return ;
			
			
			var p:Point=LayerManager.getInstance().windowLayer.globalToLocal(this.parent.localToGlobal(new Point(this.x + 40, this.y)));

			UIManager.getInstance().selectWnd.type=1;
			UIManager.getInstance().selectWnd.showPanel(this.dataId, -1, p);

		}

	}
}

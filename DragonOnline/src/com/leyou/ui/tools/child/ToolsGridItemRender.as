package com.leyou.ui.tools.child {

	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LayerManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.layer.SceneLayer;
	import com.leyou.net.cmd.Cmd_Link;
	import com.leyou.utils.FilterUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ToolsGridItemRender extends AutoSprite {

		private var GridList:Array=[];

		private var selectIndex:int=0;

		private var sprContiner:Sprite;

		private var gridlist:Array;

		private var pos:int=-1;

		public function ToolsGridItemRender() {
			super(new XML);
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			sprContiner=new Sprite();
			this.addChild(sprContiner);

			var bg:Sprite=new Sprite();

			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0, 0, 43, 195);
			bg.graphics.endFill();

			this.sprContiner.addChild(bg);

			bg.alpha=0.5;

			this.sprContiner.mouseChildren=this.sprContiner.mouseEnabled=true;
			this.sprContiner.name="continer";

			this.hide();
			this.addEventListener(MouseEvent.CLICK, onClick);
//			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseClick);

		}

		private function onMouseClick(e:MouseEvent):void {
//			if (e.target is SceneLayer)
//				return;

//			trace(e.target, e.currentTarget, this.sprContiner.contains(e.target as DisplayObject), this.sprContiner.contains(e.target as DisplayObjectContainer));

			if (!this.contains(e.target as DisplayObject) && !(e.target is ShortcutsGrid) && this.visible)
				this.hide();
//			
//			if (e.target as Sprite)
//				this.hide();
		}

		public function reupdateList():void {
			this.updateGridList(this.gridlist, this.pos);
		}

		public function updateGridList(vec:Array, pos:int):void {

			this.pos=pos;
			this.gridlist=vec;

			var g:ShortcutsGrid;
			for each (g in this.GridList) {
				this.sprContiner.removeChild(g);
			}

			this.GridList.length=0;

			var aid:int=0;

			var i:int=0;
			var j:int=0;
			var num:int=0;
			for (i=0; i < vec.length; i++) {

				if (vec[i].bind == "1")
					continue;

				g=new ShortcutsGrid();

				g.BgBmpalpha=0;

				g.updateYaoshui(vec[i]);
				g.y=2 + j * 38;
				g.x=2;
				g.name="g_" + vec[i].id;

				num=MyInfoManager.getInstance().getBagItemNumByName(vec[i].name);

				g.numLblText=num + "";

				g.mouseChildren=false;
				g.mouseEnabled=true;

				g.canMove=false;
				g.isLock=true;

				this.sprContiner.addChild(g);
				this.GridList.push(g);

				j++;
			}
		}

		private function onClick(e:MouseEvent):void {

			var g:ShortcutsGrid=e.target as ShortcutsGrid;
			if (g.ItemNum <= 0) {

//				var aid:int=0;
//				if (UIManager.getInstance().toolsWnd.shortCutGrid[pos].dataId != -1) {
//					aid=MyInfoManager.getInstance().bagItems[UIManager.getInstance().toolsWnd.shortCutGrid[pos].dataId].aid;
//				} else {
//					aid=UIManager.getInstance().toolsWnd.shortCutGrid[pos].autoid;
//				}
//
//				aid=(aid % 2 == 0 ? aid : aid - 1);
//				trace(aid, pos);
//
//				var item:TItemInfo=TableManager.getInstance().getItemInfo(aid);
//				var num:int=0;
//				g.updateYaoshui(item);

//			num=MyInfoManager.getInstance().getBagItemNumByName(item.name);
//			
//			if (num <= 0) {
//				g.filters=[FilterUtil.enablefilter]
//				g.numLblText="";
//			} else
//				g.numLblText=num + "";
//			
			} else
				Cmd_Link.cm_linkSet(pos, 2, int(g.name.split("_")[1]));

			this.hide();
		}

		public function get currentSelectIndex():int {
			return this.selectIndex;
		}

		override public function show():void {
			super.show();
			LayerManager.getInstance().windowLayer.stage.addEventListener(MouseEvent.CLICK, onMouseClick);

		}

		override public function hide():void {
			super.hide();
			LayerManager.getInstance().windowLayer.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}

	}
}

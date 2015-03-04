package com.leyou.ui.role.child {


	import com.ace.config.Core;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.ui.role.child.children.EquipGrid;
	import com.leyou.ui.role.child.children.EquipSelectGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SelectWnd extends AutoWindow {

		private var leftBtn:ImgButton;
		private var rightBtn:ImgButton;
		private var pageLbl:Label;
		private var titleNameLbl:Label;

		private var gridVec:Vector.<EquipSelectGrid>
		private var currentIndex:int=0;
		private var currentPage:int=0;
		private var PageCount:int=1;

		private var pos:int=-1;
		private var pro:int=-1;

		/**
		 *0,人物;1,坐骑;2,宝石
		 */
		public var type:int=0;

		private var dataArr:Array=[];
		
		public var succEffect:Function;
			
			

		public function SelectWnd() {
			super(LibManager.getInstance().getXML("config/ui/role/selectWnd.xml"));
			this.init();
		}

		private function init():void {
			this.leftBtn=this.getUIbyID("leftBtn") as ImgButton;
			this.rightBtn=this.getUIbyID("rightBtn") as ImgButton;
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;

			this.leftBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rightBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.gridVec=new Vector.<EquipSelectGrid>();

			var grid:EquipSelectGrid;
			for (var i:int=0; i < 12; i++) {
				grid=new EquipSelectGrid();

				this.addChild(grid);

				grid.x=23 + i % 6 * 42;
				grid.y=69 + Math.floor(i / 6) * 42;

				this.gridVec.push(grid);
			}

			this.clsBtn.y=0;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "leftBtn":
					this.currentPage--;
					break;
				case "rightBtn":
					this.currentPage++;
					break;
			}

			if (this.currentPage >= this.PageCount)
				this.currentPage=this.PageCount - 1;

			if (this.currentPage < 0)
				this.currentPage=0;

			this.updateInfo();
		}

		private function updateInfo():void {

			var grid:EquipSelectGrid;

			var idx:int=0;
			for (var i:int=this.currentPage * 12; i < this.currentPage * 12 + 12; i++) {

				if (this.dataArr[i] == null)
					continue;

				this.gridVec[idx].updataInfo(this.dataArr[i]);
				idx++;
			}

			while (idx < 12) {
				this.gridVec[idx].clearMe();
				idx++;
			}


			this.pageLbl.text=(this.currentPage + 1) + "/" + (this.PageCount < 1 ? 1 : this.PageCount);
		}

		public function showPanel(pro:int, pos:int, p:Point):void {
			if (!this.visible)
				this.show();

			this.x=p.x;
			this.y=p.y - this.height;

			if (pro < 13) {
				if (this.pos == pos)
					return;

				this.pos=pos;
			}

			this.pro=pro;

			this.titleNameLbl.text="选择装备";
			this.currentPage=0;
			this.updateList();
		}

		/**
		 * 宝石
		 * @param pro
		 * @param pos
		 * @param p
		 *
		 */
		public function showGemPanel(pro:int, pos:int, p:Point):void {
			if (!this.visible)
				this.show();

			this.x=p.x;
			this.y=p.y - this.height;

			this.pos=pos;
			this.pro=pro;

			this.titleNameLbl.text="选择宝石";
			this.currentPage=0;
			this.updateList();
		}

		public function updateList():void {

			if (!this.visible)
				return;

			var arr:Array=MyInfoManager.getInstance().bagItems;

			this.dataArr=arr.filter(function(item:Object, i:int, array:Array):Boolean {
				if (item != null) {

					if (type == 2) {

						if (item != null && item.info.classid == 10)
							return true;

					} else if (item != null && item.info.classid == 1 && item.info.subclassid == pro && item.info.level <= Core.me.info.level && (item.info.limit == 0 || item.info.limit == Core.me.info.profession))
						return true;

				}

				return false;
			});

			this.PageCount=(this.dataArr.length % 12 == 0 ? this.dataArr.length / 12 : Math.floor(this.dataArr.length / 12 + 1));

			if (this.currentPage >= this.PageCount)
				this.currentPage=this.PageCount - 1;

			if (this.currentPage < 0)
				this.currentPage=0;

			this.updateInfo();
		}

		public function get position():int {
			if (type == 1)
				return this.pro - 13;

			return this.pos;
		}

		public function set GemSelectIndex(i:int):void {
			this.pro=i;
		}

		public function get GemSelectIndex():int {
			return this.pro;
		}

		override public function hide():void {
			super.hide();
			this.pos=-1;
			this.pro=-1;
		}

	}
}

package com.leyou.ui.medic.childs {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;

	import flash.events.MouseEvent;

	public class RoleMedicRender2 extends AutoSprite {

		private var gridVec:Vector.<RoleMedicRender>;

		public function RoleMedicRender2() {
			super(LibManager.getInstance().getXML("config/ui/medic/roleMedicRender2.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.gridVec=new Vector.<RoleMedicRender>();

		}

		public function updateInfo(o:Array):void {
			var arr:Array;
			var render:RoleMedicRender;

			for each (render in this.gridVec) {
				if (render != null)
					this.removeChild(render);
			}

			this.gridVec.length=0;

			arr=TableManager.getInstance().getItemListArrByClass(ItemEnum.ITEM_TYPE_DAOJU, 29);
			if (arr.length == 0)
				return;

			var c:int=arr.length;
			c=(c % 2 == 0 ? c / 2 : Math.floor(c / 2 + 1));

			for (var i:int=0; i < arr.length; i++) {

				if (arr[i] != null) {

					render=new RoleMedicRender();
					render.updateInfo([arr[i].id, this.getArrNum(o, arr[i].id)]);

					render.x=render.width * (i % c);
					render.y=render.height * Math.floor(i / c);

					this.addChild(render);
					this.gridVec.push(render);
				}

			}

		}

		private function getArrNum(arr:Array, id:int):int {
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i][0] == id)
					return arr[i][1];
			}

			return 0;
		}

		public function selectDefault():void {
			this.gridVec[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function setUseSelectEffect(id:int):Number {

			for (var i:int=0; i < this.gridVec.length; i++) {
				if (this.gridVec[i].id == id) {
					this.gridVec[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					return this.gridVec[i].x;
				}
			}

			return 0;
		}

		override public function get width():Number {
			return Math.ceil(this.gridVec.length / 2) * 58;
		}

	}
}

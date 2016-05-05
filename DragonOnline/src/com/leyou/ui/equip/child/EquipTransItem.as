package com.leyou.ui.equip.child {

	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class EquipTransItem extends AutoSprite {

		private var nameLbl:Label;
		private var attLbl:Label;
		private var hpLbl:Label;
		private var lvLbl:Label;

		private var attaddLbl:Label;
		private var hpaddLbl:Label;
		private var lvaddLbl:Label;

		private var hptxtLbl:Label;
		private var atttxtLbl:Label;
		private var lvtxtLbl:Label;

		private var equipgrid:EquipStrengGrid;

		private var viewTxtArr:Array=[];
		private var view1Arr:Array=[];
		private var view2Arr:Array=[];

		public function EquipTransItem() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipTransItem.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.attLbl=this.getUIbyID("attLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;

			this.hptxtLbl=this.getUIbyID("hptxtLbl") as Label;
			this.atttxtLbl=this.getUIbyID("atttxtLbl") as Label;
			this.lvtxtLbl=this.getUIbyID("lvtxtLbl") as Label;

			this.attaddLbl=this.getUIbyID("attaddLbl") as Label;
			this.lvaddLbl=this.getUIbyID("lvaddLbl") as Label;
			this.hpaddLbl=this.getUIbyID("hpaddLbl") as Label;

			this.equipgrid=new EquipStrengGrid();
			this.addChild(this.equipgrid);

			this.equipgrid.dataId=1;

			this.equipgrid.x=18;
			this.equipgrid.y=50;

			this.equipgrid.setSize(60, 60);
			this.equipgrid.selectState();

			this.equipgrid.canMove=false;

			this.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);

			this.viewTxtArr.push(this.atttxtLbl);
			this.viewTxtArr.push(this.hptxtLbl);
			this.viewTxtArr.push(this.lvtxtLbl);

			this.view1Arr.push(this.attLbl);
			this.view1Arr.push(this.hpLbl);
			this.view1Arr.push(this.lvLbl);

			this.view2Arr.push(this.attaddLbl);
			this.view2Arr.push(this.hpaddLbl);
			this.view2Arr.push(this.lvaddLbl);

		}

		private function onMouseClick(e:MouseEvent):void {

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || DragManager.getInstance().grid.dataId == 1 || DragManager.getInstance().grid.dataId == 2)
					return;

				var g:GridBase=DragManager.getInstance().grid;
				var d:Object=g.data;

				if (d == null || !d.hasOwnProperty("tips"))
					return;

				var info:Object=d.tips;
				var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

				if (einfo == null)
					return;

				if ((EquipStrengGrid(e.target).dataId != -1 && g.dataId > -1)) {
					e.preventDefault();
					e.stopImmediatePropagation();
					return;
				}

				this.updateData(DragManager.getInstance().grid.data.tips);

			}

		}

		/**
		 *外部调用
		 * @param binfo
		 *
		 */
		public function setDownItem(binfo:Object):void {

			var d:Object=binfo;
			var info:Object=d.tips;
			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			this.equipgrid.updataInfo(d);
			this.updateData(binfo.tips);

		}


		private function updateData(info:Object):void {

			this.clearData();
			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			this.nameLbl.text="" + einfo.name;

			var pArr:Array=[];
			var key:String;

			var i:int=0;
			for (key in info.p) {
				if (info.p[key] != 0 && key.indexOf("_") == -1 && int(key) <= 7) {
//					pArr.push(key);

					this.viewTxtArr[i].text="" + PropUtils.propArr[int(key) - 1] + ":";
					this.view1Arr[i].text="" + info.p[key];

					if (info.p.hasOwnProperty("qh_" + key)) {
						this.view2Arr[i].text="(" + PropUtils.getStringById(1696) + "+" + info.p["qh_" + key] + ")";
					}

					i++;
				}
			}

			this.viewTxtArr[i].text=PropUtils.getStringById(1697) + ":";
			this.view1Arr[i].text="" + info.qh;


//			this.atttxtLbl.text="" + PropUtils.propArr[pArr[0] - 1];
//			this.attaddLbl.text="" + info.p[pArr[0]];
//
//			if (pArr.length == 1) {
//				this.hptxtLbl.text="";
//				this.hptopLbl.text="";
//			} else {
//				this.hptxtLbl.text="" + PropUtils.propArr[pArr[1] - 1];
//				this.hptopLbl.text="" + info.p[pArr[1]];
//			}

//			this.lvLbl.text="" + info.qh;

		}

		public function reUpdate():void {

			var data:Object;
			if (this.equipgrid.data.hasOwnProperty("pos")) {
				data=MyInfoManager.getInstance().bagItems[this.equipgrid.data.pos];
			} else {
				data=MyInfoManager.getInstance().equips[this.equipgrid.data.position];
			}

			this.equipgrid.updataInfo(data);
			this.updateData(data.tips);
		}

		public function clearAllData():void {
			this.clearData();
			this.equipgrid.delItemHandler();
		}

		private function clearData():void {
			this.hptxtLbl.text="";
			this.atttxtLbl.text="";

			this.hpLbl.text="";
			this.attLbl.text="";
			this.lvLbl.text="";

			this.hpaddLbl.text="";
			this.attaddLbl.text="";
			this.lvaddLbl.text="";

			this.nameLbl.text="";
		}

		public function set GridDataid(i:int):void {
			this.equipgrid.dataId=i;
		}

		public function getGridEmpty():Boolean {
			return this.equipgrid.isEmpty;
		}

		public function getGridData():Object {
			return this.equipgrid.data;
		}


	}
}

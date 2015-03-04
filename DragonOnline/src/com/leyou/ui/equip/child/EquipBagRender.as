package com.leyou.ui.equip.child {

	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;

	public class EquipBagRender extends AutoSprite {

		private var bodyEquipVec:Vector.<EquipStrengGrid>;
		private var bagEquipVec:Vector.<EquipStrengGrid>;
		private var mountEquipVec:Vector.<EquipStrengGrid>;

		private var bagList:ScrollPane;

		public function EquipBagRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipBagRender.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {

			this.bagList=this.getUIbyID("bagList") as ScrollPane;
			this.bodyEquipVec=new Vector.<EquipStrengGrid>();

			var g:GridBase;
			for (var i:int=0; i < 14; i++) {
				g=new EquipStrengGrid();
				g.gridType=ItemEnum.TYPE_GRID_EQUIP_BODY;

				this.bodyEquipVec.push(g);
				this.addChild(g);

				g.updataInfo(null);

				g.x=10 + i % 5 * (g.width + 3);
				g.y=32 + Math.floor(i / 5) * (g.height + 3)
			}

			this.bagEquipVec=new Vector.<EquipStrengGrid>();

			for (i=0; i < 70; i++) {

				g=new EquipStrengGrid();
				g.gridType=ItemEnum.TYPE_GRID_EQUIP_EQUIP;

				this.bagEquipVec.push(g);
				this.bagList.addToPane(g);

				g.updataInfo(null);

//				g.x=10 + i % 7 * (g.width);
//				g.y=115 + g.height + Math.floor(i / 7) * (g.height + 3)

				g.x=5 + i % 5 * (g.width);
				g.y=5 + Math.floor(i / 5) * (g.height)
			}

			this.mountEquipVec=new Vector.<EquipStrengGrid>();

			for (i=0; i < 4; i++) {

				g=new EquipStrengGrid();
				g.gridType=ItemEnum.TYPE_GRID_EQUIP_EQUIP;

				this.mountEquipVec.push(g);
				this.addChild(g);

				g.updataInfo(null);

				//				g.x=10 + i % 7 * (g.width);
				//				g.y=115 + g.height + Math.floor(i / 7) * (g.height + 3)

				g.x=15 + i % 5 * (g.width);
				g.y=185;
			}

		}


		public function getEmptyBodyGridIndex():int {
			for (var i:int=0; i < this.bodyEquipVec.length; i++) {
				if (this.bodyEquipVec[i].isEmpty)
					return i;
			}

			return -1;
		}

		public function getEmptyBagGridIndex():int {
			for (var i:int=0; i < this.bagEquipVec.length; i++) {
				if (this.bagEquipVec[i].isEmpty)
					return i;
			}

			return -1;
		}

		/**
		 *设置选择状态
		 * @param pos
		 * @param st
		 *
		 */
		public function setBagSelectState(pos:int, st:Boolean=true):void {
			for (var i:int=0; i < this.bagEquipVec.length; i++) {
				if (!this.bagEquipVec[i].isEmpty && this.bagEquipVec[i].data.pos == pos) {
					this.bagEquipVec[i].setSelectState(st);
					break;
				}
			}

		}

		public function updateEmptyBodyGrid(data:Object):void {
			this.updateBodyGrid(this.getEmptyBodyGridIndex(), data);
		}

		public function updateEmptyBagGrid(data:Object):void {
			this.updateBagGrid(this.getEmptyBagGridIndex(), data);
		}

		public function updateBodyGrid(i:int, data:Object):void {
			this.bodyEquipVec[i].updataInfo(data);
		}

		public function updateBagGrid(i:int, data:Object):void {
			this.bagEquipVec[i].updataInfo(data);
		}

		/**
		 *
		 *
		 */
		public function updatebodyData():void {

			var equip:Object=MyInfoManager.getInstance().equips;
			var einfo:EquipInfo;
			var cross:Boolean=false;

			var i:int=0;

			for each (einfo in equip) {

				if (einfo != null) {
					this.bodyEquipVec[i].updataInfo(einfo);
					this.bodyEquipVec[i].setRemask(false);
					i++;
				}
			}

			while (i < this.bodyEquipVec.length) {
				this.bodyEquipVec[i].updataInfo(null);
				this.bodyEquipVec[i].setRemask(false);
				i++;
			}

		}

		/**
		 *
		 *
		 */
		public function updateBagData():void {

			var arr:Array=MyInfoManager.getInstance().getBagItemByType(1);
			var cross:Boolean=false;

			for (var i:int=0; i < this.bagEquipVec.length; i++) {

				this.bagEquipVec[i].resetGrid();
				this.bagEquipVec[i].delItemHandler()

				if (arr[i] != null) {
					this.bagEquipVec[i].updataInfo(arr[i]);
				}

				this.bagEquipVec[i].setRemask(false);
				this.bagEquipVec[i].selectSt=false;

			}

		}

		/**
		 *
		 *
		 */
		public function updateMountData():void {

			var arr:Array=MyInfoManager.getInstance().mountEquipArr;
			var cross:Boolean=false;

			for (var i:int=0; i < this.mountEquipVec.length; i++) {

				this.mountEquipVec[i].resetGrid();
				this.mountEquipVec[i].delItemHandler()

				if (arr[i] != null) {
					this.mountEquipVec[i].updataInfo(arr[i]);
				}

				this.mountEquipVec[i].setRemask(false);
				this.mountEquipVec[i].selectSt=false;

			}


		}



		/**
		 * @param self
		 * @param type
		 * @param part
		 * @param qu
		 * @param lv
		 */
		public function updatebody(self:Array=null, fullst:Boolean=false, type:int=0, part:int=0, qu:Array=null, lv:int=-1, qhlv:int=-1):void {

//			var equip:Object=MyInfoManager.getInstance().equips;
			var einfo:EquipInfo;
			var cross:Boolean=fullst;

			for (var i:int=0; i < this.bodyEquipVec.length; i++) {

				cross=fullst;
				einfo=this.bodyEquipVec[i].data;

				if (einfo != null && einfo.position != self[0]) {

					if (part > 0 && einfo.info.position != part)
						cross=true;

					if (type > 0 && einfo.info.subclassid != type)
						cross=true;

					if (qu != null) {

						if (qu[1] == ">" && int(einfo.info.quality) > qu[0])
							cross=true;

						if (qu[1] == "<" && int(einfo.info.quality) < qu[0])
							cross=true;
					}

					if (lv > -1 && int(einfo.info.level) != lv)
						cross=true;

					if (qhlv > -1) {
						if (qhlv == 0 && int(einfo.tips.qh) == 0)
							cross=true;

						if (qhlv == 1 && int(einfo.tips.qh) != 0)
							cross=true;
					}

					if (cross)
						this.bodyEquipVec[i].setRemask(true)
					else
						this.bodyEquipVec[i].setRemask(false)

				}
			}


		}

		/**
		 *
		 * @param self
		 * @param type
		 * @param part
		 * @param qu
		 * @param lv
		 *
		 */
		public function updateBag(self:Array=null, type:int=0, part:int=0, qu:Array=null, lv:int=-1, qhlv:int=-1):void {

//			var arr:Array=MyInfoManager.getInstance().getBagItemByType(1);

			var cross:Boolean=false;
			var tmp:Baginfo;

			for (var i:int=0; i < this.bagEquipVec.length; i++) {

				cross=false;

				tmp=this.bagEquipVec[i].data;
				if (tmp != null && tmp.pos != self[0]) {

					if (part > 0 && tmp.info.position != part.toString())
						cross=true;

					if (type > 0 && tmp.info.subclassid != type.toString())
						cross=true;

					if (lv > -1 && int(tmp.info.level) != lv)
						cross=true;

					if (qu != null) {

						if (qu[1] == ">" && int(tmp.info.quality) > qu[0])
							cross=true;

						if (qu[1] == "<" && int(tmp.info.quality) < qu[0])
							cross=true;

						if (qu.length == 3 && qu[2] == int(tmp.info.quality))
							cross=true;
					}

					if (qhlv > -1) {
						if (qhlv == 0 && int(tmp.tips.qh) == 0)
							cross=true;

						if (qhlv == 1 && int(tmp.tips.qh) != 0)
							cross=true;
					}

					if (cross)
						this.bagEquipVec[i].setRemask(true);
					else
						this.bagEquipVec[i].setRemask(false);

				}

			}

		}

		/**
		 *
		 * @param self
		 * @param type
		 * @param part
		 * @param qu
		 * @param lv
		 * @param qhlv
		 *
		 */
		public function updateMount(self:Array=null, type:int=0, part:int=0, qu:Array=null, lv:int=-1, qhlv:int=-1):void {

//			var arr:Array=MyInfoManager.getInstance().getBagItemByType(1);

			var cross:Boolean=false;
			var tmp:Baginfo;

			for (var i:int=0; i < this.mountEquipVec.length; i++) {

				cross=false;

				tmp=this.mountEquipVec[i].data;
				if (tmp != null && tmp.info.subclassid != self[0]) {

					if (part > 0 && tmp.info.position != part.toString())
						cross=true;

					if (type > 0 && tmp.info.subclassid != type.toString())
						cross=true;

					if (lv > -1 && int(tmp.info.level) != lv)
						cross=true;

					if (qu != null) {

						if (qu[1] == ">" && int(tmp.info.quality) > qu[0])
							cross=true;

						if (qu[1] == "<" && int(tmp.info.quality) < qu[0])
							cross=true;

						if (qu.length == 3 && qu[2] == int(tmp.info.quality))
							cross=true;
					}

					if (qhlv > -1) {
						if (qhlv == 0 && int(tmp.tips.qh) == 0)
							cross=true;

						if (qhlv == 1 && int(tmp.tips.qh) != 0)
							cross=true;
					}

					if (cross)
						this.mountEquipVec[i].setRemask(true);
					else
						this.mountEquipVec[i].setRemask(false);

				}

			}

		}


		public function updateBagQuality2():void {

			//			var arr:Array=MyInfoManager.getInstance().getBagItemByType(1);

			var cross:Boolean=false;
			var tmp:Baginfo;

			for (var i:int=0; i < this.bagEquipVec.length; i++) {

				cross=false;

				tmp=this.bagEquipVec[i].data;
				if (tmp != null) {

					if (0 == int(tmp.info.quality))
						this.bagEquipVec[i].setRemask(true);
				}

			}

		}

		public function updateMountEnable(v:Boolean=true):void {

			//			var arr:Array=MyInfoManager.getInstance().getBagItemByType(1);

			var cross:Boolean=v;
			var tmp:Baginfo;

			for (var i:int=0; i < this.mountEquipVec.length; i++) {

				tmp=this.mountEquipVec[i].data;
				if (tmp != null) {
					this.mountEquipVec[i].setRemask(v);
				}

			}

		}

		/**
		 * 
		 * @param id
		 * 
		 */		
		public function updateAllByID(id:int):void {
			var i:int=0;

			for (i=0; i < this.bodyEquipVec.length; i++) {
				if (!this.bodyEquipVec[i].isEmpty && this.bodyEquipVec[i].data.info.id != id)
					this.bodyEquipVec[i].setRemask(true);
			}

			for (i=0; i < this.bagEquipVec.length; i++) {
				if (!this.bagEquipVec[i].isEmpty && this.bagEquipVec[i].data.info.id != id)
					this.bagEquipVec[i].setRemask(true);
			}

			for (i=0; i < this.mountEquipVec.length; i++) {
				if (!this.mountEquipVec[i].isEmpty && this.mountEquipVec[i].data.info.id != id)
					this.mountEquipVec[i].setRemask(true);
			}
		}

		private function clearData():void {
			var i:int=0;

			for (i=0; i < this.bodyEquipVec.length; i++)
				this.bodyEquipVec[i].updataInfo(null);

			for (i=0; i < this.bagEquipVec.length; i++)
				this.bagEquipVec[i].updataInfo(null);

		}

		/**
		 *清除特效
		 *
		 */
		public function clearEffect():void {
			var i:int=0;

			for (i=0; i < this.bodyEquipVec.length; i++)
				this.bodyEquipVec[i].stopMc()

			for (i=0; i < this.bagEquipVec.length; i++)
				this.bagEquipVec[i].stopMc();

		}


		/**
		 *
		 * @param self
		 * @param type
		 * @param part
		 * @param qu
		 * @param lv
		 *
		 */
		public function update():void {
			this.clearData();

			this.updateBagData();
			this.updatebodyData();
			this.updateMountData();

		}


	}
}

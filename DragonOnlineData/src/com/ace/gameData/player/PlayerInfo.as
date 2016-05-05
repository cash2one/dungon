package com.ace.gameData.player {

	import com.ace.enum.EventEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.mChild.MPlayerInfo;
	import com.ace.manager.EventManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.playerSkill.SkillInfo;
	import com.leyou.data.store.StoreInfo;

	public class PlayerInfo extends MPlayerInfo {

		private var _currentTaskId:int;
		private var _isTaskOk:Boolean;
		public var bagItems:Array=[];
		public var storeItems:Array=[];
		public var skilldata:SkillInfo;
		public var wingData:Object;
		public var links:Object;
		public var equips:Object={};
		public var otherEquips:Object={};
//		public var vipLv:int;

		public var isTeam:Boolean=false;
		public var isGuild:Boolean=false;

		public var guildArr:Array=[];

		/**
		 *vip剩余传送次数
		 */
		public var VipLastTransterCount:int=0;

		/**
		 *蓝的标志
		 */
		public var Mp:int=0;

		/**
		 *坐骑装备
		 */
		public var mountEquipArr:Array=[];

		/**
		 *宝石
		 */
		public var gemArr:Array=[];


		public var othergemArr:Array=[];

		public var firstItem:Object;

		public var mercenaryClose:int=0;
		public var mercenaryExp:int=0;
		public var mercenaryCount:int=0;

		public function PlayerInfo($info:LivingInfo=null) {
			super($info);
		}

		public function get isTaskOk():Boolean
		{
			return _isTaskOk;
		}

		public function set isTaskOk(value:Boolean):void
		{
			_isTaskOk = value;
		}

		public function get currentTaskId():int {
			return _currentTaskId;
		}

		public function set currentTaskId(value:int):void {
			if(value==this._currentTaskId){
				return;
			}
			trace("当前任务：",value);
			_currentTaskId=value;
			EventManager.getInstance().dispatchEvent(EventEnum.TASK_CHANGE);
		}

		public function addItems(data:Object):void {

			var info:*=TableManager.getInstance().getItemInfo(data.aid);

			if (info == null) {
				info=TableManager.getInstance().getEquipInfo(data.aid);
			}

			var tinfo:Baginfo=new Baginfo(data);
			tinfo.info=info;
			this.bagItems[tinfo.pos]=tinfo;

		}

		public function updateItems(data:Object):void {

			var info:*=TableManager.getInstance().getItemInfo(data.aid);

			if (info == null) {
				info=TableManager.getInstance().getEquipInfo(data.aid);
			}

			var tinfo:Baginfo=data as Baginfo; //new Baginfo(data);
			tinfo.info=info;


			this.bagItems[tinfo.pos]=tinfo;
		}

		public function addStore(data:Object):void {

			var info:*=TableManager.getInstance().getItemInfo(data.aid);

			if (info == null) {
				info=TableManager.getInstance().getEquipInfo(data.aid);
			}

			var tinfo:StoreInfo=new StoreInfo(data);
			tinfo.info=info;

			this.storeItems[tinfo.pos]=tinfo;
		}

		/**
		 * 背包使用总数
		 * @return
		 *
		 */
		public function getBagNum():int {

			var i:int=0;
			var o:Object
			for (var j:int=0; j < bagItems.length; j++) {
				if (this.bagItems[j] != null)
					i++;
			}

			return i;
		}

		/**
		 * 背包剩余总数
		 * @return
		 *
		 */
		public function getBagEmptyNum():int {

			var i:int=0;
			var o:Object
			for (var j:int=0; j < bagItems.length; j++) {
				if (this.bagItems[j] == null)
					i++;
			}

			return i;
		}

		/**
		 * 仓库数量
		 * @return
		 *
		 */
		public function getStoreNum():int {
			var i:int=0;
			var o:Object

			for each (o in storeItems) {
				if (o != null)
					i++;
			}

			return i;
		}

		/**
		 * 获取空背包格子
		 * @return
		 *
		 */
		public function getBagEmptyGridIndex(aid:int=-1, num:int=1):int {
			var i:int=0;

			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] == null)
					return i;
			}

			if (this.bagItems.length < ItemEnum.BACKPACK_GRID_OPEN)
				return this.bagItems.length;

			if (aid != -1) {
				for (i=0; i < this.bagItems.length; i++) {
					if (this.bagItems[i] != null && this.bagItems[i].info != null && this.bagItems[i].aid == aid && this.bagItems[i].num < this.bagItems[i].info.maxgroup && (this.bagItems[i].info.maxgroup - this.bagItems[i].num) >= num)
						return i;
				}
			}

			return -1;
		}

		/**
		 * 通过id--获取物品数量
		 * @param id
		 * @return
		 *
		 */
		public function getBagItemNumById(id:int):int {
			var i:int=0;

			var c:int=0;
			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] != null && this.bagItems[i].aid == id)
					c+=int(this.bagItems[i].num);
			}

			return c;
		}

		/**
		 *
		 * @param id
		 * @return
		 *
		 */
		public function getBagItemStrengLvById(id:int):int {

			var i:int=0;
			var lv:int=0;

			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] != null && this.bagItems[i].aid == id) {

					if (lv < this.bagItems[i].tips.qh)
						lv=this.bagItems[i].tips.qh;
				}
			}

			return lv;
		}

		/**
		 *
		 * @param id
		 * @return
		 *
		 */
		public function getBagItemStrengLvIdById(id:int):int {

			var i:int=0;
			var lv:int=0;
			var pos:int=0;
			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] != null && this.bagItems[i].aid == id) {

					if (pos == 0)
						pos=i;

					if (lv < this.bagItems[i].tips.qh) {
						lv=this.bagItems[i].tips.qh;
						pos=i;
					}

				}
			}

			return pos;
		}

		/**
		 * 通过名字--获取物品数量
		 * @param name
		 */
		public function getBagItemNumByName(name:String):int {
			var i:int=0;
			var c:int=0;
			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] != null && this.bagItems[i].info != null && this.bagItems[i].info.name == name)
					c+=this.bagItems[i].num;
			}

			return c;
		}

		/**
		 *
		 * @param qu
		 * @return  [pos,pos]
		 *
		 */
		public function getBagItemByQuality(qu:int):Array {
			var i:int=0;
			var pArr:Array=[];
			for (i=0; i < this.bagItems.length; i++) {
				if (this.bagItems[i] != null && this.bagItems[i].info != null && this.bagItems[i].info.classid == 1 && this.bagItems[i].info.quality == qu)
					pArr.push(this.bagItems[i].pos);
			}

			return pArr;
		}



		/**
		 * 药水bind取反
		 * @param id
		 * @return
		 *
		 */
		public function getBagItemNegationByID(id:int):Baginfo {
			var baginfo:Baginfo;

			if (id % 2 == 0) {
				baginfo=this.getBagItemPosByID(id + 1);
			} else {
				baginfo=this.getBagItemPosByID(id - 1);
			}


			return baginfo;
		}


		public function delBagItem(pos:int):void {
			if (pos <= 0)
				return;


		}

		/**
		 *根据类型返回 物品
		 * @param type 1: 装备, 2, 药水; 3, 其他
		 * @return
		 *
		 */
		public function getBagItemByType(type:int):Array {

			var tmp2:Array=this.bagItems.filter(function(item:Baginfo, _i:int, arr:Array):Boolean {

				if (item != null && item.info != null && item.info.classid == type) {
					return true;
				}

				return false;
			});

			return tmp2;
		}

		/**
		 *根据id找位置
		 * @param id
		 * @return
		 *
		 */
		public function getBagItemPosByID(id:int):Baginfo {

			var baginfo:Baginfo;
			for each (baginfo in this.bagItems) {
				if (baginfo != null && baginfo.aid == id)
					return baginfo;
			}

			return null;
		}

		/**
		 *获得位置数组---包括非绑定
		 * @param info
		 * @return
		 *
		 */
		public function getBagItemPosArrById(info:Baginfo):Array {

			var arr:Array=[];
			var baginfo:Baginfo;

			for each (baginfo in this.bagItems) {

				if (baginfo != null && baginfo.aid == info.aid && baginfo.pos != info.pos) {
					arr.push(baginfo.pos);
				}

			}

			var aid:int=(info.aid % 2 == 0 ? info.aid + 1 : info.aid - 1)

			for each (baginfo in this.bagItems) {

				if (baginfo != null && baginfo.aid == aid) {
					arr.push(baginfo.pos);
				}

			}

			return arr;

		}

		public function getBagItemIDArrByID(id:int):Array {

			var arr:Array=[];
			var baginfo:Baginfo=this.getBagItemPosByID(id);

			if (baginfo != null)
				arr.push(id);

			if (id % 2 == 0) {
				baginfo=this.getBagItemPosByID(id + 1);

				if (baginfo != null)
					arr.push(id + 1);

			} else {
				baginfo=this.getBagItemPosByID(id - 1);

				if (baginfo != null)
					arr.push(id - 1);
			}

			return arr;
		}

		public function getBagItemDataArrByID(id:int):Array {

			var arr:Array=[];
			var baginfo:Baginfo=this.getBagItemPosByID(id);

			if (baginfo != null)
				arr.push(baginfo);

			if (id % 2 == 0) {
				baginfo=this.getBagItemPosByID(id + 1);

				if (baginfo != null)
					arr.push(baginfo);

			} else {
				baginfo=this.getBagItemPosByID(id - 1);

				if (baginfo != null)
					arr.push(baginfo);
			}

			return arr;
		}

		/**
		 *
		 * @param id
		 * @return  绑定和非绑定
		 *
		 */
		public function getBagItemByID(id:int):Baginfo {

			var baginfo:Baginfo=this.getBagItemPosByID(id);
			if (baginfo == null) {
				if (id % 2 == 0) {
					baginfo=this.getBagItemPosByID(id + 1);
				} else {
					baginfo=this.getBagItemPosByID(id - 1);
				}
			}

			return baginfo;
		}

		public function getBagItemByUid(id:String):Baginfo {
			if ((null == id) || ("" == id)) {
				return null;
			}
			for each (var baginfo:Baginfo in bagItems) {
				if ((null != baginfo) && (baginfo.tips.uid == id)) {
					return baginfo;
				}
			}
			return null;
		}


		public function getBagItemArrByid(id:int):Array {

			var arr:Array=[];

			for each (var baginfo:Baginfo in bagItems) {
				if ((null != baginfo) && (baginfo.aid == int(id))) {
					arr.push(baginfo);
				}
			}

			return arr;
		}

		/**
		 *	获取绑定物品
		 * @return
		 *
		 */
		public function getBagItemByBind():Array {
			var tmp2:Array=this.bagItems.filter(function(item:Baginfo, _i:int, arr:Array):Boolean {

				if (item != null && item.info != null && item.info.bind == 1) {
					return true;
				}

				return false;
			});

			return tmp2;
		}

		/**
		 * 获取仓库的空格子
		 * @return
		 *
		 */
		public function getStoreEmptyGridIndex():int {
			var i:int=0;

			for (i=0; i < this.storeItems.length; i++) {
				if (this.storeItems[i] == null)
					return i;
			}

			if (this.storeItems.length < ItemEnum.STORAGE_GRIDE_OPEN)
				return this.storeItems.length;

			return -1;
		}

		/**
		 *角色面板id 转 位置
		 * @param id
		 * @return
		 *
		 */
		public function getRoleEquipPosById(id:int):int {

			var key:String;
			for (key in this.equips) {
				if (this.equips[key].id == id)
					return int(key);
			}

			return -1;
		}

		/**
		 * 返回已激活,为放物品的slot
		 * @return
		 *
		 */
		public function getWingSlotIndex():int {

			if (this.wingData != null && this.wingData.hasOwnProperty("st")) {

				var key:String;
				for (key in wingData.st) {
					if (wingData.st[key].s == 1) {
						return int(key);
					}
				}

			}

			return -1;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getRoleEquipLen():int {
			var i:int=0;
			var e:Object;
			for each (e in equips) {
				if (e != null)
					i++;
			}

			return i;
		}

		/**
		 * 根据品质返回数量
		 * @param q
		 * @return
		 *
		 */
		public function getRoleEquipNumByQuilty(q:int):int {

			var i:int=0;
			var e:Object;
			for each (e in equips) {
				if (e != null && int(e.info.quality) >= q)
					i++;
			}

			return i;
		}

		/**
		 * 根据强化lv获得数量
		 * @param q
		 * @return
		 *
		 */
		public function getRoleEquipNumByLv(q:int):int {

			var i:int=0;
			var e:Object;
			for each (e in equips) {
				if (e != null && e.tips != null && int(e.tips.qh) >= q)
					i++;
			}

			return i;
		}

		public function set BagItemLen(len:int):void {
			this.bagItems.length=len;
		}


		public function get hasWing():Boolean {
			return this.featureInfo.wing > 0;
		}
	}
}

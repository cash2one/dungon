package com.leyou.ui.convenientuse
{
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.convenient.ConvenientItem;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.MouseEvent;
	
	public class ConvenientUseManager
	{
		// 等待显示装备队列
		private var equipQueue:Vector.<String> = new Vector.<String>(14);
		
		// 等待显示的坐骑装备
		public var rideEquipQueue:Vector.<String> = new Vector.<String>();
		
		// 等待显示道具队列
		private var itemQueue:Vector.<String> = new Vector.<String>();
		
		// 正在显示的项
		private var currentItem:ConvenientItem = new ConvenientItem();
		
		private static var instance:ConvenientUseManager;
		
		public static function getInstance():ConvenientUseManager{
			if(null == instance){
				instance = new ConvenientUseManager();
				UIManager.getInstance().convenientWear.registeredUse(instance.onUseClick);
				UIManager.getInstance().convenientTransfer.registeredUse(instance.onUseClick);
				UIManager.getInstance().convenientUse.registeredUse(instance.onUseClick);
				
			}
			return instance;
		}
		
		/**
		 * <T>放入一个新获得物品唯一ID</T>
		 * 
		 * @param id 物品唯一ID
		 * 
		 */		
		public function checkNewBagId(id:String):void{
			var bagInfo:Baginfo = MyInfoManager.getInstance().getBagItemByUid(id);
			if(1 == bagInfo.info.classid){
				// 装备
				if(currentItem.uid == id){// 是否是当前显示
					return;
				}
				checkEquip(bagInfo);
			}else if((3 == bagInfo.info.classid) || (2 == bagInfo.info.classid)){
				// 道具或药品
				if(currentItem.uid == id){// 是否是当前显示
					pushData(bagInfo, 3);
					UIManager.getInstance().convenientUse.showItem(currentItem);
					return;
				}
				checkItem(bagInfo);
			}
			if(!isShow()){
				showNext();
			}
		}
		
		private function checkEquip(bagInfo:Baginfo):void{
			if(1 == bagInfo.info.classid){
				// 新获得装备
				var level:int = Core.me.info.level;
				if(int(bagInfo.info.level) > level){// 不匹配等级
					return;
				}
				if((0 != bagInfo.info.limit) && (bagInfo.info.limit != Core.me.info.profession)){// 不匹配职业
					return;
				}
				// 获得身上已穿戴的装备
				var el:Array = ItemEnum.ItemToRolePos[bagInfo.info.subclassid];
				if(null != el){
					// 角色装备
					if(el.length > 1){
						// 可以装备两件的装备
						var equip1:EquipInfo = MyInfoManager.getInstance().equips[el[0]];
						var equip2:EquipInfo = MyInfoManager.getInstance().equips[el[1]];
						if((null != equip1) && (null != equip2)){
							var tPos:int;
							var tPosArr1:Array;
							var tBagInfo:Baginfo;
							if(equip1.tips.strengthZdl(0) != equip2.tips.strengthZdl(0)){
								var tEquip:EquipInfo = (equip1.tips.strengthZdl(0) < equip2.tips.strengthZdl(0)) ? equip1 : equip2;
								tPosArr1 = getEquipPos(bagInfo.info.subclassid);
								tPos = (equip1.tips.strengthZdl(0) < equip2.tips.strengthZdl(0)) ? tPosArr1[0] : tPosArr1[1];
								if(tEquip.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0)){
									tBagInfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[tPos]);
									if((null == tBagInfo) || (tBagInfo.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
										equipQueue[tPos] = bagInfo.tips.uid;
										return;
									}
								}
							}else{
								tPosArr1 = getEquipPos(bagInfo.info.subclassid);
								tPos = tPosArr1[0];
								tBagInfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[tPos]);
								if((null == tBagInfo) || (tBagInfo.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
									equipQueue[tPos] = bagInfo.tips.uid;
									return;
								}
								tPos = tPosArr1[1];
								tBagInfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[tPos]);
								if((null == tBagInfo) || (tBagInfo.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
									equipQueue[tPos] = bagInfo.tips.uid;
									return;
								}
							}
						}
						// 和第一件装备对比
						if((null == equip1) ||(equip1.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
							var posArr1:Array = getEquipPos(bagInfo.info.subclassid);
							var pos1:int = posArr1[0];
							var eBagInfo1:Baginfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[pos1]);
							// 战力比此位置的缓存大
							if((null == eBagInfo1) || (eBagInfo1.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
								equipQueue[pos1] = bagInfo.tips.uid;
								// 将两者交换,然后和第二个位置对比
								if(null != eBagInfo1){
									bagInfo = eBagInfo1;
								}else{
									return;
								}
							}
						}
						// 和第二件装备对比
						if((null == equip2) || (equip2.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
							var posArr2:Array = getEquipPos(bagInfo.info.subclassid);
							var pos2:int = posArr2[1];
							var eBagInfo2:Baginfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[pos2]);
							// 战力比此位置的缓存大
							if((null == eBagInfo2) || (eBagInfo2.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
								equipQueue[pos2] = bagInfo.tips.uid;
							}
						}
					}else{
						var equip:EquipInfo = MyInfoManager.getInstance().equips[el[0]];
						// 和当前装备对比
						if((null == equip) || (equip.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
							var posArr:Array = getEquipPos(bagInfo.info.subclassid);
							var pos:int = posArr.pop();
							var eBagInfo:Baginfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[pos]);
							// 和已加入缓存对比
							if((null == eBagInfo) || (eBagInfo.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
								equipQueue[pos] = bagInfo.tips.uid;
							}
						}
					}
				}else{
					// 坐骑装备
					var cEquip:Baginfo;
					var mAe:Array = MyInfoManager.getInstance().mountEquipArr;
					var l:int = mAe.length;
					for(var n:int = 0; n < l; n++){
						var mEquip:Baginfo = mAe[n];
						if((null != mEquip) && (mEquip.info.subclassid == bagInfo.info.subclassid)){
							cEquip = mEquip;
							break;
						}
					}
					if((null == cEquip) || (cEquip.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
						var index:int = -1;
						var cl:int = rideEquipQueue.length;
						for(var m:int = 0; m < cl; m++){
							var mBagInfo:Baginfo = MyInfoManager.getInstance().getBagItemByUid(rideEquipQueue[m]);
							if((null != mBagInfo) && (mBagInfo.info.subclassid == bagInfo.info.subclassid)){
								index = m;
								break;
							}
						}
						if(0 > index){
							rideEquipQueue.push(bagInfo.tips.uid);
						}else{
							if((null != mBagInfo) && (mBagInfo.tips.strengthZdl(0) < bagInfo.tips.strengthZdl(0))){
								rideEquipQueue[index] = bagInfo.tips.uid;
							}
						}
					}
				}
			}
		}
		
		private function checkItem(info:Baginfo):void{
			// 新获得道具
			var id:String = info.info.id;
			var convenientItems:Array = ItemEnum.CONVENIENT_ITEMS;
			for each (var str:String in convenientItems) {
				var index:int = id.indexOf(str);
				if (0 == index) {
					if(-1 == itemQueue.indexOf(info.tips.uid)){
						itemQueue.push(info.tips.uid);
					}
					break;
				}
			}
		}
		
		/**
		 * 获得该装备对应的位置
		 * 
		 * @param pos 装备位置
		 * @return 缓存对应位置
		 * 
		 */		
		private function getEquipPos(pos:int):Array{
			switch(pos){
				case 1: // 武器
					return [ConvenientUseEnum.EQUIP_POS_WEAPON];
				case 2: // 戒指,有两个
					return [ConvenientUseEnum.EQUIP_POS_RING1, ConvenientUseEnum.EQUIP_POS_RING2];
				case 3: // 手镯,有两个
					return [ConvenientUseEnum.EQUIP_POS_BRACELET1, ConvenientUseEnum.EQUIP_POS_BRACELET2];
				case 4: // 头盔
					return [ConvenientUseEnum.EQUIP_POS_HELMET];
				case 5: // 衣服
					return [ConvenientUseEnum.EQUIP_POS_COAT];
				case 6: // 手套
					return [ConvenientUseEnum.EQUIP_POS_GLOVE];
				case 7: // 鞋子
					return [ConvenientUseEnum.EQUIP_POS_SHOES];
				case 8: // 腰带
					return [ConvenientUseEnum.EQUIP_POS_GIRDLE];
				case 9: // 裤子
					return [ConvenientUseEnum.EQUIP_POS_PANTS];
				case 10: // 项链
					return [ConvenientUseEnum.EQUIP_POS_NECKLACE];
				case 11: // 护符,有两个
					return [ConvenientUseEnum.EQUIP_POS_TALIMAN1, ConvenientUseEnum.EQUIP_POS_TALIMAN2];
				default:
					throw new Error("getEquipPos error");
					break;
				
			}
			return null;
		}
		
		/**
		 * <T>显示下一个</T>
		 * 
		 */		
		private function showNext():void{
			clear();
			setCurrentItem();
			if(currentItem.empty()){
				return;
			}
			switch(currentItem.type){
				case 1:
					UIManager.getInstance().convenientWear.showItem(currentItem);
					break;
				case 2:
					UIManager.getInstance().convenientTransfer.showItem(currentItem);
					break;
				case 3:
					UIManager.getInstance().convenientUse.showItem(currentItem);
					break;
			}
		}
		
		/**
		 * <T>放入要显示的物品</T>
		 * @param info 物品信息
		 * @param type 类型
		 *        1 -- 便捷换装
		 *        2 -- 便捷换装(对应装备有强化等级时)
		 *        3 -- 便捷使用道具
		 * @param id   已穿装备ID
		 * @param dzdl 战斗力差值
		 * @param cost 转移消耗
		 * 
		 */		
		public function pushData(info:Baginfo, type:int, dzdl:uint=0, cIndex:int=0, cost:uint=0, transferInfo:EquipInfo=null):void{
			currentItem.uid = info.tips.uid;
			currentItem.type = type;
			currentItem.dzdl = dzdl;
			currentItem.cost = cost;
//			currentItem.currentIndx = cIndex;
			if(null != transferInfo){
				currentItem.eInfoIndex = transferInfo.position;
			}
		}
		
		private function getIndexByPos(pos:int):int{
			if((ConvenientUseEnum.EQUIP_POS_BRACELET2 == pos) || (ConvenientUseEnum.EQUIP_POS_RING2 == pos) || (ConvenientUseEnum.EQUIP_POS_TALIMAN2 == pos)){
				return 1;
			}
			return 0;
		}
		
		/**
		 * <T>获得一个显示项</T>
		 * 
		 */		
		private function setCurrentItem():void{
			// 装备
			var cost:int
			var increase:int;
			var l:int = equipQueue.length;
			for(var n:int = 0; n < l; n++){
				var eBagInfo:Baginfo = MyInfoManager.getInstance().getBagItemByUid(equipQueue[n]);
				if(null != eBagInfo){
//					equipQueue[n] = null;
					// 获得身上已穿戴的装备
					var index:int = getIndexByPos(n);
					var el:Array = ItemEnum.ItemToRolePos[eBagInfo.info.subclassid];
					var einfo:EquipInfo = MyInfoManager.getInstance().equips[el[index]];
					// 身上没有穿戴
					if(null == einfo){
						pushData(eBagInfo, 1, eBagInfo.tips.zdl, n);
						return;
					}
					// 比较装备基础品质
					if((einfo.strengthZdl(0) < eBagInfo.tips.strengthZdl(0)) || (einfo.tips.zdl < eBagInfo.tips.zdl)){
						if(((einfo.tips.qh > 0) && (eBagInfo.tips.qh <= 0)) && (einfo.info.quality <= eBagInfo.info.quality)){
							// 身上装备有强化等级，背包装备没有强化，背包装备品质高于身上装备
							increase = eBagInfo.tips.strengthZdl(einfo.tips.qh) - einfo.tips.strengthZdl(einfo.tips.qh);
							cost = int(eBagInfo.info.dc) * int(ConfigEnum["equip" + einfo.tips.qh]);
							pushData(eBagInfo, 2, increase, n, cost, einfo);
							return;
						}else if(einfo.tips.zdl < eBagInfo.tips.zdl){
							pushData(eBagInfo, 1, eBagInfo.tips.zdl - einfo.tips.zdl, n);
							return;
						}
					}
				}
			}
			
			// 坐骑装备
			var mAe:Array = MyInfoManager.getInstance().mountEquipArr;
			var ml:int = mAe.length;
			var mBagInfo:Baginfo = MyInfoManager.getInstance().getBagItemByUid(rideEquipQueue.shift());
			if(null != mBagInfo){
				for(var k:int = 0; k < ml; k++){
					var mEquip:Baginfo = mAe[k];
					if((null != mEquip) && (mEquip.info.subclassid == mBagInfo.info.subclassid)){
						// 比较装备基础品质
						if((mBagInfo.tips.strengthZdl(0) > mEquip.tips.strengthZdl(0)) || (mBagInfo.tips.zdl > mEquip.tips.zdl)){
							if(((mEquip.tips.qh > 0) && (mBagInfo.tips.qh <= 0)) && (mEquip.info.quality <= mBagInfo.info.quality)){
								// 身上装备有强化等级，背包装备没有强化，背包装备品质高于身上装备
								increase = mBagInfo.tips.strengthZdl(einfo.tips.qh) - mEquip.tips.strengthZdl(einfo.tips.qh);
								cost = int(mBagInfo.info.dc) * int(ConfigEnum["equip" + mEquip.tips.qh])
								pushData(mBagInfo, 2, increase, n, cost, einfo);
								return;
							}else if(mBagInfo.tips.zdl > mEquip.tips.zdl){
								pushData(mBagInfo, 1, mBagInfo.tips.zdl - mEquip.tips.zdl, k);
								return;
							}
						}
					}
				}
				pushData(mBagInfo, 1, mBagInfo.tips.zdl, n);
				return;
			}
			
			// 道具
			var info:Baginfo = MyInfoManager.getInstance().getBagItemByUid(itemQueue.shift());
			if(null != info){
				pushData(info, 3);
			}
		}
		
		/**
		 * <T>是否在显示状态</T>
		 * 
		 * @return 是否显示中 
		 * 
		 */		
		private function isShow():Boolean{
			return UIManager.getInstance().convenientWear.visible ||
				UIManager.getInstance().convenientTransfer.visible ||
				UIManager.getInstance().convenientUse.visible;
		}
		
		/**
		 * <T>使用监听</T>
		 * 
		 * @param event 点击鼠标事件
		 * 
		 */		
		private function onUseClick(event:MouseEvent):void{
			showNext();
		}
		
		/**
		 * <T>检查包裹内是否有比已穿戴装备更好的装备</T>
		 * 
		 */		
		public function checkAvailable():void{
			var bagItems:Array = MyInfoManager.getInstance().bagItems;
			for each(var bagInfo:Baginfo in bagItems){
				if(null == bagInfo){
					continue;
				}
				checkNewBagId(bagInfo.tips.uid);
			}
		}
		
		/**
		 * <T>检测是否在显示已被移出背包的物品</T>
		 * 
		 * @param pos 所在背包的位置
		 * 
		 */		
		public function checkUseQueue(uid:String):void{
			// 被转移的物品是否存在于缓存中
			var l:int = equipQueue.length;
			for(var n:int = 0; n < l; n++){
				if(equipQueue[n] == uid){
					equipQueue[n] = null;
				}
			}
			
			// 被转移的物品是否正在显示
			if(isShow() && (currentItem.uid == uid)){
				showNext();
				UIManager.getInstance().convenientWear.visible = false;
				UIManager.getInstance().convenientUse.visible = false;
				UIManager.getInstance().convenientTransfer.visible = false;
			}
		}
		
		public function removeUid(uid:String):void{
			// 被转移的物品是否存在于缓存中
			var l:int = equipQueue.length;
			for(var n:int = 0; n < l; n++){
				if(equipQueue[n] == uid){
					equipQueue[n] = null;
				}
			}
			var index:int = rideEquipQueue.indexOf(uid);
			if(-1 < index){
				rideEquipQueue.splice(index, 1);
			}
		}
		
		public function clear():void{
			currentItem.clear();
		}
	}
}
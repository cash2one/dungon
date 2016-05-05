package com.leyou.ui.convenientuse {
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.convenient.ConvenientItem;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.ui.convenientuse.children.ConvenientGrid;

	import flash.events.MouseEvent;

	/**
	 * 快捷使用
	 * @author Administrator
	 *
	 */
	public class ConvenientWearWnd extends AutoWindow {
		// 物品格子
		private var grid:ConvenientGrid;

		// 使用按钮
		private var useBtn:ImgButton;

		// 数值显示
		private var num:RollNumWidget;

		// 监听函数
		private var clickHandler:Function;

		private var item:ConvenientItem;

		public function ConvenientWearWnd() {
			super(LibManager.getInstance().getXML("config/ui/convenient/equipMessage.xml"))
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			hideBg();
			useBtn=getUIbyID("useBtn") as ImgButton;
			useBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			grid=new ConvenientGrid();
			addChild(grid);
			grid.x=35;
			grid.y=84;

			num=new RollNumWidget();
			num.addFrontFlag("ui/num/plus_yellow.png");
			num.loadSource("ui/num/{num}_zdl.png");
			//			num.visibleOfBg = false;
			addChild(num);
			num.x=120;
			num.y=130;
//			clsBtn.x-=6;
//			clsBtn.y-=14;
		}

		/**
		 * <T>注册使用监听</T>
		 *
		 * @param $clickHandler 监听函数
		 *
		 */
		public function registeredUse($clickHandler:Function):void {
			clickHandler=$clickHandler;
		}

		/**
		 * <T>显示下一个</T>
		 *
		 */
		public function showItem($item:ConvenientItem):void {
			resize();
			show(true, 1, false);
			item=$item;
			grid.updataInfo(item);
			num.setNum(item.dzdl);
			if ((Core.me.info.level < 30) && hasPos(item.bagInfo.info.subclassid)) {
				onMouseClick(null);
			}

			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {
			if (ConfigEnum.common7 - i <= 0) {
				this.useBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				TimerManager.getInstance().remove(exeTime);
			}
		}

		private function hasPos(classId:int):Boolean {
			var ol:Array=ItemEnum.ItemToRolePos[classId];
			if (null != ol) {
				for each (var rl:int in ol) {
					var ef:EquipInfo=MyInfoManager.getInstance().equips[rl];
					if (null == ef) {
						return true;
					}
				}
				return false;
			} else {
				// 坐骑装备
				var cEquip:Baginfo;
				var mAe:Array=MyInfoManager.getInstance().mountEquipArr;
				var l:int=mAe.length;
				for (var n:int=0; n < l; n++) {
					var mEquip:Baginfo=mAe[n];
					if ((null != mEquip) && (mEquip.info.subclassid == classId)) {
						cEquip=mEquip;
						return false;
					}
				}
				return true;
			}
			return false;
		}

		/**
		 * <T>点击按钮使用</T>
		 *
		 * @param event 点击事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			// 是否找到背包信息
			var bagInfo:Baginfo=grid.bitem.bagInfo;
			if (null == bagInfo || bagInfo.info.classid != 1) {
				hide();
				return;
			}
			var ol:Array=ItemEnum.ItemToRolePos[bagInfo.info.subclassid];
			if (null == ol) {
				Cmd_Bag.cm_bagMoveTo(bagInfo.pos, 40, bagInfo.info.subclassid - 13);
			}
			// 装备是否比原来好
			var better:Boolean=false;
			for each (var rl:int in ol) {
				var ef:EquipInfo=MyInfoManager.getInstance().equips[rl];
				if (null != ef) {
					// 比较装备基础品质
					if (ef.strengthZdl(0) < bagInfo.tips.strengthZdl(0)) {
						better=true;
						break;
					}
				} else {
					better=true;
					break;
				}
			}
			if (!better) {
				hide();
				return;
			}

			// 复制背包格子使用
			if (bagInfo.info.classid == ItemEnum.ITEM_TYPE_EQUIP) {

				var olist:Array=ItemEnum.ItemToRolePos[bagInfo.info.subclassid];

				var st:Boolean=false;
				var roleIndex:int=-1;
				var einfo:EquipInfo=MyInfoManager.getInstance().equips[olist[0]];

				if (einfo != null) {

					if (bagInfo.tips.zdl > einfo.tips.zdl) {
						roleIndex=olist[0];
					}

					if (olist.length == 2) {

						var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
						if (einfo1 != null) {

							if (einfo.info.name == bagInfo.info.name && einfo1.info.name != bagInfo.info.name)
								roleIndex=olist[1];
							else if (einfo1.info.name == bagInfo.info.name && einfo.info.name != bagInfo.info.name)
								roleIndex=olist[0];
							//								else if (this.data.tips.zdl > einfo1.tips.zdl) 
							//									roleIndex=olist[1];
							else {

								if (einfo.tips.zdl > einfo1.tips.zdl)
									roleIndex=olist[1];
								else
									roleIndex=olist[0];

							}
						} else {

							roleIndex=olist[1];

						}

					} else {
						roleIndex=olist[0];
					}

				} else {

					roleIndex=olist[0];

				}
				Cmd_Bag.cm_bagMoveTo(bagInfo.pos, 3, roleIndex);
			}
			hide();
		}

		public override function hide():void {
			super.hide();
			ConvenientUseManager.getInstance().removeUid(item.uid);
			if (null != clickHandler) {
				clickHandler.call(this, null);
			}
		}

		public override function set visible(value:Boolean):void {
			super.visible=value;
			if (value) {
				GuideManager.getInstance().showGuide(40, useBtn);
			} else {
				GuideManager.getInstance().removeGuide(40);
			}
		}

		public function resize():void {
			x=UIEnum.WIDTH - width;
			y=UIEnum.HEIGHT - height; // - 100;
		}

		override public function get width():Number {
			return 308;
		}

		override public function get height():Number {
			return 249;
		}

	}
}

package com.leyou.ui.convenientuse {
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.ImageUtil;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.convenient.ConvenientItem;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Equip;
	import com.leyou.ui.convenientuse.children.ConvenientGrid;
	import com.leyou.utils.ItemUtil;

	import flash.events.MouseEvent;

	public class ConvenientTransferWnd extends AutoWindow {

		// 物品格子
		protected var grid:ConvenientGrid;

		// 使用按钮
		protected var useBtn:ImgButton;

		// 数值显示
		private var num:RollNumWidget;

		// 消耗金钱
		private var goldLbl:Label;

		// 使用监听
		private var clickHandler:Function;

		// 当前显示项
		private var item:ConvenientItem;

		private var iconImg:Image;

		public function ConvenientTransferWnd() {
			super(LibManager.getInstance().getXML("config/ui/convenient/equipMessage1.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			hideBg();
			mouseEnabled=true;
			mouseChildren=true;
			iconImg=getUIbyID("iconImg") as Image;
			useBtn=getUIbyID("useBtn") as ImgButton;
			useBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			goldLbl=getUIbyID("goldLbl") as Label;

			grid=new ConvenientGrid();
			addChild(grid);
			grid.x=35;
			grid.y=75;

			num=new RollNumWidget();
			num.addFrontFlag("ui/num/plus_yellow.png");
			num.loadSource("ui/num/{num}_zdl.png");
			//			num.visibleOfBg = false;
			addChild(num);
			num.x=136;
			num.y=126;
//			clsBtn.x-=6;
//			clsBtn.y-=14;
		}

		/**
		 * <T>显示下一个</T>
		 *
		 */
		public function showItem($item:ConvenientItem):void {
			resize();
			item=$item;
			show(true, 1, false);
			grid.updataInfo(item);
			num.setNum(item.dzdl);
			var cStr:String=ConfigEnum["equip" + item.eInfo.tips.qh];
			var dataArr:Array=cStr.split("|");
			goldLbl.text=dataArr[1];
			if (1 == int(dataArr[0])) {
				iconImg.updateBmp(ItemUtil.getExchangeIcon(0));
			} else {
				iconImg.updateBmp(ItemUtil.getExchangeIcon(2));
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

		/**
		 * <T>点击按钮使用</T>
		 *
		 * @param event 点击事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			var jb:int=UIManager.getInstance().backpackWnd.jb;
			if (item.cost > jb) {
				// todo:放入强化转移界面
				if (ConfigEnum.EquipTransOpenLv <= Core.me.info.level) {
					if (!UIManager.getInstance().isCreate(WindowEnum.EQUIP) || !UIManager.getInstance().getWindow(WindowEnum.EQUIP).visible) {
						UILayoutManager.getInstance().show(WindowEnum.EQUIP);
					}
					UIManager.getInstance().equipWnd.setDownItem(item.bagInfo, item.eInfo);
				}
			} else {
				Cmd_Equip.cm_EquipTransfer(3, item.eInfo.position, 1, item.bagInfo.pos);
//				Cmd_Bag.cm_bagUse(item.bagInfo.pos);
				var bagInfo:Baginfo=item.bagInfo;
				// 复制背包格子使用
				if (bagInfo.info.classid == ItemEnum.ITEM_TYPE_EQUIP) {

					var olist:Array=ItemEnum.ItemToRolePos[bagInfo.info.subclassid];
					if (null == olist) {
						Cmd_Bag.cm_bagMoveTo(bagInfo.pos, 40, bagInfo.info.subclassid - 13);
						return;
					}
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

		/**
		 * <T>注册使用监听</T>
		 *
		 * @param $clickHandler 监听函数
		 *
		 */
		public function registeredUse($clickHandler:Function):void {
			clickHandler=$clickHandler;
		}
	}
}

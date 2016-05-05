package com.leyou.ui.role.child.children {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.ui.backpack.child.GridModel;
	import com.leyou.utils.FilterUtil;
	
	import flash.geom.Point;

	public class EquipSelectGrid extends GridModel {

		private var _type:int;
		private var moveFlag:Boolean;
		public var doubleEvent:Boolean;

		private var info:Object;

		public function EquipSelectGrid() {
			super();
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_ROLE;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.bgBmp.alpha=0;

			this.selectBmp.updateBmp("ui/backpack/select.png");

			this.selectBmp.x=-1.9;
			this.selectBmp.y=-1.8;

			this.doubleClickEnabled=true;
//			this.mouseEnabled=false;

//			this.opaqueBackground=0xff0000;
		}

		override public function updataInfo(info:Object):void {

			this.reset();

			this.isLock=false;
			this.isEmpty=false;

			if (info == null)
				return;

			super.updataInfo(info);
			this.info=info;

			if (info.info != null && int(info.info.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			if (int(info.tips.qh) > 0)
				this.setIntensify("" + info.tips.qh);

			this.updateTopIconState();

//			if (this.gridType == ItemEnum.TYPE_GRID_EQUIP)
//				this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
//
//			if (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) {
			this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
			this.canMove=false;
//			}

			this.iconBmp.x=(40 - 36) >> 1;
			this.iconBmp.y=(40 - 36) >> 1;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			if (info.info.effect != null && info.info.effect != "0")
				this.playeMc(int(info.info.effect), new Point(0, 0));

			this.addChild(this.intensifyLbl);
		}

		public function setSize(w:Number, h:Number):void {
			this.iconBmp.setWH(w, h);
		}

		override protected function reset():void {
			super.reset();
			this.isLock=false;
			this.isEmpty=true;
			this.iconBmp.bitmapData=null;
			this.enable=true;
			this.stopMc();
			this.topBmp.visible=false;
//			this.intensifyLbl.bitmapData=null;
//			this.bindingBmp.visible=false;
			this.info=null;
		}

		private function updateTopIconState():void {

			var binfo:Baginfo=this.info as Baginfo;
			if (binfo.info.classid != 1 || this.disableBmp.visible || !UIManager.getInstance().selectWnd.visible)
				return;

			var olist:Array=ItemEnum.ItemToRolePos[binfo.info.subclassid];

			var st:int=-1;
			var roleIndex:int;
			var einfo:Object;

			var eobj:Object={};
			if (UIManager.getInstance().selectWnd.type == 0)
				eobj=MyInfoManager.getInstance().equips;
			else if (UIManager.getInstance().selectWnd.type == 1)
				eobj=MyInfoManager.getInstance().mountEquipArr;

			einfo=eobj[UIManager.getInstance().selectWnd.position];

			if (einfo == null || einfo.tips.zdl < binfo.tips.zdl) {
				st=1;
			} else if (einfo.tips.zdl > binfo.tips.zdl) {
				st=0;
			}
//			}

			this.topBmp.visible=true;
			this.changeTopState(st);
		}

		public function clearMe():void {
			this.reset();
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty || this.info == null)
				return;

			var binfo:Baginfo=this.info as Baginfo;

			var einfo:Object;
			var tips:TipsInfo=binfo.tips;
			if (binfo.info.classid == 1) {

				if (UIManager.getInstance().selectWnd.type == 0)
					einfo=MyInfoManager.getInstance().equips[UIManager.getInstance().selectWnd.position];
				else if (UIManager.getInstance().selectWnd.type == 1)
					einfo=MyInfoManager.getInstance().mountEquipArr[UIManager.getInstance().selectWnd.position];
			}

			tips.istype=3;
			if (einfo != null) {
				tips.isdiff=true;
				einfo.tips.isUse=true;
				einfo.tips.isdiff=false;
				ToolTipManager.getInstance().showII([TipEnum.TYPE_EQUIP_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [tips, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
			} else {
				//					this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height))

				var type:int=TipEnum.TYPE_EQUIP_ITEM;

				if (binfo.info.classid == 10) {
					type=TipEnum.TYPE_GEM_OTHER;
				}

				tips.isdiff=false;
				ToolTipManager.getInstance().show(type, tips, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
			}


//			var tips:TipsInfo=this.info.tips;
//			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
		}


		override public function set enable(value:Boolean):void {
			super.enable=value;

			if (!value) {
				this.iconBmp.filters=[FilterUtil.enablefilter];
			} else {
				this.iconBmp.filters=[];
				this.moveFlag=false;
			}

		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);

			if (this.info != null && UIManager.getInstance().selectWnd.visible) {
				if (UIManager.getInstance().selectWnd.type == 2) {

//					var arr:Array=MyInfoManager.getInstance().gemArr[UIManager.getInstance().selectWnd.GemSelectIndex];
//					var tequip:TEquipInfo;
//					for (var i:int=0; i < arr.length; i++) {
//
//						tequip=TableManager.getInstance().getEquipInfo(arr[i]);
//						if (tequip != null && tequip.classid == 10 && tequip.classid == this.info.info.classid && tequip.subclassid == this.info.info.subclassid)
//							break;
//
//						if (int(arr[i]) == 0)
//							break;
//					}

					Cmd_Gem.cmGemInlay(this.info.pos, UIManager.getInstance().selectWnd.GemSelectIndex, UIManager.getInstance().selectWnd.position);

					if (UIManager.getInstance().selectWnd.succEffect != null)
						UIManager.getInstance().selectWnd.succEffect();

				}else if(UIManager.getInstance().selectWnd.type == 3){
					UIManager.getInstance().legendaryWnd.setMaterialEquip(UIManager.getInstance().selectWnd.position, info);
					UIManager.getInstance().selectWnd.hide();
				}else {
					var type:int=(UIManager.getInstance().selectWnd.type == 0 ? 3 : 40);
					Cmd_Bag.cm_bagMoveTo(this.info.pos, type, UIManager.getInstance().selectWnd.position);
					
					GuideManager.getInstance().removeGuide(146);
				}
			}

		}

//
//		override public function mouseMoveHandler($x:Number, $y:Number):void {
////			ItemTip.getInstance().updataPs($x, $y);
//			if (this.moveFlag) {
//				this.enable=false;
//				this.moveFlag=false;
//			}
//
//		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			super.mouseUpHandler($x, $y);


//			var i:int=MyInfoManager.getInstance().getBagEmptyGridIndex();
//
//			if (i == -1) {
//				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//				return;
//			}

			UIManager.getInstance().selectWnd.hide();

		}


	}
}

package com.leyou.ui.shop.child {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.backpack.child.GridModel;
	
	import flash.geom.Point;

	public class ShopGrid extends GridModel {

		private var lockImg:Image;
		private var unUseImg:Image;
//		private var numLbl:Label;
		public var id:int;

		protected var tips:TipsInfo;
		private var tipsInfo:TipsInfo;

		/**
		 * 0,普通商店; 1:神秘商店;2:每日手冲
		 */
		public var type:int=0;

		public function ShopGrid() {

		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");

//			this.lockImg=new Image("ui/backpack/bg_lock.png");
//			this.lockImg.x=2;
//			this.lockImg.y=24;
//			this.addChild(this.lockImg);

//			this.unUseImg=new Image("ui/backpack/bg_unavail.png");
//			this.unUseImg.x=13;
//			this.unUseImg.y=24;
//			this.addChild(this.unUseImg);

//			this.numLbl=new Label();
//			this.numLbl.textColor=0xffffff;
//			this.numLbl.x=22
//			this.numLbl.y=20;
			this.numLbl.text="";
//			this.addChild(this.numLbl);

			this.iconBmp.x=(40 - 36) >> 1;
			this.iconBmp.y=(40 - 36) >> 1;

			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.tips=new TipsInfo();
		}

		override public function updataInfo(info:Object):void {

//			var s:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/icon/icon_hp.png"));
//			s.scale9Grid=new Rectangle(2,2,40,40);
//			s.setSize(35,35);
//			
//			this.iconBmp.bitmapData=s.bitmapData;

			this.reset();
			super.updataInfo(info);
			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");

			this.bgBmp.setWH(65, 65);
			this.selectBmp.bitmapData=null;
			this.iconBmp.setWH(60, 60);

			this.stopMc();
			if (info.effect1 != null && info.effect1 != "0") {
				this.playeMc(int(info.effect1));
			}

			this.tips.itemid=info.id;

			this.numLbl.x=22 + (this.bgBmp.width - 40 - 3);
			this.numLbl.y=24 + (this.bgBmp.height - 40 - 3);

			this.canMove=false;
			this.addChild(this.numLbl);

			this.limitTimeLbl.x=60 - 25;
		}
		
		override protected function reset():void{
			super.reset();
			super.updataInfo(null);
		}
		
		public function clearData():void{
			this.reset();
		}

		public function setSize(w:Number, h:Number):void {

		}

		public function set LockImgSta(f:Boolean):void {
			this.lockImg.visible=f;
		}

		public function set unUseImgSta(f:Boolean):void {
			this.unUseImg.visible=f;
		}

		public function set numLblSta(f:Boolean):void {
			this.numLbl.visible=f;
		}

		public function set numLblTxt(s:String):void {
			this.numLbl.text=s + "";
			this.numLbl.x=this.width-this.numLbl.textWidth;
		}
		
		public function getNum():int{
			return int(this.numLbl.text); 
		}

		public override function mouseOutHandler():void {

		}

		public function settipsInfo(t:TipsInfo):void {
			this.tipsInfo=t;
		}

		public override function mouseOverHandler($x:Number, $y:Number):void {

			if (this.isEmpty)
				return;

			if (type == 0) {
				this.tips.isShowPrice=false;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else if (type == 1) {

				this.tipsInfo.istype=1;

				var binfo:Object=TableManager.getInstance().getItemInfo(tipsInfo.itemid);

				if (binfo == null)
					binfo=TableManager.getInstance().getEquipInfo(tipsInfo.itemid);

				var einfo:EquipInfo;
				if (binfo != null && binfo.classid == 1 && binfo.subclassid < 13) {

					var olist:Array=ItemEnum.ItemToRolePos[binfo.subclassid];

					var st:Boolean=false;
					var roleIndex:int;
					einfo=MyInfoManager.getInstance().equips[olist[0]];

					if (einfo != null) {

						if (olist.length == 2) {
							var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
							if (einfo1 != null) {
								if (einfo.tips.zdl > einfo1.tips.zdl) {
									einfo=einfo1;
								}
							}
						}

					} else {
						if (olist.length == 2)
							einfo=MyInfoManager.getInstance().equips[olist[1]];
					}

				}

				if (einfo != null) {
					tipsInfo.isdiff=true;
					einfo.tips.isUse=true;
					einfo.tips.isdiff=false;
					ToolTipManager.getInstance().showII([TipEnum.TYPE_EMPTY_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [this.tipsInfo, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
				} else {
					
					var _type:int=TipEnum.TYPE_EMPTY_ITEM;
					
					if(binfo.classid==10){
						_type=TipEnum.TYPE_GEM_OTHER;
					}
					
					this.tipsInfo.isShowPrice=false;
					ToolTipManager.getInstance().show(_type, tipsInfo, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
				}

			} else if (type == 2) {

				this.tips.isShowPrice=false;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));

			}
		}

		override public function get width():Number{
			return 60;
		}

		public override function doubleClickHandler():void {

		}

		public override function mouseUpHandler($x:Number, $y:Number):void {

		}
	}
}

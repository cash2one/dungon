package com.leyou.ui.task.child {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.FilterUtil;
	
	import flash.geom.Point;

	public class MissionGrid extends GridBase {

		private var numLbl:Label;

		private var tipsInfo:TipsInfo;

		private var num:int;

		public function MissionGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			this.isLock=false;
//			this.gridType=ItemEnum.TYPE_GRID_B;

			this.numLbl=new Label();
			this.numLbl.x=20;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

//			this.startName=new Label();
//			this.startName.x=(this.width - this.startName.width) / 2;
//			this.startName.y=(this.height - this.startName.height) / 2;
//			this.addChild(this.startName);

			this.bgBmp.updateBmp("ui/common/common_icon_bg.png");

//			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
//			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.dataId=-1;

			this.selectBmp.x=0;
			this.selectBmp.y=0;

			this.selectBmp.width=40;
			this.selectBmp.height=40;

			tipsInfo=new TipsInfo();

			this.updataInfo(null);
		}

		public function updateMoney():void {
			this.iconBmp.updateBmp("ico/items/money.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=1;
		}

		public function updateHun():void {
			this.iconBmp.updateBmp("ico/items/hun.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=2;
		}

		public function updateExp():void {
			this.iconBmp.updateBmp("ico/items/exp.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=3;
		}

		public function updateBg():void {
			this.iconBmp.updateBmp("ico/items/gong.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=4;
		}

		public function updateLive():void {
			this.iconBmp.updateBmp("ico/items/huo.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=5;
		}

		public function updateByb():void {
			this.iconBmp.updateBmp("ico/items/bdzs.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=6;
		}

		override public function get width():Number {
			return 43;
		}

		override public function get height():Number {
			return 43;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			super.updataInfo(info);

			if (info == null)
				return;

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.dataId=info.id;

			this.stopMc();
			if (info != null && info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.addChild(this.numLbl);
		}

		public function setNum(num:String):void {

			var _num:int=int(num);

			if (_num >= 10000) {

				if (_num / 10000 >= 100) {
					this.numLbl.text=Math.floor(_num / 10000) + "万";
				} else {
					this.numLbl.text=(int(_num / 10000) + int(parseFloat(((_num / 10000) - int(_num / 10000)).toPrecision(1)) * 10) / 10) + "万";
				}

			} else {
				this.numLbl.text=(_num) + "";
			}

			this.numLbl.x=this.width - this.numLbl.width - 2;
			this.numLbl.textColor=0xffffff;
			FilterUtil.showBlackStroke(this.numLbl);

//			this.num=Number(num);

			this.addChild(this.numLbl);
			this.canMove=false;
		}

		override protected function reset():void {
			super.reset();
			super.updataInfo(null);
			this.numLbl.text="";
			this.dataId=-1;
			this.stopMc();
			this.iconBmp.bitmapData=null;
			//this.gridId=this.initId;
		}

		override public function switchHandler(fromItem:GridBase):void {


		}

		public function setTipsNum(n:int):void {
			this.tipsInfo.moneyNum=n;
		}

		public function setTipsPriceIsshow(v:Boolean=true):void {
			this.tipsInfo.isShowPrice=v;
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty || this.dataId == -1)
				return;

			if (this.dataId == 65535) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "金币" + (this.tipsInfo.moneyNum == 0 ? "" : ":" + this.tipsInfo.moneyNum), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else if (this.dataId == 65534) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "经验" + (this.tipsInfo.moneyNum == 0 ? "" : ":" + this.tipsInfo.moneyNum), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else if (this.dataId == 65533) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "魂力" + (this.tipsInfo.moneyNum == 0 ? "" : ":" + this.tipsInfo.moneyNum), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else if (this.dataId == 65531) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "行会贡献" + (this.tipsInfo.moneyNum == 0 ? "" : ":" + this.tipsInfo.moneyNum), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else if (this.dataId == 65532) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "绑定钻石" + (this.tipsInfo.moneyNum == 0 ? "" : ":" + this.tipsInfo.moneyNum), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else {
				
				var info:Object=(TableManager.getInstance().getItemInfo(this.dataId) || TableManager.getInstance().getEquipInfo(this.dataId));
				var type:int=TipEnum.TYPE_EMPTY_ITEM;
				if(info.classid==10){
					type=TipEnum.TYPE_GEM_OTHER;
				}
				
				this.tipsInfo.itemid=this.dataId;
				this.tipsInfo.isShowPrice=false;
				ToolTipManager.getInstance().show(type, tipsInfo, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			}

		}

	}
}

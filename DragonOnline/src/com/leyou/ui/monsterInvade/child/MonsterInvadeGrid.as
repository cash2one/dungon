package com.leyou.ui.monsterInvade.child {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.FilterUtil;
	
	import flash.geom.Point;

	public class MonsterInvadeGrid extends GridBase {

		private var tipsinfo:TipsInfo;

		private var numLbl:Label;

		public function MonsterInvadeGrid(id:int=-1) {
			super(id, true);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);

			this.bgBmp.updateBmp("ui/backpack/bg.png");
			this.iconBmp.updateBmp("ui/backpack/lock.png");
			this.selectBmp.updateBmp("ui/backpack/select.png");

			this.bgBmp.setWH(60, 60);

			this.numLbl=new Label();
			this.numLbl.x=30;
			this.numLbl.y=40;
			this.addChild(this.numLbl);

			this.tipsinfo=new TipsInfo();
			this.updataInfo(null);
		}

		override public function updataInfo(info:Object):void {
			this.unlocking();
			this.reset();

			if (info == null)
				return;

			this.iconBmp.updateBmp("ico/skills/" + info.icon + ".png");
			this.tipsinfo.itemid=info.id;
		}

		public function updateMoney():void {
			this.iconBmp.updateBmp("ico/items/money.png");
//			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
//			this.iconBmp.setWH(36,36);
		}
		
		public function updateExp():void {
			this.iconBmp.updateBmp("ico/items/exp.png");
			//			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			//			this.iconBmp.setWH(36,36);
		}

		public function updateHun():void {
			this.iconBmp.updateBmp("ico/items/hun.png");
//			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
//			this.iconBmp.setWH(36, 36);
			
//			this.dataId=2;
		}
		
		public function setNum(num:String):void {
			this.numLbl.text=num + "";
			this.numLbl.x=this.width - this.numLbl.width-5;
			FilterUtil.showBlackStroke(this.numLbl);

			this.canMove=false;
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			
			if (this.tipsinfo.itemid != 0)
				ToolTipManager.getInstance().show(TipEnum.TYPE_BUFF, this.tipsinfo, new Point($x, $y));
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ToolTipManager.getInstance().hide();
		}



	}
}

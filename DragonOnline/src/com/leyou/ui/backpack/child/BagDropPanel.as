package com.leyou.ui.backpack.child {

	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class BagDropPanel extends AutoWindow {

		private var dropBtn:NormalButton;
		private var saveBtn:NormalButton;

		private var itemName:Label;

		private var itemGrid:BackpackGrid;
		private var info:GridBase;

		private var stateLbl:Label;

		public function BagDropPanel() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd04.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
		}

		private function init():void {
			this.dropBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.saveBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.itemName=this.getUIbyID("nameLbl") as Label;
			this.stateLbl=this.getUIbyID("stateLbl") as Label;

			this.dropBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.saveBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.itemGrid=new BackpackGrid(-1);
			this.addChild(this.itemGrid);

//			this.itemGrid.setSize(60,60);
			this.itemGrid.enableMouseUpEvent=false;

//			this.itemGrid.mouseChildren=false;
//			this.itemGrid.mouseEnabled=false;

			this.itemGrid.x=118;
			this.itemGrid.y=55;
		}

		private function update(info:Baginfo):void {
			this.itemGrid.updataInfo(info);
			this.itemGrid.setSize(60, 60);

			this.itemName.text=info.info.name + "";
			this.itemName.textColor=ItemUtil.getColorByQuality(int(info.info.quality));

			this.itemName.x=this.width - this.itemName.width >> 1;

			if (info.info.bind == 1) {
				this.stateLbl.text=PropUtils.getStringById(1631);
			} else {
				this.stateLbl.text=PropUtils.getStringById(1630);
			}
		}

		public function showPanel(info:GridBase):void {
			if (this.visible) {
				this.info.enable=true;
			}

			super.show();
			update(info.data as Baginfo);

			this.info=info;
			info.enable=false;

			this.itemGrid.canMove=false;
			this.itemGrid.isLock=true;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					if (this.info != null && this.info.data != null && this.info.data.info != null)
						Cmd_Bag.cm_bagDelete(this.info.data.pos);
					break;
				case "cancelBtn":

					break;
			}

			this.hide();
		}

		override public function hide():void {
			super.hide();

			BackpackGrid.menuState=-1;

			if (this.info != null)
				this.info.enable=true;
		}

	}
}

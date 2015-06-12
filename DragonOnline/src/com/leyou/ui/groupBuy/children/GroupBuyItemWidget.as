package com.leyou.ui.groupBuy.children {
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_GBUY;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GroupBuyItemWidget extends AutoSprite {
		private var pcountLbl:Label;

		private var receiveBtn:NormalButton;

		private var grid:MaillGrid;

		private var _pcount:int;

		private var id:int;

		private var status:int;

		public function GroupBuyItemWidget() {
			super(LibManager.getInstance().getXML("config/ui/groupBuy/groupbuyBtn.xml"));
			init();
		}

		public function get pcount():int {
			return _pcount;
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			grid=new MaillGrid();
			grid.x=5;
			grid.isShowPrice=false;
			addChild(grid);
			pcountLbl=getUIbyID("pcountLbl") as Label;
			receiveBtn=getUIbyID("receiveBtn") as NormalButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "receiveBtn":
					Cmd_GBUY.cm_GBUY_J(id, pcount);
					break;
			}
		}

		public function flyGift():void {
			FlyManager.getInstance().flyBags([grid.dataId], [grid.localToGlobal(new Point(0, 0))]);
		}

		public function updateInfo(itemId:int, itemCount:int, count:int, $status:int, $id:int):void {
			grid.updateInfo(itemId, itemCount);
			_pcount=count;
			id=$id;
			status=$status;
			pcountLbl.text=count + PropUtils.getStringById(1723);
			// 0 -- 未达成 1 -- 可领取 2 -- 已领取 3 -- 可领取但未购买
			receiveBtn.setActive((1 == status), 1, true);
			receiveBtn.visible=(0 != status);
			if (0 == status) {
				receiveBtn.text=PropUtils.getStringById(1576);
			} else if (1 == status) {
				receiveBtn.text=PropUtils.getStringById(1724);
			} else if (2 == status) {
				receiveBtn.text=PropUtils.getStringById(1574);
			} else if (3 == status) {
				receiveBtn.text=PropUtils.getStringById(1724);
			}
		}
	}
}

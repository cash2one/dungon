package com.leyou.ui.v3exp {

	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.task.child.MissionGrid;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;

	public class SellExpWnd2 extends AutoSprite {

		private var getBtn:NormalButton;

		private var itemGrid:Array=[];

		private var t1nameLbl:Label;

		public function SellExpWnd2() {
			super(LibManager.getInstance().getXML("config/ui/v3exp/sellExpWnd2.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.t1nameLbl=this.getUIbyID("t1nameLbl") as Label;
			this.getBtn=this.getUIbyID("getBtn") as NormalButton;
			this.getBtn.addEventListener(MouseEvent.CLICK, onClick);

		}

		public function updateInfo(o:Array):void {

			var g:MissionGrid;

			for (var i:int=0; i < o.length; i++) {
				g=new MissionGrid();
				this.addChild(g);

				g.updataInfo(TableManager.getInstance().getItemInfo(o[i][0]));

				g.x=20 + i * 52;
				g.y=432;
			}

		}

		public function setGetBtnState(v:Boolean):void {
			this.getBtn.visible=v;

			if (v) {
				this.t1nameLbl.text="" + TableManager.getInstance().getSystemNotice(10175).content;
			} else {
				this.t1nameLbl.text="" + TableManager.getInstance().getSystemNotice(10176).content;
			}
		}

		private function onClick(e:MouseEvent):void {
			PayUtil.openPayUrl()
//			UILayoutManager.getInstance().open_II(WindowEnum.TOPUP);
		}

	}
}

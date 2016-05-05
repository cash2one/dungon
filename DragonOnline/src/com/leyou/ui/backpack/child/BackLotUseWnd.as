package com.leyou.ui.backpack.child {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.greensock.TweenMax;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.MouseEvent;

	public class BackLotUseWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var numinput:TextInput;
		private var maxNumBtn:NormalButton;

		private var nameLbl:Label;
		private var maxInt:int=0;
		private var grid:BackpackGrid;

		public function BackLotUseWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/BackLotUseWnd.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.numinput=this.getUIbyID("numInput") as TextInput;
			this.maxNumBtn=this.getUIbyID("maxNumBtn") as NormalButton;
			this.numinput.restrict="0-9";

			this.numinput.input.defaultTextFormat=FontEnum.getTextFormat("Gold12Center");
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.maxNumBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.grid=new BackpackGrid(-1);
			this.grid.x=42;
			this.grid.y=73;

			this.addChild(this.grid);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					if (this.numinput.text != null && this.numinput.text != "") {

						if (this.grid.data!=null && int(this.grid.data.info.subclassid) == 29) {
							if (ConfigEnum.DragonBall10 > Core.me.info.level) {
								NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
								return;
							}

							if (!UIManager.getInstance().roleWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

							var aid:int=grid.data.aid;
							TweenMax.delayedCall(.6, function():void {
								UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MEDIC, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
								UIManager.getInstance().medicWnd.setUseSelect(aid);
								hide()
							});

							Cmd_Bag.cm_bagUse(this.grid.dataId, int(this.numinput.text));
							Cmd_Longz.cm_Longz_D();
							
						} else {
							Cmd_Bag.cm_bagUse(this.grid.dataId, int(this.numinput.text));
							this.hide()
						}

					}
					
					break;
				case "cancelBtn":
					this.hide()
					break;
				case "maxNumBtn":
//					Cmd_Bag.cm_bagUse(this.grid.dataId, this.grid.data.num);
					this.numinput.text="" + this.maxInt;
					break;
			}

		}

		public function showPanel(pos:int):void {
			super.show();

			var data:*=MyInfoManager.getInstance().bagItems[pos]

			this.grid.updataInfo(data);
			this.grid.setSize(60, 60);
//			this.grid.mouseChildren=false;
//			this.grid.mouseEnabled=false;

			this.nameLbl.text=data.info.name + "";
			this.nameLbl.textColor=ItemUtil.getColorByQuality(int(data.info.quality));
			
			this.numinput.text="" + data.num;
			this.maxInt=data.num;

			this.stage.focus=this.numinput.input;
			this.numinput.input.setSelection(0, this.numinput.input.length);



		}



	}
}

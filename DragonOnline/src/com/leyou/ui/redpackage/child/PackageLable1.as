package com.leyou.ui.redpackage.child {

	import com.ace.enum.FontEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TRed_package;
	import com.ace.manager.LibManager;
	import com.ace.manager.SkinsManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Package;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class PackageLable1 extends AutoSprite {

		private var nameLbl:Label;
		private var typeLbl:Label;
		private var countLbl:Label;
		private var lastCountLbl:Label;

		private var getBtn:NormalButton;
		private var get1Btn:NormalButton;

		private var sinfo:Object;

		private var isOpen:Boolean=false;

		public function PackageLable1() {
			super(LibManager.getInstance().getXML("config/ui/package/child/packageLable1.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.typeLbl=this.getUIbyID("typeLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.lastCountLbl=this.getUIbyID("lastCountLbl") as Label;

			this.get1Btn=this.getUIbyID("get1Btn") as NormalButton;
			this.getBtn=this.getUIbyID("getBtn") as NormalButton;

			this.get1Btn.updataBmd("style4Scale");

			this.getBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.get1Btn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			if (this.sinfo == null)
				return;

//			if (!this.isOpen) {
//
//				UILayoutManager.getInstance().hide(WindowEnum.REDPACKAGE_OPENLIST);
//
//				if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE_OPEN))
//					UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE_OPEN);
//
//				UILayoutManager.getInstance().show(WindowEnum.REDPACKAGE_OPEN);
//				UIManager.getInstance().redPackOpenWnd.updateInfo(this.sinfo);
//
//			} else {
//
//				UILayoutManager.getInstance().hide(WindowEnum.REDPACKAGE_OPEN);
//
//				if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE_OPENLIST))
//					UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE_OPENLIST);
//
//				UILayoutManager.getInstance().show(WindowEnum.REDPACKAGE_OPENLIST);
//
//				UIManager.getInstance().redPackObWnd.updateInfo(this.sinfo);
//				
//			}

			Cmd_Package.cm_package_H(this.sinfo[0]);
		}

		public function updateInfo(o:Object):void {

			this.sinfo=o;

			var tinfo:TRed_package=TableManager.getInstance().getRedPackageById(o[1]);

			this.nameLbl.text="" + o[2];
			this.typeLbl.text="" + tinfo.Red_Name;
			this.countLbl.text="" + tinfo.Red_Quota + PropUtils.getStringById(40);
			this.lastCountLbl.text=int(tinfo.Red_Num) - int(o[5]) + "/" + tinfo.Red_Num;

			this.isOpen=false;
			var list:Array=o[6];
			for (var i:int=0; i < list.length; i++) {

				if (MyInfoManager.getInstance().name == list[i][1]) {
					this.isOpen=true;
					break;
				}

			}

			if (int(o[5]) != 0 && int(o[5]) == int(tinfo.Red_Num)) {
				this.isOpen=true;
			}

			this.get1Btn.visible=this.isOpen;
			this.getBtn.visible=!this.isOpen;
		}



	}
}

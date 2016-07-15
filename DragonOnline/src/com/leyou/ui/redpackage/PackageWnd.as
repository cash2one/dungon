package com.leyou.ui.redpackage {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Package;
	import com.leyou.ui.redpackage.child.PackageLable1;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class PackageWnd extends AutoWindow {

		private var exchangeLbl:Label;
		private var pageLbl:Label;
		private var countLbl:Label;
		private var descLbl:Label;

		private var leftBtn:ImgButton;
		private var rightBtn:ImgButton;

		private var itemlist:Vector.<PackageLable1>;

		private var currentIndex:int=1;
		private var count:int=0;
		private var pagecount:int=9;

		public function PackageWnd() {
			super(LibManager.getInstance().getXML("config/ui/packageWnd.xml"));
			this.init();

		}

		private function init():void {

			this.exchangeLbl=this.getUIbyID("exchangeLbl") as Label;
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.leftBtn=this.getUIbyID("leftBtn") as ImgButton;
			this.rightBtn=this.getUIbyID("rightBtn") as ImgButton;

			this.leftBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rightBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.exchangeLbl.addEventListener(MouseEvent.CLICK, onItemClick);
			this.exchangeLbl.mouseEnabled=true;

			this.itemlist=new Vector.<PackageLable1>();

			var lb1:PackageLable1;
			for (var i:int=0; i < 9; i++) {
				lb1=new PackageLable1();
				this.addChild(lb1);
				this.itemlist.push(lb1);

				lb1.x=pagecount;
				lb1.y=140 + i * 36;
			}

			this.descLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2479), ConfigEnum.RedBag2);
		}

		private function onItemClick(e:MouseEvent):void {
			PayUtil.openPayUrl();
		}

		private function onClick(e:MouseEvent):void {

			var pc:int=0;
			if (this.count % pagecount == 0)
				pc=this.count / pagecount;
			else
				pc=this.count / pagecount + 1;

			switch (e.target.name) {
				case "rightBtn":
					this.currentIndex++;
					if (this.currentIndex >= pc - 1)
						this.currentIndex=pc - 1;

					Cmd_Package.cm_package_I(this.currentIndex * pagecount + 1, this.currentIndex * pagecount + pagecount);
					break;
				case "leftBtn":
					this.currentIndex--;
					if (this.currentIndex <= 0) {
						this.currentIndex=0;
						Cmd_Package.cm_package_I(1, 9);
					} else
						Cmd_Package.cm_package_I(this.currentIndex * pagecount + 1, this.currentIndex * pagecount + pagecount);
					break;
			}

//			var page:int=(this.currentIndex <= 0 ? 1 : this.currentIndex);
//			var page:int=this.currentIndex + 1;
//			this.pageLbl.text=page + "/" + pc;
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			this.currentIndex=0
//			Cmd_Package.cm_package_I(1, 9);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			this.currentIndex=0;
			Cmd_Package.cm_package_I(1, 9);
		}


		public function updateInfo(o:Object):void {

			UIManager.getInstance().showPanelCallback(WindowEnum.REDPACKAGE);

			this.count=o.sc;
			this.countLbl.text=o.cc + "";

			var pc:int=0;
			if (this.count % pagecount == 0)
				pc=this.count / pagecount;
			else
				pc=this.count / pagecount + 1;

			var page:int=this.currentIndex + 1;

			if (pc <= 0)
				pc=1;

			this.pageLbl.text=page + "/" + pc;

			var list:Array=o.hblist;
			var lb1:PackageLable1;
			for (var i:int=0; i < this.itemlist.length; i++) {
				lb1=this.itemlist[i];

				if (i >= list.length) {
					lb1.visible=false;
				} else {
					lb1.updateInfo(list[i]);
					lb1.visible=true;
				}

			}

			UIManager.getInstance().toolsWnd.setRedPackageBtnEffect(o.cc);
		}


		public function sendPagexx():void {
			if (this.currentIndex <= 0) {
				this.currentIndex=0;
				Cmd_Package.cm_package_I(1, 9);
			} else
				Cmd_Package.cm_package_I(this.currentIndex * pagecount + 1, this.currentIndex * pagecount + pagecount);
		}

	}
}

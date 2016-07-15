package com.leyou.ui.redpackage {

	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TRed_package;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.ui.redpackage.child.PackageLable2;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class PackabeObWnd extends AutoWindow {


		private var getLbl:Label;
		private var countLbl:Label;
		private var iconImg:Image;
		private var closeBtn:NormalButton;
		private var itemList:ScrollPane;

		private var itemlistArr:Array=[];

		public function PackabeObWnd() {
			super(LibManager.getInstance().getXML("config/ui/package/packabeObWnd.xml"));
			this.init();
		}

		private function init():void {
			this.getLbl=this.getUIbyID("getLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.closeBtn=this.getUIbyID("closeBtn") as NormalButton;
			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.closeBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.clsBtn.visible=false;
		}

		private function onClick(e:MouseEvent):void {

			this.hide();
		}

		public function updateInfo(o:Object):void {

			var tinfo:TRed_package=TableManager.getInstance().getRedPackageById(o[1]);

			this.getLbl.text=StringUtil.substitute(PropUtils.getStringById(2486), [o[6].length, tinfo.Red_Num]);

			this.iconImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(o[3], o[4]));

			var lb:PackageLable2;
			for each (lb in this.itemlistArr) {
				if (lb != null)
					this.itemList.delFromPane(lb);
			}

			this.itemlistArr.length=0;
			var list:Array=o[6];
			var i:int=0;
			var cross:int=-1;
			if (o[5] == int(tinfo.Red_Num)) {


				var max:int=0;
				var maxArr:Array=[];
				for (i=0; i < list.length; i++) {

					if (max == list[i][0]) {
						maxArr.push(i);
					}

					if (max < list[i][0]) {
						max=list[i][0];
						maxArr=[];
						maxArr.push(i);
					}
				}


				if (maxArr.length > 1) {

					var date:Date=TimeUtil.getStringToDate(list[maxArr[0]][2]);
					var date1:Date;
					for (i=1; i < maxArr.length; i++) {
						date1=TimeUtil.getStringToDate(list[maxArr[i]][2]);

						if (date < date1) {
							date=date1;
							cross=maxArr[i]
						}
					}
				} else {
					cross=maxArr[0];
				}


			}

			var num:int=0;
			for (i=0; i < list.length; i++) {

				lb=new PackageLable2();

				this.itemList.addToPane(lb);
				this.itemlistArr.push(lb);

				lb.updateInfo(list[i], (cross == i));

				lb.y=i * 20;

				if (MyInfoManager.getInstance().name == list[i][1])
					num=list[i][0];
			}

			if (o[5] == int(tinfo.Red_Num)) {
				this.countLbl.text="" + PropUtils.getStringById(2491);
			} else
				this.countLbl.text=num + "" + PropUtils.getStringById(40);
		}


	}
}

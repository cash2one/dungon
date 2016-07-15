package com.leyou.ui.redpackage {

	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.Living;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TRed_package;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Package;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class PackabeOpenWnd extends AutoWindow {

		private var nameLbl:Label;
		private var playLbl:Label;
		private var vipLbl:Label;
		private var lastLbl:Label;
		private var countLbl:Label;
		private var getCountLbl:Label;
		private var exchangeLbl:Label;

		private var iconImg:Image;

		private var getBtn:ImgButton;

		private var id:int=0;

		public function PackabeOpenWnd() {
			super(LibManager.getInstance().getXML("config/ui/package/packabeOpenWnd.xml"));
			this.init();
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.playLbl=this.getUIbyID("playLbl") as Label;
			this.vipLbl=this.getUIbyID("vipLbl") as Label;
			this.lastLbl=this.getUIbyID("lastLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.getCountLbl=this.getUIbyID("getCountLbl") as Label;
			this.exchangeLbl=this.getUIbyID("exchangeLbl") as Label;

			this.iconImg=this.getUIbyID("iconImg") as Image;

			this.getBtn=this.getUIbyID("getBtn") as ImgButton;

			this.getBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.exchangeLbl.addEventListener(MouseEvent.CLICK, onitemClick);
			this.exchangeLbl.mouseEnabled=true;
		}

		private function onitemClick(e:MouseEvent):void {
			PayUtil.openPayUrl();
		}

		private function onClick(e:MouseEvent):void {
			Cmd_Package.cm_package_D(this.id);

			if (!UIManager.getInstance().isCreate(WindowEnum.REDPACKAGE))
				UIManager.getInstance().creatWindow(WindowEnum.REDPACKAGE);

			UIManager.getInstance().redPackWnd.sendPagexx();

		}

		public function updateInfo(o:Object):void {

			this.id=o[0];

			var tinfo:TRed_package=TableManager.getInstance().getRedPackageById(o[1]);

			this.nameLbl.text="" + tinfo.Red_Name;
			this.playLbl.text="" + o[2];

			if (tinfo.Red_Type == "1")
				this.vipLbl.text="" + PropUtils.getStringById(2483) + "VIP"+tinfo.Red_Term;
			else if (tinfo.Red_Type == "2"){
				var living:TLivingInfo=TableManager.getInstance().getLivingInfo(int(tinfo.Red_Term));
				
				this.vipLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2489), [living.name]);
			}

			this.countLbl.text="" + tinfo.Red_Quota;
			this.lastLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2485), int(tinfo.Red_Num) - int(o[5]));

			this.getCountLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2481), ConfigEnum.RedBag2);

			this.iconImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(o[3], o[4]));
		}

	}
}

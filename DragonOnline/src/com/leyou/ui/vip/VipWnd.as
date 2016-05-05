package com.leyou.ui.vip {
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.vip.VipData;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class VipWnd extends AutoWindow {

		//		private var vipArm:VipArmBar;

		private var vipImg:Image;

		private var payBtn:ImgButton;

		private var receiveBtn:ImgButton;

		private var desLbl:Label;

		private var rightsRender:VipRightsRender;

		private var listRender:VipListRender;

		private var progressBImg:Image;

		private var progressCImg:Image;

		private var tecentVipLbl:Label;

		private var welfareBtn:ImgButton;

		private var privilegeBtn:ImgButton;

		public function VipWnd() {
			super(LibManager.getInstance().getXML("config/ui/vip/vipWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
//			clsBtn.x += 4;
			clsBtn.y+=30;

			rightsRender=new VipRightsRender();
			rightsRender.x=35;
			rightsRender.y=240;
			addChild(rightsRender);

			listRender=new VipListRender();
			listRender.x=35;
			listRender.y=240;
			addChild(listRender);
			listRender.visible=false;

			vipImg=getUIbyID("vipImg") as Image;
			desLbl=getUIbyID("desLbl") as Label;
			payBtn=getUIbyID("payBtn") as ImgButton;
			progressBImg=getUIbyID("progressBImg") as Image;
			progressCImg=getUIbyID("progressCImg") as Image;
			receiveBtn=getUIbyID("receiveBtn") as ImgButton;
			tecentVipLbl=getUIbyID("tecentVipLbl") as Label;
			welfareBtn=getUIbyID("welfareBtn") as ImgButton;
			privilegeBtn=getUIbyID("privilegeBtn") as ImgButton;
			tecentVipLbl.visible=Core.TX_VIPTIP;
			if (!Core.PAY_OPEN) {
				payBtn.setActive(false, 1, true);
			} else {
				payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}

			welfareBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			privilegeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			welfareBtn.turnOn(false);
			privilegeBtn.turnOff(false);
		}

		private function setVipLv(value:int):void {
			vipImg.updateBmp("ui/vip/" + value + ".png");
		}

		private function setVipProgress(value:Number):void {
			var w:int=332 * value;
			var rect:Rectangle=progressCImg.scrollRect;
			if (null == rect) {
				rect=new Rectangle(0, 0, w, 17);
			}
			rect.width=w;
			progressCImg.scrollRect=rect;
		}

		public function updateVipLv():void {
			var vipLv:int=Core.me.info.vipLv;
			setVipLv(vipLv);
			rightsRender.updateVipLv(vipLv);

			//			if((vipLv < 10 && vipLv > 0) && (null == vipArm)){
			//				vipArm = new VipArmBar();
			//				vipArm.x = 780;
			//				vipArm.y = 28;
			//				addChild(vipArm);
			//			}else if((vipLv >= 10) && (null != vipArm)){
			//				removeChild(vipArm);
			//				vipArm.die();
			//				vipArm = null;
			//			}
			//			if(null != vipArm){
			//				vipArm.updateInfo();
			//			}
		}

		private function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "welfareBtn":
					welfareBtn.turnOn(false);
					privilegeBtn.turnOff(false);
					rightsRender.visible=true;
					listRender.visible=false;
					break;
				case "privilegeBtn":
					privilegeBtn.turnOn(false);
					welfareBtn.turnOff(false);
					rightsRender.visible=false;
					listRender.visible=true;
					break;
				case "payBtn":
					PayUtil.openPayUrl();
					break;
				default:
					break;
			}
		}

		public function flyItem():void {
			rightsRender.flyItem();
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			updateVipLv();
			Cmd_Vip.cm_VIP_I();
		}

		public function updateReward():void {
			//			rightsRender.updateStatus();
			var data:VipData=DataManager.getInstance().vipData;
			var vipLv:int=data.vipLv;
			var vipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(vipLv);
			var nVipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(vipLv + 1);
			var content:String=TableManager.getInstance().getSystemNotice(6002).content;
			//			if(Core.isTencent && (vipLv <= 0)){
			//				desLbl.visible = false;
			//				setVipProgress(0);
			//			}else{
			//				desLbl.visible = true;
			var rate:Number=0;
			if ((null != vipInfo) && (null != nVipInfo)) {
				content=StringUtil.substitute(content, nVipInfo.cost - data.cnum, vipLv + 1);
				desLbl.text=content;

				rate=data.cnum / nVipInfo.cost;
				setVipProgress(rate);
			} else if ((null == vipInfo) && (null != nVipInfo)) {
				// 0级
				content=StringUtil.substitute(content, nVipInfo.cost - data.cnum, vipLv + 1);
				desLbl.text=content;

				rate=data.cnum / nVipInfo.cost;
				setVipProgress(rate);
			} else if ((null != vipInfo) && (null == nVipInfo)) {
				// 顶级
				desLbl.visible=false;
				setVipProgress(1);
			}
			//			}
			rightsRender.switchToObtainable();
		}
	}
}

package com.leyou.ui.delivery {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Assist;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.ui.delivery.childs.DeliveryRender;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class DeliveryWnd extends AutoWindow {

		private var refreshTimeLbl:Label;
		private var descTxt:TextArea;
		private var lastCountLbl:Label;
		private var nowRefreshBtn:ImgButton;

		private var renderVec:Vector.<DeliveryRender>;

		private var prop:SimpleWindow;

		private var timer:int=0;

		private var showfastEff:TweenMax;

		public function DeliveryWnd() {
			super(LibManager.getInstance().getXML("config/ui/deliveryWnd.xml"));
			this.init();
		}

		private function init():void {

			this.refreshTimeLbl=this.getUIbyID("refreshTimeLbl") as Label;
			this.descTxt=this.getUIbyID("descTxt") as TextArea;
			this.lastCountLbl=this.getUIbyID("lastCountLbl") as Label;
			this.nowRefreshBtn=this.getUIbyID("nowRefreshBtn") as ImgButton;

			this.nowRefreshBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.descTxt.visibleOfBg=false;
			this.descTxt.setHtmlText(TableManager.getInstance().getSystemNotice(4516).content);

			this.renderVec=new Vector.<DeliveryRender>();

			var render:DeliveryRender;
			for (var i:int=0; i < 3; i++) {
				render=new DeliveryRender();

				render.x=17;
				render.y=53 + i * (119);

				render.index=(i + 1);

				this.addChild(render);
				this.renderVec.push(render);
			}


		}


		public function updateInfo(o:Object):void {

			var render:DeliveryRender;
			for (var i:int=0; i < this.renderVec.length; i++) {
				render=this.renderVec[i];
				render.updateInfo(o.cart[i]);
			}

			this.lastCountLbl.text=o.ynum + "/" + o.zynum;

//			if (o.ynum == o.zynum) {
//				this.nowRefreshBtn.setActive(false, .6, true);
//			} else {
//				this.nowRefreshBtn.setActive(true, 1, true);
//			}

			if (this.timer == 0)
				this.timer=o.rtime;
//			this.refreshTimeLbl.text=TimeUtil.getIntToDateTime(this.timer);

			TimerManager.getInstance().add(exeTime);

			if (this.timer == 0 && o.ynum < o.zynum) {
				this.nowRefreshBtn.filters=[];
				if (this.showfastEff == null)
					showfastEff=TweenMax.to(this.nowRefreshBtn, 2, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

				this.nowRefreshBtn.updataBmd("ui/delivery/btn_shuaxin2.png");
			} else {
				if (showfastEff != null)
					showfastEff.kill();

				showfastEff=null;
				this.nowRefreshBtn.filters=[];
				this.nowRefreshBtn.updataBmd("ui/delivery/btn_shuaxin.png");
			}

		}

		private function exeTime(i:int):void {

			if (this.timer - i > 0) {
				this.refreshTimeLbl.text=TimeUtil.getIntToDateTime(this.timer - i);
			} else {
				this.timer=0;
				this.refreshTimeLbl.text=StringUtil.substitute(PropUtils.getStringById(2144), [0, 0, 0]);
				this.nowRefreshBtn.updataBmd("ui/delivery/btn_shuaxin2.png");
				TimerManager.getInstance().remove(exeTime);
			}

		}


		private function onBtnClick(e:MouseEvent):void {

			if (this.timer == 0)
				Cmd_Yct.cm_DeliveryRefresh();
			else {
				var str:String;
				if (Core.isSF)
					str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(4518).content, [ConfigEnum.delivery10.split("|")[0]])
				else
					str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(4501).content, [ConfigEnum.delivery10.split("|")[0]])

				prop=PopupManager.showRadioConfirm(str, ConfigEnum.delivery10.split("|")[0], ConfigEnum.delivery10.split("|")[1], function(i:int):void {

					Cmd_Yct.cm_DeliveryRefresh((i == 1 ? 0 : 1));
				}, null, false, "deliveryNowRefresh");
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {

			if (ConfigEnum.delivery19 > Core.me.info.level)
				return;

			super.show(toTop, $layer, toCenter);
			this.resise();
			Cmd_Yct.cm_DeliveryInit();
		}

		override public function get width():Number {
			return 778;
		}

		override public function get height():Number {
			return 428;
		}

		override public function hide():void {
			super.hide();

//			TimerManager.getInstance().remove(exeTime);

			if (prop != null)
				prop.hide()

			if (DeliveryRender.prop != null)
				DeliveryRender.prop.hide()
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

	}
}

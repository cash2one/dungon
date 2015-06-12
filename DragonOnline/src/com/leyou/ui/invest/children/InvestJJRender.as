package com.leyou.ui.invest.children {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.invest.InvestData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Invest;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class InvestJJRender extends AutoSprite {
		private var desLbl:Label;

		private var investLbl:Label;

		private var sumLbl:Label;

		private var vlImg:Image;

		private var flagImg:Image;

		private var flagBtn:ImgButton;

		private var spanLblDic:Object;

		private var spanImgDic:Object;

		private var receiveFlags:Object;

		private var fundStatus:int;

		private var num:RollNumWidget;

		public function InvestJJRender() {
			super(LibManager.getInstance().getXML("config/ui/invest/cajhRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			spanLblDic={};
			spanImgDic={};
			receiveFlags={};
			desLbl=getUIbyID("desLbl") as Label;
			desLbl.multiline=true;
			flagImg=getUIbyID("flagImg") as Image;
			flagBtn=getUIbyID("flagBtn") as ImgButton;
			investLbl=getUIbyID("investLbl") as Label;
			sumLbl=getUIbyID("sumLbl") as Label;
			vlImg=getUIbyID("vlImg") as Image;
			flagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			desLbl.htmlText=TableManager.getInstance().getSystemNotice(5327).content;

			var lblIdx:int=0;
			var investDic:Object=TableManager.getInstance().getInvestDic();
			for (var key:String in investDic) {
				var lv:int=investDic[key].lv;
				var byb:int=investDic[key].byb;

				lblIdx++;
				var lblName:String=StringUtil.substitute("span{1}Lbl", lblIdx);
				var lbl:Label=getUIbyID(lblName) as Label;
				spanLblDic[lv]=lbl;
				lbl.text=lv + "";

				var img:Image=new Image("ui/tzlc/licai_arrow.png");
				addChild(img);
				img.x=lbl.x + 2;
				img.y=50 + 329 * (1 - byb / ConfigEnum.invest14);
				img.scrollRect=new Rectangle(0, 0, 16, 329 * byb / ConfigEnum.invest14);
				spanImgDic[lv]=img;

				var receiveFlag:InvestJJBtn=new InvestJJBtn();
				receiveFlags[lv]=receiveFlag;
				addChild(receiveFlag);
				receiveFlag.updateValue(byb);
				receiveFlag.updateStatus(false);
				receiveFlag.x=img.x - 17;
				receiveFlag.y=img.y - 55;
			}

			var url:String="ui/name/vip{1}.jpg";
			vlImg.updateBmp(StringUtil.substitute(url, ConfigEnum.invest11));
			var tztext:String=PropUtils.getStringById(1767);
			investLbl.text=StringUtil.substitute(tztext, ConfigEnum.invest12);
			var gottext:String=PropUtils.getStringById(1768);
			sumLbl.text=StringUtil.substitute(gottext, ConfigEnum.invest15);
			num=new RollNumWidget();
			num.x=369;
			num.y=52;
			num.alignRound();
			num.loadSource("ui/num/{num}_lz.png");
			addChild(num);
			num.setNum(ConfigEnum.invest13 * 100);
		}

		protected function onBtnClick(event:MouseEvent):void {
			if (1 == DataManager.getInstance().investData.fundStatus) {
				Cmd_Invest.cm_TZ_D();
			} else {
				var content:String=TableManager.getInstance().getSystemNotice(5328).content;
				content=StringUtil.substitute(content, ConfigEnum.invest12);
				PopupManager.showConfirm(content, buyFun, null, false, "tzlc.buy");
			}
		}

		private function buyFun():void {
			Cmd_Invest.cm_TZ_Z();
		}

		public function updateInfo(data:InvestData):void {
			if (1 == data.fundStatus) {
				flagImg.updateBmp("ui/tzlc/btn_hqhb.png");
				var reArr:Array=data.receiveList;
				var length:int=reArr.length;
				for (var n:int=0; n < length; n++) {
					receiveFlags[reArr[n]].updateStatus(true);
				}
				flagBtn.setActive((1 == data.rStatus), 1, true);
			}
			for (var key:String in receiveFlags) {
				var receiveFlag:InvestJJBtn=receiveFlags[key];
				receiveFlag.filters=(Core.me.info.level >= int(key)) ? null : [FilterEnum.enable];
			}
		}

		public function flyReward(ids:Array):void {
			var flyId:Array=new Array();
			var length:int=ids.length;
			flyId.length=length;
			for (var n:int=0; n < length; n++) {
				flyId[n]=65532;
			}
			var startPs:Array=new Array();
			startPs.length=length;
			for (var m:int=0; m < length; m++) {
				var re:InvestJJBtn=receiveFlags[ids[m]];
				startPs[m]=re.localToGlobal(new Point(0, 0));
			}
			FlyManager.getInstance().flyBags(flyId, startPs);
		}
	}
}

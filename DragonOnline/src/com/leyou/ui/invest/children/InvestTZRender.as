package com.leyou.ui.invest.children {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.invest.InvestData;
	import com.leyou.data.invest.InvestRewardInfo;
	import com.leyou.data.sinfo.ServerData;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Invest;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class InvestTZRender extends AutoSprite implements IMenu {
		private var cVImg:Image;

		private var yVImg:Image;

		private var lVImg:Image;

		private var cDRLbl:Label;

		private var yDRLbl:Label;

		private var lDRLbl:Label;

		private var cADLbl:Label;

		private var yADLbl:Label;

		private var lADLbl:Label;

		private var cinvestLbl:Label;

		private var yinvestLbl:Label;

		private var linvestLbl:Label;

		private var csumLbl:Label;

		private var ysumLbl:Label;

		private var lsumLbl:Label;

		private var cflagImg:Image;

		private var yflagImg:Image;

		private var lflagImg:Image;

		private var cflagBtn:ImgButton;

		private var yflagBtn:ImgButton;

		private var lflagBtn:ImgButton;

		private var des1Lbl:Label;

//		private var des2Lbl:Label;

		private var cgrid:MarketGrid;

		private var ygrid:MarketGrid;

		private var lgrid:MarketGrid;

		private var cnum:RollNumWidget;

		private var ynum:RollNumWidget;

		private var lnum:RollNumWidget;

		private var logPanel:ScrollPane;

		private var logTexts:Vector.<TextField>;

		private var menuArr:Vector.<MenuInfo>;

		private var playerName:String;
		
//		private var cftLbl:Label;
//		
//		private var yebLbl:Label;
//		
//		private var lqbLbl:Label;

		public function InvestTZRender() {
			super(LibManager.getInstance().getXML("config/ui/invest/lcjhRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			cVImg=getUIbyID("cVImg") as Image;
			yVImg=getUIbyID("yVImg") as Image;
			lVImg=getUIbyID("lVImg") as Image;
			cDRLbl=getUIbyID("cDRLbl") as Label;
			yDRLbl=getUIbyID("yDRLbl") as Label;
			lDRLbl=getUIbyID("lDRLbl") as Label;
			cADLbl=getUIbyID("cADLbl") as Label;
			yADLbl=getUIbyID("yADLbl") as Label;
			lADLbl=getUIbyID("lADLbl") as Label;
			cinvestLbl=getUIbyID("cinvestLbl") as Label;
			yinvestLbl=getUIbyID("yinvestLbl") as Label;
			linvestLbl=getUIbyID("linvestLbl") as Label;
			csumLbl=getUIbyID("csumLbl") as Label;
			ysumLbl=getUIbyID("ysumLbl") as Label;
			lsumLbl=getUIbyID("lsumLbl") as Label;
			cflagImg=getUIbyID("cflagImg") as Image;
			yflagImg=getUIbyID("yflagImg") as Image;
			lflagImg=getUIbyID("lflagImg") as Image;
			cflagBtn=getUIbyID("cflagBtn") as ImgButton;
			yflagBtn=getUIbyID("yflagBtn") as ImgButton;
			lflagBtn=getUIbyID("lflagBtn") as ImgButton;
			des1Lbl=getUIbyID("des1Lbl") as Label;
//			cftLbl = getUIbyID("cftLbl") as Label;
//			yebLbl = getUIbyID("yebLbl") as Label;
//			lqbLbl = getUIbyID("lqbLbl") as Label;
//			des2Lbl = getUIbyID("des2Lbl") as Label;

			cflagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			yflagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lflagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			des1Lbl.htmlText=TableManager.getInstance().getSystemNotice(5320).content;
//			des2Lbl.htmlText = TableManager.getInstance().getSystemNotice(5322).content;

			var url:String="ui/name/vip{1}.jpg";
			cVImg.updateBmp(StringUtil.substitute(url, ConfigEnum.invest2));
			yVImg.updateBmp(StringUtil.substitute(url, ConfigEnum.invest5));
			lVImg.updateBmp(StringUtil.substitute(url, ConfigEnum.invest8));

			var tztext:String=PropUtils.getStringById(1767);
			cinvestLbl.text=StringUtil.substitute(tztext, ConfigEnum.invest3);
			yinvestLbl.text=StringUtil.substitute(tztext, ConfigEnum.invest6);
			linvestLbl.text=StringUtil.substitute(tztext, ConfigEnum.invest9);

			var retext:String=PropUtils.getStringById(1768)
			csumLbl.text=StringUtil.substitute(retext, ConfigEnum.invest4 * ConfigEnum.invest1);
			ysumLbl.text=StringUtil.substitute(retext, ConfigEnum.invest7 * ConfigEnum.invest1);
			lsumLbl.text=StringUtil.substitute(retext, ConfigEnum.invest10 * ConfigEnum.invest1);

			cgrid=new MarketGrid();
			addChild(cgrid);
			cgrid.x=80;
			cgrid.y=60;

			ygrid=new MarketGrid();
			addChild(ygrid);
			ygrid.x=306;
			ygrid.y=60;

			lgrid=new MarketGrid();
			addChild(lgrid);
			lgrid.x=534;
			lgrid.y=60;
			resetText()

			cnum=new RollNumWidget();
			ynum=new RollNumWidget();
			lnum=new RollNumWidget();
			cnum.x=125;
			cnum.y=221;
			ynum.x=356;
			ynum.y=221;
			lnum.x=586;
			lnum.y=221;
			addChild(cnum);
			addChild(ynum);
			addChild(lnum);
			cnum.alignRound();
			ynum.alignRound();
			lnum.alignRound();
			cnum.loadSource("ui/num/{num}_lz.png");
			ynum.loadSource("ui/num/{num}_lz.png");
			lnum.loadSource("ui/num/{num}_lz.png");
//			cnum.setNum((ConfigEnum.invest4*ConfigEnum.invest1/ConfigEnum.invest3/5-1)*100);
//			ynum.setNum((ConfigEnum.invest7*ConfigEnum.invest1/ConfigEnum.invest6/5-1)*100);
//			lnum.setNum((ConfigEnum.invest10*ConfigEnum.invest1/ConfigEnum.invest9/5-1)*100);
			cnum.setNum(ConfigEnum.invest16);
			ynum.setNum(ConfigEnum.invest17);
			lnum.setNum(ConfigEnum.invest18);

			logPanel=new ScrollPane(332, 82);
			logPanel.x=354;
			logPanel.y=354;
			addChild(logPanel);
			logTexts=new Vector.<TextField>(4);
			
//			var timeSpan:Array = ConfigEnum.invest19.split("|");
//			var beginDate:Date = DateUtil.dateStr2Date(timeSpan[0]);
//			var endDate:Date = DateUtil.dateStr2Date(timeSpan[1]);
//			var cDate:Date = new Date(DataManager.getInstance().serverData.ctime*1000);
//			var isOn:Boolean = ((cDate.time >= beginDate.time) && (cDate.time <= endDate.time));
//			if(isOn){
//				cftLbl.visible = true;
//				yebLbl.visible = true;
//				lqbLbl.visible = true;
//				var item1:Array = ConfigEnum.invest20.split(",");
//				var item2:Array = ConfigEnum.invest21.split(",");
//				var item3:Array = ConfigEnum.invest22.split(",");
//				var content:String = TableManager.getInstance().getSystemNotice(10099).content;
//				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(item1[0]);
//				cftLbl.text = StringUtil.substitute(content, itemInfo.name, item1[1]);
//				itemInfo = TableManager.getInstance().getItemInfo(item2[0]);
//				yebLbl.text = StringUtil.substitute(content, itemInfo.name, item2[1]);
//				itemInfo = TableManager.getInstance().getItemInfo(item3[0]);
//				lqbLbl.text = StringUtil.substitute(content, itemInfo.name, item3[1]);
//			}else{
//				cftLbl.visible = false;
//				yebLbl.visible = false;
//				lqbLbl.visible = false;
//			}
			x = 11;
			y = 4;
		}

		protected function resetText():void {
			var adtext:String=PropUtils.getStringById(1769);
			adtext=StringUtil.substitute(adtext, ConfigEnum.invest1);
			cADLbl.text=adtext;
			yADLbl.text=adtext;
			lADLbl.text=adtext;

			cgrid.updataInfo({itemId: 65532, count: ConfigEnum.invest4});
			ygrid.updataInfo({itemId: 65532, count: ConfigEnum.invest7});
			lgrid.updataInfo({itemId: 65532, count: ConfigEnum.invest10});

			cDRLbl.text=PropUtils.getStringById(1770);
			yDRLbl.text=PropUtils.getStringById(1770);
			lDRLbl.text=PropUtils.getStringById(1770);
		}

		protected function onBtnClick(event:MouseEvent):void {
			var type:int=DataManager.getInstance().investData.type;
			if (0 != type) {
				Cmd_Invest.cm_TZ_J();
				return;
			}
			var content:String=TableManager.getInstance().getSystemNotice(5321).content;
			switch (event.target.name) {
				case "cflagBtn":
					content=StringUtil.substitute(content, PropUtils.getStringById(1771), ConfigEnum.invest3, ConfigEnum.invest4, ConfigEnum.invest1);
					PopupManager.showConfirm(content, buyCFT, null, false, "tzlc.buy");
					break;
				case "yflagBtn":
					content=StringUtil.substitute(content, PropUtils.getStringById(1772), ConfigEnum.invest6, ConfigEnum.invest7, ConfigEnum.invest1);
					PopupManager.showConfirm(content, buyYEB, null, false, "tzlc.buy");
					break;
				case "lflagBtn":
					content=StringUtil.substitute(content, PropUtils.getStringById(1773), ConfigEnum.invest9, ConfigEnum.invest10, ConfigEnum.invest1);
					PopupManager.showConfirm(content, buyLQB, null, false, "tzlc.buy");
					break;
			}
		}

		private function buyLQB():void {
			Cmd_Invest.cm_TZ_T(3);
		}

		private function buyYEB():void {
			Cmd_Invest.cm_TZ_T(2);
		}

		private function buyCFT():void {
			Cmd_Invest.cm_TZ_T(1);
		}

		public function updateInfo(data:InvestData):void {
			resetText();
			var adtext:String=PropUtils.getStringById(1769);
			adtext=StringUtil.substitute(adtext, data.remainDay);
			switch (data.type) {
				case 1:
					cflagBtn.setActive((0 == data.status), 1, true);
					yflagBtn.setActive(false, 1, true);
					lflagBtn.setActive(false, 1, true);
					cflagImg.filters=(0 == data.status) ? null : [FilterEnum.enable];
					yflagImg.filters=[FilterEnum.enable];
					lflagImg.filters=[FilterEnum.enable];
					cgrid.updataInfo({itemId: 65532, count: data.byb});
					cADLbl.text=adtext;
					cflagImg.updateBmp("ui/tzlc/btn_hqhb.png");
					cDRLbl.text=PropUtils.getStringById(1774);
					break;
				case 2:
					cflagBtn.setActive(false, 1, true);
					yflagBtn.setActive((0 == data.status), 1, true);
					lflagBtn.setActive(false, 1, true);
					cflagImg.filters=[FilterEnum.enable];
					yflagImg.filters=(0 == data.status) ? null : [FilterEnum.enable];
					lflagImg.filters=[FilterEnum.enable];
					ygrid.updataInfo({itemId: 65532, count: data.byb});
					yADLbl.text=adtext;
					yflagImg.updateBmp("ui/tzlc/btn_hqhb.png");
					yDRLbl.text=PropUtils.getStringById(1774);
					break;
				case 3:
					cflagBtn.setActive(false, 1, true);
					yflagBtn.setActive(false, 1, true);
					lflagBtn.setActive((0 == data.status), 1, true);
					cflagImg.filters=[FilterEnum.enable];
					yflagImg.filters=[FilterEnum.enable];
					lflagImg.filters=(0 == data.status) ? null : [FilterEnum.enable];
					lgrid.updataInfo({itemId: 65532, count: data.byb});
					lADLbl.text=adtext;
					lflagImg.updateBmp("ui/tzlc/btn_hqhb.png");
					lDRLbl.text=PropUtils.getStringById(1774);
					break;
				case 0:
					cflagBtn.setActive(true, 1, true);
					yflagBtn.setActive(true, 1, true);
					lflagBtn.setActive(true, 1, true);
					cflagImg.filters=null;
					yflagImg.filters=null;
					lflagImg.filters=null;
					cflagImg.updateBmp("ui/tzlc/btn_wytz.png");
					yflagImg.updateBmp("ui/tzlc/btn_wytz.png");
					lflagImg.updateBmp("ui/tzlc/btn_wytz.png");
					break;
			}
		}

		public function updateLog(data:InvestData):void {
			var length:int=data.getRewardCount();
			for (var n:int=0; n < length; n++) {
				var tf:TextField=logTexts[n];
				if (null == tf) {
					tf=new TextField();
					tf.textColor=0xffffff;
					tf.filters=[FilterEnum.hei_miaobian];
					tf.autoSize=TextFieldAutoSize.LEFT;
					var tfFormat:TextFormat=tf.defaultTextFormat;
					tfFormat.size=12;
					tf.defaultTextFormat=tfFormat;
					logTexts[n]=tf;
					tf.y=n * 20;
					logPanel.addToPane(tf);
					tf.addEventListener(TextEvent.LINK, onTextClick);
					logPanel.updateUI();
				}
				var rewardInfo:InvestRewardInfo=data.getReward(n);
				var content:String="<font face='SimSun' color='#ffea00' size='12'><u><a href='event:{1}'>{2}</a></u></font><font face='SimSun' color='#CDB97C' size='12'>" + PropUtils.getStringById(1775) + "</Font>";
				content=StringUtil.substitute(content, rewardInfo.playerName, rewardInfo.playerName, getTZName(rewardInfo.ltype), rewardInfo.byb);
				tf.htmlText=content;
			}
		}

		protected function onTextClick(event:TextEvent):void {
			playerName=event.text;
			if (null == menuArr) {
				menuArr=new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			}
			MenuManager.getInstance().show(menuArr, this);
		}

		private function getTZName(ltype:int):String {
			switch (ltype) {
				case 1:
					return PropUtils.getStringById(1771);
				case 2:
					return PropUtils.getStringById(1772);
				case 3:
					return PropUtils.getStringById(1773);
				case 4:
					return PropUtils.getStringById(1776);
			}
			return null;
		}

		public function flyReward():void {
			var grid:MarketGrid;
			var type:int=DataManager.getInstance().investData.type;
			switch (type) {
				case 1:
					grid=cgrid;
					break;
				case 2:
					grid=ygrid;
					break;
				case 3:
					grid=lgrid;
					break;
			}
			FlyManager.getInstance().flyBags([grid.dataId], [grid.localToGlobal(new Point(0, 0))]);
		}

		public function onMenuClick(index:int):void {
			switch (index) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, playerName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(playerName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(playerName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(playerName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(playerName);
					break;
			}
		}
	}
}

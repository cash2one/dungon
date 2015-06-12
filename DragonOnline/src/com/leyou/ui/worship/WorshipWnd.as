package com.leyou.ui.worship {
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Worship;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WorshipWnd extends AutoWindow {
		private var nameLbl:Label;

		private var applaudLbl:Label;

		private var awardEnergyLbl:Label;

		private var awardMoneyLbl:Label;

		private var awardMoney1Lbl:Label;

		private var awardEnergy1Lbl:Label;

		private var moneyCostLbl:Label;

		private var bybCostLbl:Label;

		private var remainbybLbl:Label;

		private var remainybLbl:Label;

		private var ybCostLbl:Label;

		private var moenyABtn:NormalButton;

		private var bybABtn:NormalButton;

		private var ybABtn:NormalButton;

		private var big:BigAvatar;

		private var fInfo:FeatureInfo;

		private var remainMoneyLbl:Label;

		private var worshipLbl:Label;

		private var moneyImg:Image;

		private var bybImg:Image;

		private var ybImg:Image;

		private var evtInfo:MouseEventInfo;

		private var modelImg:Image;

		public function WorshipWnd() {
			super(LibManager.getInstance().getXML("config/ui/worship/worshipWnd.xml"));
			init();
		}

		private function init():void {
			big=new BigAvatar();
			pane.addChild(big);
			nameLbl=getUIbyID("nameLbl") as Label;
			applaudLbl=getUIbyID("applaudLbl") as Label;
			awardEnergyLbl=getUIbyID("awardEnergyLbl") as Label;
			awardMoneyLbl=getUIbyID("awardMoneyLbl") as Label;
			awardMoney1Lbl=getUIbyID("awardMoney1Lbl") as Label;
			awardEnergy1Lbl=getUIbyID("awardEnergy1Lbl") as Label;
			moneyCostLbl=getUIbyID("moneyCostLbl") as Label;
			bybCostLbl=getUIbyID("bybCostLbl") as Label;
			remainbybLbl=getUIbyID("remainbybLbl") as Label;
			remainMoneyLbl=getUIbyID("remainMoneyLbl") as Label;
			remainybLbl=getUIbyID("remainybLbl") as Label;
			ybCostLbl=getUIbyID("ybCostLbl") as Label;
			moenyABtn=getUIbyID("moenyABtn") as NormalButton;
			bybABtn=getUIbyID("bybABtn") as NormalButton;
			ybABtn=getUIbyID("ybABtn") as NormalButton;
			worshipLbl=getUIbyID("worshipLbl") as Label;
			ybImg=getUIbyID("ybImg") as Image;
			bybImg=getUIbyID("bybImg") as Image;
			moneyImg=getUIbyID("moneyImg") as Image;
			modelImg=getUIbyID("modelImg") as Image;
			moenyABtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			bybABtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybABtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			evtInfo=new MouseEventInfo();
			evtInfo.onMouseMove=onMouseMove;
			MouseManagerII.getInstance().addEvents(ybImg, evtInfo);
			MouseManagerII.getInstance().addEvents(bybImg, evtInfo);
			MouseManagerII.getInstance().addEvents(moneyImg, evtInfo);

			awardEnergyLbl.text=ConfigEnum.worship3 + "";
			moneyCostLbl.text=ConfigEnum.worship2 + "";
			awardMoneyLbl.text=ConfigEnum.worship6 + "";
			bybCostLbl.text=ConfigEnum.worship5 + "";
			awardMoney1Lbl.text=ConfigEnum.worship8 + "";
			awardEnergy1Lbl.text=ConfigEnum.worship9 + "";
			ybCostLbl.text=ConfigEnum.worship7 + "";

			big.x=195;
			big.y=370;

			pane.swapChildren(nameLbl, big);
		}

		private function onMouseMove(target:Image):void {
			var content:String="";
			switch (target.name) {
				case "ybImg":
					content=TableManager.getInstance().getSystemNotice(9559).content;
					break;
				case "bybImg":
					content=TableManager.getInstance().getSystemNotice(9558).content;
					break;
				case "moneyImg":
					content=TableManager.getInstance().getSystemNotice(9555).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "moenyABtn":
					Cmd_Worship.cm_WSP_M(1);
					break;
				case "bybABtn":
					Cmd_Worship.cm_WSP_M(2);
					break;
				case "ybABtn":
					Cmd_Worship.cm_WSP_M(3);
					break;
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			Cmd_Worship.cm_WSP_I();
		}

		//		wsp
		//		上行:wsp|I
		//		下行:wsp|{"mk":"I", "master":["avt":str, "name":str,"level":num,"vocation":num,"gender":num], "wnum":num, "moneyw":[cc,mc],"bybw":[cc,mc],"ybw":[cc,mc]}
		//		master  -- 城主信息
		//			avt      -- avt字符串(p协议中的avt字符串)	
		//			name     -- 玩家名字		
		//			level    -- 等级	
		//			vocation -- 职业	
		//			gender  --玩家性别 （0男 1女）
		//		wnum   -- 膜拜次数
		//		moneyw  -- 金币膜拜      (cc 当前次数 mc 总次数)
		//		bybw    -- 绑定元宝膜拜
		//		ybw     -- 元宝膜拜
		public function updateInfo(obj:Object):void {
			var masterInfo:Array=obj.cz;
			if ((null != masterInfo) && (masterInfo.length > 0)) {
				worshipLbl.visible=true;
				applaudLbl.visible=true;
				applaudLbl.text=obj.wnum;
				nameLbl.text=masterInfo[1];
				var avaStr:String=masterInfo[4];
				var sex:int=masterInfo[3];
				var pro:int=masterInfo[2];
				if (null == fInfo) {
					fInfo=new FeatureInfo();
				}
				fInfo.clear();
				var avaArr:Array=avaStr.split(",");
				fInfo.weapon=PnfUtil.realAvtId(avaArr[1], false, sex);
				fInfo.suit=PnfUtil.realAvtId(avaArr[2], false, sex);
				fInfo.wing=PnfUtil.realWingId(avaArr[3], false, sex, pro);
				big.show(fInfo, false, pro);
				big.playAct(PlayerEnum.ACT_STAND, 4);
				big.visible=true;
				modelImg.visible=false;
			} else {
				big.visible=false;

				modelImg.visible=true;

				nameLbl.text=PropUtils.getStringById(1642);
				worshipLbl.visible=false;
				applaudLbl.visible=false;
			}

			var moneyw:Array=obj.moneyw;
			var bybw:Array=obj.bybw;
			var ybw:Array=obj.ybw;
			if (moneyw[0] <= 0) {
				remainMoneyLbl.textColor=0xee0d0d;
				remainMoneyLbl.text=PropUtils.getStringById(1995);
				moenyABtn.setActive(false, 1, true);
			} else {
				remainMoneyLbl.textColor=0xcdb97c;
				remainMoneyLbl.text=PropUtils.getStringById(1996) + "：" + moneyw[0] + "/" + moneyw[1];
				moenyABtn.setActive(true, 1, true);
			}
			if (bybw[0] <= 0) {
				remainbybLbl.textColor=0xee0d0d;
				remainbybLbl.text=PropUtils.getStringById(1995);
				bybABtn.setActive(false, 1, true);
			} else {
				remainbybLbl.textColor=0xcdb97c;
				remainbybLbl.text=PropUtils.getStringById(1996) + "：" + bybw[0] + "/" + bybw[1];
				bybABtn.setActive(true, 1, true);
			}
			if (ybw[0] <= 0) {
				remainybLbl.textColor=0xee0d0d;
				remainybLbl.text=PropUtils.getStringById(1995);
				ybABtn.setActive(false, 1, true);
			} else {
				remainybLbl.textColor=0xcdb97c;
				remainybLbl.text=PropUtils.getStringById(1996) + "：" + ybw[0] + "/" + ybw[1];
				ybABtn.setActive(true, 1, true);
			}
		}
	}
}

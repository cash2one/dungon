package com.leyou.ui.payrank {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TRankRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.data.payrank.PayRankData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_PayRank;
	import com.leyou.ui.payrank.children.PayRankRender;
	import com.leyou.ui.payrank.children.PayRankReward;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class PayRankWnd extends AutoWindow {
		private var regularImg:Image;

		private var remainTLbl:Label;

		private var payRankBtn:TabButton;

		private var levelRankBtn:TabButton;

		private var zlRankBtn:TabButton;

		private var payBtn:ImgButton;

		private var rewards:Vector.<PayRankReward>;

		private var fInfo:FeatureInfo;

		private var big:BigAvatar;

		private var ctype:int=1;

		private var rankLbl:Label;

		private var payRank:PayRankRender;

		private var num:RollNumWidget;

		private var flagImg:Image;

		private var remianT:int;

		private var tick:int;

		private var rbLbl:Label;

		private var modelBgImg:Image;

		public function PayRankWnd() {
			super(LibManager.getInstance().getXML("config/ui/payRank/yrcbWnd.xml"));
			init();
		}

		private function init():void {
			regularImg=getUIbyID("regularImg") as Image;
			remainTLbl=getUIbyID("remainTLbl") as Label;
			rankLbl=getUIbyID("rankLbl") as Label;
			flagImg=getUIbyID("flagImg") as Image;
			payRankBtn=getUIbyID("payRankBtn") as TabButton;
			levelRankBtn=getUIbyID("levelRankBtn") as TabButton;
			zlRankBtn=getUIbyID("zlRankBtn") as TabButton;
			payBtn=getUIbyID("payBtn") as ImgButton;
			rbLbl=getUIbyID("rbLbl") as Label;
			modelBgImg=getUIbyID("modelBgImg") as Image;
			rewards=new Vector.<PayRankReward>();

			payRankBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			levelRankBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			zlRankBtn.addEventListener(MouseEvent.CLICK, onBtnClick);


			var spt:Sprite=new Sprite();
			spt.addChild(regularImg);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			spt.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addChild(spt);

			num=new RollNumWidget();
			num.loadSource("ui/num/{num}_zdl.png");
			num.alignLeft();
			addChild(num);
			num.x=254;
			num.y=79;
			if (!Core.PAY_OPEN) {
				payBtn.setActive(false, 1, true);
			} else {
				payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			hideBg();
//			clsBtn.x-=117;
//			clsBtn.y+=40;
			for (var n:int=0; n < 5; n++) {
				var reward:PayRankReward=new PayRankReward();
				addChild(reward);
				reward.x=282;
				reward.y=118 + 67 * n;
				rewards.push(reward);
			}
			// 确定职业
			var ridx:int=0;
			switch (Core.me.info.profession) {
				case PlayerEnum.PRO_SOLDIER:
					ridx=0;
					break;
				case PlayerEnum.PRO_MASTER:
					ridx=1;
					break;
				case PlayerEnum.PRO_WARLOCK:
					ridx=2;
					break;
				case PlayerEnum.PRO_RANGER:
					ridx=3;
					break;
			}
			var content:String=ConfigEnum.dayAward3;
			var arr:Array=content.split("|");
			var proData:Array=arr[ridx].split(",");
			big=new BigAvatar();
			addChild(big);
			fInfo=new FeatureInfo();
			fInfo.weapon=PnfUtil.realAvtId(proData[0], false, Core.me.info.sex);
			fInfo.suit=PnfUtil.realAvtId(proData[1], false, Core.me.info.sex);
			big.show(fInfo, true, Core.me.info.profession);
			big.playAct(PlayerEnum.ACT_STAND, 4);
			big.x=-45;
			big.y=425;
			payRankBtn.turnOn();
			initRewardbyType(ctype);
			payRank=new PayRankRender();
			addChild(payRank);
			payRank.x=692;
			payRank.y=132;

			// 是否开服
			var open:Boolean=(1 == DataManager.getInstance().serverData.status);
			levelRankBtn.visible=open;
			modelBgImg.visible=open;
			big.visible=open;
		}

//		protected function onMouseOut(event:MouseEvent):void{
//		}

		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(4302).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "payRankBtn":
					if (1 == ctype) {
						return;
					}
					payRank.reset();
					ctype=1;
					Cmd_PayRank.cm_PayRank_I(ctype, 1, PayRankData.RANK_MAX_NUM);
					break;
				case "levelRankBtn":
					if (2 == ctype) {
						return;
					}
					payRank.reset();
					ctype=2;
					Cmd_PayRank.cm_PayRank_I(ctype, 1, PayRankData.RANK_MAX_NUM);
					break;
				case "zlRankBtn":
					if (3 == ctype) {
						return;
					}
					payRank.reset();
					ctype=3;
					Cmd_PayRank.cm_PayRank_I(ctype, 1, PayRankData.RANK_MAX_NUM);
					break;
				case "payBtn":
					PayUtil.openPayUrl();
					return;
			}
			initRewardbyType(ctype);
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		private function getRankReward(type:int, rank:int):TRankRewardInfo {
			var rewardDic:Object=TableManager.getInstance().rankRewardDic;
			for (var key:String in rewardDic) {
				var reward:TRankRewardInfo=rewardDic[key];
				if ((reward.type == type) && (reward.rank == rank)) {
					return reward;
				}
			}
			return null;
		}

		protected function initRewardbyType(type:int):void {
			var length:int=rewards.length;
			for (var n:int=0; n < length; n++) {
				var reward:PayRankReward=rewards[n];
				var rank:int;
				if (n < 3) {
					rank=n + 1;
				} else if (3 == n) {
					rank=4;
				} else if (4 == n) {
					rank=11;
				}
				var rInfo:TRankRewardInfo=getRankReward(type, rank);
				reward.updateTInfo(rInfo);
			}
		}
		

		public function updateInfo():void {
			tick=getTimer();
			var data:PayRankData=DataManager.getInstance().payRankData;
			remianT=data.remainT;
			payRank.updateInfo(data.getRankData(ctype), data.pageCount, ctype);
			if (data.myRankV > 0) {
				rankLbl.text=StringUtil.substitute(PropUtils.getStringById(1641), data.myRankV);
			} else {
				rankLbl.text=PropUtils.getStringById(1821);
			}
			num.setNum(data.myVar);
			var id:int;
			var value:int;
			var url:String;
			switch (ctype) {
				case 1:
					id=4303;
					value=ConfigEnum.dayAward1;
					url="ui/yrcb/icon_czsl.png";
					break;
				case 2:
					id=4305;
					value=ConfigEnum.dayAward4;
					url="ui/yrcb/icon_dqdjl.png";
					break;
				case 3:
					id=4304;
					if(DataManager.getInstance().serverData.isOpening()){
						value=ConfigEnum.dayAward5;
					}else{
						value=ConfigEnum.dayAward7;
					}
					url="ui/yrcb/icon_dqzdl.png";
					break;
			}
			flagImg.updateBmp(url);
			var content:String=TableManager.getInstance().getSystemNotice(id).content;
			rbLbl.text=StringUtil.substitute(content, value);
			if (data.remainT > 0) {
				if (!TimeManager.getInstance().hasITick(updateTime)) {
					TimeManager.getInstance().addITick(1000, updateTime);
				}
			} else {
				remainTLbl.text=PropUtils.getStringById(1822);
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			payRank.reset();
			payRankBtn.turnOn(false);
//			Cmd_PayRank.cm_PayRank_I(ctype, 1, PayRankData.RANK_MAX_NUM);
			updateTime();
		}

		public override function hide():void {
			super.hide();
			ctype = 1;
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}

		private function updateTime():void {
			var rt:int=remianT - (getTimer() - tick) / 1000;
			if (rt < 0) {
				rt=0;
			}
			var hh:String=StringUtil.fillTheStr(int(rt / 60 / 60), 2, "0", true);
			var mi:String=StringUtil.fillTheStr(int(rt / 60 % 60), 2, "0", true);
			var ms:String=StringUtil.fillTheStr(int(rt % 60), 2, "0", true);
			var str:String="{1}:{2}:{3}";
			remainTLbl.text=StringUtil.substitute(str, hh, mi, ms);
		}

		public override function get width():Number {
			return 762;
		}

		public override function get height():Number {
			return 599;
		}

	}
}

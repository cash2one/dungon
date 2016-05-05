package com.leyou.ui.battlefield {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class IceBattlefieldRender extends AutoSprite {
		private var creditLbl:Label;

		private var killLbl:Label;

		private var assistLbl:Label;

		private var enterBtn:ImgButton;

		private var openTimeLbl:Label;

//		private var mysteryBtn:ImgButton;

		private var historyBtn:NormalButton;
		private var honuerBtn:NormalButton;

		private var ruleBtn:NormalButton;

		private var rewardBtn:NormalButton;

		private var iconImg0:Image;

		private var iconImg1:Image;

		private var iconImg2:Image;

		public function IceBattlefieldRender() {
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			iconImg0=getUIbyID("iconImg0") as Image;
			iconImg1=getUIbyID("iconImg1") as Image;
			iconImg2=getUIbyID("iconImg2") as Image;
			creditLbl=getUIbyID("creditLbl") as Label;
			killLbl=getUIbyID("killLbl") as Label;
			assistLbl=getUIbyID("assistLbl") as Label;
			enterBtn=getUIbyID("enterBtn") as ImgButton;
			openTimeLbl=getUIbyID("openTimeLbl") as Label;
//			mysteryBtn = getUIbyID("mysteryBtn") as ImgButton;
			historyBtn=getUIbyID("lastBtn") as NormalButton;
			honuerBtn=getUIbyID("honuerBtn") as NormalButton;
			ruleBtn=getUIbyID("ruleBtn") as NormalButton;
			rewardBtn=getUIbyID("rewardBtn") as NormalButton;

			enterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			mysteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			historyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ruleBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			honuerBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			openTimeLbl.text=TableManager.getInstance().getSystemNotice(21003).content;

			var spt:Sprite=new Sprite();
			spt.name=iconImg0.name;
			spt.addChild(iconImg0);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			spt=new Sprite();
			spt.name=iconImg1.name;
			spt.addChild(iconImg1);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			spt=new Sprite();
			spt.name=iconImg2.name;
			spt.addChild(iconImg2);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		private var info:TipsInfo=new TipsInfo();

		protected function onMouseOver(event:MouseEvent):void {
			var itemId:int;
			switch (event.target.name) {
				case "iconImg0":
					itemId=ConfigEnum.Opbattle34.split(",")[0];
					break;
				case "iconImg1":
					itemId=ConfigEnum.Opbattle35.split(",")[0];
					break;
				case "iconImg2":
					itemId=ConfigEnum.Opbattle36.split(",")[0];
					break;
			}
			info.itemid=itemId;
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, info, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "honuerBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
				case "enterBtn":
					Cmd_ZC.cm_ZC_E();
					break;
				case "mysteryBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
				case "lastBtn":
					UIManager.getInstance().showWindow(WindowEnum.WAR_LOG);
					Cmd_ZC.cm_ZC_H(3);
					break;
				case "ruleBtn":
					UIManager.getInstance().showWindow(WindowEnum.ICE_BATTLE_RULE);
					break;
				case "rewardBtn":
					UIManager.getInstance().showWindow(WindowEnum.ICE_BATTLE_REWARD);
					break;
			}
		}

		public function updateInfo():void {
			var data:IceBattleData=DataManager.getInstance().iceBattleData;
			creditLbl.text=(null == data.jf) ? PropUtils.getStringById(1642) : data.jf;
			killLbl.text=(null == data.kill) ? PropUtils.getStringById(1642) : data.kill;
			assistLbl.text=(null == data.ass) ? PropUtils.getStringById(1642) : data.ass;
		}
	}
}

package com.leyou.ui.battlefield
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class IceBattlefieldRender extends AutoSprite
	{
		private var creditLbl:Label;
		
		private var killLbl:Label;
		
		private var assistLbl:Label;
		
		private var enterBtn:ImgButton;
		
		private var openTimeLbl:Label;
		
		private var mysteryBtn:ImgButton;
		
		private var historyBtn:NormalButton;
		
		private var ruleBtn:NormalButton;
		
		private var rewardBtn:NormalButton;
		
		public function IceBattlefieldRender(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			creditLbl = getUIbyID("creditLbl") as Label;
			killLbl = getUIbyID("killLbl") as Label;
			assistLbl = getUIbyID("assistLbl") as Label;
			enterBtn = getUIbyID("enterBtn") as ImgButton;
			openTimeLbl = getUIbyID("openTimeLbl") as Label;
			mysteryBtn = getUIbyID("mysteryBtn") as ImgButton;
			historyBtn = getUIbyID("lastBtn") as NormalButton;
			ruleBtn = getUIbyID("ruleBtn") as NormalButton;
			rewardBtn = getUIbyID("rewardBtn") as NormalButton;
			
			enterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			mysteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			historyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ruleBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			openTimeLbl.text = TableManager.getInstance().getSystemNotice(21003).content;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
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
		
		public function updateInfo():void{
			var data:IceBattleData = DataManager.getInstance().iceBattleData;
			creditLbl.text = (null == data.jf) ? PropUtils.getStringById(1642) : data.jf;
			killLbl.text = (null == data.kill) ? PropUtils.getStringById(1642) : data.kill;
			assistLbl.text = (null == data.ass) ? PropUtils.getStringById(1642) : data.ass;
		}
	}
}
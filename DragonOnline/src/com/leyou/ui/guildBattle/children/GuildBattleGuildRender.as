package com.leyou.ui.guildBattle.children {
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.guildBattle.GuildBattleData;
	import com.leyou.data.guildBattle.GuildBattleFirstGuildData;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class GuildBattleGuildRender extends AutoSprite {
		
		private var guildName:Label;

//		private var playerName:Label;

		private var openTimeLbl:Label;

		private var enterBtn:ImgButton;

		private var ordinationBtn:NormalButton;

		private var rankBtn:NormalButton;

		private var historyBtn:NormalButton;
		private var honuerBtn:NormalButton;

//		private var big:BigAvatar;

		private var fInfo:FeatureInfo;

//		private var mysteryBtn:ImgButton;

		public function GuildBattleGuildRender() {
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			mouseEnabled=false;
			guildName=getUIbyID("guildName") as Label;
//			playerName=getUIbyID("playerName") as Label;
			enterBtn=getUIbyID("enterBtn") as ImgButton;
			ordinationBtn=getUIbyID("ordinationBtn") as NormalButton;
			rankBtn=getUIbyID("rankBtn") as NormalButton;
			openTimeLbl=getUIbyID("openTimeLbl") as Label;
			historyBtn=getUIbyID("historyBtn") as NormalButton;
			honuerBtn=getUIbyID("honuerBtn") as NormalButton;
//			mysteryBtn=getUIbyID("mysteryBtn") as ImgButton;
//			big=new BigAvatar();
//			big.x=417;
//			big.y=352;
			fInfo=new FeatureInfo();
			openTimeLbl.text=TableManager.getInstance().getSystemNotice(3091).content;
			enterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ordinationBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rankBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			historyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			honuerBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			mysteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			var index:int=getChildIndex(enterBtn);
//			addChildAt(big, index);
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "enterBtn":
					Cmd_GuildBattle.cm_UNZ_E();
					break;
				case "honuerBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
				case "ordinationBtn":
					UIManager.getInstance().openWindow(WindowEnum.GUILD_BATTLE_EXPLAIN);
					break;
				case "rankBtn":
					UIManager.getInstance().openWindow(WindowEnum.GUILD_BATTLE_RANK);
					break;
				case "historyBtn":
					UIManager.getInstance().showWindow(WindowEnum.WAR_LOG);
					Cmd_ZC.cm_ZC_H(1);
					break;
				case "mysteryBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
			}
		}

		public function updateInfo():void {
			var data:GuildBattleData=DataManager.getInstance().guildBattleData;
//			big.visible=data.hasFirst;
			if (data.hasFirst) {
				var guild:GuildBattleFirstGuildData=data.fistGuild;
				guildName.text=guild.guildName;
				var avaArr:Array=guild.avt.split(",");
				fInfo.weapon=PnfUtil.realAvtId(avaArr[1], false, guild.gender);
				fInfo.suit=PnfUtil.realAvtId(avaArr[2], false, guild.gender);
				fInfo.wing=PnfUtil.realWingId(avaArr[3], false, guild.gender, guild.school);
//				big.showII(fInfo, false, guild.school);
//				big.showEquipEffect(avaArr[6], avaArr[5]);
//				big.playAct(PlayerEnum.ACT_STAND, 4);
			} else {
				guildName.text=PropUtils.getStringById(1642);
//				playerName.text=PropUtils.getStringById(1642);
			}
		}
	}
}

package com.leyou.ui.intro.childs {

	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.table.TIntro;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.ui.pet.PetWnd;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;

	public class IntroRender extends AutoSprite {

		private var targetBtn:NormalButton;
		private var nameLbl:Label;

		private var itemStar:Array=[];

		private var info:TIntro;

		public function IntroRender() {
			super(LibManager.getInstance().getXML("config/ui/intro/child/introRender.xml"));
			init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.targetBtn=this.getUIbyID("targetBtn") as NormalButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			var im:Image;
			for (var i:int=0; i < 5; i++) {
				im=new Image("ui/tobestr/star_1.png");
				this.addChild(im);
				this.itemStar.push(im);

				im.x=124 + i * 30;
				im.y=25;

			}

			this.targetBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			var wfhenum:Array=[WindowEnum.ARENA_NOTICE, WindowEnum.CDKEY, WindowEnum.ACHIEVEMENT, WindowEnum.ACHIEVEMENTNOTIFY, WindowEnum.VIP, WindowEnum.LUCKDRAW, WindowEnum.LUCKDRAW_STORE, WindowEnum.WORSHIP, WindowEnum.FARMMESSAGE, WindowEnum.FIELD_BOSS_TRACK, WindowEnum.FIELD_BOSS_REMIND, WindowEnum.FIELD_BOSS_REWARD, WindowEnum.ONLINDREWARD, WindowEnum.FIRST_LOGIN, WindowEnum.SUPER_FIRST_RETURN, WindowEnum.FIRST_PAY, WindowEnum.FUN_OPEN, WindowEnum.PAY_PROMOTION, WindowEnum.TOBE_STRONG, WindowEnum.PLAYER_TRACK, WindowEnum.SEVENDAY, WindowEnum.INVEST, WindowEnum.AREA_CELEBRATE, WindowEnum.DIE, WindowEnum.PAY_RANK, WindowEnum.FIRST_RETURN, WindowEnum.GUILD_BATTLE, WindowEnum.GUILD_BATTLE_RANK, WindowEnum.GUILD_BATTLE_TRACK, WindowEnum.GUILD_MESSAGE, WindowEnum.QQ_VIP, WindowEnum.QQ_MARKET, WindowEnum.GUILD_BATTLE_EXPLAIN, WindowEnum.QQ_YELLOW, WindowEnum.COLLECTION, WindowEnum.INTEGRAL, WindowEnum.ABIDE_PAY, WindowEnum.ABIDE_BOX, WindowEnum.GROUP_BUY, WindowEnum.FIRSTGIFT, WindowEnum.VENDUE, WindowEnum.CITY_BATTLE_ANNOUNCE, WindowEnum.CITY_BATTLE_REWARD, WindowEnum.CITY_BATTLE_TAX, WindowEnum.CITY_BATTLE_FINAL, WindowEnum.CITY_BATTLE_TRACK, WindowEnum.CITY_BATTLE_EXPLAIN, WindowEnum.CITY_BATTLE_CHALLENGE, WindowEnum.BOSS, WindowEnum.DRAGON_BALL, WindowEnum.DRAGON_PROVIEW, WindowEnum.ICE_BATTLE_END, WindowEnum.ICE_BATTLE_PAUSE, WindowEnum.ICE_BATTLE_REWARD, WindowEnum.ICE_BATTLE_TRACK, WindowEnum.WAR_LOG, WindowEnum.ICE_BATTLE_RULE, WindowEnum.LEGENDAREY_WEAPON, WindowEnum.BLACK_STROE, WindowEnum.PET, WindowEnum.PET_SKILL_SELECT, WindowEnum.TASK_MARKET, WindowEnum.COMBINE_RECHARGE, WindowEnum.PRO_LUCKDRAW, WindowEnum.PET_SELECT, WindowEnum.COPY_RANK, WindowEnum.CROSS_SERVER, WindowEnum.CROSS_SERVER_DONATE, WindowEnum.CROSS_SERVER_RANK, WindowEnum.CROSS_SERVER_RANK_AWARD, WindowEnum.TAIWAN_LC, WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE, WindowEnum.ELEMENT_SWITCH, WindowEnum.WELFARE_FINDBACK, WindowEnum.AUTION, WindowEnum.BOSSCOPY_REWARD, WindowEnum.STORYCOPY_REWARD, WindowEnum.COPYTRACK, WindowEnum.EXPCOPY_MAP, WindowEnum.EXP_COPY_TRACK, WindowEnum.FARM, WindowEnum.FARM_LOG, WindowEnum.FARM_SHOP, WindowEnum.MARKET, WindowEnum.WELFARE, WindowEnum.MAILL, WindowEnum.MAILL_READ, WindowEnum.FRIEND, WindowEnum.FRIEDN_ADD, WindowEnum.RANK, WindowEnum.ACTIVE, WindowEnum.QUICK_BUY]
			var ndlenum:Array=[WindowEnum.SHOP, WindowEnum.MYSTORE, WindowEnum.STOREGE, WindowEnum.GUILD, WindowEnum.GUILD_COPY_TRACK, WindowEnum.GUILD_WAR_WIN, WindowEnum.EQUIP, WindowEnum.BADAGE, WindowEnum.QUESTION, WindowEnum.ARENA, WindowEnum.ARENAAWARD, WindowEnum.ARENAFINISH, WindowEnum.ARENALIST, WindowEnum.ARENAMESSAGE, WindowEnum.BADGEREBUD, WindowEnum.DELIVERYFINISH, WindowEnum.MESSAGE, WindowEnum.PKCOPY, WindowEnum.PKCOPYPANEL, WindowEnum.BACKPACK, WindowEnum.PKCOPYSGTRACK, WindowEnum.SKILL, WindowEnum.TEAM, WindowEnum.TASK, WindowEnum.RUNE, WindowEnum.MEDIC, WindowEnum.ROLE, WindowEnum.MOUTLVUP, WindowEnum.MOUTTRADEUP, WindowEnum.WINGLVUP, WindowEnum.WING_FLY, WindowEnum.DELIVERYPANEL, WindowEnum.PKCOPYDRAGONFINISH, WindowEnum.MONSTERINVADEWND, WindowEnum.MONSTERINFINISH, WindowEnum.TOPUP, WindowEnum.DUNGEONTB_TRACK, WindowEnum.DUNGEON_BLT_TRACK, WindowEnum.GEM_LV, WindowEnum.DUNGEON_TEAM, WindowEnum.DUNGEON_TEAM_CREATE, WindowEnum.DUNGEON_TEAM_REWARD, WindowEnum.DUNGEON_TEAM_TRACK, WindowEnum.KEEP_7, WindowEnum.TTT, WindowEnum.TTT_TRACK, WindowEnum.LABA, WindowEnum.LABA_DESC, WindowEnum.MARRY1, WindowEnum.MARRY2, WindowEnum.MARRY3, WindowEnum.MARRY4, WindowEnum.SHIYI, WindowEnum.KFCB, WindowEnum.KFHD, WindowEnum.VIP3EXP, WindowEnum.SELLEXPEFFECT, WindowEnum.REDPACKAGE, WindowEnum.REDPACKAGE_OPEN, WindowEnum.REDPACKAGE_OPENLIST, WindowEnum.INTROWND];

			if (this.info.uiId > 0) {

				var tid:int;
				if (this.info.tabId.indexOf("|") > -1)
					tid=this.info.tabId.split("|")[1];

				if (wfhenum.indexOf(this.info.uiId) > -1) {

					if (UIManager.getInstance().isCreateAndVisible(this.info.uiId))
						return;

					if (tid > 0) {
						if (this.info.uiId == WindowEnum.WELFARE) {
							UIOpenBufferManager.getInstance().open(this.info.uiId);
							
							TweenLite.delayedCall(0.6, function():void {
								switch (info.uiId) {
									case WindowEnum.WELFARE:
										UIManager.getInstance().welfareWnd.changeTable(tid);
										break;
								}
							});
						} else
							UIOpenBufferManager.getInstance().open(this.info.uiId, tid);

					} else {
						UIOpenBufferManager.getInstance().open(this.info.uiId);
					}
				}

				if (ndlenum.indexOf(this.info.uiId) > -1) {
					if ([139].indexOf(this.info.uiId) > -1)
						UILayoutManager.getInstance().show(this.info.uiId);
					else {
						UILayoutManager.getInstance().show_II(this.info.uiId);

						if (tid > 0) {

							TweenLite.delayedCall(0.6, function():void {
								switch (info.uiId) {
									case WindowEnum.ROLE:
										UIManager.getInstance().roleWnd.setTabIndex(tid);
										break;
									case WindowEnum.EQUIP:
										UIManager.getInstance().equipWnd.changeTable(tid);
										break;
									case WindowEnum.DUNGEON_TEAM:
										UIManager.getInstance().teamCopyWnd.setTabIndex(tid);
										break;
								}
							});
						}

					}
				}

			} else if (this.info.uiId == -1) {
				UIManager.getInstance().taskTrack.autoCompleteLoop();
			} else if (this.info.uiId == -2) {
				Cmd_Go.cmGo(ConfigEnum.delivery21);
			} else if (this.info.uiId == -3) {
				PayUtil.openPayUrl();

			}



		}

		public function updateInfo(tinfo:TIntro):void {

			this.info=tinfo;
			this.nameLbl.text=tinfo.des;
			this.setStar(tinfo.starNum);

		}

		private function setStar(c:int):void {

			var im:Image;
			for (var i:int=0; i < 5; i++) {
				im=this.itemStar[i] as Image;
				if (i < c)
					im.updateBmp("ui/tobestr/star_1.png");
				else
					im.updateBmp("ui/tobestr/star_2.png");

			}

		}

	}
}

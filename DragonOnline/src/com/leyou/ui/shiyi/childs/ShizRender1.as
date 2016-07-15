package com.leyou.ui.shiyi.childs {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Syj;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ShizRender1 extends AutoSprite {

		private var lastTimeLbl:Label;

		private var fightLbl:Label;
		private var descLbl:Label;
		private var buyBtn:NormalButton;

		private var rollNum:RollNumWidget;
		private var effSwf:SwfLoader;
		private var weaponSwf:SwfLoader;
		private var priceImg:Image;
		private var noticeLbl:Label;

		private var pTxtArr:Array=[];
		private var pLblArr:Array=[];

		private var itemArr:Array=[];

		private var selectIndex:int=0;

		private var bigAvater:BigAvatar;

		private var currentTabInfo:Object;

		private var st:int;

		public function ShizRender1() {
			super(LibManager.getInstance().getXML("config/ui/shiyi/shizRender1.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {

			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;
			this.noticeLbl=this.getUIbyID("noticeLbl") as Label;

			this.fightLbl=this.getUIbyID("fightLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.buyBtn=this.getUIbyID("buyBtn") as NormalButton;

			var i:int=0;
			for (i=0; i < 3; i++) {
				this.pTxtArr.push(this.getUIbyID("p" + (i + 1) + "Txt") as Label);
				this.pLblArr.push(this.getUIbyID("p" + (i + 1) + "Lbl") as Label);
			}

			this.rollNum=new RollNumWidget();
			this.addChild(this.rollNum);
			this.rollNum.loadSource("ui/num/{num}_zdl.png");

			this.rollNum.x=142;
			this.rollNum.y=404;

			this.rollNum.alignCenter();

			this.effSwf=new SwfLoader();
			this.addChild(this.effSwf);

			this.effSwf.x=469;
			this.effSwf.y=270;

			this.weaponSwf=new SwfLoader();
			this.addChild(this.weaponSwf);

			this.weaponSwf.x=469;
			this.weaponSwf.y=270;

			this.priceImg=new Image();
			this.addChild(this.priceImg);

			this.priceImg.x=55;
			this.priceImg.y=10;

			this.bigAvater=new BigAvatar();
			this.addChild(this.bigAvater);

			this.descLbl.wordWrap=true;
			this.descLbl.multiline=true;

			this.descLbl.width=232;
			this.descLbl.height=102;

			this.buyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.descLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.descLbl.mouseEnabled=true;

			this.bigAvater.mouseChildren=this.bigAvater.mouseEnabled=false;
			this.effSwf.mouseChildren=this.effSwf.mouseEnabled=false;
			this.weaponSwf.mouseChildren=this.weaponSwf.mouseEnabled=false;
		}

		private function onClick(e:MouseEvent):void {
			if (this.st == 0) {
				if (this.selectIndex > 0)
					Cmd_Syj.cmBuy(this.selectIndex);
			} else if (this.st == 1) {

				var cnum:int=TableManager.getInstance().getVipInfo(27).getVipValue(Core.me.info.vipLv);
				if (cnum > 1 && UIManager.getInstance().shiyeWnd.getTitleCount() >= cnum) {
					//						if (cnum > 1) {
					var str:String=StringUtil.substitute(TableManager.getInstance().getSystemNotice(23400).content, [cnum]);
					PopupManager.showAlert(str, null, false, "shiyialert");
						//						}
						//					this.useCb.turnOff();
				} else {

					var tinfo:TTitle=TableManager.getInstance().getTitleByID(this.selectIndex);
					var arr:Array=UIManager.getInstance().shiyeWnd.getOtherCount();
					if (tinfo.Sz_type != 1) {
						if (arr.length > 0) {
							Cmd_Syj.cmUninstall(arr[0]);
						}
					} else {
						if (arr.length >= 0 && UIManager.getInstance().shiyeWnd.getTitleCount() >= cnum) {
							Cmd_Syj.cmUninstall(arr[0]);
						}
					}



//					}

					Cmd_Syj.cmInstall(this.selectIndex);
				}


			} else if (this.st == 2) {
				Cmd_Syj.cmUninstall(this.selectIndex);
			}
		}

		private function onMouseMove(e:MouseEvent):void {

			var lb:Label=Label(e.target);
			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(lb.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url != null && url != "") {
				var tips:TipsInfo=new TipsInfo();
				tips.itemid=url.split("--")[1];
				tips.isShowPrice=true;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(e.stageX, e.stageY));
			}
		}

		public function updateInfo(o:Object):void {

			this.selectIndex=o.sinfo[0];
			this.st=o.sinfo[1];

			var obj:Object;
			for each (obj in this.itemArr) {
				if (obj.sortId == o.sinfo[0]) {
					obj.setBgState((o.sinfo[1] == 2));
				}
			}

			this.lastTimeLbl.visible=(o.sinfo[1] != 0)

			if (o.sinfo[2] > 0) {
				var d:Date=new Date();
				d.time=o.sinfo[2] * 1000;
				this.lastTimeLbl.text="" + TimeUtil.getDateToString2(d);
			} else {

				this.lastTimeLbl.text="" + PropUtils.getStringById(2368);
			}

			var tinfo:TTitle=TableManager.getInstance().getTitleByID(o.sinfo[0]);
			var power:int=0;

			for (var i:int=0; i < this.pTxtArr.length; i++) {

				if (int(tinfo["attribute" + (i + 1)]) > 0) {

					this.pTxtArr[i].text="" + PropUtils.getStringEasyById(int(tinfo["attribute" + (i + 1)])) + ":";
					this.pLblArr[i].text="" + tinfo["value" + (i + 1)];

					power+=TableManager.getInstance().getZdlElement(int(tinfo["attribute" + (i + 1)])).rate * int(tinfo["value" + (i + 1)]);

				} else {

					this.pTxtArr[i].text="";
					this.pLblArr[i].text="";

				}

			}

			if (power == 0)
				this.pTxtArr[0].text="" + PropUtils.getStringEasyById(1594);

			this.rollNum.setNum(power);

			if (tinfo.model2 == "" || tinfo.model2 == null) {
				this.effSwf.visible=false;
			} else {
				this.effSwf.visible=true;
			}

			this.weaponSwf.visible=false;
			this.bigAvater.visible=false;
			this.priceImg.fillEmptyBmd();

			switch (tinfo.Sz_type) {
				case 1:
					this.bigAvater.visible=true;
					if (int(tinfo.model2) > 0) {

						this.effSwf.update(int(tinfo.model2));

						if (tinfo.Bottom_Pic != "")
							this.priceImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");

					} else if (tinfo.Bottom_Pic != "") {
						this.effSwf.visible=false;
						this.priceImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");
					}

					this.addChild(this.priceImg);
					this.addChild(this.effSwf);

					this.effSwf.x=50;
					this.effSwf.y=10;

					this.bigAvater.showII(Core.me.info.featureInfo, false, Core.me.info.profession);

					this.bigAvater.x=150;
					this.bigAvater.y=340;

					break;
				case 2:
					this.effSwf.visible=false;
					this.weaponSwf.visible=false;
					this.bigAvater.visible=true;

					//					var marr:Array=tinfo.model2.split("|")[Core.me.info.profession - 1].split(",");

					//					this.effSwf.update(PnfUtil.realBigAvtId(PnfUtil.realAvtId(int(marr[1]),false,Core.me.info.sex)));
					//					this.effSwf.x=469;
					//					this.effSwf.y=440;
					//					
					//					this.weaponSwf.update(int(marr[0]));
					//					this.weaponSwf.x=469;
					//					this.weaponSwf.y=440;


					var finfo:FeatureInfo=new FeatureInfo();
					finfo.weapon=PnfUtil.realAvtId(tinfo.model.split("|")[Core.me.info.profession - 1].split(",")[0], false, Core.me.info.sex);
					finfo.suit=PnfUtil.realAvtId(tinfo.model.split("|")[Core.me.info.profession - 1].split(",")[1], false, Core.me.info.sex);

					this.bigAvater.show(finfo, false, Core.me.info.profession);
					this.bigAvater.playAct(PlayerEnum.ACT_STAND, 4);
					this.bigAvater.x=150;
					this.bigAvater.y=340;

					break;
				case 3:
					this.effSwf.update(int(tinfo.model2));
					this.effSwf.x=150;
					this.effSwf.y=330;
					break;
				case 4:
					this.effSwf.update(int(tinfo.model2));
					this.effSwf.x=150;
					this.effSwf.y=370;
					break;
				case 5:
//					this.effSwf.update(tinfo.model2.split(",")[Core.me.info.profession - 1]);
					break;
				case 6:
					this.effSwf.update(int(tinfo.model2));
					this.effSwf.x=150;
					this.effSwf.y=370;
					break;
				case 7:

					this.bigAvater.visible=true;
					this.bigAvater.showII(Core.me.info.featureInfo, true, Core.me.info.profession);

					this.bigAvater.x=150;
					this.bigAvater.y=340;

					var pinfo:TPnfInfo=TableManager.getInstance().getPnfInfo(int(tinfo.model2));

					this.effSwf.update(int(tinfo.model2));

					if (pinfo.type == 10) {
						this.effSwf.x=150;
						this.effSwf.y=335;
						this.addChild(this.bigAvater);

					} else if (pinfo.type == 3) {
						this.effSwf.x=150;
						this.effSwf.y=190;
						this.addChild(this.effSwf);
					}


					break;
			}

			/**
			 * 1 等级（进度条）
			 2 杀死怪物
			 3 杀死怪物数量（进度条）
			 4 完成指定任务
			 5 装备品质达成（进度条）
			 6 开启指定纹章组
			 7 坐骑达到指定等阶（进度条）
			 8 翅膀达到指定等阶（进度条）
			 9 好友数量（进度条）
			 10 战斗力排行
			 11 军衔积分排行榜
			 12 使用道具后获得
			 13 历史事件激活
			 14 全身装备强化（进度条）
			 15.宝石战斗力达成
			 17.宝石合成达到级别
			 18.消费排行榜排名
			 19.副本通关榜
			 20.VIP等级
			 21.租用
			 22.钻石购买
			 23.竞技场获胜次数
			 24.成为升龙城主
			 */

			var marryarr:Array=[2399, 2400, 2401, 2402];
			var marr:Array=[2395, 2396, 2397, 2398];
			var qarr:Array=[1604, 1605, 1606, 1607, 1608];
			var quarr:Array=[2391, 2392, 2393, 2394];
			var earr:Array=[2370, 2371, 2372, 2373, 2374];
			var arr:Array=[];
			var ttinfo:TItemInfo;
			var stStr:String;
			var strcontent:String;
			for (i=0; i < o.sinfo[3].length; i++) {
				if (int(tinfo["factorNum" + (i + 1)]) > 0) {

					if ([1, 3, 7, 8, 14].indexOf(int(tinfo["factor" + (i + 1)])) > -1) {
						strcontent="(" + o.sinfo[3][i] + "/" + int(tinfo["factorNum" + (i + 1)]) + ")";
					} else if ([2, 4, 5, 12, 25, 48, 42, 57, 53].indexOf(int(tinfo["factor" + (i + 1)])) > -1) {

						if (int(tinfo["factor" + (i + 1)]) == 25 || int(tinfo["factor" + (i + 1)]) == 48) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(earr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 5) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(qarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 42) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(quarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 57) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(marryarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 53) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(marr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else {
							ttinfo=TableManager.getInstance().getItemInfo(int(tinfo["factorNum" + (i + 1)]));
							strcontent="<font color='#" + ItemUtil.getColorByQuality2(ttinfo.quality) + "'><u><a href='event:itemid--" + int(tinfo["factorNum" + (i + 1)]) + "'>" + ttinfo.name + "</a></u></font>";
						}

					} else {
						strcontent="" + int(tinfo["factorNum" + (i + 1)]);
					}

					if (strcontent != null) {
						if (i == 0)
							strcontent=StringUtil.substitute(tinfo.des, [strcontent]);
						else
							strcontent=StringUtil.substitute(tinfo["des" + (i + 1)], [strcontent]);

						if (int(o.sinfo[3][i]) < int(tinfo["factorNum" + (i + 1)])) {
							strcontent+="<font color='#ff0000'>" + PropUtils.getStringEasyById(2360) + "</font>";
						} else {
							strcontent+="<font color='#00ff00'>" + PropUtils.getStringEasyById(2361) + "</font>";
						}

//						strcontent+=strcontent;
						arr.push(strcontent);
					}
				}
			}


			this.descLbl.htmlText="" + arr.join("\n");

			if (tinfo.moneyType > 0) {
				this.buyBtn.visible=true;

				if (tinfo.time > 0) {
					this.buyBtn.text="" + PropUtils.getStringById(2362);
				} else {
					this.buyBtn.text="" + PropUtils.getStringById(1721);
				}

			} else {
				this.buyBtn.visible=false;
			}

			if (o.sinfo[1] > 0) {

				this.buyBtn.visible=true;

				if (o.sinfo[1] == 1) {
					this.buyBtn.text="" + PropUtils.getStringById(2492);
				} else {
					this.buyBtn.text="" + PropUtils.getStringById(2493);
				}

			}

			if (tinfo.Sz_type == 1)
				this.noticeLbl.text="" + StringUtil.substitute(TableManager.getInstance().getSystemNotice(10165).content, [TableManager.getInstance().getVipInfo(27).getVipValue(Core.me.info.vipLv)]);
			else
				this.noticeLbl.text="" + StringUtil.substitute(TableManager.getInstance().getSystemNotice(10165).content, [1]);

			UIManager.getInstance().shiyeWnd.reAddChild();
		}

	}
}

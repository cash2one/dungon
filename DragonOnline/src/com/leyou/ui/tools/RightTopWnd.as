package com.leyou.ui.tools {

	import com.ace.config.Core;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.gameData.table.TFunForcastInfo;
	import com.ace.manager.GuideDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.MoldEnum;
	import com.leyou.enum.PkCopyEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.ui.tools.child.RightTopWidget;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class RightTopWnd extends AutoSprite {

		private static const BUTTON_WIDTH:int=60;

		private var widgets1:Dictionary;

		private var widgets2:Dictionary;

		private var widgets3:Dictionary;

		private var _spacing:int=0;

		private var _hspacing:int=75;

		private var sortArr:Vector.<RightTopWidget>;

		private var switchBtn1:ImgButton;

		private var switchBtn2:ImgButton;

		private var switchBtn3:ImgButton;

		private var panel1:Sprite;

		private var panel2:Sprite;

		private var panel3:Sprite;

		private var viewPanel1:Boolean=true;

		private var viewPanel2:Boolean=true;

		private var viewPanel3:Boolean=true;

		private var viewCount1:int;

		private var viewCount2:int;

		private var viewCount3:int;

		private var speed:int=500;

		private var exit:Boolean=false;

		public function RightTopWnd() {
			super(LibManager.getInstance().getXML("config/ui/ToolsUpWnd.xml"));
			this.init();
		}

		private function init():void {
			mouseChildren=true;
			switchBtn1=getUIbyID("switch1") as ImgButton;
			switchBtn2=getUIbyID("switch2") as ImgButton;
			switchBtn3=getUIbyID("switch3") as ImgButton;

			switchBtn1.x=59;
			switchBtn1.y=(59 - 17) / 2;
			switchBtn2.x=59;
			switchBtn2.y=switchBtn1.y + _hspacing;
			switchBtn3.x=59;
			switchBtn3.y=switchBtn2.y + _hspacing;
			panel1=new Sprite();
			panel2=new Sprite();
			panel3=new Sprite();
			addChild(panel3);
			addChild(panel2);
			addChild(panel1);
			widgets1=new Dictionary();
			widgets2=new Dictionary();
			widgets3=new Dictionary();
			sortArr=new Vector.<RightTopWidget>();
			addEventListener(MouseEvent.CLICK, onClick);

			var btnIdx:int=0;
			btnIdx=1;
			packButton("collectBtn", btnIdx++, 1);
//			packButton("achievementBtn", btnIdx++, 1);
//			packButton("rankBtn", btnIdx++, 1);
			packButton("towerBtn", btnIdx++, 1);
			packButton("arenaBtn", btnIdx++, 1);
			packButton("guildBattleBtn", btnIdx++, 1);
			packButton("copyRBtn", btnIdx++, 1);
			packButton("teamCopyBtn", btnIdx++, 1);
			packButton("bossCopyBtn", btnIdx++, 1);

			packButton("fieldBossBtn", btnIdx++, 1);
			packButton("questBtn", btnIdx++, 1);

			packButton("crossServerBtn", btnIdx++, 1);
			//			packButton("guildBattleBtn", btnIdx++, 1);
			//			packButton("questBtn", btnIdx++, 1);
			//			packButton("activityBtn", btnIdx++, 1);
			//			packButton("petBtn", btnIdx++, 1);

			btnIdx=1;
			packButton("taskMarketBtn", btnIdx++, 2);
//			packButton("tobeStrong", btnIdx++, 2);
			packButton("shopBtn", btnIdx++, 2);
			packButton("keyBtn", btnIdx++, 2);
//			packButton("worshipBtn", btnIdx++, 2);
			packButton("welfareBtn", btnIdx++, 2);
			packButton("activityBtn", btnIdx++, 2);
			packButton("sevenDayBtn", btnIdx++, 2);
			packButton("promotionBtn", btnIdx++, 2);
			packButton("v0", btnIdx++, 2);
			packButton("onlineBtn", btnIdx++, 2);
			packButton("v3expBtn", btnIdx++, 2);

			packButton("sevenDBtn", btnIdx++, 2);
			packButton("guildBtn", btnIdx++, 2);
			packButton("areaCelebrate", btnIdx++, 2);
			packButton("tecentVipBtn", btnIdx++, 2);


			btnIdx=1;
			packButton("investBtn", btnIdx++, 3);
			packButton("lotteryBtn", btnIdx++, 3);
			packButton("blackStoreBtn", btnIdx++, 3);
			packButton("kfjjBtn", btnIdx++, 3);
			packButton("kfhdBtn", btnIdx++, 3);
			packButton("groupBuyBtn", btnIdx++, 3);
			packButton("abidePayBtn", btnIdx++, 3);
			packButton("saleBtn", btnIdx++, 3);
			
			packButton("superReturnBtn", btnIdx++, 3);
			packButton("firstReturnBtn", btnIdx++, 3);
			
			packButton("payRankBtn", btnIdx++, 3);
			packButton("qqYellowBtn", btnIdx++, 3);
			packButton("firstPayBtn", btnIdx++, 3);
			packButton("todayAwardBtn", btnIdx++, 3);
			packButton("areaFirstPayBtn", btnIdx++, 3);
			
			packButton("taiwanBtn", btnIdx++, 3);
			packButton("costBtn", btnIdx++, 3);
			packButton("combineBtn", btnIdx++, 3);
			packButton("gambleBtn", btnIdx++, 3);


			//			packButton("saleBtn", btnIdx++, 3);
			//			packButton("abidePayBtn", btnIdx++, 3);
			//			packButton("costBtn", btnIdx++, 3);
			//			packButton("onlineBtn", btnIdx++, 3);

			var m1:Shape=new Shape();
			addChild(m1);
			panel1.mask=m1;
			var g:Graphics=m1.graphics;
			g.beginFill(0);
			g.drawRect(-657, 0, 715, _hspacing);
			g.endFill();

			var m2:Shape=new Shape();
			addChild(m2);
			panel2.mask=m2;
			var g2:Graphics=m2.graphics;
			g2.beginFill(0);
			g2.drawRect(-657, 0, 715, _hspacing * 2);
			g2.endFill();

			var m3:Shape=new Shape();
			addChild(m3);
			panel3.mask=m3;
			var g3:Graphics=m3.graphics;
			g3.beginFill(0);
			g3.drawRect(-657, 0, 715, _hspacing * 3);
			g3.endFill();


		}

		public override function set visible(value:Boolean):void {
			super.visible=value;
			if (!value) {
				GuideManager.getInstance().refreshGuide();
			}
		}

		public function getWidget(wName:String):RightTopWidget {
			var widget:RightTopWidget=widgets1[wName];
			if (null == widget) {
				widget=widgets2[wName];
			}
			if (null == widget) {
				widget=widgets3[wName];
			}
			return widget;
		}

		/**
		 * 反转显示状态
		 *
		 * row - 指定要反转的行数
		 *
		 **/
		public function reverseBarVisible(row:int, v:Boolean):void {
			switch (row) {
				case 1:
					switchPanel1(v);
					break;
				case 2:
					switchPanel2(v);
					break;
				case 3:
					switchPanel3(v);
					break;
			}
		}

		public function hideBar(type:int):void {
			if (1 == type) {
				panel1.visible=false;
				switchBtn1.visible=false;
				this.y=-65;
				exit=true;
			} else {
				panel2.visible=false;
				switchBtn2.visible=false;
			}

			var abtn:ImgButton=getUIbyID("achievementBtn") as ImgButton;
			if (abtn != null)
				abtn.y=70;
		}

		public function showBar(type:int):void {
			if (1 == type) {
				panel1.visible=true;
				switchBtn1.visible=true;
				if (exit) {
					exit=false;
					this.y=10;
				}
			} else {
				panel2.visible=true;
				switchBtn2.visible=true;
			}

			var abtn:ImgButton=getUIbyID("achievementBtn") as ImgButton;
			if (abtn != null)
				abtn.y=5;
		}

		/**
		 * 将按钮包入容器
		 *
		 * @param btnName 按钮名称
		 * @param index   按钮索引,从右往左数从1开始
		 * @param pos     位置,第一排是1,第二排是2
		 *
		 */
		private function packButton(btnName:String, index:int, pos:int):void {
			var imgBtn:ImgButton=getUIbyID(btnName) as ImgButton;
			var btnWidget:RightTopWidget=new RightTopWidget();
			btnWidget.index=index;
			btnWidget.visible=false;
			btnWidget.pushContent(imgBtn);
			btnWidget.x=-(BUTTON_WIDTH + _spacing) * index;
			imgBtn.x=0;
			imgBtn.y=0;
			if (1 == pos) {
				widgets1[btnWidget.name]=btnWidget;
				panel1.addChild(btnWidget);
				btnWidget.y=_hspacing * 0;
			} else if (2 == pos) {
				widgets2[btnWidget.name]=btnWidget;
				panel2.addChild(btnWidget);
				btnWidget.y=_hspacing * 1;
			} else if (3 == pos) {
				widgets3[btnWidget.name]=btnWidget;
				panel3.addChild(btnWidget);
				btnWidget.y=_hspacing * 2;
			}
		}

		public function packDisplay(display:DisplayObject, index:int, pos:int):void {
			if (widgets1.hasOwnProperty(display.name) || widgets2.hasOwnProperty(display.name) || widgets3.hasOwnProperty(display.name)) {
				return;
			}
			var btnWidget:RightTopWidget=new RightTopWidget();
			btnWidget.index=index;
			btnWidget.pushContent(display);
			btnWidget.x=-(BUTTON_WIDTH + _spacing) * index;

			if (1 == pos) {
				widgets1[btnWidget.name]=btnWidget;
				panel1.addChild(btnWidget);
			} else if (2 == pos) {
				widgets2[btnWidget.name]=btnWidget;
				panel2.addChild(btnWidget);
				btnWidget.y=_hspacing;
			} else if (3 == pos) {
				widgets3[btnWidget.name]=btnWidget;
				panel3.addChild(btnWidget);
				btnWidget.y=_hspacing * 2;
			}
		}

		public function removeDisplay(n:String, pos:int):void {
			var btnWidget:RightTopWidget;
			//			if (1 == pos) {
			//				btnWidget=widgets1[n];
			//				delete widgets1[n];
			//				panel1.removeChild(btnWidget);
			//			} else if (2 == pos) {
			//				btnWidget=widgets2[n];
			//				delete widgets2[n];
			//				panel2.removeChild(btnWidget);
			//			}else if(3 == pos){o
			//				btnWidget=widgets3[n];
			//				delete widgets3[n];
			//				panel3.removeChild(btnWidget);
			//			}
			if (widgets1.hasOwnProperty(n)) {
				btnWidget=widgets1[n];
				delete widgets1[n];
				panel1.removeChild(btnWidget);
			} else if (widgets2.hasOwnProperty(n)) {
				btnWidget=widgets2[n];
				delete widgets2[n];
				panel2.removeChild(btnWidget);
			} else if (widgets3.hasOwnProperty(n)) {
				btnWidget=widgets3[n];
				delete widgets3[n];
				panel3.removeChild(btnWidget);
			}
			btnWidget.die();
			refresh();
		}

		private function moveOver(panel:Sprite):void {
			panel.visible=false;
			GuideManager.getInstance().refreshGuide();
		}

		private var welfareSelfCount:int;
		private var sp:int;

		public function updateWelfare():void {
			var c:int=GuideManager.getInstance().rc;
			var fuliW:RightTopWidget=getWidget("welfareBtn");
			fuliW.setNum(c + welfareSelfCount);

			if (c > 0) {
				GuideDirectManager.getInstance().updateWelfareOther();
			}

			if (1 == sp) {
				fuliW.setText(PropUtils.getStringById(1963));
			} else {
				fuliW.setText("");
			}
		}

		/**
		 * 天天受充
		 * @param v
		 *
		 */
		public function updateDDSC(v:Boolean, v2:Boolean):void {
			var fuliW:RightTopWidget=getWidget("firstPayBtn");

			if (v) {
				fuliW.setText(PropUtils.getStringById(1964));
			} else {
				fuliW.setText("");
			}

			if (v2) {
				fuliW.setEffect(true)
			} else {
				fuliW.setEffect(false)
			}
		}

		public function callback(type:String):void {
			switch (type) {
				case "scp":
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [0]);
					UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK);
					break;
				case "scpcj":
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [0]);
					UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK);
					break;
				case "bcp":
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [1]);
//					UIOpenBufferManager.getInstance().open(WindowEnum.BOSS, 2);
					break;
				case "exp":

					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [4]);
					//					UIOpenBufferManager.getInstance().open(WindowEnum.EXPCOPY);
					break;
				case "sign":
					UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
					UIManager.getInstance().creatWindow(WindowEnum.WELFARE);
					UIManager.getInstance().welfareWnd.changeTable(0);
					break;
				case "col":
					UIOpenBufferManager.getInstance().open(WindowEnum.COLLECTION);
					break;
				case "offline":
					UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
					UIManager.getInstance().creatWindow(WindowEnum.WELFARE);
					UIManager.getInstance().welfareWnd.changeTable(3);
					break;
				case "bbt":
					UILayoutManager.getInstance().open_II(WindowEnum.TTT);
					break;
				case "cptm":
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [2]);
					break;
				case "farm":
					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					break;
				case "warter":
					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					break;
				case "wybq":
					UIOpenBufferManager.getInstance().open(WindowEnum.TASK_MARKET);
					break;
				case "wsp":
					UIOpenBufferManager.getInstance().open(WindowEnum.WORSHIP);
					break;
			}
		}

		//		tcs
		//		下行:tcs|{"mk":"I", "tid":tid, "act":num, "count":num, "sp":num}
		//		-- tid 引导id (练级场景:expc ,竞技场:jjc, boss副本:bcp,剧情副本:scp,农场:farm,挑战:act,福利:fuli,活跃度:hyd,排行榜:rak)
		//		-- act 是否激活（0,1）可能没有这个字段
		//		-- count 次数
		//		-- sp 特例（0,1）
		public function updateNotify(type:String, count:int, act:int, $sp:int, ... values):void {
			var playEffect:Boolean=((0 < count) || (1 == $sp));
			var arr:Array;
			switch (type) {
				case "tz":
					var tzW:RightTopWidget=getWidget("investBtn");
					if (!tzW.visible) {
						return;
					}
					tzW.setEffect(playEffect);
					tzW.setNum(count);
					break;
				case "expc":
					var expW:RightTopWidget=getWidget("expCopyBtn");
					if (!expW.visible) {
						return;
					}
					expW.setEffect(playEffect);
					expW.setNum(count);
					if (count > 0) {
						var ec:String=StringUtil.substitute(PropUtils.getStringById(1965), ["<font color='#ff0000'>({1}/10)</font><font color='#ff00'><u><a href='event:other_exp--exp'>"]);
						ec=StringUtil.substitute(ec, 10 - count);
						arr=[PropUtils.getStringById(2429), "<a href='event:other_exp--exp'>" + PropUtils.getStringById(2446) + "</a>", PropUtils.getStringById(2458), "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_levelingLine, arr);
					} else {
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_levelingLine)
					}
					break;
				case "jjc":
					var jjcW:RightTopWidget=getWidget("arenaBtn");
					jjcW.setEffect(playEffect);
					jjcW.setNum(count);
					if (1 == $sp) {
						jjcW.setText(PropUtils.getStringById(1964));
					} else {
						jjcW.setText("");
					}
					break;
				case "bcp":
					DataManager.getInstance().popupNumData.bossCyNum=count;
					var bcpW:RightTopWidget=getWidget("teamCopyBtn");
					bcpW.setEffect(playEffect);
					bcpW.setNum(DataManager.getInstance().popupNumData.cyNum);
//					var bcpW:RightTopWidget=getWidget("bossCopyBtn");
//					bcpW.setEffect(playEffect);
//					bcpW.setNum(count);
//					if (!bcpW.visible) {
//						return;
//					}
					var bc:String;
//					if (count > 0) {
					bc=StringUtil.substitute(PropUtils.getStringById(2448), [count]);
//						bc=StringUtil.substitute(bc, count);
//						bc=StringUtil.substitute(PropUtils.getStringById(2437), count);
//					} else {
//						bc="  " + StringUtil.substitute(PropUtils.getStringById(2437), ["<font color='#ff00'><u><a href='event:other_bcp--bcp'>"]) + "</a></u></font>";

//					}
					arr=[PropUtils.getStringById(2423), "<a href='event:other_bcp--bcp'>" + PropUtils.getStringById(2437) + "</a>", bc, "", callback]
					UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_bossCopyLine, arr);
					break;
				case "scp":
					DataManager.getInstance().popupNumData.storyCyNum=count;
					var scpW:RightTopWidget=getWidget("teamCopyBtn");
					scpW.setEffect(playEffect);
					scpW.setNum(DataManager.getInstance().popupNumData.cyNum);
//					var scpW:RightTopWidget=getWidget("storyCopyBtn");
//					if(scpW){
//						scpW.setEffect(playEffect);
//						scpW.setNum(count);
//						if (values[0] > 0) {
//							scpW.setText(PropUtils.getStringById(1964));
//						} else {
//							scpW.setText("");
//						}
//						if (!scpW.visible) {
//							return;
//						}
//					}

					var sc2:String;
					if (count > 0 || values[0] > 0) {
//						var sc1:String=StringUtil.substitute(PropUtils.getStringById(1969), ["<font color='#ff00'><u><a href='event:other_scp--scp'>"]) + "</a></u></font>";
//						sc1=StringUtil.substitute(sc1, values[0]);
						sc2=StringUtil.substitute(PropUtils.getStringById(2448), [count]);
//						sc2=StringUtil.substitute(sc2, count);
						arr=[PropUtils.getStringById(2421), "<a href='event:other_scp--scp'>" + PropUtils.getStringById(2430) + "</a>", sc2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_storeCopyLine, arr);
					} else {
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_storeCopyLine)
					}


					if (values[0] > 0) {
//						var sc1:String=StringUtil.substitute(PropUtils.getStringById(1969), ["<font color='#ff00'><u><a href='event:other_scp--scp'>"]) + "</a></u></font>";
//						sc1=StringUtil.substitute(sc1, values[0]);
						sc2=StringUtil.substitute(PropUtils.getStringById(2448), [values[0]]);
//						sc2=StringUtil.substitute(sc2, count);
						arr=[PropUtils.getStringById(2422), "<a href='event:other_scpcj--scpcj'>" + PropUtils.getStringById(2431) + "</a>", sc2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_storeCopylotteryLine, arr);
					} else {
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_storeCopylotteryLine)
					}

					break;
				case "farm":
					var farmW:RightTopWidget=getWidget("farmBtn");
					if (farmW) {
						farmW.setEffect(playEffect);
						farmW.setNum(count);
					}

					var fa2:String="";
					if (count > 0) {

						if (count > 0)
							fa2=StringUtil.substitute(PropUtils.getStringById(2456), count);

						arr=[PropUtils.getStringById(2427), "<a href='event:other_farm--farm'>" + PropUtils.getStringById(2444) + "</a>", fa2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_farmGetLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_farmGetLine);


					if (values[1][1] > 0) {

						if (values[1][1] > 0)
							fa2=StringUtil.substitute(PropUtils.getStringById(2455), values[1][1]);

						arr=[PropUtils.getStringById(2427), "<a href='event:other_farm--farm'>" + PropUtils.getStringById(2459) + "</a>", fa2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_farmPlantLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_farmPlantLine);


					if (values[1][0] > 0) {

						if (values[1][0] > 0)
							fa2=StringUtil.substitute(PropUtils.getStringById(2448), values[1][0]);

						arr=[PropUtils.getStringById(2426), "<a href='event:other_warter--warter'>" + PropUtils.getStringById(2443) + "</a>", fa2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_waterTreeLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_waterTreeLine);

					break;
				case "act":
					var actW:RightTopWidget=getWidget("deliveryBtn");
					actW.setEffect(playEffect);
					actW.setNum(count);
					break;
				case "fuli":
					var fuliW:RightTopWidget=getWidget("welfareBtn");
					if (!fuliW.visible) {
						return;
					}
					fuliW.setEffect(playEffect);

					welfareSelfCount=count;
					sp=$sp;
					if (1 == $sp) {
//						var wc1:String=StringUtil.substitute(PropUtils.getStringById(2432), ["<u><a href='event:other_sign--sign'>"]) + "</a></u>";
						arr=[PropUtils.getStringById(2422), "<a href='event:other_sign--sign'>" + PropUtils.getStringById(2432) + "</a></u>", PropUtils.getStringById(2450), "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_signInLine, arr);
					} else {
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_signInLine);
					}

					var wc2:String;
					if (int(values[0]) == 1) {
						wc2=PropUtils.getStringById(1898);
//					} else {
//						wc2=PropUtils.getStringById(1574);
//					}

//					wc1=StringUtil.substitute(PropUtils.getStringById(2447), ["<u><a href='event:other_offline--offline'>"]) + "</a></u>";
						arr=[PropUtils.getStringById(2421), "<a href='event:other_offline--offline'>" + PropUtils.getStringById(2447) + "</a></u>", wc2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_offlineExpLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_offlineExpLine);

					updateWelfare();
					break;
				case "hyd":
					var hydW:RightTopWidget=getWidget("activityBtn");
					hydW.setEffect(playEffect);
					hydW.setNum(count);
					break;
				case "rak":
//					var rakW:RightTopWidget=getWidget("rankBtn");
//					rakW.setEffect(playEffect);
//					rakW.setNum(count);
					break;
				case "sevd":
					var sevenDW:RightTopWidget=getWidget("sevenDBtn");
					sevenDW.setEffect(playEffect);
					sevenDW.setNum(count);
					if (count > 0) {
						if (!UIManager.getInstance().isCreate(WindowEnum.SEVENDAY) || !UIManager.getInstance().sevenDay.visible) {
							GuideManager.getInstance().showGuide(82, sevenDW);
						}
					}
					break;
				case "kf":
					var kfW:RightTopWidget=getWidget("areaCelebrate");
					kfW.setEffect(playEffect);
					kfW.setNum(count);
					break;
				case "col":
					var cfw:RightTopWidget=getWidget("collectBtn");
					if (cfw) {
						cfw.setEffect(playEffect);
						cfw.setNum(count);
					}
					DataManager.getInstance().collectionData.rewardCount=count;
					var groupId:int=DataManager.getInstance().collectionData.cgroupId;
					if (-1 == groupId && count <= 0) {
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_collectLine);
					} else {
						var remianTask:int=DataManager.getInstance().collectionData.remainTask(groupId);
						var cc1:String="";
						if (-1 == groupId) {
							cc1=PropUtils.getStringById(1552);
						} else {
							var tData:TCollectionPreciousInfo=TableManager.getInstance().getPreciousByGroup(groupId);
							cc1="<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>" + PropUtils.getStringById(1553);
							cc1=StringUtil.substitute(cc1, tData.mapName, remianTask);
						}
						var cc2:String=StringUtil.substitute(PropUtils.getStringById(1554), ["<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>"]);
						cc2=StringUtil.substitute(cc2, count);
						cc2=StringUtil.substitute(PropUtils.getStringById(2457), count);
						if (count <= 0) {
							cc2="";
						}
//						arr=[PropUtils.getStringById(1555), cc1, cc2, "", callback];

						arr=[PropUtils.getStringById(2428), "<a href='event:other_col--col'>" + PropUtils.getStringById(2445) + "</a>", cc2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_collectLine, arr);
					}
					break;
				case "ccz":
					var ccfw:RightTopWidget=getWidget("abidePayBtn");
					ccfw.setEffect(playEffect);
					ccfw.setNum(count);
					break;
				case "cptm":
					DataManager.getInstance().popupNumData.teamCyNum=count;
					var cptm:RightTopWidget=getWidget("teamCopyBtn");
					cptm.setEffect(playEffect);
					cptm.setNum(DataManager.getInstance().popupNumData.cyNum);

					if (count > 0) {
						var cp2:String=StringUtil.substitute(PropUtils.getStringById(2452), count);
						arr=[PropUtils.getStringById(2422), "<a href='event:other_cptm--cptm'>" + PropUtils.getStringById(2436) + "</a>", cp2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_teamCopyLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_teamCopyLine);
//					var cptm:RightTopWidget=getWidget("teamCopyBtn");
//					cptm.setEffect(playEffect);
//					cptm.setNum(count);
					break;
				case "yd":
					var tmw:RightTopWidget=getWidget("taskMarketBtn");
					if (tmw) {
						tmw.setEffect(playEffect);
						tmw.setNum(count);
					}

					if (count > 0) {
						var yd2:String=StringUtil.substitute(PropUtils.getStringById(2452), count);
						arr=[PropUtils.getStringById(2422), "<a href='event:other_wybq--wybq'>" + PropUtils.getStringById(2434) + "</a>", yd2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_powerfulRewardLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_powerfulRewardLine);

					break;
				case "lday":
					var lday:RightTopWidget=getWidget("sevenDayBtn");
					if (lday) {
						lday.setEffect(playEffect);
						lday.setNum(count);

						if (count > 0 && Core.me.info.level >= 15 && (!UIManager.getInstance().isCreate(WindowEnum.KEEP_7) || !UIManager.getInstance().sdayWnd.visible))
							UIManager.getInstance().sdayWnd.show();

					}
					break;
				case "hccz":
					var hday:RightTopWidget=getWidget("combineBtn");
					if (null != hday) {
						hday.setEffect(playEffect);
						hday.setNum(count);
					}
					break;
				case "lxtw":
					var lxtw:RightTopWidget=getWidget("taiwanBtn");
					if (null != lxtw) {
						lxtw.setEffect(playEffect);
						lxtw.setNum(count);
					}
				case "bbt":
					if (count > 0) {
						var bbt2:String=StringUtil.substitute(PropUtils.getStringById(2453), count);
						arr=[PropUtils.getStringById(2422), "<a href='event:other_bbt--bbt'>" + PropUtils.getStringById(2435) + "</a>", bbt2, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_tttLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_tttLine);
					break;
				case "wsp":
					if (count > 0) {
						var wsp:String=StringUtil.substitute(PropUtils.getStringById(2448), count);
						arr=[PropUtils.getStringById(2425), "<a href='event:other_wsp--wsp'>" + PropUtils.getStringById(2475) + "</a>", wsp, "", callback];
						UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_worshipLine, arr);
					} else
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_worshipLine);
					break;
				case "pet":

					MyInfoManager.getInstance().mercenaryClose=values[1][1];
					MyInfoManager.getInstance().mercenaryExp=values[1][0];
					MyInfoManager.getInstance().mercenaryCount=count;

					Cmd_Tsk.cmTaskQuest();
					break;
				case "hb":
					UIManager.getInstance().toolsWnd.setRedPackageBtnEffect(count);
					break;
			}
		}

		private function switchPanel1(v:Boolean):void {
			TweenLite.killTweensOf(panel1);
			if (!v) {
				switchBtn1.updataBmd("ui/funForcast/btn_left.png");
				TweenLite.to(panel1, viewCount1 * BUTTON_WIDTH / speed, {x: viewCount1 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel1]});
			} else {
				panel1.visible=true;
				TweenLite.to(panel1, viewCount1 * BUTTON_WIDTH / speed, {x: 0});
				switchBtn1.updataBmd("ui/funForcast/btn_right.png")
			}
			viewPanel1=v;
		}

		private function switchPanel2(v:Boolean):void {
			TweenLite.killTweensOf(panel2);
			if (!v) {
				switchBtn2.updataBmd("ui/funForcast/btn_left.png");
				TweenLite.to(panel2, viewCount2 * BUTTON_WIDTH / speed, {x: viewCount2 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel2]});
			} else {
				panel2.visible=true;
				TweenLite.to(panel2, viewCount2 * BUTTON_WIDTH / speed, {x: 0});
				switchBtn2.updataBmd("ui/funForcast/btn_right.png");
			}
			viewPanel2=v;
		}

		private function switchPanel3(v:Boolean):void {
			TweenLite.killTweensOf(panel3);
			if (!v) {
				switchBtn3.updataBmd("ui/funForcast/btn_left.png");
				TweenLite.to(panel3, viewCount3 * BUTTON_WIDTH / speed, {x: viewCount3 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel3]});
			} else {
				panel3.visible=true;
				TweenLite.to(panel3, viewCount3 * BUTTON_WIDTH / speed, {x: 0});
				switchBtn3.updataBmd("ui/funForcast/btn_right.png");
			}
			viewPanel3=v;
		}

		/**
		 * <T>点击按钮触发</T>
		 *
		 * @param e 鼠标事件
		 *
		 */
		private function onClick(e:MouseEvent):void {
			var n:String=e.target.name;
			switch (n) {
				case "switch1":
					switchPanel1(!viewPanel1);
//					TweenLite.killTweensOf(panel1);
//					if (viewPanel1) {
//						switchBtn1.updataBmd("ui/funForcast/btn_left.png");
//						TweenLite.to(panel1, viewCount1 * BUTTON_WIDTH / speed, {x: viewCount1 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel1]});
//					} else {
//						panel1.visible=true;
//						TweenLite.to(panel1, viewCount1 * BUTTON_WIDTH / speed, {x: 0});
//						switchBtn1.updataBmd("ui/funForcast/btn_right.png")
//					}
//					viewPanel1=!viewPanel1;
					break;
				case "switch2":
					switchPanel2(!viewPanel2);
//					TweenLite.killTweensOf(panel2);
//					if (viewPanel2) {
//						switchBtn2.updataBmd("ui/funForcast/btn_left.png");
//						TweenLite.to(panel2, viewCount2 * BUTTON_WIDTH / speed, {x: viewCount2 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel2]});
//					} else {
//						panel2.visible=true;
//						TweenLite.to(panel2, viewCount2 * BUTTON_WIDTH / speed, {x: 0});
//						switchBtn2.updataBmd("ui/funForcast/btn_right.png");
//					}
//					viewPanel2=!viewPanel2;
					break;
				case "switch3":
					switchPanel3(!viewPanel3);
//					TweenLite.killTweensOf(panel3);
//					if (viewPanel3) {
//						switchBtn3.updataBmd("ui/funForcast/btn_left.png");
//						TweenLite.to(panel3, viewCount3 * BUTTON_WIDTH / speed, {x: viewCount3 * BUTTON_WIDTH + 10, onComplete: moveOver, onCompleteParams: [panel3]});
//					} else {
//						panel3.visible=true;
//						TweenLite.to(panel3, viewCount3 * BUTTON_WIDTH / speed, {x: 0});
//						switchBtn3.updataBmd("ui/funForcast/btn_right.png");
//					}
//					viewPanel3=!viewPanel3;
					break;
				case "arenaBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.ARENA);
					break;
				case "farmBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					//					UILayoutManager.getInstance().open(WindowEnum.FARM);
					break;
				case "storyCopyBtn":
					//					UIOpenBufferManager.getInstance().open(WindowEnum.STORYCOPY);
					//					UILayoutManager.getInstance().open(WindowEnum.STORYCOPY);
					//					UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK);
					break;
				case "bossCopyBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.BOSS);
//					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					//					UILayoutManager.getInstance().open(WindowEnum.BOSS);
					break;
				case "fieldBossBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.DRAGON_BALL);
					//					UILayoutManager.getInstance().open(WindowEnum.FIELDBOSS);
					//					UILayoutManager.getInstance().open(WindowEnum.DRAGON_BALL);
					break;
				case "expCopyBtn":
					//					UIOpenBufferManager.getInstance().open(WindowEnum.EXPCOPY);
					//					UILayoutManager.getInstance().open(WindowEnum.EXPCOPY);
					break;
				case "deliveryBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.PKCOPY);
					break;
				case "questBtn":
					if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYPANEL))
						UIManager.getInstance().creatWindow(WindowEnum.PKCOPYPANEL);

					UIManager.getInstance().pkCopyPanel.updateInfo({"actid": PkCopyEnum.PKCOPY_QUEST});
					break;
				case "welfareBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
					//					UILayoutManager.getInstance().open(WindowEnum.WELFARE);
					break;
				case "rankBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.RANK);
//										UILayoutManager.getInstance().open(WindowEnum.RANK);
					break;
				case "shopBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					break;
				case "activityBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.ACTIVE);
					//					UILayoutManager.getInstance().open(WindowEnum.ACTIVE);
					break;
				case "keyBtn":
					UILayoutManager.getInstance().open(WindowEnum.CDKEY);
					break;
				case "achievementBtn":

					if (!UIManager.getInstance().isCreate(WindowEnum.ACHIEVEMENT))
						UIManager.getInstance().creatWindow(WindowEnum.ACHIEVEMENT);

					var wd:AutoWindow=UIManager.getInstance().getWindow(WindowEnum.ACHIEVEMENT) as AutoWindow;

					var mod:int=wd.visible ? 2 : 1;
					UILayoutManager.getInstance().singleMove(wd, "ACHIEVEMENT", mod, e.target.localToGlobal(new Point(50, 100)));
//					UIOpenBufferManager.getInstance().open(WindowEnum.ACHIEVEMENT);
					//					UILayoutManager.getInstance().open(WindowEnum.ACHIEVEMENT);
					break;
				//				case "vipBtn":
				//					UILayoutManager.getInstance().open(WindowEnum.VIP);
				//					break;
				case "lotteryBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.LUCKDRAW);
					//					UILayoutManager.getInstance().open(WindowEnum.LUCKDRAW);
					break;
				case "worshipBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.WORSHIP);
					//					UILayoutManager.getInstance().open(WindowEnum.WORSHIP);
					break;
				case "firstPayBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.TOPUP);
					break;
				case "areaFirstPayBtn":
					UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
					break;
				case "promotionBtn":
					//					UILayoutManager.getInstance().open(WindowEnum.PAY_PROMOTION);
					UIOpenBufferManager.getInstance().open(WindowEnum.PAY_PROMOTION);
					break;
				case "tobeStrong":
					UIOpenBufferManager.getInstance().open(WindowEnum.TOBE_STRONG);
					//					UILayoutManager.getInstance().open(WindowEnum.TOBE_STRONG);
					break;
				case "sevenDBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.SEVENDAY);
					//					UILayoutManager.getInstance().open(WindowEnum.SEVENDAY);
					break;
				case "investBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.INVEST);
					//					UILayoutManager.getInstance().open(WindowEnum.INVEST);
					break;
				case "areaCelebrate":
					UIOpenBufferManager.getInstance().open(WindowEnum.AREA_CELEBRATE);
					//					UILayoutManager.getInstance().open(WindowEnum.AREA_CELEBRATE);
					break;
				case "guildBtn":
					if (!UIManager.getInstance().isCreate(WindowEnum.GUILD) || !UIManager.getInstance().guildWnd.visible) {

						UILayoutManager.getInstance().show_II(WindowEnum.GUILD);

						TweenLite.delayedCall(0.3, function():void {
							UIManager.getInstance().guildWnd.setTabIndex(6);
						});
					} else {
						UILayoutManager.getInstance().hide(WindowEnum.GUILD);
					}
					break;
				case "firstReturnBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.FIRST_RETURN);
					//					if((null != UIManager.getInstance().payFirst) && UIManager.getInstance().payFirst.visible){
					//						UIManager.getInstance().payFirst.hide();
					//					}else{
					//						Cmd_FCZ.cm_FCZ_I();
					//					}
					break;
				case "payRankBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.PAY_RANK);
					//					UILayoutManager.getInstance().open(WindowEnum.PAY_RANK);
					break;
				case "onlineBtn":
					UILayoutManager.getInstance().open(WindowEnum.ONLINDREWARD);
					break;
				case "guildBattleBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.GUILD_BATTLE, 1);
					//					UILayoutManager.getInstance().open(WindowEnum.GUILD_BATTLE);
					break;
				case "tecentVipBtn":
					//					UIOpenBufferManager.getInstance().open(WindowEnum.QQ_VIP);
					UILayoutManager.getInstance().open(WindowEnum.QQ_VIP);
					break;
				case "qqYellowBtn":
					UILayoutManager.getInstance().open(WindowEnum.QQ_YELLOW);
					break;
				case "collectBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.COLLECTION);
					//					UILayoutManager.getInstance().open(WindowEnum.COLLECTION);
					break;
				case "costBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.INTEGRAL);
					//					UILayoutManager.getInstance().open(WindowEnum.INTEGRAL);
					break;
				case "abidePayBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.ABIDE_PAY);
					break;
				case "groupBuyBtn":
					//					UILayoutManager.getInstance().open(WindowEnum.GROUP_BUY);
					UIOpenBufferManager.getInstance().open(WindowEnum.GROUP_BUY);
					break;
				case "teamCopyBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					break;
				case "saleBtn":
					//					UILayoutManager.getInstance().open(WindowEnum.VENDUE);
					UIOpenBufferManager.getInstance().open(WindowEnum.VENDUE);
					break;
				//				case "legendaryBtn":
				//					UILayoutManager.getInstance().open(WindowEnum.LEGENDAREY_WEAPON);
				//					break;
				case "superReturnBtn":
					UILayoutManager.getInstance().open(WindowEnum.SUPER_FIRST_RETURN);
					break;
				case "blackStoreBtn":
					//					UILayoutManager.getInstance().open(WindowEnum.BLACK_STROE);
					UIOpenBufferManager.getInstance().open(WindowEnum.BLACK_STROE);
					break;
				case "petBtn":
					//					UILayoutManager.getInstance().open(WindowEnum.PET);
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);
					break;
				case "taskMarketBtn":
//					UILayoutManager.getInstance().open(WindowEnum.TASK_MARKET);
					UIOpenBufferManager.getInstance().open(WindowEnum.TASK_MARKET);
					break;
				case "sevenDayBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.KEEP_7);
					break;
				case "combineBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.COMBINE_RECHARGE);
					break;
				case "towerBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.TTT);
					break;
				case "gambleBtn":
					UILayoutManager.getInstance().open(WindowEnum.LABA);
					break;
				case "copyRBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.COPY_RANK);
					break;
				case "crossServerBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.CROSS_SERVER);
					break;
				case "taiwanBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.TAIWAN_LC);
					break;
				case "kfjjBtn":
					UILayoutManager.getInstance().open(WindowEnum.KFCB);
					break;
				case "kfhdBtn":
					UILayoutManager.getInstance().open(WindowEnum.KFHD);
					break;
				case "v3expBtn":
					UILayoutManager.getInstance().open(WindowEnum.VIP3EXP);
					break;
				case "v0":
					UILayoutManager.getInstance().open(WindowEnum.CLIENT_WND);
					break;
				case "todayAwardBtn":
					UILayoutManager.getInstance().open(WindowEnum.KF_HF_AWARD);
					break;
			}
		}

		/**
		 * <T>显示按钮</T>
		 *
		 * @param n 按钮名称
		 * @param num 次数
		 *
		 */
		public function active(n:String, num:int=-1, text:String=""):void {
			var widget:RightTopWidget=getWidget(n);
			if (null != widget) {
				if (num != -1) {
					widget.setNum(num);
				}
				if ("" != text) {
					widget.setText(text);
				}
				widget.setActive(true);
				refresh();
			}
		}

		public function setTime(n:String, time:int, ov:String=""):void {
			var widget:RightTopWidget=getWidget(n);
			if (null != widget) {
				widget.overV=ov;
				widget.setRemain(time);
			}
		}

		public function updateWidgetUrl(n:String, $url:String):void {
			var widget:RightTopWidget=getWidget(n);
			if (null != widget) {
				widget.updateBmp($url);
			}
		}

		public function setEffect(n:String, b:Boolean):void {
			var widget:RightTopWidget=getWidget(n);
			if (null != widget) {
				widget.setEffect(b);
			}
		}

		/**
		 * <T>隐藏按钮</T>
		 *
		 * @param n 按钮名称
		 *
		 */
		public function deactive(n:String):void {
			var widget:RightTopWidget=getWidget(n);
			if (null != widget) {
				widget.setActive(false);
				refresh();
			}
		}

		/**
		 * <T>刷新</T>
		 *
		 */
		public function refresh():void {
			viewCount1=refreshWidgetPos(widgets1);
			viewCount2=refreshWidgetPos(widgets2);
			viewCount3=refreshWidgetPos(widgets3);
			GuideManager.getInstance().resize();
		}

		/**
		 * <T>刷新按钮位置</T>
		 *
		 */
		private function refreshWidgetPos(widgets:Dictionary):uint {
			var vc:int=0;
			sortArr.length=0;
			for each (var widget:RightTopWidget in widgets) {
				if (widget.visible) {
					sortArr[vc++]=widget;
				}
			}
			sortArr.sort(compare);
			for (var n:int=0; n < vc; n++) {
				sortArr[n].x=-n * (BUTTON_WIDTH + _spacing);
					//trace("-----------widget name = "+ sortArr[n].name + "----widget.x = "+sortArr[n].x);
			}
			function compare(ca:RightTopWidget, cb:RightTopWidget):int {
				return (ca.index - cb.index);
			}
			return vc;
		}

		public function resize():void {
			if (exit) {
				this.y=-50;
			} else {
				this.y=10;
			}
			this.x=UIEnum.WIDTH - 452;
		}

		/**
		 * <T>升级时检测是否有开启模块</T>
		 *
		 */
		public function checkActiveIcon():void {
			active("achievementBtn");
			active("keyBtn");
			active("lotteryBtn");
			active("shopBtn");
			active("investBtn");
			active("guildBattleBtn");
//			active("todayAwardBtn");

			if (ConfigEnum.function1 == 1)
				active("groupBuyBtn");
			else
				deactive("groupBuyBtn");

			if (ConfigEnum.function4 == 1)
				active("saleBtn");
			else
				deactive("saleBtn");

			active("sevenDayBtn");
//			active("costBtn");
//			active("saleBtn");
//			active("kfhdBtn");
//			active("v0");
			
			this.setEffect("areaFirstPayBtn",true);

			// 腾讯平台
			if (Core.isTencent) {
				active("tecentVipBtn");
				if (0 == DataManager.getInstance().qqvipData.actSt) {
					active("qqYellowBtn");
				}
			}
			
			var level:int=Core.me.info.level;
			// 收集
			if (level >= ConfigEnum.setin1) {
				active("collectBtn");
//				UIManager.getInstance().toolsWnd.unlockButton(MoldEnum.COLLECTION);

				var count:int=DataManager.getInstance().collectionData.rewardCount;
				var groupId:int=DataManager.getInstance().collectionData.cgroupId;
				if (-1 == groupId && count <= 0) {
					UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_collectLine);
				} else {
					var remianTask:int=DataManager.getInstance().collectionData.remainTask(groupId);
					var cc1:String="";
					if (-1 == groupId) {
						cc1=PropUtils.getStringById(1552);
					} else {
						var tData:TCollectionPreciousInfo=TableManager.getInstance().getPreciousByGroup(groupId);
						cc1="<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>" + PropUtils.getStringById(1553);
						cc1=StringUtil.substitute(cc1, tData.mapName, remianTask);
					}
					var cc2:String=StringUtil.substitute(PropUtils.getStringById(1554), ["<font color='#ff00'><u><a href='event:other_col--col'>{1}</a></u></font>"]);
					cc2=StringUtil.substitute(cc2, count);
					cc2=StringUtil.substitute(PropUtils.getStringById(2457), count);
					if (count <= 0) {
						cc2="";
					}
//					var arr:Array=[PropUtils.getStringById(1555), cc1, cc2, "", callback];
					var arr:Array=[PropUtils.getStringById(2428), "<a href='event:other_col--col'>" + PropUtils.getStringById(2445) + "</a>", cc2, "", callback];
					UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_collectLine, arr);
				}
			}
			// 佣兵
			if (level >= ConfigEnum.servent1) {
				UIManager.getInstance().toolsWnd.unlockButton(MoldEnum.SERVENT);
				UIManager.getInstance().petIconbar.checkActive();
			}
			// 排行榜
			if (level >= ConfigEnum.RankOpenLevel) {
//				active("rankBtn");

//				UIManager.getInstance().toolsWnd.guildBtn.setActive(true, 1, true);
			}
			// 神器
			if (level >= ConfigEnum.Artifact1) {
				UIManager.getInstance().leftTopWnd.activeLegendaryBtn();
					//				active("legendaryBtn");
			}
			// 我要变强
			if (level >= ConfigEnum.tobeStr1) {
//				active("tobeStrong");
			}
			// 农场
			if (level >= ConfigEnum.FarmOpenLevel) {
//				active("farmBtn");
				UIManager.getInstance().toolsWnd.unlockButton(MoldEnum.FARM);
					//				UIManager.getInstance().openWindow(WindowEnum.FARM);
					//				UIManager.getInstance().openWindow(WindowEnum.FARM_SHOP);
					//				UIManager.getInstance().openWindow(WindowEnum.FARM_LOG);
			}
			// 剧情副本
			if (level >= ConfigEnum.StoryCopyOpenLevel) {
				active("storyCopyBtn");
					//				UIManager.getInstance().openWindow(WindowEnum.STORYCOPY);
					//				UIManager.getInstance().openWindow(WindowEnum.STORYCOPY_REWARD);
			}
			// 野外小Boss
			if (level >= ConfigEnum.question1) {
				active("bossCopyBtn");
			}
			// Boss副本
			//			if (level >= ConfigEnum.BossCopyOpenLevel) {
			//				active("bossCopyBtn");
			//			}
			//			
			//			//野外BOSS
			//			if (level >= ConfigEnum.FieldBossOpenLevel) {
			//				active("bossCopyBtn");
			//			}

			// 龙珠
			if (level >= ConfigEnum.DragonBall10) {
//				active("fieldBossBtn");
			}

			// 练级副本
			if (level >= ConfigEnum.ExpCopyOpenLevel) {
				active("expCopyBtn");
					//				UIManager.getInstance().openWindow(WindowEnum.EXPCOPY);
					//				UIManager.getInstance().openWindow(WindowEnum.EXPCOPY_MAP);
			}
			// 福利
			if (level >= ConfigEnum.WelfareOpenLvel) {
				active("welfareBtn");
					//				UIManager.getInstance().openWindow(WindowEnum.WELFARE);
			}
			// 活跃度
//			if (level >= ConfigEnum.ActiveOpenLevel) {
//				active("activityBtn");
//			}

			// 押镖
			if (level >= ConfigEnum.question1) {
				active("deliveryBtn");
			}

			// 竞技场
			if (level >= ConfigEnum.ArenaOpenLv) {
				active("arenaBtn");
			}

			// 答题
			//			if (level >= ConfigEnum.question1) {
			//				active("questBtn");
			//			}

			// 城主膜拜
			var funInfo:TFunForcastInfo=TableManager.getInstance().getFunForcstInfoById(10);
			if (level >= funInfo.openLevel) {
//				active("worshipBtn");

				UIManager.getInstance().toolsWnd.worshipBtn.setActive(true, 1, true);
			}

			//通天塔
			if (level >= ConfigEnum.Babel1) {
				active("towerBtn");
			}

			//纹章
			if (level >= ConfigEnum.BadgeOpenLv) {
				//				UIManager.getInstance().openWindow(WindowEnum.BADAGE);
				//				UIManager.getInstance().toolsWnd.unlockButton(MoldEnum.MEDAL);
			}

			//行会
			if (level >= ConfigEnum.UnionOpenLv) {
				//				active("guildBtn");
				UIManager.getInstance().toolsWnd.guildBtn.setActive(true, 1, true);
			}

			// 商城
			if (level >= ConfigEnum.MarketOpenLevel) {
				UIManager.getInstance().toolsWnd.shopBtn.setActive(true, 1, true);
			}

			//寄售
			if (level >= ConfigEnum.AutionOpenLevel) {
//				UIManager.getInstance().openWindow(WindowEnum.AUTION);
			}

			if (level >= ConfigEnum.MountTradeOpenLv) {
				UIManager.getInstance().roleWnd.openMountTrade();
			}

			if (level >= ConfigEnum.EquipIntensifyOpenLv) {
				UIManager.getInstance().toolsWnd.duanZBtn.setActive(true, 1, true);
			}

			if (level >= ConfigEnum.MountOpenLv) {
				UIManager.getInstance().toolsWnd.mountBtn.setActive(true, 1, true);
			}

			if (level >= ConfigEnum.StoryCopyOpenLevel) {
				active("teamCopyBtn");
			}

			if (level >= ConfigEnum.FastTop1) {
//				active("copyRBtn");
			}

			// 任务集市
			if (level >= ConfigEnum.TaskMarket1) {
				active("taskMarketBtn");
			}

			// 跨服
			if ((level >= ConfigEnum.multiple4) && !Core.isTaiwan) {
				active("crossServerBtn");
			}
			// 元素
			if (level >= ConfigEnum.ElementOpenLv) {
				UIManager.getInstance().toolsWnd.unlockButton(MoldEnum.ELEMENT);
			}

			if (ConfigEnum.BadgeOpenLv <= level) {
				Cmd_Bld.cm_bldOpen();
				UIManager.getInstance().toolsWnd.wenZBtn.setActive(true, 1, true);
			}

			if (ConfigEnum.V3exp34Open == level) {
				if (Core.me.info.vipLv == 0)
					UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
			}

			if (ConfigEnum.V3exp37Open == level) {
				UILayoutManager.getInstance().show(WindowEnum.VIP3EXP);
				active("v3expBtn");
//				if (Core.me.info.vipLv < 3)
//					UIManager.getInstance().vip3exp.setNoGet();
			}

			if (Core.me != null && Core.me.info.level >= 30 && MapInfoManager.getInstance().type == SceneEnum.SCENE_TYPE_PTCJ) {
				UIManager.getInstance().taskTrack2.hide();
				UIManager.getInstance().taskTrack.show();
				Cmd_Tsk.cmTaskQuest();
			}

			if (Core.me != null && Core.me.info.level >= 39) {
				Cmd_YBS.cm_YBS_Y();
			}

		}

	}
}

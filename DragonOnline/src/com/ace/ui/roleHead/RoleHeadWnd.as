package com.ace.ui.roleHead {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.gameData.buff.child.BuffInfo;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.buff.BuffWnd;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.utils.DebugUtil;
	import com.ace.utils.StringUtil;
	import com.ace.utils.TimeUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.PkMode;
	import com.leyou.net.cmd.Cmd_Pkm;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.utils.getTimer;

	public class RoleHeadWnd extends AutoSprite implements IMenu {
		//		private static const HP_WIDTH_MAX:int = 190;
		//		private static const MP_WIDTH_MAX:int = 152;

		private var userheadImg:Image;
		private var nameLbl:Label;
		private var modeLbl:Label;
		private var lvLbl:Label;
//		private var professionImg:Image;
//		private var pkModeBtn:ImgButton;
//		private var pkFlagImg:Image;
		private var payBtn:ImgButton;
		private var vipBtn:ImgButton;
		private var moneyLbl:Label;
		private var ybLbl:Label;
		private var bybLbl:Label;
		private var energyLbl:Label;
		private var zdl:RollNumWidget;
		private var menu:Vector.<MenuInfo>;
		private var modeList:Array;
		private var ybbImg:Image;
		private var ybImg:Image;
		private var jbImg:Image;
		private var hlImg:Image;
//		private var _wingBtn:ImgButton;
//		private var timeLbl:Label;

		private var remianT:int;

		// 当前的pk模式
		public var pkMode:int;
		public var buffWnd:BuffWnd;
		//		private var hpImg:Image;
		//		private var mpImg:Image;
		//		private var raceLbl:Label;
		//		private var hpLbl:Label;
		//		private var mpLbl:Label;
		//		private var thresholdMpImg:Image;
		//		private var thresholdHpImg:Image;
		//		private var trdHpContainer:Sprite;
		//		private var trdMpContainer:Sprite;
		//		private var targetSpt:Sprite;
		//		private var targetX:int;
		//		private var targetW:int;
		//		public var hpProgressImg:ProgressImage;
		//		public var mpProgressImg:ProgressImage;

		private var vipImg:Image;
		private var teamImg:Image;
//		private var guildImg:Image;
		private var doubleImg:Image;
		private var bloodImg:Image;
		private var freshImg:Image;
		private var safeImg:Image;
		private var worldExpImg:Image;
//		private var evtInfo:MouseEventInfo;
		private var modeBtn:ImgButton;
		private var pfVipImg:Image;
		private var pfImgContainer:Sprite;
		private var style:StyleSheet;
		private var copyArr:Vector.<MenuInfo>;

//		private var giftBtn:ImgButton;
//		private var giftSwf:SwfLoader;

		public function RoleHeadWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleHeadWnd.xml"));
			init();
//			mouseEnabled = true;
			mouseChildren=true;
		}

//		public function get wingBtn():ImgButton{
//			return _wingBtn;
//		}

		private function init():void {
			EventManager.getInstance().addEvent(EventEnum.GUIDE_PK_ATT, onPkAttack);
//			style = new StyleSheet();
//			style.setStyle("a:hover", {color:"#ff0000"});
//			giftBtn = getUIbyID("giftBtn") as ImgButton;
//			giftSwf = getUIbyID("giftSwf") as SwfLoader;
			userheadImg=getUIbyID("userheadImg") as Image;
			nameLbl=getUIbyID("nameLbl") as Label;
//			nameLbl.styleSheet = style;
			modeLbl=getUIbyID("modeLbl") as Label;
			lvLbl=getUIbyID("lvLbl") as Label;
			bybLbl=getUIbyID("bybLbl") as Label;
			ybLbl=getUIbyID("ybLbl") as Label;
			energyLbl=getUIbyID("energyLbl") as Label;
			moneyLbl=getUIbyID("moneyLbl") as Label;
//			timeLbl = getUIbyID("timeLbl") as Label;
//			pkFlagImg = getUIbyID("pkModeImg") as Image;
//			pkModeBtn = getUIbyID("pkModeBtn") as ImgButton;
			payBtn=getUIbyID("supplyBtn") as ImgButton;
			vipBtn=getUIbyID("vipBtn") as ImgButton;
//			_wingBtn = getUIbyID("wingBtn") as ImgButton;
			modeBtn=getUIbyID("modeBtn") as ImgButton;
			pfVipImg=getUIbyID("pfVipImg") as Image;
//			_wingBtn.visible = false;
//			_wingBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			modeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			vipBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			giftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			nameLbl.filters=[FilterEnum.hei_miaobian];
			buffWnd=new BuffWnd();
			addChild(buffWnd);
			menu=new Vector.<MenuInfo>(PkMode.PK_MODE_COUNT, true);

			zdl=new RollNumWidget();
			zdl.mouseChildren=false;
			zdl.mouseEnabled=false;
			zdl.x=137;
			zdl.y=87;
			zdl.speed=600;
			zdl.loadSource("ui/num/{num}_zdl.png");
			addChild(zdl);

			ybbImg=getUIbyID("ybbImg") as Image;
			ybImg=getUIbyID("ybImg") as Image;
			jbImg=getUIbyID("jbImg") as Image;
			hlImg=getUIbyID("hlImg") as Image;
//			professionImg = getUIbyID("professionImg") as Image;
			packContainer(ybbImg);
			packContainer(ybImg);
			packContainer(jbImg);
			packContainer(hlImg);
//			packContainer(professionImg);

			DebugUtil.cacheLabel(this);

//			vipBtn.setActive(false, 1, true);
//			payBtn.setActive(false, 1, true);

//			evtInfo = new MouseEventInfo();
//			evtInfo.onMouseMove = onMouseMove;
//			evtInfo.onMouseOut = onMouseOut;
			vipImg=getUIbyID("vipImg") as Image;
			teamImg=getUIbyID("teamImg") as Image;
//			guildImg=getUIbyID("guildImg") as Image;
			doubleImg=getUIbyID("doubleImg") as Image;
			bloodImg=getUIbyID("bloodImg") as Image;
			freshImg=getUIbyID("freshImg") as Image;
			safeImg=getUIbyID("safeImg") as Image;
			worldExpImg=getUIbyID("worldExpImg") as Image;
			packContainer(vipImg);
			packContainer(teamImg);
//			packContainer(guildImg);
			packContainer(doubleImg);
			packContainer(bloodImg);
			packContainer(freshImg);
			packContainer(safeImg);
			packContainer(worldExpImg);
//			MouseManagerII.getInstance().addEvents(vipImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(teamImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(guildImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(doubleImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(bloodImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(freshImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(safeImg, evtInfo);
			activeIcon("vipImg", false);
			activeIcon("teamImg", false);
			activeIcon("guildImg", false);
			activeIcon("doubleImg", false);
			activeIcon("bloodImg", false);
			activeIcon("freshImg", false);
			activeIcon("safeImg", false);
			activeIcon("worldExpImg", false);
			pfVipImg.visible=false;

			if (!Core.PAY_OPEN) {
				payBtn.setActive(false, 1, true);
			} else {
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}

			pfImgContainer=new Sprite();
			pfImgContainer.addChild(pfVipImg);
			addChild(pfImgContainer);
			pfImgContainer.addEventListener(MouseEvent.CLICK, onVipClick);
			nameLbl.mouseEnabled=true;
			nameLbl.addEventListener(TextEvent.LINK, onTextClick);
			//			hpImg=getUIbyID("hpImg") as Image;
			//			var hpIdx:int = getChildIndex(hpImg);
			//			removeChild(hpImg);
			//			hpProgressImg = new ProgressImage();
			//			hpProgressImg.updateBmp("ui/mainUI/main_character_bar_hp.png");
			//			hpProgressImg.x = hpImg.x;
			//			hpProgressImg.y = hpImg.y;
			//			addChildAt(hpProgressImg, hpIdx);
			//			mpImg=getUIbyID("mpImg") as Image;
			//			var mpIdx:int = getChildIndex(mpImg);
			//			removeChild(mpImg);
			//			mpProgressImg = new ProgressImage();
			//			mpProgressImg.updateBmp("ui/mainUI/main_character_bar_mp.png");
			//			mpProgressImg.x = mpImg.x;
			//			mpProgressImg.y = mpImg.y;
			//			addChildAt(mpProgressImg, mpIdx);
			//			raceLbl=getUIbyID("raceLbl") as Label;
			//			hpLbl=getUIbyID("hpLbl") as Label;
			//			mpLbl=getUIbyID("mpLbl") as Label;
			//			thresholdHpImg=getUIbyID("thresholdHpImg") as Image;
			//			thresholdMpImg=getUIbyID("thresholdMpImg") as Image;
			//			trdHpContainer = new Sprite()
			//			addChild(trdHpContainer);
			//			trdHpContainer.addChild(thresholdHpImg);
			//			trdHpContainer.x = thresholdHpImg.x;
			//			thresholdHpImg.x = 0;
			//			trdMpContainer = new Sprite();
			//			addChild(trdMpContainer);
			//			trdMpContainer.addChild(thresholdMpImg);
			//			trdMpContainer.x = thresholdMpImg.x;
			//			thresholdMpImg.x = 0;
			//			addChild(hpLbl);
			//			addChild(mpLbl);
			//			trdHpContainer.addEventListener(MouseEvent.MOUSE_DOWN, onThresholdMouseDown);
			//			trdMpContainer.addEventListener(MouseEvent.MOUSE_DOWN, onThresholdMouseDown);
			//			trdHpContainer.addEventListener(MouseEvent.MOUSE_OVER, onThresholdMouseOver);
			//			trdHpContainer.addEventListener(MouseEvent.MOUSE_OUT, onThresholdMouseOut);
			//			trdMpContainer.addEventListener(MouseEvent.MOUSE_OVER, onThresholdMouseOver);
			//			trdMpContainer.addEventListener(MouseEvent.MOUSE_OUT, onThresholdMouseOut);
		}

		protected function onTextClick(event:TextEvent):void {
			if (null == copyArr) {
				copyArr=new Vector.<MenuInfo>();
				copyArr.push(new MenuInfo(PropUtils.getStringById(1530), 1));
			}
			menuType=1;
			MenuManager.getInstance().show(copyArr, this);
		}

//		public function setFirstGift(value:Boolean, rtime:int):void{
//			if(value){
//				DataManager.getInstance().commonData.payStatus = 1;
//			}else{
//				DataManager.getInstance().commonData.payStatus = 2;
//			}
//			giftBtn.visible = value;
//			giftSwf.visible = value;
//			timeLbl.visible = value;
//			remianT = rtime;
//			tick = getTimer();
//			if(value && rtime > 0){
//				if(!TimeManager.getInstance().hasITick(uddateTime)){
//					TimeManager.getInstance().addITick(1000, uddateTime);
//				}
//				uddateTime();
//			}else{
//				if(TimeManager.getInstance().hasITick(uddateTime)){
//					TimeManager.getInstance().removeITick(uddateTime);
//				}
//			}
//		}

//		private function uddateTime():void{
//			var hour:String = StringUtil.fillTheStr(int(remianT/60/60), 2, "0", true);
//			var minutes:String = StringUtil.fillTheStr(int(remianT/60)%60, 2, "0", true);
//			var seconds:String = StringUtil.fillTheStr(remianT%60, 2, "0", true);
//			timeLbl.text = StringUtil.substitute("{1}:{2}:{3}", hour, minutes, seconds);
//		}

		protected function onVipClick(event:MouseEvent):void {
			UILayoutManager.getInstance().open(WindowEnum.QQ_VIP);
		}

		private function packContainer(img:Image):void {
			var container:Sprite=new Sprite();
			container.name=img.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			img.parent.addChild(container);
			container.addChild(img);
		}

		private function onMouseOut(event:MouseEvent):void {
//			trace("--------------------on mouse out target name = "+ event.target.name);
			ToolTipManager.getInstance().hide();
			if (TimeManager.getInstance().hasITick(onTipTick)) {
				TimeManager.getInstance().removeITick(onTipTick);
			}
		}

		public function activeIcon(tn:String, value:Boolean, values:Array=null):void {
			switch (tn) {
				case "vipImg":
					vipImg.filters=value ? null : [FilterEnum.enable];
					break;
				case "teamImg":
					teamImg.filters=value ? null : [FilterEnum.enable];
					break;
//				case "guildImg":
//					if (values && 0 != values.length) {
//						if (null == guildValues) {
//							guildValues=[];
//						}
//						guildValues.length=0;
//						for each (var id:int in values) {
//							guildValues.push(TableManager.getInstance().getguildAttributeInfo(id).uAtt);
//						}
//					}
//					guildImg.filters=value ? null : [FilterEnum.enable];
//					break;
				case "doubleImg":
					doubleImg.filters=value ? null : [FilterEnum.enable];
					break;
				case "bloodImg":
					bloodImg.filters=value ? null : [FilterEnum.enable];
					if (value) {
						SceneProxy.sm_update_buff(408);
					}
					break;
				case "freshImg":
					if (value) {
						freshImg.visible=true;
						safeImg.visible=false;
					} else {
						freshImg.visible=false;
					}
					break;
				case "safeImg":
					if (value) {
						safeImg.visible=true;
						freshImg.visible=false;
					} else {
						safeImg.visible=false;
					}
					break;
				case "worldExpImg":
					worldExpImg.filters=value ? null : [FilterEnum.enable];
					if (value) {
						wexpAdd=values[0];
					}
					break;
			}
		}

		public function checkBuffChange():void {
			var tbInfo:TBuffInfo;
			var bInfo:BuffInfo=null;
			// 补血buff
			bInfo=Core.me.info.buffsInfo.getBuff(408);
			if (null != bInfo) {
				activeIcon("bloodImg", true);
			} else {
				activeIcon("bloodImg", false);
			}
			// 组队buff
			bInfo=null;
			bInfo=Core.me.info.buffsInfo.getBuff(900);
			if (null == bInfo) {
				bInfo=Core.me.info.buffsInfo.getBuff(901);
			}
			if (null == bInfo) {
				bInfo=Core.me.info.buffsInfo.getBuff(902);
			}
			if (null != bInfo) {
//				if(null == teamVlaues){
//					teamVlaues = [];
				tbInfo=TableManager.getInstance().getBuffInfo(bInfo.id);
				var reg:RegExp=/\d{1,3}/g;
				teamVlaues=tbInfo.des.match(reg);
//				}
				activeIcon("teamImg", true);
			} else {
				activeIcon("teamImg", false);
			}
			// 双倍经验buff
			bInfo=null;
			bInfo=Core.me.info.buffsInfo.getBuff(950);
			if (null != bInfo) {
				activeIcon("doubleImg", true);
			} else {
				activeIcon("doubleImg", false);
			}
			// 安全保护buff
			bInfo=null;
			bInfo=Core.me.info.buffsInfo.getBuff(952);
			if (null != bInfo) {
				activeIcon("safeImg", true);
			} else {
				activeIcon("safeImg", false);
			}
		}

		private function onPkAttack():void {
			GuideManager.getInstance().showGuide(7, UIManager.getInstance().roleHeadWnd);
		}

//		// 更新翅膀信息
//		public function updateWingInfo(obj:Object):void{
//			var wingExist:Boolean = obj.st;
//			_wingBtn.visible = wingExist;
//		}

		private function onTipTick():void {
			var content:String;
			var buffInfo:BuffInfo;
			if ("safeImg" == targetName) {
				buffInfo=SceneCore.me.info.buffsInfo.getBuff(952);
				content=TableManager.getInstance().getSystemNotice(9969).content;
				if (null != buffInfo) {
					content=StringUtil.substitute(content, TimeUtil.date2CnFormat(buffInfo.lastTime));
				}
			} else if ("doubleImg" == targetName) {
				buffInfo=SceneCore.me.info.buffsInfo.getBuff(950);
				content=TableManager.getInstance().getSystemNotice(9967).content;
				if (null != buffInfo) {
					content=StringUtil.substitute(content, TimeUtil.date2CnFormat(buffInfo.lastTime));
				}
			}
			if (null == content)
				return;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 30, this.stage.mouseY + 30));
		}

		private var teamVlaues:Array;
		private var guildValues:Array;
		private var targetName:String;
		private var wexpAdd:int;
		private var menuType:int;
		private var tick:uint;

		protected function onMouseOver(event:MouseEvent):void {
//			trace("--------------------on mouse over target name = "+ event.target.name);
			var id:int;
			var content:String;
			switch (event.target.name) {
				case "ybbImg":
					content=TableManager.getInstance().getSystemNotice(9558).content;
					break;
				case "ybImg":
					content=TableManager.getInstance().getSystemNotice(9559).content;
					break;
				case "jbImg":
					content=TableManager.getInstance().getSystemNotice(9555).content;
					break;
				case "hlImg":
					content=TableManager.getInstance().getSystemNotice(9556).content;
					break;
				case "professionImg":
					if (PlayerEnum.PRO_MASTER == Core.me.info.profession) {
						content=PropUtils.getStringById(1526);
					} else if (PlayerEnum.PRO_RANGER == Core.me.info.profession) {
						content=PropUtils.getStringById(1527);
					} else if (PlayerEnum.PRO_SOLDIER == Core.me.info.profession) {
						content=PropUtils.getStringById(1528);
					} else if (PlayerEnum.PRO_WARLOCK == Core.me.info.profession) {
						content=PropUtils.getStringById(1529);
					}
					break;
				case "vipImg":
					id=(null != vipImg.filters && 0 != vipImg.filters.length) ? 6000 : 6001;
					var expRate:int=TableManager.getInstance().getVipInfo(12).getVipValue(Core.me.info.vipLv);
					var sitRate:int=TableManager.getInstance().getVipInfo(11).getVipValue(Core.me.info.vipLv);
					var energyRate:int=TableManager.getInstance().getVipInfo(10).getVipValue(Core.me.info.vipLv);
					content=TableManager.getInstance().getSystemNotice(id).content;
					if (Core.me.info.vipLv > 0) {
						content=StringUtil.substitute(content, Core.me.info.vipLv, expRate, sitRate, energyRate);
					}
					break;
				case "teamImg":
					id=(null != teamImg.filters && 0 != teamImg.filters.length) ? 3120 : 3121;
					content=TableManager.getInstance().getSystemNotice(id).content;
					if (teamVlaues && teamVlaues.length > 0) {
						content=StringUtil.substitute(content, teamVlaues);
					}
					break;
//				case "guildImg":
//					id=(null != guildImg.filters && 0 != guildImg.filters.length) ? 3058 : 3059;
//					content=TableManager.getInstance().getSystemNotice(id).content;
//					if (guildValues && guildValues.length > 0) {
//						content=StringUtil.substitute(content, guildValues);
//					}
//					break;
				case "doubleImg":
					event.target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
					id=(null != doubleImg.filters && 0 != doubleImg.filters.length) ? 9966 : 9967;
					content=TableManager.getInstance().getSystemNotice(id).content;
					if (9967 == id) {
						if (!TimeManager.getInstance().hasITick(onTipTick)) {
							TimeManager.getInstance().addITick(1000, onTipTick);
						}
						content=StringUtil.substitute(content, TimeUtil.date2CnFormat(SceneCore.me.info.buffsInfo.getBuff(950).lastTime));
					}
					break;
				case "bloodImg":
					id=(null != bloodImg.filters && 0 != bloodImg.filters.length) ? 9968 : 9952;
					content=TableManager.getInstance().getSystemNotice(id).content;
					if (9952 == id) {
						SceneProxy.sm_update_buff(408);
						content=StringUtil.substitute(content, SceneCore.me.info.buffsInfo.getBuff(408).zhi);
					}
					break;
				case "freshImg":
					id=9970;
					content=TableManager.getInstance().getSystemNotice(id).content;
					break;
				case "safeImg":
					id=9969;
					if (!TimeManager.getInstance().hasITick(onTipTick)) {
						TimeManager.getInstance().addITick(1000, onTipTick);
					}
					content=TableManager.getInstance().getSystemNotice(id).content;
					content=StringUtil.substitute(content, SceneCore.me.info.buffsInfo.getBuff(952).zhi);
					break;
				case "worldExpImg":
					id=(null != worldExpImg.filters && 0 != worldExpImg.filters.length) ? 9988 : 9989;
					content=TableManager.getInstance().getSystemNotice(id).content;
					if (9988 == id) {
						content=StringUtil.substitute(content, ConfigEnum.worldExp1, ConfigEnum.worldExp2);
					} else {
						content=StringUtil.substitute(content, wexpAdd);
					}
					break;
				default:
					break;
			}
			targetName=event.target.name;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		/**更新信息*/
		public function updataInfo(info:LivingInfo):void {
			if (Core.isTencent) {
				//				UIManager.getInstance().chatWnd.chatNotice("-----pfVipType = "+info.pfVipType);
				pfVipImg.visible=(0 != info.pfVipType);
				var url:String;
				// 腾讯
				if (1 == info.pfVipType) {
					url=StringUtil.substitute("ui/name/qq_vip_0{1}.png", info.pfVipLv);
					pfVipImg.updateBmp(url);
				} else if (2 == info.pfVipType) {
					url=StringUtil.substitute("ui/name/qq_vip_year_0{1}.png", info.pfVipLv);
					pfVipImg.updateBmp(url);
				}
			}
			nameLbl.htmlText=StringUtil_II.getColorStr(StringUtil_II.addEventString(info.name, info.name, false), "#FFFFFF", 14);
			lvLbl.text=info.level.toString();
//			professionImg.updateBmp("ui/common/common_profession_" + info.profession + ".png");
			userheadImg.updateBmp(PlayerUtil.getPlayerHeadImg(info.profession, info.sex), null, false, -1, -1, PriorityEnum.FIVE);
			updateCurrce();
			activeIcon("vipImg", info.vipLv > 0);
//			ybLbl.text = UIManager.getInstance().backpackWnd.yb+"";
//			moneyLbl.text = UIManager.getInstance().backpackWnd.jb+"";
//			energyLbl.text = info.baseInfo.hunL+"";
			//			raceLbl.text=PlayerUtil.getPlayerRaceByIdx(info.profession, 1);
			//			hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
			//			mpLbl.text=info.baseInfo.mp + "/" + info.baseInfo.maxMp;
			//			hpProgressImg.setProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			//			mpProgressImg.setProgress(info.baseInfo.mp / info.baseInfo.maxMp);
			//			updataMHP(info);
		}

		/**
		 * 更新战斗力
		 *
		 * @param num 战斗力数值
		 *
		 */
		public function updateZDL(num:int):void {
			zdl.rollToNum(num);
		}

		/**
		 * 更新货币信息
		 *
		 */
		public function updateCurrce():void {
			var byb:uint=UIManager.getInstance().backpackWnd.byb;
			if ((byb / 100000000) > 1) {
				byb/=100000000;
				bybLbl.text=byb + PropUtils.getStringById(1531);
			} else if ((byb / 10000) > 1) {
				byb/=10000;
				bybLbl.text=byb + PropUtils.getStringById(1532);
			} else {
				bybLbl.text=byb + "";
			}

			var yb:uint=UIManager.getInstance().backpackWnd.yb;
			if ((yb / 100000000) > 1) {
				yb/=100000000;
				ybLbl.text=yb + PropUtils.getStringById(1531);
			} else if ((yb / 10000) > 1) {
				yb/=10000;
				ybLbl.text=yb + PropUtils.getStringById(1532);
			} else {
				ybLbl.text=yb + "";
			}

			var money:uint=UIManager.getInstance().backpackWnd.jb;
			if ((money / 100000000) > 1) {
				money/=100000000;
				moneyLbl.text=money + PropUtils.getStringById(1531);
			} else if ((money / 10000) > 1) {
				money/=10000;
				moneyLbl.text=money + PropUtils.getStringById(1532);
			} else {
				moneyLbl.text=money + "";
			}
			if ((null != Core.me) && (null != Core.me.info) && (null != Core.me.info.baseInfo)) {
				var energy:uint=Core.me.info.baseInfo.hunL;
				if ((energy / 10000) > 1) {
					energy/=10000;
					energyLbl.text=energy + PropUtils.getStringById(1532);
				} else {
					energyLbl.text=energy + "";
				}
			}
		}

		/**
		 * <T>鼠标移入</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		//		protected function onThresholdMouseOver(event:MouseEvent):void{
		//			var progress:String
		//			var content:String;
		//			switch(event.target){
		//				case trdHpContainer:
		//					progress = AssistWnd.getInstance().hpHslider.progress.toFixed(2);
		//					content = TableManager.getInstance().getSystemNotice(9907).content;
		//					content = StringUtil.substitute(content,parseFloat(progress)*100+"%");
		//					break;
		//				case trdMpContainer:
		//					progress = AssistWnd.getInstance().mpHslider.progress.toFixed(2);
		//					content = TableManager.getInstance().getSystemNotice(9908).content;
		//					content = StringUtil.substitute(content, parseFloat(progress)*100+"%");
		//					break;
		//			}
		//			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX + 30, stage.mouseY + 30));
		//		}

		/**
		 * <T>鼠标移出</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		//		protected function onThresholdMouseOut(event:MouseEvent):void{
		//			ToolTipManager.getInstance().hide();
		//		}

		/**
		 * <T>设置血量和蓝量阀值</T>
		 *
		 * @param hp 血量阀值
		 * @param mp 蓝量阀值
		 *
		 */
		//		public function setThreshold(hp:Number, mp:Number):void{
		//			if(-1 != hp){
		//				var phx:int = hp*HP_WIDTH_MAX - (thresholdHpImg.width>>1);
		//				trdHpContainer.x = hpImg.x + phx;
		//			}
		//			if(-1 != mp){
		//				var pmx:int = mp*MP_WIDTH_MAX - (thresholdMpImg.width>>1);
		//				trdMpContainer.x = mpImg.x + pmx;
		//			}
		//		}

		/**
		 * <T>阀值图片抬起监听</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		//		protected function onThresholdMouseUP(event:Event):void{
		//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		//			stage.removeEventListener(MouseEvent.MOUSE_UP, onThresholdMouseUP);
		//			AssistWnd.getInstance().saveConfig();
		//		}

		/**
		 * <T>阀值图片按下监听</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		//		protected function onThresholdMouseDown(event:MouseEvent):void{
		//			targetSpt = event.target as Sprite;
		//			targetX = (targetSpt == trdHpContainer) ? hpImg.x : mpImg.x;
		//			targetW = (targetSpt == trdHpContainer) ? HP_WIDTH_MAX : MP_WIDTH_MAX;
		//			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		//			stage.addEventListener(MouseEvent.MOUSE_UP, onThresholdMouseUP);
		//		}

		/**
		 * <T>血量蓝量阀值设置鼠标移动监听</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		//		protected function onMouseMove(event:MouseEvent):void{
		//			if(null != targetSpt){
		//				var p:Point = globalToLocal(new Point(event.stageX, event.stageY));
		//				if(p.x > targetX && p.x <= (targetX + targetW)){
		//					targetSpt.x = p.x - (targetSpt.width>>1);
		//				}
		//				if(targetSpt == trdHpContainer){
		//					var hp:Number = (trdHpContainer.x - hpImg.x + (trdHpContainer.width>>1))/HP_WIDTH_MAX;
		//					hp = parseFloat(hp.toFixed(2));
		//					AssistWnd.getInstance().setProgress(hp, -1);
		//				}else{
		//					var mp:Number = (trdMpContainer.x - mpImg.x + (trdMpContainer.width>>1))/MP_WIDTH_MAX;
		//					mp = parseFloat(mp.toFixed(2));
		//					AssistWnd.getInstance().setProgress(-1, mp);
		//				}
		//			}
		//		}


		//------------------------------------------------------------
		// pk模式相关功能逻辑
		//------------------------------------------------------------
		/**
		 * <T>按钮点击事件处理</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			event.stopImmediatePropagation();
			var name:String=event.target.name;
			switch (name) {
				case "modeBtn":
					GuideManager.getInstance().removeGuide(6);
					GuideManager.getInstance().removeGuide(7);
					menuType=0;
					MenuManager.getInstance().show(menu, this);
					break;
//				case "wingBtn":
//					UILayoutManager.getInstance().open(WindowEnum.MARKET);
////					UIManager.getInstance().creatWindow(WindowEnum.MARKET)
//					UIManager.getInstance().marketWnd.changeTable(4);
//					break;
				case "supplyBtn":
					PayUtil.openPayUrl();
					break;
				case "vipBtn":
					GuideManager.getInstance().removeGuide(81);
					UILayoutManager.getInstance().open(WindowEnum.VIP);
					break;
//				case "giftBtn":
//					UILayoutManager.getInstance().open(WindowEnum.FIRSTGIFT);
//					break;
			}
		}

		/**
		 * <T>加载PK模式列表</T>
		 *
		 * @param obj 模式列表信息
		 *
		 */
		public function onPkmList(obj:Object):void {
			var list:Array=obj.list;
			var count:int=PkMode.PK_MODE_COUNT + 1;
			for (var n:int=1; n < count; n++) {
				modeList=list.concat();
				var idx:int=list.indexOf(n);
				if (-1 != idx) {
					var mode:int=list[idx];
					var menuName:String=PkMode.PK_MODE_MENU[mode - 1];
					menu[n - 1]=new MenuInfo(menuName, mode);
				} else {
					menu[n - 1]=null;
				}
			}
		}

		/**
		 * <T>设置当前PK模式</T>
		 *
		 * @param obj 模式信息
		 *
		 */
		public function onPkmSet(obj:Object):void {
			setMode(obj.set);
		}

		public function setMode(mode:int):void {
			if (pkMode != mode) {
				pkMode=mode;
				Core.me.info.pkMode=pkMode;
				EventManager.getInstance().dispatchEvent(EventEnum.LIVING_STOP_ATTACK);
			}
			activeIcon("freshImg", false);
			switch (pkMode) {
				case PkMode.PK_MODE_FRESH:
					activeIcon("freshImg", true);
					modeLbl.text=PropUtils.getStringById(1533);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_0.png");
					break;
				case PkMode.PK_MODE_PEACE:
					modeLbl.text=PropUtils.getStringById(1534);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_0.png");
					break;
				case PkMode.PK_MODE_KIND:
					modeLbl.text=PropUtils.getStringById(1535);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_1.png");
					break;
				case PkMode.PK_MODE_TEAM:
					modeLbl.text=PropUtils.getStringById(1536);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_2.png");
					break;
				case PkMode.PK_MODE_GUILD:
					modeLbl.text=PropUtils.getStringById(1537);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_3.png");
					break;
				case PkMode.PK_MODE_HYSTERICAL:
					modeLbl.text=PropUtils.getStringById(1538);
//					pkFlagImg.updateBmp("ui/mainUI/main_button_pk_4.png");
					break;
				case PkMode.PK_MODE_CAMP:
					modeLbl.text=PropUtils.getStringById(1539);
					break;
			}
		}

		/**
		 * <T>PK模式下拉菜单点击处理</T>
		 *
		 * @param idx 点击菜单索引
		 *
		 */
		public function onMenuClick(idx:int):void {
			if (0 != menuType) {
				System.setClipboard(nameLbl.text);
				return;
			}
			Cmd_Pkm.cm_Pkm_S(idx);
		}

		/**
		 * <T>更新角色PK模式</T>
		 *
		 * @param mode 模式枚举
		 *
		 */
		public function updataPkMode(mode:int):void {
			onMenuClick(mode);
		}

		public function toNextPkMode():void {
			if (1 == pkMode) {
				pkMode++;
			}
			var index:int=modeList.indexOf(pkMode);
			if (-1 != index) {
				index++;
				if (index >= modeList.length) {
					index=0;
				}
				Cmd_Pkm.cm_Pkm_S(modeList[index])
			}
		}

		//更新 生命值 魔法值
		//		public function updataMHP(info:LivingInfo):void {
		//			hpImg.setWH(207 * info.baseInfo.hp / info.baseInfo.maxHp, 18);
		//			mpImg.setWH(169 * info.baseInfo.mp / info.baseInfo.maxMp, 13);
		//			hpProgressImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp, 1);
		//			mpProgressImg.rollToProgress(info.baseInfo.mp / info.baseInfo.maxMp, 1);
		//			hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
		//			mpLbl.text=info.baseInfo.mp + "/" + info.baseInfo.maxMp;
		//		}
	}
}

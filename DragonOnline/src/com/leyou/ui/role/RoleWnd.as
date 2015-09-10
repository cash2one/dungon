package com.leyou.ui.role {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.greensock.core.TweenCore;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Element;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.net.cmd.Cmd_Nck;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.gem.GemWnd;
	import com.leyou.ui.mount.MountWnd;
	import com.leyou.ui.role.child.ElementWnd;
	import com.leyou.ui.role.child.PropertyWnd;
	import com.leyou.ui.role.child.children.EquipGrid;
	import com.leyou.ui.role.child.children.PropertyNum;
	import com.leyou.ui.role.child.children.RoleEquipUpWnd;
	import com.leyou.ui.title.TitleWnd;
	import com.leyou.ui.vip.VipEquipPage;
	import com.leyou.ui.wing.WingUnWnd;
	import com.leyou.ui.wing.WingWnd;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	//格式化代码
	public class RoleWnd extends AutoWindow {

		private var roleTabBar:TabBar;

		//人物属性面板
		private var rolePropertyWnd:PropertyWnd;

		//元素面板
		public var elementWnd:ElementWnd;

		//坐骑面板
		private var mountWnd:MountWnd;
		private var wingWnd:WingWnd; //翅膀面板
		private var wingUnWnd:WingUnWnd; //翅膀面板
		private var titleWnd:TitleWnd; //称号面板

		private var gemWnd:GemWnd; //称号面板

		private var fristF:Boolean; //是否第一次打开此面板

		private var info:RoleInfo;
		private var equip:Object;
		private var elementFlag:Boolean;

		private var otherPlayer:Boolean=false;

		private var bigAvatar:BigAvatar;

		private var roleEquipUp:RoleEquipUpWnd;
		private var propertyNum:PropertyNum;

		private var tweenCore:TweenCore;

		private var bgsp:Sprite;
		private var wingAvatar:SwfLoader;

		private var isOpenWing:Boolean=false;

		private var currentTabIndex:int=-1;

		/**
		 * 强化特效
		 */
		private var equipBackEffect:SwfLoader;
		private var equipEffect:SwfLoader;

		// 神器
		private var equipPage:VipEquipPage;

		public function RoleWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleWnd.xml"));
			this.init();
		}

		private function init():void {
			this.roleTabBar=this.getUIbyID("RoleTabBar") as TabBar;
			this.roleTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);

			this.rolePropertyWnd=new PropertyWnd();
			this.roleTabBar.addToTab(this.rolePropertyWnd, 0);

			this.elementWnd=new ElementWnd();
			this.roleTabBar.addToTab(this.elementWnd, 3);

			this.mountWnd=new MountWnd();
			this.roleTabBar.addToTab(this.mountWnd, 1);

			this.gemWnd=new GemWnd();
			this.roleTabBar.addToTab(this.gemWnd, 2);

			this.wingWnd=new WingWnd();
//			this.roleTabBar.addToTab(this.wingWnd, 3);

//			this.wingUnWnd=new WingUnWnd();
			this.roleTabBar.addToTab(this.wingWnd, 6);

			this.titleWnd=new TitleWnd();
			this.roleTabBar.addToTab(this.titleWnd, 4);

			this.equipPage=new VipEquipPage();
			this.roleTabBar.addToTab(this.equipPage, 5);

			this.propertyNum=new PropertyNum();

			this.propertyNum.x=287;
			this.propertyNum.y=68;
			this.addChild(this.propertyNum);

			this.equipBackEffect=new SwfLoader();
			this.addChild(this.equipBackEffect);

			this.equipBackEffect.x=160;
			this.equipBackEffect.y=408;

			this.roleEquipUp=new RoleEquipUpWnd();
			this.addChild(this.roleEquipUp);
			this.roleEquipUp.y=70;
			this.roleEquipUp.x=15;

			this.bigAvatar=new BigAvatar();
			this.bigAvatar.x=156;
			this.bigAvatar.y=411;
			this.addChild(this.bigAvatar);

			this.propertyNum.addEventListener(MouseEvent.CLICK, onMouseOver);

			this.wingAvatar=new SwfLoader();
			this.addChild(this.wingAvatar);

			this.wingAvatar.x=150;
			this.wingAvatar.y=408;

			this.roleEquipUp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.roleEquipUp.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.equipEffect=new SwfLoader();
			this.addChild(this.equipEffect);

			this.equipEffect.x=155;
			this.equipEffect.y=248;

			this.equipEffect.mouseChildren=false;
			this.equipEffect.mouseEnabled=false;

			bgsp=new Sprite();
			bgsp.graphics.beginFill(0x000000);
			bgsp.graphics.drawRect(0, 0, 143, 307);
			bgsp.graphics.endFill();

			this.addChild(bgsp);

			bgsp.x=80;
			bgsp.y=110;
			bgsp.alpha=0;

			bgsp.addEventListener(MouseEvent.CLICK, onEffClick);

//			this.scrollRect=new Rectangle(-256, 0, 745, 524);
		}

		private function onEffClick(e:MouseEvent):void {
			this.bigAvatar.showII(Core.me.info.featureInfo, true, Core.me.info.profession);
		}

		private function onMouseOut(e:MouseEvent):void {

			if (e.target is EquipGrid) {
				if (this.tweenCore != null)
					this.tweenCore.kill();

				this.tweenCore=TweenLite.delayedCall(1.5, exeTime);
			}
		}


		private function onMouseOver(e:MouseEvent):void {

			if (this.tweenCore != null)
				this.tweenCore.kill();

			if (e.target is PropertyNum) {

				this.setChildIndex(this.propertyNum, 8);
				this.setChildIndex(this.roleEquipUp, 6);
				this.setChildIndex(this.bigAvatar, 7);

				this.tweenCore=TweenLite.delayedCall(3, exeTime);

			} else if (e.target is EquipGrid) {

				this.setChildIndex(this.propertyNum, 6);
				this.setChildIndex(this.roleEquipUp, 10);
				this.setChildIndex(this.bigAvatar, 7);
			}

		}

		private function exeTime():void {
			this.setChildIndex(this.propertyNum, 6);
			this.setChildIndex(this.roleEquipUp, 7);
			this.setChildIndex(this.bigAvatar, 8);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {


			UIManager.getInstance().hideWindow(WindowEnum.EQUIP);
			UIManager.getInstance().hideWindow(WindowEnum.STOREGE);
			UIManager.getInstance().hideWindow(WindowEnum.SHOP);
			UIManager.getInstance().hideWindow(WindowEnum.AUTION);

//			if (UIManager.getInstance().backpackWnd.visible) {
//
//				this.x=(UIEnum.WIDTH - this.width - UIManager.getInstance().backpackWnd.width) / 2;
//				UIManager.getInstance().backpackWnd.x=this.x + this.width + 5;
//				UIManager.getInstance().backpackWnd.y=this.y;
//
//			}

//			if (!this.visible) {



//			this.roleTabBar.setTabVisible(5, true);

//			Cmd_Role.cm_role();
//			Cmd_Role.cm_equip();
//
//			Cmd_Element.cm_ele_s();
//			Cmd_Element.cm_ele_c();
//
//			Cmd_Mount.cmMouInit();
//			Cmd_Wig.cm_WigInit();
//			Cmd_Nck.cm_NckInit();
//			}

			if (!this.visible)
				this.updateWingEffect(this.roleEquipUp.currentEquip);

			this.roleTabBar.turnToTab(0);

			super.show(toTop, $layer, toCenter);
//			this.updateWingEffect([99933, 99935]);

			if (ConfigEnum.MountOpenLv <= Core.me.info.level)
				GuideManager.getInstance().showGuide(2, this.roleTabBar.getTabButton(1));

			if (ConfigEnum.NckOpenLv <= Core.me.info.level)
				GuideManager.getInstance().showGuide(59, this.roleTabBar.getTabButton(4));

			GuideManager.getInstance().removeGuide(1);
			GuideManager.getInstance().removeGuide(57);
			GuideManager.getInstance().removeGuide(58);
			GuideManager.getInstance().removeGuide(9);
			GuideManager.getInstance().removeGuide(90);

			UIManager.getInstance().backpackWnd.setPlayGuideMountItem(1);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_ElementFlagNum);
		}

		public function getTabIndex():int {
			return this.roleTabBar.turnOnIndex;
		}

		public function getTabButton(i:int):TabButton {
			return this.roleTabBar.getTabButton(i);
		}

		/**
		 * @param i
		 */
		public function setTabIndex(i:int):void {
			this.roleTabBar.turnToTab(i);
		}

		/**
		 *
		 *
		 */
		public function buyWingEffect():void {
			this.wingUnWnd.flyMovie();
			this.hide();
		}

		private function onTabBarChangeIndex(evt:Event):void {

			if (this.currentTabIndex == this.roleTabBar.turnOnIndex)
				return;

			if (this.roleTabBar.turnOnIndex == 4) {
				Cmd_Nck.cm_NckInit();
				GuideManager.getInstance().removeGuide(59);
			} else {
//				GuideManager.getInstance().removeGuide(58);
			}

			if (this.roleTabBar.turnOnIndex == 6) {

				Cmd_Wig.cm_WigInit();
				this.wingAvatar.visible=true;
				this.wingWnd.wingNameImg.visible=true;

			} else {

				if (UIManager.getInstance().wingLvUpWnd.visible)
					UIManager.getInstance().hideWindow(WindowEnum.WINGLVUP);

				if (UIManager.getInstance().wingTradeWnd.visible)
					UIManager.getInstance().wingTradeWnd.hide();

				this.wingAvatar.visible=false;
				this.wingWnd.wingNameImg.visible=false;

				PopupManager.closeConfirm("openWingConfirm");
			}

			if (this.roleTabBar.turnOnIndex == 1) {
				Cmd_Mount.cmMouInit();

				GuideManager.getInstance().removeGuide(4);
				GuideManager.getInstance().removeGuide(2);
				GuideManager.getInstance().removeGuide(1);

				UIManager.getInstance().backpackWnd.setPlayGuideMountItem(2);
			} else {

				GuideManager.getInstance().removeGuide(87);
				GuideManager.getInstance().removeGuide(88);

				if (UIManager.getInstance().mountLvUpwnd.visible)
					UIManager.getInstance().mountLvUpwnd.hide();

				if (UIManager.getInstance().mountTradeWnd.visible)
					UIManager.getInstance().mountTradeWnd.hide();

			}

			if (this.roleTabBar.turnOnIndex == 3) {

				Cmd_Element.cm_ele_s();
				Cmd_Element.cm_ele_c();

				GuideManager.getInstance().removeGuide(120);
				GuideManager.getInstance().removeGuide(10);

				if (ConfigEnum.ElementOpenLv <= Core.me.info.level && this.elementWnd.guildElement==-1)
					GuideManager.getInstance().showGuide(11, this);

				GuideManager.getInstance().showGuide(80, this.elementWnd.begainBtn);

			} else {

				UIManager.getInstance().hideWindow(WindowEnum.MESSAGE);
				GuideManager.getInstance().removeGuide(11);
				GuideManager.getInstance().removeGuide(80);

			}

			if (this.roleTabBar.turnOnIndex == 2) {
				Cmd_Gem.cmGemInit();
				GuideManager.getInstance().removeGuide(110);
			} else {

				this.gemWnd.clearGrid();
//				UIManager.getInstance().hideWindow(WindowEnum.GEM_LV);
			}

			if (this.roleTabBar.turnOnIndex == 0) {

				Cmd_Role.cm_role();
				Cmd_Role.cm_equip();
				this.bigAvatar.showII(Core.me.info.featureInfo, false, Core.me.info.profession);
				this.bigAvatar.visible=true;

				this.roleEquipUp.visible=true;
				this.propertyNum.visible=true;

				this.bgsp.visible=true;
			} else {

				this.bgsp.visible=false;
				this.bigAvatar.visible=false;
				this.roleEquipUp.visible=false;
				this.propertyNum.visible=false;

				this.equipBackEffect.visible=false;
				this.equipEffect.visible=false;
				UIManager.getInstance().hideWindow(WindowEnum.MEDIC);
			}

			if (this.currentTabIndex != this.roleTabBar.turnOnIndex)
				UIManager.getInstance().selectWnd.hide();

			if (this.roleTabBar.turnOnIndex == 5) {
				this.equipPage.updateInfo();
			}

			UILayoutManager.getInstance().hide(WindowEnum.QUICK_BUY);
			this.currentTabIndex=this.roleTabBar.turnOnIndex

		}

		/**
		 *更新面板的位置
		 * @param flag
		 *
		 */
		public function setPos(flag:int):void {

			var w:Number;
			if (flag == 1) { //坐骑升级
				w=UIManager.getInstance().mountLvUpwnd.width;
			} else if (flag == 2) {
				//坐骑驯养
				w=UIManager.getInstance().mountTradeWnd.width;
			} else if (flag == 3) { //翅膀升级
				w=UIManager.getInstance().wingLvUpWnd.width;
			}

			this.x=(UIEnum.WIDTH - this.width - w) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}


		public function openWingBuy():void {
			if (Core.me.info.level >= ConfigEnum.WingOpenLv)
				this.roleTabBar.setTabVisible(6, true);
			else
				this.roleTabBar.setTabVisible(6, false);
		}

		/**
		 *更新人物信息
		 * @param info
		 *
		 */
		public function updateInfo(info:RoleInfo):void {
			UIManager.getInstance().showPanelCallback(WindowEnum.ROLE);

			this.info=info;
			this.rolePropertyWnd.updateInfo(info);
			this.roleEquipUp.updateInfo(info);
			this.propertyNum.updateInfo(info);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			if (ConfigEnum.MountOpenLv <= Core.me.info.level)
				this.roleTabBar.setTabVisible(1, true);
			else
				this.roleTabBar.setTabVisible(1, false);

			if (ConfigEnum.ElementOpenLv <= Core.me.info.level) {
				this.roleTabBar.setTabVisible(3, true);
				GuideManager.getInstance().showGuide(120, this.roleTabBar.getTabButton(3));
			} else
				this.roleTabBar.setTabVisible(3, false);

			if (Core.me.info.level >= ConfigEnum.WingOpenLv) {
				this.roleTabBar.setTabVisible(6, false);
			} else
				this.roleTabBar.setTabVisible(6, false);

			if (Core.me.info.level >= ConfigEnum.NckOpenLv)
				this.roleTabBar.setTabVisible(4, true);
			else
				this.roleTabBar.setTabVisible(4, false);

			if (Core.me.info.level >= ConfigEnum.Gem1)
				this.roleTabBar.setTabVisible(2, true);
			else
				this.roleTabBar.setTabVisible(2, false);



			Cmd_Gem.cmGemInit();
			Cmd_Role.cm_role();
			Cmd_Role.cm_equip();

			Cmd_Element.cm_ele_s();
			Cmd_Element.cm_ele_c();

			Cmd_Mount.cmMouInit();
			Cmd_Wig.cm_WigInit();
			Cmd_Nck.cm_NckInit();

			//宝石引导
			if (Core.me.info.level == ConfigEnum.Gem1) {
				GuideManager.getInstance().showGuide(110, this.roleTabBar.getTabButton(2));
			}

			GuideManager.getInstance().removeGuide(109);
		}

		override public function set visible(value:Boolean):void {
			super.visible=value;
		}

		/**
		 *更新装备信息
		 *
		 */
		public function updateEquip():void {
			this.roleEquipUp.updateEquip(this.otherPlayer);
			if (this.roleTabBar.turnOnIndex == 0)
				this.updateWingEffect(this.roleEquipUp.currentEquip);
			UIManager.getInstance().backpackWnd.refresh();
		}

		/**
		 *删除装备
		 * @param pos
		 *
		 */
		public function deleteEquip(pos:int):void {
			this.roleEquipUp.deleteEquip(pos);
			if (this.roleTabBar.turnOnIndex == 0)
				this.updateWingEffect(this.roleEquipUp.currentEquip);
		}

		/**
		 *
		 * @param o
		 *
		 */
		public function updatemountEquip(o:Array):void {
			this.mountWnd.updateEquipSlot(o);

		}

		/**
		 *元素的信息
		 * @return
		 *
		 */
		public function get elementInfo():ElementInfo {
			if (this.elementWnd.info == null)
				this.elementWnd.info=new ElementInfo();

			return this.elementWnd.info;
		}

		/**
		 *更新元素信息
		 * @param info
		 *
		 */
		public function updateElement(info:ElementInfo):void {
			this.elementWnd.updateInfor(info);
		}

		public function updateGemInfo(o:Object):void {
			this.gemWnd.updateInfo(o);
		}

		public function setGemSlot(p:int):void {
			this.gemWnd.setCurrentSlotItem(p);
		}

		/**
		 *更新守护元素信息
		 * @param info
		 *
		 */
		public function updateGuildElement(info:ElementInfo):void {
			if (ConfigEnum.ElementOpenLv <= Core.me.info.level) {
				this.roleTabBar.setTabVisible(3, true);
				this.elementWnd.updateGuildElement(info);
			} else
				this.roleTabBar.setTabVisible(3, false);
		}

		public function updateMount(o:Object):void {
			 
//			trace(ConfigEnum.MountOpenLv, Core.me.info.level)
			if (ConfigEnum.MountOpenLv <= Core.me.info.level) {

				this.roleTabBar.setTabVisible(1, true);

//				if (this.roleTabBar.turnOnIndex == 1)
				this.mountWnd.updateData(o);

				UIManager.getInstance().toolsWnd.mountBtn.setActive(true, 1, true);

				Cmd_Wig.cm_WigInit();
			} else {
				this.roleTabBar.setTabVisible(1, false);
				UIManager.getInstance().toolsWnd.mountBtn.setActive(false, .6, true);
			}
		}

		/**
		 * 坐骑属性列表
		 * @param o
		 *
		 */
		public function updateMountProps(o:Object):void {
			this.mountWnd.updatePropList(o);
		}

		/**
		 * 改变坐骑状态
		 * @param o
		 */
		public function changeMountState(o:Object):void {
			this.mountWnd.changeMountState(o);
		}

		/**
		 * 更新数据
		 * @param o
		 *
		 */
		public function updateWig(o:Object):void {
//			trace(Core.me.info.level, o.lv)
			if (o.hasOwnProperty("lv") && Core.me.info.level >= ConfigEnum.WingOpenLv) {
				this.isOpenWing=true;

//				if (this.wingWnd.parent == null) {
				UIManager.getInstance().adWnd.setStateWing(true);
//					this.roleTabBar.addToTab(this.wingWnd, 6);

				if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
					UIManager.getInstance().marketWnd.setADStateWing(true);
				}
//				}

//				if (this.roleTabBar.turnOnIndex == 5)
				this.wingWnd.updateInfo(o);
				this.roleTabBar.setTabVisible(6, true);

			} else {
				this.roleTabBar.setTabVisible(6, false);
			}

		}

		public function updateWingEffect(pid:Array):void {
			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;

			if (pid[0] != -1) {

				this.equipBackEffect.visible=true;
				this.equipBackEffect.update(pid[0], play1);

				function play1():void {
					equipBackEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}

			}

			if (pid[1] != -1) {

				this.equipEffect.visible=true;
				this.equipEffect.update(pid[1], play2);

				function play2():void {
					equipEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}
			}

		}


		/**
		 * 血量,法力,精力
		 *
		 */
		public function updateHpAndMpAndSoul():void {
			this.propertyNum.updateHpAndMpAndSoul();
		}

		/**
		 *上下坐骑
		 *
		 */
		public function mountUpAndDown():void {
			this.mountWnd.UpAndDownMount();
		}

		public function mountStopDown():void {
			this.mountWnd.stopDownMout();
		}

		public function updateWingAvatar(pnfid:int):void {
			var pnid:int=38000 + (pnfid - 1);
			this.wingAvatar.update(pnid);
		}

		/**
		 * 坐骑是否达到最高等级
		 * @return
		 *
		 */
		public function mountIsTopLv():Boolean {
			return this.mountWnd.Lv == 10;
		}

		public function mountLv():int {
			return this.mountWnd.Lv;
		}

		public function wingLv():int {
			return this.wingWnd.Lv;
		}

		public function wingOpenTradeLv():Boolean {
			return this.wingWnd.Lv >= ConfigEnum.wing17;
		}

		public function wingIsTopLv():Boolean {
			return this.wingWnd.wLv >= 100;
		}

		public function elementschangeState(i:int):void {
			this.elementWnd.changeState(i);
		}

		/**
		 *开启驯养
		 * @return
		 *
		 */
		public function openMountTrade():void {
			this.mountWnd.openTrade();
		}

		/**
		 * 开启格子
		 * @param o
		 *
		 */
		public function updateWingGrid(o:Object):void {
			this.wingWnd.updateGrid(o);
		}

		/**
		 * @param o
		 */
		public function updateWingGridList(o:Object):void {
			this.wingWnd.updateGridList(o);
		}

		/**
		 *	更新称号列表
		 * @param o
		 */
		public function updateTitleList(o:Object):void {
			if (Core.me != null && Core.me.info != null && ConfigEnum.NckOpenLv <= Core.me.info.level) {
				this.roleTabBar.setTabVisible(4, true);
				this.titleWnd.updateInfo(o);

//				if (this.visible)
//					GuideManager.getInstance().showGuide(59, this.roleTabBar.getTabButton(4));
			} else
				this.roleTabBar.setTabVisible(4, false);

		}

		public function get titlePanel():TitleWnd {
			return this.titleWnd;
		}

		/**
		 *更新人物avatar
		 *
		 */
		public function updateRoleAvatar():void {
			this.bigAvatar.showII(Core.me.info.featureInfo, true, Core.me.info.profession);
//			this.bigAvatar.showEquipEffect(Core.me.info.avtArr[6], Core.me.info.avtArr[5]);
		}

		public function updateVipEquip():void {
			this.equipPage.udpateStatus();
		}

		/**
		 *翅膀是否开启
		 * @return
		 *
		 */
		public function openWing():Boolean {
			if (Core.me.info.level >= ConfigEnum.WingOpenLv) {
				return this.isOpenWing;
			}

			return false;
		}

		public function getPower():int {
			return this.info.fight;
		}

		override public function hide():void {
			super.hide();

			if (UIManager.getInstance().mountLvUpwnd.visible) {
				UIManager.getInstance().mountLvUpwnd.hide();
			}

			if (UIManager.getInstance().mountTradeWnd.visible) {
				UIManager.getInstance().mountTradeWnd.hide();
			}

			if (UIManager.getInstance().wingLvUpWnd.visible) {
				UIManager.getInstance().wingLvUpWnd.hide();
			}

			PopupManager.closeConfirm("changeElement");
			PopupManager.closeConfirm("openWingConfirm");
			UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);
//			UIManager.getInstance().hideWindow(WindowEnum.GEM_LV);
			UIManager.getInstance().hideWindow(WindowEnum.MEDIC);
			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);

			GuideManager.getInstance().removeGuide(2);
			GuideManager.getInstance().removeGuide(11);
			GuideManager.getInstance().removeGuide(58);
			GuideManager.getInstance().removeGuide(59);
			GuideManager.getInstance().removeGuide(80);

			GuideManager.getInstance().removeGuide(87);
			GuideManager.getInstance().removeGuide(88);
			GuideManager.getInstance().removeGuide(110);
			GuideManager.getInstance().removeGuide(120);

			this.roleTabBar.turnToTab(0);

			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;
			this.gemWnd.clearGrid();

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.playerBtn);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_ElementFlagNum);


			UIManager.getInstance().selectWnd.closePanel([0, 1, 2]);
		}

		public function resise():void {

//			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;

			var _w:Number=489;

			if (UIManager.getInstance().mountLvUpwnd.visible) {

//				if (this.x + _w + 3 + UIManager.getInstance().mountLvUpwnd.width > UIEnum.WIDTH)
				this.x=UIEnum.WIDTH - UIManager.getInstance().mountLvUpwnd.width - 3 - _w >> 1;

				UIManager.getInstance().mountLvUpwnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().mountLvUpwnd.y=this.y + UILayoutManager.SPACE_Y;

			} else if (UIManager.getInstance().mountTradeWnd.visible) {

//				if (this.x + _w + 3 + UIManager.getInstance().mountTradeWnd.width > UIEnum.WIDTH)
				this.x=UIEnum.WIDTH - UIManager.getInstance().mountTradeWnd.width - 3 - _w >> 1;

				UIManager.getInstance().mountTradeWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().mountTradeWnd.y=this.y + UILayoutManager.SPACE_Y;

			} else if (UIManager.getInstance().wingLvUpWnd.visible) {

//				if (this.x + _w + 3 + UIManager.getInstance().wingLvUpWnd.width > UIEnum.WIDTH)
				this.x=UIEnum.WIDTH - UIManager.getInstance().wingLvUpWnd.width - 3 - _w >> 1;

				UIManager.getInstance().wingLvUpWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().wingLvUpWnd.y=this.y + UILayoutManager.SPACE_Y;
			}
		}

		override public function onWndMouseMove($x:Number, $y:Number):void {
			super.onWndMouseMove($x, $y);

			var _w:Number=489;

			if (UIManager.getInstance().mountLvUpwnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().mountLvUpwnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().mountLvUpwnd.width - 3 - _w;

				UIManager.getInstance().mountLvUpwnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().mountLvUpwnd.y=this.y + UILayoutManager.SPACE_Y;

			} else if (UIManager.getInstance().mountTradeWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().mountTradeWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().mountTradeWnd.width - 3 - _w;

				UIManager.getInstance().mountTradeWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().mountTradeWnd.y=this.y + UILayoutManager.SPACE_Y;

			} else if (UIManager.getInstance().wingLvUpWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().wingLvUpWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().wingLvUpWnd.width - 3 - _w;

				UIManager.getInstance().wingLvUpWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().wingLvUpWnd.y=this.y + UILayoutManager.SPACE_Y;
			} else if (UIManager.getInstance().wingTradeWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().wingTradeWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().wingTradeWnd.width - 3 - _w;

				UIManager.getInstance().wingTradeWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().wingTradeWnd.y=this.y + UILayoutManager.SPACE_Y;
//			} else if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV) && UIManager.getInstance().gemLvWnd.visible) {
//
//				if (this.x + _w + 3 + UIManager.getInstance().gemLvWnd.width > UIEnum.WIDTH)
//					this.x=UIEnum.WIDTH - UIManager.getInstance().gemLvWnd.width - 3 - _w;
//
//				UIManager.getInstance().gemLvWnd.x=this.x + _w + UILayoutManager.SPACE_X;
//				UIManager.getInstance().gemLvWnd.y=this.y + UILayoutManager.SPACE_Y;
			} else if (UIManager.getInstance().isCreate(WindowEnum.MEDIC) && UIManager.getInstance().medicWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().medicWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().medicWnd.width - 3 - _w;

				UIManager.getInstance().medicWnd.x=this.x + _w + UILayoutManager.SPACE_X;
				UIManager.getInstance().medicWnd.y=this.y + UILayoutManager.SPACE_Y + 3;
			}

		}

		override public function onWndMouseDown():void {
			super.onWndMouseDown();

			if (UIManager.getInstance().mountLvUpwnd.visible) {
				UIManager.getInstance().mountLvUpwnd.setToTop();
			} else if (UIManager.getInstance().mountTradeWnd.visible) {
				UIManager.getInstance().mountTradeWnd.setToTop();
			} else if (UIManager.getInstance().wingLvUpWnd.visible) {
				UIManager.getInstance().wingLvUpWnd.setToTop();
			} else if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV) && UIManager.getInstance().gemLvWnd.visible) {
				UIManager.getInstance().gemLvWnd.setToTop();
			} else if (UIManager.getInstance().isCreate(WindowEnum.MEDIC) && UIManager.getInstance().medicWnd.visible) {
				UIManager.getInstance().medicWnd.setToTop();
			}

			UIManager.getInstance().selectWnd.setToTop();
		}


		override public function get width():Number {
			return 489;
		}

		override public function get height():Number {
			return 528;
		}

		public function playVipSkillCd(skillId:int):void {
			equipPage.playCD(skillId);
		}

		public function getMouseLvBtn():NormalButton {
			return this.mountWnd.getMouseLvBtn();
		}

	}
}

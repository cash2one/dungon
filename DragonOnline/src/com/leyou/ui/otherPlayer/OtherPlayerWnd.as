package com.leyou.ui.otherPlayer {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.PnfUtil;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.net.cmd.Cmd_Marry;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.dragonBall.children.DragonBallPropertyRender;
	import com.leyou.ui.gem.GemWnd;
	import com.leyou.ui.mount.MountWnd;
	import com.leyou.ui.role.child.ElementWnd;
	import com.leyou.ui.role.child.PropertyWnd;
	import com.leyou.ui.role.child.children.EquipGrid;
	import com.leyou.ui.role.child.children.PropertyNum;
	import com.leyou.ui.role.child.children.RoleEquipUpWnd;
	import com.leyou.ui.title.TitleWnd;
	import com.leyou.ui.wing.WingWnd;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	//格式化代码
	public class OtherPlayerWnd extends AutoWindow {

		private var roleTabBar:TabBar;

		//人物属性面板
		private var rolePropertyWnd:PropertyWnd;

		//元素面板
		public var elementWnd:ElementWnd;

		//坐骑面板
		private var mountWnd:MountWnd;
		private var wingWnd:WingWnd; //翅膀面板
		private var titleWnd:TitleWnd; //称号面板
		private var gemWnd:GemWnd; //称号面板
		public var dragonBall:DragonBallPropertyRender;

		private var fristF:Boolean; //是否第一次打开此面板

		private var info:RoleInfo;
		private var equip:Object;
		private var elementFlag:Boolean;

		private var otherPlayer:Boolean=true;

		private var bigAvatar:BigAvatar;

		private var roleEquipUp:RoleEquipUpWnd;
		private var propertyNum:PropertyNum;
		private var feachInfo:FeatureInfo;

		private var wingAvatar:SwfLoader;

		private var playName:String;

		private var equipBackEffect:SwfLoader;
		private var equipEffect:SwfLoader;

		private var bgsp:Sprite;

		private var wardrobeBtn:NormalButton;
		private var marryBtn:NormalButton;
		private var marryiconImg:Image;
		private var marryiconImgbg:Image;
		private var marryiconImgSwf:SwfLoader;

		private var lvImg:Image;
		private var qulityImg:Image;

		private var marryName:String;
		private var img1SSwf:Sprite;

		private var ava9:int;

		private var tipinfo:TipsInfo;

		public function OtherPlayerWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleWnd.xml"), true);
			this.init();
		}

		private function init():void {
			this.wardrobeBtn=this.getUIbyID("wardrobeBtn") as NormalButton;
			this.marryBtn=this.getUIbyID("marryBtn") as NormalButton;
			this.marryiconImg=this.getUIbyID("marryiconImg") as Image;
			this.marryiconImgbg=this.getUIbyID("marryiconImgbg") as Image;

			this.qulityImg=this.getUIbyID("qulityImg") as Image;
			this.lvImg=this.getUIbyID("lvImg") as Image;

			this.roleTabBar=this.getUIbyID("RoleTabBar") as TabBar;
			this.roleTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);

			this.rolePropertyWnd=new PropertyWnd(otherPlayer);
			this.roleTabBar.addToTab(this.rolePropertyWnd, 0);

			this.mountWnd=new MountWnd(otherPlayer);
			this.roleTabBar.addToTab(this.mountWnd, 1);

			this.gemWnd=new GemWnd(otherPlayer);
			this.roleTabBar.addToTab(this.gemWnd, 2);

			this.wingWnd=new WingWnd(otherPlayer);
			this.roleTabBar.addToTab(this.wingWnd, 6);

			dragonBall=new DragonBallPropertyRender(true);
			this.roleTabBar.addToTab(this.dragonBall, 7);

			dragonBall.mouseChildren=dragonBall.mouseEnabled=false;

			this.propertyNum=new PropertyNum(otherPlayer);

			this.propertyNum.x=330;
			this.propertyNum.y=90;
			this.addChild(this.propertyNum);

			this.equipBackEffect=new SwfLoader();
			this.addChild(this.equipBackEffect);

			this.equipBackEffect.x=160;
			this.equipBackEffect.y=428;

			this.roleEquipUp=new RoleEquipUpWnd(otherPlayer);
			this.addChild(this.roleEquipUp);
			this.roleEquipUp.y=90;
			this.roleEquipUp.x=10;

			this.roleEquipUp.setLVImg(this.lvImg);
			this.roleEquipUp.setQualityImg(this.qulityImg);

//			this.lvImg.x+=13;
//			this.lvImg.y+=67;
//			
//			this.qulityImg.x+=13;
//			this.qulityImg.y+=67;
//			
//			this.addChild(this.lvImg);
//			this.addChild(this.qulityImg);

			this.bigAvatar=new BigAvatar();
			this.bigAvatar.x=165;
			this.bigAvatar.y=436;
			this.addChild(this.bigAvatar);

			this.feachInfo=new FeatureInfo();

			this.wingAvatar=new SwfLoader();
			this.addChild(this.wingAvatar);

			this.wingAvatar.x=160;
			this.wingAvatar.y=448;

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseMove, true);

			this.equipEffect=new SwfLoader();
			this.addChild(this.equipEffect);

			this.equipEffect.x=165;
			this.equipEffect.y=258;

			this.equipEffect.mouseChildren=false;
			this.equipEffect.mouseEnabled=false;

//			bgsp=new Sprite();
//			bgsp.graphics.beginFill(0x000000);
//			bgsp.graphics.drawRect(0, 0, 143, 307);
//			bgsp.graphics.endFill();
//			
//			this.addChild(bgsp);
//			
//			bgsp.x=80;
//			bgsp.y=110;
//			bgsp.alpha=0;

//			bgsp.addEventListener(MouseEvent.CLICK, onEffClick);

			this.marryBtn.visible=false;

			this.addChild(this.wardrobeBtn);
			this.addChild(this.marryBtn);
//			this.addChild(this.marryiconImgbg);
//			this.addChild(this.marryiconImg);

			this.marryiconImgSwf=new SwfLoader();
			this.addChild(this.marryiconImgSwf);

			this.marryiconImgSwf.x=this.marryiconImg.x;
			this.marryiconImgSwf.y=this.marryiconImg.y;

			this.marryiconImgSwf.visible=false;

			this.img1SSwf=new Sprite();
			this.img1SSwf.graphics.beginFill(0x000000);
			this.img1SSwf.graphics.drawRect(0, 0, 40, 40);
			this.img1SSwf.graphics.endFill();

			this.addChild(this.img1SSwf);

			this.img1SSwf.alpha=0;

			this.img1SSwf.x=this.marryiconImg.x;
			this.img1SSwf.y=this.marryiconImg.y;

			this.img1SSwf.addEventListener(MouseEvent.MOUSE_OVER, onTipsMouseOver);
			this.img1SSwf.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut);

			this.tipinfo=new TipsInfo();
			//			this.scrollRect=new Rectangle(-256, 0, 745, 524);
		}

		private function onTipsMouseOver(e:MouseEvent):void {
			if (this.marryName != null)
				ToolTipManager.getInstance().show(TipEnum.TYPE_MARRY, this.tipinfo, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateMarryInfo(o:Object):void {

			if (o.hasOwnProperty("marry_name")) {
				this.marryName=o.marry_name;
				var info:TMarry_ring=TableManager.getInstance().getMarryRingByid(o.mtype);
				this.marryiconImg.updateBmp("ico/items/" + info.Ring_Pic);
				this.marryiconImg.setWH(40, 40);

				this.marryiconImgSwf.update(info.Ring_Eff);
				this.marryiconImgSwf.visible=true;

				this.tipinfo.itemid=o.mtype;
				this.tipinfo.zf=o.mmd_l;
				this.tipinfo.qh=o.m_ring;

				this.img1SSwf.visible=true;


			} else {
				this.marryiconImg.fillEmptyBmd();
				this.marryiconImgSwf.visible=false;
				this.marryName=null;

				this.img1SSwf.visible=false;
			}

			this.roleEquipUp.setCpName(this.marryName);
		}

		private function onEffClick(e:MouseEvent):void {
			this.bigAvatar.showII(Core.me.info.featureInfo, true, Core.me.info.profession);
		}

		private function onMouseMove(e:MouseEvent):void {

			if (e.target is PropertyNum || e.target is EquipGrid || e.target is RoleEquipUpWnd) {


				e.stopImmediatePropagation();
				e.stopPropagation();
				e.preventDefault();

				if (e.target is PropertyNum) {

					this.setChildIndex(this.marryiconImgbg, 3);
					this.setChildIndex(this.marryiconImg, 4);
					this.setChildIndex(this.marryiconImgSwf, 5);
//					this.setChildIndex(this.equipBackEffect, 11);

					this.setChildIndex(this.propertyNum, 14);
					this.setChildIndex(this.roleEquipUp, 12);
					this.setChildIndex(this.bigAvatar, 13);

				} else {

					if (e.target is EquipGrid || e.target is RoleEquipUpWnd) {

						this.addChild(this.marryiconImgbg);
						this.addChild(this.marryiconImg);
						this.addChild(this.marryiconImgSwf);

						this.setChildIndex(this.propertyNum, 6);
						this.setChildIndex(this.roleEquipUp, 8);
						this.setChildIndex(this.bigAvatar, 7);

					} else {

						this.setChildIndex(this.propertyNum, 6);
						this.setChildIndex(this.roleEquipUp, 7);
						this.setChildIndex(this.bigAvatar, 8);


//				this.addChild(this.lvImg);
//				this.addChild(this.qulityImg);

//				this.addChild(this.marryiconImgbg);
//				this.addChild(this.marryiconImg);

					}
				}
			}

		}

		private function onMouseOut(e:MouseEvent):void {

			this.setChildIndex(this.propertyNum, 6);
			this.setChildIndex(this.roleEquipUp, 7);
			this.setChildIndex(this.bigAvatar, 8);
		}

		public function showPanel(playName:String):void {

			this.roleTabBar.turnToTab(0);

			Cmd_Role.cm_role(playName);
			Cmd_Role.cm_equip(playName);

//			Cmd_Element.cm_ele_s(playName);
//			Cmd_Element.cm_ele_c(playName);

			Cmd_Gem.cmGemInit(playName);
			Cmd_Mount.cmMouInit(playName);
			Cmd_Wig.cm_WigInit(playName);
			Cmd_Marry.cmMarryInit(playName);
			Cmd_Longz.cm_Longz_H(playName);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.roleTabBar.setTabVisible(1, false);
			this.roleTabBar.setTabVisible(2, false);
			this.roleTabBar.setTabVisible(3, false);
			this.roleTabBar.setTabVisible(4, false);
			this.roleTabBar.setTabVisible(5, false);
			this.roleTabBar.setTabVisible(6, false);

//			Cmd_Role.cm_role();
//			Cmd_Role.cm_equip();
//			
//			Cmd_Element.cm_ele_s();
//			Cmd_Element.cm_ele_c();
//			
//			Cmd_Mount.cmMouInit();
//			Cmd_Wig.cm_WigInit();

//			this.updateWingEffect(this.roleEquipUp.currentEquip);
//			this.updateWingEffect([99933, 99935]);

		}


		private function onTabBarChangeIndex(evt:Event):void {

//			if (this.roleTabBar.turnOnIndex == 3) {
//				Cmd_Wig.cm_WigInit(this.playName);
//			} else {
//			}
//			
//			if (this.roleTabBar.turnOnIndex == 2) {
//				Cmd_Mount.cmMouInit(playName);
//			} else {
//				UIManager.getInstance().mountLvUpwnd.hide();
//				UIManager.getInstance().mountTradeWnd.hide();
//			}

//			if (this.roleTabBar.turnOnIndex == 1) {
//				if (this.elementFlag == false) {
//					Cmd_Element.cm_ele_s();
//					Cmd_Element.cm_ele_c();
//					this.elementFlag=true;
//				}
//				
//			}

			if (this.roleTabBar.turnOnIndex == 6) {

//				Cmd_Wig.cm_WigInit();
				this.wingAvatar.visible=true;
				this.wingWnd.wingNameImg.visible=true;

			} else {

				if (UIManager.getInstance().wingLvUpWnd.visible)
					UIManager.getInstance().hideWindow(WindowEnum.WINGLVUP);

				this.wingAvatar.visible=false;
				this.wingWnd.wingNameImg.visible=false;
			}

			if (this.roleTabBar.turnOnIndex == 0) {
//				Cmd_Role.cm_role();
//				Cmd_Role.cm_equip();
//				this.bigAvatar.showII(Core.me.info.featureInfo);
				this.bigAvatar.visible=true;

				this.roleEquipUp.visible=true;
				this.propertyNum.visible=true;

//				this.updateWingEffect(this.roleEquipUp.currentEquip);

//				this.bgsp.visible=true;
				this.marryBtn.visible=false;
				this.marryiconImg.visible=true;
				this.marryiconImgSwf.visible=true;
				this.img1SSwf.visible=true;
				this.marryiconImgbg.visible=true;

				this.wardrobeBtn.visible=false;
				this.lvImg.visible=true;
				this.qulityImg.visible=true;

				if (this.ava9 != 0) {

					var pid:int=int(ava9) + 5;

					var pinfo:TPnfInfo=TableManager.getInstance().getPnfInfo(pid);

					if (pinfo.type == 10) {
						this.setBackEffect(pid);
					} else if (pinfo.type == 3) {
						this.setEffect(pid);
					}
				}

			} else {

				this.wardrobeBtn.visible=false;
				this.lvImg.visible=false;
				this.qulityImg.visible=false;

				this.marryBtn.visible=false;
				this.marryiconImg.visible=false;
				this.marryiconImgbg.visible=false;
				this.marryiconImgSwf.visible=false;
				this.img1SSwf.visible=false;

//				this.bgsp.visible=false;

				this.bigAvatar.visible=false;
				this.roleEquipUp.visible=false;
				this.propertyNum.visible=false;

				this.equipBackEffect.visible=false;
				this.equipEffect.visible=false;
			}



		}


		/**
		 *更新人物信息
		 * @param info
		 *
		 */
		public function updateInfo(info:RoleInfo):void {
			this.info=info;
			this.rolePropertyWnd.updateInfo(info);
			this.roleEquipUp.updateInfo(info);
			this.propertyNum.updateInfo(info);
			this.showAvatar(info);
		}

		public function showAvatar(info:RoleInfo):void {

			var avtArr:Array=info.avt.split(",");

			this.feachInfo.clear();
			this.feachInfo.mount=avtArr[4];

			if (this.feachInfo.mount == 0) {
				this.feachInfo.weapon=PnfUtil.realAvtId(avtArr[1], false, info.sex);
				this.feachInfo.suit=PnfUtil.realAvtId(avtArr[2], false, info.sex);
				this.feachInfo.wing=PnfUtil.realWingId(avtArr[3], false, info.sex, info.race);

			} else {
				this.feachInfo.mountWeapon=PnfUtil.realAvtId(avtArr[1], true, info.sex);
				this.feachInfo.mountSuit=PnfUtil.realAvtId(avtArr[2], true, info.sex);
				this.feachInfo.mountWing=PnfUtil.realWingId(avtArr[3], true, info.sex, info.race);
				this.feachInfo.autoNormalInfo(true, info.race, info.sex);
			}

			this.bigAvatar.showII(this.feachInfo, false, info.race);

			this.ava9=avtArr[9];
			if (int(avtArr[9]) == 0)
				return;

			var pid:int=int(avtArr[9]) + 5;

			var pinfo:TPnfInfo=TableManager.getInstance().getPnfInfo(pid);

			if (pinfo.type == 10) {
				this.setBackEffect(pid);
			} else if (pinfo.type == 3) {
				this.setEffect(pid);
			}

		}

		public function setBackEffect(pid:int):void {
			this.equipEffect.visible=false;

			this.equipBackEffect.visible=true;
			this.equipBackEffect.update(pid, play1);

			function play1():void {
				equipBackEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
			}

		}

		/**
		 * 身上特效
		 * @param pid
		 *
		 */
		public function setEffect(pid:int):void {
			this.equipBackEffect.visible=false;

			this.equipEffect.visible=true;
			this.equipEffect.update(pid, play2);

			function play2():void {
				equipEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
			}

		}

		public function updateWingAvatar(pnfid:int):void {
//			var pnid:int=38000 + (pnfid - 1);
			this.wingAvatar.update(pnfid);
		}

		/**
		 *更新装备信息
		 *
		 */
		public function updateEquip():void {
			this.roleEquipUp.updateEquip(this.otherPlayer)
			this.updateWingEffect(this.roleEquipUp.currentEquip);
		}

		/**
		 *删除装备
		 * @param pos
		 *
		 */
		public function deleteEquip(pos:int):void {
			this.roleEquipUp.deleteEquip(pos);
			this.updateWingEffect(this.roleEquipUp.currentEquip);
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

		public function updatemountEquip(o:Array):void {
			this.mountWnd.updateEquipSlot(o);

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
			if (ConfigEnum.Gem1 <= this.info.lv) {
				this.roleTabBar.setTabVisible(2, true);
				this.gemWnd.updateInfo(o);
			} else
				this.roleTabBar.setTabVisible(2, false);

		}

		/**
		 *更新守护元素信息
		 * @param info
		 *
		 */
		public function updateGuildElement(info:ElementInfo):void {
			if (ConfigEnum.ElementOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(3, true);
				this.elementWnd.updateGuildElement(info);
			} else
				this.roleTabBar.setTabVisible(3, false);
		}

		public function updateMount(o:Object):void {
			//			trace(ConfigEnum.MountOpenLv, Core.me.info.level)
			if (ConfigEnum.MountOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(1, true);
				this.mountWnd.updateData(o);
				UIManager.getInstance().toolsWnd.mountBtn.setActive(true);
			} else {
				this.roleTabBar.setTabVisible(1, false);
				UIManager.getInstance().toolsWnd.mountBtn.setActive(false);
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
			if (o.hasOwnProperty("lv") && this.info.lv >= ConfigEnum.WingOpenLv) {
				this.wingWnd.updateInfo(o);
				this.roleTabBar.setTabVisible(6, true);
			} else {
				this.roleTabBar.setTabVisible(6, false);
			}
		}

		/**
		 *上下坐骑
		 *
		 */
		public function mountUpAndDown():void {
			this.mountWnd.UpAndDownMount();
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
		 *更新称号列表
		 * @param o
		 *
		 */
		public function updateTitleList(o:Object):void {
			if (ConfigEnum.NckOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(4, true);
//				this.titleWnd.updateInfo(o);
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
			this.bigAvatar.showII(Core.me.info.featureInfo);
		}

		override public function hide():void {
			super.hide();
			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;
		}

		public function updateWingEffect(pid:Array):void {
			return;
			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;

			if (pid[0] != -1) {

				this.equipBackEffect.visible=true;
				this.equipBackEffect.update(pid[0], play1);

				function play1():void {
					if (visible)
						equipBackEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}

			}

			if (pid[1] != -1) {

				this.equipEffect.visible=true;
				this.equipEffect.update(pid[1], play2);

				function play2():void {
					if (visible)
						equipEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}
			}

			this.equipBackEffect.x=160;
			this.equipBackEffect.y=408;

			this.equipEffect.x=155;
			this.equipEffect.y=248;
		}

		public function resise():void {
			//			if (UIManager.getInstance().isCreate(WindowEnum.MOUTLVUP) && UIManager.getInstance().mountLvUpwnd.visible && UIManager.getInstance().isCreate(WindowEnum.MOUTTRADEUP) && UIManager.getInstance().mountTradeWnd.visible && UIManager.getInstance().isCreate(WindowEnum.WINGLVUP) && UIManager.getInstance().wingLvUpWnd.visible) {
			//				return ;
			//			} else {

//			if (UIManager.getInstance().mountLvUpwnd.visible && UIManager.getInstance().mountTradeWnd.visible && UIManager.getInstance().wingLvUpWnd.visible) {
//				this.x=(UIEnum.WIDTH - this.width) / 2;
//				this.y=(UIEnum.HEIGHT - this.height) / 2;
//			}

			//			}
		}


		override public function get width():Number {
			return 489;
		}

		override public function get height():Number {
			return 524;
		}

	}
}

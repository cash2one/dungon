package com.leyou.ui.arena.childs {

	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.Living;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.game.scene.ui.child.BaseLiving;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.Font;

	public class ArenaRender extends AutoSprite {

		private var powerLbl:Label;
		private var integralLbl:Label;
		private var iconImg:Image;
		private var integralImg:Image;

		private var feachInfo:FeatureInfo;

		private var living:Living;
		private var livimgUI:BaseLiving;
		private var bigAvatar:BigAvatar;

		private var pkStateImg:Image;

		public var pkImgBtn:ImgButton;

		private var _index:int=0;

		public var arenaspr:Sprite;

		public var pkLbl:Label;
		public var titleNameLbl:Label;

		private var mName:String;
		private var mtitleid:int;
		private var mintegral:int=0;

		public var isTop3:Boolean=false;

		public function ArenaRender() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.powerLbl=this.getUIbyID("powerLbl") as Label;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.integralImg=this.getUIbyID("integralImg") as Image;

			this.pkStateImg=new Image("ui/arena/arena_dead.png");
			this.addChild(this.pkStateImg);

			this.pkStateImg.x=20;
			this.pkStateImg.y=-160;

			this.feachInfo=new FeatureInfo();

			this.living=new Living();
			living.initData(LivingInfo.getDefaultInfo(PlayerEnum.RACE_HUMAN), null, false);

//			this.living.mouseChildren=true;
//			this.living.mouseEnabled=true;

			this.livimgUI=new BaseLiving();

			this.bigAvatar=new BigAvatar();
			this.addChild(bigAvatar);

			this.bigAvatar.x=100;
			this.bigAvatar.y=100;

			arenaspr=new Sprite();
			arenaspr.graphics.beginFill(0x000000);
			arenaspr.graphics.drawRect(0, 0, 100, 200);
			arenaspr.graphics.endFill();

			this.addChild(arenaspr);

			arenaspr.alpha=0;

			arenaspr.x=this.width - arenaspr.width >> 1;
			arenaspr.y=(this.height - arenaspr.height >> 1) - 300;

			this.pkImgBtn=new ImgButton("ui/message/message_jjc.png");
			this.addChild(this.pkImgBtn);
			this.pkImgBtn.x=55;
			this.pkImgBtn.y=-95;

			this.pkImgBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.pkImgBtn.visible=false;

			this.pkLbl=new Label();
			this.addChild(this.pkLbl);

			this.addEventListener(Event.ADDED_TO_STAGE, onStage);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.iconImg, einfo);

			this.titleNameLbl=new Label("");
			this.titleNameLbl.defaultTextFormat=FontEnum.getTextFormat("Yellow14Center");

		}


		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, this.mName, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onStage(e:Event):void {
			UIManager.getInstance().arenaWnd.addChildAt(this.living, 3);
			UIManager.getInstance().arenaWnd.addChildAt(this.livimgUI, 3);
			UIManager.getInstance().arenaWnd.addChild(this.titleNameLbl);

			this.livimgUI.x=this.x;
			this.livimgUI.y=this.y - 50;

			this.titleNameLbl.x=this.livimgUI.x + 15;
			this.titleNameLbl.y=this.livimgUI.y + 10;

			UIManager.getInstance().arenaWnd.reAddchild();

			if (this.isTop3)
				this.living.visible=false;
		}

		public function reAddchild():void {
			UIManager.getInstance().arenaWnd.chalAddchild(this.living);
			UIManager.getInstance().arenaWnd.chalAddchild(this.livimgUI);
			UIManager.getInstance().arenaWnd.chalAddchild(this.titleNameLbl);

			this.livimgUI.x=this.x;
			this.livimgUI.y=this.y - 50;

//			this.titleNameLbl.x=this.livimgUI.x + 15;
			this.titleNameLbl.x=this.livimgUI.x + (134 - this.titleNameLbl.width) / 2;
			this.titleNameLbl.y=this.livimgUI.y + 10;

			if (this.isTop3)
				this.living.visible=false;
		}

		private function onMouseOver(e:MouseEvent):void {
			this.PkBtn=true;
		}

		private function onMouseOut(e:MouseEvent):void {
			this.PkBtn=false;
		}

		public function set PkBtn(v:Boolean):void {

			if (this.pkStateImg.visible) {

				this.pkImgBtn.visible=false;

				if (v) {
					this.pkLbl.text=PropUtils.getStringById(1602);
					this.pkLbl.textColor=0xffffff;
					pkLbl.x=this.width - pkLbl.width + 20 >> 1;
					this.pkLbl.y=-130;
				} else {
					this.pkLbl.text="";
				}

			} else {

				this.pkImgBtn.visible=v;
				this.pkLbl.text="";

				if (v) {
					this.living.onOver();
				} else {
					this.living.cancelOver();
				}

			}

		}

		private function onClick(e:MouseEvent):void {

//			if (UIManager.getInstance().arenaWnd.lastPkCount > 0) 
//				this.setPkState(false);

			if (this.isTop3) {
//				Cmd_Arena.cm_ArenaPkPlayer(this.index);
				var str:String=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10170).content,[ConfigEnum.Miliyary3.split("|")[0]]);
//				var str:String=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10170).content,[2]);
				PopupManager.showConfirm(str, function():void {
					Cmd_Arena.cm_ArenaPkTop3(index + 1);
				},null,false,"arenaTop3");
			} else{
				Cmd_Arena.cm_ArenaPkPlayer(this.index);
				GuideManager.getInstance().removeGuide(33);
			}
		}

		public function setPkState(v:Boolean):void {
			if (v)
				this.pkImgBtn.setActive(true, 1, true);
			else
				this.pkImgBtn.setActive(false, .6, true);
		}

		public function setPowerTxt(s:String):void {
			this.powerLbl.text=s + "";
		}

		public function setIntegralTxt(s:String):void {
			this.integralLbl.text=s + "";
		}

		/**
		 *	-- name    名字
		   -- level   等级
		   -- school  职业
		   -- gender  性别
		   -- zdl     战斗力
		   -- jxlevel 军衔等级
		   -- gscore  胜利可获得积分
		   -- avt     玩家avt形象字符串
		   -- jstate  挑战状态 (0未挑战, 1挑战胜利 ,2挑战失败)
		 *
		 */
		public function updateInfo(o:Array):void {

			var minfo:XML;
			var item:XML=LibManager.getInstance().getXML("config/table/Miliyary_Rank.xml");

			for each (minfo in item.data) {
				if (minfo.@MR_Level == o[5]) {
					mintegral=minfo.@MR_Integral;
					mtitleid=minfo.@MR_Title;
					break;
				}
			}

			this.powerLbl.text="" + o[4];
			this.integralLbl.text="" + o[6];
			this.mName="" + minfo.@MR_Name;

			if (o[5] == 10) {
				this.iconImg.updateBmp("ui/arena/arena_10.png");
			} else {
				this.iconImg.updateBmp("ui/arena/arena_0" + o[5] + ".png");
			}

			this.showTitle(o);
			this.showAvatar(o);

//			this.livimgUI.updataPs(this.living);

			if (o[7] == 0) {
				this.living.visible=true;
//				this.livimgUI.visible=true;
				this.pkStateImg.visible=false;
				this.integralImg.visible=true;
			} else {
				this.pkStateImg.visible=true;
				this.living.visible=false;

				this.integralImg.visible=false;
				this.integralLbl.text="";

//				this.livimgUI.visible=false;
			}

			this.PkBtn=false;
		}

		public function showAvatar(u:Array):void {

			var avtArr:Array=u[8].split(",");

			this.feachInfo.mount=avtArr[4];

//			if (this.feachInfo.mount == 0) {

			this.living.info.isOnMount=false;
			this.feachInfo.weapon=PnfUtil.realAvtId(avtArr[1], false, u[3]);
			this.feachInfo.suit=PnfUtil.realAvtId(avtArr[2], false, u[3]);
			this.feachInfo.wing=PnfUtil.realWingId(avtArr[3], false, u[3], u[2]);

//			} else {
//
//				this.living.info.isOnMount=true;
//				this.feachInfo.mountWeapon=PnfUtil.realAvtId(avtArr[1], true, u[3]);
//				this.feachInfo.mountSuit=PnfUtil.realAvtId(avtArr[2], true, u[3]);
//				this.feachInfo.mountWing=PnfUtil.realWingId(avtArr[3], true, u[3], u[2]);
//				this.feachInfo.autoNormalInfo(true, u[2], u[3]);
//
//			}

			if (this.isTop3)
				this.bigAvatar.showII(this.feachInfo, false, u[2]);
			else {
				this.living.changeAvatars(this.feachInfo, true);
				this.living.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S);
			}
		}

		private function showTitle(u:Array):void {
//				-- name    名字
//				-- level   等级
//				-- school  职业
//				-- gender  性别

			this.living.info.name="" + u[0];
			this.living.info.level=u[1];
			this.living.info.profession=u[2];
			this.living.info.sex=u[3];

			if (u[9] == 0)
				this.titleNameLbl.htmlText="" + PropUtils.getStringById(101402);
			else
				this.titleNameLbl.htmlText=PropUtils.getStringById(101403) + ":" + u[9];

//			if (this.isTop3)
//				this.titleNameLbl.x=this.livimgUI.x + (204 - this.titleNameLbl.width) / 2;
//			else
			this.titleNameLbl.x=this.livimgUI.x + (134 - this.titleNameLbl.width) / 2;

			this.livimgUI.showName(this.living.info);
//			this.livimgUI.x=this.x+(this.living.width-this.livimgUI.width)>>1;
		}

		public function set index(v:int):void {
			this._index=v;

			switch (v) {
				case 1:
					this.living.y=300;
					this.living.x=135;
					this.pkImgBtn.x=50;
					break;
				case 2:
					this.living.y=335;
					this.living.x=270;
					this.pkImgBtn.x=50;
					break;
				case 3:
					this.living.y=290;
					this.living.x=420;
					this.pkImgBtn.x=55;
					break;
				case 4:
					this.living.y=350;
					this.living.x=565;
					this.pkImgBtn.x=45;
					break;
				case 5:
					this.living.y=300;
					this.living.x=705;
					this.pkImgBtn.x=45;
					break;
			}

		}

		public function setChalPos(i:int):void {

			switch (i) {
				case 0:
					this.living.y=350;
					this.living.x=190;

					this.bigAvatar.y=-44
					this.bigAvatar.x=70
					this.pkImgBtn.x=45;
					this.pkImgBtn.y=-145;
					break;
				case 1:
					this.living.y=300;
					this.living.x=400;

					this.bigAvatar.y=-47
					this.bigAvatar.x=60
					this.pkImgBtn.x=45;
					this.pkImgBtn.y=-145;
					break;
				case 2:
					this.living.y=350;
					this.living.x=660;

					this.bigAvatar.y=-44
					this.bigAvatar.x=70
					this.pkImgBtn.x=45;
					this.pkImgBtn.y=-145;
					break;
			}

		}

		public function get index():int {
			return this._index;
		}

	}
}

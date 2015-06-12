package com.leyou.ui.mount {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.effect.StarChangeEffect;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TMount;
	import com.ace.gameData.table.TMountLv;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.ui.loading.LoadingRen;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MountWnd extends AutoSprite {

		private var domesticate:NormalButton;
		private var evolutionBtn:NormalButton;

		private var rightImgBtn:ImgButton;
		private var leftImgBtn:ImgButton;

		private var getOnMountBtn:ImgLabelButton;

		private var fightKeyLbl:Label;
		private var fightAddkeyLbl:Label;
		private var phAttLbl:Label;
		private var phAttAddLbl:Label;
		private var magicAttAddLbl:Label;
		private var phDefAddLbl:Label;
		private var magicDefAddLbl:Label;
		private var hpAddLbl:Label;
		private var mpAddLbl:Label;
		private var critLvAddLbl:Label;
		private var toughLvAddLbl:Label;
		private var hitLvAddLbl:Label;
		private var dodgeLvAddLbl:Label;
		private var killLvAddLbl:Label;
		private var guaidLvAddLbl:Label;
		private var moveSpeedAddLbl:Label;
		private var magicAttLbl:Label;
		private var phDefLbl:Label;
		private var magicDefLbl:Label;
		private var hpLbl:Label;
		private var mpLbl:Label;
		private var critLvLbl:Label;
		private var toughLvLbl:Label;
		private var hitLvLbl:Label;
		private var dodgeLvLbl:Label;
		private var killLvLbl:Label;
		private var guaidLvLbl:Label;
		private var moveSpeedLbl:Label;
		private var arrow1Img:Image;
		private var arrow2Img:Image;
		private var tipImg:Image;

		private var effbg:SwfLoader;

		private var lvLbl:Label;
		private var lvprogress:ScaleBitmap;

//		private var fightBD:Bitmap;
		private var rollPower:RollNumWidget;

		private var mountNameImg:Image;
		private var jieImg:Image;

		private var effectBg:SwfLoader;

		private var mountNameImgArr:Vector.<Image>;
		private var jieImgArr:Vector.<Image>;
		private var jieNum:int;
		private var pageCount:int=10;

		/**
		 *当前使用的坐骑
		 */
		private var nid:int;

		/**
		 * 上一次的id
		 */
		private var pid:int;

		private var viewAddList:Array=[];
		private var viewList:Array=[];

		private var mount:TMount;

		/**
		 *晋级等级
		 */
		private var lv:int=0;

		/**
		 *进阶等级
		 */
		private var mlv:int=0;

		/**
		 * 上坐骑cd
		 */
		private var upToDownTime:int=0;

		private var otherPlaye:Boolean=false;

		private var swfTips:Sprite;

		/**
		 *进度条
		 */
		private var DownMountProgress:LoadingRen;

		private var propArrKey:Array=[4, 5, 8, 9, 10, 11, 12, 13, 21, 1, 2];
		private var propArrLbL:Array=[];

		private var figthEquipInfo:TEquipInfo;

		private var equipItemArr:Array=[];

		private var starEffect:StarChangeEffect;

		public function MountWnd(othePlayer:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/horseWnd.xml"));
			this.otherPlaye=othePlayer;
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.domesticate=this.getUIbyID("domesticate") as NormalButton;
			this.evolutionBtn=this.getUIbyID("evolutionBtn") as NormalButton;

			this.rightImgBtn=this.getUIbyID("rightImgBtn") as ImgButton;
			this.leftImgBtn=this.getUIbyID("leftImgBtn") as ImgButton;

			this.getOnMountBtn=this.getUIbyID("getOnMountBtn") as ImgLabelButton;

			this.fightKeyLbl=this.getUIbyID("fightKeyLbl") as Label;
			this.fightAddkeyLbl=this.getUIbyID("fightAddkeyLbl") as Label;

			this.phAttLbl=this.getUIbyID("phAttLbl") as Label;
			this.phAttAddLbl=this.getUIbyID("phAttAddLbl") as Label;
			this.magicAttAddLbl=this.getUIbyID("magicAttAddLbl") as Label;
			this.phDefAddLbl=this.getUIbyID("phDefAddLbl") as Label;
			this.magicDefAddLbl=this.getUIbyID("magicDefAddLbl") as Label;
			this.hpAddLbl=this.getUIbyID("hpAddLbl") as Label;
			this.mpAddLbl=this.getUIbyID("mpAddLbl") as Label;
			this.critLvAddLbl=this.getUIbyID("critLvAddLbl") as Label;
			this.toughLvAddLbl=this.getUIbyID("toughLvAddLbl") as Label;
			this.hitLvAddLbl=this.getUIbyID("hitLvAddLbl") as Label;
			this.dodgeLvAddLbl=this.getUIbyID("dodgeLvAddLbl") as Label;
			this.killLvAddLbl=this.getUIbyID("killLvAddLbl") as Label;
			this.guaidLvAddLbl=this.getUIbyID("guaidLvAddLbl") as Label;
			this.moveSpeedAddLbl=this.getUIbyID("moveSpeedAddLbl") as Label;
			this.magicAttLbl=this.getUIbyID("magicAttLbl") as Label;
			this.phDefLbl=this.getUIbyID("phDefLbl") as Label;
			this.magicDefLbl=this.getUIbyID("magicDefLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;
			this.critLvLbl=this.getUIbyID("critLvLbl") as Label;
			this.toughLvLbl=this.getUIbyID("toughLvLbl") as Label;
			this.hitLvLbl=this.getUIbyID("hitLvLbl") as Label;
			this.dodgeLvLbl=this.getUIbyID("dodgeLvLbl") as Label;
			this.killLvLbl=this.getUIbyID("killLvLbl") as Label;
			this.guaidLvLbl=this.getUIbyID("guaidLvLbl") as Label;
			this.moveSpeedLbl=this.getUIbyID("moveSpeedLbl") as Label;
			this.arrow1Img=this.getUIbyID("arrow1Img") as Image;
			this.arrow2Img=this.getUIbyID("arrow2Img") as Image;
			this.tipImg=this.getUIbyID("tipImg") as Image;
			this.effbg=this.getUIbyID("effbg") as SwfLoader;

			this.lvprogress=this.getUIbyID("lvprogress") as ScaleBitmap;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;

			this.effbg.scrollRect=new Rectangle(20, 145, 454, 446);

			this.effectBg=new SwfLoader();
			this.addChild(this.effectBg);
			this.effectBg.mouseChildren=false;
			this.effectBg.mouseEnabled=false;

			this.effectBg.x=140;
			this.effectBg.y=290;

			this.mountNameImg=this.getUIbyID("mountNameImg") as Image;
			this.jieImg=this.getUIbyID("jieImg") as Image;

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=this.fightKeyLbl.x;
			this.rollPower.y=this.fightKeyLbl.y + 10;

//			this.rollPower.visibleOfBg=false;
			this.rollPower.alignCenter();

			this.mountNameImgArr=new Vector.<Image>;
			this.jieImgArr=new Vector.<Image>;

			this.viewAddList.push(this.phAttAddLbl);
			this.viewAddList.push(this.phDefAddLbl);
//			this.viewAddList.push(this.magicAttAddLbl);
//			this.viewAddList.push(this.magicDefAddLbl);
			this.viewAddList.push(this.hpAddLbl);
			this.viewAddList.push(this.mpAddLbl);
			this.viewAddList.push(this.critLvAddLbl);
			this.viewAddList.push(this.hitLvAddLbl);
			this.viewAddList.push(this.dodgeLvAddLbl);
			this.viewAddList.push(this.toughLvAddLbl);
			this.viewAddList.push(this.guaidLvAddLbl);
//			this.viewAddList.push(this.moveSpeedAddLbl);
			this.viewAddList.push(this.killLvAddLbl);

			for (var i:int=0; i < 10; i++) {
				this.mountNameImgArr.push(new Image("ui/horse/horse_lv" + (i + 1) + "_name.png"));
				this.jieImgArr.push(new Image("ui/horse/horse_lv" + (i + 1) + ".png"));
			}

			this.equipItemArr[0]=new MountEquipGrid();
			this.equipItemArr[0].dataId=13;
			this.addChild(this.equipItemArr[0]);
			this.equipItemArr[0].x=10;
			this.equipItemArr[0].y=57;

			this.equipItemArr[1]=new MountEquipGrid();
			this.equipItemArr[1].dataId=14;
			this.addChild(this.equipItemArr[1]);
			this.equipItemArr[1].x=211;
			this.equipItemArr[1].y=57;

			this.equipItemArr[2]=new MountEquipGrid();
			this.equipItemArr[2].dataId=15;
			this.addChild(this.equipItemArr[2]);
			this.equipItemArr[2].x=10;
			this.equipItemArr[2].y=279;

			this.equipItemArr[3]=new MountEquipGrid();
			this.equipItemArr[3].dataId=16;
			this.addChild(this.equipItemArr[3]);
			this.equipItemArr[3].x=211;
			this.equipItemArr[3].y=279;

			this.equipItemArr[0].doubleClickEnabled=!otherPlaye;
			this.equipItemArr[1].doubleClickEnabled=!otherPlaye;
			this.equipItemArr[2].doubleClickEnabled=!otherPlaye;
			this.equipItemArr[3].doubleClickEnabled=!otherPlaye;

			if (!otherPlaye) {
				this.domesticate.addEventListener(MouseEvent.CLICK, onBtnCLick);
				this.evolutionBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);
				this.evolutionBtn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
				this.evolutionBtn.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);

				this.rightImgBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);
				this.leftImgBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);

				this.getOnMountBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);

			} else {

				this.getOnMountBtn.visible=false;
				this.rightImgBtn.visible=false;
				this.leftImgBtn.visible=false;
				this.evolutionBtn.visible=false;
				this.domesticate.visible=false;
				this.arrow1Img.visible=false;
				this.arrow2Img.visible=false;
			}

			this.setPropAddVisible(false);

//			this.bigAvatar=new BigAvatar();
//			this.bigAvatar.x=126;
//			this.bigAvatar.y=331;
//			this.addChild(this.bigAvatar);

//			this.featchInfo=new FeatureInfo();

			this.evolutionBtn.setToolTip(TableManager.getInstance().getSystemNotice(1117).content);

//			this.openTrade();

			this.DownMountProgress=new LoadingRen();
			LayerManager.getInstance().windowLayer.addChild(this.DownMountProgress);

			var lb:Label;
			for (i=0; i < this.propArrKey.length; i++) {
				lb=this.getUIbyID("txt" + this.propArrKey[i]) as Label;
				if (lb != null) {
					if (this.propArrKey[i] == 2) {
						lb.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content, [ConfigEnum.manaRevive]));
					} else
						lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content);
				}
			}

			this.starEffect=new StarChangeEffect(10, true);
			this.addChild(this.starEffect);
			this.starEffect.x=35;
			this.starEffect.y=3;

			this.swfTips=new Sprite();
			this.swfTips.graphics.beginFill(0x000000);
			this.swfTips.graphics.drawRect(0, 0, 200, 200);
			this.swfTips.graphics.endFill();

			this.addChild(this.swfTips);

			this.swfTips.x=40;
			this.swfTips.y=100;

			this.swfTips.alpha=0;
			this.swfTips.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			this.swfTips.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.figthEquipInfo=new TEquipInfo();

			this.y=1;
			this.x=-12;
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1146).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onMouseOver(e:MouseEvent):void {
//			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1119 + this.jieNum).content, new Point(e.stageX, e.stageY));
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1119 + this.jieNum).content, new Point(100, 100));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		/*按钮点击*/
		private function onBtnCLick(evt:MouseEvent):void {

			switch (evt.target.name) {
				case "domesticate":

					UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);
//					UIManager.getInstance().mountTradeWnd.open(); //驯养
					UIManager.getInstance().mountLvUpwnd.hide();
					if (UIManager.getInstance().mountTradeWnd.isShow) {
						UIManager.getInstance().mountTradeWnd.hide();
					} else
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTTRADEUP, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);

					break;
				case "evolutionBtn":

					UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);
//					UIManager.getInstance().mountLvUpwnd.open(); //进阶
					UIManager.getInstance().mountTradeWnd.hide();
					if (UIManager.getInstance().mountLvUpwnd.isShow) {
						UIManager.getInstance().mountLvUpwnd.hide();
					} else
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);


					UIManager.getInstance().backpackWnd.setPlayGuideMountItem(3);
					break;
				case "rightImgBtn":
					this.jieNum++;

					if (this.jieNum >= this.pageCount - 1) {
						this.rightImgBtn.visible=false;
					}

					this.leftImgBtn.visible=true;
					this.setMountImg(jieNum);
					break;
				case "leftImgBtn":

					this.jieNum--;
					if (this.jieNum <= 0) {
						this.leftImgBtn.visible=false;
					}

					this.rightImgBtn.visible=true;
					this.setMountImg(jieNum);
					break;
				case "getOnMountBtn":
					Core.me.onMount(); //必须调用
					if (this.getOnMountBtn.text.indexOf(PropUtils.getStringById(1808)) > -1)
						Cmd_Mount.cmMouUpOrDown();
					else {

//						var st:int=getTimer();
//						if ((st - upToDownTime) < 5000) {
//							return;
//						}
//
//						upToDownTime=st;

//						if (this.nid != 0) {
//							Cmd_Mount.cmMouUpOrDown();
//						}

						this.getOnMountBtn.setActive(false, .6, true);
//						this.jieNum=(this.lv - 1);
						this.setMountImg(this.jieNum);

//						this.DownMountProgress.resize();

//						this.DownMountProgress.startProgress(2, function():void {
//							Cmd_Mount.cmMouUpOrDown(jieNum + 1);
//							SoundManager.getInstance().play(10);
//						}, 1);

//						UIManager.getInstance().taskCollectProgress.startProgress(2000, function():void {
							Cmd_Mount.cmMouUpOrDown(jieNum + 1);
							SoundManager.getInstance().play(10);
//						}, 1);

					}
					break;
			}

		}


		public function updateEquipSlot(o:Array):void {

			var binfo:Baginfo;
			var i:int=0;

			if (this.otherPlaye) {

				for (i=0; i < 4; i++) {

					if (o[i] is Array) {
						this.equipItemArr[i].clearMe();
						continue;
					}

					binfo=new Baginfo();
					binfo.aid=o[i].id;

					binfo.tips=new TipsInfo(o[i].tips);
					binfo.info=TableManager.getInstance().getEquipInfo(binfo.tips.itemid);

					this.equipItemArr[i].updataInfo(binfo);
					this.equipItemArr[i].doubleClickEnabled=!otherPlaye;
				}
			} else {
				MyInfoManager.getInstance().mountEquipArr.length=0;

				for (i=0; i < 4; i++) {

					if (o[i] is Array) {
						MyInfoManager.getInstance().mountEquipArr[i]=null;
						this.equipItemArr[i].clearMe();
						continue;
					}

					binfo=new Baginfo();
					binfo.aid=o[i].id;

					binfo.tips=new TipsInfo(o[i].tips);
					binfo.info=TableManager.getInstance().getEquipInfo(binfo.tips.itemid);
					this.equipItemArr[i].updataInfo(binfo);

					MyInfoManager.getInstance().mountEquipArr.push(binfo);
				}

			}
		}


		public function UpAndDownMount():void {
			Core.me.onMount(); //必须调用
			if (ConfigEnum.MountOpenLv <= Core.me.info.level) {
				if (this.nid == this.pid && this.pid != 0)
					Cmd_Mount.cmMouUpOrDown();
				else {

//					var st:int=getTimer();
//					if ((st - upToDownTime) < 5000) {
//						return;
//					}
//
//					upToDownTime=st;

//					if (this.nid != 0) {
//						Cmd_Mount.cmMouUpOrDown();
//					}

					this.getOnMountBtn.setActive(false, .6, true);
					this.jieNum=(pid <= 0 ? 0 : pid - 1);
					this.setMountImg(this.jieNum);

//					this.DownMountProgress.resize();

//					UIManager.getInstance().taskCollectProgress.startProgress(2000, function():void {
//						trace(getTimer()-st,"---");
						Cmd_Mount.cmMouUpOrDown((pid));
						SoundManager.getInstance().play(10);
						GuideManager.getInstance().removeGuide(3);
//					}, 1);

				}
			}

		}

		/**
		 *停止上马进度
		 *
		 */
		public function stopDownMout():void {
			this.DownMountProgress.hide();
		}

		/*设置坐骑的图片*/
		private function setMountImg(jie:int):void {
			this.mountNameImg.bitmapData=this.mountNameImgArr[jie].bitmapData;
			this.jieImg.bitmapData=this.jieImgArr[jie].bitmapData;

			var pid:int=20500 + (jie + 1);

			if ((jie + 1) == 10)
				this.effectBg.update(pid);
			else
				this.effectBg.update(pid);

			this.effectBg.mouseChildren=this.effectBg.mouseEnabled=false;

			if ((jie + 1) == this.nid) {
				this.changeMountBtnState(1)
			} else {
				this.changeMountBtnState(0)
			}

			if ((jie + 1) > this.lv) {
				this.getOnMountBtn.setActive(false, .6, true);
				this.getOnMountBtn.setToolTip(TableManager.getInstance().getSystemNotice(1116).content);
			} else
				this.getOnMountBtn.setActive(true, 1, true);

		}

		private function onBtnOver(e:MouseEvent):void {
			this.setPropAddVisible(true);
		}

		private function onBtnOut(e:MouseEvent):void {
			this.setPropAddVisible(false);
		}

		public function changeMountState(o:Object):void {

			if (o.hasOwnProperty("nid"))
				this.nid=o.nid;

			if (o.hasOwnProperty("pid"))
				this.pid=o.pid;

			if (o.hasOwnProperty("rd"))
				this.changeMountBtnState(o.rd);

			if (this.nid > this.lv) {
				this.getOnMountBtn.setActive(false, .6, true);
				this.getOnMountBtn.setToolTip(TableManager.getInstance().getSystemNotice(1116).content);
			} else
				this.getOnMountBtn.setActive(true, 1, false);
		}

		/**
		 *驯养开启等级
		 *
		 */
		public function openTrade():void {

//			trace(ConfigEnum.MountTradeOpenLv,this.lv)
			if (ConfigEnum.MountTradeOpenLv <= this.lv) {
				this.domesticate.setActive(true, 1, true);
				this.domesticate.setToolTip(TableManager.getInstance().getSystemNotice(1118).content);
			} else {
				this.domesticate.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(1144).content, [ConfigEnum.MountTradeOpenLv]));
				this.domesticate.setActive(false, .6, true);
			}

		}

		/**
		 * 改变坐骑按钮状态
		 * @param rd
		 *
		 */
		public function changeMountBtnState(rd:int):void {

			if (rd == 0) {
				this.getOnMountBtn.text=PropUtils.getStringById(1810);
				this.getOnMountBtn.setToolTip(TableManager.getInstance().getSystemNotice(1114).content);
			} else {
				this.getOnMountBtn.text=PropUtils.getStringById(1811);
				this.getOnMountBtn.setToolTip(TableManager.getInstance().getSystemNotice(1115).content);
			}

			this.getOnMountBtn.setActive(true, 1, true);
		}

		public function updateData(o:Object):void {

			var upgrade:Boolean=false;

			if (o.hasOwnProperty("el")) {
				if (this.lv != o.el)
					upgrade=true;

				this.lv=o.el;
				this.pageCount=this.lv;
			}

			if (o.hasOwnProperty("nid")) {
				this.nid=o.nid;

				if (this.nid != 0) {
					this.jieNum=(o.nid == 0 ? 0 : o.nid - 1);
					this.setMountImg(this.jieNum);
				} else {
					this.jieNum=(o.el == 0 ? 0 : o.el - 1);
					this.setMountImg(this.jieNum);
				}

			}

			if (o.hasOwnProperty("pid")) {
				this.pid=o.pid;

				if (this.pid == 0)
					this.pid=this.lv;
			}

//			if (this.nid == 0) {
//				
//				if (upgrade) {
//					this.jieNum=(o.pid == 0 ? 0 : o.pid - 1);
//					this.setMountImg(this.jieNum);
//				} else {
//					this.jieNum=(o.pid == 0 ? 0 : o.pid - 1);
//					this.setMountImg(this.jieNum);
//				}
//			}

			if (this.jieNum == 0) {
				this.leftImgBtn.visible=false;
			} else
				this.leftImgBtn.visible=true;

			if (this.jieNum == this.pageCount - 1) {
				this.rightImgBtn.visible=false;
			} else
				this.rightImgBtn.visible=true;

//			var jt:int=this.jieNum;
//			jt++;
//			if (jt >= this.jieImgArr.length - 1 || jt >= this.lv - 1) {
//				this.rightImgBtn.visible=false;
//			} else {
//				this.rightImgBtn.visible=true;
//			}

			if (o.hasOwnProperty("rd"))
				this.changeMountBtnState(o.rd);

			if (o.hasOwnProperty("ep") && o.hasOwnProperty("mlv") && o.ep["cr"] > 0 && o.hasOwnProperty("dc")) {
				this.mlv=o.mlv;
				this.updatePropList(o);
			}

			if (o.hasOwnProperty("mlv"))
				this.starEffect.setStarPos(o.mlv % 10 - 1);

			if (o.hasOwnProperty("zdl")) {
				if (this.rollPower.number != o.zdl) {
					if (this.otherPlaye)
						this.rollPower.setNum(o.zdl);
					else
						this.rollPower.rollToNum(o.zdl);

					this.rollPower.x=270 - this.rollPower.width >> 1;
				}
			}

			this.openTrade();

			if (this.otherPlaye) {
				this.rightImgBtn.visible=false;
				this.leftImgBtn.visible=false;
				return;
			}

			if (this.mlv == 100) {
				this.arrow1Img.visible=false;
				this.evolutionBtn.setToolTip(TableManager.getInstance().getSystemNotice(1136).content);
				this.evolutionBtn.setActive(false, .6, true);
				
				this.starEffect.setStarPos(9);
			} else {
				this.evolutionBtn.setToolTip(TableManager.getInstance().getSystemNotice(1117).content);
				this.evolutionBtn.setActive(true, 1, true);
				this.arrow1Img.visible=true;

				UIManager.getInstance().mountLvUpwnd.updateInfo(mount, o);
			}

			UIManager.getInstance().mountTradeWnd.updateData(o);
		}

		public function updatePropList(o:Object):void {

			mount=TableManager.getInstance().getMountByLv(this.mlv);

//			this.lvLbl.text="" + this.mlv + "/" + mount.lvTop;
//			this.lvprogress.scaleX=int(this.mlv) / mount.lvTop;

			var mountlv:TMountLv=TableManager.getInstance().getMountLvByLv(this.mlv);
			var m1rate:Number=mount.proRate / 100;


			if (o.dc.hasOwnProperty("4")) {
//				this.phAttLbl.text="" + (this.getPropTradeValue(this.getPropValue(mountlv.p_attack, m1rate), o.dc[4].r) + this.getMountPropValue(4));
				this.phAttLbl.text="" + (mountlv.p_attack + this.getMountPropValue(4));
			}

			if (o.dc.hasOwnProperty("6")) {
//				this.magicAttLbl.text="" + (this.getPropTradeValue(this.getPropValue(mountlv.m_attack, m1rate), o.dc[6].r) + this.getMountPropValue(6));
//				this.magicAttLbl.text="" + (mountlv.m_attack + this.getMountPropValue(6));
			}

			if (o.dc.hasOwnProperty("5")) {
//				this.phDefLbl.text="" + (this.getPropTradeValue(this.getPropValue(mountlv.p_defense, m1rate), o.dc[5].r) + this.getMountPropValue(5));
				this.phDefLbl.text="" + (mountlv.p_defense + this.getMountPropValue(5));
			}

			if (o.dc.hasOwnProperty("7")) {
//				this.magicDefLbl.text="" + (mountlv.m_defense + this.getMountPropValue(7));
			}

			if (o.dc.hasOwnProperty("1")) {
				this.hpLbl.text="" + (mountlv.extraHp + this.getMountPropValue(1));
			}

			if (o.dc.hasOwnProperty("2")) {
				this.mpLbl.text=(mountlv.extraMp + this.getMountPropValue(2)) + "";
			}

			this.critLvLbl.text=(mountlv.crit + this.getMountPropValue(8)) + "";
			this.toughLvLbl.text=(mountlv.critReduce + this.getMountPropValue(9)) + "";
			this.hitLvLbl.text=(mountlv.hit + this.getMountPropValue(10)) + "";
			this.dodgeLvLbl.text=(mountlv.dodge + this.getMountPropValue(11)) + "";
			this.killLvLbl.text=(mountlv.critDam + this.getMountPropValue(12)) + "";
			this.guaidLvLbl.text=(mountlv.critDamReduce + this.getMountPropValue(13)) + "";
//			this.moveSpeedLbl.text=this.getPropValue(mountlv.speed, m1rate) + "";

			if (Core.me.info.level <= 100 && this.mlv < 100) {

				var m2:TMount=TableManager.getInstance().getMountByLv(this.mlv + 1);
				var m2lv:TMountLv;
//				if (Core.me.info.level < m2.lv)
//					m2lv=TableManager.getInstance().getMountLvByLv(Core.me.info.level);
//				else
				m2lv=TableManager.getInstance().getMountLvByLv(this.mlv + 1);

				if (m2lv == null)
					return;

				var m2rate:Number=m2.proRate / 100;

				//计算加成
				if (o.dc.hasOwnProperty("4"))
					this.phAttAddLbl.text="+" + (m2lv.p_attack - mountlv.p_attack) + "";

				if (o.dc.hasOwnProperty("5"))
					this.phDefAddLbl.text="+" + (m2lv.p_defense - mountlv.p_defense) + "";

//				if (o.dc.hasOwnProperty("6"))
//					this.magicAttAddLbl.text="+" + this.getPropTradeValue(this.getPropValue(m2lv.m_attack, m2rate) - this.getPropValue(mountlv.m_attack, m1rate), o.dc[6].r) + "";

//				if (o.dc.hasOwnProperty("7"))
//					this.magicDefAddLbl.text="+" + this.getPropTradeValue(this.getPropValue(m2lv.m_defense, m2rate) - this.getPropValue(mountlv.m_defense, m1rate), o.dc[7].r) + "";

				if (o.dc.hasOwnProperty("1"))
					this.hpAddLbl.text="+" + (m2lv.extraHp - mountlv.extraHp) + "";

				if (o.dc.hasOwnProperty("2"))
					this.mpAddLbl.text="+" + (m2lv.extraMp - mountlv.extraMp) + "";

				this.critLvAddLbl.text="+" + (m2lv.crit - mountlv.crit) + "";
				this.hitLvAddLbl.text="+" + (m2lv.hit - mountlv.hit) + "";
				this.dodgeLvAddLbl.text="+" + (m2lv.dodge - mountlv.dodge) + "";
				this.toughLvAddLbl.text="+" + (m2lv.critReduce - mountlv.critReduce) + "";
				this.guaidLvAddLbl.text="+" + (m2lv.critDamReduce - mountlv.critDamReduce) + "";
//				this.moveSpeedAddLbl.text="+" + (m2lv.speed - this.getPropValue(mountlv.speed, m1rate)) + "";
				this.killLvAddLbl.text="+" + (m2lv.critDam - mountlv.critDam) + "";

			} else {

				this.evolutionBtn.setActive(false, .6, true);

				if (UIManager.getInstance().mountLvUpwnd.visible)
					UIManager.getInstance().mountLvUpwnd.hide();
			}
		}

		/**
		 * 设置 显示/隐藏,属性加成
		 * @param v
		 *
		 */
		private function setPropAddVisible(v:Boolean):void {
			for (var i:int=0; i < this.viewAddList.length; i++) {
				this.viewAddList[i].visible=v;
			}
		}


		public function get Lv():int {
			return this.lv;
		}

		/**
		 *装备属性
		 * @param p
		 * @return
		 *
		 */
		public function getMountPropValue(p:int):int {

			var num:int=0;
			var arr:Array=MyInfoManager.getInstance().mountEquipArr;
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] != null) {

					if (arr[i].tips.p.hasOwnProperty(p))
						num+=int(arr[i].tips.p[p]);

					if (arr[i].tips.p.hasOwnProperty("qh_" + p))
						num+=int(arr[i].tips.p["qh_" + p]);

				}
			}

			return num;
		}

		/**
		 * 属性计算公式
		 * @param s 基础值
		 * @param r 比例
		 * @return
		 *
		 */
		private function getPropValue(s:int, r:Number):int {
			return Math.ceil(s * r);
		}

		private function getPropTradeValue(s:int, r:int):int {
			return Math.ceil(s + s * (r / 10000));
		}


	}
}

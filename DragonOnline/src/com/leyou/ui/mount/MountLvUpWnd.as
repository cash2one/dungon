package com.leyou.ui.mount {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.effect.StarChangeEffect;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMount;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.ui.role.child.children.ImgRolling;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class MountLvUpWnd extends AutoWindow {

//		private var proceTextArea:TextArea;

		private var up0CheckBox:RadioButton;
		private var up1CheckBox:RadioButton;
		private var up2CheckBox:RadioButton;

		private var autoUpBtn:ImgLabelButton;
		private var upBtn:ImgLabelButton;

		private var num0Sp:ImgRolling;
		private var num1Sp:ImgRolling;
		private var num2Sp:ImgRolling;

		private var needNumLbl:Label;
		private var moneyLbl:Label;

		private var proceTextArea:ScaleBitmap;
		private var lvProgress:Label;

		private var lvImg:Image;
		private var lvNameImg:Image;
		private var tipImg:Image;
		private var itemNameLbl:Label;
		private var radLbl:Label;

		private var goldImg:Image;
		private var imgArr:Vector.<Image>;
		private var starEffect:StarChangeEffect;

		private var checkBoxFlag:Vector.<Boolean>;
		private var info:TMount;

		private var f:Boolean; //测试用

		/**
		 * 进度
		 */
		public var ad:int=0;

		public var data:Object;

		private var lv:int=0;

		private var autoLv:int=0;

		private var autoTimeId:int=0;

		private var effectBg:SwfLoader;

		private var tipsinfo:TipsInfo;

		private var successEffect:SwfLoader;

		private var firstOpen:Boolean=true;

		private var swfTips:Sprite;

		private var wnd:SimpleWindow;

		private var snum:int=0;

		public function MountLvUpWnd() {
			super(LibManager.getInstance().getXML("config/ui/mount/horseLvUpWnd.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

			this.checkBoxFlag=new Vector.<Boolean>;
			for (var i:int=0; i < 3; i++)
				this.checkBoxFlag.push(false);

			this.needNumLbl=this.getUIbyID("needNumLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.proceTextArea=this.getUIbyID("proceTextArea") as ScaleBitmap;
			this.lvProgress=this.getUIbyID("lvProgress") as Label;
			this.lvImg=this.getUIbyID("lvImg") as Image;
			this.lvNameImg=this.getUIbyID("lvNameImg") as Image;
			this.goldImg=this.getUIbyID("goldImg") as Image;
			this.tipImg=this.getUIbyID("tipImg") as Image;
			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			this.radLbl=this.getUIbyID("radLbl") as Label;

			this.imgArr=new Vector.<Image>;
			this.imgArr.push(new Image("ui/horse/horse_Num_0.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_1.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_2.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_3.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_4.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_5.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_6.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_7.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_8.png", loadUI));
			this.imgArr.push(new Image("ui/horse/horse_Num_9.png", loadUI));

			this.up0CheckBox=this.getUIbyID("up0CheckBox") as RadioButton;
			this.up1CheckBox=this.getUIbyID("up1CheckBox") as RadioButton;
			this.up2CheckBox=this.getUIbyID("up2CheckBox") as RadioButton;

			this.autoUpBtn=this.getUIbyID("autoEvoBtn") as ImgLabelButton;
			this.upBtn=this.getUIbyID("startEvoBtn") as ImgLabelButton;

			this.up0CheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			this.up1CheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			this.up2CheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);

			this.autoUpBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.upBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.itemNameLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.itemNameLbl.mouseEnabled=true;

//			this.lvProgress.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			this.lvProgress.mouseEnabled=true;

			var titem:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.MountItem);
			this.itemNameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.itemNameLbl.htmlText="<font color='#00ff00'><u><a href='event:#'>" + titem.name + "</a></u></font>";
			this.itemNameLbl.addEventListener(MouseEvent.CLICK, onClick);

			this.upBtn.setToolTip(TableManager.getInstance().getSystemNotice(1130).content);
			this.autoUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1129).content);

			this.starEffect=new StarChangeEffect(10, true);
			this.addChild(this.starEffect);
			this.starEffect.x=52;
			this.starEffect.y=340;

			this.tipsinfo=new TipsInfo();
			this.tipsinfo.itemid=ConfigEnum.MountItem;

			this.effectBg=new SwfLoader();
			this.addToPane(this.effectBg);

			this.effectBg.parent.addChildAt(this.effectBg, 3);

			this.effectBg.x=154;
			this.effectBg.y=353;

			this.successEffect=new SwfLoader(99909);
			this.addToPane(this.successEffect);
			this.successEffect.x=this.width / 2;
			this.successEffect.y=this.height / 2;

			this.successEffect.visible=false;

			this.swfTips=new Sprite();
			this.swfTips.graphics.beginFill(0x000000);
			this.swfTips.graphics.drawRect(0, 0, 200, 200);
			this.swfTips.graphics.endFill();

			this.addChild(this.swfTips);

			this.swfTips.x=40;
			this.swfTips.y=150;

			this.swfTips.alpha=0;
			this.swfTips.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			this.swfTips.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.clsBtn.y=35;
			this.allowDrag=false;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.tipImg, einfo);
		}

		private function onTipMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1140).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1119 + this.lv).content, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function loadUI(e:Image):void {

			snum++;

			if (snum < 10)
				return;

			var num1Img:Image=this.getUIbyID("num1Img") as Image;
			num1Img.visible=false;

			var num0Img:Image=this.getUIbyID("num0Img") as Image;
			num0Img.visible=false;

			var num2Img:Image=this.getUIbyID("num2Img") as Image;
			num2Img.visible=false;

			this.num0Sp=new ImgRolling(0, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);
//			this.num0Sp=new ImgRolling(0, [new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData)]);

			this.num0Sp.x=num0Img.x;
			this.num0Sp.y=num0Img.y;
			this.num0Sp.endRole=this.imgEnd;
//			this.num0Sp.setEndImg(new Bitmap(this.imgArr[0].bitmapData));
			this.addChild(this.num0Sp);

			this.num1Sp=new ImgRolling(1, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);
//			this.num1Sp=new ImgRolling(1, [new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData)]);

			this.num1Sp.x=num1Img.x;
			this.num1Sp.y=num1Img.y;
			this.num1Sp.endRole=this.imgEnd;
//			this.num1Sp.setEndImg(new Bitmap(this.imgArr[0].bitmapData));
			this.addChild(this.num1Sp);

			this.num2Sp=new ImgRolling(2, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);
//			this.num2Sp=new ImgRolling(2, [new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData), new Bitmap(this.imgArr[int(Math.random()*9)].bitmapData)]);

			this.num2Sp.x=num2Img.x;
			this.num2Sp.y=num2Img.y;
			this.num2Sp.endRole=this.imgEnd;
//			this.num2Sp.setEndImg(new Bitmap(this.imgArr[0].bitmapData));
			this.addChild(this.num2Sp);

			this.firstOpen=false;

			this.num0Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));
			this.num1Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));
			this.num2Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			if (this.info == null)
				return;

			super.show(toTop, $layer, toCenter);

			if (this.checkBoxFlag.indexOf(true) == -1)
				this.up0CheckBox.dispatchEvent(new MouseEvent(MouseEvent.CLICK));

			this.updateProgress();

			GuideManager.getInstance().showGuide(5, this);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_MountLv);
		}

		override public function hide():void {
			super.hide();
			if (autoTimeId != 0)
				clearInterval(autoTimeId);

			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}

			autoUpBtn.text=PropUtils.getStringById(1804);
			autoTimeId=0;

			this.upBtn.mouseChildren=this.upBtn.mouseEnabled=this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=true;
			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
			GuideManager.getInstance().removeGuide(5);
			GuideManager.getInstance().removeGuide(89);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_MountLv);
		}

		private function onClick(e:MouseEvent):void {
			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(ConfigEnum.MountItem, ConfigEnum.MountbindItem);

			if (ConfigEnum.MarketOpenLevel <= Core.me.info.level)
				UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
		}

		private function buyItem():Boolean {
			var arr:Array=this.needNumLbl.text.split(" x ");

			if (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) >= int(arr[1])) {
				return false;
			}

			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.MountItem, ConfigEnum.MountbindItem)) {

				if (ConfigEnum.MarketOpenLevel <= Core.me.info.level)
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

				UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.MountItem, ConfigEnum.MountbindItem, int(arr[1]));

				return true;
			} else {

//				if (MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.MountItem, int(arr[1])) == -1 || MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.MountbindItem, int(arr[1])) == -1) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//					return true;
//				}

//				UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.MountItem, ConfigEnum.MountbindItem, int(arr[1]));
			}

			return false;
		}

		/*单选框的点击*/
		private function onCheckBoxClick(evt:MouseEvent):void {

			this.checkBoxFlag[0]=false;
			this.checkBoxFlag[1]=false;
			this.checkBoxFlag[2]=false;

			this.updateCostItem(evt.target as DisplayObject);
		}

		private function updateCostItem(d:DisplayObject):void {

			switch (d.name) {
				case "up0CheckBox":
					if (this.up0CheckBox.isOn)
						this.checkBoxFlag[0]=true;
					else
						this.checkBoxFlag[0]=false;

					this.moneyLbl.text=this.data.em;
					this.needNumLbl.text=" x " + this.info.Multiple1;
					this.upBtn.setToolTip(TableManager.getInstance().getSystemNotice(1130).content);
					this.radLbl.text=ConfigEnum.Mount17 + "-999";
					break;
				case "up1CheckBox":
					if (this.up1CheckBox.isOn)
						this.checkBoxFlag[1]=true;
					else
						this.checkBoxFlag[1]=false;

					this.moneyLbl.text=(int(this.data.em) * 5) + "";
					this.needNumLbl.text=" x " + this.info.Multiple2;
					this.upBtn.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1131).content, [ConfigEnum.Mount18, this.info.Multiple2, PropUtils.getStringById(1805), this.info.money]));
					this.radLbl.text=ConfigEnum.Mount18 + "-999";
					break;
				case "up2CheckBox":
					if (this.up2CheckBox.isOn)
						this.checkBoxFlag[2]=true;
					else
						this.checkBoxFlag[2]=false;

					this.moneyLbl.text=(int(this.data.em) * 10) + "";
					this.needNumLbl.text=" x " + this.info.Multiple5;
					this.upBtn.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1132).content, [ConfigEnum.Mount19, this.info.Multiple5, PropUtils.getStringById(1805), this.info.money]));
					this.radLbl.text=ConfigEnum.Mount19 + "-999";
					break;
			}

		}


		private function onMouseMove(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(e.stageX, e.stageY));
		}

		/*按钮点击*/
		private function onBtnClick(evt:MouseEvent):void {

			if (snum < 10)
				return;

			var rate:int=this.getRate();

			if (evt.target.name == "autoEvoBtn") {

				GuideManager.getInstance().removeGuide(5);
				GuideManager.getInstance().removeGuide(89);

				if (rate > 0) {

					if (this.autoUpBtn.text.indexOf(PropUtils.getStringById(1804)) > -1) {

						wnd=PopupManager.showConfirm(PropUtils.getStringById(1806), startEve, null, false, "moutLv");

					} else {

						autoUpBtn.text=PropUtils.getStringById(1804);
						clearInterval(autoTimeId);
						autoTimeId=0;

						this.upBtn.mouseChildren=this.upBtn.mouseEnabled=this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=true;

					}
				}

			} else if (evt.target.name == "startEvoBtn") {

//				this.upBtn.mouseChildren=this.upBtn.mouseEnabled=false; //this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=false;
//
//				TweenMax.delayedCall(1, endRoll);
//
//				this.num0Sp.startRoll(12);
//				this.num1Sp.startRoll(12);
//				this.num2Sp.startRoll(12);
//
//				if (rate > 0) {
//					Cmd_Mount.cmMouEvo(rate);
//				}

				this.updateAutoLv();

			}
		}

		private function startEve():void {
			upBtn.mouseChildren=upBtn.mouseEnabled=false; //autoUpBtn.mouseChildren=autoUpBtn.mouseEnabled=false;
			autoUpBtn.text=PropUtils.getStringById(1807);
			autoTimeId=setInterval(updateAutoLv, 1500);
			updateAutoLv();
		}

		public function updateAutoLv():void {

			if (this.buyItem()) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1102));
				this.closeTime();
				return;
			}

			if (UIManager.getInstance().backpackWnd.jb < int(this.moneyLbl.text)) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1101));
				this.closeTime();
				return;
			}

			var rate:int=this.getRate();
			this.upBtn.mouseChildren=this.upBtn.mouseEnabled=false; //this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=false;

			TweenMax.delayedCall(1, endRoll);

			this.num0Sp.startRoll(12);
			this.num1Sp.startRoll(12);
			this.num2Sp.startRoll(12);

			if (rate > 0) {
				var arr:Array=this.needNumLbl.text.split(" x ");
				if (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) < int(arr[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.MountItem, ConfigEnum.MountbindItem)) {
					Cmd_Mount.cmMouEvo(rate, (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.MountItem, ConfigEnum.MountbindItem) == 0 ? 2 : 1));
				} else {
					Cmd_Mount.cmMouEvo(rate);
				}
			}
//			}

		}

		/*停止图片转筒*/
		private function endRoll():void {

			if (this.ad == 0) {

				if (this.num0Sp != null)
					this.num0Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));

				if (this.num1Sp != null)
					this.num1Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));

				if (this.num2Sp != null)
					this.num2Sp.setEndImg(new Bitmap(this.imgArr[9].bitmapData));

			} else {

				if (this.num0Sp != null)
					this.num0Sp.endRolling(9);

				if (this.num1Sp != null)
					this.num1Sp.endRolling(9);

				if (this.num2Sp != null)
					this.num2Sp.endRolling(9);
			}
		}

		/*设置要显示的图片*/
		private function imgEnd(idx:int):void {

			switch (idx) {
				case 0:
					this.num0Sp.setEndImg(new Bitmap(this.imgArr[int(this.ad % 1000 / 100)].bitmapData));
					break;
				case 1:
					this.num1Sp.setEndImg(new Bitmap(this.imgArr[int(this.ad % 100 / 10)].bitmapData))
					break;
				case 2:
					this.num2Sp.setEndImg(new Bitmap(this.imgArr[this.ad % 10].bitmapData))
					this.updateProgress();
					if (autoTimeId != 0)
						this.upBtn.mouseChildren=this.upBtn.mouseEnabled=false;
					break;
			}

			if (idx == 0)
				this.num1Sp.endRolling(2);
			else if (idx == 1)
				this.num2Sp.endRolling(5);
		}

		/**
		 *
		 */
		private function closeTime():void {
			if (autoTimeId != 0) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1112));
				autoUpBtn.text=PropUtils.getStringById(1804);
				clearInterval(autoTimeId);
				autoTimeId=0;
			}

			this.upBtn.mouseChildren=this.upBtn.mouseEnabled=this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=true;
		}

		public function updateInfo(info:TMount, o:Object):void {
			this.info=info;
			this.data=o;

			if (this.checkBoxFlag.indexOf(true) > -1)
				this.updateCostItem(this["up" + this.checkBoxFlag.indexOf(true) + "CheckBox"] as DisplayObject);
			else
				this.updateCostItem(this.up0CheckBox);

			this.up0CheckBox.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1133).content));
			this.up1CheckBox.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1134).content, [ConfigEnum.Mount18]));
			this.up2CheckBox.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1135).content, [ConfigEnum.Mount19]));

			if (o.hasOwnProperty("em"))
				this.moneyLbl.text=o.em;

			if (o.hasOwnProperty("mlv"))
				this.starEffect.setStarPos(o.mlv % 10 - 1);

			if (o.hasOwnProperty("ad")) {
				this.ad=o.ad;

				var r:int=1;

				if (this.up1CheckBox.isOn)
					r=5;

				if (this.up2CheckBox.isOn)
					r=10;

				var p:Point=this.localToGlobal(new Point(130, 350));
				TweenLite.delayedCall(2, EffectUtil.flyWordEffect, ["+" + (o.ad * r) + " " + PropUtils.getStringById(1808), p]);
			}

			if (o.hasOwnProperty("mlv") && this.autoLv != o.mlv) {
				this.autoLv=o.mlv;
				this.endRoll();

				if (this.autoLv != 0) {
					this.closeTime();

//					if (successEffect.isLoaded) {
					successEffect.visible=true;
					successEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						successEffect.visible=false;
					});
//					}

					SoundManager.getInstance().play(22);
				}
			}

		}

		private function updateProgress():void {

			if (data.hasOwnProperty("ev")) {
				this.lvProgress.text=data.ev + "/" + this.info.exp;
//				this.proceTextArea.scaleX=(int(data.ev) / this.info.exp) > 1 ? 1 : (int(data.ev) / this.info.exp);
				if (data.ev == 0) {
					this.proceTextArea.visible=false;
				} else {
					this.proceTextArea.visible=true;
					this.proceTextArea.setSize(Number((int(data.ev) / this.info.exp) > 1 ? 1 : (int(data.ev) / this.info.exp)) * 214, 12);
				}
			}

			//换lv图
			if (this.data.hasOwnProperty("el")) {

				lv=this.data.el;
				if (int(this.data.mlv) % 10 == 9)
					lv=lv + 1;

				if (this.data.el == 10)
					lv=10;

				this.lvImg.updateBmp("ui/horse/horse_lv" + (lv) + ".png");
				this.lvNameImg.updateBmp("ui/horse/horse_lv" + (lv) + "_name.png");

				var pid:int=20500 + lv;

				if (lv == 10) {
					this.effectBg.update(pid);
				} else
					this.effectBg.update(pid);

			}

			this.upBtn.mouseChildren=this.upBtn.mouseEnabled=this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=true;
		}

		public function updateSuccess(o:Object):void {

			if (o.rst == 0) {

				if (this.autoTimeId != 0)
					this.closeTime();

//				this.endRoll();

				this.upBtn.mouseChildren=this.upBtn.mouseEnabled=this.autoUpBtn.mouseChildren=this.autoUpBtn.mouseEnabled=true;
			}

		}

		private function getRate():int {

			for (var i:int=0; i < this.checkBoxFlag.length; i++) {

				if (this.checkBoxFlag[i]) {

					switch (i) {
						case 0:
							return 1;
							break
						case 1:
							return 2;
							break
						case 2:
							return 5;
							break
					}
					break;
				}
			}

			return 0;
		}

		override public function get width():Number {
			return 306;
		}

		override public function get height():Number {
			return 524;
		}

	}
}

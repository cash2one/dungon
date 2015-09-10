package com.leyou.ui.role.child {

	import com.ace.ICommon.ILoaderCallBack;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.loaderSync.child.BackObj;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ElementEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Element;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.ui.role.child.children.ImgRolling;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class ElementWnd extends AutoSprite implements ILoaderCallBack {

		private var bgswf:MovieClip;
		private var woodImgBtn:ImgButton; //按钮
		private var fireImgBtn:ImgButton;
		private var goldImgBtn:ImgButton;
		private var waterImgBtn:ImgButton;
		private var soilImgBtn:ImgButton;

		private var goldBackTextArea:ScaleBitmap;
		private var waterBackTextArea:ScaleBitmap;
		private var soilBackTextArea:ScaleBitmap;
		private var fireBackTextArea:ScaleBitmap;
		private var woodBackTextArea:ScaleBitmap;

		private var goldExpTextArea:ScaleBitmap; //进度条
		private var waterExpTextArea:ScaleBitmap;
		private var soilExpTextArea:ScaleBitmap;
		private var fireExpTextArea:ScaleBitmap;
		private var woodExpTextArea:ScaleBitmap;

		private var expW:Number;

		private var fireLvLbl:Label; //等级lable
		private var waterLvLbl:Label;
		private var soilLvLbl:Label;
		private var goldLvLbl:Label;
		private var woodLvLbl:Label;

		private var img0:Image;
		private var img1:Image;
		private var img2:Image;
		private var img3:Image;
		private var img4:Image;

		private var expLbl:Label; //摇动拉杆后获得的经验说明
		private var decLbl:Label; //介绍
		private var freeDecLbl:Label; //免费次数
		private var tiemsLbl:Label; //剩余次数的说明

		private var saveEleImg:Image;

		public var begainBtn:ImgButton;

		private var ruleTxt:TextArea;
		private var descTxt:TextArea;

		private var checkBoxArr:Vector.<CheckBox>;
		private var img0Sp:ImgRolling;
		private var img1Sp:ImgRolling;
		private var img2Sp:ImgRolling;
		private var img3Sp:ImgRolling;
		private var img4Sp:ImgRolling;
		private var saveEleSwf:SwfLoader;

		private var elementActive:Vector.<Boolean>;
		private var rollingFalg:Array;
		private var stopImgNum:Array;

		public var guildElement:int=-1;
		private var clickIdx:int;
		private var timer:Timer;
		public var info:ElementInfo;
		public var info2:ElementInfo;
		private var costLbl:Label;

		private var expLblArr:Array=[];

		private var flyLblArr:Array=[new Label(), new Label(), new Label(), new Label(), new Label()];
		private var begState:Boolean=false;
		private var tipsinfo:TipsInfo;

		private var saveFlagSpr:Sprite;

		private var firstBoolt:Boolean=false;

		private var snum:int=0;

		private var loader:Loader;

		public var rollEffecSwf:Vector.<SwfLoader>;
		private var effIDArr:Array=[99925, 99924, 99922, 99921, 99923];

		private var parr:Array=[[111, 19, "fireImgBtn"], [209, 89, "goldImgBtn"], [52, 191, "soilImgBtn"], [185, 191, "woodImgBtn"], [21, 91, "waterImgBtn"]];

		private var cbtipsArr:Array=[];

		public function ElementWnd() {
			super(LibManager.getInstance().getXML("config/ui/role/ElementWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.checkBoxArr=new Vector.<CheckBox>;
			this.elementActive=new Vector.<Boolean>;
			this.rollingFalg=new Array();
			this.stopImgNum=new Array();
			this.guildElement=-1;
			this.clickIdx=-1;

//			loader=new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompelte);
//			loader.load(new URLRequest(UIEnum.DATAROOT + "ui/element/element_bg.swf"));
//			loader.loadBytes(LibManager.getInstance().getBinary("ui/element/element_bg.swf"));

			ReuseManager.getInstance().swfSyLoader.addLoader("ui/element/element_bg.swf", new BackObj(this));

//			this.woodImgBtn=this.getUIbyID("woodImgBtn") as ImgButton;
//			this.fireImgBtn=this.getUIbyID("fireImgBtn") as ImgButton;
//			this.goldImgBtn=this.getUIbyID("goldImgBtn") as ImgButton;
//			this.waterImgBtn=this.getUIbyID("waterImgBtn") as ImgButton;
//			this.soilImgBtn=this.getUIbyID("soilImgBtn") as ImgButton;
//
//			this.woodImgBtn.alpha=0;
//			this.fireImgBtn.alpha=0;
//			this.goldImgBtn.alpha=0;
//			this.waterImgBtn.alpha=0;
//			this.soilImgBtn.alpha=0;

			this.img0=new Image();
			this.img0.bitmapData=LibManager.getInstance().getImg("ui/element/el_gold.png")
			this.img1=new Image();
			this.img1.bitmapData=LibManager.getInstance().getImg("ui/element/el_wood.png")
			this.img2=new Image();
			this.img2.bitmapData=LibManager.getInstance().getImg("ui/element/el_water.png")
			this.img3=new Image();
			this.img3.bitmapData=LibManager.getInstance().getImg("ui/element/el_fire.png")
			this.img4=new Image();
			this.img4.bitmapData=LibManager.getInstance().getImg("ui/element/el_dirt.png")

			loadUI();

			this.rollEffecSwf=new Vector.<SwfLoader>();

			this.rollEffecSwf.push(this.getUIbyID("effswf1") as SwfLoader);
			this.rollEffecSwf.push(this.getUIbyID("effswf2") as SwfLoader);
			this.rollEffecSwf.push(this.getUIbyID("effswf3") as SwfLoader);
			this.rollEffecSwf.push(this.getUIbyID("effswf4") as SwfLoader);
			this.rollEffecSwf.push(this.getUIbyID("effswf5") as SwfLoader);

			this.saveFlagSpr=new Sprite();
			this.addChild(this.saveFlagSpr);
			this.saveEleImg=this.getUIbyID("saveEleImg") as Image;
			this.saveEleSwf=this.getUIbyID("saveEleSwf") as SwfLoader;

			this.saveEleImg.alpha=0;

			this.saveFlagSpr.addChild(this.saveEleImg);

			this.checkBoxArr.push(this.getUIbyID("checkBox0") as CheckBox);
			this.checkBoxArr.push(this.getUIbyID("checkBox1") as CheckBox);
			this.checkBoxArr.push(this.getUIbyID("checkBox2") as CheckBox);
			this.checkBoxArr.push(this.getUIbyID("checkBox3") as CheckBox);
			this.checkBoxArr.push(this.getUIbyID("checkBox4") as CheckBox);

			var i:int;
			var spr:Sprite;
			for (i=0; i < 5; i++) {
				this.elementActive.push(false);
				this.checkBoxArr[i].addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.checkBoxArr[i].addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				this.checkBoxArr[i].addEventListener(MouseEvent.CLICK, this.onCheckBoxClick);

				spr=new Sprite();
				spr.graphics.beginFill(0x000000);
				spr.graphics.drawRect(0, 0, 50, 50);
				spr.graphics.endFill();

				spr.x=this.parr[i][0];
				spr.y=this.parr[i][1];

				spr.name=this.parr[i][2];

				spr.alpha=0;

				this.addChild(spr);

				spr.addEventListener(MouseEvent.CLICK, this.onBtnClick);
				spr.addEventListener(MouseEvent.ROLL_OVER, onRollClick);

			}

			this.expLblArr.push(this.getUIbyID("exp0Lbl") as Label);
			this.expLblArr.push(this.getUIbyID("exp1Lbl") as Label);
			this.expLblArr.push(this.getUIbyID("exp2Lbl") as Label);
			this.expLblArr.push(this.getUIbyID("exp3Lbl") as Label);
			this.expLblArr.push(this.getUIbyID("exp4Lbl") as Label);

			this.decLbl=this.getUIbyID("decLbl") as Label;
			this.freeDecLbl=this.getUIbyID("freeDecLbl") as Label;
			this.tiemsLbl=this.getUIbyID("tiemsLbl") as Label;
			this.costLbl=this.getUIbyID("costLbl") as Label;

			this.costLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.descTxt=this.getUIbyID("descTxt") as TextArea;
			this.ruleTxt=this.getUIbyID("ruleTxt") as TextArea;

			this.descTxt.visibleOfBg=false;
			this.ruleTxt.visibleOfBg=false;

			this.descTxt.setHtmlText(TableManager.getInstance().getSystemNotice(1308).content);
			this.ruleTxt.setHtmlText(TableManager.getInstance().getSystemNotice(1307).content);

			this.begainBtn=this.getUIbyID("begainBtn") as ImgButton;
			this.tipsinfo=new TipsInfo();

			this.begainBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);

			this.saveFlagSpr.addEventListener(MouseEvent.ROLL_OVER, onRollClick);
			this.saveFlagSpr.name="saveFlagSpr";

			this.costLbl.addEventListener(MouseEvent.ROLL_OVER, onCostClick);
			this.costLbl.addEventListener(TextEvent.LINK, onCostLink);
			this.costLbl.mouseEnabled=true;

			for (i=0; i < this.flyLblArr.length; i++) {
				this.addChild(this.flyLblArr[i]);
			}

			this.y=4;
			this.x=-9;
		}

		private function loadUI():void {

//			this.snum++;
//			if (this.snum < 4)
//				return;

			var img0t:Image=this.getUIbyID("img0") as Image;
			var img1t:Image=this.getUIbyID("img1") as Image;
			var img2t:Image=this.getUIbyID("img2") as Image;
			var img3t:Image=this.getUIbyID("img3") as Image;
			var img4t:Image=this.getUIbyID("img4") as Image;

			img0t.visible=false;
			img1t.visible=false;
			img2t.visible=false;
			img3t.visible=false;
			img4t.visible=false;

			this.img0Sp=new ImgRolling(0, [new Bitmap(this.img0.bitmapData), new Bitmap(this.img1.bitmapData), new Bitmap(this.img2.bitmapData), new Bitmap(this.img3.bitmapData), new Bitmap(this.img4.bitmapData)]);
			this.img0Sp.x=img0t.x + 2;
			this.img0Sp.y=img0t.y;
			this.img0Sp.scaleX=.9;
			this.img0Sp.scaleY=.9;
//			this.img0Sp.setEndImg(new Bitmap(this.img0.bitmapData));
			this.addChild(this.img0Sp);


			this.img1Sp=new ImgRolling(1, [new Bitmap(this.img1.bitmapData), new Bitmap(this.img2.bitmapData), new Bitmap(this.img3.bitmapData), new Bitmap(this.img4.bitmapData), new Bitmap(this.img0.bitmapData)]);
			this.img1Sp.x=img1t.x + 2;
			this.img1Sp.y=img1t.y;
			this.img1Sp.scaleX=.9;
			this.img1Sp.scaleY=.9;
//			this.img1Sp.setEndImg(new Bitmap(this.img1.bitmapData));
			this.addChild(this.img1Sp);

			this.img2Sp=new ImgRolling(2, [new Bitmap(this.img2.bitmapData), new Bitmap(this.img3.bitmapData), new Bitmap(this.img4.bitmapData), new Bitmap(this.img0.bitmapData), new Bitmap(this.img1.bitmapData)]);
			this.img2Sp.x=img2t.x + 2;
			this.img2Sp.y=img2t.y;
			this.img2Sp.scaleX=.9;
			this.img2Sp.scaleY=.9;
			this.addChild(this.img2Sp);
//			this.img2Sp.setEndImg(new Bitmap(this.img2.bitmapData));

			this.img3Sp=new ImgRolling(3, [new Bitmap(this.img3.bitmapData), new Bitmap(this.img4.bitmapData), new Bitmap(this.img0.bitmapData), new Bitmap(this.img1.bitmapData), new Bitmap(this.img2.bitmapData)]);
			this.img3Sp.x=img3t.x + 2;
			this.img3Sp.y=img3t.y;
			this.img3Sp.scaleX=.9;
			this.img3Sp.scaleY=.9;
			this.addChild(this.img3Sp);
//			this.img3Sp.setEndImg(new Bitmap(this.img3.bitmapData));

			this.img4Sp=new ImgRolling(4, [new Bitmap(this.img4.bitmapData), new Bitmap(this.img0.bitmapData), new Bitmap(this.img1.bitmapData), new Bitmap(this.img2.bitmapData), new Bitmap(this.img3.bitmapData)]);
			this.img4Sp.x=img4t.x + 2;
			this.img4Sp.y=img4t.y;
			this.img4Sp.scaleX=.85;
			this.img4Sp.scaleY=.85;
			this.addChild(this.img4Sp);
//			this.img4Sp.setEndImg(new Bitmap(this.img4.bitmapData));

			this.img0Sp.endRole=this.imgEnd;
			this.img1Sp.endRole=this.imgEnd;
			this.img2Sp.endRole=this.imgEnd;
			this.img3Sp.endRole=this.imgEnd;
			this.img4Sp.endRole=this.imgEnd;

			if (this.info != null)
				this.setImg(info.result);

			img0t.die();
			img1t.die();
			img2t.die();
			img3t.die();
			img4t.die();
		}

		private function onCostLink(e:TextEvent):void {
			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(this.info.cItemId, this.info.bItemId);
			UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
		}

		private function buyItem():void {
			var arr:Array=this.costLbl.text.split(" x ");

			if (MyInfoManager.getInstance().getBagItemNumByName(arr[0]) >= int(arr[1])) {
				return;
			}

			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(this.info.cItemId, this.info.bItemId)) {
				UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
				UIManager.getInstance().quickBuyWnd.pushItem(this.info.cItemId, this.info.bItemId, arr[1]);
			} else {

//				if (MyInfoManager.getInstance().getBagEmptyGridIndex(this.info.cItemId, int(arr[1])) == -1 || MyInfoManager.getInstance().getBagEmptyGridIndex(this.info.bItemId, int(arr[1])) == -1) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//					return;
//				}

			}

		}

		private function onMouseOver(e:MouseEvent):void {
			if (this.cbtipsArr.length == 0) {
				this.cbtipsArr=DataManager.getInstance().vipData.elementPrivilegeVipLv();
			}

			var str:String=com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1309).content, this.cbtipsArr);

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function callBackFun(obj:Object):void {
			this.bgswf=LibManager.getInstance().getMc("ui/element/element_bg.swf");
			this.bgswf.x=-2;
			this.addChildAt(this.bgswf, 0);
		}

		public function updateInfor(info:ElementInfo):void {

			this.info=info;

			if (this.info2 == null)
				this.info2=this.info.clone();

			if (this.tiemsLbl.text == "") {
				this.effectEnd();
				this.tipsinfo.itemid=info.cItemId;
			}

			var item:TItemInfo=TableManager.getInstance().getItemInfo(info.cItemId);
//			this.costLbl.htmlText="<font color='#00ff00'><u><a href='event:--'>" + item.name + "</a></u></font>*" + info.lNum;

			this.setUseItem();

			if (info.freeCount <= 0) //免费次数用完 花费道具的描述显示
				this.freeDecLbl.text="";
			else {
				this.freeDecLbl.text=StringUtil.substitute(PropUtils.getStringById(1869),[info.freeCount]);
				this.costLbl.htmlText="<font color='#00ff00'><u><a href='event:--'>" + item.name + "</a></u></font> x 0";
			}

			this.tiemsLbl.text=info.count + PropUtils.getStringById(1977);

			var i:int=0;

			if (info.effect == false)
				this.setImg(info.result);
			else {

				info.effect=false;
				this.imgRolling();
				this.countDown(3);
				this.bgswf.gotoAndPlay(91);

				for (i=0; i < 5; i++) {
					if (!this.elementActive[i])
						this.stopImgNum.push(info.result[i]);
				}

			}

//			if (info.count <= 0)
//				this.begainBtn.setActive(false);
//			else
//				this.begainBtn.setActive(true);

		}

		private function onCostClick(e:MouseEvent):void {

			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(e.stageX, e.stageY));
					break;
				case MouseEvent.ROLL_OUT:

					break;
			}

		}

		/**
		 *效果结束的处理
		 */
		private function effectEnd():void {
//			this.goldLvLbl.text="lv " + info.elements[0].lv;
//			this.woodLvLbl.text="lv " + info.elements[1].lv;
//			this.waterLvLbl.text="lv " + info.elements[2].lv;
//			this.fireLvLbl.text="lv " + info.elements[3].lv;
//			this.soilLvLbl.text="lv " + info.elements[4].lv;

//			if (info.elements[0].sumExp == 0)
//				this.goldExpTextArea.setSize(0, this.goldExpTextArea.height);
//			else
////				this.goldExpTextArea.setSize((info.elements[0].exp / info.elements[0].sumExp) * this.expW, this.goldExpTextArea.height);
//				this.goldExpTextArea.scaleX=(info.elements[0].exp / info.elements[0].sumExp);
//
//			if (info.elements[1].sumExp == 0)
//				this.woodExpTextArea.setSize(0, this.goldExpTextArea.height);
//			else
////				this.woodExpTextArea.setSize((info.elements[1].exp / info.elements[1].sumExp) * this.expW, this.woodExpTextArea.height);
//				this.woodExpTextArea.scaleX=(info.elements[1].exp / info.elements[1].sumExp);
//
//			if (info.elements[2].sumExp == 0)
//				this.waterExpTextArea.setSize(0, this.goldExpTextArea.height);
//			else
////				this.waterExpTextArea.setSize((info.elements[2].exp / info.elements[2].sumExp) * this.expW, this.waterExpTextArea.height);
//				this.waterExpTextArea.scaleX=(info.elements[2].exp / info.elements[2].sumExp);
//
//			if (info.elements[3].sumExp == 0)
//				this.fireExpTextArea.setSize(0, this.goldExpTextArea.height);
//			else
////				this.fireExpTextArea.setSize((info.elements[3].exp / info.elements[3].sumExp) * this.expW, this.fireExpTextArea.height);
//				this.fireExpTextArea.scaleX=(info.elements[3].exp / info.elements[3].sumExp);
//
//			if (info.elements[4].sumExp == 0)
//				this.soilExpTextArea.setSize(0, this.goldExpTextArea.height);
//			else
////				this.soilExpTextArea.setSize((info.elements[4].exp / info.elements[4].sumExp) * this.expW, this.soilExpTextArea.height);
//				this.soilExpTextArea.scaleX=(info.elements[4].exp / info.elements[4].sumExp);

			var i:int=0;

			for (i=0; i < this.expLblArr.length; i++) {
				if (info.preExp[i] != null)
					this.expLblArr[i].text=info.preExp[i];
			}

			if (this.guildElement != -1) {
				for (i=0; i < this.info.elements.length; i++) {
					this.info.elements[i].flag=false;
				}
				this.info.elements[this.guildElement].flag=true;
			}

			if (this.firstBoolt) {
				TweenLite.delayedCall(.5, this.flyWord);
			}

			this.firstBoolt=true;
		}

		public function updateGuildElement(info:ElementInfo):void {

			if (this.guildElement != info.guildIdx) {

				switch (info.guildIdx) {
					case 0:
						this.saveEleImg.updateBmp("ui/element/el_gold.png");
						this.saveEleSwf.update(99925);
						break;
					case 1:
						this.saveEleImg.updateBmp("ui/element/el_wood.png");
						this.saveEleSwf.update(99924);
						break;
					case 2:
						this.saveEleImg.updateBmp("ui/element/el_water.png");
						this.saveEleSwf.update(99922);
						break;
					case 3:
						this.saveEleImg.updateBmp("ui/element/el_fire.png");
						this.saveEleSwf.update(99921);
						break;
					case 4:
						this.saveEleImg.updateBmp("ui/element/el_dirt.png");
						this.saveEleSwf.update(99923);
						break;
				}

			}

			this.guildElement=info.guildIdx;

			if (this.guildElement != -1) {
				for (var i:int=0; i < this.info.elements.length; i++) {
					this.info.elements[i].flag=false;
				}

				GuideManager.getInstance().removeGuide(11);
				this.info.elements[this.guildElement].flag=true;
			}
		}

		private function onRollClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "woodImgBtn": //木按钮
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[1], new Point(e.stageX, e.stageY));
					break;
				case "fireImgBtn": //火按钮
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[3], new Point(e.stageX, e.stageY));
					break;
				case "goldImgBtn": //金按钮
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[0], new Point(e.stageX, e.stageY));
					break;
				case "waterImgBtn": //水按钮
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[2], new Point(e.stageX, e.stageY));
					break;
				case "soilImgBtn": //土按钮
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[4], new Point(e.stageX, e.stageY));
					break;
				case "saveFlagSpr":
					ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, this.info2.elements[this.guildElement], new Point(e.stageX, e.stageY));
					break;
			}

		}

		/**
		 *按钮点击
		 * @param evt
		 *
		 */
		private function onBtnClick(evt:MouseEvent):void {


			switch (evt.target.name) {
				case "woodImgBtn":
					this.elementClick(ElementEnum.WOOD); //木按钮
					break;
				case "fireImgBtn":
					this.elementClick(ElementEnum.FIRE); //火按钮
					break;
				case "goldImgBtn":
					this.elementClick(ElementEnum.GOLD); //金按钮
					break;
				case "waterImgBtn":
					this.elementClick(ElementEnum.WATER); //水按钮
					break;
				case "soilImgBtn":
					this.elementClick(ElementEnum.SOIL); //土按钮
					break;
				case "begainBtn":

					GuideManager.getInstance().removeGuide(80);

					if (this.rollingFalg.length > 0)
						return;

//					if (this.snum < 4)
//						return;

					var i:int;

					this.buyItem();

					var arr:Array=new Array();
					for (i=0; i < this.elementActive.length; i++) {
						if (this.elementActive[i] == true)
							arr.push(1);
						else
							arr.push(0);
					}

					var arr1:Array=this.costLbl.text.split(" x ");
					if (MyInfoManager.getInstance().getBagItemNumByName(PropUtils.getStringById(1865)) < int(arr1[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(this.info.cItemId, this.info.bItemId)) {
						this.begainBtn.setActive(false, .6, true);
						Cmd_Element.cm_ele_l(arr, (UIManager.getInstance().quickBuyWnd.getCost(this.info.cItemId, this.info.bItemId) == 0 ? 2 : 1));
					} else {

						if (MyInfoManager.getInstance().getBagItemNumByName(arr1[0]) >= int(arr1[1])) {
							this.begainBtn.setActive(false, .6, true);
							Cmd_Element.cm_ele_l(arr);
						} else if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(this.info.cItemId, this.info.bItemId)) {
							UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
							UIManager.getInstance().quickBuyWnd.pushItem(this.info.cItemId, this.info.bItemId, arr1[1]);
							return;
						}

					}

					break;
			}

			GuideManager.getInstance().removeGuide(11);
		}

		private function setImg(arr:Array):void {

			if (this.img0Sp != null) {
				this.img0Sp.setEndImg(this.getImg(arr[0]));
				this.img0Sp.visible=false;
			}

			if (this.img1Sp != null) {
				this.img1Sp.setEndImg(this.getImg(arr[1]));
				this.img1Sp.visible=false;
			}

			if (this.img2Sp != null) {
				this.img2Sp.setEndImg(this.getImg(arr[2]));
				this.img2Sp.visible=false;
			}

			if (this.img3Sp != null) {
				this.img3Sp.setEndImg(this.getImg(arr[3]));
				this.img3Sp.visible=false;
			}

			if (this.img4Sp != null) {
				this.img4Sp.setEndImg(this.getImg(arr[4]));
				this.img4Sp.visible=false;
			}

			for (var i:int=0; i < arr.length; i++) {
				this.rollEffecSwf[i].visible=true;
				this.rollEffecSwf[i].update(this.effIDArr[arr[i]]);
				this.rollEffecSwf[i].scaleX=this.rollEffecSwf[i].scaleY=.9;
			}

			this.info2=this.info.clone();
			this.bgswf.gotoAndPlay(1);
		}

		/**
		 *计时
		 * @param t
		 *
		 */
		private function countDown(t:int):void {
			this.timer=new Timer(t * 1000, 1);
			this.timer.addEventListener(TimerEvent.TIMER, this.stopRolling);
			this.timer.start();
		}

		public function changeState(i:int):void {
			if (i == 0) {
				if (this.timer != null)
					this.timer.stop();

				this.begainBtn.setActive(true, 1, true);
			}
		}

		/**
		 *开始滚动图片
		 *
		 */
		private function imgRolling():void {

			if (!this.elementActive[0]) {
				this.img0Sp.startRoll();
				this.rollingFalg.push(0);
				this.rollEffecSwf[0].visible=false;
				this.img0Sp.visible=true;
			}

			if (!this.elementActive[1]) {
//				this.img1Sp.startRoll();
				this.rollingFalg.push(1);
				TweenLite.delayedCall(.05, this.img1Sp.startRoll);
				this.rollEffecSwf[1].visible=false;
				this.img1Sp.visible=true;
			}

			if (!this.elementActive[2]) {
				TweenLite.delayedCall(.1, this.img2Sp.startRoll);
				this.rollingFalg.push(2);
				this.rollEffecSwf[2].visible=false;
				this.img2Sp.visible=true;
			}

			if (!this.elementActive[3]) {
				TweenLite.delayedCall(.15, this.img3Sp.startRoll);
				this.rollingFalg.push(3);
				this.rollEffecSwf[3].visible=false;
				this.img3Sp.visible=true;
			}

			if (!this.elementActive[4]) {
				TweenLite.delayedCall(.2, this.img4Sp.startRoll);
				this.rollingFalg.push(4);
				this.rollEffecSwf[4].visible=false;
				this.img4Sp.visible=true;
			}

		}

		/**
		 * @param eve
		 *
		 */
		private function stopRolling(eve:TimerEvent):void {
			var delay:Number=0;
			var num:int=this.stopImgNum[0];
			var i:int=int(rollingFalg[0]);

			TweenLite.delayedCall(0.3 + int(rollingFalg[0]) / 10, complete, [int(rollingFalg[0]), num]);

			function complete(i:int, num:int):void {

				switch (i) {
					case 0:
						img0Sp.endRolling(num);
						img0Sp.visible=false;
						break;
					case 1:
						img1Sp.endRolling(num);
						img1Sp.visible=false;
						delay=.05;
						break;
					case 2:
						img2Sp.endRolling(num);
						img2Sp.visible=false;
						delay=.1;
						break;
					case 3:
						img3Sp.endRolling(num);
						img3Sp.visible=false;
						delay=.15;
						break;
					case 4:
						img4Sp.endRolling(num);
						img4Sp.visible=false;
						delay=.2;
						break;
				}

				info2=info.clone();
				rollEffecSwf[i].visible=true;
				rollEffecSwf[i].update(effIDArr[num]);
			}
		}

		private function imgEnd(idx:int):void {

			if (this.stopImgNum.length > 0) {
				var num:int=this.stopImgNum.shift();
				var img:Bitmap=this.getImg(num);
				this.getSp(this.rollingFalg.shift()).setEndImg(img, false);
			}

			if (this.rollingFalg.length > 0)
				this.stopRolling(null);
			else {
				this.begainBtn.setActive(true, 1, true);
				this.effectEnd();

				TweenLite.delayedCall(.5, this.bgswf.gotoAndPlay, [1]);
			}

		}

		private function getSp(idx:int):ImgRolling {
			switch (idx) {
				case 0:
					return this.img0Sp;
					break;
				case 1:
					return this.img1Sp;
					break;
				case 2:
					return this.img2Sp;
					break;
				case 3:
					return this.img3Sp;
					break;
				case 4:
					return this.img4Sp;
					break;
			}

			return null;
		}

		private function getImg(idx:int):Bitmap {

			var btmp:Bitmap;
			switch (idx) {
				case 0:
					btmp=new Bitmap();
					btmp.bitmapData=this.img0.bitmapData;
					break;
				case 1:
					btmp=new Bitmap();
					btmp.bitmapData=this.img1.bitmapData;
					break;
				case 2:
					btmp=new Bitmap();
					btmp.bitmapData=this.img2.bitmapData;
					break;
				case 3:
					btmp=new Bitmap();
					btmp.bitmapData=this.img3.bitmapData;
					break;
				case 4:
					btmp=new Bitmap();
					btmp.bitmapData=this.img4.bitmapData;
					break;
			}

			return btmp;
		}

		private function setUseItem():void {
			var item:TItemInfo=TableManager.getInstance().getItemInfo(info.cItemId);
			if (this.getSelect() > 0)
				this.costLbl.htmlText="<font color='#00ff00'><u><a href='event:--'>" + item.name + "</a></u></font> x " + int(info.lNum * this.info.lb[this.getSelect() - 1][1]);
			else
				this.costLbl.htmlText="<font color='#00ff00'><u><a href='event:--'>" + item.name + "</a></u></font> x " + info.lNum
		}

		private function onCheckBoxClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "checkBox0":
					if (this.checkBoxArr[0].isOn) {
						if (this.getSelect() >= this.info.lockNum) {
							this.checkBoxArr[0].turnOff(true);
						} else {
							this.elementActive[0]=true;
						}
					} else
						this.elementActive[0]=false;
					break;
				case "checkBox1":
					if (this.checkBoxArr[1].isOn) {
						if (this.getSelect() >= this.info.lockNum) {
							this.checkBoxArr[1].turnOff(true);
						} else {
							this.elementActive[1]=true;
						}
					} else
						this.elementActive[1]=false;
					break;
				case "checkBox2":
					if (this.checkBoxArr[2].isOn) {
						if (this.getSelect() >= this.info.lockNum) {
							this.checkBoxArr[2].turnOff(true);
						} else {
							this.elementActive[2]=true;
						}
					} else
						this.elementActive[2]=false;
					break;
				case "checkBox3":
					if (this.checkBoxArr[3].isOn) {
						if (this.getSelect() >= this.info.lockNum) {
							this.checkBoxArr[3].turnOff(true);
						} else {
							this.elementActive[3]=true;
						}
					} else
						this.elementActive[3]=false;
					break;
				case "checkBox4":
					if (this.checkBoxArr[4].isOn) {
						if (this.getSelect() >= this.info.lockNum) {
							this.checkBoxArr[4].turnOff(true);
						} else {
							this.elementActive[4]=true;
						}
					} else
						this.elementActive[4]=false;
					break;
			}

			this.setUseItem();
		}

		private function elementClick(idx:int):void {
			if (this.guildElement == idx)
				return;

			this.clickIdx=idx;
			var str:String=new String();

			var center:String=com.leyou.utils.StringUtil_II.addEventString(this.info.cItemId + "", PropUtils.getStringById(1865), true);
			center=com.leyou.utils.StringUtil_II.getColorStr(center, ElementEnum.COLOR_GREEN);

			var title:String;
			var f:Boolean=false;
			if (this.guildElement == -1) {
				str=StringUtil.substitute(PropUtils.getStringById(1870),[getElementNameByIdx(idx, ElementEnum.COLOR_YELLOW),center]);
//				f=true;
			} else {
				str=StringUtil.substitute(PropUtils.getStringById(1871),[getElementNameByIdx(this.guildElement, ElementEnum.COLOR_YELLOW),getElementNameByIdx(idx, ElementEnum.COLOR_YELLOW), com.leyou.utils.StringUtil_II.getColorStr("1", ElementEnum.COLOR_YELLOW) ,center]);
//				f=true;
			}

			PopupManager.showConfirm(str, function():void {

				if (guildElement == -1 || MyInfoManager.getInstance().getBagItemNumByName(PropUtils.getStringById(1865)) > 0) {
					UIManager.getInstance().roleWnd.elementWnd.setGuildElement();
				} else { //背包中没有

					if (clickIdx != -1 && UIManager.getInstance().quickBuyWnd.isAutoBuy(info.cItemId, info.bItemId)) {
						Cmd_Element.cm_ele_m(clickIdx + 1, (UIManager.getInstance().quickBuyWnd.getCost(info.cItemId, info.bItemId) == 0 ? 2 : 1));
					} else {

						var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
						swnd.pushItem(info.cItemId, info.bItemId);
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
					}

				}
			}, null, false, "changeElement", PropUtils.getStringById(1872));
		}

		private function getElementNameByIdx(idx:int, color:String=null):String {

			var str:String;
			switch (idx) {
				case ElementEnum.GOLD:
					str=PropUtils.getStringById(1301);
					break;
				case ElementEnum.WOOD:
					str=PropUtils.getStringById(1302);
					break;
				case ElementEnum.WATER:
					str=PropUtils.getStringById(1303);
					break;
				case ElementEnum.FIRE:
					str=PropUtils.getStringById(1304);
					break;
				case ElementEnum.SOIL:
					str=PropUtils.getStringById(1305);
					break;
			}

			if (str != null && color != null)
				str=com.leyou.utils.StringUtil_II.getColorStr(str, color);

			return str;
		}

		private function getSelect():int {
			var f:int;
			for (var i:int=0; i < this.elementActive.length; i++) {
				if (this.elementActive[i] == true)
					f++;
			}
			return f;
		}

//		private function getTheTimes():int {
//			if (MyInfoManager.getInstance().vipLv == 0)
//				return 1;
//			else if (MyInfoManager.getInstance().vipLv < 3)
//				return 2;
//			else if (MyInfoManager.getInstance().vipLv == 3)
//				return 3;
//			else if (MyInfoManager.getInstance().vipLv == 4)
//				return 4;
//			return 0;
//		}

		public function setGuildElement():void {
			if (this.clickIdx != -1) {
				Cmd_Element.cm_ele_m(this.clickIdx + 1);
			}
		}

		/**
		 * @param str
		 */
		private function flyWord():void {

			for (var i:int=0; i < this.info.preExp.length; i++) {

				if (this.info.preExp[i] != 0) {
					this.flyLblArr[i].text=PropUtils.getStringById(20)+" +" + this.info.preExp[i];
					this.flyLblArr[i].textColor=0xffff00;

					switch (i) {
						case 0:
							this.flyLblArr[0].x=209 + 23.5;
							this.flyLblArr[0].y=89 + 23.5;
							break;
						case 1:
							this.flyLblArr[1].x=185 + 23.5;
							this.flyLblArr[1].y=191 + 23.5;
							break;
						case 2:
							this.flyLblArr[2].x=21 + 23.5;
							this.flyLblArr[2].y=91 + 23.5;
							break;
						case 3:
							this.flyLblArr[3].x=111 + 23.5;
							this.flyLblArr[3].y=19 + 23.5;
							break;
						case 4:
							this.flyLblArr[4].x=52 + 23.5;
							this.flyLblArr[4].y=191 + 23.5;
							break;
					}

					this.flyLblArr[i].alpha=1;
					TweenMax.to(this.flyLblArr[i], 3, {y: this.flyLblArr[i].y - 40, alpha: 0});
				}

			}

		}

	}
}

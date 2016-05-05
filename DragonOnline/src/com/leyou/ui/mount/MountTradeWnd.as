package com.leyou.ui.mount {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MountTradeWnd extends AutoWindow {

		private var saveBtn:ImgLabelButton;
		private var tradeBtn:ImgLabelButton;

		private var phAttLbl:Label;
		private var phAttAddLbl:Label;
		private var magicAttAddLbl:Label;
		private var phDefAddLbl:Label;
		private var magicDefAddLbl:Label;
		private var hpAddLbl:Label;
		private var mpAddLbl:Label;
		private var magicAttLbl:Label;
		private var phDefLbl:Label;
		private var magicDefLbl:Label;
		private var hpLbl:Label;
		private var mpLbl:Label;

		private var n_phAttLbl:Label;
		private var n_phAttAddLbl:Label;
		private var n_magicAttAddLbl:Label;
		private var n_phDefAddLbl:Label;
		private var n_magicDegAddLbl:Label;
		private var n_hpAddLbl:Label;
		private var n_mpAddLbl:Label;
		private var n_magicAttLbl:Label
		private var n_phDefLbl:Label;
		private var n_magicDefLbl:Label;
		private var n_hpLbl:Label;
		private var n_mpLbl:Label;

		private var n_phAttRateLbl:Label;
		private var n_magicAttRateLbl:Label;
		private var n_phDefRateLbl:Label;
		private var n_magicDegRateLbl:Label;
		private var n_hpRateLbl:Label;
		private var n_mpRateLbl:Label;

		private var needLbl:Label;
		private var itemIcon:Image;
		private var itemIcon0:Image;

		private var freeNumLbl:Label;

		private var fightLbl:Label;
		private var fightAddLbl:Label;

		private var phAttImg:Image;
		private var magicAttImg:Image;
		private var phDefImg:Image;
		private var magicDefImg:Image;
		private var hpImg:Image;
		private var mpImg:Image;
		private var fightImg:Image;

		private var checkBox0:RadioButton;
		private var checkBox1:RadioButton;
		private var checkBox2:RadioButton;

		private var oldArr:Array=[];
		private var oldRateArr:Array=[];

		private var newArr:Array=[];
		private var newRateArr:Array=[];
		private var newImgArr:Array=[];
		private var newDiffArr:Array=[];

		private var needArr:Array=[];

		private var dc:Object;

		private var checkBoxIndex:int=-1;

		private var propArrKey:Array=[4, 5, 1, 2];

		private var numArr:Array=[];

		private var finfo:TEquipInfo;

		private var powerNum:int=0;

		public function MountTradeWnd() {
			super(LibManager.getInstance().getXML("config/ui/mount/horseTradeWnd.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

			this.saveBtn=this.getUIbyID("saveBtn") as ImgLabelButton;
			this.tradeBtn=this.getUIbyID("tradeBtn") as ImgLabelButton;

			this.phAttLbl=this.getUIbyID("phAttLbl") as Label;
			this.phAttAddLbl=this.getUIbyID("phAttAddLbl") as Label;
			this.magicAttAddLbl=this.getUIbyID("magicAttAddLbl") as Label;
			this.phDefAddLbl=this.getUIbyID("phDefAddLbl") as Label;
			this.magicDefAddLbl=this.getUIbyID("magicDefAddLbl") as Label;
			this.hpAddLbl=this.getUIbyID("hpAddLbl") as Label;
			this.mpAddLbl=this.getUIbyID("mpAddLbl") as Label;
			this.magicAttLbl=this.getUIbyID("magicAttLbl") as Label;
			this.phDefLbl=this.getUIbyID("phDefLbl") as Label;
			this.magicDefLbl=this.getUIbyID("magicDefLbl") as Label;

			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;

			this.needLbl=this.getUIbyID("needLbl") as Label;
			this.itemIcon=this.getUIbyID("itemIcon") as Image;
			this.itemIcon0=this.getUIbyID("itemIcon0") as Image;

			this.n_phAttLbl=this.getUIbyID("n_phAttLbl") as Label;
			this.n_phAttAddLbl=this.getUIbyID("n_phAttAddLbl") as Label;
			this.n_magicAttAddLbl=this.getUIbyID("n_magicAttAddLbl") as Label;
			this.n_phDefAddLbl=this.getUIbyID("n_phDefAddLbl") as Label;
			this.n_magicDegAddLbl=this.getUIbyID("n_magicDegAddLbl") as Label;
			this.n_hpAddLbl=this.getUIbyID("n_hpAddLbl") as Label;
			this.n_mpAddLbl=this.getUIbyID("n_mpAddLbl") as Label;
			this.n_magicAttLbl=this.getUIbyID("n_magicAttLbl") as Label
			this.n_phDefLbl=this.getUIbyID("n_phDefLbl") as Label;
			this.n_magicDefLbl=this.getUIbyID("n_magicDefLbl") as Label;
			this.n_hpLbl=this.getUIbyID("n_hpLbl") as Label;
			this.n_mpLbl=this.getUIbyID("n_mpLbl") as Label;

			this.n_phAttRateLbl=this.getUIbyID("n_phAttRateLbl") as Label;
			this.n_magicAttRateLbl=this.getUIbyID("n_magicAttRateLbl") as Label;
			this.n_phDefRateLbl=this.getUIbyID("n_phDefRateLbl") as Label;
			this.n_magicDegRateLbl=this.getUIbyID("n_magicDegRateLbl") as Label;
			this.n_hpRateLbl=this.getUIbyID("n_hpRateLbl") as Label;
			this.n_mpRateLbl=this.getUIbyID("n_mpRateLbl") as Label;

			this.freeNumLbl=this.getUIbyID("freeNumLbl") as Label;

			this.fightLbl=this.getUIbyID("fightLbl") as Label;
			this.fightAddLbl=this.getUIbyID("fightAddLbl") as Label;

			this.phAttImg=this.getUIbyID("phAttImg") as Image;
			this.magicAttImg=this.getUIbyID("magicAttImg") as Image;
			this.phDefImg=this.getUIbyID("phDefImg") as Image;
			this.magicDefImg=this.getUIbyID("magicDefImg") as Image;
			this.hpImg=this.getUIbyID("hpImg") as Image;
			this.mpImg=this.getUIbyID("mpImg") as Image;
			this.fightImg=this.getUIbyID("fightImg") as Image;

			this.oldArr[PropUtils.getIndexByStr("物理攻击")]=this.phAttLbl;
//			this.oldArr[PropUtils.getIndexByStr("法术攻击")]=this.magicAttLbl;
			this.oldArr[PropUtils.getIndexByStr("物理防御")]=this.phDefLbl;
//			this.oldArr[PropUtils.getIndexByStr("法术防御")]=this.magicDefLbl;
			this.oldArr[PropUtils.getIndexByStr("生命上限")]=this.hpLbl;
//			this.oldArr[PropUtils.getIndexByStr("法力上限")]=this.mpLbl;

			this.oldRateArr[PropUtils.getIndexByStr("物理攻击")]=this.phAttAddLbl;
//			this.oldRateArr[PropUtils.getIndexByStr("法术攻击")]=this.magicAttAddLbl;
			this.oldRateArr[PropUtils.getIndexByStr("物理防御")]=this.phDefAddLbl;
//			this.oldRateArr[PropUtils.getIndexByStr("法术防御")]=this.magicDefAddLbl;
			this.oldRateArr[PropUtils.getIndexByStr("生命上限")]=this.hpAddLbl;
//			this.oldRateArr[PropUtils.getIndexByStr("法力上限")]=this.mpAddLbl;

			this.newArr[PropUtils.getIndexByStr("物理攻击")]=this.n_phAttLbl;
//			this.newArr[PropUtils.getIndexByStr("法术攻击")]=this.n_magicAttLbl;
			this.newArr[PropUtils.getIndexByStr("物理防御")]=this.n_phDefLbl;
//			this.newArr[PropUtils.getIndexByStr("法术防御")]=this.n_magicDefLbl;
			this.newArr[PropUtils.getIndexByStr("生命上限")]=this.n_hpLbl;
//			this.newArr[PropUtils.getIndexByStr("法力上限")]=this.n_mpLbl;

			this.newRateArr[PropUtils.getIndexByStr("物理攻击")]=this.n_phAttRateLbl;
//			this.newRateArr[PropUtils.getIndexByStr("法术攻击")]=this.n_magicAttRateLbl;
			this.newRateArr[PropUtils.getIndexByStr("物理防御")]=this.n_phDefRateLbl;
//			this.newRateArr[PropUtils.getIndexByStr("法术防御")]=this.n_magicDegRateLbl;
			this.newRateArr[PropUtils.getIndexByStr("生命上限")]=this.n_hpRateLbl;
//			this.newRateArr[PropUtils.getIndexByStr("法力上限")]=this.n_mpRateLbl;

			this.newDiffArr[PropUtils.getIndexByStr("物理攻击")]=this.n_phAttAddLbl;
//			this.newDiffArr[PropUtils.getIndexByStr("法术攻击")]=this.n_magicAttAddLbl;
			this.newDiffArr[PropUtils.getIndexByStr("物理防御")]=this.n_phDefAddLbl;
//			this.newDiffArr[PropUtils.getIndexByStr("法术防御")]=this.n_magicDegAddLbl;
			this.newDiffArr[PropUtils.getIndexByStr("生命上限")]=this.n_hpAddLbl;
//			this.newDiffArr[PropUtils.getIndexByStr("法力上限")]=this.n_mpAddLbl;

			this.newImgArr[PropUtils.getIndexByStr("物理攻击")]=this.phAttImg;
//			this.newImgArr[PropUtils.getIndexByStr("法术攻击")]=this.magicAttImg;
			this.newImgArr[PropUtils.getIndexByStr("物理防御")]=this.phDefImg;
//			this.newImgArr[PropUtils.getIndexByStr("法术防御")]=this.magicDefImg;
			this.newImgArr[PropUtils.getIndexByStr("生命上限")]=this.hpImg;
//			this.newImgArr[PropUtils.getIndexByStr("法力上限")]=this.mpImg;

			this.checkBox0=this.getUIbyID("checkBox0") as RadioButton;
			this.checkBox1=this.getUIbyID("checkBox1") as RadioButton;
			this.checkBox2=this.getUIbyID("checkBox2") as RadioButton;

			this.saveBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
			this.tradeBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);

			this.checkBox0.addEventListener(MouseEvent.CLICK, this.onCheckBoxClick);
			this.checkBox1.addEventListener(MouseEvent.CLICK, this.onCheckBoxClick);
			this.checkBox2.addEventListener(MouseEvent.CLICK, this.onCheckBoxClick);

			var lb:Label;
			for (var i:int=0; i < this.propArrKey.length; i++) {
				lb=this.getUIbyID("ntxt" + this.propArrKey[i]) as Label;
				if (lb != null)
					lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content);

				lb=this.getUIbyID("txt" + this.propArrKey[i]) as Label;
				if (lb != null)
					lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content);
			}

			this.checkBox0.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1141).content, [ConfigEnum.Mount7, ConfigEnum.Mount16]));
			this.checkBox1.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1142).content, [ConfigEnum.Mount14]));
			this.checkBox2.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(1143).content, [ConfigEnum.Mount15]));

			this.saveBtn.setToolTip(TableManager.getInstance().getSystemNotice(1138).content);
			this.tradeBtn.setToolTip(TableManager.getInstance().getSystemNotice(1137).content);

//			this.clsBtn.y=15;
			this.allowDrag=false;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.itemIcon, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTips0MouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.itemIcon0, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (this.checkBox0.isOn) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
			} else if (this.checkBox1.isOn || this.checkBox2.isOn) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
			}
		}

		private function onTips0MouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9556).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			UIManager.getInstance().roleWnd.setPos(2);
//
//			this.x=UIManager.getInstance().roleWnd.x + 489; // UIManager.getInstance().roleWnd.width;
//			this.y=UIManager.getInstance().roleWnd.y;

			this.checkBox0.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.saveBtn.setActive(false, .6, true);
		}

		/*按钮点击*/
		private function onBtnClick(evt:MouseEvent):void {

			this.saveBtn.setActive(false, .6, true);

			if (evt.target.name == "saveBtn") {
				Cmd_Mount.cmMouTradeSave();
			} else if (evt.target.name == "tradeBtn") {

				if (this.powerNum <= 0) {

					if (this.checkBox0.isOn) {
						Cmd_Mount.cmMouTrade(1);

						if (UIManager.getInstance().backpackWnd.jb >= int(this.needLbl.text) && Core.me.info.baseInfo.hunL >= ConfigEnum.Mount16)
							this.saveBtn.setActive(true, 1, true);
					} else if (this.checkBox1.isOn) {
						Cmd_Mount.cmMouTrade(2);

						if (UIManager.getInstance().backpackWnd.byb + UIManager.getInstance().backpackWnd.yb >= int(this.needLbl.text))
							this.saveBtn.setActive(true, 1, true);
					} else if (this.checkBox2.isOn) {
						Cmd_Mount.cmMouTrade(3);

						if (UIManager.getInstance().backpackWnd.byb + UIManager.getInstance().backpackWnd.yb >= int(this.needLbl.text))
							this.saveBtn.setActive(true, 1, true);
					}

				} else {

					PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(1150).content, function():void {
						if (checkBox0.isOn) {
							Cmd_Mount.cmMouTrade(1);

							if (UIManager.getInstance().backpackWnd.jb >= int(needLbl.text) && Core.me.info.baseInfo.hunL >= ConfigEnum.Mount16)
								saveBtn.setActive(true, 1, true);
						} else if (checkBox1.isOn) {
							Cmd_Mount.cmMouTrade(2);

							if (UIManager.getInstance().backpackWnd.byb + UIManager.getInstance().backpackWnd.yb >= int(needLbl.text))
								saveBtn.setActive(true, 1, true);
						} else if (checkBox2.isOn) {
							Cmd_Mount.cmMouTrade(3);

							if (UIManager.getInstance().backpackWnd.byb + UIManager.getInstance().backpackWnd.yb >= int(needLbl.text))
								saveBtn.setActive(true, 1, true);
						}
					}, function():void {
						saveBtn.setActive(true, 1, true);
					}, false, "mouseTradePowerTopConfirm");

				}
			}
		}

		public function setPropsData(o:Object):void {

			if (!o.hasOwnProperty("dc"))
				return;

			var num:Number=0;
			var count:int=0;
			var item:Object;
			for each (item in o.dc) {
				count++;
			}

			if (count == 6)
				this.dc=o.dc;

			var i:String;
			for (i in this.dc) {

				if (int(i) == 2 || int(i) == 6 || int(i) == 7)
					continue;

				//第一次
				if (count == 6) {

					
					this.setPropsItemData(int(i) - 1, o.dc[i]["r"], o.dc[i]["v"]);
					this.newImgArr[int(i) - 1].visible=false;
					this.newArr[int(i) - 1].textColor=0xffffff;
					this.newRateArr[int(i) - 1].visible=false;
					this.newArr[int(i) - 1].visible=false;
					this.newDiffArr[int(i) - 1].visible=false;

				} else {

					this.newArr[int(i) - 1].visible=true;

					//如果是最新
					if (o.dc.hasOwnProperty(i)) {
						this.newImgArr[int(i) - 1].visible=true;
						//this.oldRateArr[int(i) - 1].visible=true;
						this.newRateArr[int(i) - 1].visible=true;
						this.newDiffArr[int(i) - 1].visible=true;

						this.setNewPropsItemData(int(i) - 1, o.dc[i]["r"], o.dc[i]["v"]);

						num+=((int(o.dc[i]["v"]) - int(this.oldArr[int(i) - 1].text)) * TableManager.getInstance().getZdlElement(int(i)).rate);

					} else {

						this.newImgArr[int(i) - 1].visible=false;
//						this.oldRateArr[int(i) - 1].visible=false;
						//this.newRateArr[int(i) - 1].visible=false;
						this.newDiffArr[int(i) - 1].visible=false;
//						this.newArr[int(i) - 1].visible=false;

						this.newArr[int(i) - 1].textColor=0xffffff;
						this.newRateArr[int(i) - 1].textColor=0xffffff;

						this.newArr[int(i) - 1].text=this.dc[i]["v"];
						this.newRateArr[int(i) - 1].text=""; //(+" + (this.dc[i]["r"] / 100).toFixed(1) + "%)";
					}

				}

			}

			this.updateFigth(Math.round(num));

		}

		private function updateFigth(num:int):void {

			var img:Image;
			for each (img in this.numArr) {
				this.removeChild(img);
			}

			this.numArr.length=0;

			this.powerNum=num;

			var len:int=num.toString().length;
			var _x:Number=(306 - len * 16) >> 1;

			if (num < 0) {
				_x-=7;
			}

			for (var i:int=0; i < len; i++) {

				img=new Image();
				img.fillEmptyBmd();

//				if (num < 0) {
//					img.updateBmp("ui/num/" + num.toString().charAt(i) + "_red.png");
//				} else

				img.updateBmp("ui/num/" + num.toString().charAt(i) + "_zdl.png");

				img.y=fightLbl.y + 8;
				img.x=_x + i * 16;

				this.addChild(img);
				this.numArr.push(img);
			}

			img=new Image();
			img.fillEmptyBmd();
			this.addChild(img);
			this.numArr.push(img);

			img.y=fightLbl.y + 11;
			img.x=_x + i * 16 + 10;

			img.visible=(num != 0);

			if (num < 0) {
//				_x-=2;
				img.updateBmp("ui/equip/equip_arrow3.png");
//				img.x=_x;
//				_x-=3;

				img.y=fightLbl.y + 14;

			} else {
//				_x-=12;
				img.updateBmp("ui/equip/equip_arrow4.png");
//				img.x=_x;
//				_x+=12;
			}

		}

		/**
		 * 更新数据列表
		 * @param o
		 *
		 */
		public function updateData(o:Object, info:TEquipInfo=null):void {
			if (info != null)
				this.finfo=info;

			this.setPropsData(o);

			if (o.hasOwnProperty("ct")) {
				this.needArr=o.ct;
			}

			if (o.hasOwnProperty("fn")) {
//				this.freeNumLbl.text=o.fn + "";

				if (o.fn > 0)
					needLbl.text="0";
				else {
					if (this.checkBoxIndex == 0)
						needLbl.text=needArr[0];
				}
			}
		}

		private function setPropsItemData(i:int, r:int, v:int):void {

			this.oldArr[i].text=v;
			this.oldRateArr[i].text="(+" + (r / 100).toFixed(1) + "%)";

			if (r == 0)
				this.oldRateArr[i].visible=false;
			else
				this.oldRateArr[i].visible=true;

			//this.setNewPropsItemData(i, r, v);
		}

		private function setNewPropsItemData(i:int, r:int, v:Number):void {

			//var v:int=int(this.dc[i + 1]["v"]);
			this.newArr[i].text=v; //-int(this.oldArr[i].text); //Math.ceil(v + v * r / 10000);

			var or:int=int(String(this.oldRateArr[i].text).replace(/[\(\)\+\%]+/g, ""));
//			var cv:int=v + v * r / 10000 - int(this.oldArr[i].text);
			var cv:int=v - int(this.oldArr[i].text);

			if (r < 0) {
				this.newDiffArr[i].text=cv + "";
				this.newRateArr[i].text="(" + (r / 100).toFixed(1) + "%)";

				this.newArr[i].setTextFormat(FontEnum.getTextFormat("Red12"));
				this.newDiffArr[i].setTextFormat(FontEnum.getTextFormat("Red12"));
				this.newRateArr[i].setTextFormat(FontEnum.getTextFormat("Red12"));

				this.newImgArr[i].updateBmp("ui/equip/equip_arrow3.png");

			} else {

				this.newDiffArr[i].text="+" + cv;
				this.newRateArr[i].text="(+" + (r / 100).toFixed(1) + "%)";
				this.newImgArr[i].updateBmp("ui/equip/equip_arrow4.png")

				this.newArr[i].setTextFormat(FontEnum.getTextFormat("Green12"));
				this.newDiffArr[i].setTextFormat(FontEnum.getTextFormat("Green12"));
				this.newRateArr[i].setTextFormat(FontEnum.getTextFormat("Green12"));

			}

		}

		/**
		 * 交换属性
		 * @param o
		 *
		 */
		public function changeValue(o:Object):void {

			var key:String;
			for (key in o.dc) {
				this.dc[key]=o.dc[key];
			}

			o.dc=this.dc;
			this.setPropsData(o);
		}

		/*单选框的点击*/
		private function onCheckBoxClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "checkBox0":
//					if (int(this.freeNumLbl.text) > 0)
//						needLbl.text="0";
//					else
					needLbl.text=needArr[0];

					checkBoxIndex=0;
					itemIcon.updateBmp("ui/backpack/moneyIco.png");
					this.freeNumLbl.text="" + ConfigEnum.Mount16;
					this.itemIcon0.visible=true;
					break;
				case "checkBox1":
					needLbl.text=needArr[1];
					checkBoxIndex=1;
					itemIcon.updateBmp("ui/backpack/yuanbaoIco.png");
					this.freeNumLbl.text="";
					this.itemIcon0.visible=false;
					break;
				case "checkBox2":
					needLbl.text=needArr[2];
					checkBoxIndex=2;
					itemIcon.updateBmp("ui/backpack/yuanbaoIco.png");
					this.freeNumLbl.text="";
					this.itemIcon0.visible=false;
					break;
			}
		}

		override public function hide():void {
			super.hide();

			PopupManager.closeConfirm("mouseTradePowerTopConfirm");
			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
		}

		override public function get width():Number {
			return 288;
		}
		
		override public function get height():Number {
			return 544;
		}

	}
}

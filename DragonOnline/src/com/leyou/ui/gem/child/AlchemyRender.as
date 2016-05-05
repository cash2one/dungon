package com.leyou.ui.gem.child {
	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAlchemy;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Alchemy;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;

	public class AlchemyRender extends AutoSprite {

		private var succImg:Image;
		private var itemImg:Image;
		private var ybImg:Image;
		private var goldImg:Image;

		private var nameLbl:Label;
		private var moneyLbl:Label;
		private var costLbl:Label;
		private var buyLbl:Label;

		private var succLbl:Label;
		private var rateLbl:Label;

		private var itemCb:CheckBox;
		private var ybCb:CheckBox;

		private var reduceBtn:ImgButton;
		private var addBtn:ImgButton;
		private var maxBtn:NormalButton;

		private var compoundBtn:NormalButton;

		private var numInput:TextInput;

		private var currentid:int=1;
		public var currentCount:int=1;
		public var currentMaxCount:int=1;

		private var renderArr:Array=[];

		private var gridArr:Array=[];
		private var gridSuccEffectArr:Array=[];
		private var gridFaildEffectArr:Array=[];
//		private var grid:GemGrid;

		private var itemGridArr:Array=[];
		private var itemGridEffectArr:Array=[];

		private var item1grid:GemGrid;
		private var item2grid:GemGrid;
		private var item3grid:GemGrid;

		private var succEffect:SwfLoader;
		private var targetEffect:SwfLoader;

		private var costEffect1:SwfLoader;
		private var costEffect2:SwfLoader;
		private var costEffect3:SwfLoader;

		private var moneyNum:int=0;

		private var succeffImg:Image;
		private var faileffImg:Image;
		private var numArr:Array=[];

		private var rate:int=0;
		private var tlv:int=0;


		public function AlchemyRender() {
			super(LibManager.getInstance().getXML("config/ui/gem/alchemyRender.xml"));
			this.init();

			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.succImg=this.getUIbyID("succImg") as Image;
			this.itemImg=this.getUIbyID("itemImg") as Image;
			this.ybImg=this.getUIbyID("ybImg") as Image;
			this.goldImg=this.getUIbyID("goldImg") as Image;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.costLbl=this.getUIbyID("costLbl") as Label;

			this.succLbl=this.getUIbyID("succLbl") as Label;
			this.rateLbl=this.getUIbyID("rateLbl") as Label;
			//			this.buyLbl=this.getUIbyID("buyLbl") as Label;

			this.itemCb=this.getUIbyID("itemCb") as CheckBox;
			this.ybCb=this.getUIbyID("ybCb") as CheckBox;

			this.reduceBtn=this.getUIbyID("reduceBtn") as ImgButton;
			this.addBtn=this.getUIbyID("addBtn") as ImgButton;
			this.maxBtn=this.getUIbyID("maxBtn") as NormalButton;

			this.compoundBtn=this.getUIbyID("compoundBtn") as NormalButton;
			this.numInput=this.getUIbyID("numInput") as TextInput;

			this.numInput.input.autoSize=TextFieldAutoSize.CENTER;
			this.numInput.input.restrict="0-9";

			this.itemCb.addEventListener(MouseEvent.CLICK, onClick);
			this.ybCb.addEventListener(MouseEvent.CLICK, onClick);

			this.numInput.addEventListener(Event.CHANGE, onChange);
			this.maxBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.compoundBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.reduceBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addBtn.addEventListener(MouseEvent.CLICK, onClick);

			//			this.buyLbl.addEventListener(MouseEvent.CLICK, onClick);
			//			this.buyLbl.mouseEnabled=true;


//			this.grid=new GemGrid();
//			this.addChild(this.grid);
//			this.grid.x=295;
//			this.grid.y=165;
//
//			this.grid.setSize(60, 60);

			var itemg:GemGrid;
			var costEffect:SwfLoader;
			var grid:GemGrid;

			for (var i:int=0; i < 5; i++) {
				itemg=new GemGrid();
				this.addChild(itemg);

				itemg.setBgBmp(1);
				itemg.y=271;

				this.itemGridArr.push(itemg);
				itemg.visible=false;

				costEffect=new SwfLoader(99907);
				this.addChild(costEffect);
				costEffect.y=itemg.y;

				costEffect.visible=false;
				this.itemGridEffectArr.push(costEffect);

				if (i < 3) {
					grid=new GemGrid();
					this.addChild(grid);
					grid.x=48.5;
					grid.y=80;

					grid.setBgBmp(2);
					grid.setSize(60, 60);

					this.gridArr.push(grid);

				}

			}

			succEffect=new SwfLoader(99908);
			this.addChild(succEffect);
			succEffect.x=grid.x - 14;
			succEffect.y=grid.y - 14;

			succEffect.visible=false;

//			this.gridSuccEffectArr.push(succEffect);

			targetEffect=new SwfLoader(99908);
			this.addChild(targetEffect);
			targetEffect.x=grid.x - 14;
			targetEffect.y=grid.y - 14;

			targetEffect.visible=false;

//			this.gridFaildEffectArr.push(targetEffect);

			var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.Gem5);

			this.itemImg.updateBmp("ico/items/" + tinfo.icon + ".png");
			this.itemImg.setWH(20, 20);

			this.itemCb.text="    ×1 100% " + PropUtils.getStringById(1719);
			this.ybCb.text="    ×1 100% " + PropUtils.getStringById(1719);

			var einfo1:MouseEventInfo;

			einfo1=new MouseEventInfo();
			einfo1.onMouseMove=onMouseOver;
			einfo1.onMouseOut=onMouseOut;

			MouseManagerII.getInstance().addEvents(this.itemImg, einfo1);

			einfo1=new MouseEventInfo();
			einfo1.onMouseMove=onMouseOver;
			einfo1.onMouseOut=onMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybImg, einfo1);

			einfo1=new MouseEventInfo();
			einfo1.onMouseMove=onMouseOver;
			einfo1.onMouseOut=onMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo1);

			this.succeffImg=new Image("ui/gem/font_hccz.png");
			this.faileffImg=new Image("ui/gem/font_hcsb.png");


			this.numArr[0]=new Image("ui/num/equip_0.png");
			this.numArr[1]=new Image("ui/num/equip_1.png");
			this.numArr[2]=new Image("ui/num/equip_2.png");
			this.numArr[3]=new Image("ui/num/equip_3.png");
			this.numArr[4]=new Image("ui/num/equip_4.png");
			this.numArr[5]=new Image("ui/num/equip_5.png");
			this.numArr[6]=new Image("ui/num/equip_6.png");
			this.numArr[7]=new Image("ui/num/equip_7.png");
			this.numArr[8]=new Image("ui/num/equip_8.png");
			this.numArr[9]=new Image("ui/num/equip_9.png");

		}

		private function onMouseOver(e:DisplayObject):void {
			if (this.itemImg == e) {
				var tips:TipsInfo=new TipsInfo();
				tips.itemid=ConfigEnum.Gem5;
				tips.isShowPrice=false;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
			} else if (this.ybImg == e) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
			} else if (this.goldImg == e) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
			}

		}

		private function onMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onTreeClick(e:MouseEvent):void {

			if (!(e.target.parent is GembtnWnd))
				return;

			this.currentid=e.target.parent.getID();

			this.setItemsSelectItem();
			e.target.parent.setSelectState(true);

			this.currentCount=1;
//			this.updateSelectInfo();

		}

		private function onChange(e:Event):void {

			this.currentCount=int(this.numInput.text);

			if (this.currentCount < 1)
				this.currentCount=1;

			if (this.currentCount >= this.currentMaxCount) {
				this.currentCount=this.currentMaxCount;
				this.numInput.text="" + this.currentCount;
			}

			this.moneyLbl.text=(this.moneyNum * this.currentCount) + "";

			this.itemCb.text="    ×" + (this.rate * this.currentCount) + " 100% " + PropUtils.getStringById(1719);
			this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.rate * this.currentCount) + " 100% " + PropUtils.getStringById(1719);

		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "reduceBtn":
					this.currentCount--;
					if (this.currentCount < 1)
						this.currentCount=1;

					break;
				case "addBtn":
					this.currentCount++

					if (this.currentCount >= this.currentMaxCount)
						this.currentCount=this.currentMaxCount;

					break;
				case "maxBtn":
					this.currentCount=this.currentMaxCount;

					//					this.moneyLbl.text=(this.moneyNum * this.currentCount) + "";
					//					this.numInput.text="" + this.currentCount;
					//
					//					this.itemCb.text="    ×" + (ConfigEnum.Gem4 * this.currentCount) + " 100% 成功";
					//					this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.currentCount) + " 100% 成功";
					break;
				case "compoundBtn":
					if (this.currentid != -1 && this.currentCount >= 1) {
						GuideArrowDirectManager.getInstance().delArrow(WindowEnum.GEM_LV+"");
						
//						Cmd_Gem.cmGemCompound(this.currentid, (this.itemCb.isOn ? 1 : (this.ybCb.isOn ? 2 : 0)), this.currentCount);
						Cmd_Alchemy.cmljNow(currentid, (this.itemCb.isOn ? 1 : (this.ybCb.isOn ? 2 : 0)), this.currentCount);

						for (var i:int=0; i < 5; i++) {
							if (this.itemGridArr[i].visible) {
								this.itemGridEffectArr[i].visible=true;
//								this.itemGridEffectArr[i].update(99907);
								this.itemGridEffectArr[i].playAct(PlayerEnum.ACT_STAND, -1, false, stopplay22);
							}
						}

					}
					break;
				case "buyLbl":
//					UILayoutManager.getInstance().open(WindowEnum.MYSTORE);
					break;
				case "itemCb":
					this.ybCb.turnOff();
					break;
				case "ybCb":
					this.itemCb.turnOff();
					break;

			}

			var tinfo:TAlchemy=TableManager.getInstance().getGemByID(currentid);
			if (tinfo == null)
				return;

			if (this.ybCb.visible) {
				if (this.ybCb.isOn || this.itemCb.isOn)
					this.rateLbl.text="100%";
				else
					this.rateLbl.text="" + (tinfo.Al_Rate / 100) + "%";
			}

			this.itemCb.text="    ×" + (tinfo.AlKey_Num * this.currentCount) + " 100% " + PropUtils.getStringById(1719);
			this.ybCb.text="    ×" + (tinfo.Al_Yb * this.currentCount) + " 100% " + PropUtils.getStringById(1719);


			if (tinfo.Al_Cost > 0) {

				if (UIManager.getInstance().backpackWnd.jb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Al_soul > 0) {

				if (Core.me.info.baseInfo.hunL < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Cost_byb > 0) {

				if (UIManager.getInstance().backpackWnd.byb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Cost_yb > 0) {

				if (UIManager.getInstance().backpackWnd.yb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			}

			this.moneyLbl.text=(this.moneyNum * this.currentCount) + "";
			this.numInput.text="" + this.currentCount;

		}

		private function stopplay22():void {
			for (var i:int=0; i < 5; i++) {
				this.itemGridEffectArr[i].visible=false;
			}
		}

		public function updateSelectInfo(cid:int):void {

			this.currentid=cid;
			this.currentMaxCount=0;
			this.currentCount=1;

			var tinfo:TAlchemy=TableManager.getInstance().getGemByID(cid);
			if (tinfo == null)
				return;

			var keyid:Array=[];
			var valId:Array=[];
			var arr:Array=[];
			var num:int=int.MAX_VALUE;
			var d:int=0;
			for (var i:int=0; i < 5; i++) {
				if (tinfo["Datum" + (i + 1)] > 0) {

					d=MyInfoManager.getInstance().getBagItemNumById(tinfo["Datum" + (i + 1)]);
					if (d < int(tinfo["Datum_Num" + (i + 1)]) || (arr.indexOf(tinfo["Datum" + (i + 1)]) > -1 && d - this.IsRepeatNum(tinfo["Datum" + (i + 1)], keyid) < int(tinfo["Datum_Num" + (i + 1)]))) {
						this.currentMaxCount=0;
						break;
					} else {
						if (d < num) {
							num=d;

							this.currentMaxCount=Math.floor(num / int(tinfo["Datum_Num" + (i + 1)]));
						}
					}

					keyid[tinfo["Datum" + (i + 1)]]=(int(tinfo["Datum_Num" + (i + 1)]));
					arr.push(tinfo["Datum" + (i + 1)]);
				}
			}

			this.addBtn.setActive(false, .6, true);
			this.reduceBtn.setActive(false, .6, true);
			this.compoundBtn.setActive(false, .6, true);
			this.maxBtn.setActive(false, .6, true);
			this.numInput.mouseChildren=false;

			this.ybCb.turnOff();
			this.itemCb.turnOff();

			this.setItemGrid(tinfo);
			num=this.setTargetGrid(tinfo);

			this.ybCb.visible=this.ybImg.visible=(tinfo.Al_Yb > 0);
			this.itemCb.visible=this.itemImg.visible=(tinfo.Al_Key > 0);

			if (tinfo.Al_RateFont != null && tinfo.Al_RateFont != "") {
				this.rateLbl.text="" + tinfo.Al_RateFont;
			} else {
				this.rateLbl.text="" + (tinfo.Al_Rate / 100) + "%";
			}

			this.moneyLbl.visible=true;
			this.goldImg.visible=true;
			this.costLbl.visible=true;

			if (tinfo.Al_Cost > 0) {
				this.costLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2210), [PropUtils.getStringEasyById(32)]);
				this.moneyNum=tinfo.Al_Cost;
				this.goldImg.updateBmp(ItemUtil.getExchangeIcon(0));

				if (UIManager.getInstance().backpackWnd.jb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Al_soul > 0) {
				this.costLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2210), [PropUtils.getStringEasyById(29)]);
				this.moneyNum=tinfo.Al_soul;
				this.goldImg.updateBmp(ItemUtil.getExchangeIcon(3));

				if (Core.me.info.baseInfo.hunL < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Cost_byb > 0) {
				this.costLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2210), [PropUtils.getStringEasyById(33)]);
				this.moneyNum=tinfo.Cost_byb;
				this.goldImg.updateBmp(ItemUtil.getExchangeIcon(1));

				if (UIManager.getInstance().backpackWnd.byb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else if (tinfo.Cost_yb > 0) {
				this.costLbl.text="" + StringUtil.substitute(PropUtils.getStringById(2210), [PropUtils.getStringEasyById(40)]);
				this.moneyNum=tinfo.Cost_yb;
				this.goldImg.updateBmp(ItemUtil.getExchangeIcon(2));

				if (UIManager.getInstance().backpackWnd.yb < int(this.moneyNum * this.currentCount)) {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				} else {
					this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
				}

			} else {
				this.moneyLbl.visible=false;
				this.goldImg.visible=false;
				this.costLbl.visible=false;
			}

			this.numInput.text="" + this.currentCount;
			this.moneyLbl.text="" + this.moneyNum;

			if (num > 3) {
				var itemInfo:Object;
				if (num > 10000)
					itemInfo=TableManager.getInstance().getItemInfo(num);
				else
					itemInfo=TableManager.getInstance().getEquipInfo(num);

				this.nameLbl.text="" + itemInfo.name;
				this.nameLbl.textColor=ItemUtil.getColorByQuality(itemInfo.quality);
			} else {
				this.nameLbl.text="" + PropUtils.getStringById(2198);
				this.nameLbl.defaultTextFormat=FontEnum.getTextFormat("Green24Center");
			}

//			this.rate=ConfigEnum.Gem4.split("|")[tinfo.level - 2];

//			this.itemCb.text="    ×" + (this.rate * this.currentCount) + " 100% " + PropUtils.getStringById(1719);
//			this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.rate * this.currentCount) + " 100% " + PropUtils.getStringById(1719);
			this.itemCb.text="    ×" + (tinfo.AlKey_Num * this.currentCount) + " 100% " + PropUtils.getStringById(1719);
			this.ybCb.text="    ×" + (tinfo.Al_Yb * this.currentCount) + " 100% " + PropUtils.getStringById(1719);

			if (this.currentMaxCount < 1)
				return;

			this.compoundBtn.setActive(true, 1, true);

			if (tinfo.Al_Type != 5 && tinfo.Al_Type != 6) {
				this.addBtn.setActive(true, 1, true);
				this.reduceBtn.setActive(true, 1, true);

				this.maxBtn.setActive(true, 1, true);
				this.numInput.mouseChildren=true;
			}
		}

		private function IsRepeatNum(sid:int, arr:Array):int {

			var num:int=0;
			var i:String;
			for (i in arr) {
				if (int(i) == sid) {
					num+=int(arr[i]);
				}
			}

			return num;
		}

		private function setItemGrid(tinfo:TAlchemy):void {

			this.tlv=0;

			var cx:int=23;
			var i:int=0;
			var num:int=0;

			for (i=0; i < 5; i++) {
				if (tinfo["Datum" + (i + 1)] == 0) {
					num=i;
					break;
				}
			}

			cx=23 + (70 * 5 - 70 * num) / 2;

			for (i=0; i < num; i++) {
				this.itemGridArr[i].visible=true;

				if (tinfo["Datum" + (i + 1)] > 10000)
					this.itemGridArr[i].updataInfo(TableManager.getInstance().getItemInfo(tinfo["Datum" + (i + 1)]));
				else
					this.itemGridArr[i].updataInfo(TableManager.getInstance().getEquipInfo(tinfo["Datum" + (i + 1)]));

				this.itemGridArr[i].setBgBmp(1);

				if (tinfo["Datum" + (i + 1)] < 10000) {
					this.tlv=MyInfoManager.getInstance().getBagItemStrengLvById(tinfo["Datum" + (i + 1)]);
					if (this.tlv > 0)
						this.itemGridArr[i].setIntensify(this.tlv + "");
				}

				this.itemGridArr[i].setNum(MyInfoManager.getInstance().getBagItemNumById(tinfo["Datum" + (i + 1)]) + "/" + tinfo["Datum_Num" + (i + 1)]);
				this.itemGridArr[i].x=cx + 70 * i;
				this.itemGridEffectArr[i].x=cx + 70 * i;
			}


			while (i < 5) {
				this.itemGridArr[i].visible=false;
				i++;
			}

		}

		private function setTargetGrid(tinfo:TAlchemy):int {
			var cx:Number=48.5;
			var i:int=0;
			var num:int=0;

			for (i=0; i < 3; i++) {
				if (tinfo["Product" + (i + 1)] == 0) {
					num=i;
					break;
				}
			}

			cx=48.5 + (97.5 * 3 - 97.5 * num) / 2;

			for (i=0; i < 3; i++) {
				this.gridArr[i].visible=true;

				if (tinfo["Product" + (i + 1)] > 0) {
					if (tinfo["Product" + (i + 1)] > 10000)
						this.gridArr[i].updataInfo(TableManager.getInstance().getItemInfo(tinfo["Product" + (i + 1)]));
					else
						this.gridArr[i].updataInfo(TableManager.getInstance().getEquipInfo(tinfo["Product" + (i + 1)]));

					this.gridArr[i].setBgBmp(2);

					if (tinfo["Product" + (i + 1)] < 10000) {
						if (this.tlv > 0)
							this.gridArr[i].setIntensify(this.tlv + "");
					}

					this.gridArr[i].tinfo=tinfo;

					if (tinfo["Product" + (i + 1) + "_Num"] > 1)
						this.gridArr[i].setDaNum("" + tinfo["Product" + (i + 1) + "_Num"]);
					else
						this.gridArr[i].setDaNum("");

					this.gridArr[i].x=cx + 97.5 * i;
				} else {
					this.gridArr[i].visible=false;
				}
			}

			if (num == 1)
				return tinfo.Product1;
			else
				return num;

		}

		public function updateInfo(o:Object):void {

			function stopplay2():void {
				succEffect.visible=false;
			}

			if (o.success == 1 && o.lose == 0) {

				this.succEffect.visible=true;
				this.succEffect.update(99960);
				this.succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);

			} else if (o.success == 0 && o.lose == 1) {

				this.succEffect.visible=true;
				this.succEffect.update(99961);
				this.succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);

			} else {

				if (o.success > 0)
					EffectUtil.flyWordEffect(StringUtil.substitute(TableManager.getInstance().getSystemNotice(6407).content, [o.success]), new Point(this.stage.mouseX, this.stage.mouseY));

				if (o.lose > 0) {
					TweenLite.delayedCall(0.5, EffectUtil.flyWordEffect, [StringUtil.substitute(TableManager.getInstance().getSystemNotice(6408).content, [o.lose]), new Point(this.stage.mouseX, this.stage.mouseY)]);
				}

			}

			if (o.success > 0) {
				var arr:Array=o.hitem;

				var itemArr:Array=[];
				var itemPointArr:Array=[];
				var itemSizeArr:Array=[];
				for (var i:int=0; i < this.gridArr.length; i++) {
					for (var j:int=0; j < arr.length; j++)
//						for (var k:int=0; k < arr[j][1]; k++) {
						if (this.gridArr[i].visible && this.gridArr[i].getItemID() == arr[j][0]) {
							itemArr.push(arr[j][0]);
							itemPointArr.push(this.gridArr[i].parent.localToGlobal(new Point(this.gridArr[i].x - 30, this.gridArr[i].y + 30)));
							itemSizeArr.push([60, 60]);
						}
//						}
				}

				FlyManager.getInstance().flyBags(itemArr, itemPointArr, itemSizeArr);

			}


			this.currentCount=1;

			//			this.updateList();
			this.updateSelectInfo(this.currentid);


			//
			//				if (this.currentid != -1 && this.currentCount >= 1)
			//					Cmd_Gem.cmGemCompound(this.currentid, (this.itemCb.isOn ? 1 : (this.ybCb.isOn ? 2 : 0)));


		}

//		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
//			super.show(toTop, $layer, toCenter);
//
//			this.updateList();
//			this.renderArr[0].getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//		}
//
//		public function updateList():void {
//
//			for (var i:int=0; i < renderArr.length; i++) {
//				this.renderArr[i].updateInfo(TableManager.getInstance().getEquipInfo(this.renderArr[i].getID()));
//			}
//		}

		private function setItemsSelectItem():void {
			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].setSelectState(false);
			}
		}

		public function clearData():void {
			this.moneyLbl.text="";

//			this.grid.reseGrid();

			this.item1grid.reseGrid();
			this.item2grid.reseGrid();
			this.item3grid.reseGrid();

			this.currentCount=1;
			this.numInput.text="1";

			this.nameLbl.text="";

		}

	}
}

package com.leyou.ui.gem {


	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.FlyManager;
	import com.ace.ui.accordion.Accordion;
	import com.ace.ui.auto.AutoWindow;
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
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.ui.gem.child.GemGrid;
	import com.leyou.ui.gem.child.GembtnWnd;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	public class GemLvUpWnd extends AutoWindow {

		private var succImg:Image;
		private var itemImg:Image;
		private var ybImg:Image;
		private var goldImg:Image;

		private var nameLbl:Label;
		private var moneyLbl:Label;
		private var buyLbl:Label;

		private var itemCb:CheckBox;
		private var ybCb:CheckBox;

		private var reduceBtn:ImgButton;
		private var addBtn:ImgButton;
		private var maxBtn:NormalButton;

		private var compoundBtn:NormalButton;

		private var numInput:TextInput;

		private var accordMenu:Accordion;

		private var currentid:int=1;
		private var currentCount:int=1;
		private var currentMaxCount:int=1;

		private var renderArr:Array=[];

		private var grid:GemGrid;

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

		public function GemLvUpWnd() {
			super(LibManager.getInstance().getXML("config/ui/gem/gemLvUpWnd.xml"));
			this.init();
			this.hideBg();
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
			this.buyLbl=this.getUIbyID("buyLbl") as Label;

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
			this.buyLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.buyLbl.mouseEnabled=true;

			this.accordMenu=new Accordion(180, 430);
			this.addChild(this.accordMenu);
			this.accordMenu.x=5;
			this.accordMenu.y=20;

			var items:Array=TableManager.getInstance().getEquipListArrByClass(10);
			items.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var data1:Array=[];
			var data2:Array=[];
			var data3:Array=[];

			var render:GembtnWnd;

			for (var i:int=0; i < items.length; i++) {

				if (items[i].level == 1)
					continue;

				render=new GembtnWnd();
				render.updateInfo(items[i]);

				switch (items[i].subclassid) {
					case 1:
						data1.push(render);
						break;
					case 2:
						data2.push(render);
						break;
					case 3:
						data3.push(render);
						break;
				}

				this.renderArr.push(render);
			}

			this.accordMenu.addItem("攻击宝石", "", data1);
			this.accordMenu.addItem("防御宝石", "", data2);
			this.accordMenu.addItem("生命宝石", "", data3);

			this.accordMenu.addEventListener(MouseEvent.CLICK, onTreeClick);

			this.accordMenu.y=70;
			this.accordMenu.x=13;

			this.grid=new GemGrid();
			this.addChild(this.grid);
			this.grid.x=295;
			this.grid.y=165;

			this.grid.setSize(60, 60);

			this.item1grid=new GemGrid();
			this.addChild(this.item1grid);
			this.item1grid.x=243;
			this.item1grid.y=288;

			this.item2grid=new GemGrid();
			this.addChild(this.item2grid);
			this.item2grid.x=311;
			this.item2grid.y=288;

			this.item3grid=new GemGrid();
			this.addChild(this.item3grid);
			this.item3grid.x=377;
			this.item3grid.y=288;

			var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.Gem5);

			this.itemImg.updateBmp("ico/items/" + tinfo.icon + ".png");
			this.itemImg.setWH(20, 20);

			this.itemCb.text="    ×1 100% 成功";
			this.ybCb.text="    ×1 100% 成功";

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

			this.succEffect=new SwfLoader(99908);
			this.addChild(this.succEffect);
			this.succEffect.x=this.grid.x - 14;
			this.succEffect.y=this.grid.y - 14;

			this.succEffect.visible=false;

			this.targetEffect=new SwfLoader(99908);
			this.addChild(this.targetEffect);
			this.targetEffect.x=this.grid.x - 14;
			this.targetEffect.y=this.grid.y - 14;

			this.targetEffect.visible=false;

			this.costEffect1=new SwfLoader(99907);
			this.addChild(this.costEffect1);
			this.costEffect1.x=this.item1grid.x; // + 20;
			this.costEffect1.y=this.item1grid.y; // + 20;

			this.costEffect1.visible=false;

			this.costEffect2=new SwfLoader(99907);
			this.addChild(this.costEffect2);
			this.costEffect2.x=this.item2grid.x; // + 20;
			this.costEffect2.y=this.item2grid.y; // + 20;

			this.costEffect2.visible=false;

			this.costEffect3=new SwfLoader(99907);
			this.addChild(this.costEffect3);
			this.costEffect3.x=this.item3grid.x; // + 20;
			this.costEffect3.y=this.item3grid.y; // + 20;

			this.costEffect3.visible=false;

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

			
			this.clsBtn.y+=18;
			this.allowDrag=false;
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
			this.updateSelectInfo();

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

			this.itemCb.text="    ×" + (this.rate * this.currentCount) + " 100% 成功";
			this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.rate * this.currentCount) + " 100% 成功";

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
					if (this.currentid != -1 && this.currentCount >= 1)
						Cmd_Gem.cmGemCompound(this.currentid, (this.itemCb.isOn ? 1 : (this.ybCb.isOn ? 2 : 0)), this.currentCount);

					break;
				case "buyLbl":
					UILayoutManager.getInstance().open(WindowEnum.MYSTORE);
					break;
				case "itemCb":
					this.ybCb.turnOff();
					break;
				case "ybCb":
					this.itemCb.turnOff();
					break;

			}

			if (this.ybCb.isOn || this.itemCb.isOn)
				this.succImg.updateBmp("ui/gem/font_cgl100.png");
			else
				this.succImg.updateBmp("ui/gem/font_cgl75.png");

			if (UIManager.getInstance().backpackWnd.jb < int(this.moneyNum * this.currentCount)) {
				this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
			} else {
				this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
			}

			this.moneyLbl.text=(this.moneyNum * this.currentCount) + "";
			this.numInput.text="" + this.currentCount;

			this.itemCb.text="    ×" + (this.rate * this.currentCount) + " 100% 成功";
			this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.rate * this.currentCount) + " 100% 成功";
		}

		private function updateSelectInfo():void {

			var tinfo:TEquipInfo=TableManager.getInstance().getEquipInfo(this.currentid);
			if (tinfo == null || tinfo.level == 1)
				return;

			var count:int=MyInfoManager.getInstance().getBagItemNumById(tinfo.StoneUp_Need);

			this.currentMaxCount=Math.floor(count / 3);

			this.addBtn.setActive(false, .6, true);
			this.reduceBtn.setActive(false, .6, true);
			this.compoundBtn.setActive(false, .6, true);
			this.maxBtn.setActive(false, .6, true);
			this.numInput.mouseChildren=false;

			this.grid.updataInfo(tinfo);

			this.item1grid.updataInfo(TableManager.getInstance().getEquipInfo(tinfo.StoneUp_Need));
			this.item2grid.updataInfo(TableManager.getInstance().getEquipInfo(tinfo.StoneUp_Need));
			this.item3grid.updataInfo(TableManager.getInstance().getEquipInfo(tinfo.StoneUp_Need));

			if (count >= 3) {
				this.item1grid.filters=[];
				this.item2grid.filters=[];
				this.item3grid.filters=[];
			} else {
				for (var i:int=0; i < 3; i++) {
					if (i < count) {
						this["item" + (i + 1) + "grid"].filters=[];
					} else {
						this["item" + (i + 1) + "grid"].filters=[FilterUtil.enablefilter];
					}
				}
			}

			this.moneyNum=tinfo.StoneUp_speed;

			if (UIManager.getInstance().backpackWnd.jb < int(this.moneyNum * this.currentCount)) {
				this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
			} else {
				this.moneyLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");
			}

			this.numInput.text="" + this.currentCount;
			this.moneyLbl.text="" + tinfo.StoneUp_speed;

			this.nameLbl.text="" + tinfo.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(tinfo.quality);

			this.rate=ConfigEnum.Gem4.split("|")[tinfo.level - 2];

			this.itemCb.text="    ×" + (this.rate * this.currentCount) + " 100% 成功";
			this.ybCb.text="    ×" + (ConfigEnum.Gem7 * this.rate * this.currentCount) + " 100% 成功";

			if (this.currentMaxCount < 1)
				return;


			this.addBtn.setActive(true, 1, true);
			this.reduceBtn.setActive(true, 1, true);
			this.compoundBtn.setActive(true, 1, true);
			this.maxBtn.setActive(true, 1, true);
			this.numInput.mouseChildren=true;
		}

		public function updateInfo(o:Object):void {


			function stopplay2():void {
				succEffect.visible=false;
			}



			if (o.success == 1 && o.lose == 0) {
				this.succEffect.visible=true;
				this.succEffect.update(99960);
				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);
			} else if (o.success == 0 && o.lose == 1) {
				this.succEffect.visible=true;

				this.succEffect.update(99961);
				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);
			} else {

				if (o.success > 0)
					EffectUtil.flyWordEffect(StringUtil.substitute(TableManager.getInstance().getSystemNotice(6405).content, [o.success]), new Point(this.stage.mouseX, this.stage.mouseY));

				if (o.lose > 0)
					EffectUtil.flyWordEffect(StringUtil.substitute(TableManager.getInstance().getSystemNotice(6404).content, [o.lose]), new Point(this.stage.mouseX, this.stage.mouseY));

//				if (o.success > 0) {
//					var sImg:Image=new Image();
//					sImg.bitmapData=this.succeffImg.bitmapData;
//
//					sImg.bitmapData.copyPixels(this.numArr[(o.success)-1].bitmapData,new Rectangle(0,0,10,11),new Point(130,10));
//					
//					EffectUtil.flyImageEffect(sImg, new Point(this.stage.mouseX, this.stage.mouseY));
//				}
//
//				if (o.lose > 0) {
//					var fImg:Image=new Image();
//					fImg.bitmapData=this.faileffImg.bitmapData;
//					
//					fImg.bitmapData.copyPixels(this.numArr[(o.lose)-1].bitmapData,new Rectangle(0,0,10,11),new Point(130,10));
//					
//					EffectUtil.flyImageEffect(fImg, new Point(this.stage.mouseX, this.stage.mouseY));
//				}

			}

			if (o.success > 0) {
				FlyManager.getInstance().flyBags([this.grid.getItemID()], [this.grid.parent.localToGlobal(new Point(this.grid.x - 30, this.grid.y + 30))], [[60, 60]]);
			}

			this.targetEffect.visible=true;

			targetEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
				targetEffect.visible=false;
			});

			this.costEffect1.visible=true;

			costEffect1.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
				costEffect1.visible=false;
			});

			this.costEffect2.visible=true;

			costEffect2.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
				costEffect2.visible=false;
			});

			this.costEffect3.visible=true;

			costEffect3.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
				costEffect3.visible=false;
			});


			this.currentCount=1;

			this.updateList();
			this.updateSelectInfo();


//
//				if (this.currentid != -1 && this.currentCount >= 1)
//					Cmd_Gem.cmGemCompound(this.currentid, (this.itemCb.isOn ? 1 : (this.ybCb.isOn ? 2 : 0)));


		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.updateList();
			this.renderArr[0].getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function updateList():void {

			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].updateInfo(TableManager.getInstance().getEquipInfo(this.renderArr[i].getID()));
			}
		}

		private function setItemsSelectItem():void {
			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].setSelectState(false);
			}
		}

		public function clearData():void {
			this.moneyLbl.text="";

			this.grid.reseGrid();

			this.item1grid.reseGrid();
			this.item2grid.reseGrid();
			this.item3grid.reseGrid();

			this.currentCount=1;
			this.numInput.text="1";

			this.nameLbl.text="";

		}

		override public function get width():Number {
			return 478;
		}

		override public function get height():Number {
			return 524;
		}

		override public function hide():void {
			super.hide();

			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
		}

	}
}

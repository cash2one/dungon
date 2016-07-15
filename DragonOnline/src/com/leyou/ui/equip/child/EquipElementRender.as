package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementTrans;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Element;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class EquipElementRender extends AutoSprite {

		private var ruleLbl:Label;

		private var confirmBtn:ImgButton;

		private var itemLbl:Label;
		private var moneyLbl:Label;
		private var moneyImg:Image;

		private var changeRd:RadioButton;
		private var restRd:RadioButton;

		private var txtLblArr:Array=[];

		private var grid:EquipStrengGrid;

		private var lightSwf:SwfLoader;
		private var cirSwf:SwfLoader;
		private var star1Swf:SwfLoader;
		private var star2Swf:SwfLoader;

		private var cirEffArr:Array=[100010, 100015, 100013, 100012, 100017];

		public function EquipElementRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipElementRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;

			this.itemLbl=this.getUIbyID("itemLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.moneyImg=this.getUIbyID("moneyImg") as Image;

			this.changeRd=this.getUIbyID("changeRd") as RadioButton;
			this.restRd=this.getUIbyID("restRd") as RadioButton;

			for (var i:int=0; i < 5; i++) {
				this.txtLblArr.push(this.getUIbyID("txt" + (i + 1) + "Lbl") as Label);
			}

			this.grid=new EquipStrengGrid();
			this.addChild(this.grid);
			this.grid.x=123;
			this.grid.y=104;

			this.grid.setSize(60, 60);
			this.grid.dataId=1;

			this.grid.selectState()
			this.grid.setBgVisible(false);

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.changeRd.addEventListener(MouseEvent.CLICK, onRadioClick);
			this.restRd.addEventListener(MouseEvent.CLICK, onRadioClick);

			this.itemLbl.addEventListener(TextEvent.LINK, onLink);
			this.itemLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.itemLbl.mouseEnabled=true;

			this.lightSwf=new SwfLoader(100022);
			this.addChild(this.lightSwf);

			this.cirSwf=new SwfLoader(100010);
			this.addChild(this.cirSwf);

			this.star1Swf=new SwfLoader(99904);
			this.addChild(this.star1Swf);

			this.star2Swf=new SwfLoader(99904);
			this.addChild(this.star2Swf);

			this.lightSwf.visible=false;
			this.star1Swf.visible=false;
			this.star2Swf.visible=false;
			this.cirSwf.visible=false;

			this.setAttVisible(false);

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(10120).content);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.moneyImg, einfo);

			this.y=1;
			this.x=60;
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			if (this.grid.isEmpty)
				return;

			var btype:int=this.grid.data.hasOwnProperty("pos") ? 1 : 3;
			var pos:int=this.grid.data.hasOwnProperty("pos") ? this.grid.data.pos : this.grid.data.position;

			var ctype:int=this.changeRd.isOn ? 1 : 2;
			if (ctype == 1) {

				var needNum:int=this.itemLbl.text.split(" x ")[1];

				var num:int=MyInfoManager.getInstance().getBagItemNumByName(this.itemLbl.text.split(" x ")[0]);
				if (num < needNum && UIManager.getInstance().quickBuyWnd.isAutoBuy(30800, 30801))
					Cmd_Element.cm_ele_trans_c(btype, pos, ctype, (UIManager.getInstance().quickBuyWnd.getCost(30800, 30801) == 0 ? 2 : 1));
				else
					Cmd_Element.cm_ele_trans_c(btype, pos, ctype);
			} else
				Cmd_Element.cm_ele_trans_c(btype, pos, ctype);

		}

		private function onRadioClick(e:MouseEvent):void {

			if (this.grid.isEmpty)
				return;

			var etinfo:TElementTrans=TableManager.getInstance().getElementTransByLvOrQu(this.grid.data.info.level, this.grid.data.info.quality);

			if (this.changeRd.isOn) {
				this.moneyLbl.text="" + etinfo.tranMoney;
				this.itemLbl.htmlText="<font color='#cc54ea'><a href='event: 111--" + 30800 + "'><u><b>" + TableManager.getInstance().getItemInfo(etinfo.tranItemId.split(",")[0]).name + "</b></u></a></font> x " + etinfo.tranItemNum;

			} else {

				this.moneyLbl.text="" + etinfo.resetMoney;
				var id:int=etinfo.resetItemId.split("|")[this.grid.data.tips.ele - 1].split(",")[0];
				this.itemLbl.htmlText="<font color='#cc54ea'><a href='event: 222--" + id + "'><u><b>" + TableManager.getInstance().getItemInfo(id).name + "</b></u></a></font> x " + etinfo.resetItemNum;
			}
		}

		public function setChangeBag():void {
			UIManager.getInstance().equipWnd.BagRender.updateMountEnable(true);
			UIManager.getInstance().equipWnd.BagRender.updateBagAndBodyByLevelAndQuality(40, 3);
			this.confirmBtn.setActive(false, 0.6, true);
		}

		public function setDownItem(g:EquipStrengGrid):void {

			if (g.isEmpty)
				return;

			var d:Object=g.data;
			var info:TEquipInfo=g.data.info;
			var tips:TipsInfo=g.data.tips;

//			if (info.level < ConfigEnum.ElementOpenLv)
//				return;

			this.grid.updataInfo(g.data);

			this.setAttVisible(false);

			this.txtLblArr[tips.ele - 1].text=PropUtils.getStringEasyById(ItemUtil.getElementToEleId(tips.ele)) + ": " + tips.elea;
			this.txtLblArr[tips.ele - 1].visible=true;

			var sp:Point=new Point(5, 70);

			if (this.grid.data.tips.ele == 1) {
				sp.x=2;
				sp.y=65;
			} else if (this.grid.data.tips.ele == 4) {
				sp.x=1;
				sp.y=68;
			} else if (this.grid.data.tips.ele == 3) {
				sp.x=0;
				sp.y=66;
			} else if (this.grid.data.tips.ele == 5) {
				sp.x=3;
			}


			this.cirSwf.x=this.txtLblArr[this.grid.data.tips.ele - 1].x + sp.x;
			this.cirSwf.y=this.txtLblArr[this.grid.data.tips.ele - 1].y - sp.y;

			this.cirSwf.visible=true;
			this.cirSwf.update(this.cirEffArr[this.grid.data.tips.ele - 1]);

			this.changeRd.turnOn();

			var etinfo:TElementTrans=TableManager.getInstance().getElementTransByLvOrQu(this.grid.data.info.level, this.grid.data.info.quality);

			if (this.changeRd.isOn) {
				this.moneyLbl.text="" + etinfo.tranMoney;
				this.itemLbl.htmlText="<font color='#cc54ea'><a href='event: 111--" + 30800 + "'><u><b>" + TableManager.getInstance().getItemInfo(etinfo.tranItemId.split(",")[0]).name + "</b></u></a></font> x " + etinfo.tranItemNum;

			} else {

				this.moneyLbl.text="" + etinfo.resetMoney;
				var id:int=etinfo.resetItemId.split("|")[this.grid.data.tips.ele - 1].split(",")[0];
				this.itemLbl.htmlText="<font color='#cc54ea'><a href='event: 222--" + id + "'><u><b>" + TableManager.getInstance().getItemInfo(id).name + "</b></u></a></font> x " + etinfo.resetItemNum;
			}

			this.confirmBtn.setActive(true, 1, true);
		}

		public function updateSuccess(o:Object):void {

//			if (this.changeRd.isOn) {
//
//				this.setAttVisible(false);
//
//				this.star1Swf.x=this.txtLblArr[this.grid.data.tips.ele - 1].x + 35;
//				this.star1Swf.y=this.txtLblArr[this.grid.data.tips.ele - 1].y - 35;
//
//				star1Swf.visible=true;
//				this.star1Swf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
//					star1Swf.visible=false;
//				});
//
//			}

			UIManager.getInstance().equipWnd.BagRender.updateBagData();
			UIManager.getInstance().equipWnd.BagRender.updatebodyData();


			UIManager.getInstance().equipWnd.BagRender.updateBagAndBodyByLevelAndQuality(40, 3);

			if (this.grid.data.hasOwnProperty("pos"))
				this.grid.updataInfo(MyInfoManager.getInstance().bagItems[this.grid.data.pos]);
			else
				this.grid.updataInfo(MyInfoManager.getInstance().equips[this.grid.data.position]);


			if (this.changeRd.isOn) {
				this.setAttVisible(false);

				this.star2Swf.x=this.txtLblArr[this.grid.data.tips.ele - 1].x + 35;
				this.star2Swf.y=this.txtLblArr[this.grid.data.tips.ele - 1].y - 35;

				star2Swf.visible=true;
				this.star2Swf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					star2Swf.visible=false;
				});

				var sp:Point=new Point(5, 70);

				if (this.grid.data.tips.ele == 1) {
					sp.x=2;
					sp.y=65;
				} else if (this.grid.data.tips.ele == 4) {
					sp.x=1;
					sp.y=68;
				} else if (this.grid.data.tips.ele == 3) {
					sp.x=0;
					sp.y=66;
				} else if (this.grid.data.tips.ele == 5) {
					sp.x=3;
				}


				this.cirSwf.x=this.txtLblArr[this.grid.data.tips.ele - 1].x + sp.x;
				this.cirSwf.y=this.txtLblArr[this.grid.data.tips.ele - 1].y - sp.y;

				this.cirSwf.update(this.cirEffArr[this.grid.data.tips.ele - 1]);

			} else {

				this.lightSwf.x=this.txtLblArr[this.grid.data.tips.ele - 1].x - 20;
				this.lightSwf.y=this.txtLblArr[this.grid.data.tips.ele - 1].y - 20;

				lightSwf.visible=true;
				this.lightSwf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					lightSwf.visible=false;
				});

			}

			this.txtLblArr[this.grid.data.tips.ele - 1].text=PropUtils.getStringEasyById(ItemUtil.getElementToEleId(this.grid.data.tips.ele)) + ": " + this.grid.data.tips.elea;
			this.txtLblArr[this.grid.data.tips.ele - 1].visible=true;

		}

		private function onLink(e:TextEvent):void {

			if (this.restRd.isOn)
				return;

			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(30800, 30801);
			UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
		}

		private function onMouseMove(e:MouseEvent):void {

			var i:int=this.itemLbl.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(this.itemLbl.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url.indexOf("--") > -1) {

				var tipsInfo:TipsInfo=new TipsInfo();
				tipsInfo.itemid=int(url.split("--")[1])

				tipsInfo.isShowPrice=false;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipsInfo, new Point(e.stageX, e.stageY));
			} else {

			}

		}

		private function setAttVisible(v:Boolean):void {
			for (var i:int=0; i < this.txtLblArr.length; i++) {
				this.txtLblArr[i].visible=v;
			}

		}

		public function clearAllData():void {

			this.setAttVisible(false);

			this.moneyLbl.text="";
			this.itemLbl.text="";

			this.confirmBtn.setActive(false, 0.6, true);

			if (!this.grid.isEmpty) {
				this.grid.resetGrid();
				this.grid.delItemHandler();
			}

			this.cirSwf.visible=false;
		}


	}
}

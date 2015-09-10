package com.leyou.ui.ttt {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Ttt;
	import com.leyou.ui.ttt.childs.TttBigBtn;
	import com.leyou.ui.ttt.childs.TttGrid;
	import com.leyou.ui.ttt.childs.TttSmallBtn;
	import com.leyou.ui.ttt.childs.TttTitleBtn;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display3D.IndexBuffer3D;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class TttWnd extends AutoWindow {

		private var lvLbl:Label;
		private var firstNameLbl:Label;
		private var timeLbl:Label;
		private var pkBtn:NormalButton;
		private var resetBtn:NormalButton;
		private var totalCurBtn:NormalButton;
		private var totalBtn:NormalButton;
		private var downBtn:ImgButton;
		private var upBtn:ImgButton;
		private var ruleLbl:Label;
		private var succImg:Image;
		private var itemList:ScrollPane;
		private var countLbl:Label;
		private var maxLbl:Label;
		private var getImg:Image;

		private var lvArr:Array=[];

		private var renderArr:Array=[];
		private var renderSpr:Sprite;
		private var rendermaskSpr:Sprite;
		private var renderSprWidth:Number=10054;

		private var rewardFirstArr:Array=[];
		private var rewardArr:Array=[];

		private var dataArr:Array=[];

		private var currentLv:int=-1;
		private var currentMaxLv:int=-1;

		private var maxLv:int=-1;
		private var scrollIndex:int=-1;

		private var sBtn:TttSmallBtn;
		private var bBtn:TttBigBtn;

		public function TttWnd() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttWnd.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {

			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.firstNameLbl=this.getUIbyID("firstNameLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.pkBtn=this.getUIbyID("pkBtn") as NormalButton;
			this.resetBtn=this.getUIbyID("resetBtn") as NormalButton;
			this.totalCurBtn=this.getUIbyID("totalCurBtn") as NormalButton;
			this.totalBtn=this.getUIbyID("totalBtn") as NormalButton;

			this.downBtn=this.getUIbyID("downBtn") as ImgButton;
			this.upBtn=this.getUIbyID("upBtn") as ImgButton;

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.maxLbl=this.getUIbyID("maxLbl") as Label;

			this.succImg=this.getUIbyID("succImg") as Image;
			this.getImg=this.getUIbyID("getImg") as Image;

			this.itemList=this.getUIbyID("itemList") as ScrollPane;


			this.pkBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.resetBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.totalCurBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.totalBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.downBtn.addEventListener(MouseEvent.CLICK, onMoveClick);
			this.upBtn.addEventListener(MouseEvent.CLICK, onMoveClick);

			this.renderSpr=new Sprite();
			this.addChild(this.renderSpr);

			this.renderSpr.x=220;
			this.renderSpr.y=130;

			this.rendermaskSpr=new Sprite();
			this.addChild(this.rendermaskSpr);

			this.rendermaskSpr.graphics.beginFill(0x00);
			this.rendermaskSpr.graphics.drawRect(0, 0, 167, 353);
			this.rendermaskSpr.graphics.endFill();

			this.rendermaskSpr.x=220;
			this.rendermaskSpr.y=130;

			this.renderSpr.mask=this.rendermaskSpr;

			dataArr=TableManager.getInstance().getTttCopyAll();

			dataArr.sortOn("D_Floor", Array.DESCENDING | Array.NUMERIC);

			var tdb:TDungeon_Base;
			var tbtn:TttTitleBtn;

			var tbbtn:TttBigBtn;
			var tsbtn:TttSmallBtn;

			var i:int=dataArr.length;
			var j:int=0;

			for each (tdb in dataArr) {

				if (i % 10 == 0) {

					tbtn=new TttTitleBtn();

					tbtn.setLvTxt((i - 10 + 1) + "~" + i + PropUtils.getStringById(2203));

					this.itemList.addToPane(tbtn);
					this.lvArr.push(tbtn);

					tbtn.addEventListener(MouseEvent.CLICK, onBtnClick);

					tbtn.y=j * 31;

					j++;
				}

				i--;
			}

			this.succImg.visible=false;
			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(10056).content);

			this.scrollRect=new Rectangle(0, 0, 799, 539);

			this.bBtn=new TttBigBtn();
			this.sBtn=new TttSmallBtn();

		}

		private function onBtnClick(e:MouseEvent):void {

			this.updateToSmallBtn(this.scrollIndex);

			var idx:int=this.lvArr.length - this.lvArr.indexOf(e.target.parent as TttTitleBtn) - 1;
			this.scrollIndex=idx * 10;

			this.upBtn.visible=true;
			this.downBtn.visible=true;

			if (this.scrollIndex >= this.currentLv - 1) {
				this.upBtn.visible=false;
				this.scrollIndex=this.currentLv - 1;
			}

			if (this.scrollIndex <= 0) {
				this.scrollIndex=0;
				this.downBtn.visible=false;
			}

			if (this.scrollIndex >= this.renderArr.length - 1) {
				this.scrollIndex=this.renderArr.length - 1;
				this.upBtn.visible=false;
			}


			var _y:Number=this.downBtn.y - 100 - this.renderSprWidth + this.scrollIndex * 100;

			if (idx > Math.floor(this.currentLv / 10) && Math.floor(this.currentLv / 10) > 0)
				_y+=53;

			if (_y > this.upBtn.y + 100)
				_y=this.upBtn.y + 100;

			TweenLite.to(this.renderSpr, 0.5, {y: _y});

			this.updateToBigBtn(this.scrollIndex);

			this.setSelectBtn(this.lvArr.length - Math.floor(this.scrollIndex / 10) - 1);

		}

		private function onMoveClick(e:MouseEvent):void {

			this.updateToSmallBtn(this.scrollIndex);

			if (e.target.name == "downBtn") {

				this.scrollIndex--;

				this.upBtn.visible=true;

				if (this.scrollIndex <= 0) {
					this.scrollIndex=0;
					this.downBtn.visible=false;
				}

			} else if (e.target.name == "upBtn") {
				this.scrollIndex++;

				this.downBtn.visible=true;

				if (this.scrollIndex >= this.renderArr.length - 1) {
					this.scrollIndex=this.renderArr.length - 1;
					this.upBtn.visible=false;
				}

				if (this.scrollIndex >= this.currentLv - 1) {
					this.upBtn.visible=false;
					this.scrollIndex=this.currentLv - 1;
				}

			}

			var _y:Number=this.downBtn.y - 100 - this.renderSprWidth + this.scrollIndex * 100;

			if (_y > this.upBtn.y + 100)
				_y=this.upBtn.y + 100;

			TweenLite.to(this.renderSpr, 0.5, {y: _y});
//			TweenLite.delayedCall(0.25,updateToBigBtn,[this.scrollIndex]);
			this.updateToBigBtn(this.scrollIndex);

			this.setSelectBtn(this.lvArr.length - Math.floor(this.scrollIndex / 10) - 1);
		}


		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "pkBtn":
					Cmd_Ttt.cmEnterCopy(currentLv);
					break;
				case "resetBtn":
					PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(10057).content, function():void {
						Cmd_Ttt.cmCopyReset();
					}, null, false, "tttResetBtn");
					break;
				case "totalCurBtn":
					PopupManager.showRadioConfirm(TableManager.getInstance().getSystemNotice(10055).content, "" + ConfigEnum.Babel4, "" + ConfigEnum.Babel5, function(i:int):void {
						Cmd_Ttt.cmfastComplete(currentLv, (i == 0 ? 1 : 0));
					}, null, false, "ttttotalCurBtn");
					break;
				case "totalBtn":
					var r:int=(maxLv - this.currentLv) + 1;
					r=r < 1 ? 1 : r;

					PopupManager.showRadioConfirm(TableManager.getInstance().getSystemNotice(10055).content, "" + ConfigEnum.Babel4 * r, "" + ConfigEnum.Babel5 * r, function(i:int):void {
						Cmd_Ttt.cmfastComplete(0, (i == 0 ? 1 : 0));
					}, null, false, "ttttotalBtn");
					break;
			}

		}

		public function updateToBigBtn(idx:int, isDown:Boolean=false):void {

			if (idx >= this.renderArr.length)
				return;

			var pos:int=this.renderArr.length - idx - 1;
			var tdb:TDungeon_Base=this.dataArr[this.dataArr.length - idx - 1];
			var tsbtn:TttSmallBtn=this.renderArr[pos];

			var ypos:int=tsbtn.y - 53;

			this.renderSpr.removeChild(tsbtn);

			var tbbtn:TttBigBtn=this.bBtn;

			var std:int=(tdb.D_Floor < this.currentLv ? 1 : tdb.D_Floor == this.currentLv ? 0 : -1);
			if (this.currentLv < this.currentMaxLv)
				std=1;
//			tbbtn.addEventListener(MouseEvent.CLICK, onItemClick);
			tbbtn.updateInfo({lv: tdb.D_Floor, st: std});

			Cmd_Ttt.cmCurrentCopy(tdb.D_Floor);

			this.renderSpr.addChild(tbbtn);
			this.renderArr[pos]=(tbbtn);

//			tsbtn.x=16.5;
			tbbtn.y=ypos;

			ypos=0;
			var i:int=0;
			while (i < this.renderArr.length) {

				this.renderArr[i].y=ypos;

				if (this.renderArr[i] is TttBigBtn)
					ypos+=150;
				else
					ypos+=100;

				i++;
			}
		}

		public function updateToSmallBtn(idx:int):void {

			if (idx >= this.renderArr.length)
				return;

			var pos:int=this.renderArr.length - idx - 1;
			var tdb:TDungeon_Base=this.dataArr[this.dataArr.length - idx - 1];
			var tbbtn:TttBigBtn=this.renderArr[pos];

			var ypos:int=tbbtn.y + 53;

			this.renderSpr.removeChild(tbbtn);

			var tsbtn:TttSmallBtn=new TttSmallBtn();

//			tsbtn.addEventListener(MouseEvent.CLICK, onItemClick);

			var std:int=(tdb.D_Floor < this.currentLv ? 1 : tdb.D_Floor == this.currentLv ? 0 : -1);
			if (this.currentLv < this.currentMaxLv)
				std=1;

			tsbtn.updateInfo({lv: tdb.D_Floor, st: std});

			this.renderSpr.addChild(tsbtn);
			this.renderArr[pos]=(tsbtn);

			tsbtn.x=16.5;
//			tsbtn.y=ypos;

			ypos=0;
			var i:int=0;
			while (i < this.renderArr.length) {

				this.renderArr[i].y=ypos;

				if (this.renderArr[i] is TttBigBtn)
					ypos+=150;
				else
					ypos+=100;

				i++;
			}

		}


		public function updateInfo(o:Object):void {

			UIManager.getInstance().showPanelCallback(WindowEnum.TTT)

			this.currentMaxLv=o.cfloor;
			this.currentLv=(this.currentMaxLv > ConfigEnum.Babel2 ? ConfigEnum.Babel2 : this.currentMaxLv);

			this.maxLv=o.max_floor;

			this.maxLbl.text="" + o.max_floor;
			this.countLbl.text="" + o.scount;

			if (o.scount > 0)
				this.resetBtn.setActive(true, 1, true);
			else
				this.resetBtn.setActive(false, 0.6, true);

			Cmd_Ttt.cmCurrentCopy(this.currentLv);

			var tbbb:DisplayObject;
			for each (tbbb in this.renderArr) {
				this.renderSpr.removeChild(tbbb);
			}

			this.renderArr.length=0;

			var tbtn:TttTitleBtn;

			var tdb:TDungeon_Base;
			var tbbtn:TttBigBtn;
			var tsbtn:TttSmallBtn;
			var ypos:Number=0;

			var i:int=0;

			for each (tdb in dataArr) {

				if (tdb.D_Floor == this.currentLv) {

					tbbtn=new TttBigBtn();
//					tbbtn.addEventListener(MouseEvent.CLICK, onItemClick);

					this.renderSpr.addChild(tbbtn);
					this.renderArr.push(tbbtn);

					tbbtn.updateInfo({lv: tdb.D_Floor, st: (this.currentLv < this.currentMaxLv)});

					tbbtn.y=ypos;
					ypos+=153

					this.scrollIndex=(this.dataArr.length - i - 1);

				} else {

					tsbtn=new TttSmallBtn();
//					tsbtn.addEventListener(MouseEvent.CLICK, onItemClick);
					tsbtn.updateInfo({lv: tdb.D_Floor, st: (tdb.D_Floor < this.currentLv ? 1 : tdb.D_Floor == this.currentLv ? 0 : -1)});

					this.renderSpr.addChild(tsbtn);
					this.renderArr.push(tsbtn);

					tsbtn.x=16.5;
					tsbtn.y=ypos;

					ypos+=100;

				}

				i++;
			}


			this.renderSpr.y=this.downBtn.y - 100 - this.renderSprWidth;

			var _y:Number=this.downBtn.y - 100 - this.renderSprWidth + this.scrollIndex * 100;

//			if (_y < this.downBtn.y - this.renderSpr.height)
//				_y=this.downBtn.y - this.renderSpr.height

			TweenLite.to(this.renderSpr, 0.5, {y: _y});

			TweenLite.delayedCall(0.3, this.setSelectBtn, [this.lvArr.length - Math.floor(this.scrollIndex / 10) - 1]);

			for (i=0; i < this.lvArr.length; i++) {
				this.lvArr[i].visible=(this.lvArr.length - i - 1 <= Math.floor(this.maxLv / 10));
			}

			this.downBtn.visible=true;
			this.upBtn.visible=true;

			if (this.scrollIndex >= this.currentLv - 1) {
				this.upBtn.visible=false;
				this.scrollIndex=this.currentLv - 1;
			}

			if (this.scrollIndex <= 0) {
				this.scrollIndex=0;
				this.downBtn.visible=false;
			}

		}

		private function onItemClick(e:MouseEvent):void {
			Cmd_Ttt.cmCurrentCopy(e.target.parent.lv)
		}

		/**
		 * 单前层级的info
		 * @param o
		 *
		 */
		public function updateCurrentInfo(o:Object):void {

			var info:TDungeon_Base=this.dataArr[this.dataArr.length - o.floor];
			if (info == null)
				return;

			this.lvLbl.text="" + o.floor;

			if (o.hasOwnProperty("fname"))
				this.firstNameLbl.text="" + o.fname;
			else
				this.firstNameLbl.text="" + PropUtils.getStringById(1642);

			var tstr:Array=String(o.ftime).split(".");

			if (o.hasOwnProperty("ftime")) {
//				if (tstr.length == 2)
				this.timeLbl.text="" + o.ftime + PropUtils.getStringById(2146); // TimeUtil.getIntToTime(int(tstr[0])) + "." + tstr[1];
//				else
//					this.timeLbl.text="" + TimeUtil.getIntToTime(int(tstr[0]));
			} else
				this.timeLbl.text="";

			this.updateItemGrid(info);
			this.updateFirstGrid(info);

			this.addChild(this.succImg);
			this.addChild(this.getImg);

			if (o.floor < this.currentLv) {
				this.succImg.visible=true;

				this.pkBtn.setActive(false, 0.6, true);
				this.totalCurBtn.setActive(false, 0.6, true);

			} else if (o.floor == this.currentLv) {

				if (o.floor < this.currentMaxLv) {
					this.succImg.visible=true;

					this.pkBtn.setActive(false, 0.6, true);
					this.totalCurBtn.setActive(false, 0.6, true);
					this.totalBtn.setActive(false, 0.6, true);
				} else {

					this.succImg.visible=false;

					this.pkBtn.setActive(true, 1, true);
					this.totalCurBtn.setActive(true, 1, true);
					this.totalBtn.setActive(true, 1, true);
				}

			} else {

				this.succImg.visible=false;
				this.pkBtn.setActive(false, 0.6, true);
				this.totalCurBtn.setActive(false, 0.6, true);
				this.totalBtn.setActive(false, 0.6, true);

			}

			if (o.floor <= this.maxLv && this.currentLv <= this.maxLv && this.currentMaxLv == this.currentLv) {
				this.totalBtn.setActive(true, 1, true);
			} else {
				this.totalBtn.setActive(false, 0.6, true);
				this.totalCurBtn.setActive(false, 0.6, true);
			}


			this.getImg.visible=(o.floor <= this.maxLv);
		}


		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			Cmd_Ttt.cmInit();

//			UIManager.getInstance().showPanelCallback(WindowEnum.TTT);

//			this.updateInfo({"cfloor": 1, "scount": 1, "max_floor": 23});
//			this.updateCurrentInfo({"floor": 13, "fname": "ff", "ftime": 123});

		}


		public function setSelectBtn(i:int):void {

			for (var j:int=0; j < this.lvArr.length; j++) {
				this.lvArr[j].select=false;
			}

			if (i <= 0)
				i=0;

			if (i >= this.lvArr.length)
				i=this.lvArr.length - 1;

			this.lvArr[i].select=true;
		}

		private function updateFirstGrid(info:TDungeon_Base):void {

			var render:TttGrid;
			for each (render in this.rewardFirstArr) {
				this.removeChild(render);
			}

			this.rewardFirstArr.length=0;

			var _x:int=495;
			var _y:int=400;

			var _w:Number=50;

			if (info.First_Exp > 0) {

				render=new TttGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65534));
				render.setNum(info.First_Exp + "");
				render.setTipsNum(info.First_Exp);
				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * _w;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_energy > 0) {

				render=new TttGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65533));
				render.setNum(info.First_energy + "");
				render.setTipsNum(info.First_energy);

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * _w;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Money > 0) {

				render=new TttGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65535));
				render.setNum(info.First_Money + "");
				render.setTipsNum(info.First_Money);

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * _w;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item1 > 0) {

				render=new TttGrid();
				if (info.First_Item1 > 10000)
					render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item1)));
				else
					render.updataInfo(TableManager.getInstance().getEquipInfo(int(info.First_Item1)));

				render.setNum(info.Fitem_Num1 + "");

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * _w;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item2 > 0) {

				render=new TttGrid();

				if (info.First_Item2 > 10000)
					render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item2)));
				else
					render.updataInfo(TableManager.getInstance().getEquipInfo(int(info.First_Item2)));

				render.setNum(info.Fitem_Num2 + "");

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * _w;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

		}


		private function updateItemGrid(info:TDungeon_Base):void {

			var render:TttGrid;
			for each (render in this.rewardArr) {
				this.removeChild(render);
			}

			this.rewardArr.length=0;

			var ctx:Array=[];

			for (var i:int=0; i < 5; i++) {

				if (info["DBC_ITEM" + (i + 1)] == null || info["DBC_ITEM" + (i + 1)] == 0)
					continue;

				ctx=info["DBC_ITEM" + (i + 1)].split(",");

				render=new TttGrid();

				this.rewardArr.push(render);
				this.addChild(render);

				render.y=310;
				render.x=495 + i * 50;

				if (String(ctx[0]).length == 4)
					render.updataInfo(TableManager.getInstance().getEquipInfo(int(ctx[0])));
				else
					render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));

				render.canMove=false;

				if (ctx.length == 2) {
					render.setTipsNum(int(ctx[1]));

					if (int(ctx[1]) > 1)
						render.setNum((ctx[1]));
				}

			}

		}



	}
}

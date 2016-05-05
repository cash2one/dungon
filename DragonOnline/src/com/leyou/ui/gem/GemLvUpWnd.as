package com.leyou.ui.gem {

	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAlchemy;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.accordion.Accordion;
	import com.ace.ui.accordion.LabelButton;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.ui.gem.child.AlchemyRender;
	import com.leyou.ui.gem.child.FoldMenu;
	import com.leyou.ui.gem.child.GembtnWnd;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class GemLvUpWnd extends AutoWindow {

		private var itemList:ScrollPane;
		private var ruleLbl:Label;
		private var accordMenu:Accordion;
		private var foldMenu:FoldMenu;
		private var render:AlchemyRender;

		private var currentid:int=1;
		private var currentCount:int=1;
		private var currentMaxCount:int=1;

		private var renderArr:Array=[];

		private var moneyNum:int=0;

		private var succeffImg:Image;
		private var faileffImg:Image;
		private var numArr:Array=[];

		private var rate:int=0;

		public function GemLvUpWnd() {
			super(LibManager.getInstance().getXML("config/ui/gem/gemLvUpWnd.xml"));
			this.init();
//			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.itemList.visible=false;

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(10100).content);

//			this.accordMenu=new Accordion(200, 480);
//			this.itemList.addToPane(this.accordMenu);

			this.foldMenu=new FoldMenu(220, 455);
			this.addChild(this.foldMenu);
			this.foldMenu.x=8;
			this.foldMenu.y=70;
//			this.itemList.addToPane(this.foldMenu);

			var items:Array=TableManager.getInstance().getGemListNameByType();

			items.sortOn("Al_ID", Array.CASEINSENSITIVE | Array.NUMERIC);

			var tinfo:TAlchemy;
			var tinfo1:TAlchemy;
			var tinfo2:TAlchemy;
			var itemsName:Array=[];

			var data1:Array=[];
			var data2:Array=[];
			var data3:Array=[];

			var item2:Array=[];
			var item3:Array=[];
			var renders:Array=[];
			var render:GembtnWnd;

			var accorMenu1:Accordion;

			var rect:Rectangle;
			var res:String;
			var gname:String;
			var lb:LabelButton

			var i1:int=0;
			var i2:int=0;
			var i3:int=0;

			for (i1=0; i1 < items.length; i1++) {

				tinfo=items[i1];
				item2=TableManager.getInstance().getGemListNameByType(0, tinfo.Al_Type, 2);

				item2.sortOn("Al_ID", Array.CASEINSENSITIVE | Array.NUMERIC);

				res="ui/other/button_type1.jpg";
				rect=new Rectangle(12, 26, 233, 18);
				gname="accordion_ttt";

				lb=new LabelButton(LibManager.getInstance().getImg(res), rect, 200, 30, gname, true);
				this.foldMenu.addItem(lb, "0");
				lb.setTitleTxt(tinfo.AlT_Nam);


				for (i2=0; i2 < item2.length; i2++) {

					tinfo1=item2[i2];

					res="ui/alchemy/btn_2.png";
					rect=new Rectangle(0, 0, 190, 75);
					gname="accordion_tttt";

					lb=new LabelButton(LibManager.getInstance().getImg(res), rect, 190, 25, gname, true);
					this.foldMenu.addItem(lb, "0_" + i1);
					lb.setTitleTxt(tinfo1.Als_Nam);
					lb.CrossVisible=true;
					lb.setCrossState(false);

					item3=TableManager.getInstance().getGemListNameByType(tinfo.Al_Type, tinfo1.Al_second, 3);
					item3.sortOn("Al_ID", Array.CASEINSENSITIVE | Array.NUMERIC);

					for (var i:int=0; i < item3.length; i++) {

						if (TAlchemy(item3[i]).limit != 0 && TAlchemy(item3[i]).limit != Core.me.info.profession)
							continue;

						render=new GembtnWnd();
						render.updateInfo(item3[i]);

						render.addEventListener(MouseEvent.CLICK, onTreeClick);
						this.renderArr.push(render);

						this.foldMenu.addItem(render, "0_" + i1 + "_" + i2);
					}

				}

			}

			this.foldMenu.updateInfo();

			this.render=new AlchemyRender();
			this.addChild(this.render);

			this.render.x=231;
			this.render.y=65;

			this.addChild(this.ruleLbl);

//			this.clsBtn.y+=18;
//			this.allowDrag=false;
		}


		private function onTreeClick(e:MouseEvent):void {

			if (!(e.target.parent is GembtnWnd))
				return;

			this.currentid=e.target.parent.getID();

			this.setItemsSelectItem();
			e.target.parent.setSelectState(true);

			this.currentCount=1;
			this.render.updateSelectInfo(this.currentid);
		}

		public function updateInfo(o:Object):void {
			this.render.updateInfo(o);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.updateList();

			this.renderArr[0].getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.renderArr[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));

		}

		public function setSelectById(id:int):void {
			for (var i:int=0; i < this.renderArr.length; i++) {
				if (this.renderArr[i].getItemID() == id) {
					this.renderArr[i].getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					this.renderArr[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}

		public function updateList():void {

			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].updateInfo(TableManager.getInstance().getGemByID(this.renderArr[i].getID()));
			}
		}

		private function setItemsSelectItem():void {
			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].setSelectState(false);
			}
		}

		public function clearData():void {
			this.currentCount=1;
		}

		override public function getUIbyID(id:String):DisplayObject {
			var ds:DisplayObject=super.getUIbyID(id);

			if (ds == null)
				ds=render.getUIbyID(id);

			return ds;
		}


		override public function get width():Number {
			return 617;
		}

		override public function get height():Number {
			return 544;
		}

		override public function hide():void {
			super.hide();
			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.GEM_LV + "");
			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("alchmyBtn"));
		}

	}
}

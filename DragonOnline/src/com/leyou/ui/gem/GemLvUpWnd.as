package com.leyou.ui.gem {


	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAlchemy;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.accordion.Accordion;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.ui.gem.child.AlchemyRender;
	import com.leyou.ui.gem.child.GembtnWnd;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class GemLvUpWnd extends AutoWindow {

		private var itemList:ScrollPane;
		private var accordMenu:Accordion;
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

			this.accordMenu=new Accordion(200, 480);
			this.itemList.addToPane(this.accordMenu);

			var items:Object=TableManager.getInstance().getGemListNameByType();

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


			for each (tinfo in items) {
				itemsName.push(tinfo.AlT_Nam);
				item2=TableManager.getInstance().getGemListNameByType(0,tinfo.Al_Type, 2);

				accorMenu1=new Accordion(200, 410, 25);
				accorMenu1.isSencond=true;
				data2=[];

				for each (tinfo1 in item2) {

					item3=TableManager.getInstance().getGemListNameByType(tinfo.Al_Type,tinfo1.Al_second, 3);

					data1=[];
					for (var i:int=0; i < item3.length; i++) {

						render=new GembtnWnd();
						render.updateInfo(item3[i]);

						data1.push(render);
						
						render.addEventListener(MouseEvent.CLICK, onTreeClick);
						this.renderArr.push(render);
					}

					accorMenu1.addItem(tinfo1.Als_Nam, "", data1);
//					accorMenu1.addEventListener(MouseEvent.CLICK, onTreeClick);
				}

				data2.push(accorMenu1);
				this.accordMenu.addItem(tinfo.AlT_Nam, "", data2);
			}

//			this.accordMenu.addItem(PropUtils.getStringById(1716), "", data1);
//			this.accordMenu.addItem(PropUtils.getStringById(1717), "", data2);
//			this.accordMenu.addItem(PropUtils.getStringById(1718), "", data3);

//			this.accordMenu.addEventListener(MouseEvent.CLICK, onTreeClick);



//			this.accordMenu.y=70;
//			this.accordMenu.x=13;

			this.render=new AlchemyRender();
			this.addChild(this.render);

			this.render.x=243;
			this.render.y=50;

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

		override public function get width():Number {
			return 644;
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

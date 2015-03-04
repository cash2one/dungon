package com.ace.ui.accordion {

	import com.ace.ui.menu.data.MenuInfo;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Accordion extends Sprite {

		private var _w:Number=0;
		private var _h:Number=0

		private var itemVec:Vector.<AccordionItem>;

		public var selectIndex:int=0;

		public var leftSpace:Number=0;
		private var _titleHegiht:Number=25;

		public function Accordion(_w:Number=200, _h:Number=400, _titleH:Number=30) {
			this._h=_h;
			this._w=_w;
			this._titleHegiht=_titleH;
			this.init();
		}

		private function init():void {
			this.itemVec=new Vector.<AccordionItem>();
		}

		/**
		 * 添加item
		 * @param title
		 * @param num
		 * @param data
		 * @return
		 *
		 */
		public function addItem(title:String="", num:String="", data:Array=null, menuVec:Vector.<MenuInfo>=null):AccordionItem {
			var item:AccordionItem=new AccordionItem(this.itemVec.length, _w, 0, _titleHegiht);
			item.setTitleTxt(title);
			item.setNumTxt(num);
			item.setMenu(menuVec);

			this.addChild(item);

			if (data != null)
				for (var i:int=0; i < data.length; i++) {
					item.addItem(data[i]);
				}

			this.itemVec.push(item);
			item.addEventListener(MouseEvent.CLICK, onClick);

			this.updateContentUi();
			closeItem(this.itemVec.length - 1);
			openItem(0);

			return item;
		}

		/**
		 * 删除item 通过index
		 * @param i
		 *
		 */
//		public function removeItemAt(i:int):void {
//			var _i:int=this.itemVec.indexOf(i);
//			if (_i > -1) {
//				this.removeChild(this.itemVec[_i])
//				this.itemVec.splice(_i, 1);
//				this.updateContentUi();
//			}
//		}

		/**
		 * 更新ui,用于添加,删除后的改变
		 *
		 */
		private function updateContentUi():void {
			var item:AccordionItem;
			var hh:int=_h - this.itemVec.length * this.itemVec[0].getTitleLbl().height;
			var i:int=0;

			for each (item in this.itemVec) {

				item.setHeight(hh)
				item.y=i;
				item.updateContentUi();

				i+=item.getHeight() + 1;
			}

			this.scrollRect=new Rectangle(0, 0, _w, _h - 22)
		}

		private function updateTitleUi():void {
			var item:AccordionItem;
			var hh:int=_h - this.itemVec.length * this.itemVec[0].getTitleLbl().height;
			var i:int=0;

			for each (item in this.itemVec) {

				item.titleH=this._titleHegiht;
				item.updateTitleUi();

				item.setHeight(hh)
				item.y=i;
				item.updateContentUi();

				i+=item.getHeight() + 1;
			}

			this.scrollRect=new Rectangle(0, 0, _w, _h - 22)
		}

		/**
		 * 更新位置 ,只用于位置改变
		 *
		 */
		private function updateContentlist():void {
			var item:AccordionItem;
			var i:int=0;
			for each (item in this.itemVec) {
				item.y=i;
				i+=item.getHeight() + 1;
			}
		}

		/**
		 * 返回子items
		 * @param i
		 * @return
		 *
		 */
		public function getItem(i:int):AccordionItem {
			return this.itemVec[i];
		}

//		/**
//		 * 
//		 * @param i
//		 * @param data
//		 * 
//		 */		
//		public function addItemDataAt(i:int, data:Array):void {
//			for (var i:int=0; i < data.length; i++) {
//				this.itemVec[i].addItem(data[i]);
//			}
//		}

		/**
		 * 更新右键菜单
		 * @param i
		 * @param menuVec
		 *
		 */
		public function setItemMenu(i:int, menuVec:Vector.<MenuInfo>):void {
			this.itemVec[i].setMenu(menuVec);
		}

		public function setItemNum(i:int, v:String):void {
			this.itemVec[i].setNumTxt(v);
		}

		public function setItemTitle(i:int, v:String):void {
			this.itemVec[i].setTitleTxt(v);
		}

		private function onClick(e:MouseEvent):void {

			this.itemVec[selectIndex].states=false;
			selectIndex=this.itemVec.indexOf(e.currentTarget as AccordionItem);
			this.itemVec[selectIndex].states=true;

			this.updateContentlist();
		}

		public function set titleHeight(v:Number):void {
			this._titleHegiht=v;
			this.updateTitleUi();
		}

		private function openItem(i:int):void {
			this.itemVec[i].states=true;
			this.updateContentlist();
		}

		private function closeItem(i:int):void {
			this.itemVec[i].states=false;
			this.updateContentlist();
		}

	}
}

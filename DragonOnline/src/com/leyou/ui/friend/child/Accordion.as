package com.leyou.ui.friend.child {
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
		private var currentBtn:LabelButton;

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
			var item:AccordionItem = new AccordionItem(this.itemVec.length, _w, 0, _titleHegiht);
			item.setTitleTxt(title);
			item.setMenu(menuVec);

			this.addChild(item);

			if (data != null)
				for (var i:int=0; i < data.length; i++) {
					item.pushItem(data[i]);
				}

			this.itemVec.push(item);
			item.addEventListener(MouseEvent.CLICK, onClick);
			item.setNumTxt(num);

			this.updateContentUi();
			closeItem(this.itemVec.length - 1);
			openItem(0);
			if(0 < itemVec.length){
				itemVec[0].lb.turnOn();;
			}
			return item;
		}
		
		/**
		 * 添加社交角色项
		 * @param item 社交角色项
		 *
		 */
		public function addFriendItem(friendItem:FriendDateBar, relation:int):void{
			var item:AccordionItem = itemVec[relation-1];
			if(2 == relation){
				item.unshiftItem(friendItem, 20);
			}else{
				var num:int = (3 != relation) ? 50 : 20;
				item.pushItem(friendItem, num);
			}
			item.sortItemsPosition();
		}
		
		/**
		 * 删除社交角色项
		 *
		 */
		public function removedFriendItemByName(name:String, relation:int):void{
			var item:AccordionItem = itemVec[relation-1];
			item.removeItemByName(name);
		}
		
		/**
		 * 更新社交角色项
		 *
		 */
		public function updateFriendItem(o:Object, relation:int):void{
			var item:AccordionItem = itemVec[relation-1];
			item.updateItemDate(o, relation);
		}
		
		/**
		 * <T>清空一个列表项</T>
		 * 
		 * @param relation 关系列表
		 * 
		 */		
		public function clear(relation:int):void{
			var item:AccordionItem = itemVec[relation-1];
			item.removeAllList();
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
		 * @return 社交项
		 *
		 */
		public function getItem(i:int):AccordionItem {
			if(i >= 0 && i < itemVec.length){
				return itemVec[selectIndex];
			}
			return null;
		}

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
			if(null != currentBtn){
				currentBtn.turnOff();
			}
			currentBtn = e.target as LabelButton;
			if(null != currentBtn){
				currentBtn.turnOn();
			}
			if(selectIndex >= 0 && selectIndex < itemVec.length){
				this.itemVec[selectIndex].states=false;
				selectIndex=this.itemVec.indexOf(e.currentTarget as AccordionItem);
				this.itemVec[selectIndex].states=true;
	
				this.updateContentlist();
			}
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

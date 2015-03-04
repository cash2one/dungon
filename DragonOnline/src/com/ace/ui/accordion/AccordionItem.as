package com.ace.ui.accordion {
	import com.ace.ICommon.IMenu;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AccordionItem extends Sprite implements IMenu {

		private var _lb:LabelButton;
		private var _continer:Sprite;
		private var _scrollPanel:ScrollPane;

		/**
		 * 显示列表
		 */
		private var _itemsVec:Vector.<DisplayObjectContainer>;

		/**
		 * 使用的宽
		 */
		private var _w:Number=200;
		/**
		 * 使用的高
		 */
		private var _h:Number=0;

		/**
		 * 标题高
		 */
		private var _titleH:Number=30;

		/**
		 * index
		 */
		public var index:int=0;

		/**
		 * 状态
		 */
		private var _states:Boolean=false;

		public var menuVec:Vector.<MenuInfo>;
		public var selectIndex:int=-1;

		public function AccordionItem(index:int=0, _w:Number=200, _h:Number=0, _titleHeight:Number=0) {
			super();
			this.index=index;
			this._w=_w;
			this._h=_h;
			this._titleH=_titleHeight;
			this.init();

			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			var rect:Rectangle=new Rectangle(12, 26, 233, 22);
			_lb=new LabelButton(LibManager.getInstance().getImg("ui/other/button_type1.png"), rect, _w, _titleH, "accordion_ttt", true);
			this.addChild(_lb);

			_continer=new Sprite();
			this.addChild(_continer);
			_h=_continer.y=_lb.height + 2;

			//_continer.visible=_states;

			_scrollPanel=new ScrollPane(_w, _h - _lb.height);
			_continer.addChild(_scrollPanel);

			_itemsVec=new Vector.<DisplayObjectContainer>();

			menuVec=new Vector.<MenuInfo>();
		}

		public function addItem(continer:DisplayObjectContainer):void {
			_scrollPanel.addToPane(continer);
			continer.y=this._itemsVec.length * continer.height;
			_itemsVec.push(continer);
		}

		/**
		 * 从第一个添加 
		 * @param continer
		 * 
		 */		
		public function addItemUnshift(continer:DisplayObjectContainer):void {
			_scrollPanel.addToPane(continer);
			_itemsVec.unshift(continer);
			this.updatePs();
		}

		/**
		 * 更新到位置 
		 * @param index
		 * @param continer
		 * 
		 */		
		public function addItemAt(index:int,continer:DisplayObjectContainer):void {
			_scrollPanel.addToPane(continer);
			_itemsVec.splice(index,0,continer);
			this.updatePs();
		}
		
		/**
		 *更新位置 
		 * 
		 */		
		public function updatePs():void {
			var con:DisplayObjectContainer;
			for (var i:int=0; i < this._itemsVec.length; i++) {
				this._itemsVec[i].y=i * this._itemsVec[i].height;
			}

			this._scrollPanel.scrollTo(0);
			DelayCallManager.getInstance().add(this, this._scrollPanel.updateUI, "updateUI", 4);
		}

		public function updateUI():void {
			this.removeAllList();

			while (this.numChildren)
				this.removeChildAt(0);

			var rect:Rectangle=new Rectangle(12, 26, 233, 22);
			_lb=new LabelButton(LibManager.getInstance().getImg("ui/other/button_type1.png"), rect, _w, _titleH, "accordion_ttt", true);
			this.addChild(_lb);

			_continer=new Sprite();
			this.addChild(_continer);
			_continer.y=_lb.height + 2;

			_scrollPanel=new ScrollPane(_w, (_h - _lb.height < 0 ? 0 : _h - _lb.height));
			_continer.addChild(_scrollPanel);

			_scrollPanel.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)

			this.updateContentList();
		}

		/**
		 * 重新改变list ui
		 *
		 */
		public function updateContentUi():void {

			this.removeAllList();
			_continer.removeChild(_scrollPanel);

			_scrollPanel=new ScrollPane(_w, (_h - _lb.height < 0 ? 0 : _h - _lb.height));
			_continer.addChild(_scrollPanel);

			_scrollPanel.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			this.updateContentList();
		}

		/**
		 * 改变title
		 *
		 */
		public function updateTitleUi():void {

			this.removeChild(this._lb);

			var rect:Rectangle=new Rectangle(12, 26, 233, 22);
			_lb=new LabelButton(LibManager.getInstance().getImg("ui/other/button_type1.png"), rect, _w, _titleH, "accordion_ttt", true);
			this.addChild(_lb);

			_continer.y=_lb.height + 2;
		}

		public function updateContentList():void {
			var con:DisplayObjectContainer;
			for each (con in this._itemsVec) {
				_scrollPanel.addToPane(con);
			}
			
			this._scrollPanel.scrollTo(0);
			DelayCallManager.getInstance().add(this, this._scrollPanel.updateUI, "updateUI", 4);
		}

		public function removeAllList():void {
			var con:DisplayObjectContainer;
			for each (con in this._itemsVec) {
				_scrollPanel.delFromPane(con);
			}
		}

		private function onMouseUp(e:MouseEvent):void {
//			trace(e.target,e.currentTarget,this._itemsVec.indexOf(e.target));
			if (menuVec != null && menuVec.length > 0) {
				selectIndex=this._itemsVec.indexOf(e.target as DisplayObjectContainer)
				MenuManager.getInstance().show(menuVec, this, new Point(e.stageX, e.stageY));
			}

		}

		public function onMenuClick(i:int):void {

			var menuinfo:Vector.<MenuInfo>=this.menuVec.filter(function(item:MenuInfo, _i:int, arr:Vector.<MenuInfo>):Boolean {
				if (item.menuIndex == i)
					return true;

				return false;
			});

			if (menuinfo != null && menuinfo.length > 0) {
				if (menuinfo[0].func != null && selectIndex != -1)
					menuinfo[0].func(Object(this._itemsVec[selectIndex]).data);
			}

			selectIndex=-1;
		}

		public function setMenu(menuVec:Vector.<MenuInfo>):void {
			this.menuVec=menuVec;
		}

		public function getTitleLbl():LabelButton {
			return this._lb;
		}

		/**
		 * 标题文本
		 * @param v
		 *
		 */
		public function setTitleTxt(v:String):void {
			this._lb.setTitleTxt(v);
		}

		public function setNumTxt(v:String):void {
			this._lb.setNumTxt(v);
		}

		/**
		 * 实际宽
		 * @param v
		 *
		 */
		public function setWidth(v:Number):void {
			_w=v;
		}

		/**
		 * 实际高
		 * @param v
		 *
		 */
		public function setHeight(v:Number):void {
			_h=v;
		}

		public function getWidth():Number {
			return _w;
		}

		/**
		 * 标题的高
		 * @param v
		 *
		 */
		public function set titleH(v:Number):void {
			this._titleH=v;
		}

		public function set states(v:Boolean):void {
			this._states=v;
			this._continer.visible=v;
		}

		public function get states():Boolean {
			return this._states;
		}

		/**
		 * 获取高
		 * @return
		 *
		 */
		public function getHeight():Number {
			if (_states)
				return _h;
			else
				return _lb.height
		}

	}
}

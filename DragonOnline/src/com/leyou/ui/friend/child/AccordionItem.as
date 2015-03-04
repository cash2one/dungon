package com.leyou.ui.friend.child {
	import com.ace.ICommon.IMenu;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
		private var _w:Number=256;
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
			
			this._w=_w;
			this._h=_h;
			this.index=index;
			this.mouseEnabled=true;
			this.mouseChildren=true;
			this._titleH=_titleHeight;
			this.init();
		}
		
		public function get lb():LabelButton
		{
			return _lb;
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
			
//			menuVec=new Vector.<MenuInfo>();
		}
		
		/**
		 * 在列表头添加显示项目
		 * 
		 */
		public function unshiftItem(display:DisplayObjectContainer, maxCount:int=20):void {
			_scrollPanel.addToPane(display);
			var index:int = _itemsVec.indexOf(display); 
			if(-1 == index){
				_itemsVec.splice(0, 0, display);
			}
			setNumTxt("(" + _itemsVec.length + "/"+maxCount+")");
		}
		
		/**
		 * 在列表尾添加显示项目
		 * 
		 */
		public function pushItem(display:DisplayObject, maxCount:int=20):void {
			_scrollPanel.addToPane(display);
			display.y = this._itemsVec.length * display.height;
			_itemsVec.push(display);
			setNumTxt("(" + _itemsVec.length + "/"+maxCount+")"); 
		}
		
		/**
		 * 更新好友项目
		 * 
		 */
		public function updateItemDate(o:Object, relation:int):void {
			var name:String = o[0];
			var doc:FriendDateBar = null;
			var length:int = _itemsVec.length;
			for(var n:int = 0; n < length; n++){
				doc = _itemsVec[n] as FriendDateBar;
				if(doc.info.name == name){
					break;
				}
			}
			if(null != doc){
				doc.updateInfo(o, relation);
			}
			sortItemsPosition();
		}
		
		/**
		 * 重新排序好友列表，使在线好友在列表前面
		 * 
		 */
		public function sortItemsPosition():void{
			_itemsVec.sort(function(friend1:FriendDateBar, friend2:FriendDateBar):Number{
				if(friend1.info.online && !friend2.info.online){
					return -1;
				}else if(!friend1.info.online && friend2.info.online){
					return 1;
				}
				return 0;
			});
			adjustItemPosition();
		}
		
		/**
		 * 重新调整列表位置关系
		 * 
		 */
		public function adjustItemPosition():void{
			var length:int = _itemsVec.length;
			for(var n:int = 0; n < length; n++){
				var display:DisplayObject = _itemsVec[n] as DisplayObject;
				display.y = n * 42;
			}
		}
		
		/**
		 * 根据角色名删除好友项
		 * 
		 */
		public function removeItemByName(name:String):void{
			var find:Boolean = false;
			var doc:FriendDateBar = null;
			var length:int = _itemsVec.length;
			for(var n:int = 0; n < length; n++){
				doc = _itemsVec[n] as FriendDateBar;
				if(!find){
					if(doc.info.name == name){
						_itemsVec.splice(n, 1);
						_scrollPanel.delFromPane(doc);
						doc.die();
						length = _itemsVec.length;
						n--;
						find = true;
					}
				}else{
					// 删除后需要重新调整位置
					doc.y -= 42/*doc.height*/;
				}
			}
			setNumTxt("(" + _itemsVec.length + "/20)");
		}
		
		public function updateUI():void {
			this.removeAllList();
			
			while (this.numChildren)
				this.removeChildAt(0);
			
			var rect:Rectangle=new Rectangle(12, 26, 233, 22);
			_lb=new LabelButton(LibManager.getInstance().getImg("ui/other/button_type1.png"), rect, _w, _titleH, "accordion_ttt", true);
			this.addChild(_lb);
			
			if(null == _continer){
				_continer =new Sprite();
			}
			this.addChild(_continer);
			_continer.y=_lb.height + 2;
			
			_scrollPanel=new ScrollPane(_w, (_h - _lb.height < 0 ? 0 : _h - _lb.height));
			_continer.addChild(_scrollPanel);
			
			_scrollPanel.addEventListener(MouseEvent.CLICK, onMouseClick)
			
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
			
			_scrollPanel.addEventListener(MouseEvent.CLICK, onMouseClick);
			
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
		}
		
		public function removeAllList():void {
			for each (var item:FriendDateBar in this._itemsVec) {
				_scrollPanel.delFromPane(item);
				item.die();
			}
			_itemsVec.length = 0;
		}
		
		private function onMouseClick(e:MouseEvent):void {
			//			trace(e.target,e.currentTarget,this._itemsVec.indexOf(e.target));
			e.stopPropagation();
			if (menuVec!=null && menuVec.length > 0 && (e.target is FriendDateBar)) {
				selectIndex=this._itemsVec.indexOf(e.target as DisplayObjectContainer)
				MenuManager.getInstance().show(menuVec, this);
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
					menuinfo[0].func(FriendDateBar(_itemsVec[selectIndex]).info);
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
			v = StringUtil_II.lpad(v, 13);
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
		
		/**
		 * 返回子items
		 * @param i
		 * @return
		 *
		 */
		public function getItem(i:int):DisplayObjectContainer {
			if(i >= 0 && i < _itemsVec.length){
				return _itemsVec[selectIndex];
			}
			return null;
		}
	}
}

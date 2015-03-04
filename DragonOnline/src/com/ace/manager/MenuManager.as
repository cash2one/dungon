package com.ace.manager {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.UIEnum;
	import com.ace.tools.ScaleBitmap;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.menu.MenuButton;
	import com.ace.ui.menu.data.MenuInfo;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MenuManager {

		private static var instance:MenuManager;

		public static function getInstance():MenuManager {
			if (!instance)
				instance=new MenuManager();

			return instance;
		}

		private var con:SpriteNoEvt; //菜单容器
		private var bg:ScaleBitmap;
		private var currentMenus:Vector.<MenuInfo>; //当前菜单s
		private var currentIMenu:IMenu; //当前单击的菜单

		public function MenuManager() {
			this.init();
		}

		//ui初始化
		private function init():void {
			this.con=new SpriteNoEvt();
			this.con.mouseEnabled=this.con.mouseChildren=true;
			LayerManager.getInstance().menuLayer.addChild(this.con);

			this.bg=new ScaleBitmap(SkinsManager.instance.getUIBmd("MenuBar_backgroundSkin"));
			this.bg.scale9Grid=SkinsManager.instance.getUIRect("MenuBar_backgroundSkin");
			this.con.addChild(this.bg);
		}


		private function addEvts():void {
			if (MouseManager.getInstance().hasFun(MouseEvent.MOUSE_MOVE, onMouseMove))
				return;
			MouseManager.getInstance().addFun(MouseEvent.MOUSE_MOVE, onMouseMove);
			MouseManager.getInstance().addFun(MouseEvent.CLICK, onMenuClick);
		}

		private function removeEvts():void {
			MouseManager.getInstance().removeFun(MouseEvent.MOUSE_MOVE, onMouseMove);
			MouseManager.getInstance().removeFun(MouseEvent.CLICK, onMenuClick);
		}

		private var tmpPt:Point;

		private function onMouseMove(evt:MouseEvent):void {
			if (!(evt.target is MenuButton)) {
				this.con.visible=false;
				this.removeEvts();
			}
		}

		//菜单单击
		private function onMenuClick(evt:MouseEvent):void {
			if (evt.target is MenuButton) {
				this.currentIMenu.onMenuClick(MenuButton(evt.target).index);
			}
			this.con.visible=false;
			this.removeEvts();
		}

		/**
		 * 显示菜单
		 * @param info 要显示的菜单
		 * @param iMenu 接受单击事件的接口
		 * @param pt 显示的位置
		 *
		 */
		public function show(info:Vector.<MenuInfo>, iMenu:IMenu, pt:Point=null):void {
			this.currentMenus=info;
			this.currentIMenu=iMenu;

			this.updateButton();
			pt=(pt != null ? pt : new Point(this.con.stage.mouseX - 15, this.con.stage.mouseY - 15));
			pt.x > (UIEnum.WIDTH - this.con.width - 3) && (pt.x=UIEnum.WIDTH - this.con.width - 3);
			pt.x < 0 && (pt.x=0);
			pt.y > (UIEnum.HEIGHT - this.con.height) && (pt.y=UIEnum.HEIGHT - this.con.height - 3);

			this.con.x=pt.x;
			this.con.y=pt.y;
			this.addEvts();
			this.con.visible=true;
		}

		public function hide():void {
			this.con.visible=false;
			this.clearMenuCon();
		}

		public function isShow():Boolean {
			return this.con.visible;
		}

		private function clearMenuCon():void {
			while (this.con.numChildren > 1) {
				this.con.removeChildAt(1);
			}
		}


		private var tmpH:Number=0;

		private function updateButton():void {
			this.clearMenuCon();

			tmpH=0;
			var btn:MenuButton;
			for (var i:int=0; i < this.currentMenus.length; i++) {
				if (this.currentMenus[i] == null)
					continue;
				btn=new MenuButton(this.currentMenus[i].menuName, this.currentMenus[i].menuIndex);
				this.con.addChild(btn);
				btn.y=tmpH;
				tmpH+=btn.height;
			}

			this.bg.setSize(btn.width + 4, tmpH + 4);
		}

	}
}

/*
*
负责右键菜单
1：单击时显示隐藏
2：鼠标移除菜单后隐藏
3：单击菜单时回调
*/

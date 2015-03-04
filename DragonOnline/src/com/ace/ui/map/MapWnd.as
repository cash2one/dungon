/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-26 下午4:58:59
 */
package com.ace.ui.map {
	import com.ace.enum.UIEnum;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.wnd.BigMap;
	import com.ace.ui.map.wnd.WorldMapView;
	
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class MapWnd extends AutoWindow {
		private static var instance:MapWnd;

		private var switchBtn:NormalButton;
		private var lxLbl:Label;
		private var lyLbl:Label;
		private var bgImg:ScaleBitmap;
		private var btnImg:Image;
		private var mapBar:AutoSprite;
		private var mapNameLbl:Label;

		public static function getInstance():MapWnd {
			if (!instance) {
				instance=new MapWnd();
				instance.init();
			}
			return instance;
		}

		public var bigMap:BigMap;
		public var worldMap:WorldMapView;

		public function MapWnd() {
			super(new XML("<TitleWindow width='100' height='100'/>"));
			LayerManager.getInstance().windowLayer.addChild(this);
			KeysManager.getInstance().addKeyFun(Keyboard.M, open);
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		public function init():void {
			mapBar=new AutoSprite(LibManager.getInstance().getXML("config/ui/MapWnd.xml"));
			mapBar.mouseChildren=true;
			bigMap=new BigMap();
			worldMap=new WorldMapView();
			addToPane(bigMap);
			addToPane(worldMap);
			addToPane(mapBar);
			worldMap.hide();

			lxLbl=mapBar.getUIbyID("lxLbl") as Label;
			lyLbl=mapBar.getUIbyID("lyLbl") as Label;
			btnImg=mapBar.getUIbyID("btnImg") as Image;
			bgImg=mapBar.getUIbyID("bgImg") as ScaleBitmap;
			mapNameLbl=mapBar.getUIbyID("mapNameLbl") as Label;
			switchBtn=mapBar.getUIbyID("switchBtn") as NormalButton;
			switchBtn.addEventListener(MouseEvent.CLICK, onSwitchClick);
			mouseChildren=true;
			hideBg();
			resize(bigMap.width, bigMap.height);
		}

		/**
		 * <T>地图转换按钮点击</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onSwitchClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "switchBtn":
					switchMapView();
					break;
			}

		}
		
		public function hideSwitch():void{
			if(!bigMap.visible){
				if(bigMap.visible){
					bigMap.hide();
					worldMap.show();
				}else{
					bigMap.show();
					worldMap.hide();
				}
				resize(width, width);
			}
			btnImg.visible = false;
			switchBtn.visible = false;
		}
		
		public function resetSwitch():void{
			if(!btnImg.visible){
				btnImg.visible = true;
				switchBtn.visible = true;
			}
		}

		/**
		 * <T>转换显示地图</T>
		 *
		 */
		public function switchMapView():void {
			if(bigMap.visible){
				bigMap.hide();
				worldMap.show();
			}else{
				bigMap.show();
				worldMap.hide();
			}
			resize(width, height);
			super.show(true, UIEnum.WND_LAYER_NORMAL, true);
		}

		/**
		 * <T>重新调整按钮位置</T>
		 *
		 * @param $w 显示对象宽度
		 * @param $h 显示对象高度
		 *
		 */
		public function resize($w:Number, $h:Number):void {
			if (!bigMap)
				return;
			if (worldMap.visible) {
				$w=width;
				$h=height;
				worldMap.setFocusPoint();
				btnImg.updateBmp("ui/map/font_dqdt.png");
			} else {
				btnImg.updateBmp("ui/map/font_sjdt.png");
			}
			mapBar.y=$h - bgImg.y;
			bgImg.setSize($w, bgImg.height);
			switchBtn.x=$w - 100 - 5;
			btnImg.x=switchBtn.x + 8;
			clsBtn.x=$w - 18;
			clsBtn.y=-clsBtn.height * 0.5+3;
		}

		public override function get width():Number {
			return (bigMap.visible ? bigMap.width : worldMap.width);
		}

		public override function get height():Number {
			return (bigMap.visible ? bigMap.height : worldMap.height);
		}

		/**
		 * <T>显示</T>
		 *
		 * @param toTop    是否置顶
		 * @param $layer   显示呈
		 * @param toCenter 是否中心显示
		 *
		 */
		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			this.bigMap.show();
			super.show(toCenter, $layer, toCenter);
			resize(width, height);
		}

		override public function hide():void {
			super.hide();
			this.bigMap.hide();
			this.worldMap.hide();
		}

		public function refreshMapStatus():void {
			worldMap.checkAvailable();
		}

		public function updateName(na:String):void {
			mapNameLbl.text=na
		}

		public function updatePs(lx:int, ly:int):void {
			lxLbl.text="X:" + lx;
			lyLbl.text="Y:" + ly;
		}
	}
}

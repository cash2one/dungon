package com.ace.ui.map.wnd {
	import com.ace.ICommon.ILoaderCallBack;
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.loaderSync.child.BackObj;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.utils.ImageUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.utils.PropUtils;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WorldMapView extends AutoSprite implements ILoaderCallBack {

		private var bg:ScaleBitmap;

		private var view:MovieClip;

		private var flyBtn:ImgButton;

		private var point:SwfLoader;

		public function WorldMapView() {
			super(new XML());
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseChildren=true;
			bg=ImageUtil.getScaleBitmap("PanelBgIn", false);
			flyBtn=new ImgButton("ui/map/btn_fei.png");
			flyBtn.visible=false;
			flyBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
//			flyBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);
			bg.setSize(818, 498);
			addChild(bg);
			point=new SwfLoader(99927);
			ReuseManager.getInstance().swfSyLoader.addLoader("ui/worldMap/worldMap.swf", new BackObj(this), PriorityEnum.FIVE);
		}

//		protected function onBtnOut(event:MouseEvent):void{
//		}

		protected function onBtnOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(9937).content;
			var timec:String = MyInfoManager.getInstance().VipLastTransterCount+"";
			if(-1 == MyInfoManager.getInstance().VipLastTransterCount){
				timec = PropUtils.getStringById(1890);
			}
			content=StringUtil.substitute(content, timec);
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		/**
		 * <T>点击句柄函数</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function clickHandler(event:MouseEvent):void {
			var taget:Object=event.target;
			var mapId:String=taget.name.substr(3, 3);
			Core.me.gotoMap(new Point(-1, -1), mapId);
		}

		/**
		 * <T>显示当前所在点</T>
		 * @param mapId
		 *
		 */
		public function setFocusPoint():void {
			var mapId:int=int(MapInfoManager.getInstance().sceneId);
			if ((0 == mapId) || (null == view)) {
				return;
			}
			var focusBtn:SimpleButton;
			var l:int=view.numChildren;
			for (var n:int=0; n < l; n++) {
				focusBtn=view.getChildAt(n) as SimpleButton;
				if (focusBtn && (-1 != focusBtn.name.indexOf(mapId + ""))) {
					break;
				}
			}
			point.x=focusBtn.x - (point.width >> 1);
			point.y=focusBtn.y - (point.height >> 1);
		}

		/**
		 * <T>显示</T>
		 *
		 */
		public override function show():void {
			this.visible=true;
			if (null != view) {
				setFocusPoint();
			}
		}

		public function callBackFun(obj:Object):void {
			view=LibManager.getInstance().getMc("ui/worldMap/worldMap.swf");
			view.addEventListener(MouseEvent.CLICK, clickHandler);
			view.x=5;
			view.y=5;
			addChild(view);
			addChild(point);
			addChild(flyBtn);
			checkAvailable();
			view.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			view.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			flyBtn.addEventListener(MouseEvent.CLICK, onFlyClick);
		}

		protected function onMouseOut(event:MouseEvent):void {
			if ((event.target == currentBtn) && (flyBtn != event.relatedObject)) {
				flyBtn.visible=false;
			}
		}

		protected function onMouseOver(event:MouseEvent):void {
			if (event.target is SimpleButton) {
				currentBtn=event.target as SimpleButton;
//				trace("-----------------------target ben name = "+event.target.name+"current target = "+event.currentTarget);
				var level:int=Core.me.info.level;
				var flag:String=event.target.name;
				var separator:int=flag.indexOf("_");
				var limitLv:int=int(flag.substr(separator + 1));
				var mapId:String=flag.substr(3, 3);
				if("111" == mapId){
					return;
				}
				var sceneInfo:TSceneInfo=TableManager.getInstance().getSceneInfo(mapId);
				var content:String;
				if (limitLv > level) {
					content=TableManager.getInstance().getSystemNotice(9971).content;
					content=StringUtil.substitute(content, limitLv);
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
				} else if (!sceneInfo.active) {
					content=TableManager.getInstance().getSystemNotice(9984).content;
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
				} else {
					flyBtn.visible=true;
					flyBtn.x=event.target.x - (flyBtn.width * 0.5);
					flyBtn.y=event.target.y - (flyBtn.height * 0.5);
				}
			}
		}

		private var currentBtn:SimpleButton;

		protected function onFlyClick(event:MouseEvent):void {
			if (null == currentBtn)
				return;
			var mapId:String=currentBtn.name.substr(3, 3);
			var sceneInfo:TSceneInfo=TableManager.getInstance().getSceneInfo(mapId);
			if (sceneInfo.active) {
				Cmd_Go.cmGoPoint(int(mapId), sceneInfo.safeTX, sceneInfo.safeTY);
			}
		}

		/**
		 * <T>隐藏</T>
		 *
		 */
		public override function hide():void {
			this.visible=false;
		}

		public function checkAvailable():void {
			if (null == view || null == Core.me) {
				return;
			}
			var level:int=Core.me.info.level;
			var l:int=view.numChildren;
			for (var n:int=0; n < l; n++) {
				var focusBtn:SimpleButton=view.getChildAt(n) as SimpleButton;
				if (null != focusBtn) {
					var flag:String=focusBtn.name;
					var separator:int=flag.indexOf("_");
					var limitLv:int=int(flag.substr(separator + 1));
					var mapId:String=flag.substr(3, 3);
					var sceneInfo:TSceneInfo=TableManager.getInstance().getSceneInfo(mapId);
					if ((limitLv > level) || !sceneInfo.active) {
						focusBtn.filters=[FilterEnum.enable];
					} else {
						focusBtn.filters=null;
					}
				}
			}
		}
	}
}

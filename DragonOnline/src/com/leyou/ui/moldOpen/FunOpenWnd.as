package com.leyou.ui.moldOpen {
	import com.ace.enum.EventEnum;
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMount;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FunOpenWnd extends AutoWindow {
		private var confirmBtn:NormalButton;

		private var callImg:Image;

		private var gridImg:Image;

		private var movie:SwfLoader;

		private var ctype:int=-1;

		private var listener:Function;

		private var modeQueue:Vector.<int>;

		private var modeFunQueue:Vector.<Function>;

		public function FunOpenWnd() {
			super(LibManager.getInstance().getXML("config/ui/funWnd.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			allowDrag=false;
			hideBg();
			clsBtn.visible=false;
			confirmBtn=getUIbyID("confirmBtn") as NormalButton;
			callImg=getUIbyID("callImg") as Image;
			gridImg=getUIbyID("gridImg") as Image;
			movie=new SwfLoader();
			addChild(movie);
			movie.x=152;
			movie.y=180;
			resize();
			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			modeQueue=new Vector.<int>();
			modeFunQueue=new Vector.<Function>();

//			EventManager.getInstance().addEvent(EventEnum.UI_MOVE_OVER, onUIMoveOver);
		}

//		private function onUIMoveOver(type:int):void{
//			if(WindowEnum.FUN_OPEN != type){
//				return;
//			}
//			switch(ctype){
//				case FunOpenEnum.BACKPACK_GRID:
//					confirmBtn.text = "背包格子开启";
//					break;
//				case FunOpenEnum.STORAGE_GRID:
//					confirmBtn.text = "仓库格子开启";
//					break;
//				case FunOpenEnum.RIDE:
//					confirmBtn.text = "立即骑乘";
//					break;
//				case FunOpenEnum.SPRITE:
//					confirmBtn.text = "立即召唤";
//					break;
//			}
//		}

		protected function onMouseClick(event:MouseEvent):void {
			if (FunOpenEnum.SPRITE == ctype) {
				var vipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(DataManager.getInstance().vipData.vipLv);
				var mpt:Point=movie.localToGlobal(new Point(0, 0));
				var flyMovie:SwfLoader=new SwfLoader(vipInfo.modelBigId);
//				flyMovie.playAct("stand", 6);
				flyMovie.x=mpt.x;
				flyMovie.y=mpt.y;
				LayerManager.getInstance().windowLayer.addChild(flyMovie);
				var endW:int=flyMovie.width;
				var endH:int=flyMovie.height;
				var beginX:int=flyMovie.x + flyMovie.width * 0.5;
				var beginY:int=flyMovie.y + flyMovie.height * 0.5;
				var endX:int=UIEnum.WIDTH * 0.5;
				var endY:int=UIEnum.HEIGHT * 0.5;
				TweenMax.to(flyMovie, 3, {bezierThrough: [{x: beginX, y: beginY}, {x: endX, y: endY}], width: endW * 0.5, height: endH * 0.5, ease: Expo.easeIn(1, 10, 1, 1), onComplete: onMoveOver, onCompleteParams: [flyMovie, listener]});
			} else {
				if (null != listener) {
					listener.call(this);
				}
			}
			ctype=-1;
			listener=null;
			if (-1 != ctype || modeQueue.length <= 0) {
				if (visible) {
					hide();
				}
			} else {
				openNext();
			}
		}

		public override function hide():void {
			super.hide();
			onMouseClick(null);
		}

		private function onMoveOver(mc:SwfLoader, callBack:Function):void {
			if (LayerManager.getInstance().windowLayer.contains(mc)) {
				LayerManager.getInstance().windowLayer.removeChild(mc);
			}
			mc.die();
			if (null != callBack) {
				callBack.call(this);
			}
		}

		public function resize():void {
			x=(UIEnum.WIDTH - 575);
			y=((UIEnum.HEIGHT - 246) >> 1);
		}

		/**
		 * 功能开启
		 *
		 * @param type 开启类型
		 * @param fun  点击回调
		 *
		 */
		public function openFun(type:int, fun:Function=null):void {
			if (ctype == type || -1 != modeQueue.indexOf(type)) {
				return;
			}
			modeQueue.push(type);
			modeFunQueue.push(fun);
			openNext();
		}

		private function openNext():void {
			if (-1 != ctype || modeQueue.length <= 0) {
				return;
			}
			ctype=modeQueue.shift();
			listener=modeFunQueue.shift();
			switch (ctype) {
				case FunOpenEnum.BACKPACK_GRID:
					callImg.visible=false;
					gridImg.visible=true;
					movie.visible=false;
					confirmBtn.text=PropUtils.getStringById(1790);
					break;
				case FunOpenEnum.STORAGE_GRID:
					callImg.visible=false;
					gridImg.visible=true;
					movie.visible=false;
					confirmBtn.text=PropUtils.getStringById(1791);
					break;
				case FunOpenEnum.RIDE:
					callImg.visible=false;
					gridImg.visible=false;
					movie.visible=true;
					confirmBtn.text=PropUtils.getStringById(1792);

					var tmount:TMount=TableManager.getInstance().getMountByLv(1);
					movie.update(tmount.UI_ModeId);
					movie.playAct("stand", 3);
					break;
				case FunOpenEnum.SPRITE:
					callImg.visible=true;
					gridImg.visible=false;
					movie.visible=true;
					confirmBtn.text=PropUtils.getStringById(1793);

					var vipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(DataManager.getInstance().vipData.vipLv);
					movie.update(vipInfo.modelBigId);
					movie.playAct("stand", 6);
					break;
//				case FunOpenEnum.WING:
//					callImg.visible = false;
//					gridImg.visible = false;
//					movie.visible = true;
//					confirmBtn.text = "立即获得";
//					
//					movie.update(ConfigEnum.WingShowModeID); 
//					break;
			}
		}
	}
}

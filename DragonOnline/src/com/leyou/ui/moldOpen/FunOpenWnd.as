package com.leyou.ui.moldOpen {
	import com.ace.config.Core;
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TMount;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FunOpenWnd extends AutoWindow {
		private var confirmBtn:NormalButton;

		private var callImg:Image;

		private var gridImg:Image;
		private var lockLbl:Label;

		private var movie:SwfLoader;
		private var priceImg:Image;
		private var priceBgImg:Image;

		private var ctype:int=-1;

		private var listener:Function;
		private var params:Object;

		private var modeQueue:Vector.<int>;

		private var modeQueueParams:Array=[];

		private var modeFunQueue:Vector.<Function>;

		private var bigAvater:BigAvatar;
		private var swfloader:Loader;

		private var dis:DisplayObject;

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
			this.lockLbl=getUIbyID("lockLbl") as Label;
			movie=new SwfLoader();
			addChild(movie);
			movie.x=152;
			movie.y=180;

			this.priceBgImg=new Image("ui/tips/TIPS_bg_frame.png");
			addChild(priceBgImg);
			priceBgImg.x=52;
			priceBgImg.y=80;

			this.priceImg=new Image();
			addChild(priceImg);
			priceImg.x=52;
			priceImg.y=80;

			resize();
			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			modeQueue=new Vector.<int>();
			modeFunQueue=new Vector.<Function>();


			this.swfloader=new Loader();
			this.swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);

			this.bigAvater=new BigAvatar();
			this.addChild(this.bigAvater);


//			EventManager.getInstance().addEvent(EventEnum.UI_MOVE_OVER, onUIMoveOver);
		}

		private function onComplete(e:Event):void {

			if (this.dis != null && this.dis.parent == this)
				this.removeChild(this.dis);

			this.dis=e.target.content as DisplayObject;
			this.addChild(dis);

			this.dis.x=41;
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
				} else if (params != null) {
					var tinfo:TTitle=TableManager.getInstance().getTitleByID(params[0]);

					if (!UIManager.getInstance().isCreate(WindowEnum.SHIYI))
						UIManager.getInstance().creatWindow(WindowEnum.SHIYI);

					UILayoutManager.getInstance().show_II(WindowEnum.SHIYI);
					TweenLite.delayedCall(0.6, UIManager.getInstance().shiyeWnd.setTabIndex, [[2, 7, 3, 4, 5, 6, 1].indexOf(tinfo.Sz_type)]);

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
//			onMouseClick(null);

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
			x=(UIEnum.WIDTH - 575) >> 1;
			y=((UIEnum.HEIGHT - 246) >> 1);
		}

		/**
		 * 功能开启
		 *
		 * @param type 开启类型
		 * @param fun  点击回调
		 *
		 */
		public function openFun(type:int, fun:Function=null, params:Object=null):void {
			if (ctype == type || -1 != modeQueue.indexOf(type)) {
				return;
			}
			modeQueue.push(type);
			modeFunQueue.push(fun);
			modeQueueParams.push(params);
			openNext();
		}

		private function openNext():void {
			if (-1 != ctype || modeQueue.length <= 0) {
				return;
			}
			ctype=modeQueue.shift();
			listener=modeFunQueue.shift();
			params=modeQueueParams.shift();

			switch (ctype) {
				case FunOpenEnum.BACKPACK_GRID:
//					callImg.visible=false;
					gridImg.visible=true;
					movie.visible=false;

					this.bigAvater.visible=false;
					this.priceBgImg.visible=false;
					priceImg.fillEmptyBmd();
					this.lockLbl.text="" + PropUtils.getStringById(2409);
					confirmBtn.text=PropUtils.getStringById(1790);
					break;
				case FunOpenEnum.STORAGE_GRID:
//					callImg.visible=false;
					gridImg.visible=true;
					movie.visible=false;

					this.bigAvater.visible=false;
					this.priceBgImg.visible=false;
					priceImg.fillEmptyBmd();

					this.lockLbl.text="" + PropUtils.getStringById(2410);
					confirmBtn.text=PropUtils.getStringById(1791);
					break;
				case FunOpenEnum.RIDE:
//					callImg.visible=false;
					gridImg.visible=false;
					movie.visible=true;
					this.priceBgImg.visible=false;
					confirmBtn.text=PropUtils.getStringById(1792);
//					this.lockLbl.text="" + TableManager.getInstance().getSystemNotice(2363).content;

					var tmount:TMount=TableManager.getInstance().getMountByLv(1);
					movie.update(tmount.UI_ModeId);
					movie.playAct("stand", 3);
					break;
				case FunOpenEnum.SPRITE:
//					callImg.visible=true;
					gridImg.visible=false;
					movie.visible=true;
					confirmBtn.text=PropUtils.getStringById(1793);

					var vipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(DataManager.getInstance().vipData.vipLv);
					movie.update(vipInfo.modelBigId);
					movie.playAct("stand", 6);
					break;
				case FunOpenEnum.SHIYIJIANG:
//					callImg.visible = false;
					gridImg.visible=false;
					movie.visible=true;
					this.bigAvater.visible=false;
					this.priceBgImg.visible=false;
					priceImg.fillEmptyBmd();
					confirmBtn.text=PropUtils.getStringById(2369);

					var tinfo:TTitle=TableManager.getInstance().getTitleByID(params[0]);

					movie.x=152;
					movie.y=180;

					switch (tinfo.Sz_type) {
						case 1:
							if (int(tinfo.model2) > 0) {

								movie.x=52;
								movie.y=80;
								this.movie.update(int(tinfo.model2));

								if (tinfo.Bottom_Pic != "")
									this.priceImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");
								movie.playAct("stand", 3);
							} else if (tinfo.Bottom_Pic != "") {
								this.movie.visible=false;
								this.priceImg.updateBmp("scene/title/" + tinfo.Bottom_Pic + ".png");
							}
							
							this.addChild(this.priceImg);
							this.addChild(this.movie);

							this.bigAvater.showII(Core.me.info.featureInfo, false, Core.me.info.profession);

							this.priceImg.x=50;
							this.priceImg.y=-140;

							movie.x=52;
							movie.y=-140;

							this.bigAvater.x=150;
							this.bigAvater.y=190;

							this.bigAvater.visible=true;

							this.lockLbl.text="" + PropUtils.getStringById(2403);
							break;
						case 2:
							movie.visible=false;
							this.bigAvater.visible=true;
//							this.movie.update(int(tinfo.model2.split("|")[Core.me.info.profession - 1].split(",")[1]));
//							movie.playAct("stand", 3);

							var finfo:FeatureInfo=new FeatureInfo();
							finfo.weapon=PnfUtil.realAvtId(tinfo.model.split("|")[Core.me.info.profession - 1].split(",")[0], false, Core.me.info.sex);
							finfo.suit=PnfUtil.realAvtId(tinfo.model.split("|")[Core.me.info.profession - 1].split(",")[1], false, Core.me.info.sex);

							this.bigAvater.show(finfo, false, Core.me.info.profession);
							this.bigAvater.playAct(PlayerEnum.ACT_STAND, 4);
							this.bigAvater.x=150;
							this.bigAvater.y=190;

							this.lockLbl.text="" + PropUtils.getStringById(2365);
							break;
						case 3:
							this.movie.update(int(tinfo.model2));
							movie.playAct("stand", 3);
							this.lockLbl.text="" + PropUtils.getStringById(2363);
							break;
						case 4:
							this.movie.update(int(tinfo.model2));
							movie.playAct("stand", 3);

							movie.x=132;
							movie.y=280;
							this.lockLbl.text="" + PropUtils.getStringById(2364);
							break;
						case 5:

							this.priceImg.x=120;
							this.priceImg.y=70;
//							this.swfloader.load(new URLRequest(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv.split("|")[Core.me.info.profession - 1])));
							this.priceImg.updateBmp("ico/items/" + tinfo.Bottom_Pic + ".png");
							this.lockLbl.text="" + PropUtils.getStringById(2405);
							movie.visible=false;
							this.priceBgImg.visible=true;
							break;
						case 6:

							this.priceImg.x=120;
							this.priceImg.y=70;

//							this.swfloader.load(new URLRequest(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv)));
							this.priceImg.updateBmp("ico/items/" + tinfo.Bottom_Pic + ".png");
							this.lockLbl.text="" + PropUtils.getStringById(2404);
							movie.visible=false;
							this.priceBgImg.visible=true;
							break;
						case 7:
							this.bigAvater.visible=true;
							this.bigAvater.showII(Core.me.info.featureInfo, true, Core.me.info.profession);

							this.bigAvater.x=150;
							this.bigAvater.y=190;

							var pinfo:TPnfInfo=TableManager.getInstance().getPnfInfo(int(tinfo.model2));

							this.movie.update(int(tinfo.model2));

							if (pinfo.type == 10) {
//								this.movie.x=150;
//								this.movie.y=335;
								this.addChild(this.bigAvater);

							} else if (pinfo.type == 3) {
//								this.movie.x=150;
//								this.movie.y=190;
								this.addChild(this.movie);
							}

							movie.playAct("stand", 3);
							this.lockLbl.text="" + PropUtils.getStringById(2367);
							break;
					}

					priceBgImg.x=this.priceImg.x - 2;
					priceBgImg.y=this.priceImg.y - 2;
					break;

			}
		}
	}
}

package com.ace.loader.pre {
	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.FileEnum;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.LoopManager;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.ImageUtil;
	import com.ace.utils.LoadUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	public class PreLoaderImg extends PreLoaderModel {
		private static const PROGRESS_OFFSET:int=45;
		private static const PROGRESS_VALID_WIDTH:int=675;

		private var bgImg:Bitmap;
		private var proressBgImg:Bitmap;
		private var progressCoverImg:Bitmap;
		private var logoEffectImg:Bitmap;
		private var contanier:Sprite;
		private var text:TextField;
		private var progressText:TextField;

		private var logoImg:Image;

		public function PreLoaderImg(root:Sprite, fun:Function) {
			super(root, fun);
		}

		override protected function loadListOver():void {
			super.loadListOver();
			LibManager.getInstance().load([LoadUtil.libNoCach(FileEnum.PRE_GAME_IMG), LoadUtil.libNoCach("ui/loading/logo.png")], onComplete);
		}

		private function onComplete():void {
			ImageUtil.cutBigImg(FileEnum.PRE_GAME_IMG, null, this.logxml);
			this.initUI();
			this.start();
		}

		private function initUI():void {
			bgImg=new Bitmap();
			bgImg.bitmapData=LibManager.getInstance().getImg(FileEnum.ACE_FILE + "pre/icon_logo.png");
			proressBgImg=new Bitmap();
			proressBgImg.bitmapData=LibManager.getInstance().getImg(FileEnum.ACE_FILE + "pre/logo_bg.png");
			progressCoverImg=new Bitmap();
			progressCoverImg.bitmapData=LibManager.getInstance().getImg(FileEnum.ACE_FILE + "pre/logo_bar1.png")
			logoEffectImg=new Bitmap();
			logoEffectImg.bitmapData=LibManager.getInstance().getImg(FileEnum.ACE_FILE + "pre/logo_bar2.png");
			proressBgImg.y=(bgImg.height - proressBgImg.height) * 0.5 + 220;
			logoEffectImg.y=proressBgImg.y;
			progressCoverImg.y=proressBgImg.y;
			proressBgImg.x=(bgImg.width - proressBgImg.width) * 0.5
			progressCoverImg.x=proressBgImg.x;

			progressCoverImg.scrollRect=new Rectangle(0, 0, PROGRESS_OFFSET, progressCoverImg.bitmapData.height);
			logoEffectImg.x=progressCoverImg.x + progressCoverImg.scrollRect.width - logoEffectImg.width * 0.5;

			progressText=new TextField();
			progressText.defaultTextFormat=new TextFormat(null, 16, 0xffffff, true);
			progressText.autoSize=TextFieldAutoSize.LEFT;
			progressText.text="100%";
			progressText.x=progressCoverImg.x + (progressCoverImg.width - progressText.width) * 0.5;
			progressText.y=proressBgImg.y + 12;
			progressText.text="0%";

			text=new TextField();
			text.autoSize=TextFieldAutoSize.LEFT;
			text.textColor=0xffffff;
			text.filters=[FilterEnum.hei_miaobian];
			text.text="抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。";
			if (this.gameRoot.stage.loaderInfo.parameters.hasOwnProperty("version")) {
				this.text.appendText(this.gameRoot.stage.loaderInfo.parameters.version);
			} else {
				this.text.appendText( /*"（" + UIEnum.PLAT_FORM_ID + "）" + */UIEnum.VERSIONCM);
			}

			text.x=progressCoverImg.x + (progressCoverImg.width - text.width) * 0.5;
			text.y=proressBgImg.y + proressBgImg.height + 20;

			logoImg=new Image();
			logoImg.updateBmp("ui/loading/logo.png", onLogo, false, -1, -1, 7);

			contanier=new Sprite();
			contanier.addChild(bgImg);
			contanier.addChild(logoImg);
			contanier.addChild(proressBgImg);
			contanier.addChild(progressCoverImg);
			contanier.addChild(logoEffectImg);
			contanier.addChild(text);
			contanier.addChild(progressText);
			contanier.x=(UIEnum.WIDTH - contanier.width) * 0.5;
			contanier.y=(UIEnum.HEIGHT - contanier.height) * 0.5;
			this.gameRoot.addChild(contanier);
		}

		private function onLogo():void {
			logoImg.x=(bgImg.width - logoImg.width) * 0.5;
		}

		override public function onLoading(byteNow:int, byteAll:int):void {
//			byteAll=2058395;//4439415;
//			trace("-----------byteNow = "+byteNow+"--------byteAll = "+byteAll);
			var progress:Number;
			if (byteNow == 0 || byteAll == 0) {
				setProgress(0);
			} else {
//				progress=Number((byteNow / byteAll).toFixed(2));
				setProgress(Number((byteNow / byteAll).toFixed(2)));
			}
		}

		override public function onLoaded():void {
			setProgress(1);
			progressText.text="准备资源中....";
			super.onLoaded();
//			DelayCallManager.getInstance().add(this, this.onLoaded2, "onLoaded2", 1);
			setTimeout(this.setUp, 10);
		}

		override protected function setUp():void {
			super.setUp();
			this.die();
		}

		private function setProgress(rate:Number):void {
			if (rate <= preProgress) {
				return;
			}
			if (rate > 1) {
				rate=1;
			}
			progressText.text=(rate * 100).toFixed() + "%";
			preProgress=rate;
			var viewRect:Rectangle=progressCoverImg.scrollRect;
			var changeWidth:Number=PROGRESS_VALID_WIDTH * preProgress;
			viewRect.width=PROGRESS_OFFSET + changeWidth;
			progressCoverImg.scrollRect=viewRect;
			logoEffectImg.x=progressCoverImg.x + viewRect.width - logoEffectImg.width * 0.5;
		}

		private function die():void {
			this.contanier.removeChild(this.proressBgImg);
			this.contanier.removeChild(this.progressCoverImg);
			this.contanier.removeChild(this.logoEffectImg);
			this.contanier.removeChild(this.bgImg);
			this.gameRoot.removeChild(contanier);

			this.proressBgImg.bitmapData.dispose();
			this.progressCoverImg.bitmapData.dispose();
			this.logoEffectImg.bitmapData.dispose();
			this.bgImg.bitmapData.dispose();
		}
		private var logxml:XML=<TextureAtlas imagePath="loading.png">
				<SubTexture name="icon_logo.png" x="0" y="0" width="1000" height="600"/>
				<SubTexture name="logo_bar1.png" x="0" y="600" width="761" height="48"/>
				<SubTexture name="logo_bar2.png" x="761" y="600" width="22" height="48"/>
				<SubTexture name="logo_bg.png" x="0" y="648" width="761" height="48"/>
			</TextureAtlas>;
	}
}

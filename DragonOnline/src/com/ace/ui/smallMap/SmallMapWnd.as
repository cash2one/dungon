package com.ace.ui.smallMap {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSpriteII;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.MapWnd;
	import com.ace.utils.DebugUtil;
	import com.ace.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SmallMapWnd extends AutoSpriteII {

		private var nameLbl:Label;
		private var tileXLbl:Label;
		private var tileYLbl:Label;
		private var mapBtn:ImgButton;
		private var mailBtn:ImgButton;
		private var hideBtn:ImgButton;
		private var soundBtn:ImgButton;
		private var shieldViewImg:Image;
		private var shieldSoundImg:Image;
		private var leftBtn:ImgButton;
		private var rightBtn:ImgButton;
		private var circleMc:SwfLoader;
		private var logBtn:ImgButton;

		public function SmallMapWnd() {
			super("config/ui/SmallMapWnd.xml");
			this.mouseChildren=true;
			this.cacheAsBitmap=true;
		}

		override protected function init():void {
			super.init();

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.tileXLbl=this.getUIbyID("tileXLbl") as Label;
			this.tileYLbl=this.getUIbyID("tileYLbl") as Label;
			this.mapBtn=this.getUIbyID("mapBtn") as ImgButton;
			this.mailBtn=this.getUIbyID("mailBtn") as ImgButton;
			this.hideBtn=this.getUIbyID("hideBtn") as ImgButton;
			this.soundBtn=this.getUIbyID("soundBtn") as ImgButton;
			this.leftBtn=this.getUIbyID("mapLeft") as ImgButton;
			this.rightBtn=this.getUIbyID("mapRight") as ImgButton;
			this.logBtn=this.getUIbyID("logBtn") as ImgButton;
			shieldViewImg=getUIbyID("shieldViewImg") as Image;
			shieldSoundImg=getUIbyID("shieldSoundImg") as Image;
			circleMc=getUIbyID("circleMc") as SwfLoader;
			
			shieldViewImg.visible=false;
			shieldSoundImg.visible=false;

			this.logBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.mapBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.mailBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.hideBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.hideBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.soundBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.soundBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.leftBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.rightBtn.addEventListener(MouseEvent.CLICK, onCLick);
			
			this.updateName();
			this.updatePs(Core.me);
			
			EventManager.getInstance().addEvent(EventEnum.LOW_FRAME, showGuide);

			DebugUtil.cacheLabel(this);
		}
		
		private function showGuide():void{
//			GuideManager.getInstance().showGuide(99, hideBtn);
		}
		
		protected function onMouseOut(event:MouseEvent):void {
			switch (event.target.name) {
				case "hideBtn":
					if (UIManager.getInstance().viewConfig != event.relatedObject) {
						UIManager.getInstance().viewConfig.hide();
					}
					break;
				case "soundBtn":
					if (UIManager.getInstance().soundConfig != event.relatedObject) {
						UIManager.getInstance().soundConfig.hide();
					}
					break;
			}
		}
		
		public function setSound(v:Boolean):void {
			shieldSoundImg.visible=v;
		}

		public function setView(v:Boolean):void {
			shieldViewImg.visible=v;
		}

		protected function onMouseOver(event:MouseEvent):void {
			switch (event.target.name) {
				case "hideBtn":
					UIManager.getInstance().viewConfig.show();
					break;
				case "soundBtn":
					UIManager.getInstance().soundConfig.show();
					break;
			}
		}

		public function updateName():void {
			if (!this.isInit || StringUtil.isWhitespace(MapInfoManager.getInstance().sceneId))
				return;
			if (UIManager.getInstance().gameScene.isInitOk)
				this.nameLbl.text=TableManager.getInstance().getSceneInfo(MapInfoManager.getInstance().sceneId).name;
			MapWnd.getInstance().updateName(nameLbl.text);
		}

		private var preTile:Point=new Point();

		public function updatePs(livingBase:LivingBase):void {
			if (!this.isInit || !livingBase || livingBase != Core.me)
				return;
			if (this.preTile.equals(livingBase.nowTilePt()))
				return;
			this.preTile=livingBase.nowTilePt();
			this.tileXLbl.text="X:" + SceneUtil.screenXToTileX(livingBase.x);
			this.tileYLbl.text="Y:" + SceneUtil.screenYToTileY(livingBase.y);
			MapWnd.getInstance().updatePs(SceneUtil.screenXToTileX(livingBase.x), SceneUtil.screenYToTileY(livingBase.y));
		}
		
		public function switchToType(type:int):void{
			switch(type){
				case 1:
					leftBtn.visible = false;
					rightBtn.visible = false;
					mapBtn.visible = true;
					circleMc.visible = false;
					break;
				case 2:
					leftBtn.visible = true;
					rightBtn.visible = true;
					mapBtn.visible = false;
					circleMc.visible = true;
					break;
			}
		}

		private function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "mapBtn":
				case "mapLeft":
					MapWnd.getInstance().open();
					break;
				case "mailBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.MAILL);
					break;
				case "mapRight":
					EventManager.getInstance().dispatchEvent(EventEnum.COPY_QUIT);
					break;
				case "logBtn":
					UIManager.getInstance().postWnd.open();
					break;
			}
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - 246;
		}
	}
}

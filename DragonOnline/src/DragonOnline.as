package {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.LogManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.UiTester;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.ServerFunDic;
	import com.leyou.utils.MessageUtil;
	
	import flash.display.Bitmap;
	import flash.ui.Keyboard;

	[SWF(width='1024', height='768', backgroundColor='#000000')]
	public class DragonOnline extends GameModel {


		public function DragonOnline() {
//			UIEnum.LOGIN_SERVER="16";
//			UIEnum.LOGIN_SERVER="360";
//			UIEnum.VERSIONCM="V1.0.12.2";
			UIEnum.IS_USE_CDN=UIEnum.IS_DE_FILE=UIEnum.IS_RELEASE=false;
			super();
		}

		override protected function start():void {

//			var effectSucc:SwfLoader=new SwfLoader(100023,null, true);
//			this.addChild(effectSucc);
//			return ;
 	
//			this.addChild(new Image("ui/other/close_btn_minus.png"))
//			this.addChild(new Image("ui/alchemy/btn_2.png"))
//			this.addChild(new Bitmap(LibManager.getInstance().getImg("ui/alchemy/btn_2.png")))
//			this.addChild(new Bitmap(LibManager.getInstance().getImg("ui/other/close_btn_minus.png")))
//			this.addChild(new ImgButton(LibManager.getInstance().getImg("ui/alchemy/btn_2.png")))
				
				
			if (Core.bugTest) {
				LayerManager.getInstance().windowLayer.addChild(new UiTester());
				return;
			}

			super.start();
			
			ServerFunDic.setup();
			FlyManager.getInstance().setup(this.stage);
			LogManager.getInstance().showLog("连接web服务器：" + UIEnum.DATAROOT.split("webData")[0]);
			NoticeManager.getInstance().setup(LayerManager.getInstance().serverTipLayer, MessageUtil.onMsgLinkClick);
//			ItemTip.getInstance().setup(this.stage);
			
			KeysManager.getInstance().addKeyFun(Keyboard.BACKQUOTE, switchShow); //隐藏场景上人物名称
			
		}
		
		private function switchShow():void {
//			GuideManager.getInstance().show(159);
			GuideManager.getInstance().show(152);
			//			GuideManager.getInstance().autoGuide();
		}


	}
}

package {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.LogManager;
	import com.ace.manager.LayerManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.UiTester;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.ServerFunDic;
	import com.leyou.utils.MessageUtil;

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

//			var effectSucc:SwfLoader=new SwfLoader(99939,null, true);
//			this.addChild(effectSucc);
//			return ;
			
			
			
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
		}

	}
}

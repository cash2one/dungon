package com.leyou.net.cmd {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;

	/**
	 * @author Administrator
	 *
	 */
	public class Cmd_Cpy {

		/**
		 *进入副本
下行:cpy|{"mk":E, "ctid":num}
 * @param o
	   *
			*/
		public static function sm_Cpy_E(o:Object):void {

			if (!o.hasOwnProperty("ctid"))
				return;

			if (o.ctid == ConfigEnum.Miliyary11) {
				
				TweenLite.delayedCall(3,function():void{
					SoundManager.getInstance().play(25);
				});
				
			}


		}

		/**
		 *退出副本
下行:cpy|{"mk":Q, "ctid":num}
 *
	   */
		public static function sm_Cpy_Q(o:Object):void {
			if (!o.hasOwnProperty("ctid"))
				return;

			if (o.ctid == ConfigEnum.Miliyary11) {
				UIManager.getInstance().backpackWnd.setEnableItems();

				if (UIManager.getInstance().isCreate(WindowEnum.ARENA))
					UIManager.getInstance().arenaWnd.setQuitBtnVisible(false);
			}



		}

	}
}

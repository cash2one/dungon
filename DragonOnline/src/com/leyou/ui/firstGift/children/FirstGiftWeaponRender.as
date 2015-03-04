package com.leyou.ui.firstGift.children
{
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.img.child.Image;
	
	public class FirstGiftWeaponRender extends FirstGiftRender
	{
		private var weaponImg:Image;
		
		public function FirstGiftWeaponRender(){
			super(LibManager.getInstance().getXML("config/ui/firstGift/schl1Render.xml"));
			init();
		}
		
		protected override function init():void{
			super.init();
			weaponImg = getUIbyID("weaponImg") as Image;
			var url:String = "";
			switch(Core.me.info.profession){
				case PlayerEnum.PRO_MASTER:
					url = "ui/schl/weapon_fs.png";
					break;
				case PlayerEnum.PRO_RANGER:
					url = "ui/schl/weapon_yx.png";
					break;
				case PlayerEnum.PRO_SOLDIER:
					url = "ui/schl/weapon_zs.png";
					break;
				case PlayerEnum.PRO_WARLOCK:
					url = "ui/schl/weapon_ss.png";
					break;
			}
			weaponImg.updateBmp(url);
		}
	}
}
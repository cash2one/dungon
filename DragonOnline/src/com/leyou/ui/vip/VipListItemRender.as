package com.leyou.ui.vip
{
	import com.ace.gameData.table.TVIPInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	
	public class VipListItemRender extends AutoSprite
	{
		private static var oc:int=0;
		
		private var bgImg:Image;
		
		private var nameLbl:Label;
		
		private var flagList:Vector.<VipListFlagRender>;
		
		public function VipListItemRender(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipAllList.xml"));
			oc++;
			init();
		}
		
		private function init():void{
			bgImg = getUIbyID("bgImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			flagList = new Vector.<VipListFlagRender>();
			var bgUrl:String
			if((oc&1) == 0){
				bgUrl = "ui/vip/vip_tequan_1.jpg";
			}else{
				bgUrl = "ui/vip/vip_tequan_2.jpg";
			}
			bgImg.updateBmp(bgUrl);
		}
		
		public function updateVipInfo(vipinfo:TVIPInfo):void{
			nameLbl.text = vipinfo.des;
			for(var n:int = 0; n < 10; n++){
				var flag:VipListFlagRender = new VipListFlagRender();
				flag.x = 125 + n * 55;
				flag.updateInfo(vipinfo.type, vipinfo.getVipValue(n+1));
				addChild(flag);
			}
		}
	}
}
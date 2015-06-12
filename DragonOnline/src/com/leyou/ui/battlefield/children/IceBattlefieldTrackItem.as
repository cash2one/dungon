package com.leyou.ui.battlefield.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	
	public class IceBattlefieldTrackItem extends AutoSprite
	{
		private var boxImg:Image;
		
		private var rankNum:RollNumWidget;
		
		private var nameLbl:Label;
		
		private var ryLbl:Label;
		
		private var killlbl:Label;
		
		private var deadLbl:Label;
		
		private var bgImg:Image;
		
		public function IceBattlefieldTrackItem(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyTrackList.xml"));
			init();
		}
		
		private function init():void{
			bgImg = getUIbyID("bgImg") as Image;
			boxImg = getUIbyID("boxImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			ryLbl = getUIbyID("ryLbl") as Label;
			killlbl = getUIbyID("killlbl") as Label;
			deadLbl = getUIbyID("deadLbl") as Label;
			rankNum = new RollNumWidget();
			rankNum.loadSource("ui/num/{num}_zdl.png");
			rankNum.alignRound();
			rankNum.x = 12;
			rankNum.y = 3;
			addChild(rankNum);
		}
		
		public function updateInfo(data:IceBattlePalyerData):void{
			rankNum.setNum(data.rank);
			nameLbl.text = data.name;
			ryLbl.text = data.credit+"";
			killlbl.text = data.kill+"";
			deadLbl.text = data.assist+"";
			var bgUrl:String = (1 == data.camp) ? "ui/war/paihangbangb.png" : "ui/war/paihangbangh.png"
			bgImg.updateBmp(bgUrl);
		}
	}
}
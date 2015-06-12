package com.leyou.ui.battlefield.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	
	public class IceBattlefieldPauseItem extends AutoSprite
	{
		private var _palyerName:String;
		
		private var nameLbl:Label;
		
		private var ryLbl:Label;
		
		private var killlbl:Label;
		
		private var deadLbl:Label;
		
		private var bgImg:Image;
		
		private var rankNum:RollNumWidget;
		
		public function IceBattlefieldPauseItem(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyPauseList.xml"));
			init();
		}
		
		public function get playerName():String{
			return _palyerName;
		}

		private function init():void{
			bgImg = getUIbyID("bgImg") as Image;
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
			_palyerName = data.name;
			ryLbl.text = data.honour+"";
			killlbl.text = data.kill+"";
			deadLbl.text = data.assist+"";
			var bgUrl:String = (1 == data.camp) ? "ui/war/paihangbangb2.png" : "ui/war/paihangbangh2.png"
			bgImg.updateBmp(bgUrl);
		}
	}
}
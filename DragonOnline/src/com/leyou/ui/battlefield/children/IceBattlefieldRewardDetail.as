package com.leyou.ui.battlefield.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	import com.leyou.utils.PropUtils;
	
	public class IceBattlefieldRewardDetail extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var nameLbl:Label;
		
		private var creditLbl:Label;
		
		private var killLbl:Label;
		
		private var assistLbl:Label;
		
		public function IceBattlefieldRewardDetail(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyAwardRender2.xml"));
			init();
		}
		
		private function init():void{
			rankLbl = getUIbyID("rankLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			creditLbl = getUIbyID("creditLbl") as Label;
			killLbl = getUIbyID("killLbl") as Label;
			assistLbl = getUIbyID("assistLbl") as Label;
		}
		
		public function updateInfo(data:IceBattlePalyerData):void{
			rankLbl.text = StringUtil.substitute(PropUtils.getStringById(1640), data.rank);
			nameLbl.text = data.name;
			creditLbl.text = "+"+data.credit;
			killLbl.text = data.kill+"";
			assistLbl.text = data.assist+"";
		}
	}
}
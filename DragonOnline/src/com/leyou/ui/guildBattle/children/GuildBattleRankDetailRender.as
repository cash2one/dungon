package com.leyou.ui.guildBattle.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.guildBattle.children.GuildBattleTrackItemData;
	
	public class GuildBattleRankDetailRender extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var nameLbl:Label;
		
		private var ryLbl:Label;
		
		private var killLbl:Label;
		
		private var beKillLbl:Label;
		
		public function GuildBattleRankDetailRender(){
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildAwardRender3.xml"));
			init();
		}
		
		private function init():void{
			rankLbl = getUIbyID("rankLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			ryLbl = getUIbyID("ryLbl") as Label;
			killLbl = getUIbyID("killLbl") as Label;
			beKillLbl = getUIbyID("beKillLbl") as Label;
		}
		
		public function updateInfo(data:GuildBattleTrackItemData):void{
			rankLbl.text = StringUtil.substitute("第{1}名", data.rank);
			nameLbl.text = data.name;
			ryLbl.text = "+"+data.honour;
			killLbl.text = data.kill+"";
			beKillLbl.text = data.dead+"";
		}
	}
}
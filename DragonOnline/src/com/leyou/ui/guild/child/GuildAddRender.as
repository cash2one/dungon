package com.leyou.ui.guild.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PlayerUtil;

	public class GuildAddRender extends AutoSprite {

		private var lightBg:Image;
		private var NumLbl:Label;
		private var proLbl:Label;
		private var lvLbl:Label;
		private var attLbl:Label;
		private var playNameLbl:Label;

		private var state:int=-1;
		
		public function GuildAddRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildAddRender.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.lightBg=this.getUIbyID("lightBg") as Image;
			this.NumLbl=this.getUIbyID("NumLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.attLbl=this.getUIbyID("attLbl") as Label;
			this.playNameLbl=this.getUIbyID("playNameLbl") as Label;

//			this.lightBg.visible=false;
		}

		/**
		 *下行:un|{"mk":"H", "pl":[[name,pro,lv,att]...]}
		name --玩家名
			uname -- 行会名称
			pro --职业
			lv --等级
			att --战斗力
		 * @param o
		 *
		 */
		public function updateInfo(o:Array):void {

			this.NumLbl.text="" + (o[1] == "" ? "无" : o[1]);
			this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(o[2]);
			this.lvLbl.text="" + o[3];
			this.attLbl.text="" + o[4];
			this.playNameLbl.text="" + o[0];

		}

		public function get playName():String {
			return this.playNameLbl.text;
		}

		public function setHight(i:int=-1):void {
			if (this.state == -1)
				this.state=i;
			
			if (i == -1) {
//				this.lightBg.updateBmp("ui/guild/member_bg_" + this.state + ".png");
				this.lightBg.updateBmp("ui/team/team_list_bg_1.png");
			} else
				this.lightBg.updateBmp("ui/team/team_list_bg_"+i+".png");
//				this.lightBg.updateBmp("ui/guild/member_bg_" + i + ".png");
		}

		override public function get height():Number {
			return 27;
		}

	}
}

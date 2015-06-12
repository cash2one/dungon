package com.leyou.ui.arena.childs {

	import com.ace.ICommon.IMenu;
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.TextEvent;

	public class ArenaListRender extends AutoSprite implements IMenu {

		private var ctxLbl:Label;
		private var playerName:String;

		public function ArenaListRender() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaListRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.ctxLbl=this.getUIbyID("ctxLbl") as Label;

			this.ctxLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.ctxLbl.addEventListener(TextEvent.LINK, onLink);
			this.ctxLbl.mouseEnabled=true;
		}

		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, playerName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(playerName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(playerName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(playerName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(playerName);
					break;
			}
		}

		private function onLink(e:TextEvent):void {
//			trace(e.text)
			if (e.text.indexOf("time") > -1)
				Cmd_Arena.cm_ArenaRevenge(e.text.split("--")[1]);
			else if (e.text.indexOf("play") > -1) {

				playerName=e.text.split("--")[1];

				var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
				MenuManager.getInstance().show(menuArr, this);
			}
		}

		public function setContentTxt(a:Array):void {

			var str:String="";
			if (a[1] == 1)
				str="<font color='#00ff00'>[" + PropUtils.getStringById(1595) + "]</font>";
			else
				str="<font color='#ff0000'>[" + PropUtils.getStringById(1596) + "]</font>";

//			var d:Date=new Date();
//			d.month+=1;
//			var d2:Date=TimeUtil.getStringToDate(a[0]);

//			str+=" " + TimeUtil.getIntToDateTime((d.time - d2.time) / 1000) + "前,";
			str+=" " + a[0] + ",";
//			str+=" " + DateUtil.formatDate(d2,"YYYY-MM-DD HH24：MI：SS") + "前,";

			if (a[1] == 1)
				str+=" " + PropUtils.getStringById(1597);
			else
				str+=" " + PropUtils.getStringById(1598);

			str+="<font color='#ffd700'><u><a href='event:play--" + a[3] + "'>" + a[3] + "</a></u></font>,";

			if (a[1] == 1)
				str+=" " + StringUtil.substitute(PropUtils.getStringById(1599), ["<font color='#00ff00'>" + a[2] + "</font>"]) + ",";
			else
				str+=" " + StringUtil.substitute(PropUtils.getStringById(1600), ["<font color='#ff0000'>" + a[2] + "</font>"]) + ",";

			if (a[4] == 0)
				str+=" <font color='#ffd700'><u><a href='event:time--" + a[0] + "'>"+PropUtils.getStringById(1601)+"</a></u></font>";

			this.ctxLbl.htmlText=str + "";
		}


	}
}

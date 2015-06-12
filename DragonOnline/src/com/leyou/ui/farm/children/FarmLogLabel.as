package com.leyou.ui.farm.children {
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFarmPlantInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.TextEvent;
	import flash.text.StyleSheet;

	public class FarmLogLabel extends AutoSprite implements IMenu {
		private static const getLogTpl:String="<Font face='SimSun' size='12' color='#69e053'>" + StringUtil.substitute(PropUtils.getStringById(1701), ["</Font>{1}"]) + "<Font face='SimSun' size='12' color='#ffd700'>{2}</Font>" + "<Font face='SimSun' size='12' color='#ffd700'>{3}</Font>" + PropUtils.getStringById(1702) + "<Font face='SimSun' size='12' color='#ffd700'>{4}</Font>"
		private static const loseLogTpl:String="<Font face='SimSun' size='12' color='#ff0000'>" + PropUtils.getStringById(1703) + "】</Font>{1}" + "<Font face='SimSun' size='12' color='#ffd700'>{2}</Font>" + PropUtils.getStringById(1704) + "<Font face='SimSun' size='12' color='#ffd700'>{3}</Font>" + PropUtils.getStringById(1705) + "<Font face='SimSun' size='12' color='#ffd700'>{4}</Font>";

		private var logLbl:Label;

		public var id:String;

		private var playerName:String;

		private var menuArr:Vector.<MenuInfo>;

		public function FarmLogLabel() {
			super(LibManager.getInstance().getXML("config/ui/farm/farmlogRender.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			logLbl=getUIbyID("logLbl") as Label;
			logLbl.mouseEnabled=true;
			logLbl.addEventListener(TextEvent.LINK, onTextLink);
			var style:StyleSheet=new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			logLbl.styleSheet=style;
		}

		protected function onTextLink(event:TextEvent):void {
			playerName=event.text;
			if (null == menuArr) {
				menuArr=new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			}
			MenuManager.getInstance().show(menuArr, this);
		}

		/**
		 * <T>更新日志信息</T>
		 *
		 */
		public function updataInfo(data:Array):void {
			id=data[0];
			var useName:String=data[1];
			var date:String=data[2];
			var friendName:String=data[3];
			var copeName:String=data[4];
			var pinfo:TFarmPlantInfo=TableManager.getInstance().getPlantByName(copeName);
			var copeCount:String=data[5] + getEarnName(pinfo.plantId);
			var operate:int=data[6];
			switch (operate) {
				case 1: // 偷取
					logLbl.htmlText=StringUtil_II.translate(getLogTpl, date, StringUtil_II.addEventString(friendName, friendName, true), copeName, copeCount);
					break;
				case 2: // 被偷
					logLbl.htmlText=StringUtil_II.translate(loseLogTpl, date, StringUtil_II.addEventString(friendName, friendName, true), copeName, copeCount);
					break;
			}
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

		public function getEarnName(plantId:int):String {
			switch (plantId) {
				case 0:
					return PropUtils.getStringById(32);
				case 1:
					return PropUtils.getStringById(33);
				case 2:
					return PropUtils.getStringById(40);
				case 3:
					return PropUtils.getStringById(29);
				case 4:
					return PropUtils.getStringById(20);
			}
			return "";
		}
	}
}

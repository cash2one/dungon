package com.leyou.ui.rank.child
{
	import com.ace.ICommon.IMenu;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.greensock.TweenLite;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	
	import flash.events.MouseEvent;
	
	public class RankRender extends AutoSprite implements IMenu
	{
		private var bgImg:Image;
		
		private var rankImg:Image;
		
		private var nameLbl:Label;
		
		private var rankLbl:Label;
		
		private var typeLbl:Label;
		
		private var numLbl:Label;
		
		private var _locked:Boolean;
		
		public var avaStr:String;
		
		public var gender:int;
		
		public var vocation:int;
		
		public var type:int;
		
		private var menuArr:Vector.<MenuInfo>;
		
		public var free:Boolean;
		
		private var _isSelf:Boolean;
		
		public function RankRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankListBar.xml"));
			init();
		}
		
		public function get isSelf():Boolean{
			return _isSelf;
		}

		public function get locked():Boolean{
			return _locked;
		}

		public function set locked(value:Boolean):void{
			_locked = value;
		}
		
		private function init():void{
			mouseEnabled = true;
			bgImg = getUIbyID("bgImg") as Image;
			rankImg = getUIbyID("rankImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			rankLbl = getUIbyID("rankLbl") as Label;
			typeLbl = getUIbyID("typeLbl") as Label;
			numLbl = getUIbyID("numLbl") as Label;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			bgImg.alpha = 0;
			
			menuArr = new Vector.<MenuInfo>();
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL));
		}
		
		public function onMouseOut(event:MouseEvent):void{
			if(!free && !locked){
				TweenLite.to(bgImg, 0.5, {alpha:0});
			}
		}
		
		public function onMouseOver(event:MouseEvent):void{
			if(!free && !locked){
				TweenLite.to(bgImg, 0.5, {alpha:1});
			}
		}
		
		public function getName():String{
			return nameLbl.text;
		}
		
		public function showFunMenu():void{
			if(!free && locked){
				MenuManager.getInstance().show(menuArr, this);
			}
		}
		
		public function updateInfo(data:Array, self:Boolean=false):void{
			_isSelf = self;
			free = false;
			var rankNum:int = data[0];
			nameLbl.text = data[1];
			vocation = data[2];
			gender = data[3];
			avaStr = data[4];
			var var1:int = data[5];
			numLbl.text = data[6];
//			var onLine:Boolean = data[7];
//			filters = onLine ? null : [FilterEnum.enable];
			typeLbl.text = getVocationLabel(vocation, var1);
			if((rankNum > 0) && (rankNum < 4)){
				rankLbl.visible = false;
				rankImg.visible = true;
				rankImg.updateBmp("ui/rank/"+rankNum+".png");
			}else if(rankNum >= 4){
				rankLbl.visible = true;
				rankImg.visible = false;
				rankLbl.text = rankNum+"";
			}else{
				rankLbl.visible = true;
				rankImg.visible = false;
				rankLbl.text = "未上榜";
			}
		}
		// (1总战斗力 2坐骑 3翅膀 4装备 5军衔 6等级 7财富)
		private function getVocationLabel(vocation:int, var1:int):String{
			if((1 == type) || (4 == type) || (6 == type) || (7 == type)){
				switch(vocation){
					case 1:
						return "战士";
					case 2:
						return "法师";
					case 3:
						return "术士";
					case 4:
						return "游侠";
				}
			}else if(2 == type || 3 == type){
				switch(var1){
					case 1:
						return "一阶";
					case 2:
						return "二阶";
					case 3:
						return "三阶";
					case 4:
						return "四阶";
					case 5:
						return "五阶";
					case 6:
						return "六阶";
					case 7:
						return "七阶";
					case 8:
						return "八阶";
					case 9:
						return "九阶";
					case 10:
						return "十阶";
				}
			}else if(5 == type){
				switch(var1){
					case 1:
						return "民兵";
					case 2:
						return "列兵";
					case 3:
						return "中尉";
					case 4:
						return "上尉";
					case 5:
						return "中校";
					case 6:
						return "上校";
					case 7:
						return "中将";
					case 8:
						return "上将";
					case 9:
						return "元帅";
					case 10:
						return "大元帅";
				}
			}
			return "";
		}
		
		/**
		 * <T>处理菜单的操作</T>
		 *
		 * @param idx 菜单索引
		 *
		 */
		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, nameLbl.text);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(nameLbl.text);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(nameLbl.text);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(nameLbl.text);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(nameLbl.text);
					break;
				case ChatEnum.DUEL:
					Cmd_Duel.cm_DUEL_T(nameLbl.text);
					break;
			}
		}
		
		public function clear():void{
			free = true;
			rankImg.visible = false;
			nameLbl.text = "";
			rankLbl.text = "";
			typeLbl.text = "";
			numLbl.text = "";
		}
	}
}
package com.leyou.ui.arena {

	import com.ace.ICommon.IMenu;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.CursorManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.arena.childs.ArenaRender;
	import com.leyou.ui.question.childs.QuestionQBtn;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ArenaUtil;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	public class ArenaWnd extends AutoWindow implements IMenu {

		private var proLbl:Label;
		private var integralLbl:Label;
		private var topLbl:Label;
		private var lastPkCountLbl:Label;
		private var freeTimeLbl:Label;
		private var refreshTimeLbl:Label;
		private var addFreeCountLbl:Label;
		private var freeTimeTxt:Label;
		private var refreshLbl:Label;

		private var rewardBtn:ImgButton;
		private var logBtn:ImgButton;
		private var refreshBtn:ImgButton;
		private var topBtn:ImgButton;
		private var addPkCountBtn:ImgButton;

		private var logTxt:TextArea;

		private var playVec:Vector.<ArenaRender>;

		private var wnd:SimpleWindow;

		private var freeTime:int;
		private var refreshTime:int;

		private var playerName:String;

		private var addPKCountCost:int=0;
		public var lastPkCount:int=0;

		private var quitBtn:QuestionQBtn;

		public function ArenaWnd() {
			super(LibManager.getInstance().getXML("config/ui/arenaWnd.xml"));
			this.init();
		}

		private function init():void {

			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.topLbl=this.getUIbyID("topLbl") as Label;
			this.lastPkCountLbl=this.getUIbyID("lastPkCountLbl") as Label;
			this.freeTimeLbl=this.getUIbyID("freeTimeLbl") as Label;
			this.refreshTimeLbl=this.getUIbyID("refreshTimeLbl") as Label;
			this.addFreeCountLbl=this.getUIbyID("addFreeCountLbl") as Label;
			this.freeTimeTxt=this.getUIbyID("freeTimeTxt") as Label;
			this.refreshLbl=this.getUIbyID("refreshLbl") as Label;

			this.addPkCountBtn=this.getUIbyID("addPkCountBtn") as ImgButton;
			this.rewardBtn=this.getUIbyID("rewardBtn") as ImgButton;
			this.logBtn=this.getUIbyID("logBtn") as ImgButton;
			this.refreshBtn=this.getUIbyID("refreshBtn") as ImgButton;
			this.topBtn=this.getUIbyID("topBtn") as ImgButton;

			this.logTxt=this.getUIbyID("logTxt") as TextArea;
			this.logTxt.visibleOfBg=false;
			this.logTxt.addEventListener(TextEvent.LINK, onLink);
			this.logTxt.mouseEnabled=true;

			this.logTxt.tf.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.logBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.refreshBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.refreshBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
//			this.refreshBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);
			this.topBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addPkCountBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addPkCountBtn.addEventListener(MouseEvent.MOUSE_OVER, onPKClick);
			this.addPkCountBtn.addEventListener(MouseEvent.MOUSE_OUT, onPKClick);

			this.addFreeCountLbl.addEventListener(TextEvent.LINK, onTextLink);
			this.addFreeCountLbl.addEventListener(MouseEvent.MOUSE_OVER, onFreeClick);
			this.addFreeCountLbl.addEventListener(MouseEvent.MOUSE_OUT, onFreeClick);

			this.addFreeCountLbl.htmlText="<font color='#00ff00'><u><a href='event:free'>增加免战</a></u></font>";
			this.addFreeCountLbl.mouseEnabled=true;

			this.addFreeCountLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.playVec=new Vector.<ArenaRender>();

			var render:ArenaRender;

			render=new ArenaRender();
			this.playVec.push(render);
			this.addChild(render);

			render.x=18;
			render.y=315;

			render=new ArenaRender();
			this.playVec.push(render);
			this.addChild(render);

			render.x=160;
			render.y=350;

			render=new ArenaRender();
			this.playVec.push(render);
			this.addChild(render);

			render.x=306;
			render.y=314;

			render=new ArenaRender();
			this.playVec.push(render);
			this.addChild(render);

			render.x=457;
			render.y=363;

			render=new ArenaRender();
			this.playVec.push(render);
			this.addChild(render);

			render.x=593;
			render.y=319;

			for (var i:int=0; i < this.playVec.length; i++) {
//				this.playVec[i].addEventListener(MouseEvent.CLICK, onPlayClick);
				this.playVec[i].addEventListener(MouseEvent.MOUSE_OVER, onPlayOver);
				this.playVec[i].addEventListener(MouseEvent.MOUSE_OUT, onPlayOut);
			}

			this.refreshBtn.setToolTip(TableManager.getInstance().getSystemNotice(4712).content);
			this.addFreeCountLbl.setToolTip(TableManager.getInstance().getSystemNotice(4715).content);

//			this.quitBtn=new QuestionQBtn();
//
//			this.quitBtn.addEventListener(MouseEvent.CLICK, onQuitClick);
//			this.quitBtn.x=UIEnum.WIDTH - this.quitBtn.width;
//			this.quitBtn.y=0;
//
//			this.quitBtn.visible=false;
//
//			LayerManager.getInstance().windowLayer.addChild(this.quitBtn);

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onQuitClick);
		}

		private function onQuitClick(e:MouseEvent):void {
			if (SceneEnum.SCENE_TYPE_JSC == MapInfoManager.getInstance().type) {
				PopupManager.showConfirm("确定离开竞技场?", function():void {
					Cmd_Arena.cm_ArenaQuit();
				}, null, false, "quitarena");
			}
		}

		private function onPKClick(e:MouseEvent):void {

			if (e.type == MouseEvent.MOUSE_OVER) {
				this.addPkCountBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(4710).content, [this.addPKCountCost]));
			} else if (e.type == MouseEvent.MOUSE_OUT) {

			}
 
		}

		public function get reAwardBtn():ImgButton {
			return this.rewardBtn;
		}

		/**
		 * @param v
		 */
		public function setQuitBtnVisible(v:Boolean):void {
//			this.quitBtn.visible=v;
			if (!v) {
				PopupManager.closeConfirm("quitarena");
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

		private function onBtnOver(e:MouseEvent):void {

			if (this.refreshTime > 0) {
				this.refreshBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(4716).content, [ConfigEnum.Miliyary4]));
			} else {
				this.refreshBtn.setToolTip(TableManager.getInstance().getSystemNotice(4712).content);
			}

		}

		private function onBtnOut(e:MouseEvent):void {


		}

		private function onLink(e:TextEvent):void {
			playerName=e.text;

			var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			MenuManager.getInstance().show(menuArr, this);

		}

		private function onBtnClick(e:MouseEvent):void {
			var ctx:String;

			switch (e.target.name) {
				case "rewardBtn":
					UIManager.getInstance().openWindow(WindowEnum.ARENAAWARD);
					break;
				case "logBtn":
					UIManager.getInstance().openWindow(WindowEnum.ARENALIST);
					break;
				case "refreshBtn":
					GuideManager.getInstance().removeGuide(66);
					if (this.refreshTime > 0) {
						ctx=StringUtil.substitute(TableManager.getInstance().getSystemNotice(4713).content, [ConfigEnum.Miliyary4]);
						wnd=PopupManager.showConfirm(ctx, function():void {
							Cmd_Arena.cm_ArenaRefresh();
						}, null, false, "arenaRefresh");
					} else {
						Cmd_Arena.cm_ArenaRefresh();
					}
					break;
				case "topBtn":
					UIManager.getInstance().openWindow(WindowEnum.RANK);
					UIManager.getInstance().rankWnd.selectPageByType(5);
					break;
				case "addPkCountBtn":

					ctx=StringUtil.substitute(TableManager.getInstance().getSystemNotice(4711).content, [this.addPKCountCost, 1]);
					wnd=PopupManager.showConfirm(ctx, function():void {
						Cmd_Arena.cm_ArenaBuyPkCount()
					}, null, false, "arenaPkCount");

					break;
			}

		}

		private function onPlayOver(e:MouseEvent):void {
			if (e.target is ArenaRender)
				ArenaRender(e.target).PkBtn=true;
			else if (e.target.parent is ArenaRender)
				ArenaRender(e.target.parent).PkBtn=true;
		}

		private function onPlayOut(e:MouseEvent):void {
			if (e.target is ArenaRender)
				ArenaRender(e.target).PkBtn=false;
			else if (e.target.parent is ArenaRender)
				ArenaRender(e.target.parent).PkBtn=false;
		}

		private function onFreeClick(e:MouseEvent):void {

			if (e.type == MouseEvent.MOUSE_OVER) {
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
			} else if (e.type == MouseEvent.MOUSE_OUT) {
				CursorManager.getInstance().resetGameCursor();
			}

		}

		override public function get width():Number {
			return 778;
		}

		override public function get height():Number {
			return 482;
		}

		private function onTextLink(e:TextEvent):void {

//			if (wnd == null) {
//				wnd=PopupManager.showConfirmInput("请输入免费次数:", function(i:int):void {
//					if (i > 0)
//						Cmd_Arena.cm_ArenaBuyFreeCount(i);
//				}, function():void {
//					wnd=null;
//				});
//
//				InputWindow(wnd).input.restrict="[1-9]";
//			}

			UIManager.getInstance().openWindow(WindowEnum.ARENAMESSAGE);
		}

		/**
		 *基础信息
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			UIManager.getInstance().showPanelCallback(WindowEnum.ARENA);
			
			this.proLbl.text="" + ArenaUtil.ArenaPro[int(o.jxlevel) - 1];
			this.integralLbl.text="" + o.score;
			this.topLbl.text="" + o.jrank;
			this.lastPkCountLbl.text="" + o.sfight;
			this.freeTimeLbl.text="" + DateUtil.formatTime(o.avoidt * 1000, 2);
			this.addPKCountCost=o.buyf;
			this.lastPkCount=o.sfight;

			if (!UIManager.getInstance().isCreate(WindowEnum.ARENAAWARD))
				UIManager.getInstance().creatWindow(WindowEnum.ARENAAWARD);

			UIManager.getInstance().arenaAwardWnd.updateInfo(int(o.jxlevel) - 1, o.jlst);

			if (this.freeTime == 0)
				this.freeTime=o.avoidt;

			this.addFreeCountLbl.visible=(this.freeTime <= 0)
			this.freeTimeTxt.visible=!this.addFreeCountLbl.visible;

			TimerManager.getInstance().add(exeFreeTime);
		}

		private function exeFreeTime(i:int):void {

			if (this.freeTime - i > 0) {

//				this.freeTimeLbl.text="" + TimeUtil.getIntToDateTime(this.freeTime);
				this.freeTimeLbl.text="" + DateUtil.formatTime((this.freeTime - i) * 1000, 2);
			} else {
				this.freeTime=0;
				TimerManager.getInstance().remove(exeFreeTime);
//				this.freeTimeLbl.text="" + TimeUtil.getIntToDateTime(this.freeTime);
				this.freeTimeLbl.text="";
				this.freeTimeTxt.visible=false;

			}

			this.addFreeCountLbl.visible=((this.freeTime - i) <= 0)
		}

		/**
		 *玩家列表
		 */
		public function updatePkList(o:Object):void {

			if (this.refreshTime == 0)
				this.refreshTime=o.retz;

//			this.refreshTimeLbl.text="" + DateUtil.formatTime(this.refreshTime * 1000, 2);

			if (o.hasOwnProperty("tzlist")) {

				for (var i:int=0; i < o.tzlist.length; i++) {
					if (i >= this.playVec.length)
						continue;

					this.playVec[i].index=i + 1;
					this.playVec[i].updateInfo(o.tzlist[i]);
					this.playVec[i].setPkState(true);
				}

			}

			if (this.refreshTime > 0) {
				this.refreshLbl.visible=true;
				this.refreshBtn.updataBmd("ui/delivery/btn_shuaxin.png");
				TimerManager.getInstance().add(exePkTime);
			} else {
				this.refreshLbl.visible=false;
				if (this.visible)
					GuideManager.getInstance().showGuide(66, this);
				this.refreshBtn.updataBmd("ui/delivery/btn_shuaxin2.png");
			}

		}

		public function updateLog(arr:Array):void {

			this.logTxt.setHtmlText("");

			var ls:int=0;
			var str:String="";
			var a:Array=[];
			for (var i:int=0; i < arr.length; i++) {

				if (i >= 3)
					break;

				a=arr[i];

				str+="你";

				var d:Date=new Date();
				d.month+=1;

				var d2:Date=TimeUtil.getStringToDate(a[0]);

//				str+=TimeUtil.getIntToDateTime((d.time - d2.time) / 1000) + "前,";

				ls=(d.time - d2.time);

				if (ls / 1000 / 60 < 3)
					str+="刚刚";
				else
					str+="在" + DateUtil.formatTime(ls, 3) + "前";

				if (a[1] == 1)
					str+="打败了";
				else
					str+="败给了";

				str+="<font color='#ffd700'><u><a href='event:" + a[3] + "'>" + a[3] + "</a></u></font>\n";
			}


			this.logTxt.setHtmlText(str);
		}

		private function exePkTime(i:int):void {

			if (this.refreshTime - i > 0) {
				this.refreshTimeLbl.text="" + DateUtil.formatTime((this.refreshTime - i) * 1000, 2);
			} else {
				this.refreshTime=0;
				TimerManager.getInstance().remove(exePkTime);
				this.refreshTimeLbl.text="0时0分0秒";

				if (this.visible)
					GuideManager.getInstance().showGuide(66, this);

				this.refreshLbl.visible=false;
				this.refreshBtn.updataBmd("ui/delivery/btn_shuaxin2.png");
				SoundManager.getInstance().play(25);
			}

		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			Cmd_Arena.cm_ArenaInit();
//			Cmd_Arena.cm_ArenaRecord(3);
//			Cmd_Arena.cm_ArenaList();

			GuideManager.getInstance().showGuide(33, this);

			GuideManager.getInstance().removeGuide(31);
			GuideManager.getInstance().removeGuide(32);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_ArenaPkNum);
		}
		
		override public function sendOpenPanelProtocol(...parameters):void{
			this.dataModel=parameters;
			
			Cmd_Arena.cm_ArenaInit();
			Cmd_Arena.cm_ArenaRecord(3);
			Cmd_Arena.cm_ArenaList();
		}

		override public function hide():void {
			super.hide();

			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}

			GuideManager.getInstance().removeGuide(33);
			GuideManager.getInstance().removeGuide(66);
			GuideManager.getInstance().removeGuide(65);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_ArenaPkNum);
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		public function reBtnsise():void {
//			this.quitBtn.x=UIEnum.WIDTH - this.quitBtn.width;
//			this.quitBtn.y=0;
		}

	}
}

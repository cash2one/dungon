package com.leyou.ui.chat.child {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.chat.ChatInputText;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.chat_II.ChatChannelInfo;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.data.chat_II.ChatInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Chat;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_GM;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.ChatUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.System;

	public class ChatController extends AutoSprite implements IMenu {

		private static const PRIVATEBAR_HEIGHT:int=20;

		private var channelCd:ComboBox;

		private var chatInput:TextInput;

		private var channelBar:TabBar;

		private var sendBtn:ImgButton;

		private var faceBtn:ImgButton;

		private var configBtn:ImgButton;

		private var scaleBtn:ImgButton;

		private var hideBtn:ImgButton;

		private var privateBar:PrivateBar;

		// 显示器
		private var view:ChatMessageView;

		// 消息仓库
		private var messageStore:ChatInfo;

		// 聊天面板隐藏监听
		public var hideListener:Function;

		// 聊天频道索引
		private var _chatIndex:int;

		// 显示频道
		private var _viewChannel:int=ChatEnum.CHANNEL_COMPOSITE;

		// 当前指向的记录索引
		private var myRecordIdx:int=-1;

		// 个人聊天记录
		private var myRecord:Vector.<String>;

		// 各频道发送间隔时间戳
		private var tickRecords:Object;

		// 超连接数据
		private var linkData:Vector.<Object>;

		// 玩机名点击显示菜单
		private var menuArr:Vector.<MenuInfo>;

		private var tips:TipsInfo;

		private var currPlayer:String;

		private var input:ChatInputText;

		public function ChatController() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatController.xml"));
			this.cacheAsBitmap=true;
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseChildren=true;
			messageStore=new ChatInfo();

			channelCd=getUIbyID("channelCd") as ComboBox;
			chatInput=getUIbyID("chatInput") as TextInput;
			channelBar=getUIbyID("chatTabBar") as TabBar;
			sendBtn=getUIbyID("sendBtn") as ImgButton;
			faceBtn=getUIbyID("faceBtn") as ImgButton;
			configBtn=getUIbyID("configBtn") as ImgButton;
			scaleBtn=getUIbyID("scaleBtn") as ImgButton;
			hideBtn=getUIbyID("hideBtn") as ImgButton;

//			channelBar.addEventListener(MouseEvent.CLICK, onViewClick);
			sendBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			faceBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			configBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			scaleBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			hideBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			channelBar.addEventListener(TabbarModel.changeTurnOnIndex, onViewClick);
			channelCd.addEventListener(DropMenuEvent.Item_Selected, onChatClick);
			myRecord=new Vector.<String>();
			linkData=new Vector.<Object>();
			privateBar=new PrivateBar();
			tickRecords=new Object();
			tips=new TipsInfo(null);
			addChild(privateBar);
			privateBar.x=7;

			menuArr=new Vector.<MenuInfo>();
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[3], ChatEnum.ADD_FRIEND));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[4], ChatEnum.ADD_BLACK));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[9], ChatEnum.TRACK));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL));
			menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE));
			menuArr.push(new MenuInfo(PropUtils.getStringById(2242), ChatEnum.PROPOSAL));

			var index:int=getChildIndex(chatInput);
			removeChild(chatInput);

//			chatInput.input.textColor=ChatEnum.COLOR_VAL_WORLD;
//			chatInput.clearEvent();
//			chatInput.closeEvent();

			input=new ChatInputText(chatInput.width, chatInput.height);
			input.defaultTextFormat=chatInput.input.defaultTextFormat;
			input.x=chatInput.x;
			input.y=chatInput.y;
			addChildAt(input, index);
			input.input.textColor=ChatEnum.COLOR_VAL_WORLD;
		}

		/**
		 * <T>聊天频道选择</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onChatClick(event:Event):void {
			var index:int=int(event.target.list.selectIndex);
			switchToChannel(index);
		}

		/**
		 * <T>显示频道选择</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onViewClick(event:Event):void {
			switchToChannel(channelBar.turnOnIndex - 1);
			channelCd.list.selectByInd(_chatIndex);
			_viewChannel=(0 == channelBar.turnOnIndex) ? ChatEnum.CHANNEL_COMPOSITE : channelCd.value.uid;
			var channel:ChatChannelInfo=messageStore.getChannel(_viewChannel);
			view.switchToChannel(channel, onLinkClick);
			if (ChatEnum.CHANNEL_PRIVATE == _viewChannel) {
				stopFlashing();
			}
		}

		/**
		 * <T>切换聊天频道</T>
		 *
		 * @param channelIdx 频道索引
		 *
		 */
		protected function switchToChannel(channelIdx:int):void {
			if ((_chatIndex == channelIdx) || (channelIdx < 0)) {
				return;
			}
			// 原来是私聊频道时需重新调整界面
			if (1 == _chatIndex) {
				setPrivateStatus(false);
			}
			// 还原文本框焦点
			setFocus();
			// 切换频道
			_chatIndex=channelIdx;
			switch (_chatIndex) {
				case 0:
					input.input.textColor=ChatEnum.COLOR_VAL_WORLD;
					break;
				case 1:
					setPrivateStatus(true);
					break;
				case 2:
					input.input.textColor=ChatEnum.COLOR_VAL_TEAM;
					break;
				case 3:
					input.input.textColor=ChatEnum.COLOR_VAL_GUILD;
					break;
				case 4:
					input.input.textColor=ChatEnum.COLOR_VAL_HORN;
					break;
			}
		}

		/**
		 * <T>设置焦点</T>
		 *
		 */
		public function setFocus():void {
			stage.focus=input.input;
		}

		/**
		 * <T>是否是焦点</T>
		 *
		 */
		public function isFocus():Boolean {
			return (stage.focus == input.input);
		}

		/**
		 * <T>私聊状态切入切出</T>
		 *
		 * @param v true :切入
		 *          false:切出
		 *
		 */
		public function setPrivateStatus(v:Boolean):void {
			// 界面调整
			if (v) {
				view.y-=PRIVATEBAR_HEIGHT;
				hideBtn.y-=PRIVATEBAR_HEIGHT;
				scaleBtn.y-=PRIVATEBAR_HEIGHT;
				configBtn.y-=PRIVATEBAR_HEIGHT;
				channelBar.y-=PRIVATEBAR_HEIGHT;
				privateBar.visible=true;
				privateBar.setFocus();
				// 字体颜色调整
				input.input.textColor=ChatEnum.COLOR_VAL_PRIVATE
			} else {
				view.y+=PRIVATEBAR_HEIGHT;
				hideBtn.y+=PRIVATEBAR_HEIGHT;
				scaleBtn.y+=PRIVATEBAR_HEIGHT;
				configBtn.y+=PRIVATEBAR_HEIGHT;
				channelBar.y+=PRIVATEBAR_HEIGHT;
				privateBar.visible=false;
			}
		}

		// 临时测试变量
		private var n:int;

		/**
		 * <T>按钮点击监听</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onButtonClick(event:MouseEvent):void {
//			var content:ChatContentInfo = new ChatContentInfo();
//			content.content = StringUtil.translate("<Font color='#FCE504' size='15'>我是小喇叭{1}号,我是弹出来测试的</Font>", ++n);
			switch (event.target.name) {
				case "sendBtn":
					sendMsg();
//					view.pushInHorn(content);
					break;
				case "faceBtn":
					UIManager.getInstance().faceWnd.open();
//					view.pushInSystem(content, onLinkClick);
					break;
				case "configBtn":
					UIManager.getInstance().chatConfigWnd.open();
//					view.pushInCommon(content, onLinkClick);
					break;
				case "scaleBtn":
					view.changeSizeStatus();
					break;
				case "hideBtn":
					setVisible(false);
					break;
			}
		}

		/**
		 * <T>设置是否显示</T>
		 *
		 * @param v 是否显示
		 *
		 */
		public function setVisible(v:Boolean):void {
			visible=v;
			view.visible=v;
			if (!v && (null != hideListener)) {
				hideListener.call(this);
			}
		}

		/**
		 * <T>设置显示器</T>
		 *
		 * @param $view 显示器
		 *
		 */
		public function setView($view:ChatMessageView):void {
			view=$view;
		}

		/**
		 * <T>发送聊天消息</T>
		 *
		 */
		public function sendMsg():void {
			var cmd:String=input.input.text;
			// 临时指引显示指令
//			if(-1 < cmd.indexOf("@gd|")){
//				var index:int = cmd.indexOf("|");
//				cmd = cmd.substr(index+1);
//				var arr:Array = cmd.split(",");
//				var gid:int = arr[0];
//				var gd:int = arr[1];
//				var gx:int = arr[2];
//				var gy:int = arr[3];
//				GuideManager.getInstance().showGuideT(gid, gd, gx, gy);
//				return;
//			}
//			if(-1 < cmd.indexOf("@notice|")){
//				var index:int = cmd.indexOf("|");
//				cmd = cmd.substr(index+1);
//				var arr:Array = cmd.split(",");
//				var noticeId:int = arr.shift();
//				NoticeManager.getInstance().broadcastById(noticeId, arr);
//				return;
//			}
			UIManager.getInstance().faceWnd.hide();
			// 若均为不可见字符返回
			var content:String=input.input.text;
			content=StringUtil_II.trim(content);

			var context1:String=content;

			content=StringUtil_II.getFilterWord(content);
			if (0 == content.length) {
				reset();
				return;
			}

			// GM命令处理
			if (0 == content.indexOf("@")) {
				Cmd_GM.sendGMCmd(content.substring(1));
				reset();
				return;
			}

			// 处理频道CD时间
			var channel:int=int(channelCd.value.uid);
			if (ChatEnum.CHANNEL_WORLD == channel) {
				var o:Object;
				var chatContent:ChatContentInfo;
				if (Core.me.info.level < Core.SPEECK_LEVEL) {
					o={i: "", c: StringUtil.substitute(PropUtils.getStringById(1655), [Core.SPEECK_LEVEL])};
					chatContent=ChatUtil.decode(o);
					pushContent(chatContent);
					return;
				}
				var tick:Number=tickRecords[channel];
				var currTick:Number=new Date().time;
				var dt:Number=currTick - tick;
				if (dt < 5000) {
					var remain:int=Math.ceil((5000 - dt) / 1000);
					o={i: "", c: StringUtil.substitute(PropUtils.getStringById(1656), [remain])};
					chatContent=ChatUtil.decode(o);
					pushContent(chatContent);
					reset();
					return;
				}
			}

			// 个人聊天记录添加
			while (myRecord.length >= ChatEnum.MYRECORD_REMAIN) {
				myRecord.pop();
			}
			myRecord.unshift(context1);

			// 处理频道聊天
			if (processChannel(channel, content)) {
				trace("-------------------send sucess")
				tickRecords[channel]=currTick;
			}
		}

		/**
		 * <T>向服务器发送聊天信息</T>
		 *
		 * @return 是否发送成功
		 *
		 */
		public function processChannel(channel:int, content:String):Boolean {
			switch (channel) {
				case ChatEnum.CHANNEL_PRIVATE:
					var n:String=privateBar.playerName();
					privateBar.pushNmae(n);
					if (!privateBar.playerNameValid()) {
						// todo: 提示玩家名无效
						trace("玩家名字无效")
						return false;
					}
					break;
				case ChatEnum.CHANNEL_HORN:
					// todo: 检查是否有相应道具
					break;
				case ChatEnum.CHANNEL_WORLD:
					// 检查当前频道等级限制
//					var focusLevel:int = MyInfoManager.getInstance().level;
//					if (focusLevel < ChatEnum.WORLD_CHANNEL_LIMIT) {
//						trace("聊天等级限制")
//						return false;
//					}
					break;
				default:
					break;
			}
			// 字符数量限制
			var charCount:int=content.length;
			if (charCount > 128) {
				return false;
			}
			// 非法信息过滤
			content=ChatUtil.filtration(content);
			// 超链接生成
			content=ChatUtil.createLinkString(content, linkData, channel, privateBar.playerName());
			// 协议发送
			Cmd_Chat.cm_say(content);
			reset();
			return true;
		}

		/**
		 * <T>输入框内是否有内容</T>
		 *
		 * @return 有木有
		 *
		 */
		public function hasContent():Boolean {
			return (0 != input.input.text.length);
		}

		/**
		 * <T>根据内容选择频道</T>
		 *
		 */
		public function checkContent():void {
			var content:String=input.input.text;
//			content=StringUtil.trim(content);
			var flag:String=content.substr(0, 2);
			switch (flag) {
				case "/S":
				case "/s":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_COMPOSITE + "");
					break;
				case "/W":
				case "/w":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_WORLD + "");
					break;
				case "/R":
				case "/r":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_PRIVATE + "");
					break;
				case "/P":
				case "/p":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_TEAM + "");
					break;
				case "/G":
				case "/g":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_GUILD + "");
					break;
				case "/Y":
				case "/y":
					content=content.replace(flag, "");
					channelCd.list.selectByUid(ChatEnum.CHANNEL_HORN + "");
					break;
			}
			input.input.text=content;
		}

		/**
		 * <T>显示下一条内容</T>
		 *
		 */
		public function nextContent():void {
			if ((myRecordIdx - 1) >= 0) {
				input.input.text=myRecord[--myRecordIdx];
			}
		}

		/**
		 * <T>显示上一条内容</T>
		 *
		 */
		public function prevContent():void {
			if ((myRecordIdx + 1) < myRecord.length) {
				input.input.text=myRecord[++myRecordIdx];
			}
		}

		/**
		 * <T>重置聊天内容</T>
		 *
		 */
		public function reset():void {
			input.input.text="";
			myRecordIdx=-1;
			linkData.length=0;
			stage.focus=null;
		}

		/**
		 * <T>加入超链接</T>
		 *
		 * @param link 连接数据
		 *
		 */
		public function pushLink(link:Object):void {
			if (0 != linkData.length) {
				// todo: 提示超链接仅能发送一个
//				var notice:TNoticeInfo=TableManager.getInstance().getSystemNotice(3410);
//				if (notice.viewPsIs(3)) {
//					UIManager.getInstance().chatWnd.onSysNotice(notice);
//				}
//				NoticeManager.getInstance().broadcast(notice);
				sendMsg();
//				return;
			}
			linkData.push(link);
			var value:String=input.input.text;
			value+=link.content;
			input.input.text=value;
			input.input.setSelection(input.input.text.length, input.input.text.length);
		}

		/**
		 * <T>文本连接点击处理</T>
		 *
		 * @param evt 连接事件
		 *
		 */
		public function onLinkClick(evt:TextEvent):void {
			var content:String=evt.text;
			var type:int=int(content.substring(0, content.indexOf("+")));
			var linkValue:String=content.substring(content.indexOf("{"), content.indexOf("}") + 1);
			var linkData:Object=null;
			switch (type) {
				case ChatEnum.LINK_TYPE_ACTIVE:
					// 格式[type|[value...]]
					linkValue=linkValue.substr(1, linkValue.length - 2);
					var valueArr:Array=linkValue.split("|");
					openUI(valueArr[0], valueArr[1].split(","));
					break;
				case ChatEnum.LINK_TYPE_ITEM:
					linkData=com.adobe.serialization.json.JSON.decode(linkValue);
					tips.clear();
					tips.unserialize(linkData);
					var info:TEquipInfo=TableManager.getInstance().getEquipInfo(tips.itemid);
					if (null != info) {
						if (10 == info.classid) {
							ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
							return;
						}
						var tipType:int=tips.hasOwner() ? TipEnum.TYPE_EQUIP_ITEM : TipEnum.TYPE_EMPTY_ITEM;
						var wear:Boolean=ItemUtil.showDiffTips(tipType, tips, new Point(stage.mouseX, stage.mouseY));
						if (!wear) {
							if (tips.hasOwner()) {
								ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
							} else {
								ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
							}
						}
					} else {
						ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					}
					break;
				case ChatEnum.LINK_TYPE_MAP:
					linkData=com.adobe.serialization.json.JSON.decode(linkValue);
					Core.me.gotoMap(new Point(linkData.x, linkData.y), linkData.id, true);
					break;
				case ChatEnum.LINK_TYPE_PLAYER:
					currPlayer=linkValue.substring(1, linkValue.length - 1);
					MenuManager.getInstance().show(menuArr, this);
					break;
				case ChatEnum.LINK_TYPE_VIP:
					break;
				case ChatEnum.LINK_TYPE_TEAM:
					if (ConfigEnum.UnionOpenLv > Core.me.info.level) {
						NoticeManager.getInstance().broadcastById(4110);
					}
					UILayoutManager.getInstance().open(WindowEnum.TEAM);
					break;
				case ChatEnum.LINK_TYPE_GUILD:
					if (Core.me.info.level >= ConfigEnum.union1) {
						UILayoutManager.getInstance().open_II(WindowEnum.GUILD);
					}
					break;
			}
		}

		private function openUI(type:String, values:Array):void {
			switch (type) {
				case "usp":
					if (Core.me.info.level >= ConfigEnum.union1) {
						UILayoutManager.getInstance().open_II(WindowEnum.GUILD);
						UIManager.getInstance().guildWnd.setTabIndex(5)
					}
					break;
				case "shp":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					break;
				case "scp":
					if ((Core.me.info.level >= ConfigEnum.StoryCopyOpenLevel) && (SceneEnum.SCENE_TYPE_PTCJ == MapInfoManager.getInstance().type)) {
						UILayoutManager.getInstance().open(WindowEnum.DUNGEON_TEAM);
					}
					break;
				case "ol":
					if (Core.me.info.level >= ConfigEnum.WelfareOpenLvel) {
						UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
						UIManager.getInstance().creatWindow(WindowEnum.WELFARE);
						UIManager.getInstance().welfareWnd.changeTable(1);
					}
					break;
				case "expc":
					if ((Core.me.info.level >= ConfigEnum.ExpCopyOpenLevel) && (SceneEnum.SCENE_TYPE_PTCJ == MapInfoManager.getInstance().type)) {
//						UIOpenBufferManager.getInstance().open(WindowEnum.EXPCOPY);
						UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					}
					break;
				case "lbox":
					UIOpenBufferManager.getInstance().open(WindowEnum.LUCKDRAW);
					break;
				case "vip":
					UILayoutManager.getInstance().open(WindowEnum.VIP);
					break;
				case "ddsc":
					if (Core.me.info.vipLv <= 0) {
						if (1 == DataManager.getInstance().commonData.payStatus) {
							UILayoutManager.getInstance().open(WindowEnum.FIRSTGIFT);
						} else if (2 == DataManager.getInstance().commonData.payStatus) {
							UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
						}
					}
					break;
				case "fcz":
					UIOpenBufferManager.getInstance().open(WindowEnum.FIRST_RETURN);
					break;
				case "cptm":// 组队副本
					if (SceneEnum.SCENE_TYPE_PTCJ == MapInfoManager.getInstance().type) {
						Cmd_CpTm.cmTeamCopyAdd(values[0]);
						UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
						TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [2]);
					}
					break;
				case "pm":
					UIOpenBufferManager.getInstance().open(WindowEnum.VENDUE);
					break;
				case "warc":
					if (SceneEnum.SCENE_TYPE_PTCJ == MapInfoManager.getInstance().type) {
						UIOpenBufferManager.getInstance().open(WindowEnum.GUILD_BATTLE, 1);
					}
					break;
				case "fanl":
					UIOpenBufferManager.getInstance().open(WindowEnum.PAY_PROMOTION);
					break;
			}
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
					Cmd_Friend.cm_FriendMsg_A(1, currPlayer);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(currPlayer);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(currPlayer);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					privateChat(currPlayer);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(currPlayer);
					break;
				case ChatEnum.ADD_BLACK: // 拉黑
					Cmd_Friend.cm_FriendMsg_A(3, currPlayer);
					break;
				case ChatEnum.SUE: // 举报
//					var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(9961);
//					NoticeManager.getInstance().broadcast(notice);
					NoticeManager.getInstance().broadcastById(9961);
					break;
				case ChatEnum.COPY: // 复制
					System.setClipboard(currPlayer);
					break;
				case ChatEnum.TRACK:
					ChatUtil.trackPlayer(currPlayer);
					break;
				case ChatEnum.DUEL:
					Cmd_Duel.cm_DUEL_T(currPlayer);
					break;
				case ChatEnum.PROPOSAL:
					UIManager.getInstance().roleWnd.startMarry(currPlayer);
					break;
			}
		}

		/**
		 * <T>进入私聊</T>
		 *
		 * @param name 私聊名称
		 *
		 */
		public function privateChat(name:String):void {
			privateBar.setPlayerName(name);
			switchToChannel(1);
			channelCd.list.selectByInd(_chatIndex);
			setFocus();
		}

		/**
		 * <T>向聊天频道加入聊天信息</T>
		 *
		 * @param content 信息数据
		 *
		 */
		public function pushContent(content:ChatContentInfo):void {
			// 检测是否存在于黑名单
			if ((ChatEnum.CHANNEL_HORN != content.type) && DataManager.getInstance().friendData.testInBlack(content.fromUserName)) {
				return;
			}
			// 是否是玩家发言
			if (content.palyerSpeak()) {
				messageStore.pushContent(content, content.type);
				if (ChatEnum.CHANNEL_COMPOSITE != content.type) {
					messageStore.pushContent(content, ChatEnum.CHANNEL_COMPOSITE);
				}
			}
			// 是否为私聊,私聊标签需要闪烁
			if ((ChatEnum.CHANNEL_PRIVATE == content.type) && (ChatEnum.CHANNEL_PRIVATE != _viewChannel) && (ChatEnum.CHANNEL_COMPOSITE != _viewChannel)) {
				privateFlashing();
			}
			switch (content.type) {
				case ChatEnum.CHANNEL_SYSTEM:
					view.pushInSystem(content, onLinkClick);
					break;
				case ChatEnum.CHANNEL_HORN:
					view.pushInHorn(content);
					if (oughtShow(content)) {
						view.pushInCommon(content, onLinkClick);
					}
					break;
				default:
					if (oughtShow(content)) {
						view.pushInCommon(content, onLinkClick);
					}
					break;
			}
		}

		private function privateFlashing():void {
			var btn:TabButton=channelBar.getTabButton(2);
			if (!TweenMax.isTweening(btn)) {
				TweenMax.to(btn, 1.5, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 10, blurY: 10, strength: 2}, yoyo: true, repeat: -1});
			}
		}

		private function stopFlashing():void {
			var btn:TabButton=channelBar.getTabButton(2);
			if (TweenMax.isTweening(btn)) {
				TweenMax.killTweensOf(btn);
			}
			btn.filters=[];
		}

		/**
		 * <T>是否应该显示</T>
		 *
		 * @param content 显示内容
		 * @return        是否显示
		 *
		 */
		public function oughtShow(content:ChatContentInfo):Boolean {
			var limit:Boolean;
			if (ChatEnum.CHANNEL_COMPOSITE == _viewChannel) {
				var config:ChatConfig=UIManager.getInstance().chatConfigWnd;
				// 是否接收该频道消息
				limit=!config.getLimit(content.type);
			}
			return (limit || (_viewChannel == content.type /* || ChatEnum.CHANNEL_PRIVATE == content.type*/) || !content.palyerSpeak());
		}

		/**
		 * <T>添加表情</T>
		 *
		 * @param value 表情的KEY
		 *
		 */
		public function addFace(key:String):void {
			var str:String=input.input.text + key;
			input.input.text=str;
			stage.focus=input.input;
			input.input.setSelection(input.input.text.length, input.input.text.length);
		}
	}
}

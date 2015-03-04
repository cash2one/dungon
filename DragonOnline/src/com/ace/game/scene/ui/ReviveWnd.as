/**
 * @VERSION:	1.0
 * 2013-10-26 下午1:54:54
 */
package com.ace.game.scene.ui {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.proxy.CmdProxy;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Attack;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class ReviveWnd extends AutoWindow implements IMenu{
		private static var instance:ReviveWnd;

		public static function getInstance():ReviveWnd {
			if (!instance)
				instance=new ReviveWnd();
			return instance;
		}

		private var timeLbl:Label;
		
		private var desLbl:Label;
		
//		private var countLbl2:Label;
		
		private var aqBtn:NormalButton;
		
		private var ybBtn:NormalButton;
		
		public var autoCKBox:CheckBox;
		
		private var numInput:TextInput;
		
		private var grid:MarketGrid;
		
		private var addBtn:ImgButton;
		
		private var delBtn:ImgButton;
		
		private var ybChek:RadioButton;
		
		private var bybChek:RadioButton;
		
		private var sumPrice:Label;
		
		private var buyBtn:NormalButton;
		
		private var tick:Number;
		
		private var reviveWaitTime:int;
		
		private var proCount:int;
		
		private var item:int;
		private var itemPrice:int;
		
		private var bItem:int;
		private var bItemPrice:int;
		
		private var killName:String;
		private var menuArr:Vector.<MenuInfo>;
		
		public function ReviveWnd() {
			super(LibManager.getInstance().getXML("config/ui/scene/reviveWnd.xml"));
			init();
//			KeysManager.getInstance().addKeyFun(Keyboard.R, open);
			LayerManager.getInstance().windowLayer.addChild(this);
		}

		private function init():void {
			clsBtn.visible = false;
			allowDrag = false;
			hideBg();
			timeLbl = getUIbyID("timeLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			aqBtn = getUIbyID("aqBtn") as NormalButton;
			ybBtn = getUIbyID("ybBtn") as NormalButton;
			autoCKBox = getUIbyID("autoCKBox") as CheckBox;
			numInput = getUIbyID("numInput") as TextInput;
			addBtn = getUIbyID("addBtn") as ImgButton;
			delBtn = getUIbyID("delBtn") as ImgButton;
			ybChek = getUIbyID("ybChek") as RadioButton;
			bybChek = getUIbyID("bybChek") as RadioButton;
			sumPrice = getUIbyID("sumPrice") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			
			var format:TextFormat = numInput.input.defaultTextFormat;
			format.align = TextFormatAlign.CENTER;
			numInput.input.defaultTextFormat = format;
			numInput.restrict = "[0-9]";
			numInput.input.maxChars = 2;
			numInput.input.addEventListener(Event.CHANGE, onInputChange);
			desLbl.mouseEnabled = true;
			var style:StyleSheet = new StyleSheet()
			style.setStyle("body", {leading:0.5});
			style.setStyle("a:hover", {color:"#ff0000"});
			desLbl.styleSheet = style;
			
			desLbl.multiline = true;
			desLbl.wordWrap = true;
			
			aqBtn.addEventListener(MouseEvent.CLICK, onCLick);
			ybBtn.addEventListener(MouseEvent.CLICK, onCLick);
			addBtn.addEventListener(MouseEvent.CLICK, onCLick);
			delBtn.addEventListener(MouseEvent.CLICK, onCLick);
			buyBtn.addEventListener(MouseEvent.CLICK, onCLick);
			autoCKBox.addEventListener(MouseEvent.CLICK, onCLick);
			grid = new MarketGrid();
			grid.x = 68;
			grid.y = 54;
			addChild(grid);
		}
		
		protected function onTextClick(event:TextEvent):void{
			if(null == menuArr){
				menuArr = new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
			}
			MenuManager.getInstance().show(menuArr, this);
		}
		
		protected function onInputChange(event:Event):void{
			var price:int = ybChek.isOn ? itemPrice : bItemPrice;
			sumPrice.text = (price * int(numInput.text)) + "";
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
					Cmd_Friend.cm_FriendMsg_A(1, killName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(killName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(killName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(killName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(killName);
					break;
			}
		}
		
		/**
		 * <T>接收死亡协议</T>
		 * 
		 * @param obj 协议内容
		 * 
		 */		
		public function serv_show(obj:Object):void {
//			if(AutoUtil.autoRevive()){
//				return;
//			}
			var isMonster:Boolean;
			var kn:String = obj.name;
			if(null != kn){
				if(int(kn.substr(0,1)) > 0){
					isMonster = false;
					desLbl.addEventListener(TextEvent.LINK, onTextClick);
				}else{
					isMonster = true;
					if(desLbl.hasEventListener(TextEvent.LINK)){
						desLbl.removeEventListener(TextEvent.LINK, onTextClick);
					}
				}
			}
			show();
			item = obj.item;
			bItem = obj.bitem;
			itemPrice = obj.ip;
			bItemPrice = obj.bip;
			killName = obj.name;
			ybChek.turnOn();
			var price:int = ybChek.isOn ? itemPrice : bItemPrice;
			numInput.text = 1+"";
			sumPrice.text = price+"";
			proCount = obj.num;
			autoCKBox.text = "下次自动使用道具原地复活(剩余"+proCount+")"
			grid.updataInfo({itemId:obj.item, count:obj.num});
			reviveWaitTime = obj.dt*1000;
			timeLbl.text = DateUtil.formatDate(new Date(obj.tick*1000), "YYYY-MM-DD HH24:MI:SS");
			var des:String = "";
			if(0 == obj.bh){
				// 没有消耗
				des += "您在"+obj.mn+"地图被"+ StringUtil_II.getColorStr(StringUtil_II.addEventString(obj.name, "["+obj.name+"]", true), ChatEnum.COLOR_USER) +"击败了";
				var pl:Array = obj.pl;
				if(pl.length > 0){
					des+="掉落物品"
					var l:int = pl.length;
					for(var n:int = 0; n < l; n++){
						var itemId:int = pl[n][0];
						var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
						var equipInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(itemId);
						var qulity:uint;
						var itemName:String;
						if (null != itemInfo) {
							qulity=uint(itemInfo.quality);
							itemName=itemInfo.name;
						}
						if (null != equipInfo) {
							qulity=uint(equipInfo.quality);
							itemName=equipInfo.name;
						}
						var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
						var reName:String=com.leyou.utils.StringUtil_II.getColorStrByFace(itemName, color, "微软雅黑", 14);
						if(pl[n][1] > 1){
							des += (reName+"×"+pl[n][1])+",";
						}else{
							des += reName+",";
						}
					}
					des+="."
				}else{
					des+=",没有掉落物品."
				}
			}else if(1 == obj.bh){
				des = TableManager.getInstance().getSystemNotice(3904).content;
				var pn:String = StringUtil_II.getColorStr(StringUtil_II.addEventString(obj.name, "["+obj.name+"]", true), ChatEnum.COLOR_USER);
				des = StringUtil.substitute(des, obj.mn, pn, obj.pk);
			}
			if(!isMonster && hasProtected()){
				des+="您获得10分钟的复活保护,主动攻击他人提前终止."
			}
			desLbl.htmlText = des;
			startCount();
		}
		
		public function hasProtected():Boolean{
			var type:int=MapInfoManager.getInstance().type;
			switch (type) {
				case SceneEnum.SCENE_TYPE_SGLX:
				case SceneEnum.SCENE_TYPE_BWBLT:
				case SceneEnum.SCENE_TYPE_GUCJ:
					return false;
				default:
					return true;
			}
			return true;
		}
		
		/**
		 * <T>开始计时</T>
		 * 
		 */		
		public function startCount():void{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tick = new Date().time;
		}
		
		/**
		 * <T>帧事件监听,计时作用</T>
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			var t:uint = new Date().time - tick;
			if(autoCKBox.isOn && (proCount > 0)){
				if(t >= 3000){
					CmdProxy.cm_revive(1);
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					hide();
					return;
				}
			}
			var interval:int = reviveWaitTime - t;
			if(interval < 0){
				interval = 0;
			}
			aqBtn.text = "安全复活("+int(interval/1000)+")";
			if(interval <= 0){
				CmdProxy.cm_revive(0);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				hide();
				return;
			}			
		}
		
//		/**
//		 * <T>点击关闭按钮,发送安全复活协议</T>
//		 * 
//		 * @param e 鼠标事件
//		 * 
//		 */		
//		override protected function onExitBtnClick(e:Event):void {
//			super.onExitBtnClick(e);
//			CmdProxy.cm_revive(0);
//		}

		/**
		 * <T>显示</T>
		 * 
		 * @param toTop    是否置顶
		 * @param $layer   所在层
		 * @param toCenter 是否置中
		 * 
		 */		
		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter); //显示在顶层
			AssistWnd.getInstance().info.isAutoRevive ? autoCKBox.turnOn() : autoCKBox.turnOff();
//			var atExp:Boolean = UIManager.getInstance().expCopyTrack && UIManager.getInstance().expCopyTrack.visible;
//			anQBtn.setActive(!atExp, 1, true);
		}
		
		override public function hide():void{
			super.hide();
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
		}
		
		public function safeRevive():void{
			CmdProxy.cm_revive(0);
			hide();
		}
		
		private function cancel():void{
			show();
		}

		/**
		 * <T>鼠标点击控件监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onCLick(evt:Event):void {
			var price:int = ybChek.isOn ? itemPrice : bItemPrice;
			switch (evt.target.name) {
				case "buyBtn":
					var it:int = ybChek.isOn ? item : bItem;
					var t:int = ybChek.isOn ? 1 : 4;
					Cmd_Attack.cm_REV_B(t, it, int(numInput.text));
					break;
				case "aqBtn":
					if(SceneEnum.SCENE_TYPE_BSFB == MapInfoManager.getInstance().type){
						super.show(true, UIEnum.WND_LAYER_NORMAL);
						var content:String = TableManager.getInstance().getSystemNotice(4406).content;
						PopupManager.showConfirm(content, safeRevive, cancel, true, "revive.safe");
//						safeRevive();
					}else{
						safeRevive();
					}
					break;
				case "ybBtn":
					if(0 < proCount){
						CmdProxy.cm_revive(1);
						hide();
					}else{
//						var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(3902);
//						NoticeManager.getInstance().broadcast(notice);
						NoticeManager.getInstance().broadcastById(3902);
					}
					break;
				case "autoCKBox":
					var reviveCbox:CheckBox = AssistWnd.getInstance().reliveCheckBox;
					autoCKBox.isOn ? reviveCbox.turnOn() : reviveCbox.turnOff();
					AssistWnd.getInstance().info.isAutoRevive = autoCKBox.isOn;
					AssistWnd.getInstance().saveConfig();
					break;
				case "addBtn":
					var sumCount:int = int(numInput.text);
					if(sumCount < 99){
						sumCount++;
						numInput.text = sumCount + "";
						sumPrice.text = (price * sumCount) + "";
					}
					break;
				case "delBtn":
					var sc:int = int(numInput.text);
					if(sc > 1){
						sc--;
						numInput.text = sc + "";
						sumPrice.text = (price * sc) + "";
					} 
					break;
				case "buyBtn":
					var id:int = ybChek.isOn ? 1 : 2;
					var type:int = ybChek.isOn ? 1 : 4;
					Cmd_Market.cm_Mak_B(type, id, int(numInput.text));
					break;
			}
		}
		
		public function ser_REV_B(obj:Object):void{
			if(autoCKBox.isOn){
				tick = new Date().time;
			}
			proCount = obj.ic;
			autoCKBox.text = "下次自动使用道具原地复活(剩余"+proCount+")"
		}
	}
}
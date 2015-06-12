package com.leyou.ui.achievement
{
	import com.ace.config.Core;
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.gameData.table.TServerListInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.achievement.AchieveRoleData;
	import com.leyou.data.achievement.AchievementData;
	import com.leyou.data.achievement.AchievementEraData;
	import com.leyou.data.achievement.AchievementRoleProgressData;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.cmd.Cmd_Achievement;
	import com.leyou.ui.achievement.child.AchievementEraItem;
	import com.leyou.ui.achievement.child.AchievementRoleItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AchievementWnd extends AutoWindow
	{
		private var worldAchieveBtn:ImgLabelButton;
		
		private var forceBtn:ImgLabelButton;
		
		private var levelBtn:ImgLabelButton;
		
		private var equipBtn:ImgLabelButton;
		
		private var killBtn:ImgLabelButton;
		
		private var arenaBtn:ImgLabelButton;
		
		private var otherBtn:ImgLabelButton;
		
		private var activeBtn:ImgLabelButton;
		
		private var greatRoleBtn:ImgLabelButton;
		
		private var eraProgressLbl:Label;
		
		private var serverCbx:ComboBox;
		
		private var rolePanel:ScrollPane;
		
		private var roleItems:Vector.<AchievementRoleItem>;
		
		private var eraPanel:ScrollPane;
		
		private var eraItemStore:Object;
		
		private var initTable:Boolean = false;
		
		private var currentBtn:ImgLabelButton;

		private var finishedArr:Vector.<AchievementEraItem>;
		
		private var unfinishedArr:Vector.<AchievementEraItem>;
		
		private var tag:int;

		private var viewArr:Vector.<AchievementEraItem>;
		
		public function AchievementWnd(){
			super(LibManager.getInstance().getXML("config/ui/achievement/achievementWnd.xml"));
			init();
		}
		
		private function init():void{
			rolePanel = new ScrollPane(580, 390);
			eraPanel = new ScrollPane(580, 390);
			eraItemStore = new Object();
			roleItems = new Vector.<AchievementRoleItem>();
			finishedArr = new Vector.<AchievementEraItem>();
			unfinishedArr = new Vector.<AchievementEraItem>();
			rolePanel.x = 290;
			rolePanel.y = 160;
			eraPanel.x = 290;
			eraPanel.y = 160;
			addChild(rolePanel);
			addChild(eraPanel);
			rolePanel.visible = false;
			rolePanel.mouseChildren = true;
			
			worldAchieveBtn = getUIbyID("worldAchieveBtn") as ImgLabelButton;
			forceBtn = getUIbyID("forceBtn") as ImgLabelButton;
			levelBtn = getUIbyID("levelBtn") as ImgLabelButton;
			equipBtn = getUIbyID("equipBtn") as ImgLabelButton;
			killBtn = getUIbyID("killBtn") as ImgLabelButton;
			arenaBtn = getUIbyID("arenaBtn") as ImgLabelButton;
			otherBtn = getUIbyID("otherBtn") as ImgLabelButton;
			activeBtn = getUIbyID("activeBtn") as ImgLabelButton;
			greatRoleBtn = getUIbyID("GreatRoleBtn") as ImgLabelButton;
			eraProgressLbl = getUIbyID("eraProgressLbl") as Label;
			serverCbx = getUIbyID("serverCbx") as ComboBox;
			
			worldAchieveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			forceBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			levelBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			equipBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			killBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			arenaBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			activeBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			otherBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			greatRoleBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			serverCbx.addEventListener(DropMenuEvent.Item_Selected, onServerSelect);
			
			hideBg();
			clsBtn.x -= 25;
			clsBtn.y += 51;
		}
		
		protected function onServerSelect(event:Event):void{
			DataManager.getInstance().achievementData.serverId = serverCbx.value.uid;
			var serverId:String = DataManager.getInstance().achievementData.serverId;
			if(rolePanel.visible){
				Cmd_Achievement.cm_HSY_I(serverId);
				Cmd_Achievement.cm_HSY_R(serverId);
			}else{
				Cmd_Achievement.cm_HSY_I(serverId);
			}
		}
		
		public function updateRoleView():void{
			var achieveData:AchievementData = DataManager.getInstance().achievementData;
			var count:int = achieveData.roleDataCount;
			if(roleItems.length < count){
				roleItems.length = count;
			}
			var sumY:uint = 0;
			for(var n:int = 0; n < count; n++){
				var data:AchieveRoleData = achieveData.getRoleData(n);
				var item:AchievementRoleItem = roleItems[n];
				if(null == item){
					item = new AchievementRoleItem();
					roleItems[n] = item;
				}
				if(!rolePanel.contains(item)){
					rolePanel.addToPane(item);
				}
				item.update(data);
				item.y = sumY;
				sumY += (item.height + 8);
			}
			var l:int = roleItems.length;
			for(var m:int = count; m < l; m++){
				var vitem:AchievementRoleItem = roleItems[m];
				if(null != vitem && rolePanel.contains(vitem)){
					rolePanel.delFromPane(vitem);
				}
			}
			rolePanel.scrollTo(0);
			rolePanel.updateUI();
		}
		
		public function updateAchievementView():void{
//			var sdata:AchievementData = DataManager.getInstance().achievementData;
//			var l:int = eraItems.length;
//			for(var n:int = 0; n < l; n++){
//				var vitem:AchievementEraItem = eraItems[n];
//				if(eraPanel.contains(vitem)){
//					var data:AchievementEraData = sdata.getEraData(vitem.tid);
//					if(null != data){
//						vitem.updateByData(data);
//					}else{
//						vitem.reset();
//					}
//				}
//			}
			eraProgressLbl.text = DataManager.getInstance().achievementData.getProgress();
			showEraItemsByType(tag);
		}
		
		public function updateServerView():void{
			var data:AchievementData = DataManager.getInstance().achievementData;
			if(data.serverCount < 2){
				serverCbx.visible = false;
				var serverId:String = data.serverId;
				Cmd_Achievement.cm_HSY_I(serverId);
				UIOpenBufferManager.getInstance().addCmd(WindowEnum.ACHIEVEMENT, CmdEnum.SM_HSY_I);
			}else{
				serverCbx.visible = true;
				var arr:Array = [];
				var sc:int = data.serverCount;
				for(var n:int = 0; n < sc; n++){
					var serInfo:TServerListInfo = TableManager.getInstance().getServerInfo(UIEnum.PLAT_FORM_ID);
					if(null != serInfo){
						var serId:String = data.getServerId(n).match(/\d+/)[0];
						var serName:String;
						switch(UIEnum.PLAT_FORM_ID){
							case PlatformEnum.ID_KUGOU:
								serName = StringUtil.substitute(serInfo.name, serId, serId);
								break;
//							case PlatformEnum.ID_1360:
//								serName = StringUtil.substitute(serInfo.name, serId);
//								break;
//							case PlatformEnum.ID_YINGSU:
//								serName = StringUtil.substitute(serInfo.name, serId);
//								break;
//							case PlatformEnum.ID_TENCENT:
//								serName = StringUtil.substitute(serInfo.name, serId);
//								break;
//							case PlatformEnum.ID_14339:
//								serName = StringUtil.substitute(serInfo.name, serId);
//								break;
//							case PlatformEnum.ID_E7E7PK:
//								serName = StringUtil.substitute(serInfo.name, serId);
//								break;
							default:
								serName = StringUtil.substitute(serInfo.name, serId);
								break;
						}
						var obj:Object = {label:serName, uid:data.getServerId(n)}
						arr.push(obj);
					}else{
						throw new Error("找不到服务器名称.");
					}
				}
				serverCbx.list.addRends(arr);
				serverCbx.list.selectByUid(Core.serverName);
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			var serverId:String = DataManager.getInstance().achievementData.serverId;
//			if((null != serverId) && ("" != serverId)){
//				Cmd_Achievement.cm_HSY_I(serverId);
//			}
			initTableInfo();
		}
		
		private function initTableInfo():void{
			if(initTable){
				return;
			}
			initTable = true;
//			Cmd_Achievement.cm_HSY_S();
			showEraItemsByType(-1);
			worldAchieveBtn.turnOn();
		}
		
		private function showEraItemsByType($tag:int):void{
//			var t:uint = getTimer();
			tag = $tag;
			// 初始化信息
			var achievementDic:Object = TableManager.getInstance().getAchievementDic();
			var sdata:AchievementData = DataManager.getInstance().achievementData;
			var count:int;
			finishedArr.length = 0;
			unfinishedArr.length = 0;
			for(var key:String in achievementDic){
				var achievementInfo:TAchievementInfo = achievementDic[key];
				if((achievementInfo.tag == tag) || (-1 == tag)){
//					nvlEraItem(++count);
					var item:AchievementEraItem = eraItemStore[achievementInfo.id];
					if(null == item){
						item = new AchievementEraItem();
						eraItemStore[achievementInfo.id] = item;
					}
//					if(!eraPanel.contains(item)){
//						eraPanel.addToPane(item);
//						item.y = (count-1) * 98/*item.height*/;
//					}
					item.update(achievementInfo);
					var idata:AchievementEraData = sdata.getEraData(achievementInfo.id);
					var mData:AchievementRoleProgressData = sdata.getMyProgressData(achievementInfo.id);
					if(null != idata){
						item.updateByData(idata);
						finishedArr.push(item);
					}else{
						if(null != mData){
							item.updateProgress(mData);
						}else{
							item.resetProgress();
						}
						unfinishedArr.push(item);
					}
				}
			}
			finishedArr.sort(compare);
			unfinishedArr.sort(compare);
			var vl:int;
			var vitem:AchievementEraItem;
			if(null != viewArr){
				vl = viewArr.length;
				for(var m:int = 0; m < vl; m++){
					vitem = viewArr[m];
					if(eraPanel.contains(vitem)){
						eraPanel.delFromPane(vitem);
					}
				}
			}
			viewArr = finishedArr.concat(unfinishedArr);
			vl = viewArr.length;
			for(var n:int = 0; n < vl; n++){
				vitem = viewArr[n];
				eraPanel.addToPane(vitem);
				vitem.y = n * 98;
			}
			//排序,已完成的放前面
//			var fl:int = finishedArr.length;
//			for(var i:int = 0; i < count; i++){
//				if(i < fl){
//					eraItemStore[i] = finishedArr[i];
//				}else{
//					eraItemStore[i] = unfinishedArr[i-fl];
//				}
//			}
			// 删除多余项
//			var l:int = eraItemStore.length;
//			for(var n:int = 0; n < l; n++){
//				var vitem:AchievementEraItem = eraItemStore[n];
//				if(n >= count){
//					if((null != vitem) && eraPanel.contains(vitem)){
//						eraPanel.delFromPane(vitem);
//					}
//				}else{
//					vitem.y = n * 98;
//				}
//			}
			eraPanel.scrollTo(0);
			eraPanel.updateUI();
//			trace("--------------achievement update info cost time =  "+ (getTimer() - t))
		}
		
		private function compare(p:AchievementEraItem, n:AchievementEraItem):int{
			if(p.tid > n.tid){
				return 1;
			}else if(p.tid < n.tid){
				return -1;
			}
			return 0;
		}
		
//		private function nvlEraItem(count:int):void{
//			if(count > eraItems.length){
//				eraItems.length = count;
//			}
//		}
		
		private function exchangeToEra(v:Boolean):void{
			if(eraPanel.visible != v){
				eraPanel.visible = v;
				rolePanel.visible = !v;
				var serverId:String = DataManager.getInstance().achievementData.serverId;
				Cmd_Achievement.cm_HSY_I(serverId);
			}
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			if(currentBtn == event.target){
				return;
			}
			if(null != currentBtn){
				currentBtn.turnOff();
			}
			switch(event.target.name){
				case "worldAchieveBtn":
					exchangeToEra(true);
					showEraItemsByType(-1);
					currentBtn = worldAchieveBtn;
					break;
				case "forceBtn":
					exchangeToEra(true);
					showEraItemsByType(1);
					currentBtn = forceBtn;
					break;
				case "levelBtn":
					exchangeToEra(true);
					showEraItemsByType(2);
					currentBtn = levelBtn;
					break;
				case "equipBtn":
					exchangeToEra(true);
					showEraItemsByType(3);
					currentBtn = equipBtn;
					break;
				case "killBtn":
					exchangeToEra(true);
					showEraItemsByType(4);
					currentBtn = killBtn;
					break;
				case "arenaBtn":
					exchangeToEra(true);
					showEraItemsByType(5);
					currentBtn = arenaBtn;
					break;
				case "activeBtn":
					exchangeToEra(true);
					showEraItemsByType(6);
					currentBtn = activeBtn;
					break;
				case "otherBtn":
					exchangeToEra(true);
					showEraItemsByType(7);
					currentBtn = otherBtn;
					break;
				case "GreatRoleBtn":
					var serverId:String = DataManager.getInstance().achievementData.serverId;
					Cmd_Achievement.cm_HSY_R(serverId);
					exchangeToEra(false);
					currentBtn = greatRoleBtn;
					break;
				default:
					break;
			}
			if(null != currentBtn){
				currentBtn.turnOn();
			}
		}
	}
}
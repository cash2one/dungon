/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-13 上午11:23:10
 */
package com.ace.game.scene.ui.head {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.KeysEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.gameData.buff.child.BuffInfo;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSpriteII;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.ui.Keyboard;

	/**
	 * 其他玩家头像
	 * @author ace
	 *
	 */
	public class OtherRoleHead extends AutoSpriteII implements IMenu {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var hpLbl:Label;
		private var userheadImg:Image;
//		private var professionImg:Image;
//		private var hpImg:Image;
		private var lookBtn:ImgButton;
//		private var elementImg:Image;
		private var closeBtn:ImgButton;
		private var lockBtn:ImgButton;
		
		private var vipImg:Image;
		private var teamImg:Image;
		private var doubleImg:Image;
		private var bloodImg:Image;
		private var freshImg:Image;
		private var safeImg:Image;
		private var lockImg:Image;

		public function OtherRoleHead() {
			super("config/ui/scene/OtherHeadWnd.xml");
			mouseChildren=true;
		}


		override protected function init():void {
			super.init();
			nameLbl=getUIbyID("nameLbl") as Label;
			lvLbl=getUIbyID("lvLbl") as Label;
			hpLbl=getUIbyID("hpLbl") as Label;
			userheadImg=getUIbyID("userheadImg") as Image;
			lockImg=getUIbyID("lockImg") as Image;
//			var container:Sprite=new Sprite();
//			container.name=professionImg.name;
//			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			professionImg.parent.addChild(container);
//			container.addChild(professionImg);
//			hpImg=getUIbyID("hpImg") as Image;
//			elementImg=getUIbyID("elementImg") as Image;
			lookBtn=getUIbyID("lookBtn") as ImgButton;
			closeBtn=getUIbyID("closeBtn") as ImgButton;
			lockBtn=getUIbyID("lockBtn") as ImgButton;
			lookBtn.addEventListener(MouseEvent.MOUSE_DOWN, onCLick);
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, onCLick);
			lockBtn.addEventListener(MouseEvent.MOUSE_DOWN, onCLick);
			if (null == hpProgressImg) {
				hpProgressImg=new ProgressImage();
				addChildAt(hpProgressImg, 2);
				hpProgressImg.updateBmp("ui/mainUI/main_other_hp.png");
				hpProgressImg.x=42;
				hpProgressImg.y=37;
			}
			
			vipImg = getUIbyID("vipImg") as Image;
			teamImg = getUIbyID("teamImg") as Image;
			doubleImg = getUIbyID("doubleImg") as Image;
			bloodImg = getUIbyID("bloodImg") as Image;
			safeImg = getUIbyID("safeImg") as Image;
			freshImg = getUIbyID("freshImg") as Image;
//			professionImg=getUIbyID("professionImg") as Image;
			packContainer(vipImg);
			packContainer(teamImg);
			packContainer(doubleImg);
			packContainer(bloodImg);
			packContainer(freshImg);
			packContainer(safeImg);
//			packContainer(professionImg);
			
			activeIcon("vipImg", false);
			activeIcon("teamImg", false);
			activeIcon("doubleImg", false);
			activeIcon("bloodImg", false);
			activeIcon("freshImg", false);
			activeIcon("safeImg", false);
			
			EventManager.getInstance().addEvent(EventEnum.LOCK_TARGET_IN, onTargetIn);
			EventManager.getInstance().addEvent(EventEnum.LOCK_TARGET_OUT, onTargetOut);
			EventManager.getInstance().addEvent(EventEnum.SETTING_UPDATE_LOCK_TARGET, updateTarget);
			var content:String = TableManager.getInstance().getSystemNotice(9991).content;
			lockBtn.setToolTip(content);
		}
		
		private function onTargetOut():void{
			this.filters = [FilterEnum.enable];
		}
		
		private function onTargetIn():void{
			this.filters = null;
		}
		
		private function updateTarget():void{
			var url:String = Core.me.pInfo.isLockAttackTarget ? "ui/mainUI/min_ui_unlock.png" : "ui/mainUI/min_ui_lock.png";
			lockImg.updateBmp(url);
			var id:int = Core.me.pInfo.isLockAttackTarget ? 9990 : 9991;
			var content:String = TableManager.getInstance().getSystemNotice(id).content;
			lockBtn.setToolTip(content);
		}
		
		public override function hide():void{
			super.hide();
			this.filters = null;
		}
		
		private function packContainer(img:Image):void{
			var container:Sprite = new Sprite();
			container.name = img.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			img.parent.addChild(container);
			container.addChild(img);
		}
		
		public function activeIcon(tn:String, value:Boolean, values:Array=null):void{
			switch(tn){
				case "vipImg":
					vipImg.filters = value ? null : [FilterEnum.enable];
					break;
				case "teamImg":
					teamImg.filters = value ? null : [FilterEnum.enable];
					break;
				case "doubleImg":
					doubleImg.filters = value ? null : [FilterEnum.enable];
					break;
				case "bloodImg":
					bloodImg.filters = value ? null : [FilterEnum.enable];
					break;
				case "freshImg":
					if(value){
						freshImg.visible = true;
						safeImg.visible = false;
					}else{
						freshImg.visible = false;
					}
					break;
				case "safeImg":
					if(value){
						safeImg.visible = true;
						freshImg.visible = false;
					}else{
						safeImg.visible = false;
					}
					break;
			}
		}
		
//		private function onMouseOut(event:MouseEvent):void{
//			ToolTipManager.getInstance().hide();
//			TimeManager.getInstance().removeITick(onTipTick);
//		}
		
//		private function onTipTick():void{
//			var content:String = TableManager.getInstance().getSystemNotice(9967).content;
//			content = StringUtil.substitute(content, TimeUtil.date2CnFormat(SceneCore.me.info.buffsInfo.getBuff(950).lastTime));
//			ToolTipManager.getInstance().show(TipEnum.TYPE_MAP, content, new Point(this.stage.mouseX + 30, this.stage.mouseY + 30));
//		}
		
		private var teamVlaues:Array;

		protected function onMouseOver(event:MouseEvent):void {
			if (!info) {
				return;
			}
			var id:int;
			var content:String;
			switch(event.target.name){
//				case "professionImg":
//					if (PlayerEnum.PRO_MASTER == info.profession) {
//						content="法师";
//					} else if (PlayerEnum.PRO_RANGER == info.profession) {
//						content="游侠";
//					} else if (PlayerEnum.PRO_SOLDIER == info.profession) {
//						content="战士";
//					} else if (PlayerEnum.PRO_WARLOCK == info.profession) {
//						content="术士";
//					}
//					break;
				case "vipImg":
					id = (null != vipImg.filters && 0 != vipImg.filters.length) ? 6000 : 6001;
					var expRate:int = TableManager.getInstance().getVipInfo(12).getVipValue(info.vipLv);
					var sitRate:int = TableManager.getInstance().getVipInfo(11).getVipValue(info.vipLv);
					var energyRate:int = TableManager.getInstance().getVipInfo(10).getVipValue(info.vipLv);
					content = TableManager.getInstance().getSystemNotice(id).content;
					if(info.vipLv > 0){
						content = StringUtil.substitute(content, info.vipLv, expRate, sitRate, energyRate);
					}
					break;
				case "teamImg":
					id = (null != teamImg.filters && 0 != teamImg.filters.length) ? 3120 : 3121;
					content = TableManager.getInstance().getSystemNotice(id).content;
					if(teamVlaues && teamVlaues.length > 0){
						content = StringUtil.substitute(content, teamVlaues);
					}
					break;
				case "doubleImg":
					id = (null != doubleImg.filters && 0 != doubleImg.filters.length) ? 9966 : 9982;
					content = TableManager.getInstance().getSystemNotice(id).content;
					break;
				case "bloodImg":
					id = (null != bloodImg.filters && 0 != bloodImg.filters.length) ? 9968 : 9983;
					content = TableManager.getInstance().getSystemNotice(id).content;
					break;
				case "freshImg":
					id = 9970;
					content = TableManager.getInstance().getSystemNotice(id).content;
					break;
				case "safeImg":
					id = 9985;
					content = TableManager.getInstance().getSystemNotice(id).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		private var info:LivingInfo;
		private var hpProgressImg:ProgressImage;

		private var info2:Vector.<MenuInfo>;

		public function updataHP($info:LivingInfo):void {
			info=$info;
			if (!isInit)
				return;
			hpProgressImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
		}

		public function onResize($w:Number=0, $h:Number=0):void {
			this.x=500;
			this.y=20;
		}

		public function updataUI($info:LivingInfo):void {
			info=$info;
			if (!isInit)
				return;
			hpProgressImg.setProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			updateInfo($info)
		}

		private function updateInfo($info:LivingInfo):void {
			nameLbl.text=info.name+"[lv"+info.level+"]";
//			lvLbl.text=info.level.toString();
			hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
			//			userheadImg.updateBmp("");
			//			professionImg.updateBmp("");
//			professionImg.updateBmp("ui/common/common_profession_" + info.profession + ".png");
			userheadImg.updateBmp(PlayerUtil.getPlayerHeadImg(info.profession, info.sex));
			
			// vip
			activeIcon("vipImg", info.vipLv > 0);
			
			var tbInfo:TBuffInfo;
			var bInfo:BuffInfo = null;
			// 补血buff
			bInfo = info.buffsInfo.getBuff(408);
			if(null != bInfo){
				activeIcon("bloodImg", true);
			}else{
				activeIcon("bloodImg", false);
			}
			// 组队buff
			bInfo = null;
			bInfo = info.buffsInfo.getBuff(900);
			if(null == bInfo){
				bInfo = info.buffsInfo.getBuff(901);
			}
			if(null == bInfo){
				bInfo = info.buffsInfo.getBuff(902);
			}
			if(null != bInfo){
				if(null == teamVlaues){
					teamVlaues = [];
					tbInfo = TableManager.getInstance().getBuffInfo(bInfo.id);
					var reg:RegExp = /\d{1,3}/g;
					teamVlaues = tbInfo.des.match(reg);
				}
				activeIcon("teamImg", true);
			}else{
				activeIcon("teamImg", false);
			}
			// 双倍经验buff
			bInfo = null;
			bInfo = info.buffsInfo.getBuff(950);
			if(null != bInfo){
				activeIcon("doubleImg", true);
			}else{
				activeIcon("doubleImg", false);
			}
			// 安全保护buff
			bInfo = null;
			bInfo = info.buffsInfo.getBuff(952);
			if(null != bInfo){
				activeIcon("safeImg", true);
			}else{
				activeIcon("safeImg", false);
			}
		}


		private function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "lookBtn":
					lookOtherRole();
					break;
				case "lockBtn":
//					EventManager.getInstance().dispatchEvent(EventEnum.KEY_CLICK);
					KeysManager.getInstance().disPatchEvent(Keyboard.CONTROL, KeysEnum.KEY_CLICK);
					//					lockBtn.updataBmd("");
					break;
				case "closeBtn":
					Core.me.clearTarget();
//					KeysManager.getInstance().disPatchEvent(Keyboard.ESCAPE, KeysEnum.KEY_CLICK);
//					EventManager.getInstance().dispatchEvent(EventEnum.LOCK_OTHER_HEAD);
					break;
			}
		}


		private function lookOtherRole():void {
			if (null == info2) {
				info2=new Vector.<MenuInfo>;
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[0], ChatEnum.PRIVATE_CHAT));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[1], ChatEnum.CHECK_STATUS));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[2], ChatEnum.ADD_TEAM));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[3], ChatEnum.ADD_FRIEND));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[4], ChatEnum.ADD_BLACK));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[5], ChatEnum.ADD_GUILD));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[6], ChatEnum.COPY));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL));
				info2.push(new MenuInfo(ChatEnum.CLICK_MENU_II[7], ChatEnum.SUE));
				info2.push(new MenuInfo(PropUtils.getStringById(2242), ChatEnum.PROPOSAL));
			}
			MenuManager.getInstance().show(info2, this);
		}

		public function onMenuClick(index:int):void {
			var livingModel:LivingModel=UIManager.getInstance().gameScene.getPlayer(Core.me.info.recordLookTargetId);
			if(null == livingModel){
				return;
			}
			var currPlayer:String = livingModel.info.name;
			switch (index) {
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
					UIManager.getInstance().chatWnd.privateChat(currPlayer);
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
				case ChatEnum.DUEL:
					Cmd_Duel.cm_DUEL_T(currPlayer);
					break;
				case ChatEnum.PROPOSAL:
					UIManager.getInstance().roleWnd.startMarry(currPlayer);
					break;
			}
		}
	}
}

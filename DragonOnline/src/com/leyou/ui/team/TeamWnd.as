package com.leyou.ui.team {

	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.team.child.TeamPlayerRender;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TeamWnd extends AutoWindow implements IMenu {

		private var noTeamCb:CheckBox;
		private var bossAccCb:CheckBox;

		private var viewDataBtn:ImgLabelButton;
		private var addFirBtn:ImgLabelButton;
		private var exitTeamBtn:ImgLabelButton;
		private var topBossBtn:ImgLabelButton;
		private var expelPlayBtn:ImgLabelButton;
		private var addTeamBtn:ImgLabelButton;
		private var createTeamBtn:ImgLabelButton;
		private var searchTeamBtn:ImgLabelButton;
		private var teamBgImg:Image;

		private var hpImg:Image;
		private var expImg:Image;
		private var dropImg:Image;
		private var hpLbl:Label;
		private var expLbl:Label;
		private var dropLbl:Label;

		private var teamPlayVec:Vector.<String>;
		private var teamPlayItems:Vector.<TeamPlayerRender>;

		private var teamAddPlayWnd:TeamAddPlayerWnd;
		private var teamAddTeamWnd:TeamAddATeamWnd;

		private var bossCross:Boolean=false;

		public var teamInviteWnd:TeamInviteWnd;
		private var wnd:SimpleWindow;

		private var tempRect:Array=[];

		/**
		 *服务器数据
		 */
		private var info:Object;

		private var selectPlayIndex:int=-1;

		/**
		 * teamid
		 */
		private var tid:int=0;

		public function TeamWnd() {
			super(LibManager.getInstance().getXML("config/ui/TeamWnd.xml"));
			this.init();
		}

		private function init():void {
			this.noTeamCb=this.getUIbyID("noTeamCb") as CheckBox;
			this.bossAccCb=this.getUIbyID("bossAccCb") as CheckBox;

			this.viewDataBtn=this.getUIbyID("viewDataBtn") as ImgLabelButton;
			this.addFirBtn=this.getUIbyID("addFirBtn") as ImgLabelButton;
			this.exitTeamBtn=this.getUIbyID("exitTeamBtn") as ImgLabelButton;
			this.topBossBtn=this.getUIbyID("topBossBtn") as ImgLabelButton;
			this.expelPlayBtn=this.getUIbyID("expelPlayBtn") as ImgLabelButton;
			this.addTeamBtn=this.getUIbyID("addTeamBtn") as ImgLabelButton;
			this.createTeamBtn=this.getUIbyID("createTeamBtn") as ImgLabelButton;
			this.searchTeamBtn=this.getUIbyID("searchTeamBtn") as ImgLabelButton;

			this.teamBgImg=this.getUIbyID("teamBgImg") as Image;
			this.hpImg=this.getUIbyID("hpImg") as Image;
			this.dropImg=this.getUIbyID("dropImg") as Image;
			this.expImg=this.getUIbyID("expImg") as Image;

			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.expLbl=this.getUIbyID("expLbl") as Label;
			this.dropLbl=this.getUIbyID("dropLbl") as Label;

			this.hpLbl.mouseEnabled=true;
			this.expLbl.mouseEnabled=true;
			this.dropLbl.mouseEnabled=true;

			this.noTeamCb.addEventListener(MouseEvent.CLICK, onClick);
			this.bossAccCb.addEventListener(MouseEvent.CLICK, onClick);
			this.viewDataBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addFirBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.exitTeamBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.topBossBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.expelPlayBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addTeamBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.createTeamBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.searchTeamBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.CLICK, onItemClick);
//			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.teamPlayItems=new Vector.<TeamPlayerRender>();
			this.teamPlayVec=new Vector.<String>();

			this.teamAddPlayWnd=new TeamAddPlayerWnd();
			this.teamAddTeamWnd=new TeamAddATeamWnd();
			this.teamInviteWnd=new TeamInviteWnd();

//			this.createTeamBtn.visible=false;
//			this.viewDataBtn.visible=false;
//			this.addFirBtn.visible=false;
//			this.topBossBtn.visible=false;
//			this.expelPlayBtn.visible=false;
//			this.addTeamBtn.visible=false;

			this.hpLbl.addEventListener(MouseEvent.MOUSE_MOVE, onTipsMouseOver)
			this.hpLbl.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut)
			this.expLbl.addEventListener(MouseEvent.MOUSE_MOVE, onTipsMouseOver)
			this.expLbl.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut)
			this.dropLbl.addEventListener(MouseEvent.MOUSE_MOVE, onTipsMouseOver)
			this.dropLbl.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut)

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.hpImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.expImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.dropImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onLeftClick=onLeftClick;

			MouseManagerII.getInstance().addEvents(this.teamBgImg, einfo);

			var spr:Sprite;
			for (var i:int=0; i < 4; i++) {
				spr=new Sprite();

				spr.graphics.beginFill(0x000000);
				spr.graphics.drawRect(0, 0, 183, 370);
				spr.graphics.endFill();

				spr.x=18 + i * 185;
				spr.y=50;
				spr.name="rectspr" + i;
				spr.alpha=0;
				spr.addEventListener(MouseEvent.CLICK, onItemClick);

				this.addChild(spr);
				this.tempRect.push(spr);
			}

		}

		private function onLeftClick(e:DisplayObject):void {
			this.teamAddPlayWnd.show(true);
		}

		private function onTipsMouseOver(e:Object):void {
			if (e is MouseEvent) {

				if (e.target == this.hpLbl)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3115).content, [this.hpLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));
				else if (e.target == this.expLbl)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3116).content, [this.expLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));
				else if (e.target == this.dropLbl)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3117).content, [this.dropLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));

			} else {

				if (e == this.hpImg)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3115).content, [this.hpLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));
				else if (e == this.expImg)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3116).content, [this.expLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));
				else if (e == this.dropImg)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3117).content, [this.dropLbl.text.replace(/[\+\%]/g, "")]), new Point(this.stage.mouseX, this.stage.mouseY));
			}
		}

		private function onTipsMouseOut(e:Object):void {
			ToolTipManager.getInstance().hide();
		}

		public function onMenuClick(i:int):void {

			switch (i) {
				case 1:
					if (this.selectPlayIndex != -1)
						UIManager.getInstance().otherPlayerWnd.showPanel(this.teamPlayItems[selectPlayIndex].playName());
					break;
				case 2:
					if (selectPlayIndex != -1)
						Cmd_Friend.cm_FriendMsg_A(1, this.teamPlayItems[selectPlayIndex].playName());
					break;
				case 3:
					if (selectPlayIndex != -1)
						Cmd_Tm.cm_teamAppoint(this.teamPlayItems[selectPlayIndex].playName());
					break;
				case 4:
					if (selectPlayIndex != -1)
						Cmd_Tm.cm_teamKill(this.teamPlayItems[selectPlayIndex].playName());
					selectPlayIndex=-1;
					break;
			}

		}


		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "noTeamCb":
					Cmd_Tm.cm_teamAutoSetting(1, (this.noTeamCb.isOn ? 1 : 0));
					break;
				case "bossAccCb":
					Cmd_Tm.cm_teamAutoSetting(2, (this.bossAccCb.isOn ? 1 : 0));
					break;
				case "viewDataBtn":
					if (this.selectPlayIndex != -1)
						UIManager.getInstance().otherPlayerWnd.showPanel(this.teamPlayItems[selectPlayIndex].playName());
					break;
				case "addFirBtn":
					if (selectPlayIndex != -1)
						Cmd_Friend.cm_FriendMsg_A(1, this.teamPlayItems[selectPlayIndex].playName());
					break;
				case "exitTeamBtn":

					wnd=PopupManager.showConfirm(PropUtils.getStringById(1915), function():void {
						Cmd_Tm.cm_teamQuit();
					}, null, false, "teamExit");

					break;
				case "topBossBtn":
					if (selectPlayIndex != -1)
						Cmd_Tm.cm_teamAppoint(this.teamPlayItems[selectPlayIndex].playName());
//					selectPlayIndex=-1;
					break;
				case "expelPlayBtn":
					if (selectPlayIndex != -1)
						Cmd_Tm.cm_teamKill(this.teamPlayItems[selectPlayIndex].playName());
//					selectPlayIndex=-1;
					break;
				case "addTeamBtn":
					teamAddPlayWnd.open();
					break;
				case "createTeamBtn":
					Cmd_Tm.cm_teamCreate();
					break;
				case "searchTeamBtn":
					teamAddTeamWnd.open();
					break;
			}

		}

		public function onItemClick(e:MouseEvent):void {

			if (e.target.name.indexOf("rect") > -1) {
				e.stopImmediatePropagation();

				if (this.selectPlayIndex != -1 && this.teamPlayItems.length > this.selectPlayIndex)
					this.teamPlayItems[this.selectPlayIndex].setHigit(false);

				this.selectPlayIndex=this.tempRect.indexOf(e.target);
				this.teamPlayItems[this.selectPlayIndex].setHigit(true);

				if (this.teamPlayItems[selectPlayIndex].playName() == MyInfoManager.getInstance().name)
					return;

				var menuVec:Vector.<MenuInfo>=new Vector.<MenuInfo>();
				menuVec.push(new MenuInfo(PropUtils.getStringById(1916), 1));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1711), 2));

				if (this.bossCross) {
					menuVec.push(new MenuInfo(PropUtils.getStringById(1917), 3));
					menuVec.push(new MenuInfo(PropUtils.getStringById(1918), 4));
				}

				MenuManager.getInstance().show(menuVec, this, new Point(e.stageX - 35, e.stageY));
			} else {
//				this.selectPlayIndex=-1;
			}
		}

		private function onMouseOver(e:MouseEvent):void {
			if (e.target is TeamPlayerRender) {
				TeamPlayerRender(e.target).setHigit(true);
			}
		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is TeamPlayerRender) {
				if (selectPlayIndex != this.teamPlayItems.indexOf(e.target as TeamPlayerRender))
					TeamPlayerRender(e.target).setHigit(false);
			}
		}

		/**
		 * @param o
		 */
		public function updateTeamPlays(o:Object):void {

			if (o == null)
				return;
			
			UIManager.getInstance().showPanelCallback(WindowEnum.TEAM);
			

			if (this.info == null) {
				SoundManager.getInstance().play(20);
			}

			this.info=o;

			var prender:TeamPlayerRender;
			for each (prender in this.teamPlayItems) {
				if (prender != null) {
					prender.removeAvatar();
					this.removeChild(prender);
				}
			}

			this.teamPlayItems.length=0;

			if (o.hasOwnProperty("tid"))
				this.tid=o.tid;

			if (o.hasOwnProperty("u")) {
				this.bossCross=false;
				var cross:int=0;
				var u:Array=o.u;
				var t:Array=[];

				for (var i:int=0; i < u.length; i++) {
					if (u[i][0] == MyInfoManager.getInstance().name) {

						if (i > 0) {
							t=u.splice(i, 1, u[0]);
							u[0]=t[0];
							cross=i;
							break;
						} else {
							this.bossCross=true;
						}

					}
				}

				var trender:TeamPlayerRender;
				for (i=0; i < u.length; i++) {
					prender=new TeamPlayerRender();

					prender.x=17 + i * 185;
					prender.y=50;

					prender.updateInfo(u[i], i);

					this.addChild(prender);
					this.teamPlayItems.push(prender);

					if (cross == i) {
						prender.boosImgVisible(true);
						trender=prender;
					} else {
						prender.boosImgVisible(false);
					}

//					if (i == 0)
//						prender.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}

				if (trender != null)
					trender.setboosImgTop();

				for (i=0; i < 4; i++) {
					if (i < u.length) {
						this.tempRect[i].visible=true;
						this.setChildIndex(this.tempRect[i], this.numChildren - 1);
					} else {
						this.tempRect[i].visible=false;
					}
				}

			}

			if (this.selectPlayIndex >= this.teamPlayItems.length)
				this.selectPlayIndex=-1;

			if (o.av != 0)
				this.noTeamCb.turnOn();
			else
				this.noTeamCb.turnOff();

			if (o.aa != 0)
				this.bossAccCb.turnOn();
			else
				this.bossAccCb.turnOff();

			this.expLbl.text="+" + o.exp + "%";
			this.dropLbl.text="+" + o.at + "%";
			this.hpLbl.text="+" + o.hp + "%";

			if (o.exp > 0) {
				this.expLbl.visible=true;
				this.expImg.filters=[];
			} else {
				this.expLbl.visible=false;
				this.expImg.filters=[FilterUtil.enablefilter];
			}

			if (o.at > 0) {
				this.dropLbl.visible=true;
				this.dropImg.filters=[];
			} else {
				this.dropLbl.visible=false;
				this.dropImg.filters=[FilterUtil.enablefilter];
			}

			if (o.hp > 0) {
				this.hpLbl.visible=true;
				this.hpImg.filters=[];
			} else {
				this.hpLbl.visible=false;
				this.hpImg.filters=[FilterUtil.enablefilter];
			}

			if (o.u.length > 0) {

				if (o.u[cross][0] == MyInfoManager.getInstance().name) {
					this.topBossBtn.setActive(true, 1, true);
					this.expelPlayBtn.setActive(true, 1, true);
				} else {
					this.topBossBtn.setActive(false, .6, true);
					this.expelPlayBtn.setActive(false, .6, true);
				}

				MyInfoManager.getInstance().isTeam=true;
				this.teamAddTeamWnd.hide();

			} else {

				this.hpLbl.visible=false;
				this.hpImg.filters=[FilterUtil.enablefilter];

				this.dropLbl.visible=false;
				this.dropImg.filters=[FilterUtil.enablefilter];

				this.expLbl.visible=false;
				this.expImg.filters=[FilterUtil.enablefilter];

				MyInfoManager.getInstance().isTeam=false;
			}

			UIManager.getInstance().gameScene.checkBuff();
			changeTeamBtnState();
		}

		/**
		 * 更新自己的换装
		 */
		public function updateSelfAvatar():void {
			if (this.visible && this.teamPlayItems.length >= 1)
				this.teamPlayItems[0].updateBigAvatar(Core.me.info.featureInfo);
		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
		}
		
		override public function sendOpenPanelProtocol(...parameters):void{
			this.dataModel=parameters;
			Cmd_Tm.cm_teamInit();
		}

		public function teamAddPlayPanel():TeamAddPlayerWnd {
			return this.teamAddPlayWnd;
		}

		public function teamAddTeamPanel():TeamAddATeamWnd {
			return this.teamAddTeamWnd;
		}

		/**
		 * 是否是组队状态的下显示的按钮
		 */
		private function changeTeamBtnState():void {

			if (this.teamPlayItems.length > 0) {

				this.viewDataBtn.visible=true;
				this.addFirBtn.visible=true;
				this.topBossBtn.visible=true;
				this.expelPlayBtn.visible=true;
				this.addTeamBtn.visible=true;
				this.exitTeamBtn.visible=true;

				this.searchTeamBtn.visible=false;
				this.createTeamBtn.visible=false;

			} else {

				this.viewDataBtn.visible=false;
				this.addFirBtn.visible=false;
				this.topBossBtn.visible=false;
				this.expelPlayBtn.visible=false;
				this.exitTeamBtn.visible=false;

				this.searchTeamBtn.visible=true;
				this.createTeamBtn.visible=true;
			}

		}

		/**
		 *比较 team playName
		 * @param playName
		 * @return
		 *
		 */
		public function compareTeamPlayName(playName:String):Boolean {

			if (this.info != null && this.info.u.length != 0) {

				for (var i:int=0; i < this.info.u.length; i++) {
					if (this.info.u[i][0] == playName)
						return true;
				}
			}

			return MyInfoManager.getInstance().name == playName;
		}

		public function compareTeamNoSelfPlayName(playName:String):Boolean {

			if (this.info != null && this.info.u.length != 0) {

				for (var i:int=0; i < this.info.u.length; i++) {
					if (this.info.u[i][0] == playName)
						return true;
				}
			}

			return false;
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		override public function hide():void {
			super.hide();

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.teamBtn);

			teamAddPlayWnd.hide();
			teamAddTeamWnd.hide();
			teamInviteWnd.hide();

			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}

		}

	}
}

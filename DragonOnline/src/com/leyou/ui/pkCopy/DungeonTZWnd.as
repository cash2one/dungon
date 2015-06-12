package com.leyou.ui.pkCopy {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.ArrayUtil;
	import com.ace.utils.ObjectUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Act;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.ui.pkCopy.child.DungeonTZRender;
	import com.leyou.ui.pkCopy.child.DungeonTzGrid;
	import com.leyou.utils.TaskUtil;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class DungeonTZWnd extends AutoSprite {

		private var itemList:ScrollPane;
		private var bigImg:Image;
		private var bgimg:Image;
		private var titleImg:Image;
		private var ruleLbl:Label;
		private var timeLbl:Label;
		private var timerLbl:Label;
		private var accpetBtn:NormalButton;
		private var flyBtn:ImgButton;

		private var startBtn:ImgButton;

		private var itemsList:Vector.<DungeonTZRender>;
		private var gridList:Vector.<DungeonTzGrid>;

		private var currentDateTime:int=0;
		private var timer:int=0;

		private var date:Date;
		private var date1:Date;
		private var date2:Date;

		private var selectId:int=-1;
		private var startId:int=-1;
		private var clientId:int=-1;

		private var scenesType:int;

		private var o:Object;

		public function DungeonTZWnd() {
//			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonTZWnd.xml"));
			super(LibManager.getInstance().getXML("config/ui/pkCopy/bossTZRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.bigImg=this.getUIbyID("bigImg") as Image;
			this.bgimg=this.getUIbyID("bgimg") as Image;
			this.titleImg=this.getUIbyID("titleImg") as Image;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.accpetBtn=this.getUIbyID("accpetBtn") as NormalButton;
			this.flyBtn=this.getUIbyID("flyBtn") as ImgButton;

			this.flyBtn.visible=this.bgimg.visible=false;

			this.ruleLbl.height=139;
			this.ruleLbl.width=256;
			this.ruleLbl.wordWrap=true;
			this.ruleLbl.multiline=true;

			this.gridList=new Vector.<DungeonTzGrid>();
			this.itemsList=new Vector.<DungeonTZRender>();

			this.accpetBtn.addEventListener(MouseEvent.CLICK, onAccpetClick);
			this.flyBtn.addEventListener(MouseEvent.CLICK, onFlyClick);
			this.itemList.addEventListener(MouseEvent.CLICK, onClick);

			date=new Date();

			this.startBtn=new ImgButton("ui/tz/tz_btn_sglx.png");
			LayerManager.getInstance().windowLayer.addChild(this.startBtn);

			this.startBtn.visible=false;
			this.startBtn.addEventListener(MouseEvent.CLICK, onStartClick);

			this.timerLbl=new Label();
			LayerManager.getInstance().windowLayer.addChild(this.timerLbl);
			this.timerLbl.width=150;

			this.timerLbl.x=(UIEnum.WIDTH - 150) - 80;
			this.timerLbl.y=6;

			this.timerLbl.visible=true;

			TimerManager.getInstance().add(exePkCopyTime);

			this.x=-13;
			this.y=3;
		}

		private function onStartClick(e:MouseEvent):void {

			if (MapInfoManager.getInstance().type == SceneEnum.SCENE_TYPE_PTCJ) {
				if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYPANEL))
					UIManager.getInstance().creatWindow(WindowEnum.PKCOPYPANEL);

				UIManager.getInstance().pkCopyPanel.updateInfo({actid: startId});
			} else {
				NoticeManager.getInstance().broadcastById(4408);
			}
		}

		private function onFlyClick(e:MouseEvent):void {

			if (ConfigEnum.MarketOpenLevel <= Core.me.info.level) {
				var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.traveItem);

				if (MyInfoManager.getInstance().VipLastTransterCount == 0 && MyInfoManager.getInstance().getBagItemNumByName(tinfo.name) <= 0) {

					if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.traveItem, ConfigEnum.traveBindItem)) {
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
						UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.traveItem, ConfigEnum.traveBindItem);

						return;
					} else {
						UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.traveItem, ConfigEnum.traveBindItem);
					}
				}
			}

			Cmd_Go.cmGoNpc(ConfigEnum.delivery21);
		}

		private function onAccpetClick(e:MouseEvent):void {

			if (this.selectId != -1)
				Cmd_Act.cmActNowAccept(selectId);
		}

		private function exePkCopyTime(i:int):void {

			this.timerLbl.htmlText="<font color='#ffffff' size='14'>" + TimeUtil.getTimeToString(date) + "</font>";
			this.timerLbl.textColor=0xffffff;

			this.timerLbl.x=(UIEnum.WIDTH - this.timerLbl.width) - 120;
			this.timerLbl.y=6;

			this.updateList();

//			trace(MapInfoManager.getInstance().type, this.clientId)
			if (MapInfoManager.getInstance() != null && MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ && MapInfoManager.getInstance().type == this.clientId) {
				this.startBtn.visible=false;
			}
		}

		private function onClick(e:MouseEvent):void {

			if (!(e.target.parent is DungeonTZRender))
				return;

			var render:DungeonTZRender;
			for each (render in this.itemsList) {
				render.setHight(false);
			}

			ImgButton(e.target).turnOn();

			selectId=DungeonTZRender(e.target.parent).id;

			var tinfo:TTzActiive=TableManager.getInstance().getTzActiveByID(selectId);

			this.titleImg.updateBmp("ui/tz/" + tinfo.nameImage);
			this.bigImg.updateBmp("ui/tz/" + tinfo.bImage);
//			this.bigImg.updateBmp("ui/dungeon/" + tinfo.sImage);
			this.ruleLbl.htmlText=tinfo.des1 + "";
			this.timeLbl.text=tinfo.time.replace("|", "\-").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2");

			var dgrid:DungeonTzGrid;
			for each (dgrid in this.gridList) {
				this.removeChild(dgrid);
			}

			this.gridList.length=0;

			var i:int=0;
			for (i=0; i < 5; i++) {

				if (tinfo["item" + (i + 1)] == 0)
					continue;

				dgrid=new DungeonTzGrid();
				dgrid.updataInfo(TableManager.getInstance().getItemInfo(tinfo["item" + (i + 1)]));

				dgrid.y=70;
				dgrid.x=635 + i * dgrid.width;

				this.addChild(dgrid);
				this.gridList.push(dgrid);
			}

			var st:int=this.getStateByID(selectId);

			if (st == 1 && Core.me != null && tinfo.lv <= Core.me.info.level) {
				this.accpetBtn.setActive(true, 1, true);
				this.flyBtn.visible=this.bgimg.visible=(tinfo.serverId == 2 || tinfo.serverId == 7)
			} else {
				this.accpetBtn.setActive(false, 0.6, true);
				this.flyBtn.visible=this.bgimg.visible=false;
			}

		}

		public function updateInfo(data:Object):void {
			this.o=data;

			var render:DungeonTZRender;

			for each (render in this.itemsList) {
				if (render != null)
					this.itemList.delFromPane(render);
			}

			this.itemsList.length=0;

			var obj:Object=TableManager.getInstance().getTzActiveAll();
			var o:TTzActiive;
			var i:int=0;
//			var render:DungeonTZRender;

			var oarr:Array=TaskUtil.ChangeObjectToArray(obj);
			oarr.sort(sortOnTime, Array.CASEINSENSITIVE | Array.NUMERIC);

			var week:Array=[];

			for each (o in oarr) {
				if (o != null) {

					week=o.week.replace("7", "0").split(",");

					if (week.indexOf(date.day.toString()) == -1) {
						continue;
					}

					render=new DungeonTZRender();
					render.updateInfo(o);

					render.y=i * render.height;

					this.itemsList.push(render);
					this.itemList.addToPane(render);

					i++;
				}
			}

			this.visible=true;
			this.updateList();

//			UIManager.getInstance().showPanelCallback(WindowEnum.PKCOPY);
		}

		private function sortOnTime(item:TTzActiive, item2:TTzActiive):int {

			var arr:Array=[];
			var arr1:Array=[];

			var arr2:Array=[];
			var arr3:Array=[];

			arr=item.time.split("|");
			arr1=arr[0].split(":");

			arr3=item2.time.split("|");
			arr2=arr3[0].split(":");

			date1=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);
			date2=new Date(date.fullYear, date.month, date.date, arr2[0], arr2[1], arr2[2]);

			if (date1 < date2)
				return -1;
			else if (date1 == date2)
				return 0;
			else //if (date1 > date2)
				return 1;

		}

		private function updateList():void {

			var render:DungeonTZRender;
			var i:int=0;
			var tinfo:TTzActiive;
			var arr:Array=[];
			var arr1:Array=[];
			var arr2:Array=[];

			this.startBtn.visible=false;

			for each (render in this.itemsList) {
				date.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
				tinfo=TableManager.getInstance().getTzActiveByID(render.id);

				arr=tinfo.time.split("|");
				arr1=arr[0].split(":");
				arr2=arr[1].split(":");

				date1=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);
				date2=new Date(date.fullYear, date.month, date.date, arr2[0], arr2[1], arr2[2]);

				if (date >= date1 && date < date2) {

					if (this.getStateByID(render.id) == 1) {

						if (this.selectId == -1)
							render.exeClick();

						if (Core.me == null || tinfo.lv > Core.me.info.level) {
							continue;
						}

						render.updateState(1);

						if (tinfo.btn != "") {

							if (this.startId != render.id)
								this.startBtn.updataBmd("ui/tz/" + tinfo.btn);

							this.startBtn.visible=true;

							this.startId=render.id;
							this.clientId=tinfo.clientId;
						}

					} else
						render.updateState(2);


					switch (MapInfoManager.getInstance().type) {
						case SceneEnum.SCENE_TYPE_SGLX:
//							if (date.time + 30000 == date2.time)
//								NoticeManager.getInstance().countdown(4409, 30);
							break;
						case SceneEnum.SCENE_TYPE_RQCJ:
							if (date.time + 30000 == date2.time)
								NoticeManager.getInstance().countdown(4409, 30);
							break;
						case SceneEnum.SCENE_TYPE_LXTB:
							if (date.time + 30000 == date2.time)
								NoticeManager.getInstance().countdown(4409, 30);
							break;
						case SceneEnum.SCENE_TYPE_BWBLT:
							if (date.time + 30000 == date2.time)
								NoticeManager.getInstance().countdown(4409, 30);
							break;
					}

				} else if (date < date1)
					render.updateState(0);
				else if (date > date2)
					render.updateState(2);
			}

		}

		private function getStateByID(id:int):int {
			if (this.o == null)
				return -1;

			for (var i:int=0; i < this.o.actl.length; i++) {
				if (this.o.actl[i].actid == id)
					return this.o.actl[i].state;
			}

			return -1;
		}

//		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
//			super.show(toTop, $layer, toCenter);
//
//
//			GuideManager.getInstance().removeGuide(8);
//		}


//		override public function sendOpenPanelProtocol(... parameters):void {
//			this.dataModel=parameters;
//
//			Cmd_Act.cmActInit();
//		}




		public function setTime(t:int):void {
			this.currentDateTime=t;
		}

		public function resise():void {
//			this.x=(UIEnum.WIDTH - this.width) / 2;
//			this.y=(UIEnum.HEIGHT - this.height) / 2;

			this.startBtn.x=(UIEnum.WIDTH - this.startBtn.width) / 2;
			this.startBtn.y=UIEnum.HEIGHT - this.startBtn.height - 200;

			this.timerLbl.x=(UIEnum.WIDTH - this.timerLbl.width) - 120;
			this.timerLbl.y=6;
		}

		public function setHidBtn(v:Boolean):void {



		}

		override public function get height():Number {
			return 482;
		}

//		override public function hide():void {
//			super.hide();

//			TimerManager.getInstance().remove(exePkCopyTime);
//		}

	}
}

package com.leyou.ui.pkCopy {

	import com.ace.config.Core;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Act;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Stime;
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

		private var startBtnArr:Array=[];

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

		private var startIdArr:Array=[];
		private var clientIdArr:Array=[];

		private var tzId:int=-1;

		private var scenesType:int;

		private var o:Object;

		private var tzBar:TzBar;

		private var currentSpaceTime:int=0;

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

			var startBtn:ImgButton;

			for (var i:int=0; i < 10; i++) {
				startBtn=new ImgButton("ui/tz/tz_btn_sglx.png");
				LayerManager.getInstance().windowLayer.addChild(startBtn);

				this.startBtnArr.push(startBtn);

				startBtn.visible=false;
				startBtn.addEventListener(MouseEvent.CLICK, onStartClick);
			}

			this.timerLbl=new Label();
			LayerManager.getInstance().windowLayer.addChild(this.timerLbl);
			this.timerLbl.width=150;

			this.timerLbl.x=(UIEnum.WIDTH - 150) - 80;
			this.timerLbl.y=6;

			this.timerLbl.visible=false;

			Cmd_Stime.cmRequestTime();
			TimerManager.getInstance().add(exePkCopyTime);

			this.tzBar=new TzBar();
			LayerManager.getInstance().mainLayer.addChildAt(this.tzBar, 0);

			this.tzBar.hide();
			this.tzBar.x=(UIEnum.WIDTH - 150) - 80;
			this.tzBar.y=80;

			this.x=0;
			this.y=1;
		}

		private function onStartClick(e:MouseEvent):void {

			if (MapInfoManager.getInstance().type == SceneEnum.SCENE_TYPE_PTCJ) {
				if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYPANEL))
					UIManager.getInstance().creatWindow(WindowEnum.PKCOPYPANEL);

				UIManager.getInstance().pkCopyPanel.updateInfo({actid: startIdArr[this.startBtnArr.indexOf(e.target)]});
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

			if (this.selectId != -1) {
				if (this.selectId == 25) {
					UILayoutManager.getInstance().show_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.3, UIManager.getInstance().teamCopyWnd.setTabIndex, [2]);
				} else if (this.selectId == 26 || this.selectId == 27) {
					UILayoutManager.getInstance().show_II(WindowEnum.DUNGEON_TEAM);
					TweenLite.delayedCall(0.3, UIManager.getInstance().teamCopyWnd.setTabIndex, [4]);
				} else
					Cmd_Act.cmActNowAccept(selectId);
			}
		}

		private function exePkCopyTime(_i:int):void {

			this.timerLbl.htmlText="<font color='#ffffff' size='14'>" + TimeUtil.getTimeToString(date) + "</font>";
			this.timerLbl.textColor=0xffffff;

			this.timerLbl.x=(UIEnum.WIDTH - this.timerLbl.width) - 120;
			this.timerLbl.y=6;

			this.currentSpaceTime=_i;

			this.updateList();

//			trace(MapInfoManager.getInstance().type, this.clientId)

			for (var i:int=0; i < this.clientIdArr.length; i++) {
				if (MapInfoManager.getInstance() != null && MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ && MapInfoManager.getInstance().type == this.clientIdArr[i]) {
					this.startBtnArr[i].visible=false;
				}

				if (int(MapInfoManager.getInstance().sceneId) == 110 && this.clientIdArr[i] == 13) {
					this.startBtnArr[i].visible=false;
				}
			}


			this.resise();

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
			if (Core.me == null || Core.me.info == null)
				return;

			this.timerLbl.visible=true;
			this.o=data;

			var render:DungeonTZRender;

			for each (render in this.itemsList) {
				if (render != null)
					this.itemList.delFromPane(render);
			}

			this.itemsList.length=0;

			var obj:Object=TableManager.getInstance().getTzActiveAll();
			var oinfo:TTzActiive;
			var i:int=0;
//			var render:DungeonTZRender;

			var oarr:Array=TaskUtil.ChangeObjectToArray(obj);
			oarr.sort(sortOnTime, Array.CASEINSENSITIVE | Array.NUMERIC);

			var week:Array=[];

			for each (oinfo in oarr) {
				if (oinfo != null) {

					week=oinfo.week.replace("7", "0").split(",");

					if (week.indexOf(date.day.toString()) == -1) {
						continue;
					}

					render=new DungeonTZRender();
					render.updateInfo(oinfo);

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


			/**
			 * 时间顺序排序
			 * */
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


		/**
		* 开启时间排序
			arr=item.time.split("|");
			arr1=arr[0].split(":");
			arr2=arr[1].split(":");

 * date.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
*
date1=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);
date2=new Date(date.fullYear, date.month, date.date, arr2[0], arr2[1], arr2[2]);

if (date >= date1 && date < date2) {
return -1;
} else if (date < date1) {
		return 0;
			} else if (date > date2)
				return 1;

			return 1;
			   **/
		}

		private function updateList():void {

			var render:DungeonTZRender;
			var i:int=0;
			var okopen:Boolean=false;
			var tinfo:TTzActiive;
			var arr:Array=[];
			var arr1:Array=[];
			var arr2:Array=[];

			this.tzId=-1;

//			this.startBtn.visible=false;

			this.setStartBtnVisible(10);
			this.startIdArr=[];
			this.clientIdArr=[];

			var sid:int=0;

			for (i=0; i < this.itemsList.length; i++) {
				render=this.itemsList[i] as DungeonTZRender;

				date.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
				tinfo=TableManager.getInstance().getTzActiveByID(render.id);

				arr=tinfo.time.split("|");
				arr1=arr[0].split(":");
				arr2=arr[1].split(":");

				date1=new Date(date.fullYear, date.month, date.date, arr1[0], arr1[1], arr1[2]);
				date2=new Date(date.fullYear, date.month, date.date, arr2[0], arr2[1], arr2[2]);

				if (date >= date1 && date < date2) {

					if (render.id != 1)
						okopen=true;

					if (Core.me == null || tinfo.lv > Core.me.info.level) {
						continue;
					}

					if (this.getStateByID(render.id) == 1) {

						if (this.selectId == -1)
							render.exeClick();

						render.updateState(1);

						if (tinfo.btn != "") {

							if (this.startIdArr[sid] != render.id)
								this.startBtnArr[sid].updataBmd("ui/tz/" + tinfo.btn);

							this.startBtnArr[sid].visible=true;

							this.startIdArr[sid]=render.id;
							this.clientIdArr[sid]=tinfo.clientId;

							sid++;
						}

					} else {
						render.updateState(2);

//						if (this.getStateByID(render.id) == 2) {
//
//							if (render.id != 1)
//								okopen=true;
//						}
					}

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

				} else if (date < date1) {
					render.updateState(0);

					if (this.tzId == -1)
						this.tzId=i;
				} else if (date > date2)
					render.updateState(2);

			}

//			if (this.currentSpaceTime % 10 == 0) {
			var tmp1:Vector.<DungeonTZRender>=this.itemsList.filter(function(item:DungeonTZRender, i:int, vec:Vector.<DungeonTZRender>):Boolean {
				if (item.state == -1)
					return true;
				return false;
			});

			var tmp2:Vector.<DungeonTZRender>=this.itemsList.filter(function(item:DungeonTZRender, i:int, vec:Vector.<DungeonTZRender>):Boolean {
				if (item.state == 0)
					return true;
				return false;
			});

			var tmp3:Vector.<DungeonTZRender>=this.itemsList.filter(function(item:DungeonTZRender, i:int, vec:Vector.<DungeonTZRender>):Boolean {
				if (item.state == 1)
					return true;
				return false;
			});

			tmp1.sort(sortOnTimeII);
			tmp2.sort(sortOnTimeII);
			tmp3.sort(sortOnTimeII);

			var tmp4:Vector.<DungeonTZRender>=tmp1.concat(tmp2, tmp3);

			for (i=0; i < tmp4.length; i++) {
				render=tmp4[i] as DungeonTZRender;
				render.y=i * render.height;
			}
//			}

			if (okopen || date > date2 || this.tzId == -1) {
				this.tzBar.hide();
			} else {

				var infot:TTzActiive=TableManager.getInstance().getTzActiveByID(this.itemsList[this.tzId].id);
				if (Core.me == null || infot.lv > Core.me.info.level) {
					this.tzBar.hide();
					return;
				}

				this.tzBar.updateInfo(this.itemsList[this.tzId].id, this.itemsList[this.tzId - 1].id, this.itemsList[1].id);
			}

		}

		private function sortOnTimeII(item:DungeonTZRender, item1:DungeonTZRender):int {

			var arr:Array=[];
			var arr1:Array=[];

			var arr2:Array=[];
			var arr3:Array=[];

			var tinfo1:TTzActiive=TableManager.getInstance().getTzActiveByID(item.id);
			var tinfo2:TTzActiive=TableManager.getInstance().getTzActiveByID(item1.id);

			arr=tinfo1.time.split("|");
			arr1=arr[0].split(":");

			arr3=tinfo2.time.split("|");
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

		private function setStartBtnVisible(num:int):void {

			for (var i:int=0; i < num; i++) {
				this.startBtnArr[i].visible=false;
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

			for (var j:int=0; j < 10; j++) {
				if (!this.startBtnArr[j].visible) {
					break;
				}
			}


			for (var i:int=0; i < 10; i++) {
				if (this.startBtnArr[i].visible) {
					this.startBtnArr[i].x=(UIEnum.WIDTH - j * this.startBtnArr[i].width) / 2 + i * this.startBtnArr[i].width;
					this.startBtnArr[i].y=UIEnum.HEIGHT - this.startBtnArr[i].height - 200;
				}
			}

			this.timerLbl.x=(UIEnum.WIDTH - this.timerLbl.width) - 120;
			this.timerLbl.y=6;

			this.tzBar.x=(UIEnum.WIDTH - 202) - 30;
			this.tzBar.y=100;
		}

		public function setHidBtn(v:Boolean):void {



		}

		override public function get height():Number {
			return 482;
		}

		public function setTzBarState(v:Boolean):void {
			this.tzBar.setScalePanel(v);
		}

//		override public function hide():void {
//			super.hide();

//			TimerManager.getInstance().remove(exePkCopyTime);
//		}

	}
}

package com.leyou.ui.title {

	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.accordion.Accordion;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Nck;
	import com.leyou.ui.title.child.TitleBar;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class TitleWnd extends AutoSprite implements IMenu {

		private var previewTitleLbl:Label;
		private var titleNameLbl:Label;
		private var descLbl:TextArea;
		private var totalFightLbl:Label;
		private var fightKeyLbl:Label;
		private var hidCb:CheckBox;
		private var desc1Lbl:TextArea;
		private var startBtn:NormalButton;

		private var progressLbl:Label;
		private var progressImg:Image;
		private var progressBg:Image;

//		private var fightBD:Bitmap;
		private var rollPower:RollNumWidget;

		private var properNameArr:Vector.<Label>;
		private var properkeyArr:Vector.<Label>;

		private var titleTree:Accordion;
		private var titleBarList:Array=[];

		private var selectRender:TitleBar;

		/**
		 *ID
		 */
		private var selectId:int=-1;

		/**
		 *服务器时间差
		 */
		public var serverDiffTime:int=-1

		private var currentTime:int=0;

		private var pos:int=-1;

		public function TitleWnd() {
			super(LibManager.getInstance().getXML("config/ui/title/titleWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.properNameArr=new Vector.<Label>;
			this.properkeyArr=new Vector.<Label>;

//			this.previewTitleLbl=this.getUIbyID("previewTitleLbl") as Label;
//			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
//			this.totalFightLbl=this.getUIbyID("totalFightLbl") as Label;

			this.fightKeyLbl=this.getUIbyID("fightKeyLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as TextArea;
			this.desc1Lbl=this.getUIbyID("desc1Lbl") as TextArea;
			this.startBtn=this.getUIbyID("startBtn") as NormalButton;

			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.progressBg=this.getUIbyID("progressBg") as Image;

//			this.fightBD=new Bitmap();
//			this.addChild(this.fightBD);.
//
//			this.fightBD.x=this.fightKeyLbl.x;
//			this.fightBD.y=this.fightKeyLbl.y + 10;

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=this.fightKeyLbl.x + 30;
			this.rollPower.y=this.fightKeyLbl.y + 10;

//			this.rollPower.visibleOfBg=false;
			this.rollPower.alignCenter();

			this.desc1Lbl.setHtmlText(TableManager.getInstance().getSystemNotice(1403).content);
			this.desc1Lbl.visibleOfBg=false;
			this.descLbl.visibleOfBg=false;

			this.properNameArr.push(this.getUIbyID("proName0Lbl") as Label);
			this.properNameArr.push(this.getUIbyID("proName1Lbl") as Label);
			this.properNameArr.push(this.getUIbyID("proName2Lbl") as Label);
			this.properNameArr.push(this.getUIbyID("proName3Lbl") as Label);

			this.properkeyArr.push(this.getUIbyID("proKey0Lbl") as Label);
			this.properkeyArr.push(this.getUIbyID("proKey1Lbl") as Label);
			this.properkeyArr.push(this.getUIbyID("proKey2Lbl") as Label);
			this.properkeyArr.push(this.getUIbyID("proKey3Lbl") as Label);

//			this.hidCb.addEventListener(MouseEvent.CLICK, onCheckBoxClick);

			this.titleTree=new Accordion(267, 405);
			this.addChild(this.titleTree);
			this.titleTree.y=1;

			var obj:Object=TableManager.getInstance().getTitleAllData();

			var render:TitleBar;
			var key:int=TableManager.getInstance().getTitleAllDataLen();
			var item:TTitle;

			var data1:Array=[];
			var data2:Array=[];
			var data3:Array=[];
			var data4:Array=[];

			var i:int=0;
			while (i <= key) {

				item=obj[i];
				if (item != null) {

					render=new TitleBar();
					render.updateInfo(item);

					this.titleBarList[item.titleId]=render;

					switch (item.type) {
						case 0:
							data1.push(render);
							break;
						case 1:
							data2.push(render);
							break;
						case 2:
							data3.push(render);
							break;
						case 3:
//							data2.push(render);
//							render.hide();
							break;
					}
				}

				i++;
			}


			this.titleTree.addItem(PropUtils.getStringById(1954), "", data1);
			this.titleTree.addItem(PropUtils.getStringById(1955), "", data2);
			this.titleTree.addItem(PropUtils.getStringById(1956), "", data3);

			this.titleTree.addEventListener(MouseEvent.CLICK, onClick);
			this.startBtn.addEventListener(MouseEvent.CLICK, onstartClick);

			this.startBtn.setActive(false, .6, true);
			this.y=1;
			this.x=-12;

			this.startBtn.visible=false;

			this.setProgressVisiable(false);
		}

		private function onstartClick(e:MouseEvent):void {
			if (this.selectId != -1) {

				this.selectRender.isclick=false;
				this.selectRender.BgState=false;
				this.selectRender.setState(false);

				if (this.startBtn.text.indexOf(PropUtils.getStringById(1957)) > -1) {
					Cmd_Nck.cm_NckUninstall(this.selectId);
				} else
					Cmd_Nck.cm_NckStart(this.selectId);

			}

		}

		private function onClick(e:MouseEvent):void {

			e.stopImmediatePropagation();

			if (e.target is TitleBar) {
				this.updateSelectData(e.target as TitleBar);
			}

		}

		public function updateSelectData(render:TitleBar):void {
			var tinfo:TTitle=TableManager.getInstance().getTitleByID(this.titleBarList.indexOf(render));
			if (tinfo == null)
				return;

			this.updateTitleProgress(tinfo);

			pos=0;
			for (var i:int=0; i < 4; i++) {
				if (i < 3 && tinfo["attribute" + (i + 1)] > 0) {
					this.properNameArr[i].text="      "+PropUtils.propArr[int(tinfo["attribute" + (i + 1)]) - 1] + ":";

//					if (int(tinfo["attribute" + (i + 1)]) - 1 < 7){
//						this.properkeyArr[i].text="" + tinfo["value" + (i + 1)];
//						this.properkeyArr[i].textColor=0xffffff;
//					}else{
					this.properkeyArr[i].text="+" + tinfo["value" + (i + 1)];
					this.properkeyArr[i].textColor=0x00ff00;
//					}

					this.properNameArr[i].setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(tinfo["attribute" + (i + 1)])).content);
					pos++;
				} else {
					this.properNameArr[i].text="";
					this.properkeyArr[i].text="";
				}
			}

			this.selectId=tinfo.titleId;
			this.descLbl.setText(tinfo.des);

			this.updateClickByType(render.getType());

			render.isclick=true;
			render.BgState=true;

			this.selectRender=render;

			if (render.getState()) {
				this.startBtn.text=PropUtils.getStringById(1957);
				this.startBtn.setToolTip(TableManager.getInstance().getSystemNotice(1402).content);
			} else {
				this.startBtn.text=PropUtils.getStringById(1958);
				this.startBtn.setToolTip(TableManager.getInstance().getSystemNotice(1401).content);
			}

			this.currentTime=0;
			TimerManager.getInstance().removeBykey("nickTime");

			//如果未激活
			if (!render.mouseChildren) {
				this.startBtn.setActive(false, .6, true);
				return;
			}

			this.startBtn.setActive(true, 1, true);

			if (tinfo.time > 0) {
				Cmd_Nck.cm_NckLastTime(tinfo.titleId);
			}

			//				var arr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
			//				if (!render.getState())
			//					arr.push(new MenuInfo("启用", 1));
			//				else
			//					arr.push(new MenuInfo("取消", 2));
			//
			//				MenuManager.getInstance().show(arr, this, this.localToGlobal(new Point(this.mouseX, this.mouseY)));

		}

		public function onMenuClick(i:int):void {

			switch (i) {
				case 1:
					Cmd_Nck.cm_NckStart(this.selectId);
					break;
				case 2:
					Cmd_Nck.cm_NckUninstall(this.selectId);
					break;
			}

		}

		private function updateTitleProgress(tinfo:TTitle):void {

			switch (int(tinfo.factor)) {
				case 1:

					if (Core.me.info.level < int(tinfo.factorNum))
						this.updateProgressUi(Core.me.info.level, int(tinfo.factorNum));
					else
						this.setProgressVisiable(false);

					break;
				case 3:
					this.setProgressVisiable(false);
					Cmd_Nck.cm_NckProgress(tinfo.titleId);
					break;
				case 5:

					if (MyInfoManager.getInstance().getRoleEquipNumByQuilty(int(tinfo.factorNum)) < 14)
						this.updateProgressUi(MyInfoManager.getInstance().getRoleEquipNumByQuilty(int(tinfo.factorNum)), 14);
					else
						this.setProgressVisiable(false);

					break;
				case 7:

					if (UIManager.getInstance().roleWnd.mountLv() < int(tinfo.factorNum))
						this.updateProgressUi(UIManager.getInstance().roleWnd.mountLv(), int(tinfo.factorNum));
					else
						this.setProgressVisiable(false);

					break;
				case 8:

					if (UIManager.getInstance().roleWnd.wingLv() < int(tinfo.factorNum))
						this.updateProgressUi(UIManager.getInstance().roleWnd.wingLv(), int(tinfo.factorNum));
					else
						this.setProgressVisiable(false);

					break;
				case 9:
					this.setProgressVisiable(false);
					Cmd_Nck.cm_NckProgress(tinfo.titleId);
					break;
				case 14:

					if (MyInfoManager.getInstance().getRoleEquipNumByLv(int(tinfo.factorNum)) < 14)
						this.updateProgressUi(MyInfoManager.getInstance().getRoleEquipNumByLv(int(tinfo.factorNum)), 14);
					else
						this.setProgressVisiable(false);

					break;
				default:
					this.setProgressVisiable(false);
			}

		}

		private function updateProgressUi(cur:int, target:int):void {
			this.setProgressVisiable(true);
			this.progressBg.setWH(160, 20);
			this.progressImg.setWH((Number(cur / target) > 1 ? 1 : Number(cur / target)) * 160, 11);
			this.progressLbl.text=cur + "/" + target;
		}

		public function updateProgress(obj:Object):void {

			if (this.selectId != obj.id) {
				return;
			}

			var tinfo:TTitle=TableManager.getInstance().getTitleByID(obj.id);

			switch (int(tinfo.factor)) {
				case 1:

					break;
				case 3:
					this.updateProgressUi(obj.count, int(tinfo.factorNum));
					break;
				case 5:

					break;
				case 7:

					break;
				case 8:

					break;
				case 9:
					this.updateProgressUi(obj.count, int(tinfo.factorNum));
					break;
			}

		}


		public function updateInfo(o:Object):void {

			//激活的
			this.updateActiveList(o.mlist);

			//世界称号
			if (o.hasOwnProperty("wlist"))
				this.updateActiveList(o.wlist, false);

			if (o.hasOwnProperty("time")) {
				var d:Date=new Date();
				this.serverDiffTime=(d.time / 1000 - int(o.time));
			}

			//正在使用
			var obj:Object=o.curNckid;
			var render:TitleBar;
			var key:String;
			for (key in obj) {

				if (obj[key] != null) {

					if (key.indexOf("t0") > -1) {

						render=this.titleBarList[obj[key]];
						render.setState(true);
//						render.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						this.updateSelectData(render);
					} else if (key.indexOf("t1") > -1) {

						render=this.titleBarList[obj[key]];
						render.setState(true);
					} else if (key.indexOf("t2") > -1) {

						for (var i:int=0; i < obj[key].length; i++) {
							render=this.titleBarList[obj[key][i]];
							render.setState(true);
						}

					}

				}

			}

			if (o.hasOwnProperty("fight")) {
				if (this.rollPower.number != o.fight) {
					this.rollPower.rollToNum(o.fight);
				}

				this.rollPower.x=(300 - this.rollPower.width) >> 1;
			}
		}

		/**
		 *更新激活列表
		 * @param obj
		 *
		 */
		public function updateActiveList(obj:Object, m:Boolean=true):void {
			var render:TitleBar;
			var key:String;
			var item:Array;

			for (key in obj) {

				item=obj[key];
				if (item != null) {
					render=this.titleBarList[obj[key][0]];
					render.updateData(item);

					if (m && key == "0")
						this.updateSelectData(render);

					if (render.parent == null) {
						this.titleTree.getItem(1).addItemUnshift(render);
					}

				}
			}

		}


		/**
		 * 更新开启格子
		 * @param obj
		 *
		 */
		public function updateStartNick(o:Object):void {
			var render:TitleBar=this.titleBarList[o.curNckid];

			if (render.getType() != 2)
				this.updateActiveByType(render.getType());

			render.setState(true);
			render.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			render.isclick=false;
		}

		public function updateLastTime(o:Object):void {

			this.currentTime=o.time;
			this.properNameArr[this.pos].text=PropUtils.getStringById(1941)+":";
			this.properkeyArr[this.pos].text="" + TimeUtil.getIntToDateTime(currentTime);

			TimerManager.getInstance().add(exeTimer, "nickTime");

//			var render:TitleBar;
//			
//			for each (render in this.titleBarList) {
//				if (render.getType() == 1 || render.getType() == 2) {
//					 if(render.getTid()==o.id)
//						 return render;
//				}
//			}

		}

		private function exeTimer(i:int):void {

			if (currentTime - i > 0)
				properkeyArr[pos].text="" + TimeUtil.getIntToDateTime(currentTime - i);
			else {
				currentTime=0;
				TimerManager.getInstance().removeBykey("nickTime");

				properNameArr[pos].text="";
				properNameArr[pos].setToolTip("");
				properkeyArr[pos].text="";

				startBtn.setActive(false, .6, true);
			}


		}

		/**
		 * 取消称号
		 * @param id
		 *
		 */
		public function updateUninstall(o:Object):void {
			var render:TitleBar=this.titleBarList[o.curNckid];

			if (render.getType() != 2)
				this.updateActiveByType(render.getType());

			this.startBtn.text=PropUtils.getStringById(1958);
			this.startBtn.setToolTip(TableManager.getInstance().getSystemNotice(1401).content);

			render.setState(false);
		}

		private function updateClickByType(type:int):void {
			var render:TitleBar;

			for each (render in this.titleBarList) {
				if (render.getType() == type) {
					render.isclick=false;
					render.BgState=false;
				}
			}

		}

		private function updateActiveByType(type:int):void {
			var render:TitleBar;

			for each (render in this.titleBarList) {
				if (render.getType() == type) {
					render.setState(false);
				}
			}

		}

		private function setProgressVisiable(v:Boolean):void {
			this.progressBg.visible=v;
			this.progressImg.visible=v;
			this.progressLbl.visible=v;
		}

		private function onItemClick(e:MouseEvent):void {
//			trace("eee", e.target);
		}

	}
}

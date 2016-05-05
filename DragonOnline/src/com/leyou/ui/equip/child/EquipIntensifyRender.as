package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.cmd.Cmd_Equip;
	
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class EquipIntensifyRender extends AutoSprite {

		private var descLbl:Label;
		private var ruleLbl:Label;

//		private var confirmBtn:TaskTrackBtn;
		private var confirmBtn:ImgButton;
		private var equipgrid:EquipStrengGrid;

		private var timecount:int=0;
		private var succEffect:SwfLoader;
		private var succeffSwf:SwfLoader;
		private var starEffect:SwfLoader;
		private var startEffect:SwfLoader;

		/**
		 *基础数据
		 */
		private var infodata:Object;

		private var autoStrengid:int=0;


		private var lvStarArr:Array=[];

		private var intensifyBar:EquipIntensifyBar;

		public function EquipIntensifyRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipIntensifyRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.succeffSwf=this.getUIbyID("succeffSwf") as SwfLoader;
			this.succeffSwf.visible=false;
			
//			this.confirmBtn=new TaskTrackBtn(); //this.getUIbyID("confirmBtn") as ImgButton;
			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
//			this.confirmBtn.updateIcons("ui/equip/btn_qh.jpg");
			this.confirmBtn.mouseChildren=this.confirmBtn.mouseEnabled=true;
//			this.addChild(this.confirmBtn);

//			this.confirmBtn.x=60.5;
//			this.confirmBtn.y=385;

			this.equipgrid=new EquipStrengGrid();
			this.addChild(this.equipgrid);

			this.equipgrid.dataId=1;

			this.equipgrid.x=124;
			this.equipgrid.y=80;

			this.equipgrid.setSize(60, 60);
			this.equipgrid.selectState();

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);

			this.intensifyBar=new EquipIntensifyBar();
			this.addChild(this.intensifyBar);
			this.intensifyBar.x=27;
			this.intensifyBar.y=199;

			var img:Image;
			for (var i:int=0; i < 16; i++) {
				img=this.getUIbyID("starImg" + i) as Image;
//				img.visible=false;
				this.lvStarArr.push(img);
			}
			
			this.succEffect=new SwfLoader(99977, null, false);
			this.addChild(this.succEffect);
			this.succEffect.x=160;
			this.succEffect.y=70;

			this.succEffect.visible=false;
			this.intensifyBar.visible=false;

			this.starEffect=new SwfLoader(99904);
			this.addChild(this.starEffect);
			this.starEffect.x=135;
			this.starEffect.y=80;

			this.starEffect.visible=false;

			this.startEffect=new SwfLoader(99901);
			this.addChild(this.startEffect);
			this.startEffect.x=125;
			this.startEffect.y=10;

			this.startEffect.visible=false;

			this.addChild(this.succeffSwf);
			
			this.confirmBtn.setActive(false, .6, true);
			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2407).content);

//			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(2408).content;
			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(2408).content);

			this.x=60;
			this.y=1;
		}

		private function onClick(e:MouseEvent):void {

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.EQUIP+"");
			
			if (autoStrengid > 0) {
				clearInterval(autoStrengid);
				autoStrengid=0;
				this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
				this.intensifyBar.targetLv=0;
				this.intensifyBar.setAutoEnbale(true);
				this.equipgrid.setEnable(true);

				UIManager.getInstance().equipWnd.BagRender.mouseChildren=true;
				return;
			}

//			if (!this.allowStrength())
//				return;

			if (!this.startEffect.isLoaded)
				return;

			if (!this.equipgrid.isEmpty) {

				this.equipgrid.setEnable(false);

				if (this.intensifyBar.autoSuccess) {
					this.intensifyBar.setAutoEnbale(false);
					this.confirmBtn.updataBmd("ui/equip/btn_qx.jpg");
					autoStrengid=setInterval(sendStrenth, 2000);
					sendStrenth();
				} else {
					this.confirmBtn.setActive(false, .6, true);
					sendStrenth();
				}

			}


		}

		/**
		 * 开始强化
		 */
		private function sendStrenth():void {

			if (!this.allowStrength())
				return;

			this.startEffect.visible=true;

			var pos:int=-1;
			var type:int=-1;

			if (this.equipgrid.data.hasOwnProperty("pos")) {

				if (this.equipgrid.data.num == 0) {
					pos=equipgrid.data.info.subclassid - 13;
					type=40;
				} else {
					pos=equipgrid.data.pos;
					type=1;
				}
			} else {
				pos=equipgrid.data.position;
				type=3;
			}

			UIManager.getInstance().equipWnd.BagRender.mouseChildren=false;

			if (MyInfoManager.getInstance().getBagItemNumByName(this.intensifyBar.needItems()[0]) < int(this.intensifyBar.needItems()[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(this.intensifyBar.getitems()[1], this.intensifyBar.getitems()[0])) {
				startEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					startEffect.visible=false;
					Cmd_Equip.cm_EquipStrengthen(type, pos, (UIManager.getInstance().quickBuyWnd.getCost(intensifyBar.getitems()[1], intensifyBar.getitems()[0]) == 0 ? 2 : 1));
				});
			} else {
				startEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					startEffect.visible=false;
					Cmd_Equip.cm_EquipStrengthen(type, pos);
				});
			}

		}

		public function changeState(v:int):void {

			if (v == 0) {

				if (autoStrengid > 0) {
					clearInterval(autoStrengid);
					autoStrengid=0;
					this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
					this.intensifyBar.targetLv=0;
				}

				this.equipgrid.setEnable(true);
				this.intensifyBar.setAutoEnbale(true);
				UIManager.getInstance().equipWnd.BagRender.mouseChildren=true;
				this.confirmBtn.setToolTip("");
				this.confirmBtn.setActive(true, 1, true);
			}

		}

		private function allowStrength():Boolean {

			if (this.infodata == null)
				return false;

			var xml:XML=LibManager.getInstance().getXML("config/table/strengthen.xml");
			var tmp1Xml:XML=xml.strengthen[this.intensifyBar.currentLv];

			var iteminfo:TItemInfo=TableManager.getInstance().getItemInfo(tmp1Xml.@item);

			if (UIManager.getInstance().backpackWnd.jb < this.intensifyBar.needGoldNum || this.intensifyBar.buyItems()) { // || MyInfoManager.getInstance().getBagItemNumByName(iteminfo.name) < int(tmp1Xml.@itemNum)) {

				if (UIManager.getInstance().backpackWnd.jb < this.intensifyBar.needGoldNum)
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2405));
				else if (MyInfoManager.getInstance().getBagItemNumById(int(tmp1Xml.@item)) < int(tmp1Xml.@itemNum))
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2404));
				else if (MyInfoManager.getInstance().getBagItemNumById(int(tmp1Xml.@item2)) < int(tmp1Xml.@itemNum))
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2404));

				if (autoStrengid > 0) {
					clearInterval(autoStrengid);
					autoStrengid=0;
					this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
					this.intensifyBar.targetLv=0;
				}

				this.intensifyBar.setAutoEnbale(true);
				this.equipgrid.setEnable(true);
				this.confirmBtn.setToolTip("");
				this.confirmBtn.setActive(true, 1, true);
				return false;
			}

			if (this.infodata.tips.qh >= int(this.infodata.info.maxlevel)) {

				if (autoStrengid > 0) {
					clearInterval(autoStrengid);
					autoStrengid=0;
					this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
					this.intensifyBar.targetLv=0;
				}

				this.equipgrid.setEnable(true);
				this.intensifyBar.setAutoEnbale(true);
				this.confirmBtn.setToolTip("");
				this.confirmBtn.setActive(true, 1, true);
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2406));
				return false;
			}

			return true;
		}

		private function onMouseClick(e:MouseEvent):void {

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty)
					return;

				var d:Object=DragManager.getInstance().grid.data;

				if (d == null || !d.hasOwnProperty("tips"))
					return;

				if (d.tips.qh >= int(d.info.maxlevel)) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2406));
					return;
				}

				this.infodata=d;
				this.clearData();

//				this.setStarvisiable(int(this.infodata.info.maxlevel));
//				this.setStarView(this.infodata.tips.qh);
//
//				this.intensifyBar.updateData(this.infodata.tips);
//				this.intensifyBar.visible=false;
//
//				this.confirmBtn.setToolTip("");
//				this.confirmBtn.setActive(true, 1, true);
//				this.descLbl.visible=true;
			}
		}

		/**
		 *	模拟拖拽
		 * @param g
		 *
		 */
		public function setDownItem(g:GridBase):void {

			var d:Object=g.data;
			if (d == null)
				return;

			if (d.tips.qh >= int(d.info.maxlevel)) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2406));
				return;
			}

			this.infodata=d;
			this.clearData();

			this.setStarvisiable(int(this.infodata.info.maxlevel));
			this.setStarView(this.infodata.tips.qh);

			this.equipgrid.updataInfo(d);
			this.intensifyBar.updateData(this.infodata.tips);
			this.intensifyBar.visible=true;

			this.confirmBtn.setToolTip("");
			this.confirmBtn.setActive(true, 1, true);
//			this.descLbl.visible=false;
		}


		/**
		 * 强化完成处理
		 */
		public function updateSuccess(o:Object):void {

			if (this.infodata == null)
				return;

//			function stopplay1():void {
//			succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);
//			}

			function stopplay2():void {
				succEffect.visible=false;
			}
			
			function stopplay3():void {
				succeffSwf.visible=false;
			}

			if (o.re == 0) {

				this.succEffect.visible=true;

				this.succEffect.update(99903);
				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);

				if (autoStrengid == 0) {
					UIManager.getInstance().equipWnd.BagRender.mouseChildren=true;
					this.confirmBtn.setActive(true, 1, true);
					this.confirmBtn.setToolTip("");
				}

			} else {

				this.succeffSwf.visible=true;
				succeffSwf.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay3);
				
				this.succEffect.visible=true;
				this.succEffect.update(99902);
				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, stopplay2);

				SoundManager.getInstance().play(21);

				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");

				//是背包
				if (this.infodata.hasOwnProperty("pos")) {
					if (this.infodata.num == 0) //坐骑装备
						this.infodata=MyInfoManager.getInstance().mountEquipArr[this.infodata.info.subclassid - 13];
					else
						this.infodata=MyInfoManager.getInstance().bagItems[this.infodata.pos];
				} else
					this.infodata=MyInfoManager.getInstance().equips[this.infodata.position];

				this.starEffect.x=this.lvStarArr[this.infodata.tips.qh - 1].x + 5;
				this.starEffect.y=this.lvStarArr[this.infodata.tips.qh - 1].y + 5;

				this.starEffect.visible=true;
				this.starEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					starEffect.visible=false;
				});

				UIManager.getInstance().equipWnd.BagRender.update();

				this.setStarvisiable(int(this.infodata.info.maxlevel));
				this.setStarView(this.infodata.tips.qh);

				if (autoStrengid > 0) {
					if (!this.intensifyBar.autoSuccess || this.infodata.tips.qh == this.intensifyBar.targetLv) {
						clearInterval(autoStrengid);
						this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
						autoStrengid=0;
						this.intensifyBar.targetLv=0;
						this.intensifyBar.setAutoEnbale(true);
						this.equipgrid.setEnable(true);
					}

				} else
					this.equipgrid.setEnable(true);

				this.intensifyBar.visible=true;
				this.intensifyBar.updateData(this.infodata.tips);
				this.equipgrid.updataInfo(this.infodata);


				UIManager.getInstance().equipWnd.BagRender.mouseChildren=true;
			}

		}

		private function setStarView(_i:int):void {

			for (var i:int=0; i < this.lvStarArr.length; i++) {
				if (i < _i) {
					this.lvStarArr[i].updateBmp("ui/tips/icon_xx.png");
				} else {
					this.lvStarArr[i].updateBmp("ui/tips/icon_xxx.png")
				}
			}

		}

		private function setStarvisiable(_i:int):void {
			for (var i:int=0; i < this.lvStarArr.length; i++) {
				if (i < _i)
					this.lvStarArr[i].visible=true;
				else
					this.lvStarArr[i].visible=false;
			}
		}

		public function clearAllData():void {
			this.clearData();
			this.infodata=null;
			if (!this.equipgrid.isEmpty) {
				this.equipgrid.resetGrid();
				this.equipgrid.delItemHandler();
			}

		}

		private function clearData():void {

			this.setStarvisiable(16);
			this.setStarView(16);

//			this.hptxtLbl.text="";
//			this.atttxtLbl.text="";
//
//			this.hp1Lbl.text="";
//			this.att1Lbl.text="";
//
//			this.lv1Lbl.text="";
//			this.lv2Lbl.text="";
//
//			this.hp2Lbl.text="";
//			this.att2Lbl.text="";

//			this.succLbl.text="";
//			this.needGoldLbl.text="";

//			this.needItemLbl.text="";

			if (autoStrengid > 0) {
				clearInterval(autoStrengid);
				this.confirmBtn.updataBmd("ui/equip/btn_qh.jpg");
				autoStrengid=0;
			}

//			this.descLbl.visible=true;
			this.intensifyBar.visible=false;
			this.confirmBtn.setActive(false, .6, true);
			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2407).content);

			this.intensifyBar.targetLv=0;
			this.intensifyBar.setAutoEnbale(true);
			this.intensifyBar.clearData();
		}

	}
}

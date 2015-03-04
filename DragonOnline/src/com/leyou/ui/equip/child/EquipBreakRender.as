package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Equip;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.EffectUtil;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class EquipBreakRender extends AutoSprite {

		private var progressImg:Image;

		private var confirmBtn:ImgButton;

		private var progressSpr:Sprite;
		private var progressLbl:Label;
		private var descLbl:Label;

		private var cb1Lbl:CheckBox;
		private var cb2Lbl:CheckBox;
		private var cb3Lbl:CheckBox;
		private var cb4Lbl:CheckBox;

		private var cbArr:Array=[false, false, false, false, false];
		private var cbUiArr:Array=[];
		private var rectArr:Array=[];

		private var rectLbl:Label;

		private var Biggrid:ShopGrid;

		private var gridList:Vector.<EquipStrengGrid>;
		private var gridPosArr:Array=[];

		private var gridEffectArr:Array=[];

		private var currentExt:int=-1;
		private var oldcurrentExt:int=-1;

		private var tlime:TimelineMax;

		public function EquipBreakRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipBreakRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.progressImg=this.getUIbyID("progressImg") as Image;

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;

			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.rectLbl=this.getUIbyID("rectLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.cb1Lbl=this.getUIbyID("cb1Lbl") as CheckBox;
			this.cb2Lbl=this.getUIbyID("cb2Lbl") as CheckBox;
			this.cb3Lbl=this.getUIbyID("cb3Lbl") as CheckBox;
			this.cb4Lbl=this.getUIbyID("cb4Lbl") as CheckBox;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.cb1Lbl.addEventListener(MouseEvent.CLICK, onClick);
			this.cb2Lbl.addEventListener(MouseEvent.CLICK, onClick);
			this.cb3Lbl.addEventListener(MouseEvent.CLICK, onClick);
			this.cb4Lbl.addEventListener(MouseEvent.CLICK, onClick);

			this.cb1Lbl.setToolTip(TableManager.getInstance().getSystemNotice(2613).content);
			this.cb2Lbl.setToolTip(TableManager.getInstance().getSystemNotice(2613).content);
			this.cb3Lbl.setToolTip(TableManager.getInstance().getSystemNotice(2613).content);
			this.cb4Lbl.setToolTip(TableManager.getInstance().getSystemNotice(2613).content);

			this.cbUiArr[1]=this.cb1Lbl;
			this.cbUiArr[2]=this.cb2Lbl;
			this.cbUiArr[3]=this.cb3Lbl;
			this.cbUiArr[4]=this.cb4Lbl;

			this.cb1Lbl.text="       ";
			this.cb2Lbl.text="       ";
			this.cb3Lbl.text="       ";
			this.cb4Lbl.text="       ";

//			this.cb1Lbl.turnOn();
//			this.cb2Lbl.turnOff();
//			this.cb3Lbl.turnOff();
//			this.cb4Lbl.turnOff();

//			this.cbArr[1]=true;
//			this.cbArr[2]=false;
//			this.cbArr[3]=false;
//			this.cbArr[4]=false;

			this.descLbl.mouseEnabled=true;
			this.descLbl.addEventListener(MouseEvent.MOUSE_OVER, onDescMouseOver)
			this.descLbl.addEventListener(MouseEvent.MOUSE_OUT, onDescMouseOut)

			this.gridList=new Vector.<EquipStrengGrid>();

			var g:EquipStrengGrid;
			var costEffect:SwfLoader;

			for (var i:int=0; i < 10; i++) {
				g=new EquipStrengGrid();

				g.x=35 + (i % 5) * 58;
				g.y=35 + Math.floor(i / 5) * 60;

				g.selectState();
				g.dataId=5;

				this.addChild(g);
				this.gridList.push(g);

				g.updataInfo(null);

				costEffect=new SwfLoader(99907);
				this.addChild(costEffect);
				costEffect.x=g.x;
				costEffect.y=g.y;

				costEffect.visible=false;

				this.gridEffectArr.push(costEffect);
			}

			this.Biggrid=new ShopGrid()
			this.Biggrid.updataInfo(TableManager.getInstance().getItemInfo(ConfigEnum.equip19));

			this.Biggrid.type=2;
			this.addChild(this.Biggrid);

			this.Biggrid.x=134;
			this.Biggrid.y=212;

//			this.progressSpr=new Sprite();
//			this.progressSpr.graphics.beginFill(0xff0000);
//			this.progressSpr.graphics.drawRect(0, 0, 248, 2);
//			this.progressSpr.graphics.endFill();
//
//			this.addChild(this.progressSpr);
//
//			this.progressSpr.x=this.progressImg.x;
//			this.progressSpr.y=this.progressImg.y;
//
//			this.progressSpr.alpha=0;

			this.y=1;
			this.x=-10;
		}


		private function onDescMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(2612).content, new Point(e.stageX, e.stageY));
		}

		private function onDescMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(2614).content, onConfirm, null, false, "equipBreakConfirm");
					break;
				case "cb1Lbl":
					this.cbArr[1]=this.cb1Lbl.isOn
					this.updateList(1);
					break;
				case "cb2Lbl":
					this.cbArr[2]=this.cb2Lbl.isOn
					this.updateList(2);
					break;
				case "cb3Lbl":
					this.cbArr[3]=this.cb3Lbl.isOn
					this.updateList(3);
					break;
				case "cb4Lbl":
					this.cbArr[4]=this.cb4Lbl.isOn
					this.updateList(4);
					break;
			}

		}


		private function updateList(j:int):void {

			var arr:Array=MyInfoManager.getInstance().bagItems;

			var d:int=0;
			var i:int=0;


//			for (j=0; j < this.cbArr.length; j++) {

			if (this.cbArr[j]) {

				for (i=0; i < arr.length; i++) {

					if (arr[i] != null) {
						if (arr[i].info.classid == 1 && arr[i].info.quality == j && arr[i].info.quality != 0) {

							for (d=0; d < this.gridList.length; d++) {

								if (this.gridList[d].isEmpty && !this.isExist(arr[i].pos)) {
									this.gridList[d].updataInfo(arr[i]);
									UIManager.getInstance().equipWnd.BagRender.setBagSelectState(arr[i].pos);
									break;
								}
							}
						}
					}
				}
			} else if (!this.cbArr[j]) {
				for (i=0; i < this.gridList.length; i++) {
					if (!this.gridList[i].isEmpty && this.gridList[i].data.info.quality == j) {
						UIManager.getInstance().equipWnd.BagRender.setBagSelectState(this.gridList[i].data.pos, false);
						this.gridList[i].resetGrid();
						this.gridList[i].delItemHandler();
					}
				}

			}

			this.updateViewState();
		}

		public function onConfirm():void {

			this.gridPosArr.length=0;

			for (var i:int=0; i < 10; i++)
				if (!this.gridList[i].isEmpty) {
					this.gridPosArr.push(this.gridList[i].data.pos);

					this.gridEffectArr[i].visible=true;

					this.gridEffectArr[i].playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						this.parent.visible=false;
					});
				}

			if (this.gridPosArr.length > 0)
				Cmd_Equip.cm_EquipBreakItemList(this.gridPosArr);

		}

		public function onSuccess(o:Object):void {

			if (this.currentExt == -1) {
				this.progressLbl.text=o.ext + "/" + ConfigEnum.equip17;
				this.progressImg.setWH(int(o.ext) / ConfigEnum.equip17 * 222, 18);
				this.oldcurrentExt=o.ext;

//				this.progressImg.setSize(int(o.ext) / ConfigEnum.equip17 * 248, 18);
//				this.progressSpr.scaleX=int(o.ext) / ConfigEnum.equip17;
			}

			this.currentExt=o.ext;

			this.clearData();

			UIManager.getInstance().equipWnd.BagRender.update();
			UIManager.getInstance().equipWnd.BagRender.updatebody([-1], true);
			UIManager.getInstance().equipWnd.BagRender.updateMountEnable(true);
			UIManager.getInstance().equipWnd.BagRender.updateBagQuality2();
		}

		public function onSuccessEffect(o:Object):void {

			EffectUtil.flyWordEffect(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2619).content, [o.addext]), this.localToGlobal(new Point(this.progressLbl.x + this.progressLbl.width / 2 - 10, this.progressLbl.y - 30)));

			if (o.additem > 0) {

				NoticeManager.getInstance().broadcastById(2620, [o.additem]);

				this.confirmBtn.setActive(false, .6, true);

				tlime=new TimelineMax();
				tlime.active=true;

				for (var i:int=0; i < o.additem; i++) {
					tlime.append(TweenMax.to(this.progressImg, 1, {width: 222, ease: Linear.easeInOut, onComplete: setProgressImg, onUpdate: updateProgress}));
				}

				tlime.append(TweenMax.to(this.progressImg, Number((1 * Number(((this.currentExt) / ConfigEnum.equip17).toExponential(2))).toExponential(2)), {width: Number(((this.currentExt / ConfigEnum.equip17) * 222).toExponential(2)), ease: Linear.easeInOut, onComplete: CompleteProgressImg, onUpdate: updateProgress}));

			} else {

//				trace(this.currentExt - this.oldcurrentExt,this.currentExt,this.oldcurrentExt,((this.currentExt - this.oldcurrentExt) / ConfigEnum.equip17))
				TweenMax.to(this.progressImg, Number((1 * Number(((this.currentExt - this.oldcurrentExt) / ConfigEnum.equip17).toExponential(2))).toExponential(2)), {width: Number(((this.currentExt / ConfigEnum.equip17) * 222).toExponential(2)), ease: Linear.easeInOut, onComplete: CompleteProgressImg, onUpdate: updateProgress})
			}

		}

		private function CompleteProgressImg():void {

//			for (var i:int=0; i < 10; i++)
//				if (!this.gridList[i].isEmpty) {
//					this.confirmBtn.setActive(true, 1, true);
//					break;
//				}

			this.progressLbl.text=this.currentExt + "/" + ConfigEnum.equip17;
			this.progressImg.setWH(Number(((this.currentExt / ConfigEnum.equip17) * 222).toExponential(2)), 18);

			this.oldcurrentExt=this.currentExt;
		}

		private function setProgressImg():void {
			this.progressLbl.text="0/" + ConfigEnum.equip17;
			this.progressImg.setWH(1, 18);
			this.oldcurrentExt=0;

			if (this.visible && UIManager.getInstance().equipWnd.getTabIndex() == 4) {
				var p:Point=this.localToGlobal(new Point(this.Biggrid.x, this.Biggrid.y));
				FlyManager.getInstance().flyBags([ConfigEnum.equip19], [p], [[60, 60]]);
			}
		}

		private function updateProgress():void {
			this.progressLbl.text=Math.ceil(ConfigEnum.equip17 * (this.progressImg.width / 222)) + "/" + ConfigEnum.equip17;
//			this.progressLbl.text=Math.ceil(ConfigEnum.equip17 * (this.progressImg.scaleX)) + "/" + ConfigEnum.equip17;
//			this.progressImg.setSize(Math.ceil(this.progressSpr.scaleX * 248), 18);
		}


		public function setChange():void {

			this.cb1Lbl.turnOff();
			this.cb2Lbl.turnOff();
			this.cb3Lbl.turnOff();
			this.cb4Lbl.turnOff();

			this.cbArr[1]=false;
			this.cbArr[2]=false;
			this.cbArr[3]=false;
			this.cbArr[4]=false;

			Cmd_Equip.cm_EquipBreakStart();
		}

		public function isExist(pos:int):Boolean {

			for (var i:int=0; i < 10; i++) {
				if (this.gridList[i].data != null && this.gridList[i].data.pos == pos)
					return true;
			}

			return false;
		}
 
		public function setDownItem(g:EquipStrengGrid):void {

			if (g.data.info.quality == 0)
				return;

			var i:int=0;

			if (this.isExist(g.data.pos)) {
				for (i=0; i < 10; i++) {
					if (!this.gridList[i].isEmpty && this.gridList[i].data.pos == g.data.pos) {
						this.gridList[i].resetGrid();
						this.gridList[i].delItemHandler();
						break;
					}
				}

				g.setSelectState(false);

			} else {

				g.setSelectState(true);

				for (i=0; i < 10; i++) {
					if (this.gridList[i].isEmpty) {
						this.gridList[i].updataInfo(g.data);
						break;
					}
				}
			}

			this.updateViewState();
		}

		public function updateViewState():void {

			var j:int=0;
			var d:int=0;
			var c:int=0;
			var i:int=0;
			var rect:int=0;

			var start:int=0;
			var end:int=0;

//			this.cb1Lbl.turnOff();
//			this.cb2Lbl.turnOff();
//			this.cb3Lbl.turnOff();
//			this.cb4Lbl.turnOff();
//
//			this.cbArr[1]=false;
//			this.cbArr[2]=false;
//			this.cbArr[3]=false;
//			this.cbArr[4]=false;

//			for (i=0; i < 10; i++) {
//				if (!this.gridList[i].isEmpty) {
//					this.cbArr[this.gridList[i].data.info.quality]=true;
//					this.cbUiArr[this.gridList[i].data.info.quality].turnOn();
//				}
//			}


			for (j=0; j < this.cbArr.length; j++) {

//				if (this.cbArr[j]) {
				for (i=0; i < this.gridList.length; i++) {
					if (!this.gridList[i].isEmpty && this.gridList[i].data.info.quality == j) {

						switch (j) {
							case 1:
								rect=ConfigEnum.equip20;
								break
							case 2:
								rect=ConfigEnum.equip21;
								break
							case 3:
								rect=ConfigEnum.equip22;
								break
							case 4:
								rect=ConfigEnum.equip23;
								break
						}

						start+=int(this.gridList[i].data.info.Dec_score);
						end+=int(this.gridList[i].data.info.Dec_score) + int(this.gridList[i].data.info.Dec_score) * (rect / 100);

					}
				}
//				}

			}

			if (start == 0) {
				this.rectLbl.text=" ";
				this.confirmBtn.setActive(false, .6, true);
			} else {
				this.rectLbl.text=start + "~" + end;
				this.confirmBtn.setActive(true, 1, true);
			}
		}

		public function clearAllData():void {
			this.confirmBtn.setActive(false, .6, true);
//			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			for (var i:int=0; i < this.gridList.length; i++) {
				if (!this.gridList[i].isEmpty) {
					UIManager.getInstance().equipWnd.BagRender.setBagSelectState(this.gridList[i].data.pos, false);
					this.gridList[i].resetGrid();
					this.gridList[i].delItemHandler();
				}
			}

			this.cb1Lbl.turnOff();
			this.cb2Lbl.turnOff();
			this.cb3Lbl.turnOff();
			this.cb4Lbl.turnOff();

			this.cbArr[1]=false;
			this.cbArr[2]=false;
			this.cbArr[3]=false;
			this.cbArr[4]=false;

			if (this.tlime != null) {
				this.tlime.pause();
				this.tlime.kill();

				if (this.currentExt != -1) {
					this.progressLbl.text=this.currentExt + "/" + ConfigEnum.equip17;
					this.progressImg.setWH(this.currentExt / ConfigEnum.equip17 * 222, 18);
				}
			}

			PopupManager.closeConfirm("equipBreakConfirm");
		}

		private function clearData():void {
			this.confirmBtn.setActive(false, .6, true);
//			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			for (var i:int=0; i < this.gridList.length; i++) {
				if (!this.gridList[i].isEmpty) {
					UIManager.getInstance().equipWnd.BagRender.setBagSelectState(this.gridList[i].data.pos, false);
					this.gridList[i].resetGrid();
					this.gridList[i].delItemHandler();
				}
			}

			this.cb1Lbl.turnOff();
			this.cb2Lbl.turnOff();
			this.cb3Lbl.turnOff();
			this.cb4Lbl.turnOff();

			this.cbArr[1]=false;
			this.cbArr[2]=false;
			this.cbArr[3]=false;
			this.cbArr[4]=false;

			PopupManager.closeConfirm("equipBreakConfirm");
		}


	}
}

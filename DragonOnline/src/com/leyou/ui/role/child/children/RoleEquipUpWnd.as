package com.leyou.ui.role.child.children {

	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffAward;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.enum.QualityEnum;
	import com.leyou.ui.role.RoleWnd;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	public class RoleEquipUpWnd extends AutoSprite {

		public var nameLbl:Label;
		private var nameLbl0:Label;
		public var raceImg:Image;
		public var bgNameImg:Image;
		private var lvLbl:Label;
		private var lvImg:Image;
		private var qulityImg:Image;

		private var buffArr:Array=[];
		private var buffStateArr:Array=[];

		private var gridArr:Vector.<EquipGrid>;

		private var currentIndex:int=0;
		private var currentQIndex:int=0;

		private var otherPlayer:Boolean=false;

		public function RoleEquipUpWnd(otherPlay:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/role/RoleEquipUpWnd.xml"));
			this.otherPlayer=otherPlay;
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgNameImg=this.getUIbyID("bgNameImg") as Image;
			this.raceImg=this.getUIbyID("raceImg") as Image;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.nameLbl0=this.getUIbyID("nameLbl0") as Label;

//			this.buffArr.push(this.getUIbyID("qh8img") as Image);
//			this.buffArr.push(this.getUIbyID("qh12img") as Image);
//			this.buffArr.push(this.getUIbyID("qh16img") as Image);
//			this.buffArr.push(this.getUIbyID("zsimg") as Image);
//			this.buffArr.push(this.getUIbyID("jsimg") as Image);

			this.buffStateArr=[0, 0, 0, 0, 0, 0];

			this.gridArr=new Vector.<EquipGrid>;

			var grid:EquipGrid;
			for (var i:int=0; i < 14; i++) {

				grid=new EquipGrid();
				grid.dataId=i;

				if (Math.floor(i / 7) == 0)
					grid.x=11;
				else
					grid.x=267;

				grid.y=62 + i % 7 * (65 - 19);

				grid.doubleClickEnabled=!otherPlayer;

				this.addChild(grid);
				this.gridArr.push(grid);
			}

//			EventManager.getInstance().addEvent(EventEnum.UI_MOVE_OVER, onLoader);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
//			TweenLite.delayedCall(2,onLoadStage);
		}

		private function onStage(e:Event):void {
			this.onLoadStage();
		}

		private function onLoadStage():void {

			var rolewnd:RoleWnd=UIManager.getInstance().roleWnd;

//			rolewnd.addChild(this.bgNameImg);
//			rolewnd.addChild(this.raceImg);
//			rolewnd.addChild(this.nameLbl);

//			this.bgNameImg.x=52;
//			this.bgNameImg.y=109;
			if (!this.otherPlayer)
				this.bgNameImg.fillEmptyBmd();

//			this.raceImg.x=150;
//			this.raceImg.y=91;
//			
//			this.nameLbl.x=80;
//			this.nameLbl.y=110;

//			rolewnd.addChild(rolewnd.lvImg);
//			rolewnd.addChild(rolewnd.qulityImg);


		}

		private function onLoader(i:int):void {
			if (i == WindowEnum.ROLE) {
//				this.raceImg.x=(273 - 34 - this.nameLbl.textWidth) / 2;
//				this.nameLbl.x=this.raceImg.x + 34;
			}

		}

		public function onTips1MouseOver(e:DisplayObject):void {

			var sc:int=currentIndex == -1 ? 0 : currentIndex;

			var nextCount:int;
			for (var i:int=sc + 1; i < 3; i++)
				nextCount+=this.buffStateArr[i];

			if (currentIndex > -1 && currentIndex < 3) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_ROLE_EQUIP_LV, {id: currentIndex + 1, next: nextCount, active: true}, new Point(this.stage.mouseX, this.stage.mouseY));
			} else
				ToolTipManager.getInstance().show(TipEnum.TYPE_ROLE_EQUIP_LV, {id: 1, next: nextCount, active: false}, new Point(this.stage.mouseX, this.stage.mouseY));

		}


		public function onTips2MouseOver(e:DisplayObject):void {

			if (currentQIndex == 5)
				return;

			var sc:int=currentQIndex == -1 ? 3 : currentQIndex;

			var nextCount:int;
			for (var i:int=sc + 1; i < 6; i++)
				nextCount+=this.buffStateArr[i];

			if (currentQIndex > 2) {

				ToolTipManager.getInstance().show(TipEnum.TYPE_ROLE_QULITY, {id: currentQIndex + 1, next: nextCount, active: true}, new Point(this.stage.mouseX, this.stage.mouseY));
			} else
				ToolTipManager.getInstance().show(TipEnum.TYPE_ROLE_QULITY, {id: 4, next: nextCount, active: false}, new Point(this.stage.mouseX, this.stage.mouseY));

		}


		private function onTipsMouseOver(e:DisplayObject):void {

		/**
		var i:int=this.buffArr.indexOf(e);
		if (i > -1) {

			var info:TBuffAward=TableManager.getInstance().getBuffAwardById(i + 1);
			var id:int=0;
			var dataArr:Array=[];

			if ((currentIndex > -1 && i < 3 && i <= currentIndex) || (i >= 3 && i <= 4 && i <= currentQIndex && currentQIndex > -1)) {
				id=info.tip_own;

				if (i == 3 || i == 4) {
//						dataArr=[info.attack, info.magic, info.phyDef, info.magicDef, info.life, info.tenacity, info.dodge, info.guard];
					dataArr=[info.attack, info.phyDef, info.life, info.tenacity, info.dodge, info.guard];
				} else
//						dataArr=[info.attack, info.magic, info.phyDef, info.magicDef, info.life, info.crit, info.hit, info.slay];
					dataArr=[info.attack, info.phyDef, info.life, info.crit, info.hit, info.slay];

			} else {

				id=info.tip_unown;

				if (i == 3) {
//						dataArr=[this.buffStateArr[i] + this.buffStateArr[4], info.attack, info.magic, info.phyDef, info.magicDef, info.life, info.tenacity, info.dodge, info.guard];
					dataArr=[this.buffStateArr[i] + this.buffStateArr[4], info.attack, info.phyDef, info.life, info.tenacity, info.dodge, info.guard];
				} else if (i == 4) {
//						dataArr=[this.buffStateArr[i], info.attack, info.magic, info.phyDef, info.magicDef, info.life, info.tenacity, info.dodge, info.guard];
					dataArr=[this.buffStateArr[i], info.attack, info.phyDef, info.life, info.tenacity, info.dodge, info.guard];
				} else {

					var ucount:int=0;
					for (var _i:int=i; _i < 3; _i++)
						ucount+=this.buffStateArr[_i]

//						dataArr=[ucount, info.attack, info.magic, info.phyDef, info.magicDef, info.life, info.crit, info.hit, info.slay];
					dataArr=[ucount, info.attack, info.phyDef, info.life, info.crit, info.hit, info.slay];
				}
			}

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(id).content, dataArr), new Point(this.stage.mouseX, this.stage.mouseY));
		}
		*/

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(o:RoleInfo):void {

//			this.nameLbl.setTextFormat(FontEnum.getTextFormat("Gold12Center"));
			this.nameLbl.text=o.n + "";

			this.raceImg.visible=(o.vipLv > 0);
			this.raceImg.updateBmp("ui/name/vip" + o.vipLv + ".jpg");

			this.raceImg.x=(320 - 34) / 2;
			this.nameLbl.x=(320 - this.nameLbl.textWidth) / 2;
//			this.lvLbl.text="等级:" + o.lv;

		}

		public function setCpName(n:String):void {
//			if (n == null)
//				this.nameLbl0.text="";
//			else
//				this.nameLbl0.text=n + "" + PropUtils.getStringById(2241);
		}

		public function updateEquip(otherPlayer:Boolean=false):void {

			var obj:Object;
			if (!otherPlayer)
				obj=MyInfoManager.getInstance().equips;
			else
				obj=MyInfoManager.getInstance().otherEquips;


//			this.setbuffState();
			this.currentIndex=-1;
			this.currentQIndex=-1;


			this.buffStateArr=[0, 0, 0, 0, 0, 0];
			var isfull:Boolean=true;

			for (var i:Object in this.gridArr) {

				var info:EquipInfo=obj[i];
				this.gridArr[i].updataInfo(info);

				if (otherPlayer)
					this.gridArr[i].canMove=false;

				if (info != null) {

					if (info.tips.qh >= 8 && info.tips.qh < 12) {
						this.buffStateArr[0]++
					}

					if (info.tips.qh >= 12 && info.tips.qh < 16) {
						this.buffStateArr[1]++;
					}

					if (info.tips.qh == 16) {
						this.buffStateArr[2]++;
					}

					if (info.info.quality == QualityEnum.QUA_INCREDIBLE) {
						this.buffStateArr[3]++;
					}

					if (info.info.quality == QualityEnum.QUA_LEGEND) {
						this.buffStateArr[4]++;
					}

					if (info.info.quality == QualityEnum.QUA_ARTIFACT) {
						this.buffStateArr[5]++;
					}

				} else
					isfull=false;

			}

//			for (var _i:int=0; _i < this.buffArr.length; _i++) {
//				this.buffArr[_i].filters=[FilterUtil.enablefilter];
//			}

			if (isfull) {

				var k:int=this.buffStateArr.lastIndexOf(14, 2);
				var j:int=0;
				if (k == -1) {

					j=int(this.buffStateArr[1]) + int(this.buffStateArr[2]);

					if (j >= 14)
						k=1;
					else if (k == -1) {
						j=int(this.buffStateArr[0]) + int(this.buffStateArr[1]);
						if (j < 14) {
							j+=int(this.buffStateArr[2]);
						}

						if (j >= 14) {
							k=0;
						}
					}
				}

				currentIndex=k;

				switch (k) {
					case 0:
						this.lvImg.updateBmp("ui/character/img_eqstr_8.png");
						break;
					case 1:
						this.lvImg.updateBmp("ui/character/img_eqstr_12.png");
						break;
					case 2:
						this.lvImg.updateBmp("ui/character/img_eqstr_16.png");
						break;
					default:
						this.lvImg.updateBmp("ui/character/img_eqstr_0.png");
				}

				k=this.buffStateArr.indexOf(14, 3);

				if (k == -1) {
					j=int(this.buffStateArr[4]) + int(this.buffStateArr[5]);
					if (j == 14) {
						k=4;
					} else {
						j=int(this.buffStateArr[3]) + int(this.buffStateArr[4]);
						if (j < 14) {
							j+=int(this.buffStateArr[5]);
						}

						if (j == 14)
							k=3;
					}
				}

				currentQIndex=k;

//				for (_i=3; _i <= k; _i++)
//					if (_i < this.buffArr.length)
//						this.buffArr[_i].filters=[];

				switch (k) {
					case 3:
						this.qulityImg.updateBmp("ui/character/img_equality_3.png");
						break;
					case 4:
						this.qulityImg.updateBmp("ui/character/img_equality_4.png");
						break;
					case 5:
						this.qulityImg.updateBmp("ui/character/img_equality_5.png");
						break;
					default:
						this.qulityImg.updateBmp("ui/character/img_equality_0.png");
				}

			} else {
				this.lvImg.updateBmp("ui/character/img_eqstr_0.png");
				this.qulityImg.updateBmp("ui/character/img_equality_0.png");
			}

			ToolTipManager.getInstance().hide();
			UIManager.getInstance().selectWnd.updateList();
		}

		public function get currentEquip():Array {

			var pid:Array=[99935, 99936, 99937, 99933, 99934];
			var data:Array=[-1, -1];

			if (this.currentIndex > -1)
				data[1]=pid[this.currentIndex];

			if (this.currentQIndex > -1) {
				if (this.currentQIndex == 5)
					data[0]=pid[4];
				else
					data[0]=pid[this.currentQIndex];
			}

			return data;
		}

		private function setbuffState(v:Boolean=true):void {
			for (var i:int=0; i < this.buffStateArr.length; i++) {
				this.buffStateArr[i]=0;
			}
		}

		public function deleteEquip(pos:int):void {
			this.gridArr[pos].clearMe();
			this.updateEquip();
		}

		public function setLVImg(i:Image):void {
			this.lvImg=i;
			this.addChild(this.lvImg);
		}

		public function setQualityImg(i:Image):void {
			this.qulityImg=i;
			this.addChild(this.qulityImg);
		}

	}
}

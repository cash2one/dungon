package com.leyou.ui.role.child.children {

	import com.ace.enum.EventEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffAward;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.enum.QualityEnum;
	import com.leyou.utils.FilterUtil;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class RoleEquipUpWnd extends AutoSprite {

		private var nameLbl:Label;
		private var raceImg:Image;
		private var lvLbl:Label;

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
		}

		private function init():void {

			this.raceImg=this.getUIbyID("raceImg") as Image;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.buffArr.push(this.getUIbyID("qh8img") as Image);
			this.buffArr.push(this.getUIbyID("qh12img") as Image);
			this.buffArr.push(this.getUIbyID("qh16img") as Image);
			this.buffArr.push(this.getUIbyID("zsimg") as Image);
			this.buffArr.push(this.getUIbyID("jsimg") as Image);

			this.buffStateArr=[0, 0, 0, 0, 0];

			this.gridArr=new Vector.<EquipGrid>;

			var grid:EquipGrid;
			for (var i:int=0; i < 14; i++) {

				grid=new EquipGrid();
				grid.dataId=i;

				if (Math.floor(i / 7) == 0)
					grid.x=5;
				else
					grid.x=227;

				grid.y=33 + i % 7 * (65 - 19);

				grid.doubleClickEnabled=!otherPlayer;

				this.addChild(grid);
				this.gridArr.push(grid);
			}

			var einfo:MouseEventInfo;
			for (i=0; i < this.buffArr.length; i++) {

				einfo=new MouseEventInfo();
				einfo.onMouseMove=onTipsMouseOver;
				einfo.onMouseOut=onTipsMouseOut;

				MouseManagerII.getInstance().addEvents(this.buffArr[i], einfo);
			}

			EventManager.getInstance().addEvent(EventEnum.UI_MOVE_OVER, onLoader);
		}

		private function onLoader(i:int):void {
			if (i == WindowEnum.ROLE) {
				this.raceImg.x=(273 - 34 - this.nameLbl.textWidth) / 2;
				this.nameLbl.x=this.raceImg.x + 34;
			}

		}

		private function onTipsMouseOver(e:DisplayObject):void {

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

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(o:RoleInfo):void {

			this.nameLbl.text=o.n + "";

			this.raceImg.visible=(o.vipLv > 0);
			this.raceImg.updateBmp("ui/name/vip" + o.vipLv + ".jpg");

			this.raceImg.x=(273 - 34 - this.nameLbl.textWidth) / 2;
			this.nameLbl.x=this.raceImg.x + 34;
//			this.lvLbl.text="等级:" + o.lv;

		}

		public function updateEquip(otherPlayer:Boolean=false):void {

			var obj:Object;
			if (!otherPlayer)
				obj=MyInfoManager.getInstance().equips;
			else
				obj=MyInfoManager.getInstance().otherEquips;

			this.setbuffState();
			this.currentIndex=-1;
			this.currentQIndex=-1;

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

			for (var _i:int=0; _i < this.buffArr.length; _i++) {
				this.buffArr[_i].filters=[FilterUtil.enablefilter];
			}

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

				for (_i=0; _i <= k; _i++)
//				if (k != -1)
					this.buffArr[_i].filters=[];

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

				for (_i=3; _i <= k; _i++)
//				if (k != -1)
					this.buffArr[_i].filters=[];

			}

			ToolTipManager.getInstance().hide();
			UIManager.getInstance().selectWnd.updateList();
		}

		public function get currentEquip():Array {

			var pid:Array=[99935, 99936, 99937, 99933, 99934];
			var data:Array=[-1, -1];

			if (this.currentIndex > -1)
				data[1]=pid[this.currentIndex];

			if (this.currentQIndex > -1)
				data[0]=pid[this.currentQIndex];

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

	}
}

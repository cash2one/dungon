package com.leyou.ui.skill.childs {

	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.PnfUtil;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.enum.SkillEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Skill;
	import com.leyou.utils.FilterUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SkillGrid extends GridBase {

		private var lvLbl:Label;
		public var sta:int; //现在处于什么状态

		private var autoEffect:SwfLoader;

		public function SkillGrid() {

		}

		override protected function init(hasCd:Boolean=false):void {

			super.init();

			//this.canMove=false;
			this.isLock=false;

			this.iconBmp.x=(40 - 38) >> 1;
			this.iconBmp.y=(40 - 38) >> 1;

			var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/bg.png"));
			bmp.scale9Grid=new Rectangle(3, 3, 35, 35);
			bmp.setSize(40, 40);
			this.bgBmp.bitmapData=bmp.bitmapData;

//			var select:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
//			select.scale9Grid=new Rectangle(2, 2, 20, 20);
//			select.setSize(40, 40);
//			this.selectBmp.bitmapData=select.bitmapData;

			this.lvLbl=new Label("1", FontEnum.getTextFormat("White10right"));
			this.lvLbl.x=30;
			this.lvLbl.y=22;
			this.lvLbl.text="";
			this.addChild(this.lvLbl);

			this.autoEffect=new SwfLoader(99969);
			this.autoEffect.x=-1;
			this.autoEffect.y=-1;

			this.canMove=false;
		}

		override public function updataInfo(info:Object):void {
			if (info == null)
				return;

			super.updataInfo(info);

			if (this.gridType == ItemEnum.TYPE_GRID_RUNE) {
				this.lvLbl.visible=false;
				this.iconBmp.updateBmp("ico/skills/" + TSkillInfo(info).runeIcon + ".png", null, false, -1, -1, PriorityEnum.FIVE);
			} else {
				this.iconBmp.updateBmp("ico/skills/" + TSkillInfo(info).icon + ".png", null, false, -1, -1, PriorityEnum.FIVE);
			}

			this.iconBmp.setWH(38, 38);
			this.canMove=false;
			this.dataId=int(info.skillId);
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);
		}

		public function setSize(w:Number, h:Number):void {
			this.iconBmp.setWH(w, h);
			this.bgBmp.setWH(w, h);
//			this.selectBmp.setWH(w+2,h+2);
		}

		public function setMagicEffect(v:Boolean):void {

			if (v) {
				if (this.autoEffect.parent == null)
					this.addChild(this.autoEffect);
			} else {
				if (this.autoEffect.parent == this)
					this.removeChild(this.autoEffect);
			}

		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if (this.gridType == ItemEnum.TYPE_GRID_BASE) {

				var sk:TSkillInfo=UIManager.getInstance().skillWnd.getOpenSkill(this.dataId);
				if (sk == null)
					return;

				if (this.autoEffect.parent == null) {
					if (sk.auto == 0) {
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2118))
						return;
					}

					this.addChild(this.autoEffect);
					UIManager.getInstance().toolsWnd.setAutoMagicGrid(this.dataId, true);
					GuideManager.getInstance().removeGuide(68);
				} else {
					this.removeChild(this.autoEffect);
					UIManager.getInstance().toolsWnd.setAutoMagicGrid(this.dataId, false);
				}

			} else {

//				if (this.sta == SkillEnum.RUNE_GETED || this.sta == SkillEnum.RUNE_NOT_GET) {
//					return;
//				} else if (!(this.parent as SkillBar).getedRune(this.dataId)) {
//				} else {
				//(this.parent as SkillBar).setRuneed(this.dataId);
//					Cmd_Skill.cm_sklActive(SkillBar(this.parent).id, (this.dataId + 1));

//					var sid:int=SkillBar(this.parent).id;
//					if (!UIManager.getInstance().skillWnd.confirmState) {
//						
//						var itmid:TItemInfo=TableManager.getInstance().getItemInfo(MyInfoManager.getInstance().skilldata.itemId);
//						PopupManager.showConfirm("切换符文将消耗掉" + MyInfoManager.getInstance().skilldata.num + "个道具 " + itmid.name + " 是否确认切换？", okFun);
//
//						function okFun():void {
//							Cmd_Skill.cm_sklChange(sid, dataId);
//						}
//
//					} else {
//						Cmd_Skill.cm_sklChange(sid, dataId);
//					}
//				}

			}
		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
//			trace($x, $y);
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
			this.selectBmp.visible=true;

			if (this.gridType == ItemEnum.TYPE_GRID_SKILL || this.dataId == -1)
				return;

//			UIManager.getInstance().tipsSkillWnd.updateInfo(SkillBar(this.parent).id, this.dataId);
//			UIManager.getInstance().tipsSkillWnd.show();
//			UIManager.getInstance().tipsSkillWnd.x=$x;
//			UIManager.getInstance().tipsSkillWnd.y=$y;
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			this.selectBmp.visible=false;

//			UIManager.getInstance().tipsSkillWnd.hide();
		}

		public function hidBg():void {
			this.bgBmp.bitmapData=null;
		}

		public function setShortCutKeyNum(num:int):void {

			if (this.lvLbl.visible == false)
				this.lvLbl.visible=true;

			if (num >= 0 && num < 5)
				this.lvLbl.text=num + 1 + "";
			else if (num == 5)
				this.lvLbl.text="Q";
			else if (num == 6)
				this.lvLbl.text="W";
			else if (num == 7)
				this.lvLbl.text="E";
			else if (num == 8)
				this.lvLbl.text="R";
			else if (num == 9)
				this.lvLbl.text="T";
			else if (num < 0)
				this.lvLbl.text="";

		}

		public function getKeyIndexByIndex():int {

			var key:String=this.lvLbl.text;

			if (key == null || key == "")
				return -1;

			switch (key) {
				case "Q":
					return 6;
					break;
				case "W":
					return 7;
					break;
				case "E":
					return 8;
					break;
				case "R":
					return 9;
					break;
				case "T":
					return 10;
					break;
			}

			return int(key);
		}

		override public function set enable(value:Boolean):void {
			super.enable=value;

			if (value) {
				this.filters=[];
			} else {
				this.filters=[FilterUtil.enablefilter];
			}

		}

		public function set state(s:int):void {
			this.sta=s;

			switch (s) {
				case 0:
					this.enable=false;
					break;
				case 1:
					this.enable=true;
					this.filters=[FilterUtil.enablefilter];
					break;
				case 2:
					this.enable=false;
					this.filters=[];
					break;
			}

		}

		public function get state():int {
			return this.sta;
		}



	}
}

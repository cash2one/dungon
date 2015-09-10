package com.ace.ui.setting.child {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.leyou.data.playerSkill.TipSkillInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AssistSkillGrid extends GridBase {
		
		public var switchListener:Function;
		
		public var gid:int;
		
		public var isPetSkill:Boolean = false;

		public function AssistSkillGrid() {
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 * @param hasCd 是否显示CD
		 *
		 */
		protected override function init(hasCd:Boolean=false):void {
			super.init();
			iconBmp.x=3;
			iconBmp.y=3;
			isLock=false;
			mouseEnabled=true;
			mouseChildren=true;
			bgBmp.visible = false;
//			bgBmp.updateBmp("ui/common/common_icon_bg.png");

			var select:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid=new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData=select.bitmapData;
		}

		public override function mouseDownHandler($x:Number, $y:Number):void {
		}

		public override function updataInfo(info:Object):void {
			var skillId:int = info as int;
			if(skillId == 0){
				dataId = -1;
				iconBmp.fillEmptyBmd();
				return;
			}
			var skillInfo:TSkillInfo = TableManager.getInstance().getSkillById(skillId);
			super.updataInfo(skillInfo);
			if (this.gridType == ItemEnum.TYPE_GRID_RUNE) {
				this.iconBmp.updateBmp("ico/skills/" + skillInfo.runeIcon + ".png", null, false, 36, 36);
			} else {
				this.iconBmp.updateBmp("ico/skills/" + skillInfo.icon + ".png", null, false, 36, 36);
			}
			this.dataId=skillId;
		}

		/**
		 * <T>鼠标移入显示TIP</T>
		 *
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 *
		 */
		public override function mouseOverHandler($x:Number, $y:Number):void {
			this.selectBmp.visible=true;
			if (this.gridType == ItemEnum.TYPE_GRID_SKILL || this.dataId == -1) {
				return;
			}
			var tipInfo:TipSkillInfo=new TipSkillInfo();
//			var skillId:uint=uint(TableManager.getInstance().getSkillById(dataId).skillId);
//			tipInfo.skillInfo=UIManager.getInstance().skillWnd.getOpenSkill(skillId)
			tipInfo.skillInfo=TableManager.getInstance().getSkillById(dataId);
//			tipInfo.runde=TableManager.getInstance().getSkillArr(skillId).indexOf(tipInfo.skillInfo);
//			tipInfo.hasRune=(0 < tipInfo.runde);
//			tipInfo.skillLv = 0;
//			tipInfo.level=Core.me.info.level;
			tipInfo.isPetSkill = isPetSkill;
			if (tipInfo.hasRune) {
				ToolTipManager.getInstance().showII([TipEnum.TYPE_SKILL, TipEnum.TYPE_RUNE], [tipInfo, tipInfo], PlayerEnum.DIR_S, new Point(0, 0), new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
			} else {
				ToolTipManager.getInstance().show(TipEnum.TYPE_SKILL, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
			}
		}

		public override function mouseUpHandler($x:Number, $y:Number):void {
		}
	}
}
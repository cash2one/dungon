package com.leyou.ui.boss.children {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.bossCopy.BossCopyBossData;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BossCopyItemRender extends AutoSprite {
		// boss图标
		private var iconImg:Image;

		// 选中图片
		private var selectImg:Image;

		// 锁定图片
		private var lockImg:Image;

		// boss信息
		private var data:BossCopyBossData;

		private var _select:Boolean;

		public var prevData:BossCopyBossData;

		public function BossCopyItemRender() {
			super(LibManager.getInstance().getXML("config/ui/boss/bossPlayerLableIn.xml"));
			init();
		}

		public function get bossData():BossCopyBossData {
			return data;
		}

		public function set select(value:Boolean):void {
			_select=value;
			selectImg.visible=value;
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseEnabled=true;
			iconImg=getUIbyID("iconImg") as Image;
			selectImg=getUIbyID("selectImg") as Image;
			lockImg=getUIbyID("lockImg") as Image;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			selectImg.visible=false;
		}

		protected function onMouseOut(event:MouseEvent):void {
			if (!_select) {
				selectImg.visible=false;
			}
		}

		protected function onMouseOver(event:MouseEvent):void {
			selectImg.visible=true;
			if (0 == data.status) {
				var lvColor:String=Core.me.info.level >= data.copyInfo.openLevel ? "#FF00" : "#FF0000";
				var nameColor:String=prevData.isFirst ? "#FF00" : "#FF0000";
				var tipStr:String=PropUtils.getStringById(1648);
				tipStr=StringUtil_II.translate(tipStr, lvColor, data.copyInfo.openLevel, nameColor, prevData.copyInfo.name);
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, tipStr, new Point(stage.mouseX, stage.mouseY));
			}
		}

		/**
		 * <T>更新boss信息</T>
		 *
		 * @param obj 数据
		 *
		 */
		public function updateInfo($data:BossCopyBossData, $prevData:BossCopyBossData):void {
			data=$data;
			prevData=$prevData;
			iconImg.updateBmp("ui/dungeon/" + data.copyInfo.sourceUrl);
			lockImg.visible=(0 == data.status);
			iconImg.filters=(0 == data.status) ? [FilterEnum.enable] : null;
		}

		public function lock():Boolean {
			return (0 == data.status);
		}
	}
}

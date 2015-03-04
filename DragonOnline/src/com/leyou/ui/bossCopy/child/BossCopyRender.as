package com.leyou.ui.bossCopy.child
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.copy.BossCopyData;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BossCopyRender extends AutoSprite
	{
		// boss图标
		private var iconImg:Image;
		
		// 选中图片
		private var selectImg:Image;
		
		// 锁定图片
		private var lockImg:Image;
		
		// boss信息
		private var data:BossCopyData;
		
		private var _select:Boolean;
		
		public var prevRender:BossCopyRender;
		
		public function BossCopyRender(){
			super(LibManager.getInstance().getXML("config/ui/bossCpy/dungeonBossRender.xml"));
			init();
		}
		
		public function get bossData():BossCopyData{
			return data;
		}
		
		public function set select(value:Boolean):void{
			_select = value;
			selectImg.visible = value;
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			mouseEnabled = true;
			data = new BossCopyData();
			iconImg = getUIbyID("iconImg") as Image;
			selectImg = getUIbyID("selectImg") as Image;
			lockImg = getUIbyID("lockImg") as Image;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			selectImg.visible = false;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			if(!_select){
				selectImg.visible = false;
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			selectImg.visible = true;
			if(0 == data.status){
				var lvColor:String = Core.me.info.level >= data.copyInfo.openLevel ? "#FF00" : "#FF0000";
				var nameColor:String = prevRender.data.isFirst ? "#FF00" : "#FF0000";
				var tipStr:String = "<b><font face='Microsoft YaHei' size='12' color='#FCD201'>开启级别：</font></b><font face='Microsoft YaHei' size='12' color='{1}'>{2}级</font>" +
					"&#13;<b><font face='Microsoft YaHei' size='12' color='#FCD201'>开启条件：</font></b><font face='Microsoft YaHei' size='12' color='{3}'>击败{4}</font>";
				tipStr = StringUtil_II.translate(tipStr, lvColor, data.copyInfo.openLevel, nameColor, prevRender.data.copyInfo.name);
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, tipStr, new Point(stage.mouseX, stage.mouseY));
			}
		}
		
		/**
		 * <T>更新boss信息</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public function updateInfo(obj:Object):void{
			data.updateInfo(obj);
			iconImg.updateBmp("ui/dungeon/" + data.copyInfo.sourceUrl);
			lockImg.visible = (0 == data.status);
			iconImg.filters = (0 == data.status) ? [FilterEnum.enable] : null;
		}
		
		public function lock():Boolean{
			return (0 == data.status);
		}
	}
}
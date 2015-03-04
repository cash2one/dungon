package com.ace.ui.notice.child {
	import com.ace.enum.TipEnum;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.ToolTipManager;
	import com.ace.reuse.ReUseModel;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenMax;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class NoticeIcon extends ReUseModel {
		internal static var TOTAL_NUM:int=0;

		// 图标
		private var icon:ImgButton;

		// 显示的TIP信息
		private var tip:String;

		// 按钮特效
		public var effect:SwfLoader;

		// 类型
		public var type:uint;

		// 数据
		public var data:Array;

		// 引用的提示id
		public var id:int;

		public function NoticeIcon() {
			init();
			this.useKey=TOTAL_NUM.toString();
			TOTAL_NUM++;
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		public function init():void {
			icon=new ImgButton(new BitmapData(1, 1));
			addChild(icon);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			mouseEnabled=true;
			mouseChildren=true;
			effect=new SwfLoader(99918);
			effect.x=-11;
			effect.y=-12;
			addChild(effect);
//			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

//		private function onLoadComplete():void{
//			effect.mc.play();
//		}
//
//		protected function onMouseOut(event:Event):void{
//		}

		/**
		 * <T>鼠标移入</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onMouseOver(event:Event):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, tip, new Point(stage.mouseX, stage.mouseY));
		}

		/**
		 * <T>更新信息</T>
		 *
		 * @param info 信息
		 *
		 */
		public function updateInfo(info:TNoticeInfo, $values:Array):void {
			id=info.id;
			var content:String=info.content;
			var flag:int=content.indexOf("|");
			type=int(content.substring(0, flag));
			tip=content.substr(content.indexOf(",") + 1);
			var url:String=content.substring(flag + 1, content.indexOf(","));
			icon.updataBmd(url);
			data=$values;
			effect.update(99918);
		}

		/**
		 * <T>释放</T>
		 *
		 */
		override public function free():void {
			super.free();
			effect.stop();
			x=0;
			tip=null;
			data=null;
			TweenMax.killTweensOf(this);
		}
	}
}

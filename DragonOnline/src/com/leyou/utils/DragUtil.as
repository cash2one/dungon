package com.leyou.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DragUtil
	{
		private static const DragTargets:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private static const LastPoint:Point = new Point();
		
		private static const DragPoint:Point = new Point();
		
		/**
		 * <T>开始拖动</T>
		 * 
		 * @param displays 目标对象
		 * 
		 */		
		public static function startDrag(...displays):void{
			var length:int = displays.length;
			for(var n:int = 0; n < length; n++){
				var display:DisplayObject = displays[n];
				DragTargets.push(display);
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUP);
			LastPoint.x = display.stage.mouseX;
			LastPoint.y = display.stage.mouseY;
		}
		
		private static function onMouseUP(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUP);
			DragTargets.length = 0;
		}
		
		private static function onMouseMove(event:MouseEvent):void{
			// 确定总体边界大小
			var rect:Rectangle;
			var length:int = DragTargets.length;
			for(var n:int = 0; n < length; n++){
				var display:DisplayObject = DragTargets[n];
				var subRect:Rectangle = display.getBounds(stage);
				if(null != rect){
					rect = rect.union(subRect);
				}else{
					rect = subRect;
				}
			}
			if(!rect.contains(stage.mouseX, stage.mouseY)){
				return;
			}
			var dx:Number = stage.mouseX - LastPoint.x;
			var dy:Number = stage.mouseY - LastPoint.y;
			rect.x += dx;
			rect.y += dy;
			// 确定是否越界
			var globalRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			if(globalRect.containsRect(rect)){
				for(var m:int = 0; m < length; m++){
					DragTargets[m].x += dx;
					DragTargets[m].y += dy;
				}
			}
			LastPoint.x = stage.mouseX;
			LastPoint.y = stage.mouseY;
		}
		
		private static function get stage():Stage{
			return DragTargets[0].stage;
		}
	}
}
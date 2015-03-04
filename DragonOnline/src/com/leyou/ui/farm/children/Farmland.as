package com.leyou.ui.farm.children
{
	import com.ace.enum.TipEnum;
	import com.ace.manager.ToolTipManager;
	import com.leyou.enum.FarmEnum;
	import com.leyou.utils.PixelUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 土地
	 * @author wfh
	 * 
	 */	
	public class Farmland extends Sprite
	{
		private static const BLOCK_COUNT:int = 9;
		
		private var blocks:Vector.<FarmBlock>;
		
		private var lastBlock:FarmBlock;
		
		public function Farmland(){
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */
		protected function init():void{
			blocks = new Vector.<FarmBlock>();
			for(var n:int = 0; n < BLOCK_COUNT; n++){
				var block:FarmBlock = new FarmBlock();
				blocks.push(block);
				block.blockId = n+1;
				block.x = -50*int(n/3) + 58*(n%3);
				block.y = 26*int(n/3) + 35*(n%3);
				addChild(block);
				block.updateStatus({c:FarmEnum.BLOCK_LOCK, l:1});
//				block.updateStatus(Math.random()*10000%5);
			}
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 3);
//			mouseChildren = false;
		}
				
		/**
		 * <T>鼠标移出</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseOut(event:MouseEvent):void{
			if(null != lastBlock){
				var block:FarmBlock = testUnderBlock(stage.mouseX, stage.mouseY);
				if(lastBlock != block){
					lastBlock.mouseOut();
					ToolTipManager.getInstance().hide();
				}
			}
		}
		
		/**
		 * <T>鼠标按下</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseDown(event:MouseEvent):void{
			var block:FarmBlock = testUnderBlock(event.stageX, event.stageY);
			if(null != block){
				block.onMouseClick(event.target);
			}
		}
		
		/**
		 * <T>鼠标移动</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseMove(event:MouseEvent):void{
			var block:FarmBlock = testUnderBlock(event.stageX, event.stageY);
			if(null != lastBlock){
				if(block == lastBlock){
					return;
				}
				lastBlock.mouseOut();
				ToolTipManager.getInstance().hide();
			}
			if(null != block){
				block.mouseOver();
				if(block.showTip()){
					ToolTipManager.getInstance().showNoHide(TipEnum.TYPE_FARM, block, new Point(stage.mouseX+15, stage.mouseY+15));
				}
			}
			lastBlock = block;
		}
		
		/**
		 * <T>像素检测鼠标下土地</T>
		 * 
		 */
		protected function testUnderBlock($x:int, $y:int):FarmBlock{
			var globalPoint:Point = new Point($x, $y);
			var objectArray:Array = parent.getObjectsUnderPoint(globalPoint);
			for(var n:int = objectArray.length; n > 1; n--){
				var display:DisplayObject = objectArray[n] as Bitmap;
				if(null != display){
					var localPint:Point = display.globalToLocal(globalPoint);
					if(PixelUtil.getIsHit(objectArray[n], localPint.x, localPint.y, 10)){
						if(display.parent is FarmBlock){
							return display.parent as FarmBlock;
						}
						if(display.parent.parent is FarmBlock){
							return display.parent.parent as FarmBlock;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * <T>更新土地地貌信息</T>
		 * 
		 * @param obj 地貌数据
		 * 
		 */		
		public function updataLandInfo(obj:Object):void{
			for(var n:int = 0; n < BLOCK_COUNT; n++){
				blocks[n].updateStatus({c:FarmEnum.BLOCK_LOCK, l:1});
			}
			for(var key:String in obj){
				var block:FarmBlock = blocks[int(key)-1];
				var o:Object = obj[key];
				block.updateStatus(o);
			}
		}
		
		/**
		 * 弹出收益提示
		 * 
		 * @param obj
		 * 
		 */		
		public function onSystemNotice(obj:Object):void{
			var li:int = obj.li;
			var ni:int = obj.ni;
			var block:FarmBlock = blocks[li-1];
			block.showNotice(ni, obj.v);
		}
		
		public function hasBuy():Boolean{
			var bc:int = 0;
			var l:int = blocks.length;
			for(var n:int = 0; n < l; n++){
				if(!blocks[n].isLock){
					bc++;
				}
			}
			return (bc < 2);
		}
		
		public function hasRipe():Boolean{
			var bc:int = 0;
			var l:int = blocks.length;
			for(var n:int = 0; n < l; n++){
				if(blocks[n].isRipe){
					return true;
				}
			}
			return false;
		}
	}
}
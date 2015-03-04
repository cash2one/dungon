package com.ace.ui.component
{
	import com.ace.enum.FilterEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class RollNumWidget extends Sprite
	{
		private var bgImg:Image;
		
		private var viewNum:Vector.<Bitmap>;
		
		private var _numContainer:Sprite;
		
		public var number:int = 0;
		
		private var rollBmp:BitmapData;
		
		private var rollIdx:int;
		
//		private var rolling:Boolean;
		
		private var label:TextField;
		
		private var isDisppear:Boolean;
		
//		private var moving:Boolean;
		
		private var imgW:int = 15;
		
		private var imgH:int = 21;
		
		// 每秒滚动像素值
		public var speed:int = 300;
		
		private var popNumber:int;
		
		private var _popText:String;
		
		public var frontFlagImg:Image;
		
		public var tailFlagImg:Image;
		
		private var align:int=1;
		
		private var mode:int;
		
		public var isPopNum:Boolean = true;

		private var rollOverListener:Function;
		
		private var tick:int;
		
		public var spacing:int;

		public function RollNumWidget(){
			init();
		}
		
		// 设置弹出文字
		public function set popText(value:String):void{
			_popText = value;
		}
		
		/**
		 * <T>以背景居中对齐</T>
		 * 
		 */		
		public function alignCenter():void{
			align = 0;
		}
		
		/**
		 * <T>左对齐</T>
		 * 
		 */		
		public function alignLeft():void{
			align = 1;
		}
		
		/**
		 * <T>右对齐</T>
		 * 
		 */		
		public function alignRight():void{
			align = 2;
		}
		
		/**
		 * <T>以容器注册点为中心</T>
		 * 
		 */		
		public function alingRound():void{
			align = 3;
		}
		
		/**
		 * <T>注册滚动完成监听函数</T>
		 * 
		 * @param fun 监听函数
		 * 
		 */		
		public function registerOverListener(fun:Function):void{
			rollOverListener = fun;
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
//			bgImg = new Image();
			label = new Label();
			_numContainer = new Sprite();
			viewNum = new Vector.<Bitmap>();
//			addChild(bgImg);
			addChild(_numContainer);
			addChild(label);
			
			label.defaultTextFormat = new TextFormat("SimSun", 14)
			label.autoSize = TextFieldAutoSize.LEFT;
			label.filters = [FilterEnum.hei_miaobian];
//			var g:Graphics = graphics;
//			g.beginFill(0xff0000);
//			g.drawRect(0, 0, 3, 10);
//			g.endFill();
		}
		
		/**
		 * <T>为数字前方添加加减标志位图</T>
		 * 
		 * @param sourceUrl 位图URI
		 * 
		 */		
		public function addFrontFlag(sourceUrl:String):void{
			if(null == frontFlagImg){
				frontFlagImg = new Image();
				addChild(frontFlagImg);
			}
			frontFlagImg.updateBmp(sourceUrl);
		}
		
		public function frontVisible(value:Boolean):void{
			if(null != frontFlagImg){
				frontFlagImg.visible = value;
			}
		}
		
		/**
		 * <T>为数字后方添加标志位图</T>
		 * 
		 * @param sourceUrl 位图URI
		 * 
		 */		
		public function addTailFlag(sourceUrl:String):void{
			if(null == tailFlagImg){
				tailFlagImg = new Image();
				addChild(tailFlagImg);
			}
			tailFlagImg.updateBmp(sourceUrl);
		}
		
		public function tailVisible(value:Boolean):void{
			if(null != tailFlagImg){
				tailFlagImg.visible = value;
			}
		}
		
		/**
		 * <T>生成一个数字显示对象</T>
		 * 
		 * @return 显示对象
		 * 
		 */		
		public function generateNumView():Bitmap{
			var numImg:Bitmap = new Bitmap();
			numImg.bitmapData = rollBmp;
			numImg.scrollRect = new Rectangle(0, 0, imgW, imgH);
			return numImg;
		}
		
		/**
		 * <T>加载显示资源</T>
		 * 
		 * @param url   数字位图资源
		 * @param bgUrl 背景图
		 * 
		 */		
		public function loadSource(url:String, bgUrl:String=""):void{
			if("" != bgUrl){
				if(null == bgImg){
					bgImg = new Image();
					addChildAt(bgImg, 0);
				}
				bgImg.updateBmp(bgUrl);
			}
			
			// 绘制滚动位图
			var point:Point = new Point();
			for(var n:int = 0; n < 10; n++){
				
				var sourceUrl:String = StringUtil.substitute(url, n); 
				var bitmapData:BitmapData = LibManager.getInstance().getImg(sourceUrl);
				
				imgW = bitmapData.width;
				imgH = bitmapData.height;
				if(null == rollBmp){
					rollBmp = new BitmapData(imgW, imgH*10, true, 0);
				}
				
				point.y = n*imgH;
				rollBmp.copyPixels(bitmapData, bitmapData.rect, point);
			}
			
			// 默认显示0
			var numImg:Bitmap = generateNumView();
			viewNum.push(numImg);
			_numContainer.addChild(numImg);
			adjustPos();
		}
		
		/**
		 * <T>设置要显示的值</T>
		 * 
		 * @param num 要设置的值
		 * 
		 */		
		public function setNum(num:int):void{
			var value:String = num.toString();
			var native:String = number.toString();
			adjustPos(value.length - native.length);
			var length:int = value.length;
			for(var n:int = 0; n < length; n++){
				var v:int = int(value.charAt(n));
				setPosNum(n, v);
			}
			number = num;
		}
		
		/**
		 * <T>设置指定位置的值</T>
		 * 
		 * @param num 要设置的值(个位数)
		 * 
		 */		
		public function setPosNum(pos:int, num:int):void{
			if(pos >= viewNum.length){
				return;
			}
			var rect:Rectangle = viewNum[pos].scrollRect;
			rect.y = num*imgH;
			viewNum[pos].scrollRect = rect;
		}
		
		/**
		 * <T>重置所有数字位为0</T>
		 * 
		 */		
		public function resetAll():void{
			var c:int = viewNum.length;
			for(var n:int = 0; n < c; n++){
				resetPos(n);
			}
		}
		
		/**
		 * <T>重置指定位置为0</T>
		 * 
		 * @param pos 指定位置
		 * 
		 */		
		public function resetPos(pos:int):void{
			var rect:Rectangle = viewNum[pos].scrollRect;
			rect.y = 0;
			viewNum[pos].scrollRect = rect;
		}
		
		/**
		 * <T>向指定数值滚动</T>
		 * 
		 * @param num 要滚动到的值
		 * @param v   滚动结束后是否隐藏
		 * @param $mode 滚动方式 1 -- 顺序滚动  2 -- 集体滚动
		 * @param enforce 强行滚动
		 * 
		 */		
		public function rollToNum(num:int, v:Boolean=false, $mode:int=1, enforce:Boolean=false):void{
			if(num == number && !enforce){
				return;
			}
			if(rollIdx > 0){
				setNum(number);
			}
			tick = getTimer();
			mode = $mode;
			visible = true;
			isDisppear = v;
			popNumber = num - number;
			var value:String = num.toString();
			var na:String = number.toString();
			adjustPos(value.length - na.length);
			number = num;
			rollIdx = viewNum.length-1;
			if(1 == mode){
				resetPos(rollIdx);
			}else if(2 == mode){
				resetAll();
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * <T>帧监听,刷新滚动位置</T>
		 * 
		 * @param event 帧事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			if(rollIdx < 0){
				// 是否弹出文本提示
				if(isPopNum){
					popNum(popNumber);
				}
				// 是否具有完成监听函数
				if(null != rollOverListener){
					rollOverListener.call(this);
				}
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			if(1 == mode){      // 单个顺序滚动模式
				singleRollMode();
			}else if(2 == mode){  // 整体滚动模式
				allRollMode();
			}
		}
		
		/**
		 * <T>单个滚动</T>
		 * 
		 */		
		private function singleRollMode():void{
			var v:int = int(number.toString().charAt(rollIdx));
			if(rollPos(rollIdx, v, speed)){
				tick = getTimer();
				if(--rollIdx >= 0){
					resetPos(rollIdx);
				}
			}
		}
		
		/**
		 * <T>整体滚动</T>
		 * 
		 */		
		private function allRollMode():void{
			var overCount:int = 0;
			for(var n:int = viewNum.length - 1; n >= 0; n--){
				var v:int = int(number.toString().charAt(n));
				if(rollPos(n, v, speed-n*20)){
					overCount++;
				}
			}
			if(overCount >= viewNum.length){
				rollIdx = -1;
			}
		}
		
		/**
		 * <T>滚动一个位置的数值</T>
		 * 
		 * @param pos 位置
		 * @param num 滚动到的值
		 * @return    是否滚动完毕
		 * 
		 */		
		private function rollPos(pos:int, num:int, $speed:int):Boolean{
			var isOver:Boolean = false;
			var interval:int = getTimer() - tick;
			var posY:int = interval/1000*$speed;
			if(posY > rollBmp.height){
				posY = num*imgH;
				isOver = true;
			}
			var rect:Rectangle = viewNum[pos].scrollRect;
			rect.y = posY;
			viewNum[pos].scrollRect = rect;
			return isOver;
		}
		
		/**
		 * <T>弹出文字提示</T>
		 * 
		 * @param num 提示数字
		 * 
		 */		
		private function popNum(num:int):void{
			var w:Number = (null == bgImg) ? width : bgImg.width;
			if(null != _popText && "" != _popText){
				label.text = _popText+"+"+num;
				label.textColor = 0xff00;
			}else{
				var v:String = (num < 0) ? ""+num : "+"+num;
				label.text = "战斗力" + v;
				label.textColor = (num > 0) ? 0x00ff00 : 0xff0000;
			}
			label.y = 0;
			label.x = (w - viewNum.length * imgW)*.5;
			label.alpha = 1;
			label.visible = true;
			TweenLite.to(label, 1, {y:-25, onComplete:onMoveOver});
			function onMoveOver():void{
				TweenLite.to(label, 0.5, {alpha:0, onComplete:onPopOver});
			}
			function onPopOver():void{
				if(rollIdx < 0 && isDisppear){
					visible = false;
				}
			}
		}
		
		/**
		 * <T>调整要显示的位数</T>
		 * 
		 * @param num 要调整的位数
		 * 
		 */		
		private function adjustPos(num:int=0):void{
			var length:int = viewNum.length + num;
			if(num > 0){
				// 大于0增加显示位数
				for(var n:int = viewNum.length; n < length; n++){
					var numImg:Bitmap = generateNumView();
					viewNum.unshift(numImg)
					_numContainer.addChild(numImg);
				}
			}else if(num < 0){
				// 小于0减少显示位数
				var count:int = viewNum.length;
				for(var m:int = length; m < count; m++){
					_numContainer.removeChild(viewNum[m]);
					viewNum[m].bitmapData = null;
				}
				viewNum.length = length;
			}
			// 调整各位上数字的显示位置
			var c:int = viewNum.length;
			for(var i:int = 0; i < c; i++){
				viewNum[i].x = i*(imgW + spacing);
			}
			// 调整对齐
			if(0 == align && (null != bgImg)){//中心
				_numContainer.x = (bgImg.width - viewNum.length * imgW)*.5;
				_numContainer.y = (bgImg.height - imgH)*.5+8;
			}else if(1 == align){//左
				_numContainer.x = 0;
				_numContainer.y = 0;
			}else if(2 == align){//右
				_numContainer.x = -_numContainer.width;
				_numContainer.y = 0;
			}else if(3 == align){//父容器注册点为中心
				_numContainer.x = -_numContainer.width*0.5;
			}
			if(null != frontFlagImg){
				frontFlagImg.x = _numContainer.x - frontFlagImg.width;
				frontFlagImg.y = _numContainer.y;
			}
			if(null != tailFlagImg){
				tailFlagImg.x = _numContainer.x + _numContainer.width;
				tailFlagImg.y = _numContainer.y;
			}
		}
		
		public function die():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}
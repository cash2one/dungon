package com.leyou.ui.chat.child{
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FilterEnum;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.leyou.enum.ChatEnum;
	import com.leyou.utils.ChatUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	
	public class RichTextFiled extends Sprite{
		
		private static const PLACEHOLDER:String = "-";
		
		private static const SCROLL_SPEED:Number = 50; // 每秒滚动像素值
		
		private var w:Number;
		
		private var h:Number;
		
		private var isScroll:Boolean;
		
		private var beginTick:Number = -1;
		
		private var style:StyleSheet;
		
		// 文本
		public var textFiled:TextField;
		
		// 表情容器
		private var container:Sprite;
		
		// 图片信息数组
		private var spriteMap:Array;
		
		// 超链接监听函数
		public var linkListener:Function;
		
		// 是否循环滚动
		public var loop:Boolean;
		
		
		public function RichTextFiled($w:Number=100, $h:Number=100, $leading:int=3){
			init($w, $h, $leading)
		}
		
		/**
		 * <T>初始化控件</T>
		 * 
		 * @param $w 控件宽
		 * @param $h 控件高(会自动调整换行)
		 * 
		 */		
		private function init($w:Number, $h:Number, $leading:int):void{
			w = $w;
			h = $h;
			textFiled = new TextField();
			addChild(textFiled);
			textFiled.x = 3;
			textFiled.width = w - 10;
			textFiled.wordWrap = true;
			textFiled.multiline = true;
			textFiled.autoSize = TextFieldAutoSize.LEFT;
			textFiled.selectable = false;
			textFiled.mouseWheelEnabled = false;
//			textFiled.border = true;
//			textFiled.borderColor = 0xff0000;
			
			container = new Sprite();
			addChild(container);
			container.mouseChildren = false;
			container.mouseEnabled = false;
			container.cacheAsBitmap = true;
			
			textFiled.filters = [FilterEnum.hei_miaobian];
			textFiled.addEventListener(TextEvent.LINK, linkHandler);
			
			spriteMap = new Array();
			
			style = new StyleSheet();
			style.setStyle("body", {leading:$leading});
			style.setStyle("a:hover", {color:"#ff0000"});
			textFiled.styleSheet = style;
			textFiled.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			textFiled.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			CursorManager.getInstance().resetGameCursor();
		}
		
		/**
		 * <T>鼠标移动(鼠标光标变换)</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseMove(event:MouseEvent):void{
			var index:int = textFiled.getCharIndexAtPoint(event.localX, event.localY);
			if(index < 0){
				CursorManager.getInstance().resetGameCursor();
				return;
			}
			var link:Vector.<String> = new Vector.<String>();
			var reg:RegExp = /<a.*?<\/a>/g;
			var subReg:RegExp = />.*?<\//g;
			var text:String = textFiled.text;
			var html:String = textFiled.htmlText;
			var links:Array = html.match(reg);
			var c:int = links.length;
			for(var n:int = 0; n < c; n++){
				var subStrs:Array = links[n].match(subReg);
				var subStr:String = subStrs[0].slice(1,-2);
				var lb:int = text.indexOf(subStr);
				if(-1 != lb){
					if(index > lb && index < (lb+subStr.length)){
						CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
						break;
					}else{
						CursorManager.getInstance().resetGameCursor();
					}
				}
			}
		}
		
		public function setWidth($w:Number):void{
			w = $w;
			textFiled.width = w - 10;
		}
		
		
		/**
		 * <T>点击超链接事件处理</T>
		 *  
		 * @param evt 连接事件
		 * 
		 */		
		private function linkHandler(evt:TextEvent):void{
			evt.stopImmediatePropagation();
			if(null != linkListener){
				linkListener.call(this, evt);
			}
		}
		
		/**
		 * <T>设置文本内容</T>
		 *  
		 * @param value 文本内容
		 * 
		 */		
		public function setHtmlText(value:String):void{
			textFiled.htmlText = "<body>"+value+"</body>";
			convert();
			checkScroll();
		}
		
		/**
		 * <T>设置为单行滚动文本</T>
		 * 
		 */		
		public function setScrollH():void{
			isScroll = true;
			textFiled.wordWrap = false;
			textFiled.multiline = false;
			textFiled.autoSize = TextFieldAutoSize.NONE;
			var m:Shape = new Shape();
			var g:Graphics = m.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(0, 0, textFiled.width, textFiled.height);
			g.endFill();
			container.parent.addChild(m);
			container.mask = m;
		}
		
		/**
		 * <T>检测是否需要滚动显示</T>
		 * 
		 */		
		public function checkScroll():void{
			if(isScroll){
				var dx:int = textFiled.textWidth - textFiled.width;
				if(dx > 0){
					beginTick = new Date().time;
					addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				}else{
					textFiled.scrollH = 0;
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		/**
		 * <T>监听帧事件,检测滚动是否完成</T>
		 * 
		 * @param event 帧事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			var t:uint = new Date().time - beginTick;
			var dx:int = textFiled.textWidth - textFiled.width;
			var dis:int = t*SCROLL_SPEED/1000;
			textFiled.scrollH = dis;
			if(dx < textFiled.scrollH){
				if(loop){
					beginTick = new Date().time;
					textFiled.scrollH = 0;
				}else{
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			setContainerPos();
		}
		
//				/**
//				 * <T>检测添加图片</T>
//				 * 
//				 */		
//				public function checkFaces():void{
//					var htmlStr:String = textFiled.htmlText;
//					var indexAry:Array = new Array();               // 表情索引数组
//					var pointObj:Array = new Array();               // 表情坐标数组
//					var reg:RegExp = /\\[0-9]{2}/g;                 // 正则检测所有表情符	,此处所用表情标志"\"
//					var faceSign:Array = htmlStr.match(reg);        // 表情符数组
//					if(0 == faceSign.length){
//						return;                                     // 无表情返回
//					}
//					
//					
//					//下面又把表情符号替换为"  "，接着下面去搜索"#$@"。如果下面去搜索表情符号
//					textFiled.htmlText = htmlStr.replace(reg, "~8!*");
//					var benginIdx:uint = 0;
//					var textStr:String = textFiled.text;
//					while(true){
//						var index:int = textStr.indexOf("~8!*", benginIdx);
//						if(-1 != index){
//							indexAry.push(index);                    // 保存所有表情所在索引
//						}else{
//							break;
//						}
//						benginIdx = indexAry[indexAry.length-1] + 1;
//					}
//					
//					var faceCount:int = indexAry.length;
//					var storeHeight:Number = textFiled.height;
//					for(var n:int = 0; n < faceCount; n++){
//						textFiled.height = textFiled.textHeight;
//						pointObj.push(textFiled.getCharBoundaries(indexAry[n]));   
//						textFiled.height = storeHeight;
//					}
//					faceSign = faceSign.reverse();
//					pointObj = pointObj.reverse();
//					var kk:uint = 0;
//					while(kk < faceSign.length){
//						if(pointObj[kk] != null){
//							//创建一个表情对象
//							var fi:uint = faceSign[kk].substr(2, 2);
//							var obj:MovieClip = LibManager.getInstance().getClsMC("face" + fi);//faceMC为资源文件中的影片剪辑
//							container.addChild(obj);
//							obj.x = pointObj[kk].x;//设置表情的x坐标
//							obj.y = pointObj[kk].y-3;//设置表情的y坐标
//							obj = null;
//							kk++;
//						}
//					}
//					reg = null;
//					faceSign = null;
//					pointObj = null;
//					indexAry = null;
//					textStr = null;
//					htmlStr = null;
//				}
		
		/**
		 * <T>图文混排将KEY转换为表情</T>
		 * 
		 */		
		private function convert():void{
//			var tt:uint = getTimer();
			var strLen:int;
			var index:int;
			var iconInfo:Object;
			while(-1 != index){
				iconInfo = getIconInfo();
				index = iconInfo.index;
				if(-1 != index){
					var htmlText:String = textFiled.htmlText;
					var keyStr:String = htmlText.substring(iconInfo.htmlIdx, iconInfo.htmlIdx + strLen);
					htmlText = htmlText.replace(iconInfo.key, PLACEHOLDER);
					textFiled.htmlText = htmlText;
					refreshArr(index, PLACEHOLDER.length - iconInfo.key.length);
					addIcon(iconInfo);
				}
			}
			refresh();
//			var interval:int = getTimer() - tt;
//			trace("-----------------cost = " + interval);
		}
		
		/**
		 * <T>刷新图片的所在索引</T>
		 * 
		 */		
		private function refreshArr(index:int, num:int):void{
			var arr:Array = spriteMap;
			var length:int = arr.length;
			for(var n:int = 0; n < length; n++){
				var info:Object = arr[n];
				if((null != info) && (info.index >= index)){
					info.index += num;
				}
			}
		}
		
		/**
		 * <T>计算图片的显示及位置</T> 
		 * 
		 */		
		private function refresh():void{
			var arr:Array = spriteMap;
			var len:int = arr.length;
			
			var info:Object;
			var item:Sprite;
			var rect:Rectangle;
			
			var txtLineMetrics:TextLineMetrics;
			var lineHeight:int;
			while(len--){
				info = arr[len];
				if(null != info){
					item = info.item;
					if(null != item){
						rect = textFiled.getCharBoundaries(info.index);
						if(null != rect){
							txtLineMetrics = textFiled.getLineMetrics(textFiled.getLineIndexOfChar(info.index));
							lineHeight = rect.height * 0.5 > 25 ? txtLineMetrics.ascent - 25 :(rect.height - 25) * 0.5;
							item.visible = true;
							item.x = rect.x;
							item.y = rect.y + lineHeight + 5;
						}else{
							item.visible = false;
						}
					}
				}
			}
			setContainerPos();
		}
		
		/**
		 * <T>设置图片容器的位置</T> 
		 * 
		 */		
		private function setContainerPos():void{
			var txtPos:Object = getTextFieldPos();
			container.x = textFiled.x + txtPos.x;
			container.y = textFiled.y + txtPos.y;
		}
		
		/**
		 * <T>计算文本滚动偏移</T> 
		 * 
		 * @return 文本位置
		 * 
		 */		
		private function getTextFieldPos():Object{
			var xpos:Number = textFiled.scrollH;
			var n:int = textFiled.scrollV - 1;
			var ypos:Number = textFiled.getLineMetrics(n).height * n;
			return{x: -xpos, y: -ypos};
		}
		
		/**
		 * <T>找到文本中要替换成图片的位置信息</T>
		 *  
		 * @param value 文本
		 * @return      排版信息
		 * 
		 */		
		private function getIconInfo():Object{
			var text:String = textFiled.text;
			var htmlText:String = textFiled.htmlText;
			var index:int = -1;
			var info:Object = {index: -1, htmlIdx:-1, key: ""};
			var keyArray:Array = ChatEnum.TEXT_IMG_KEYS;
			var keyCount:int = keyArray.length;
			for(var i:int = 0; i < keyCount; i++){
				var keyStr:String = "\\" + keyArray[i];
				index = text.indexOf(keyStr);
				if(-1 != index){
					info.index = index;
					info.htmlIdx = htmlText.indexOf(keyStr);
					info.key = keyStr;
					break;
				}
			}
			return info;
		}
		
		/**
		 * <T>替换为图片<T>
		 *  
		 * @param iconInfo 图片信息
		 * 
		 */		
		private function addIcon(keyInfo:Object):void{
//			var id:int;
			var str:String = keyInfo.key;
			var key:int = int(str.substr(1));
			var dis:DisplayObject = ChatUtil.getDisplayObject(key);
			spriteMap.push({item: dis, key: keyInfo.key, index: keyInfo.index});
//			id = spriteMap.length - 1;
			container.addChild(dis);
			setFormat(/*id*/);
		}
		
		/**
		 * <T>设置图片所在文本处格式</T>
		 *  
		 * @param id 图片所在编号
		 * 
		 */		
		private function setFormat(/*id:int*/):void{
//			var space:String = "<Font size='{1}' letterSpacing='{2}'>{3}</Font>";
//			var item:Sprite = spriteMap[id].item;
//			var fontSize:int = item.height-3;
//			var letterSpacing:int = 5;
//			space = StringUtil.translate(space, fontSize, letterSpacing, "·");
			var html:String = textFiled.htmlText;
			html = html.replace(PLACEHOLDER, space);
			textFiled.htmlText = html;
		}
		private static const space:String = "<Font size='19' letterSpacing='5'>·</Font>";
		
		/**
		 * <T>清理所有内容</T>
		 * 
		 */		
		public function clear():void{
			while(0 != container.numChildren){
				container.removeChildAt(0);
			}
			textFiled.htmlText = "";
			spriteMap.length = 0;
		}
		
		/**
		 * <T>清楚鼠标事件</T> 
		 * 
		 */
		public function clearEvent():void{
			if(textFiled.hasEventListener(TextEvent.LINK)){
				textFiled.removeEventListener(TextEvent.LINK, linkHandler);
			}
		}
		
		/**
		 * <T>销毁控件</T>
		 * 
		 */		
		public function die():void{
			clear();
			clearEvent();
			textFiled = null;
			container = null;
			spriteMap = null;
			linkListener = null;
		}
	}
}
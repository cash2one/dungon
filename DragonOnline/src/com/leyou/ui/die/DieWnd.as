package com.leyou.ui.die
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_TobeStrong;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class DieWnd extends AutoWindow
	{
		private static const TEXT_MAX_COUNT:int = 10;
		
		private var panel:ScrollPane;
		
		private var rightBtn:ImgButton;
		
		private var leftBtn:ImgButton;
		
		private var iconPanel:Sprite;
		
		private var textRenders:Vector.<DieTobeStrongMeg>;
		
		private var texts:Vector.<String>;
		
		private var scrollPanel:Sprite;
		
		private var icons:Vector.<DieTobeStrongStar>;
		private var threshold:int;
		
		public function DieWnd(){
			super(LibManager.getInstance().getXML("config/ui/die/reviveMegWnd.xml"));
			init();
		}
		
		public function init():void{
			mouseEnabled = true;
			panel = getUIbyID("viewPanel") as ScrollPane;
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			texts = new Vector.<String>();
			textRenders = new Vector.<DieTobeStrongMeg>(TEXT_MAX_COUNT);
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			scrollPanel = new Sprite();
			scrollPanel.mouseEnabled = false;
			scrollPanel.x = 50;
			scrollPanel.y = 284;
			scrollPanel.scrollRect = new Rectangle(0, 0, 280, 80);
			addChild(scrollPanel);
			icons = new Vector.<DieTobeStrongStar>();
			for(var n:int = 0; n < 6; n++){
				var star:DieTobeStrongStar = new DieTobeStrongStar();
				star.setType(n+1);
				scrollPanel.addChild(star);
				star.x = n * 100;
				icons.push(star);
			}
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			leftBtn.visible = false;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "leftBtn":
					scrollToX(0);
					break;
				case "rightBtn":
					scrollToX(300);
					break;
			}
		}
		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			rightBtn.visible = (threshold == 0);
			leftBtn.visible = (threshold == 300);
		}
		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = scrollPanel.scrollRect;
			var dValue:int = threshold - rect.x;
			if(Math.abs(dValue) < 35){
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}else if(dValue > 35){
				rect.x += 35;
			}else if(dValue < 35){
				rect.x -= 35;
			}
			scrollPanel.scrollRect = rect;
		}
		
		public function getTextRender(index:int):DieTobeStrongMeg{
			if(index >= 0 && index < textRenders.length){
				var tf:DieTobeStrongMeg = textRenders[index];
				if(null == tf){
					tf = new DieTobeStrongMeg();
					textRenders[index] = tf;
					panel.addToPane(tf);
				}
				return tf;
			}
			return null;
		}
		
		public function pushInfo(content:String):void{
			while(texts.length >= TEXT_MAX_COUNT){
				texts.shift();
			}
			texts.push(content);
			viewRenders();
		}
		
		private function viewRenders():void{
			var l:int = texts.length;
			for(var n:int = 0; n < l; n++){
				var text:DieTobeStrongMeg = getTextRender(n);
				if(null != text){
					text.updateinfo(texts[n]);
					text.y = 68*n;
				}
			}
		}
		
		public function updateInfo():void{
			for each(var item:DieTobeStrongStar in icons){
				item.updateStars();
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			Cmd_TobeStrong.cm_RISE_I();
		}
		
		public override function get width():Number{
			return 380;
		}
	}
}
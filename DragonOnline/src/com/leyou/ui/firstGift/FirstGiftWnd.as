package com.leyou.ui.firstGift
{
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.net.cmd.Cmd_ddsc;
	import com.leyou.ui.firstGift.children.FirstGiftBYBRender;
	import com.leyou.ui.firstGift.children.FirstGiftItemRender;
	import com.leyou.ui.firstGift.children.FirstGiftRender;
	import com.leyou.ui.firstGift.children.FirstGiftVipRender;
	import com.leyou.ui.firstGift.children.FirstGiftWeaponRender;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class FirstGiftWnd extends AutoWindow
	{
		public static const SCALE:Number = 0.96;
		
		private var timeLbl:Label;
		
		private var payBtn:ImgButton;
		
		private var points:Vector.<Point>;
		
		private var bybRender:FirstGiftBYBRender;
		
		private var vipRender:FirstGiftVipRender;
		
		private var itemRender:FirstGiftItemRender;
		
		private var weaponRender:FirstGiftWeaponRender;
		
		private var viewArr:Vector.<FirstGiftRender>;
		
		private var st:int;
		
		private var _tick:uint;

		private var remain:int;
		
		public function FirstGiftWnd(){
			super(LibManager.getInstance().getXML("config/ui/firstGift/schlWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			timeLbl = getUIbyID("timeLbl") as Label;
			payBtn = getUIbyID("payBtn") as ImgButton;
			payBtn.addEventListener(MouseEvent.CLICK, onPayClick);
			
			bybRender = new FirstGiftBYBRender();
			vipRender = new FirstGiftVipRender();
			itemRender = new FirstGiftItemRender();
			weaponRender = new FirstGiftWeaponRender();
			
			bybRender.addEventListener(MouseEvent.CLICK, onMouseClick);
			vipRender.addEventListener(MouseEvent.CLICK, onMouseClick);
			itemRender.addEventListener(MouseEvent.CLICK, onMouseClick);
			weaponRender.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addChild(itemRender);
			addChild(weaponRender);
			addChild(bybRender);
			addChild(vipRender);
			
			viewArr = new Vector.<FirstGiftRender>();
			viewArr.push(itemRender);
			viewArr.push(weaponRender);
			viewArr.push(bybRender);
			viewArr.push(vipRender);
			
			points = new Vector.<Point>();
			points.push(new Point(21, 246));
			points.push(new Point(148, 196));
			points.push(new Point(269, 146));
			points.push(new Point(423, 95));
			
			itemRender.x = points[0].x;
			itemRender.y = points[0].y;
			itemRender.scaleX = SCALE;
			itemRender.scaleY = SCALE;
			
			weaponRender.x = points[1].x;
			weaponRender.y = points[1].y;
			weaponRender.scaleX = SCALE;
			weaponRender.scaleY = SCALE;
			
			bybRender.x = points[2].x;
			bybRender.y = points[2].y;
			bybRender.scaleX = SCALE;
			bybRender.scaleY = SCALE;
			
			vipRender.x = points[3].x;
			vipRender.y = points[3].y;
			vipRender.scaleX = SCALE;
			vipRender.scaleY = SCALE;
		}
		
		protected function onPayClick(event:MouseEvent):void{
			if(0 == st){
				PayUtil.openPayUrl();
			}else if(1 == st){
				Cmd_ddsc.cm_DdscConfirm();
				itemRender.setItem();
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var target:FirstGiftRender = event.currentTarget as FirstGiftRender;
			var index:int = viewArr.indexOf(target);
			if(-1 != index){
				viewArr.splice(index, 1);
				viewArr.push(target);
				resetRenderPoint();
			}
		}
		
		private function resetRenderPoint():void{
			var l:int = viewArr.length;
			for(var n:int = 0; n < l; n++){
				var render:FirstGiftRender = viewArr[n];
				addChild(render);
				var pt:Point = points[n];
				TweenLite.to(render, 0.3, {x:pt.x, y:pt.y});
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		private function updateTime():void{
			var interval:int = (getTimer() - _tick);
			var remianT:int = remain*1000 - interval;
			timeLbl.text = DateUtil.formatTime(remianT, 2);
		}
		
		public function flyItem():void{
			itemRender.flyItem();
			hide();
		}
		
		public function updateInfo(obj:Object):void{
			_tick = getTimer();
			remain = obj.kf_stime;
			itemRender.updateInfo(obj);
			timeLbl.text = DateUtil.formatTime(int(obj.kf_stime)*1000, 2);
			st = obj.st;
			if(0 == st){
				payBtn.updataBmd("ui/ttsc/btn_cdxq.jpg");
				payBtn.setActive(true, 1, true);
			}else if(1 == st){
				payBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				payBtn.setActive(true, 1, true);
			}else if(2 == st){
				payBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				payBtn.setActive(false, 1, true);
			}
		}
	}
}
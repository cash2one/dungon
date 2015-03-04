package com.leyou.ui.market.child
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Market;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MarketWingRender extends AutoSprite
	{
		private var phAttLbl:Label;
		
		private var mpLbl:Label;
		
		private var critLvLbl:Label;
		
		private var magicAttLbl:Label;
		
		private var magicDefLbl:Label;
		
		private var hitLvLbl:Label;
		
		private var dodgeLvLbl:Label;
		
		private var hpLbl:Label;
		
		private var phDefLbl:Label;
		
		private var killLvLbl:Label;
		
		private var guaidLvLbl:Label;
		
		private var buyBtn:ImgButton;
		
//		private var num:RollNumWidget;
		
		private var infoXml:XML;
		
		private var toughLvLbl:Label;
		
		private var modeSwf:SwfLoader;
		
		public function MarketWingRender(){
			super(LibManager.getInstance().getXML("config/ui/market/marketWingRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			phAttLbl = getUIbyID("phAttLbl") as Label;
			mpLbl = getUIbyID("mpLbl") as Label;
			hpLbl = getUIbyID("hpLbl") as Label;
			critLvLbl = getUIbyID("critLvLbl") as Label;
			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			hitLvLbl = getUIbyID("hitLvLbl") as Label;
			dodgeLvLbl = getUIbyID("dodgeLvLbl") as Label;
			phDefLbl = getUIbyID("phDefLbl") as Label;
			killLvLbl = getUIbyID("killLvLbl") as Label;
			guaidLvLbl = getUIbyID("guaidLvLbl") as Label;
			buyBtn = getUIbyID("buyBtn")  as ImgButton;
			toughLvLbl = getUIbyID("toughLvLbl") as Label;
//			num = new RollNumWidget();
//			num.x = 0;
//			num.y = 14;
//			num.loadSource("ui/num/{num}_red.png");
//			addChild(num);
			modeSwf=new SwfLoader();
			modeSwf.x=300;
			modeSwf.y=300;
			addChild(modeSwf);
			
			buyBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(1216).content;
//			content = StringUtil.substitute(content, ConfigEnum.WingOpenCost, "翅膀");
//			PopupManager.showConfirm(content, Cmd_Market.cm_Mak_W, null, false, "wingOpen");
			PopupManager.showRadioConfirm(content,  ConfigEnum.WingOpenCost+"", ConfigEnum.WingOpenBindCost+"",onOK, null, false, "market.wing.open");
//			Cmd_Market.cm_Mak_W();
		}
		
		private function onOK(type:int):void{
			var rtype:int = (type == 0) ? 1 : 0;
			Cmd_Market.cm_Mak_W(rtype);
		}
		
		public function updateInfo():void{
			var tabel:XML = LibManager.getInstance().getXML("config/table/Wing_Base.xml");
			infoXml=tabel.child(0)[0];
			if(null != infoXml){
				hpLbl.text = "+"+infoXml.@W_AttNum1;
				mpLbl.text = "+"+infoXml.@W_AttNum2;
				phAttLbl.text = "+"+infoXml.@W_AttNum3;
				phDefLbl.text = "+"+infoXml.@W_AttNum4;
				magicAttLbl.text = "+"+infoXml.@W_AttNum5;
				magicDefLbl.text = "+"+infoXml.@W_AttNum6;
				critLvLbl.text = "+"+infoXml.@W_AttNum7;
				toughLvLbl.text = "+"+infoXml.@W_AttNum8;
				hitLvLbl.text = "+"+infoXml.@W_AttNum9;
				dodgeLvLbl.text = "+"+infoXml.@W_AttNum10;
				killLvLbl.text = "+"+infoXml.@W_AttNum11;
				guaidLvLbl.text = "+"+infoXml.@W_AttNum12;
				modeSwf.update(ConfigEnum.WingShowModeID); 
			}
//			num.setNum(ConfigEnum.WingOpenCost);
		}
		
		public function forbid():void{
			buyBtn.setActive(false, 1, true);
		}
		
		public override function die():void{
			infoXml = null;
		}
		
		public function flyMovie():void{
			var mpt:Point = modeSwf.localToGlobal(new Point(0, 0));
			var flyMovie:SwfLoader = new SwfLoader(ConfigEnum.WingShowModeID);
//			flyMovie.playAct("stand", 6);
			flyMovie.x = mpt.x;
			flyMovie.y = mpt.y;
			LayerManager.getInstance().windowLayer.addChild(flyMovie);
			var endW:int = flyMovie.width;
			var endH:int = flyMovie.height;
			var beginX:int = flyMovie.x + flyMovie.width*0.5;
			var beginY:int = flyMovie.y + flyMovie.height*0.5;
			var endX:int = UIEnum.WIDTH*0.5;
			var endY:int = UIEnum.HEIGHT*0.5;
			TweenMax.to(flyMovie, 3, {bezierThrough: [{x:beginX, y:beginY}, {x: endX, y: endY}], width: endW*0.5, height: endH*0.5, ease: Expo.easeIn(1,10,1,1), onComplete:onMoveOver, onCompleteParams:[flyMovie]})
		}
		
		private function onMoveOver(mc:SwfLoader):void{
			if(LayerManager.getInstance().windowLayer.contains(mc)){
				LayerManager.getInstance().windowLayer.removeChild(mc);
			}
			mc.die();
		}
	}
}
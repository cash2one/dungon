package com.leyou.ui.expCopy
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.expCopy.chlid.ExpCopyRender;
	
	import flash.events.TextEvent;
	
	public class ExpCopyWnd extends AutoSprite
	{
		private static const POINTS_MAX_NUM:int = 6;
		
		protected var commonCopy:ExpCopyRender;
		
		protected var doubleCopy:ExpCopyRender;
		
//		protected var doubleImg:Image;
		
//		protected var priceLbl:Label;
		
		protected var normalLbl:Label;
		
		protected var specialLbl:Label;
		
		protected var desLbl1:Label;
		
//		protected var desLbl2:Label;
		
//		private var tipsinfo:TipsInfo;
		
//		private var desLbl:Label;
//		
//		private var buttons:Vector.<ExpCopyButton>;
//		private var copyId:int;
		
		public function ExpCopyWnd(){
			super(LibManager.getInstance().getXML("config/ui/monsterScWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			commonCopy = new ExpCopyRender();
			commonCopy.id = 1;
			doubleCopy = new ExpCopyRender();
			doubleCopy.id = 2;
			commonCopy.x = 5;
			commonCopy.y = 10;
			doubleCopy.x = 390;
			doubleCopy.y = 10;
			addChild(commonCopy);
			addChild(doubleCopy);
			
//			doubleImg = getUIbyID("doubleImg") as Image;
//			priceLbl = getUIbyID("priceLbl") as Label;
			normalLbl = getUIbyID("normalLbl") as Label;
			specialLbl = getUIbyID("specialLbl") as Label;
			desLbl1 = getUIbyID("desLbl1") as Label;
//			desLbl2 = getUIbyID("desLbl2") as Label;
			
			swapChildren(normalLbl, commonCopy);
			swapChildren(specialLbl, doubleCopy);
			
			var notice1:TNoticeInfo = TableManager.getInstance().getSystemNotice(5201);
//			var notice2:TNoticeInfo = TableManager.getInstance().getSystemNotice(5202);
			desLbl1.htmlText = notice1.content;
//			desLbl2.htmlText = notice2.content;
			normalLbl.htmlText = TableManager.getInstance().getSystemNotice(5208).content;
			specialLbl.htmlText = TableManager.getInstance().getSystemNotice(5209).content;
//			desLbl2.mouseEnabled = true;
//			desLbl2.addEventListener(TextEvent.LINK, onMouseClick);
//			var style:StyleSheet = new StyleSheet();
//			style.setStyle("a:hover", {color:"#ff0000"});
//			desLbl2.styleSheet = style;
//			tipsinfo = new TipsInfo();
			
//			desLbl = getUIbyID("desLbl") as Label;
//			buttons = new Vector.<ExpCopyButton>(POINTS_MAX_NUM);
//			desLbl.text = TableManager.getInstance().getSystemNotice(5201).content;
//			
//			var copyInfo:TExpCopyInfo = TableManager.getInstance().getExpCopyInfo(1);
//			copyId = copyInfo.id;
//			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(copyInfo.sceneId+"");
//			var sUlr:String = PlayerEnum.URL_SCENE + sceneInfo.mapRes + "/map.jpg";
//			previewImg.updateBmp(sUlr, null, false, 500, 450);
			// 45级是起始等级,跨度10级
//			var level:int = 45;
//			var points:Vector.<int> = copyInfo.points;
//			var length:int = points.length;
//			for(var n:int = 0; n < POINTS_MAX_NUM; n++){
//				var cb:ExpCopyButton = buttons[n];
//				if(null == cb){
//					cb = new ExpCopyButton()
//					cb.addEventListener(MouseEvent.CLICK, onMouseClick);
//					pane.addChild(cb);
//					buttons[n] = cb;
//				}
//				if(n < length){
//					cb.visible = true;
//					cb.pointId = points[n];
//					var point:TPointInfo = TableManager.getInstance().getPointInfo(points[n]);
//					cb.x = point.tx*50/copyInfo.sceneWidth*500 - cb.width*0.5;
//					cb.y = point.ty*25/copyInfo.sceneHeight*450 - cb.height/3*0.5;
//					cb.setLv(level);
//				}else{
//					cb.visible = false;
//				}
//				level += 10;
//			}
			
			x = 3;
			y = 3;
		}
		
//		protected function onMouseClick(event:MouseEvent):void{
//			var btn:ImgButton = event.target as ImgButton;
//			Cmd_EXPC.cm_Exp_E(copyId, (btn.parent as ExpCopyButton).pointId);
//		}
		
		protected function onMouseClick(event:TextEvent):void{
//			var index:int = desLbl2.getCharIndexAtPoint(desLbl2.mouseX, desLbl2.mouseY);
//			if(index < 0){
//				return;
//			}
//			var link:Vector.<String> = new Vector.<String>();
//			var reg:RegExp = /<A.*?<\/A>/g;
//			var subReg:RegExp = /U>.*?<\//g;
//			var text:String = desLbl2.text;
//			var html:String = desLbl2.htmlText;
//			var links:Array = html.match(reg);
//			var c:int = links.length;
//			for(var n:int = 0; n < c; n++){
//				var subStrs:Array = links[n].match(subReg);
//				var subStr:String = subStrs[0].slice(2,-2);
//				var lb:int = text.indexOf(subStr);
//				if(-1 != lb){
//					if(index > lb && index < (lb+subStr.length)){
//						tipsinfo.itemid = int(event.text);
//						ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(stage.mouseX, stage.mouseY));
//						break;
//					}
//				}
//			}
		}
		
//		protected function onTextLink(event:TextEvent):void{
//			tipsinfo.itemid = int(event.text);
//			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(stage.mouseX, stage.mouseY));
//		}
		
//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//			Cmd_EXPC.cm_Exp_I();
//		}
		
		public function updateCopy(obj:Object):void{
//			doubleImg.updateBmp("ui/num/"+obj.two.bl+"_lzs.png");
//			priceLbl.text = obj.two.money;
//			openLbl.text = obj.box.cc + "/" + obj.box.cm;
		}
		
		public function removeGuide():void{
			GuideManager.getInstance().removeGuide(83);
		}
	}
}
package com.leyou.ui.expCopy.chlid
{
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TExpCopyInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_EXPC;
	
	import flash.events.MouseEvent;
	
	public class ExpMapWnd extends AutoWindow
	{
		private static const POINTS_MAX_NUM:int = 6;
		
		private var copyId:int;
		
		private var previewImg:Image;  
		
		private var desLbl:Label;
		
		private var rateLbl:Label;
		
		private var priceLbl:Label;
		
		private var costLbl:Label;
		
		private var moneyImg:Image;
		
		private var buttons:Vector.<ExpCopyButton>;
		
		public function ExpMapWnd(){
			super(LibManager.getInstance().getXML("config/ui/sceneCopy/monsterScPanel.xml"));
			init();
		}
		
		private function init():void{
			previewImg = getUIbyID("previewImg") as Image;
			moneyImg = getUIbyID("moneyImg") as Image;
			costLbl = getUIbyID("costLbl") as Label;
			rateLbl = getUIbyID("rateLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			priceLbl = getUIbyID("priceLbl") as Label;
			buttons = new Vector.<ExpCopyButton>(POINTS_MAX_NUM);
			hideBg();
			clsBtn.x -= 6;
			clsBtn.y -= 11;
		}
		
		public function loadMap($copyId:int):void{
			copyId = $copyId;
			var copyInfo:TExpCopyInfo = TableManager.getInstance().getExpCopyInfo(copyId);
			desLbl.visible = (copyInfo.moneyCost > 0);
			rateLbl.visible = (copyInfo.moneyCost > 0);
			costLbl.visible = (copyInfo.moneyCost > 0);
			moneyImg.visible = (copyInfo.moneyCost > 0);
			priceLbl.visible = (copyInfo.moneyCost > 0);
			priceLbl.text = int(Math.pow(Core.me.info.level/45, 2) * copyInfo.moneyCost) + "/分钟";
			
			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(copyInfo.sceneId+"");
			var sUlr:String = PlayerEnum.URL_SCENE + sceneInfo.mapRes + "/map.jpg";
			previewImg.updateBmp(sUlr, null, false, 500, 450);
			// 45级是起始等级,跨度10级
			var level:int = 45;
			var points:Vector.<int> = copyInfo.points;
			var length:int = points.length;
			for(var n:int = 0; n < POINTS_MAX_NUM; n++){
				var cb:ExpCopyButton = buttons[n];
				if(null == cb){
					cb = new ExpCopyButton();
					cb.addEventListener(MouseEvent.CLICK, onMouseClick);
					addChild(cb);
					buttons[n] = cb;
				}
				if(n < length){
					cb.visible = true;
					cb.pointId = points[n];
					var point:TPointInfo = TableManager.getInstance().getPointInfo(points[n]);
					cb.x = point.tx*50/copyInfo.sceneWidth*500 - cb.width*0.5;
					cb.y = point.ty*25/copyInfo.sceneHeight*450 - cb.height/3*0.5;
					cb.setLv(level);
				}else{
					cb.visible = false;
				}
				level += 10;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var btn:ImgButton = event.target as ImgButton;
			Cmd_EXPC.cm_Exp_E(copyId, (btn.parent as ExpCopyButton).pointId);
		}
	}
}
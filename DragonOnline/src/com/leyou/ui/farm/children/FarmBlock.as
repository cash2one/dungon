package com.leyou.ui.farm.children
{
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFarmLandInfo;
	import com.ace.gameData.table.TFarmPlantInfo;
	import com.ace.manager.CursorManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.FarmEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * 土地块
	 * @author wfh
	 * 
	 */	
	public class FarmBlock extends Sprite
	{
		// 土地状态
		private var _status:int;
		
		// 背景
		private var bg:ImgButton;
		
		// 植株
		private var maskImg:Image;
		
		// 收获
		private var reapBtn:ImgButton;
		
		private var reapContainer:Sprite;
		
		// 铲除
		private var unearthBtn:ImgButton;
		
		// 加速
		private var accelerateBtn:ImgButton;
		
		private var uaContainer:Sprite;
		
		// 土地块编号
		public var blockId:int;
		
		// 种植植株编号
		public var seedId:int = 1;
		
		// 等级
		public var level:int = 1;
		
		// 种植时间戳
		public var growTick:uint;
		
		// 提示文本
		private var text:TextField;
		
		public function FarmBlock(){
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		protected function init():void{
			bg = new ImgButton("ui/farm/farm_land_01.png");
			bg.mouseEnabled = false;
			addChild(bg);
			
			maskImg = new Image();
			addChild(maskImg);
			
			reapBtn = new ImgButton("ui/farm/btn_tq_bar.png");
			reapContainer =  new Sprite();
			reapContainer.addChild(new Image("ui/farm/btn_bg.png"));
			reapContainer.addChild(reapBtn);
			addChild(reapContainer);
			reapContainer.x = 30;
			reapContainer.y = -85;
			reapContainer.visible = false;
			
			unearthBtn = new ImgButton("ui/farm/btn_chanchu.png");
			unearthBtn.x = 7;
			unearthBtn.y = 7;
			accelerateBtn = new ImgButton("ui/farm/btn_jiasu.png");
			accelerateBtn.x = 46 + 7;
			accelerateBtn.y = 7;
			
			uaContainer = new Sprite();
			uaContainer.addChild(new Image("ui/farm/btn_bg.png"));
			var img:Image = new Image("ui/farm/btn_bg.png");
			img.x = 46;
			uaContainer.addChild(img);
			uaContainer.addChild(unearthBtn);
			uaContainer.addChild(accelerateBtn);
			addChild(uaContainer);
			uaContainer.visible = false;
			uaContainer.y = -40;
			
//			text = new TextField();
			
//			mouseChildren = false;
//						var g:Graphics = graphics;
//						g.clear();
//						g.lineStyle(1, 0xff0000);
//						g.drawRect(0, 0, width, height/3);
//						g.endFill();
		}
		
		public function get isLock():Boolean{
			return (FarmEnum.BLOCK_LOCK == _status || FarmEnum.BLOCK_ABLEUNLOCK == _status);
		}
		
		public function get isRipe():Boolean{
			return (FarmEnum.BLOCK_RIPE == _status);
		}
		
		public function get beSteal():Boolean{
			return (FarmEnum.BLOCK_RIPE_REMAIN == _status);
		}
		
		/**
		 * <T>鼠标指向状态</T>
		 * 
		 */
		public function mouseOver():void{
			bg.turnOn(false);
			maskImg.filters = [FilterUtil.yellowGlowFilter];
			if(FarmEnum.BLOCK_RIPE == _status){
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
			}else{
				CursorManager.getInstance().resetGameCursor();
			}
			if(UIManager.getInstance().farmWnd.isOwner()){
				var content:String;
				switch(_status){
					case FarmEnum.BLOCK_GROWING:
						uaContainer.visible = true;
						break;
					case FarmEnum.BLOCK_LOCK:
						content = TableManager.getInstance().getSystemNotice(2733).content;
						var landInfo:TFarmLandInfo = TableManager.getInstance().getLandInfo(blockId);
						content = StringUtil.substitute(content, landInfo.openLv);
						ToolTipManager.getInstance().showNoHide(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
						break;
					case FarmEnum.BLOCK_UNLOCK:
						content = TableManager.getInstance().getSystemNotice(2734).content;
						content = StringUtil.substitute(content, level);
						ToolTipManager.getInstance().showNoHide(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
						break;
				}
			}
		}
		
		/**
		 * <T>鼠标移开</T>
		 * 
		 */
		public function mouseOut():void{
			bg.turnOff(false);
			maskImg.filters = null;
			CursorManager.getInstance().resetGameCursor();
			if(UIManager.getInstance().farmWnd.isOwner()){
				uaContainer.visible = false;
				ToolTipManager.getInstance().hide();
			}
		}
		
		/**
		 * <T>更新土地信息</T>
		 * 
		 */
		public function updateStatus(obj:Object):void{
			_status = obj.c;
			seedId = obj.s;
			level = obj.l;
			var k:String = com.leyou.utils.StringUtil_II.lpad(level+"", 2, "0");
			bg.updataBmd("ui/farm/farm_land_" + k + ".png");
			maskImg.visible = true;
			reapContainer.visible = false;
			switch(_status){
				case FarmEnum.BLOCK_LOCK:
					maskImg.x = 42;
					maskImg.y = 10;
					maskImg.visible = true;
					maskImg.updateBmp("ui/farm/icon_suodin.png");
					break;
				case FarmEnum.BLOCK_ABLEUNLOCK:
					maskImg.x = 42; 
					maskImg.y = 10;
					maskImg.visible = true;
					maskImg.updateBmp("ui/farm/icon_jiesuo.png");
					break;
				case FarmEnum.BLOCK_UNLOCK:
					maskImg.visible = false;
					break;
				case FarmEnum.BLOCK_GROWING:
					var plantInfo:TFarmPlantInfo = TableManager.getInstance().getPlant(seedId);
					growTick = (new Date().time - (plantInfo.growTime - obj.t)*1000)/1000;
					maskImg.x = 5;
					maskImg.y = -40;
					maskImg.visible = true;
					maskImg.updateBmp("ui/farm/"+plantInfo.avatar1);
					break;
				case FarmEnum.BLOCK_RIPE:
					var plant:TFarmPlantInfo = TableManager.getInstance().getPlant(seedId);
					growTick = (new Date().time - (plant.growTime - obj.t)*1000)/1000;
					maskImg.x = 5;
					maskImg.y = -40;
					maskImg.visible = true;
					reapContainer.visible = true;
					maskImg.updateBmp("ui/farm/"+plant.avatar2);
					break;
				case FarmEnum.BLOCK_RIPE_REMAIN:
					var pnt:TFarmPlantInfo = TableManager.getInstance().getPlant(seedId);
					growTick = (new Date().time - (pnt.growTime - obj.t)*1000)/1000;
					maskImg.x = 5;
					maskImg.y = -40;
					maskImg.visible = true;
					maskImg.updateBmp("ui/farm/"+pnt.avatar2);
					if(UIManager.getInstance().farmWnd.isOwner()){
						reapContainer.visible = true;
					}
					break;
			}
		}
		
		/**
		 * <T>鼠标点击</T>
		 * 
		 */
		public function onMouseClick(target:Object):void{
			ToolTipManager.getInstance().hide();
			switch(_status){
				case FarmEnum.BLOCK_LOCK:
					if(UIManager.getInstance().farmWnd.isOwner()){
//						var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(2724);
//						NoticeManager.getInstance().broadcast(notice);
						NoticeManager.getInstance().broadcastById(2724);
					}
					break;
				case FarmEnum.BLOCK_ABLEUNLOCK: 
					if(UIManager.getInstance().farmWnd.isOwner()){
//						var c:String = TableManager.getInstance().getSystemNotice(2721).content;
						var landInfo:TFarmLandInfo = TableManager.getInstance().getLandInfo(blockId);
						UIManager.getInstance().showWindow(WindowEnum.FARMMESSAGE);
						UIManager.getInstance().farmMWnd.loadInfo(blockId, landInfo)
//						c = com.ace.utils.StringUtil.substitute(c, cost);
//						PopupManager.showConfirm(c, callbackOpen, null, false, "wind.confirm.unlock");
						GuideManager.getInstance().removeGuide(25);
					}
					break;
				case FarmEnum.BLOCK_UNLOCK:
					if(UIManager.getInstance().farmWnd.isOwner()){
						UIManager.getInstance().farmShopWnd.loadBlock(this);
						UIManager.getInstance().farmShopWnd.show();
						GuideManager.getInstance().removeGuide(26);
					}
					break;
				case FarmEnum.BLOCK_GROWING:
					var content:String;
					var plant:TFarmPlantInfo = TableManager.getInstance().getPlant(seedId);
					if(unearthBtn == target){
						content= TableManager.getInstance().getSystemNotice(2719).content;
						PopupManager.showConfirm(content, callbackUnearth, null, false, "farm.block.unearth");
						uaContainer.visible = false;
					}else if(accelerateBtn == target){
						content= TableManager.getInstance().getSystemNotice(2718).content;
						var remain:int = plant.growTime - (new Date().time / 1000 - growTick);
						var yb:int = Math.ceil(remain/60/30)*int(ConfigEnum.FarmCatalyticCopeCost.split("|")[0]);
						var byb:int = Math.ceil(remain/60/30)*int(ConfigEnum.FarmCatalyticCopeCost.split("|")[1]);
						content = com.ace.utils.StringUtil.substitute(content, plant.name, int(remain/60), plant.growTime/2/3600);
						PopupManager.showRadioConfirm(content, yb+"", byb+"", callbackAccelerate, null, false, "farm.block.accelerate");
						uaContainer.visible = false;
					}
					break;
				case FarmEnum.BLOCK_RIPE:
					if(UIManager.getInstance().farmWnd.isOwner()){
						Cmd_Farm.cm_FAM_H(blockId+"");
						GuideManager.getInstance().removeGuide(27);
					}else{
						Cmd_Farm.cm_FAM_H(blockId+"", UIManager.getInstance().farmWnd.ownerName);
					}
					break;
				case FarmEnum.BLOCK_RIPE_REMAIN:
					if(UIManager.getInstance().farmWnd.isOwner()){
						Cmd_Farm.cm_FAM_H(blockId+"");
					}else{
//						var n:TNoticeInfo = TableManager.getInstance().getSystemNotice(2726);
//						NoticeManager.getInstance().broadcast(n);
						NoticeManager.getInstance().broadcastById(2726);
					}
					break;
			}
		}
		
		/**
		 * <T>铲除作物回调</T>
		 * 
		 */		
		protected function callbackUnearth():void{
			Cmd_Farm.cm_FAM_C(blockId);
		}
		
		/**
		 * <T>作物加速回调</T>
		 * 
		 */		
		protected function callbackAccelerate(type:int):void{
			var rtype:int = (type == 0) ? 2 : 1;
			Cmd_Farm.cm_FAM_S(blockId, rtype);
		}
		
		/**
		 * <T>确认开启</T>
		 * 
		 */		
//		private function callbackOpen():void{
//			Cmd_Farm.cm_FAM_O(blockId);
//		}
		
		/**
		 * <T>是否是生长状态</T>
		 * 
		 */		
		public function showTip():Boolean{
			return (FarmEnum.BLOCK_GROWING == _status || FarmEnum.BLOCK_RIPE == _status || FarmEnum.BLOCK_RIPE_REMAIN == _status);
		}
		
		/**
		 * 显示收益
		 * 
		 */		
		public function showNotice(nid:int, values:Array):void{
			if(null == text){
				text = new TextField();
				text.textColor = 0xff0000;
				text.filters = [FilterEnum.hei_miaobian];
				text.selectable = false;
				text.mouseEnabled = false;
				addChild(text);
			}
			text.visible = true;
			var content:String = TableManager.getInstance().getSystemNotice(nid).content;
			content = com.ace.utils.StringUtil.substitute(content, values);
			text.htmlText = content;
			text.y = 0;
			TweenLite.to(text, 1, {y:text.y-80, onComplete:moveOver});
			function moveOver():void{
				text.visible = false;
			}
		}
	}
}
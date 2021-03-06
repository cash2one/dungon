package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.child.TitleRender;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallRewardInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.dargonball.DragonBallData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DragonBallCollectionRender extends AutoSprite
	{
		private const BallLocation:Array = [new Point(126, 258), new Point(108, 144), new Point(165, 48), new Point(275, 11), new Point(382, 46), new Point(441, 144), new Point(423, 258), new Point(330, 335), new Point(215, 335)];
		
		private static const BALL_NUM:uint = 9;
		
		private var bgImg:Image;
		
		private var ruleLbl:Label;
		
		private var callDragonBtn:ImgButton;
		
		//		private var previewBtn:NormalButton;
		
		private var balls:Vector.<DragonBallCollectionItem>;
		
		//		private var currentItem:DragonBallCollectionItem;
		
		private var desLbl:Label;
		
		private var currentStatus:int;
		
		private var isFirst:Boolean = true;
		
		private var addPropertyLbl:TextField;
		
		private var titleImg:TitleRender;
		
		//		31527|31528|31529|31530|31531|31532|31533
		public function DragonBallCollectionRender(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall1Render.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			ruleLbl = getUIbyID("rulerLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			titleImg = new TitleRender();
			addChild(titleImg);
			titleImg.x = 215;
			titleImg.y = 126;
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			callDragonBtn = getUIbyID("callDragonBtn") as ImgButton;
			//			previewBtn = getUIbyID("previewBtn") as NormalButton;
			callDragonBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			//			previewBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			balls = new Vector.<DragonBallCollectionItem>(BALL_NUM);
			for(var n:int = 0; n < BALL_NUM; n++){
				var item:DragonBallCollectionItem = balls[n];
				if(null == item){
					item = new DragonBallCollectionItem();
					addChild(item);
					balls[n] = item;
				}
				BallLocation[n].x += 30;
				BallLocation[n].y += 30;
				item.x = BallLocation[n].x;
				item.y = BallLocation[n].y;
				item.updateInfo(n+1);
				//				item.registerSelect(onChoice);
			}
			addPropertyLbl = new TextField();
			addPropertyLbl.visible = false;
			addPropertyLbl.autoSize = TextFieldAutoSize.LEFT;
			addPropertyLbl.defaultTextFormat = new TextFormat(null, 12, 0xff00);
			addChild(addPropertyLbl);
			addPropertyLbl.filters = [FilterEnum.hei_miaobian];
			var titleInfo1:TTitle = TableManager.getInstance().getTitleByID(ConfigEnum.DragonBall11);
			titleImg.updateInfo(titleInfo1);
//			bgImg.filters = [FilterEnum.enable];
		}
		
		//		protected function onChoice(item:DragonBallCollectionItem):void{
		//			currentItem = item;
		//		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "callDragonBtn":
					Cmd_Longz.cm_Longz_A();
					break;
				//				case "previewBtn":
				//					UIManager.getInstance().showWindow(WindowEnum.DRAGON_PROVIEW);
				//					break;
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(20001).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo():void{
			var data:DragonBallData = DataManager.getInstance().dragonBallData;
			callDragonBtn.setActive(data.collectComplete(), 1, true);
			callDragonBtn.visible = (0 == data.status);
			//			bgImg.filters = (0 == data.status) ? [FilterEnum.enable] : null;
			var cid:int = (0 == data.status) ? 20002 : 20003;
			desLbl.text = TableManager.getInstance().getSystemNotice(cid).content;
			//			if(currentStatus != data.status){
			//				currentStatus = data.status;
			// 背景图
			//				if(0 == data.status){
			//					TweenMax.to(bgImg, 1, {colorMatrixFilter:{colorize:0xcccccc, amount:1}})
			//					updateItemInfo();
			//				}else if(1 == data.status){
			//					TweenMax.to(bgImg, 1, {colorMatrixFilter:{amount:1}});
			//					if(!isFirst){
			//						toCentre();
			//					}else{
			updateItemInfo();
			//					}
			//				}
			//			}else{
			//				updateItemInfo();
			//			}
		}
		
		private var moveNum:int;
		
		private function toCentre():void{
			moveNum = BALL_NUM;
			for(var n:int = 0; n < BALL_NUM; n++){
				var item:DragonBallCollectionItem = balls[n];
				TweenMax.to(item, 1, {x:306, y:206, bezier:[{x:306, y:360}], onComplete:toCenMoveOver});
			}
		}
		
		private function toCenMoveOver():void{
			moveNum--;
			if(moveNum <= 0){
//				updateItemInfo();
				toLocal();
				addPropertyLbl.visible = true;
				var info:TDragonBallRewardInfo = TableManager.getInstance().getDragonBallReward(1);
				addPropertyLbl.text = StringUtil.substitute(PropUtils.getStringById(2195), info.energy_num);
				addPropertyLbl.x = (613 - addPropertyLbl.width)*0.5;
				addPropertyLbl.y = 204;
				TweenMax.to(addPropertyLbl, 1.5, {y:addPropertyLbl.y-100, onComplete:onLblMoveOver});
			}
		}
		
		private function onLblMoveOver():void{
			addPropertyLbl.visible = false;
		}
		
		private function toLocal():void{
			for(var n:int = 0; n < BALL_NUM; n++){
				var item:DragonBallCollectionItem = balls[n];
				var pt:Point = BallLocation[n];
				TweenMax.to(item, 1, {x:pt.x, y:pt.y, bezier:[{x:306, y:360}]});
			}
		}
		
		public function updateItemInfo():void{
			isFirst = false;
			var data:DragonBallData = DataManager.getInstance().dragonBallData;
			var l:int = data.getItemLength();
			for(var n:int = 0; n < l; n++){
				balls[n].updateStatus(data.getItemID(n), data.getItemNum(n));
			}
		}
		
		public function flyReward():void{
			//			if(null != currentItem){
			//				FlyManager.getInstance().flyBags([currentItem.itemId], [currentItem.localToGlobal(new Point(0,0))]);
			//			}
		}
		
		public function updateCollectionReward():void{
			toCentre();
		}
	}
}
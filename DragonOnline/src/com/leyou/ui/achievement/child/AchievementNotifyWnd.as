package com.leyou.ui.achievement.child
{
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.data.achievement.AchievementEraData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PlayerUtil;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class AchievementNotifyWnd extends AutoWindow
	{
		private var leftImg:Image;
		
		private var rightImg:Image;
		
		private var bgImg:Image;
		
		private var msk:Shape;
		
		private var item:AchievementEraItem;
		
		private var currentX:int;
		
		private var currentWidth:int;
		
		private var nameLbl:Label;
		
		private var headImg:Image;
		
		private var rankOpenImg:Image;
		
		public function AchievementNotifyWnd(){
			super(LibManager.getInstance().getXML("config/ui/achievement/achievementNotify.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			mouseChildren = false;
			mouseEnabled = false;
			clsBtn.visible = false;
			bgImg = getUIbyID("bgImg") as Image;
			leftImg = getUIbyID("leftImg") as Image;
			rightImg = getUIbyID("rightImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			headImg = getUIbyID("headImg") as Image;
			rankOpenImg = getUIbyID("rankOpenImg") as Image;
			
			item = new AchievementEraItem();
//			pane.addChildAt(bgImg, 0);
			pane.addChildAt(item, 1);
			item.x = 44;
			item.y = 64;
			addChild(leftImg);
			addChild(rightImg);
			msk = new Shape();
			pane.addChild(msk);
			pane.mask = msk;
			// w = 650 h = 180
		}
		
		public override function get width():Number{
			if(bgImg.isLoaded){
				return bgImg.width;
			}else{
				return super.width;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, true);
			y = UIEnum.HEIGHT - height - 165;
			if(!hasEventListener(Event.ENTER_FRAME)){
				currentX = 324;
				currentWidth = 2;
				var g:Graphics = msk.graphics;
				g.clear();
				g.beginFill(0);
				g.drawRect(currentX, -10, currentWidth, 190);
				g.endFill();
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				leftImg.x = currentX - 99;
				rightImg.x = currentX + currentWidth;
			}
			alpha = 1;
			DelayCallManager.getInstance().add(this, tweenHide, "achievement.notify", stage.frameRate*5);
		}
		
		public function tweenHide():void{
			TweenLite.to(this, 1, {alpha:0, onComplete:hide});
		}
		
		protected function onEnterFrame(event:Event):void{
			currentX -= 8;
			currentWidth += 16;
			if(currentX <= 0){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			leftImg.x = currentX - 99;
			rightImg.x = currentX + currentWidth;
			var g:Graphics = msk.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(currentX, -10, currentWidth, 190);
			g.endFill();
		}
		
		public function updateInfo(data:AchievementEraData, school:int, gander:int):void{
			var info:TAchievementInfo = TableManager.getInstance().getAchievementInfo(data.tid);
			item.update(info);
			item.updateByData(data);
			item.hideName();
			nameLbl.text = data.name;
			headImg.updateBmp(PlayerUtil.getPlayerHeadImg(school, gander), null, false, -1, -1, PriorityEnum.FIVE);
			rankOpenImg.visible = true;
			var rankImgUrl:String;
			switch(data.tid){
				case ConfigEnum.rank1:
					rankImgUrl = "ui/history/kqzlphb.png";
					break;
				case ConfigEnum.rank2:
					rankImgUrl = "ui/history/kqzbzlb.png";
					break;
				case ConfigEnum.rank3:
					rankImgUrl = "ui/history/kqzqzlb.png";
					break;
				case ConfigEnum.rank4:
					rankImgUrl = "ui/history/kqcbzlb.png";
					break;
				case ConfigEnum.rank5:
					rankImgUrl = "ui/history/kqjxjf.png";
					break;
				case ConfigEnum.rank7:
					rankImgUrl = "ui/history/kqdjphb.png";
					break;
				case ConfigEnum.rank8:
					rankImgUrl = "ui/history/kqcfphb.png";
					break;
				default:
					rankOpenImg.visible = false;
					break;
			}
			rankOpenImg.updateBmp(rankImgUrl);
		}
	}
}
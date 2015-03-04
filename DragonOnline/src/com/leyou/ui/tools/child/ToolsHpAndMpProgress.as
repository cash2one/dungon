package com.leyou.ui.tools.child {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class ToolsHpAndMpProgress extends AutoSprite {

		private var hpSwf:SwfLoader;
		private var mpSwf:SwfLoader;

		private var hpTopSwf:SwfLoader;
		private var mpTopSwf:SwfLoader;

		private var hpSpr:Sprite;
		private var mpSpr:Sprite;

		private var hpTopMask:Sprite;
		private var mpTopMask:Sprite;

		private var sliderBtn:Sprite;

		private var hpTip:Sprite;
		private var mpTip:Sprite;

		private var isDown:Boolean=false;

		private var hpshow:Boolean=false;
		private var mpshow:Boolean=false;

		private var mptween:TweenLite;
		private var mptoptween:TweenLite;

		private var hpstate:Boolean=false;
		private var mpstate:Boolean=false;

		private var myExe:Number=0;

		public function ToolsHpAndMpProgress() {
			super(LibManager.getInstance().getXML("config/ui/tools/ToolsHpWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		/**
		 *<mx:SWFLoader x="368.5" y="2" source="ui/effect/eft_ui_hp.sif" pnfId="99970" id="hpSwf"/>
		<mx:SWFLoader x="367.5" y="2" source="ui/effect/eft_ui_mp.sif" pnfId="99971" id="mpSwf"/>
		 *
		 */
		private function init():void {
			var slider:Image=this.getUIbyID("slider") as Image;
			this.hpSwf=this.getUIbyID("hpSwf") as SwfLoader;
			this.mpSwf=this.getUIbyID("mpSwf") as SwfLoader;

			this.hpTopSwf=new SwfLoader(99967);
			this.mpTopSwf=new SwfLoader(99968);

			this.hpTopSwf.x=12;
			this.mpTopSwf.x=20;

			this.addChildAt(this.hpTopSwf, 2);
			this.addChildAt(this.mpTopSwf, 2);

			this.hpSpr=new Sprite(); //new Image("ui/common/1.png");
			this.hpSpr.graphics.beginFill(0x000000);
			this.hpSpr.graphics.drawRect(0, 0, 50, 110);
			this.hpSpr.graphics.endFill();

			this.addChildAt(this.hpSpr, 1);
//			this.addChild(this.hpSpr);

			this.hpSpr.x=20;
			this.hpSpr.y=110;

			this.hpSwf.mask=this.hpSpr;

			this.mpSpr=new Sprite(); //new Image("ui/common/2.png");
			this.mpSpr.graphics.beginFill(0x000000);
			this.mpSpr.graphics.drawRect(0, 0, 50, 110);
			this.mpSpr.graphics.endFill();

			this.addChildAt(this.mpSpr, 1);
//			this.addChild(this.mpSpr);

			this.mpSpr.x=70;
			this.mpSpr.y=110;

			this.mpSwf.mask=this.mpSpr;

			this.hpTopMask=new Sprite();
			this.hpTopMask.graphics.beginFill(0x000000);
			this.hpTopMask.graphics.drawCircle(0, 0, 52);
			this.hpTopMask.graphics.endFill();

			this.addChild(this.hpTopMask);
			this.hpTopMask.x=72;
			this.hpTopMask.y=56;

			this.hpTopSwf.mask=this.hpTopMask;

			this.mpTopMask=new Sprite();
			this.mpTopMask.graphics.beginFill(0x000000);
			this.mpTopMask.graphics.drawCircle(0, 0, 52);
			this.mpTopMask.graphics.endFill();

			this.addChild(this.mpTopMask);
			this.mpTopMask.x=72;
			this.mpTopMask.y=56;

			this.mpTopSwf.mask=this.mpTopMask;

			this.hpTip=new Sprite();
			this.hpTip.graphics.beginFill(0x000000);
			this.hpTip.graphics.drawRect(0, 0, 50, 110);
			this.hpTip.graphics.endFill();

			this.addChild(this.hpTip);
			this.hpTip.x=20;

			this.hpTip.alpha=0;

			this.mpTip=new Sprite();
			this.mpTip.graphics.beginFill(0x000000);
			this.mpTip.graphics.drawRect(0, 0, 50, 110);
			this.mpTip.graphics.endFill();

			this.addChild(this.mpTip);

			this.mpTip.x=70;

			this.mpTip.alpha=0;

			this.sliderBtn=new Sprite();
			this.sliderBtn.addChild(slider);
			this.addChild(this.sliderBtn);

			this.sliderBtn.x=slider.x;
			this.sliderBtn.y=slider.y;

			slider.x=0;
			slider.y=0;

//			this.hpSpr.mouseChildren=this.hpSpr.mouseEnabled=false;
//			this.mpSpr.mouseChildren=this.hpSpr.mouseEnabled=false;

			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			this.sliderBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.sliderBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.hpTip.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.hpTip.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.mpTip.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.mpTip.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

//			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);

			LayerManager.getInstance().windowLayer.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseOver(e:MouseEvent):void {

			this.hpshow=false;
			this.mpshow=false;

			if (e.target == this.hpTip) {
				hpshow=true;
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9522).content, [Core.me.info.baseInfo.hp, Core.me.info.baseInfo.maxHp, int(Core.me.info.baseInfo.hp / Core.me.info.baseInfo.maxHp * 100) + "%"]), new Point(e.stageX, e.stageY));
			} else if (e.target == this.mpTip) {
				mpshow=true;
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9523).content, [Core.me.info.baseInfo.mp, Core.me.info.baseInfo.maxMp, int(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp * 100) + "%", ConfigEnum.manaRevive]), new Point(e.stageX, e.stageY));
			} else if (e.target == this.sliderBtn) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9907).content, [int((1 - this.sliderBtn.y / 80) * 100) + "%"]), new Point(e.stageX, e.stageY));
			}

		}


		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();

			this.hpshow=false
			this.mpshow=false

//			this.isDown=false;
		}

		private function onMouseDown(e:MouseEvent):void {
			if (e.target == this.sliderBtn) {
				this.isDown=true;
				this.sliderBtn.startDrag(false, new Rectangle(36, 0, 1, 80));
			}
		}

		private function onMouseMove(e:MouseEvent):void {

//			trace(e.target,e.currentTarget,this.dropTarget,this.sliderBtn.y/80)
//			if (this.isDown) {
			if (e.target == this.sliderBtn) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9907).content, [int((1 - this.sliderBtn.y / 80) * 100) + "%"]), new Point(e.stageX, e.stageY));
			}

			if (this.isDown) {
				AssistWnd.getInstance().setProgress(1 - this.sliderBtn.y / 80, -1);
			}
//			}
		}


		private function onMouseUp(e:MouseEvent):void {
			if (this.isDown) {
				this.sliderBtn.stopDrag();
				GuideManager.getInstance().removeGuide(69);
				AssistWnd.getInstance().saveConfig()
				this.isDown=false;
			}
//			trace("out side");
		}

		public function updateSlider(progress:Number):void {
			this.sliderBtn.y=(1 - progress) * 80;
		}

		public function updateProgress():void {


			var hy:Number=(Core.me.info.baseInfo.hp / Core.me.info.baseInfo.maxHp);
			var my:Number=(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp);

			TweenLite.to(this.hpSpr, .5, {scaleY: -hy});
			TweenLite.to(this.hpTopSwf, .5, {y: 110 - (hy * 110) - 10});

//			trace("hp",hy,Core.me.info.baseInfo.hp,Core.me.info.baseInfo.maxHp)
//			trace("mp", my, Core.me.info.baseInfo.mp, Core.me.info.baseInfo.maxMp, getTimer())

			if (hy <= 0.3) {
				if (!this.hpstate) {
					this.hpstate=true;
					if (UIManager.getInstance().toolsWnd.getGuidGrid(1) != null)
						GuideManager.getInstance().showGuide(43, UIManager.getInstance().toolsWnd.getGuidGrid(1));
				}
			} else {
				GuideManager.getInstance().removeGuide(43);

				if (hy == 1)
					this.hpstate=false;
			}

			this.hpTopSwf.visible=(hy != 1);
			UIManager.getInstance().roleWnd.updateHpAndMpAndSoul();

			if (MyInfoManager.getInstance().Mp != -1) {

				if (mptween != null)
					mptween.kill()
				
				if (mptoptween != null)
					mptoptween.kill();
				
				if (my <= 0.3) {
					if (!this.mpstate) {
						this.mpstate=true;
						if (UIManager.getInstance().toolsWnd.getGuidGrid(2) != null)
							GuideManager.getInstance().showGuide(44, UIManager.getInstance().toolsWnd.getGuidGrid(2));
					}
				} else {
					GuideManager.getInstance().removeGuide(44);
				}

				this.mpTopSwf.visible=(my != 1);

				this.mpSpr.scaleY=-my;
				this.mpTopSwf.y=110 - (my * 110) - 10;

				TweenLite.delayedCall(1, exeTime);
			}

			if (this.hpshow) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9522).content, [Core.me.info.baseInfo.hp, Core.me.info.baseInfo.maxHp, int(Core.me.info.baseInfo.hp / Core.me.info.baseInfo.maxHp * 100) + "%"]), new Point(this.stage.mouseX, this.stage.mouseY));
			}

			if (this.mpshow) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9523).content, [Core.me.info.baseInfo.mp, Core.me.info.baseInfo.maxMp, int(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp * 100) + "%", ConfigEnum.manaRevive]), new Point(this.stage.mouseX, this.stage.mouseY));
			}

		}

		private function exeTime():void {

			if (Core.me.info.baseInfo.mp == Core.me.info.baseInfo.maxMp) {

				myExe=(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp);
				this.mpstate=false;

				if (mptween == null || mptween.totalTime == mptween.currentTime) {
					TweenLite.to(this.mpSpr, .5, {scaleY: -myExe});
					TweenLite.to(this.mpTopSwf, .5, {y: 110 - (myExe * 110) - 10});
				}

//				trace("mp111",myExe,Core.me.info.baseInfo.mp,Core.me.info.baseInfo.maxMp,getTimer())
				return;

			} else {

				var diff:Number=Core.me.info.baseInfo.maxMp - Core.me.info.baseInfo.mp;
				if (diff >= 5) {
					Core.me.info.baseInfo.mp+=5;
				} else {
					Core.me.info.baseInfo.mp=Core.me.info.baseInfo.maxMp;
				}

				UIManager.getInstance().roleWnd.updateHpAndMpAndSoul();

				myExe=(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp);

//				if (this.mpTopSwf.y != 110 - (my * 110) - 6)
				mpTopSwf.visible=true;

//				trace("mp222",myExe,Core.me.info.baseInfo.mp,Core.me.info.baseInfo.maxMp,getTimer())

				mptween=TweenLite.to(this.mpSpr, 1, {scaleY: -myExe});
				mptoptween=TweenLite.to(this.mpTopSwf, 1, {y: 110 - (myExe * 110) - 10, onComplete: complete});

				if (this.mpshow) {
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9523).content, [Core.me.info.baseInfo.mp, Core.me.info.baseInfo.maxMp, int(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp * 100) + "%", ConfigEnum.manaRevive]), new Point(this.stage.mouseX, this.stage.mouseY));
				}
			}

		}

		private function complete():void {
			if (myExe > 0.3)
				GuideManager.getInstance().removeGuide(44);

			mpTopSwf.visible=(myExe != 1);
			exeTime();
		}

		public function stopAddMp():void {
			if (mptween != null) {
				mptween.pause();
				mptween.kill();
			}

			if (mptoptween != null) {
				mptoptween.pause();
				mptoptween.kill();
			}
		}


	}
}

package com.leyou.ui.question {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.head.OtherHead;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TQuestion;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.ui.question.childs.QuestionBtn;
	import com.leyou.ui.question.childs.QuestionLWnd;
	import com.leyou.ui.question.childs.QuestionMWnd;
	import com.leyou.ui.question.childs.QuestionQBtn;
	import com.leyou.ui.question.childs.QuestionRWnd;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class QuestionWnd extends AutoSprite {

		private var middtitle:QuestionMWnd;
		private var leftWnd:QuestionLWnd;
		private var rightWnd:QuestionRWnd;
		private var quitBtn:QuestionQBtn;

		private var wnd:SimpleWindow;

		private var QuestCount:int=0;

		/**
		 *单前选择
		 */
		public var isSelectedWnd:QuestionBtn;

		/**
		 *是否完成
		 */
		public var isComplete:Boolean=false;

		/**
		 *记录没有题目时的选择
		 */
		public var currentDic:int=0;

		private var succEffect:SwfLoader;

		public function QuestionWnd() {
			super(new XML());
			this.init();
//			this.hideBg();
//			this.allowDrag=false;
			this.mouseChildren=this.mouseEnabled=true;
//			this.clsBtn.visible=false;
		}

		private function init():void {
			this.middtitle=new QuestionMWnd();
			this.addChild(this.middtitle);

			this.leftWnd=new QuestionLWnd();
			this.addChild(this.leftWnd);

			this.rightWnd=new QuestionRWnd();
			this.addChild(this.rightWnd);

//			this.quitBtn=new QuestionQBtn();
//			this.addChild(this.quitBtn);

			this.leftWnd.addEventListener(MouseEvent.CLICK, onClick);
			this.rightWnd.addEventListener(MouseEvent.CLICK, onClick);
//			this.quitBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.succEffect=new SwfLoader();
			this.addChild(this.succEffect);
			this.succEffect.x=UIEnum.WIDTH >> 1;
			this.succEffect.y=UIEnum.HEIGHT >> 1;

			this.hide();

			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onQuitClick);
		}

		private function onQuitClick(e:MouseEvent):void {
			if (SceneEnum.SCENE_TYPE_DTCJ == MapInfoManager.getInstance().type) {
				var ctx:String;
				if (this.QuestCount < ConfigEnum.question2) {

					ctx=PropUtils.getStringById(1833);

					wnd=PopupManager.showConfirm(ctx, function():void {
						Cmd_Qa.cmQaExit();
						wnd=null;
						hide();
					}, null, false, "questQuit")

				} else {
					Cmd_Qa.cmQaExit();
				}
			}
		}

		private function onMouseClick(e:MouseEvent):void {

			if (e.currentTarget is QuestionMWnd || e.target is QuestionBtn)
				return;

			var globalPoint:Point=new Point(e.stageX, e.stageY);
			var screenPoint:Point=UIManager.getInstance().gameScene.globalToLocal(globalPoint);
			var targetPoint:Point=SceneUtil.screenToTile(screenPoint.x, screenPoint.y);
			Core.me.gotoMap(targetPoint, "", false);

		}


		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "leftWnd":

					break;
				case "rightWnd":

					break;
				case "quitBtn":

					var ctx:String;
					if (this.QuestCount < ConfigEnum.question2) {

						ctx=PropUtils.getStringById(1833);

						wnd=PopupManager.showConfirm(ctx, function():void {
							Cmd_Qa.cmQaExit();
							wnd=null;
							hide();
						}, null, false, "questQuit")

					} else {
						Cmd_Qa.cmQaExit();
					}

					break;
			}

		}

		/**
		 *题目
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			var qinfo:TQuestion=TableManager.getInstance().getQuestInfo(o.qid);
			if (qinfo == null)
				return;

			if (!this.visible)
				this.show();

			this.QuestCount=o.qindex;

			this.middtitle.setTitleNameTxt(StringUtil.substitute(PropUtils.getStringById(1834),[o.qindex + "/" + ConfigEnum.question2]));
			this.middtitle.setContentTxt(qinfo.des);
			this.middtitle.setTimeTxt();
			this.middtitle.startTimer(o.stime);

			this.leftWnd.setContentTxt(qinfo["anw" + o.a]);
			this.rightWnd.setContentTxt(qinfo["anw" + o.b]);

			this.isComplete=false;

			if (this.currentDic == 1)
				this.onClickLeftBtn();
			else if (this.currentDic == 1)
				this.onClickRightBtn();

			SoundManager.getInstance().play(26);
		}

		/**
		 *	奖励
		 * @param o
		 *
		 */
		public function updateReward(o:Object):void {
			this.middtitle.updateInfo(o);
		}

		/**
		 *	答案
		 * @param o
		 */
		public function updateRight(o:Object):void {

			succEffect.visible=true;

			if (o.qright == "a") {
				this.leftWnd.setAward(true);
				this.rightWnd.setAward(false);

				if (this.isSelectedWnd == this.leftWnd.getContent()) {
					this.succEffect.update(99938);
				} else {
					this.succEffect.update(99939);
				}
				
			} else if (o.qright == "b") {
				this.rightWnd.setAward(true);
				this.leftWnd.setAward(false);

				if (this.isSelectedWnd == this.rightWnd.getContent()) {
					this.succEffect.update(99938);
				} else {
					this.succEffect.update(99939);
				}
			}

//			function succFunc():void {
				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, endFunc);
//			}

			function endFunc():void {
				succEffect.visible=false;
			}

			this.isComplete=true;
			this.middtitle.setTimeTxt(o.rw);

			if (this.QuestCount == ConfigEnum.question2 && this.isComplete) {

				TweenLite.delayedCall(5, function():void {

					middtitle.setTitleNameTxt("");
					middtitle.setContentTxt(PropUtils.getStringById(1835));
					middtitle.setTimerTxt("");
					middtitle.setNoticeTxt("");

					leftWnd.hide();
					rightWnd.hide();

				});

			}
		}

		public function onClickLeftBtn():void {

			if (!this.isComplete) {
				this.rightWnd.setSelectState(false);
				this.leftWnd.setSelectState(true);
			} else {
				this.currentDic=1;
			}

		}

		public function onClickRightBtn():void {
			if (!this.isComplete) {
				this.leftWnd.setSelectState(false);
				this.rightWnd.setSelectState(true);
			} else {
				this.currentDic=2;
			}
		}


		override public function show():void {
			super.show();

			this.x=0;
			this.resize();

			this.leftWnd.show();
			this.rightWnd.show();
			
			this.leftWnd.setContentTxt("");
			this.rightWnd.setContentTxt("");
			this.middtitle.clearData();

//			UIManager.getInstance().roleHeadWnd.hide();
//			UIManager.getInstance().toolsWnd.hide();

			UIManager.getInstance().smallMapWnd.switchToType(2);
			UIManager.getInstance().rightTopWnd.hideBar(1);
			MapWnd.getInstance().hideSwitch();

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().maillReadWnd.hide();
			OtherHead.getInstance().hide();
			NoticeManager.getInstance().setMsgVisible(NoticeEnum.TYPE_MESSAGER8, false);
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPY);

			LayerManager.getInstance().mainLayer.addChild(UIManager.getInstance().chatWnd);
			
			LayerManager.getInstance().guildeLayer.visible=false;
		}

		/**
		 *更新开始答题剩余时间:
		 */
		public function updateStartLastTime(str:String):void {
			this.middtitle.setContentTxt(PropUtils.getStringById(1836));
			this.middtitle.setTimeTxt();
			this.middtitle.setTimerTxt(str);

			var txt:String=TableManager.getInstance().getSystemNotice(4803).content;

			this.leftWnd.setContentTxt(txt);
			this.rightWnd.setContentTxt(txt);
		}

		public function resize():void {

			this.y=50;

			var w:int=Math.min(1500, UIEnum.WIDTH);
			var h:int=Math.min(900, UIEnum.HEIGHT);

			var x:int=UIEnum.WIDTH > 1500 ? (UIEnum.WIDTH - 1500 >> 1) : 0;
//			trace(UIEnum.WIDTH,UIEnum.HEIGHT,x)

			this.leftWnd.x=x - 5;
			this.leftWnd.y=(h - this.leftWnd.height >> 1) - this.y;

			this.rightWnd.x=x + w - this.rightWnd.width;
			this.rightWnd.y=(h - this.rightWnd.height >> 1) - this.y;

			this.middtitle.y=0;
			this.middtitle.x=x + (w - this.middtitle.width >> 1) - 7;

//			this.quitBtn.y=10;
//			this.quitBtn.x=x + w - this.quitBtn.width - 50;
			
			this.succEffect.x=UIEnum.WIDTH >> 1;
			this.succEffect.y=UIEnum.HEIGHT >> 1;
		}

		override public function hide():void {
			super.hide();

			UIManager.getInstance().roleHeadWnd.show();
			UIManager.getInstance().toolsWnd.show();
			UIManager.getInstance().rightTopWnd.show();
			UIManager.getInstance().smallMapWnd.show();
			UIManager.getInstance().taskTrack.show();
//			OtherHead.getInstance().show();
			NoticeManager.getInstance().setMsgVisible(NoticeEnum.TYPE_MESSAGER8, true);
			LayerManager.getInstance().guildeLayer.visible=true;
			
			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}

		}


	}
}

package com.ace.ui {
	import com.ace.ICommon.IMenu;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.KeysEnum;
	import com.ace.enum.UIEnum;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.CursorManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.SoundManager;
	import com.ace.tools.ByteMovieClip;
	import com.ace.tools.MathTools;
	import com.ace.tools.NTSC;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.GroupButton;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.button.event.ButtonEvent;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.slider.children.HSlider;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.ace.utils.LoadUtil;
	import com.ace.utils.PnfUtil;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class UiTester extends AutoWindow implements IMenu {
		private var introduction:String="";

		private var putongBtn:NormalButton;
		private var setProBtn:NormalButton;
		private var hideBtn:NormalButton;
		private var mybtn:NormalButton;
		private var alertBtn:NormalButton;
		private var okBtn:NormalButton;
		private var inputBtn:NormalButton;
		private var input:TextInput;
		private var originalRbtn:RadioButton;
		private var custonRbtn:RadioButton;
		private var playBgmCbox:CheckBox;
		private var introduceArea:TextArea;
		private var scrollPane:ScrollPane;
		private var tabBar:TabBar;
		private var myHslider:HSlider;
		private var myTA:TextArea;
		private var menuBtn:NormalButton;
		private var bagBtn:ImgButton;


		//combobox  arr.push({str: childData[i], val: i});
		public function UiTester():void {
			super(LibManager.getInstance().getXML("config/ui/testUI.xml"));
			this.show();
			this.allowDrag=true;
			this.init();
		}

		//加载到舞台上时
		override protected function initModel():void {
			super.initModel();
			if (!LibManager.getInstance().chkData("ui/test/test.uif"))
				return;

			var mf:ByteMovieClip=new ByteMovieClip(LibManager.getInstance().getBinary("ui/test/test.uif"));
			this.addToPane(mf);

			this.swfLoader.x=this.swfLoader.y=600;
			this.addToPane(this.swfLoader);

		}
		private var swfLoader:SwfLoader=new SwfLoader();
		private var comBoxArr:Array=[];

		private function init():void {
//			return;
			/*
			//嵌入式字体
			var lab:Label=new Label("123aa", LibManager.getInstance().getEmbedFormat(FontEnum.YUANYOU), TextFormatAlign.LEFT, true);
			lab.x=488;
			lab.y=318;
			this.addToPane(lab);

			//嵌入式字体--按钮
			var btn:NormalButton=new NormalButton("1225", 0, 0, LibManager.getInstance().getEmbedFormat(FontEnum.YUANYOU), true);
			btn.x=488;
			btn.y=lab.y + lab.height + 20;
			btn.name="embedFontBtn";
			this.addToPane(btn);
			btn.addEventListener(MouseEvent.CLICK, onCLick);

			*/

			/*var swfMove:SwfBmpMovie=new SwfBmpMovie();
			swfMove.updataArr(LibManager.getInstance().getSwfBmdArr("decorate/1002.sif"), new Point(-270, -70));
			swfMove.updataAct(0, 7, 3);
			this.addToPane(swfMove);*/
			this.myTA=this.getUIbyID("myTA") as TextArea;
			this.myTA.visibleOfBg=false;

			this.introduceArea=this.getUIbyID("introduceArea") as TextArea;
			//			tarea.opaqueBackground=0xff0000;
			this.scrollPane=new ScrollPane(this.introduceArea.width + UIEnum.SCROLLBAR_WIDTH, 40);
			this.scrollPane.x=this.introduceArea.x;
			this.scrollPane.y=this.introduceArea.y;
			this.scrollPane.addToPane(this.introduceArea);
			this.addChild(this.scrollPane);
			this.introduceArea.x=this.introduceArea.y=0;
			//			this.introduceArea.setText("abc\rccccc\rddddddd\reeee");
			this.introduceArea.setText(this.introduction);
			//			this.scrollPane.opaqueBackground=0x00FFFF;

			//播放BGM声音
			SoundManager.getInstance().play(16);

			this.putongBtn=this.getUIbyID("ptBtn") as NormalButton;
			this.setProBtn=this.getUIbyID("setProBtn") as NormalButton;
			this.hideBtn=this.getUIbyID("hideBtn") as NormalButton;
			this.mybtn=this.getUIbyID("mybtn") as NormalButton;
			this.alertBtn=this.getUIbyID("alertBtn") as NormalButton;
			this.okBtn=this.getUIbyID("okBtn") as NormalButton;
			this.inputBtn=this.getUIbyID("inputBtn") as NormalButton;
			this.input=this.getUIbyID("myInput") as TextInput;
			this.originalRbtn=this.getUIbyID("originalRbtn") as RadioButton;
			this.custonRbtn=this.getUIbyID("custonRbtn") as RadioButton;
			this.playBgmCbox=this.getUIbyID("playBgmCbox") as CheckBox;
			this.tabBar=this.getUIbyID("myTabBar") as TabBar;
			this.myHslider=this.getUIbyID("myHslider") as HSlider;
			this.menuBtn=this.getUIbyID("menuBtn") as NormalButton;
			this.bagBtn=this.getUIbyID("bagBtn") as ImgButton;


			var g1:GroupButton=this.getUIbyID("g1") as GroupButton;
			var g2:GroupButton=this.getUIbyID("g2") as GroupButton;

			g1.setActive(false, 0.6, true);



			this.getUIbyID("testCBoxBtn").addEventListener(MouseEvent.CLICK, onCLick);
			this.putongBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.menuBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.setProBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.hideBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.mybtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.bagBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.alertBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.okBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.inputBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.playBgmCbox.addEventListener(MouseEvent.CLICK, onCLick);
			this.originalRbtn.addEventListener(ButtonEvent.Switch_Change, onCLick);
			this.myHslider.addEventListener(ScrollBarEvent.Progress_Update, onChanger);

			this.bagBtn.setActive(false, 0.6, true);

//			LoadUtil.testSol();

			KeysManager.getInstance().addKeyFun(KeysEnum.SPACE, addChat, KeyboardEvent.KEY_DOWN);

//			var tipBtn:NormalButton=this.getUIbyID("tipBtn") as NormalButton;
//			tipBtn.setActive(false, 0.6, true);

			this.tabBar.turnToTab(2);

			this.tabBar.setTabActive(1, false);

			KeysManager.getInstance().addKeyFun(KeysEnum.F, onClickF);



			this.comBoxArr.push([{label: "全部", uid: 0}, {label: "1级", uid: 1}, {label: "20级", uid: 20}, {label: "40级", uid: 40}, {label: "60级", uid: 60}, {label: "70级", uid: 70}, {label: "80级", uid: 80}, {label: "90级", uid: 90}]);
			this.comBoxArr.push([{label: "所有", uid: 0}, {label: "x级", uid: 1}]);
		}

		private function onClickF():void {
			this.open();
		}

		/**水平滑条事件*/
		private function onChanger(evt:Event):void {
			trace(this.myHslider.progress);
		}

		//
		private function addChat():void {
			this.introduceArea.appendHtmlText(MathTools.randomAtoB(1, 1000) + "\r");
			this.scrollPane.updateUI();
			DelayCallManager.getInstance().add(this, this.scrollPane.scrollTo, "updateUI", 4, 1); //flash的bug，添加完文本后，计算文本高度不准确，需要延迟调用
		}

		private var btnTime:Timer;
		private var btnIndex:int;

		private function onBtnTick(evt:Event):void {
			this.putongBtn.text=btnIndex + "秒";
			this.btnIndex++;
		}

		private function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "ptBtn":
					if (!btnTime) {
						this.btnTime=new Timer(1000);
						this.btnTime.addEventListener(TimerEvent.TIMER, onBtnTick);
					}
					this.btnTime.running ? this.btnTime.stop() : this.btnTime.start();
					break;
				case "hideBtn":
					if (this.hideBtn.text == "隐藏标签") {
						this.hideBtn.text="显示标签";
						this.tabBar.setTabVisible(1, false);
						this.swfLoader.update(99904);
					} else {
						this.hideBtn.text="隐藏标签";
						this.tabBar.setTabVisible(1, true);
						this.swfLoader.update(99904);
					}
					break;
				case "mybtn":
					new NTSC(2012, 4, 28);
					break;
				case "alertBtn":
					PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, WindInfo.getAlertInfo("我们的类型属于第三种，在这一种，又可分为两种类型。一类是完全的客户端回合制RPG网页版，包括魔幻大陆等很多之前的回合制都是这种模式；一类是把以前武林英雄这种RPG，把没有多人同屏显示做成了同屏多人显示，把战斗文字播报做成了图形化自动战斗。从效果来看"), "alertWnd");
					break;
				case "okBtn":
					PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, WindInfo.getInputInfo("们的类型属于第三种，在这一种，又可分为两种类型。一类是完全的客户端回合制RPG网页版，包括魔幻大陆等"), "asd");
					break;
				case "inputBtn":
					var info:WindInfo=WindInfo.getInputInfo("请输入价钱:");
					info.isModal=true;
					PopWindow.showWnd(UIEnum.WND_TYPE_INPUT, info, "inputWnd");
					break;
				case "playBgmCbox":
					if (this.playBgmCbox.isOn)
						SoundManager.getInstance().musicVolume=1;
					else
						SoundManager.getInstance().musicVolume=0;
					break;
				case "originalRbtn":
				case "custonRbtn":
					if (this.originalRbtn.isOn)
						CursorManager.getInstance().resetSystemCursor();
					else
						CursorManager.getInstance().resetGameCursor();
					break;
				case "embedFontBtn":
					break;
				case "setProBtn":
					this.myHslider.progress=0.5;
					break;
				case "menuBtn":
					this.showMenu();
					break;
				case "bagBtn":
					trace("xxxxxxxxx");
//					this.bagBtn.turnOn(false);
					break;
				case "testCBoxBtn":
//					ComboBox(this.getUIbyID("testCBox")).list.removeRender("5");
//					ComboBox(this.getUIbyID("testCBox")).list.removeRender("2");
					ComboBox(this.getUIbyID("testCBox")).list.removeRenders();
					this.comBoxIndex=(this.comBoxIndex == 1) ? 0 : 1;
					ComboBox(this.getUIbyID("testCBox")).list.addRends(this.comBoxArr[this.comBoxIndex]);

					break;
			}
		}

		private var comBoxIndex:int=1;


		private function showMenu():void {
			var arr:Vector.<MenuInfo>=new Vector.<MenuInfo>;
			var txtArr:Array=["添加", "删除", "测试长度", "短", "附近查找"];
			var info:MenuInfo;
			for (var i:int=0; i < 5; i++) {
				info=new MenuInfo(txtArr[i], i);
				arr.push(info);
			}

			MenuManager.getInstance().show(arr, this, new Point(this.stage.mouseX, this.stage.mouseY));

		}


		public function onMenuClick(index:int):void {
			trace("单击了" + index);
		}




	}
}

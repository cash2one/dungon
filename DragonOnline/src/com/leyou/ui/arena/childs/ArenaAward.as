package com.leyou.ui.arena.childs {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.LoadUtil;
	import com.greensock.TweenLite;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.ui.task.child.TaskTrackBtn;

	import flash.events.MouseEvent;

	public class ArenaAward extends AutoWindow {

		private var accpetRewardBtn:TaskTrackBtn;
		private var gridlist:ScrollPane;

		private var items:Vector.<ArenaAwardRender>;

		private var currentPro:int=-1;

		public function ArenaAward() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaAward.xml"));
			this.init();
//			this.clsBtn.y-=10;
		}

		private function init():void {

//			this.accpetRewardBtn=this.getUIbyID("accpetRewardBtn") as ImgButton;
//			this.accpetRewardBtn=new TaskTrackBtn();
//			this.addChild(this.accpetRewardBtn);
//			this.accpetRewardBtn.x=119.5;
//			this.accpetRewardBtn.y=489;
//
//			this.accpetRewardBtn.updateIcons("ui/mission/title_lqjl.png");

//			this.gridlist=this.getUIbyID("gridlist") as ScrollPane;

//			this.accpetRewardBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.items=new Vector.<ArenaAwardRender>();

//			LibManager.getInstance().load([LoadUtil.lib2Cach("config/table/Miliyary_Rank.xml")], loaderFunc);
			this.loaderFunc();
		}

		private function loaderFunc():void {

			var item:XML=LibManager.getInstance().getXML("config/table/Miliyary_Rank.xml");
			var xml:XML;

			var itemsrender:ArenaAwardRender;

			for (var i:int=int(item.data.length() - 1); i >= 0; i--) {

				itemsrender=new ArenaAwardRender();
				itemsrender.x=9;
				itemsrender.y=54 + this.items.length * 58;

				itemsrender.updateInfo(item.data[i]);

//				this.gridlist.addToPane(itemsrender);
				this.addChild(itemsrender);
				this.items.push(itemsrender);
			}

//			this.gridlist.scrollTo(0);
//			DelayCallManager.getInstance().add(this, this.gridlist.updateUI, "updateUI", 4);

			this.items.reverse();
		}


		private function onClick(e:MouseEvent):void {
			Cmd_Arena.cm_ArenaReward();

//			this.gridlist.updateUI();
//			DelayCallManager.getInstance().add(this, this.gridlist.scrollTo, "updateUI", 4, 1 - Number(this.currentPro + 1) / this.items.length);

			this.items[this.currentPro].flyBag();
		}

		public function updateInfo(pro:int, st:int):void {

			for (var i:int=0; i < this.items.length; i++) {
				this.items[i].setHight(false);
			}

			var item:XML=LibManager.getInstance().getXML("config/table/Miliyary_Rank.xml");
			var xml:XML;
			var str:String;
			for (i=int(item.data.length() - 1); i >= 0; i--) {
				xml=item.data[i];
				str=xml.@MR_PNum;
				if (pro >= int(str.split("|")[0]) && pro <= int(str.split("|")[1])) {
					if (this.items[xml.@MR_Level - 1] != null) {
						this.items[xml.@MR_Level - 1].setHight(true);
					}
				}
			}

//			if (this.items[pro] != null) {
//				this.items[pro].setHight(true);
//			}

			this.currentPro=pro;

//			this.gridlist.updateUI();
//			DelayCallManager.getInstance().add(this, this.gridlist.scrollTo, "updateUI", 4, 1 - Number(this.currentPro + 1) / this.items.length);

//			if (st == 0) {
//
//				if (UIManager.getInstance().isCreate(WindowEnum.ARENA)) {
//					TweenLite.delayedCall(0.6, function():void {
//						if (UIManager.getInstance().arenaWnd.visible)
//							GuideManager.getInstance().showGuide(65, UIManager.getInstance().arenaWnd.reAwardBtn);
//					});
//				}
//
//				this.accpetRewardBtn.setActive(true, 1, true);
//				this.accpetRewardBtn.updateIcons("ui/mission/title_lqjl.png");
//
//			} else {
//
//				GuideManager.getInstance().removeGuide(65);
//				this.accpetRewardBtn.setActive(false, .6, true);
//				this.accpetRewardBtn.updateIcons("ui/welfare/btn_lqjl2.png");
//
//			}
//
//			if (pro == 0)
//				this.accpetRewardBtn.updateIcons("ui/welfare/btn_lqjl3.png");


		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
		}


	}
}

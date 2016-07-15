package com.leyou.ui.shiyi {

	import com.ace.ICommon.IGuide;
	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Syj;
	import com.leyou.ui.shiyi.childs.ShizBtn1;
	import com.leyou.ui.shiyi.childs.ShizBtn2;
	import com.leyou.ui.shiyi.childs.ShizRender1;
	import com.leyou.ui.shiyi.childs.ShizRender2;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ShizWnd extends AutoWindow {

		private var shiyitabbar:TabBar;
		private var itemList:ScrollPane;

		private var itemArr:Array=[];

		/**
		 *1.称号
2.时装
3.坐骑
4.翅膀
5.技能
6.足迹
7.特效
(标签页)
*/
		private var tabIndexArr:Array=[2, 7, 3, 4, 5, 6, 1];

		private var selectIndex:int=0;

		private var currentTabInfo:Object;

		private var render1:ShizRender1;
		private var render2:ShizRender2;

		public function ShizWnd() {
			super(LibManager.getInstance().getXML("config/ui/shiyi/shizWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.shiyitabbar=this.getUIbyID("shiyitabbar") as TabBar;
			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.render1=new ShizRender1();
			this.addChild(this.render1);

			this.render1.x=326;
			this.render1.y=93;

			this.render2=new ShizRender2();
			this.addChild(this.render2);

			this.render2.x=326;
			this.render2.y=93;

			this.render1.visible=false;
			this.render2.visible=false;
			this.shiyitabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
		}

		private function onChangeIndex(e:Event):void {
			this.selectIndex=0;
			Cmd_Syj.cmSelectTab(this.tabIndexArr[this.shiyitabbar.turnOnIndex]);
		}

		public function updateTabList():void {
			Cmd_Syj.cmSelectTab(this.tabIndexArr[this.shiyitabbar.turnOnIndex]);
		}

		public function updateTabInfo(o:Object):void {


			this.currentTabInfo=o;

			var robj:DisplayObject;
			for each (robj in this.itemArr) {
				this.itemList.delFromPane(robj);
			}

			this.itemArr.length=0;

			var tArr:Array=TableManager.getInstance().getTitleArrByType(o.stype);
			var tinfo:TTitle;
			var render1:ShizBtn1;
			var render2:ShizBtn2;
			var st:int=0;
			var i:int=0;

			for each (tinfo in tArr) {

				if (tinfo.type == 3 && this.getisActive(o.slist, tinfo.typeId) == 0)
					continue;

				if (tinfo.Sz_type != 1) {
					render1=new ShizBtn1();
					render1.updateInfo(tinfo);

					this.itemList.addToPane(render1);
					this.itemArr.push(render1);

					render1.y=i * render1.height;

				} else {

					render2=new ShizBtn2();
					render2.updateInfo(tinfo);

					this.itemList.addToPane(render2);
					this.itemArr.push(render2);

					render2.y=i * render2.height;
				}

				st=this.getisActive(o.slist, tinfo.typeId);

				if (st > 0) {

					if (tinfo.Sz_type != 1) {
						render1.updateInfo(tinfo);
						render1.sortIndex=1;
						render1.setBgState(st == 2);

					} else {
						render2.updateInfo(tinfo);
						render2.sortIndex=1;

						render2.setBgState(st == 2);
					}

				} else {

					if (render1 != null) {
						render1.enabel=false;
					}

					if (render2 != null)
						render2.enabel=false;
				}

				i++;
			}

			this.itemArr.sortOn(["sortIndex", "sortId"], [Array.DESCENDING | Array.NUMERIC, Array.CASEINSENSITIVE | Array.NUMERIC]);

			i=0;

			var dis:DisplayObject;
			for each (dis in itemArr) {
				dis.y=i * dis.height;
				i++;
			}

			var p:Number=this.itemList.scrollBar_Y.progress;
			this.itemList.scrollTo(0);
			this.itemList.updateUI();
//			DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
			DelayCallManager.getInstance().add(this, this.itemList.scrollTo, "updateUI", 4, 0);

			this.itemArr[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		private function getisActive(arr:Array, sid:int):int {

			var tmp:Array=[];
			for each (tmp in arr) {

				if (int(tmp[0]) == sid)
					return int(tmp[1])

			}

			return 0;
		}


		public function updateInfo(o:Object):void {

			this.selectIndex=o.sinfo[0];
			this.setOtherState(o.sinfo[0], o.sinfo[1]);

			var obj:Object;
			for each (obj in this.itemArr) {
				if (obj.sortId == o.sinfo[0]) {
					obj.setBgState((o.sinfo[1] == 2));
				}
			}

			if (this.shiyitabbar.turnOnIndex == 4 || this.shiyitabbar.turnOnIndex == 5) {
				this.render1.visible=false;
				this.render2.visible=true;

				this.render2.updateInfo(o);
			} else {
				this.render1.visible=true;
				this.render2.visible=false;

				this.render1.updateInfo(o);
			}


		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_Syj.cmSelectTab(this.tabIndexArr[1]);
			shiyitabbar.turnToTab(0);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			UIManager.getInstance().showPanelCallback(WindowEnum.SHIYI);
//			UILayoutManager.getInstance().open_II(WindowEnum.SHIYI);
		}

		public function setTabIndex(i:int):void {
			shiyitabbar.turnToTab(i);
		}

		public function setSelectItem(i:int):void {

			var render3:Object;

			for each (render3 in this.itemArr) {

//				trace(render3.sortId)
				if (render3.sortId == (i - 1 + 5000)) {
					render3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}

		}

		override public function get height():Number {
			return 544;
		}

		public function getTitleCount():int {
			if (this.currentTabInfo.stype == 1) {

				var count:int=0;
				var tmp:Array=[];

				for each (tmp in this.currentTabInfo.slist) {
					if (int(tmp[1]) == 2)
						count++;
				}

				return count;
			}

			return 0;
		}

		public function setOtherState(typeid:int, st:int):void {
			var count:int=0;
			var tmp:Array=[];

			for each (tmp in this.currentTabInfo.slist) {
				if (int(tmp[0]) == typeid)
					tmp[1]=st;
			}
		}

		public function getOtherCount():Array {
//			if (this.currentTabInfo.stype != 1) {
				var count:int=0;
				var tmp:Array=[];

				for each (tmp in this.currentTabInfo.slist) {
					if (int(tmp[1]) == 2)
						return tmp;
				}

//			}

			return [];
		}

		public function reAddChild():void {
//			this.addChild(this.shiyitabbar);
//			this.shiyitabbar.mouseChildren=this.shiyitabbar.mouseEnabled=false;
//			this.shiyitabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
		}


		public function reSize():void {
			this.x=(UIEnum.WIDTH - this.width) >> 1;
			this.y=(UIEnum.HEIGHT - this.height) >> 1;
		}

		override public function hide():void {
			super.hide();
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("fittingBtn"));
		}

	}
}

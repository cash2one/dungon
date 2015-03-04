package com.leyou.ui.aution {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.ui.aution.child.AutionBuyRender;
	import com.leyou.ui.aution.child.AutionMessageRender;
	import com.leyou.ui.aution.child.AutionSellRender;
	import com.leyou.ui.backpack.BackpackWnd;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AutionWnd extends AutoWindow {
		
		private var tabBar:TabBar;
		private var goldLbl:Label;
		private var moneyLbl:Label;
//		private var goldBindLbl:Label;
		private var cessLbl:Label;
		
		private var autionBuyPanel:AutionBuyRender;
		private var autionSellPanel:AutionSellRender;
		private var autionMessagePanel:AutionMessageRender;
		private var _currentIdx:int = -1;
		
		private var ybImg:Image;
		private var jbImg:Image;
		
		public function AutionWnd() {
			super(LibManager.getInstance().getXML("config/ui/AutionWnd.xml"));
			this.init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			tabBar = getUIbyID("tabBar") as TabBar;
			goldLbl = getUIbyID("goldLbl") as Label;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			ybImg = getUIbyID("ybImg") as Image;
			cessLbl = getUIbyID("cessLbl") as Label;
			var container:Sprite = new Sprite();
			container.name = ybImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			ybImg.parent.addChild(container);
			container.addChild(ybImg);
//			container.x = ybImg.x;
//			container.y = ybImg.y;
			jbImg = getUIbyID("jbImg") as Image;
			container = new Sprite();
			container.name = jbImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			jbImg.parent.addChild(container);
			container.addChild(jbImg);
//			goldBindLbl = getUIbyID("goldBindLbl") as Label;
			
			autionBuyPanel = new AutionBuyRender();
			autionBuyPanel.x = -9;
			autionBuyPanel.y =  5;
			autionSellPanel = new AutionSellRender();
			autionSellPanel.x = -9;
			autionSellPanel.y =  5;
			autionMessagePanel = new AutionMessageRender();
			autionMessagePanel.x = -9;
			autionMessagePanel.y =  1;
			
			tabBar.addToTab(autionBuyPanel, 0);
			tabBar.addToTab(autionSellPanel, 1);
			tabBar.addToTab(autionMessagePanel, 2);
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			_currentIdx = 0;
//			tabBar.turnToTab(0);
		}
		
		protected function onMouseOut(event:Event):void{
		}
		
		public function refreshPage():void{
			autionBuyPanel.refreshPage();
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String;
			switch(event.target.name){
				case "jbImg":
					content = TableManager.getInstance().getSystemNotice(9555).content;
					break;
				case "ybImg":
					content = TableManager.getInstance().getSystemNotice(9559).content;
					break;
				default:
					throw new Error("aution show money tip unknow fault");
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		/**
		 * <T>分页按钮点击监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onTabBarChangeIndex(evt:Event):void {
			if (_currentIdx == tabBar.turnOnIndex){
				return;
			}
			_currentIdx = tabBar.turnOnIndex;
			switch(_currentIdx){
				case 0:
					autionBuyPanel.reset();
					Cmd_Aution.cm_Aution_I(autionBuyPanel.currentPage);
					break;
				case 1:
					Cmd_Aution.cm_Aution_M();
					var wnd:BackpackWnd = UIManager.getInstance().backpackWnd;
					if(!wnd || (wnd && !wnd.visible)){
						UILayoutManager.getInstance().show_II(WindowEnum.BACKPACK);
					}
					break;
				case 2:
					Cmd_Aution.cm_Aution_G();
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			var backpack:BackpackWnd = UIManager.getInstance().backpackWnd;
			backpack.hidBind(true);
			updataMoney();
			GuideManager.getInstance().removeGuide(34);
		}
		
		/**
		 * <T>界面打开</T>
		 * 
		 */		
		public override function hide():void{
			super.hide();
			UIManager.getInstance().backpackWnd.hidBind(false);
			UILayoutManager.getInstance().composingWnd(WindowEnum.AUTION);
		}
		
		/**
		 * <T>加载全部出售列表界面信息</T>
		 * 
		 */		
		public function loadAll(o:Object):void{
			var tb:Array = o.tb;
			var ct:uint = Math.ceil(o.ct/7);
			autionBuyPanel.loadInfo(tb, ct);
			var gname:String = o.gname;
			var hasOwer:Boolean = (null != gname) && ("" != gname)
			cessLbl.visible = hasOwer;
			if(hasOwer){
				var content:String = TableManager.getInstance().getSystemNotice(6720).content;
				content = StringUtil.substitute(content, o.gname, int(int(o.cess)/100)+"%");
				cessLbl.text = content;
			}
		}
		
		/**
		 * <T>加载排序出售列表界面信息</T>
		 * 
		 */		
		public function loadSortList(o:Object):void{
			var cb:Array = o.cb;
			var ct:uint = Math.ceil(o.ct/7);
			autionBuyPanel.loadInfo(cb, ct);
		}
		
		/**
		 * <T>加载排序出售列表界面信息</T>
		 * 
		 */		
//		public function loadSortListByMoney(o:Object):void{
//			var cb:Object = o.cb;
//			var ct:uint = Math.ceil(o.ct/7);
//			autionBuyPanel.loadInfoByMoneySort(cb, ct);
//		}
		
		/**
		 * <T>加载自己的出售信息</T>
		 * 
		 * @param o 信息
		 * 
		 */		
		public function loadSelf(o:Object):void{
			var mb:Array = o.mb;
			var mc:uint = o.ra[0];
			var gc:uint = o.ra[1];
			autionSellPanel.loadInfo(mb);
			autionSellPanel.loadRate(mc, gc);
		}
		
		/**
		 * <T>加载日志</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public function loadLog(o:Object):void{
			var lb:Array = o.lb;
			autionMessagePanel.loadInfo(lb);
		}
		
		/**
		 * <T>最后一次出售价格</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public function loadLastPrice(o:Object):void{
			autionSellPanel.loadLastPrice(o);
		}
		
		/**
		 * <T>更新金钱</T>
		 * 
		 */		
		public function updataMoney():void{
//			goldLbl.text = UIManager.getInstance().backpackWnd.yb+"";
//			goldBindLbl.text = UIManager.getInstance().backpackWnd.byb+"";
//			moneyLbl.text = UIManager.getInstance().backpackWnd.jb+"";
			
			moneyLbl.text = StringUtil_II.sertSign(UIManager.getInstance().backpackWnd.jb);;
			goldLbl.text = StringUtil_II.sertSign(UIManager.getInstance().backpackWnd.yb);
		}
		
		/**
		 * <T>由外部调用,加入寄售</T>
		 * 
		 * @param fromItem 寄售物品所在格子
		 * 
		 */		
		public function switchHandler(fromItem:GridBase):void{
			tabBar.turnToTab(1);
			autionSellPanel.switchHandler(fromItem);
		}
		
		public function clearSale():void{
			autionSellPanel.clearSale();
		}
	}
}

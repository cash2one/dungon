package com.leyou.ui.blackStore
{
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.leyou.data.blackStore.BlackStoreData;
	import com.leyou.data.blackStore.BlackStoreItem;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BlackStore;
	import com.leyou.ui.blackStore.children.BlackStoreRender;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlackStoreWnd extends AutoWindow
	{
		private static const ITEM_MAX_NUM:int = 9;
		
		private var blackStoreBar:TabBar;
		
		private var ybLbl:Label;
		
		private var bybLbl:Label;
		
		private var refreshLbl:Label;
		
		private var ybRefreshBtn:NormalButton;
		
		private var rechargeLbl:Label;
		
		private var numImg:Image;
		
		private var payBtn:ImgButton;
		
		private var desLbl:Label;
		
		private var progressBg:Image;
		
		private var progressCover:Image;
		
		private var progressLbl:Label;
		
		private var renders:Vector.<BlackStoreRender>;
		
		private var rollNum:RollNumWidget;
		
		private var ybImg:Image;
		
		private var bybImg:Image;
		
		public function BlackStoreWnd(){
			super(LibManager.getInstance().getXML("config/ui/blackStore/blackStoreWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			clsBtn.x += 4;
			clsBtn.y += 13;
			rollNum = new RollNumWidget();
			rollNum.loadSource("ui/num/{num}_zdl.png");
			rollNum.alignRound();
			rollNum.x = 101;
			rollNum.y = 110;
			pane.addChild(rollNum);
			progressLbl = getUIbyID("progressLbl") as Label;
			numImg = getUIbyID("numImg") as Image;
			blackStoreBar = getUIbyID("blackStoreBar") as TabBar;
			ybLbl = getUIbyID("ybLbl") as Label;
			bybLbl = getUIbyID("bybLbl") as Label;
			ybLbl = getUIbyID("ybLbl") as Label;
			refreshLbl = getUIbyID("refreshLbl") as Label;
			rechargeLbl = getUIbyID("rechargeLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			ybRefreshBtn = getUIbyID("ybRefreshBtn") as NormalButton;
			payBtn = getUIbyID("payBtn") as ImgButton;
			progressBg = getUIbyID("progressBg") as Image;
			progressCover = getUIbyID("progressCover") as Image;
			ybImg = getUIbyID("ybImg") as Image;
			bybImg = getUIbyID("bybImg") as Image;
			
			packContainer(ybImg);
			packContainer(bybImg);
			
			ybRefreshBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			renders = new Vector.<BlackStoreRender>(ITEM_MAX_NUM);
			for(var n:int = 0; n < ITEM_MAX_NUM; n++){
				var render:BlackStoreRender = renders[n];
				if(null == render){
					render = new BlackStoreRender();
					render.setPosition(n+1);
					renders[n] = render;
					pane.addChild(render);
					render.x = 36 + 214*(n%3);
					if(n/3 >= 2){
						render.y = 433;
					}else{
						render.y = 202 + 103*int(n/3);
					}
				}
			}
			blackStoreBar.turnToTab(0);
			blackStoreBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
		}
		
		private function packContainer(img:Image):void{
			var container:Sprite = new Sprite();
			container.name = img.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			img.parent.addChild(container);
			container.addChild(img);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var id:int;
			var content:String;
			switch(event.target.name){
				case "bybImg":
					content = TableManager.getInstance().getSystemNotice(9558).content;
					break;
				case "ybImg":
					content = TableManager.getInstance().getSystemNotice(9559).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		private function setProgress(progress:Number):void{
			var rect:Rectangle = progressCover.scrollRect;
			if(null == rect){
				rect = new Rectangle();
			}
			rect.x = 0;
			rect.y = 0;
			rect.width = 406 * progress;
			rect.height = 25;
			progressCover.scrollRect = rect;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			blackStoreBar.turnToTab(0);
			super.show(toTop, $layer, toCenter);
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		protected function onTabChange(event:Event):void{
			switch(blackStoreBar.turnOnIndex){
				case 0:
					Cmd_BlackStore.cm_BMAK_I(0);
					break;
				case 1:
					Cmd_BlackStore.cm_BMAK_I(1);
					break;
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "payBtn":
					if(0 == blackStoreBar.turnOnIndex){
						PayUtil.openPayUrl();
					}else{
						UIOpenBufferManager.getInstance().open(WindowEnum.ACTIVE);
					}
					break;
				case "ybRefreshBtn":
					var rt:int = DataManager.getInstance().blackStoreData.getRefreshTime();
					if(rt <= 0){
						onRefresh();
						return;
					}
					var content:String = TableManager.getInstance().getSystemNotice(23006).content;
					content = StringUtil.substitute(content, ConfigEnum.Discount9);
					PopupManager.showConfirm(content, onRefresh, null, false, "black.store.resfresh");
					break;
			}
		}
		
		private function onRefresh():void{
			Cmd_BlackStore.cm_BMAK_F(blackStoreBar.turnOnIndex);
		}
		
		public function updateTime():void{
			var rt:int = DataManager.getInstance().blackStoreData.getRefreshTime();
			var timeStr:String = DateUtil.formatTime(rt*1000, 2);
			if("" == timeStr){
				timeStr =PropUtils.getStringById(1644);
				ybRefreshBtn.text = PropUtils.getStringById(1645);
			}else{
				ybRefreshBtn.text = PropUtils.getStringById(1646);
			}
//			refreshLbl.text = StringUtil.substitute(TableManager.getInstance().getSystemNotice(23007).content, timeStr);
		}
		
		public function updateInfo():void{
			var data:BlackStoreData = DataManager.getInstance().blackStoreData;
			ybLbl.text = UIManager.getInstance().backpackWnd.yb+"";
			bybLbl.text = UIManager.getInstance().backpackWnd.byb+"";
//			var url:String = StringUtil.substitute("ui/num/{num}_lz.png", data.remianC);
//			numImg.updateBmp(url);
			rollNum.setNum(data.remianC);
			var url:String = ((0 == blackStoreBar.turnOnIndex) ? "ui/vip/btn_vip_cz.png" : "ui/vip/btn_bs_tshy.jpg");
			payBtn.updataBmd(url);
			var id:int = ((0 == blackStoreBar.turnOnIndex) ? 23001 : 23003);
			var content:String = TableManager.getInstance().getSystemNotice(id).content;
			rechargeLbl.text = StringUtil.substitute(content, DataManager.getInstance().blackStoreData.payoff);
			var pgs:Number = 0.0;
			var payoff:int = DataManager.getInstance().blackStoreData.payoff;
			id = ((0 == blackStoreBar.turnOnIndex) ? 23002 : 23004);
			content = TableManager.getInstance().getSystemNotice(id).content;
			if(0 == blackStoreBar.turnOnIndex){
				content = StringUtil.substitute(content, ConfigEnum.Discount4);
				pgs = 1 - payoff/ConfigEnum.Discount4;
				progressLbl.text = (ConfigEnum.Discount4 - payoff) + "/" + ConfigEnum.Discount4;
			}else{
				content = StringUtil.substitute(content, ConfigEnum.Discount5);
				pgs = 1 - payoff/ConfigEnum.Discount5;
				progressLbl.text = (ConfigEnum.Discount5 - payoff) + "/" + ConfigEnum.Discount5;
			}
			desLbl.text = content;
			setProgress(pgs);
			
			var length:int = data.getItemCount(blackStoreBar.turnOnIndex);
			for(var n:int = 0; n < ITEM_MAX_NUM; n++){
				var bd:BlackStoreItem = data.getItem(blackStoreBar.turnOnIndex, n);
				var render:BlackStoreRender = renders[n];
				render.updateInfo(bd);
			}
			updateTime();
		}
		
		public function flyItem(type:int, pos:int):void{
			renders[pos-1].flyItem();
		}
	}
}
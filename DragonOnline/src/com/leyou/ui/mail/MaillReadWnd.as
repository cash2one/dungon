package com.leyou.ui.mail {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Mail;
	import com.leyou.ui.mail.child.MailLableRender;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MaillReadWnd extends AutoWindow {
		
		private static const GRID_COUNT:int = 6;

		private var subjectLbl:Label;
		private var msgLbl:TextArea;
		private var deleteBtn:NormalButton;
		private var onekeyGetBtn:NormalButton;

		private var gridVec:Vector.<MaillGrid>;
		
		private var mailLink:MailLableRender;
		
		private var flyIds:Array;
		
		private var starts:Array;

		public function MaillReadWnd() {
			super(LibManager.getInstance().getXML("config/ui/mail/MaiReadWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}
		
		public function isRead(mId:int):Boolean{
			return (!mailLink || mailLink.mailInfo.mailId == mId);
		}

		/**
		 * <T>初始化</T>
		 * 
		 */
		private function init():void {
			flyIds = [];
			starts = [];
			subjectLbl = getUIbyID("subjectLbl") as Label;
			msgLbl = getUIbyID("msgLbl") as TextArea;
			msgLbl.tf.selectable = true;
			deleteBtn = getUIbyID("deleteBtn") as NormalButton;
			onekeyGetBtn = getUIbyID("onekeyGetBtn") as NormalButton;

			deleteBtn.addEventListener(MouseEvent.CLICK, onClick);
			onekeyGetBtn.addEventListener(MouseEvent.CLICK, onClick);

			gridVec = new Vector.<MaillGrid>();
			generateRewardGrid();
			this.hideBg();
			this.allowDrag = false;
		}
		
//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//		}
		
		public function flyItem():void{
			if(0 != flyIds.length){
				FlyManager.getInstance().flyBags(flyIds, starts);
			}
		}
			
		/**
		 * <T>界面关闭</T>
		 * 
		 */
		public override function hide():void{
			super.hide();
			mailLink = null;
			UIManager.getInstance().maillWnd.resetCurrent();
			UILayoutManager.getInstance().composingWnd(WindowEnum.MAILL);
		}
		
		public override function get height():Number{
			return super.height - 4;
		}
		
		/**
		 * <T>生成奖励的格子</T>
		 * 
		 */
		public function generateRewardGrid():void {
			for(var i:int = 0; i < GRID_COUNT; i++) {
				var rewardGrid:MaillGrid = new MaillGrid(i);
				rewardGrid.x = 21 + i * rewardGrid.width;
				rewardGrid.y = 368;
				rewardGrid.isShowPrice = false;
				addChild(rewardGrid);
				gridVec.push(rewardGrid);
				rewardGrid.addEventListener(MouseEvent.CLICK, onGridClick);
			}
		}

		/**
		 * <T>格子点击监听</T>
		 * 
		 */
		private function onGridClick(e:MouseEvent):void {
			var mailGrid:MaillGrid = e.target as MaillGrid;
			var itemId:String = (0 != int(mailGrid.type)) ? mailGrid.dataId+"" : mailGrid.type;
			if(null != itemId){
				flyIds.length = 0;
				starts.length = 0;
				flyIds.push(mailGrid.dataId);
				starts.push(mailGrid.localToGlobal(new Point(0, 0)));
				Cmd_Mail.cm_MailMsg_A(mailLink.mailInfo.mailId, itemId);
			}
		}
		
		/**
		 * <T>按钮点击监听</T>
		 * 
		 */
		private function onClick(e:MouseEvent):void {
			var btnName:String = e.target.name;
			switch (btnName) {
				case "deleteBtn":
					if(mailLink.mailInfo.hasStuff){
						var warnStr:String = PropUtils.getStringById(1784);
						PopupManager.showConfirm(warnStr, deleteMailRequest, null, false, "wnd.mailRead.delete");
//						var pWnd:WindInfo = WindInfo.getConfirmInfo(warnStr, deleteMailRequest);
//						PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, pWnd, "wnd.mailRead.delete");
					}else{
						Cmd_Mail.cm_MailMsg_D([mailLink.mailInfo.mailId]);
					}
					break;
				case "onekeyGetBtn":
					flyIds.length = 0;
					starts.length = 0;
					for each(var grid:MaillGrid in gridVec){
						if(0 != grid.dataId){
							flyIds.push(grid.dataId);
							starts.push(grid.localToGlobal(new Point(0, 0)));
						}
					}
					Cmd_Mail.cm_MailMsg_A(mailLink.mailInfo.mailId);
					break;
			}
		}
		
		private function deleteMailRequest():void{
			Cmd_Mail.cm_MailMsg_D([mailLink.mailInfo.mailId]);
			
		}
		
		/**
		 * <T>加载数据</T>
		 *  
		 */
		public function loadMail(mail:MailLableRender):void{
			mailLink = mail;
			subjectLbl.text = mailLink.mailInfo.title;
			msgLbl.setHtmlText(mailLink.mailInfo.content);
			var reg:RegExp = /\"/g;
			msgLbl.setText(msgLbl.text.replace(reg,""));
			
			// 清理上次格子数据
			for each(var g:MaillGrid in gridVec){
				g.clear();
			}
			
			// 加载附件列表
			var currentIndex:int = 0;
			var stuff:Object = mailLink.mailInfo.stuffList;
			for(var key:String in stuff){
				var count:int = stuff[key];
				var dataId:uint = parseInt(key);
				var qh:int;
				if(0 == dataId){
					if("ex" == key){
						dataId = 65534;
					}else if("jb" == key){
						dataId = 65535;
					}else if("zp" == key){
						dataId = 65533;
					}else if("ib" == key){
						dataId = 65529;
					}else if("bi" == key){
						dataId = 65532;
					}else if("lp" == key){
						dataId = 65531;
					}else if("qh" == key){
						var data:Array = stuff[key];
						dataId = data[0];
						qh = data[1];
					}else if("honour" == key){
						dataId = ItemEnum.HONOUR_VIR_ITEM_ID;
					}else if("score" == key){
						dataId = ItemEnum.CREDIT_VIR_ITEM_ID;
					}
				}
				if(currentIndex < GRID_COUNT){
					// 设置格子物品
					var grid:MaillGrid = gridVec[currentIndex++];
					grid.setProperty(key, dataId, count, qh);
				}
			}
			
		}
	}
}

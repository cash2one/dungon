package com.leyou.ui.marry {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;

	public class MarryWnd3 extends AutoWindow {

		private var desc1Lbl:Label;
		private var desc2Lbl:Label;
		private var desc3Lbl:Label;

		private var closeBtn:NormalButton;

		public function MarryWnd3() {
			super(LibManager.getInstance().getXML("config/ui/marry/marryWnd3.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {
			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.desc2Lbl=this.getUIbyID("desc2Lbl") as Label;
			this.desc3Lbl=this.getUIbyID("desc3Lbl") as Label;

			this.closeBtn=this.getUIbyID("closeBtn") as NormalButton;

			this.closeBtn.addEventListener(MouseEvent.CLICK, onClick);

		}

		private function onClick(e:MouseEvent):void {
			this.hide();
		}
		
		/**
		 *下行:marry|{"mk":Y, "marry_name":str, "marry_name2":str, "mtype":num}
          marry_name -- 结婚对象名字
          marry_name2 -- 结婚对象名字
          mtype -- 结婚类型（1黄金 2白金 3钻石） 
		 * @param o
		 * 
		 */		
		public function updateInfo(o:Object):void{
			
			UIManager.getInstance().hideWindow(WindowEnum.MARRY2);
			UIManager.getInstance().hideWindow(WindowEnum.MARRY1);
			
			var d:Date=new Date();
			
			this.desc1Lbl.htmlText=""+StringUtil.substitute(TableManager.getInstance().getSystemNotice(23301).content,[o.marry_name,o.marry_name2,d.fullYear,d.month+1,d.date,d.hours,d.minutes,d.seconds]);
			
		}


	}
}

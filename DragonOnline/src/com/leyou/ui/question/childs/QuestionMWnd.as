package com.leyou.ui.question.childs {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.StringUtil_II;
	import com.leyou.utils.TimeUtil;

	public class QuestionMWnd extends AutoSprite {

		private var timeLbl:Label;

		private var contentLbl:Label;
		private var titleNameLbl:Label;

		private var expLbl:Label;
		private var goldLbl:Label;

		private var addrightLbl:Label;
		private var rightLbl:Label;
		private var timeTxt:Label;
		private var noticeLbl:Label;

		private var time:int=0;

		public function QuestionMWnd() {
			super(LibManager.getInstance().getXML("config/ui/questionWnd.xml"));
			this.init();
		}

		private function init():void {

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.contentLbl=this.getUIbyID("contentLbl") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.expLbl=this.getUIbyID("expLbl") as Label;
			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.addrightLbl=this.getUIbyID("addrightLbl") as Label;
			this.rightLbl=this.getUIbyID("rightLbl") as Label;
			this.noticeLbl=this.getUIbyID("noticeLbl") as Label;

			this.noticeLbl.visible=false;

			this.timeTxt=this.getUIbyID("timeTxt") as Label;

//			this.timeLbl.filters=this.contentLbl.filters=this.titleNameLbl.filters=this.expLbl.filters=this.goldLbl.filters=this.addrightLbl.filters=this.rightLbl.filters=this.timeTxt.filters=FilterUtil.blackStrokeFilters;
		}

		/**
		 *right  -- 答对数量
		  cright -- 连队数量
		  exp    -- 累计经验
		  money  -- 累计金钱
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {
			if(o==null || !o.hasOwnProperty("exp"))
				return ;
			
			this.expLbl.text="" + o.exp;
			this.goldLbl.text="" + o.money;
			this.rightLbl.text="" + o.right;
			this.addrightLbl.text="" + o.cright;
		}

		public function startTimer(t:int):void {
//			if (this.time > 0)
//				return;

			this.time=t;
			this.timeLbl.text="" + DateUtil.formatTime(this.time,3);
			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {
			if (this.time-i > 0) {
				this.timeLbl.text="" +  DateUtil.formatTime((this.time-i)*1000,3);
			} else {
				this.time=0;
				this.timeLbl.text="";
				TimerManager.getInstance().remove(exeTime);
			}
		}

		public function setTimeTxt(v:int=0):void {
			
			if (v == 2) {
				
				this.noticeLbl.text="您答错了，下一题继续努力";
				this.timeTxt.visible=false;
				this.noticeLbl.visible=true;
				this.timeLbl.visible=false;
				
			} else if (v == 1) {
				
				this.noticeLbl.text="恭喜你答对了，请再接再厉";
				this.timeTxt.visible=false;
				this.noticeLbl.visible=true;

				this.timeLbl.visible=false;
				
			} else if (v == 0) {
				
				this.timeTxt.text="剩余时间:";
				this.timeTxt.visible=true;
				this.noticeLbl.visible=false;
				this.timeLbl.visible=true;
			}
			
		}
		
		public function clearData():void{
			this.expLbl.text="";
			this.goldLbl.text="";
			this.rightLbl.text="";
			this.addrightLbl.text="";
		}

		public function setContentTxt(s:String):void {
			this.contentLbl.text="" + StringUtil_II.getBreakLineStringByCharIndex(s, 25);
		}

		public function setTitleNameTxt(s:String):void {
			this.titleNameLbl.text=s + "";
		}

		public function setTimerTxt(s:String):void {
			this.timeLbl.text=s + "";
		}
		
		public function setTimevalueTxt(s:String):void {
			this.timeTxt.text=s + "";
		}
		
		public function setNoticeTxt(s:String):void {
			this.noticeLbl.text=s + "";
		}

		override public function get width():Number {
			return 528;
		}

		override public function get height():Number {
			return 320;
		}


	}
}

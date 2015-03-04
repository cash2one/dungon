package com.leyou.ui.question.childs {
	
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class QuestionRWnd extends AutoSprite {

		private var contentBtn:QuestionBtn;

		public function QuestionRWnd() {
			super(LibManager.getInstance().getXML("config/ui/question/questionRWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.contentBtn=new QuestionBtn();
			this.addChild(this.contentBtn);

			this.addChild(this.getUIbyID("yueImg"));
			
			this.contentBtn.x=5;
			this.contentBtn.y=75;
			
			this.contentBtn.setRight(false);
			this.contentBtn.setBgImg(1);
			
			this.contentBtn.addEventListener(MouseEvent.CLICK,onClick);
 
		}
		
		private function onClick(e:MouseEvent):void{
			
			var info:TPointInfo=TableManager.getInstance().getPointInfo(ConfigEnum.question11);
			
			//跨场景寻路
			Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
		}

		public function setContentTxt(o:Object):void{
			this.contentBtn.setContent(StringUtil_II.getBreakLineStringByCharIndex(o.toString(),11));
		 
			this.setSelectState(false);
			this.contentBtn.setRight(false);
		}
		
		public function setSelectState(v:Boolean):void{
			
			if (v) {
				if (UIManager.getInstance().questionWnd.isSelectedWnd != null)
					UIManager.getInstance().questionWnd.isSelectedWnd.setSelectState(false);
				
				UIManager.getInstance().questionWnd.isSelectedWnd=this.contentBtn;
			}
			
			this.contentBtn.setSelectState(v);
		}
		
		public function setSelectedEvent():void {
			this.contentBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function setAward(v:Boolean):void{
			this.contentBtn.setRight(true);
			this.contentBtn.setState(v);
		}
		
		public function getContent():QuestionBtn{
			return this.contentBtn;
		}
		
		override public function get width():Number {
			return 349;
		}

		override public function get height():Number {
			return 438;
		}

	}
}

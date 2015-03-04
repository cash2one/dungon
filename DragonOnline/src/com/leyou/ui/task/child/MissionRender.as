package com.leyou.ui.task.child {
	
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	public class MissionRender extends AutoSprite {

		private var taskNameLbl:Label;
		private var taskStateLbl:Label;

		private var imgbtn:ImgButton;
		

		
		public var tid:int=-1;

		public function MissionRender() {
			super(LibManager.getInstance().getXML("config/ui/task/missionRender.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {
			this.taskNameLbl=this.getUIbyID("taskNameLbl") as Label;
			this.taskStateLbl=this.getUIbyID("taskStateLbl") as Label;
			
			this.imgbtn=this.getUIbyID("imgBg") as ImgButton;
			this.imgbtn.mouseEnabled=true;
			
		}

		public function taskNameText(v:String):void {
			this.taskNameLbl.text=v;
		}

		public function taskStateText(v:String):void {  
			this.taskStateLbl.text=v;
		}
		
		public function setChangeState(s:int=0):void{
			
			switch(s){
				case 0:
					this.filters=[];
					break;
				case 1:
//					this.mouseChildren=this.mouseEnabled=false;
					this.taskNameLbl.filters=[FilterUtil.enablefilter];
					this.taskStateLbl.filters=[FilterUtil.enablefilter];
					break;
				case 2:
					this.mouseChildren=this.mouseEnabled=false;
					this.filters=[FilterUtil.enablefilter];
					break;
			}
			
		}

		public function set enable(v:Boolean):void {
			
			this.mouseChildren=this.mouseEnabled=v;
			
			if (v)
				this.filters=[];
			else
				this.filters=[FilterUtil.enablefilter];

		}

	}
}

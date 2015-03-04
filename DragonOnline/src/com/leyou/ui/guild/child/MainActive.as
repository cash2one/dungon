package com.leyou.ui.guild.child {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class MainActive extends AutoSprite {

		private var fullCb:RadioButton;
		private var memCb:RadioButton;
		private var fundCb:RadioButton;
		private var otherCb:RadioButton;

		private var sc:ScrollPane;
		
		private var contentLbl:TextArea;

		private var info:Array=[];

		private var selectType:int=0;

		public function MainActive() {
			super(LibManager.getInstance().getXML("config/ui/guild/mainActive.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.fullCb=this.getUIbyID("fullCb") as RadioButton;
			this.memCb=this.getUIbyID("memCb") as RadioButton;
			this.fundCb=this.getUIbyID("fundCb") as RadioButton;
			this.otherCb=this.getUIbyID("otherCb") as RadioButton;

			this.contentLbl=this.getUIbyID("contentLbl") as TextArea;
			this.contentLbl.visibleOfBg=false;
			
			sc=new ScrollPane(590,172);
			sc.addToPane(this.contentLbl);
			this.addChild(sc);
			
			sc.x=this.contentLbl.x;
			sc.y=this.contentLbl.y;
			
			this.contentLbl.y=this.contentLbl.x=0;

			this.fullCb.addEventListener(MouseEvent.CLICK, onClick);
			this.memCb.addEventListener(MouseEvent.CLICK, onClick);
			this.fundCb.addEventListener(MouseEvent.CLICK, onClick);
			this.otherCb.addEventListener(MouseEvent.CLICK, onClick);

			this.fullCb.turnOn();
			this.x-=10;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "fullCb":
					selectType=0;
					break;
				case "memCb":
					selectType=1;
					break;
				case "fundCb":
					selectType=2;
					break;
				case "otherCb":
					selectType=3;
					break;
			}

			this.updateInfo();
		}
		

		private function updateInfo():void {

			var str:String="";

			for (var i:int=0; i < this.info.length; i++) {

				if (selectType != this.info[i][1] && selectType != 0)
					continue;
				
				str+=TableManager.getInstance().getSystemNotice(this.info[i][2]).content;
				str=StringUtil.substitute(str,this.info[i][3])+"\n";
			}

			this.contentLbl.setHtmlText(str);
			
			this.sc.scrollTo(0);
//			this.sc.scrollBar_Y.addProgress(0);
			DelayCallManager.getInstance().add(this, this.sc.updateUI, "updateUI", 4);
		}

		public function updateData(info:Array):void {
			this.info=info;
			this.updateInfo();
		}



	}
}

package com.leyou.ui.guild.child {


	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.NumSteperSlider;
	import com.ace.ui.input.children.NumericStepper;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_unb;
	import com.leyou.utils.PropUtils;

	import flash.display.JointStyle;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GuildSciMessage extends AutoWindow {

		private var saveBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var ybLbl:Label;
		private var sumLbl:Label;

		private var slider:HSlider;
		private var numStep:NumericStepper;

		private var selectIndex:int;


		public function GuildSciMessage() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSciMessage.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.clsBtn.y-=10;
		}

		private function init():void {

			this.ybLbl=this.getUIbyID("ybLbl") as Label
			this.sumLbl=this.getUIbyID("sumLbl") as Label

			this.saveBtn=this.getUIbyID("saveBtn") as NormalButton
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton

			this.slider=this.getUIbyID("slider") as HSlider
			this.numStep=this.getUIbyID("numStep") as NumericStepper

			this.slider.progress=1;
			this.numStep.maximum=int.MAX_VALUE;
			this.numStep.minimum=1;

			this.numStep.stepSize=1;
			this.numStep.restrict="0-9"
			this.numStep.value=1;

			this.numStep.input.restrict="0-9";

			this.slider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
			this.numStep.addEventListener(Event.CHANGE, onInput);
			this.numStep.input.addEventListener(MouseEvent.CLICK, onInputSelect);

			this.saveBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "saveBtn":
					Cmd_unb.cmGuildBlessAddBuild(this.selectIndex, this.numStep.value);
					break;
				case "cancelBtn":

					break;
			}

			hide();
		}

		private function onChange(e:Event):void {
			this.numStep.value=Math.ceil(this.numStep.maximum * this.slider.progress);
			this.sumLbl.text="" + this.numStep.value * ConfigEnum.Union_Bless2;
		}

		private function onInput(e:Event):void {
			this.slider.progress=int(this.numStep.value) / int(this.numStep.maximum);
			this.sumLbl.text="" + this.numStep.value * ConfigEnum.Union_Bless2;
		}

		private function onInputSelect(e:MouseEvent):void {
			this.slider.progress=int(this.numStep.value) / int(this.numStep.maximum);
			this.sumLbl.text="" + this.numStep.value * ConfigEnum.Union_Bless2;
		}


		public function updateInfo(o:Object):void {



		}



		public function showPanel(i:int, ltime:int):void {

			this.show();

			this.selectIndex=i;

			var yb:int=UIManager.getInstance().backpackWnd.yb;
			var h:int=Math.ceil(ltime / 60 / 60);
			h=h < 0 ? 1 : h;

			var ybnum:int=h * ConfigEnum.Union_Bless2;
			ybnum=(ybnum < yb ? ybnum : Math.floor(yb / h));

//			this.numStep.maximum=ybnum;
			this.numStep.maximum=h;
			this.numStep.value=1;

			this.slider.progress=1 / this.numStep.maximum;

			this.ybLbl.text="" + ConfigEnum.Union_Bless2;




		}



	}
}

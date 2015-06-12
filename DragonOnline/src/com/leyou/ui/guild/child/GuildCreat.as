package com.leyou.ui.guild.child {

	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.ByteArray;

	public class GuildCreat extends AutoSprite {

		private var nameTxt:TextInput;
		private var createBtn:NormalButton;
		private var requiteTxt:TextArea;
		private var descTxt:TextArea;

		public function GuildCreat() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildCreat.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameTxt=this.getUIbyID("nameTxt") as TextInput;
			this.createBtn=this.getUIbyID("createBtn") as NormalButton;

			this.requiteTxt=this.getUIbyID("requiteTxt") as TextArea;
			this.descTxt=this.getUIbyID("descTxt") as TextArea;

			this.requiteTxt.visibleOfBg=false;
			this.descTxt.visibleOfBg=false;
			this.nameTxt.addEventListener(TextEvent.TEXT_INPUT, onInput);
			this.createBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.requiteTxt.setHtmlText(StringUtil.substitute(TableManager.getInstance().getSystemNotice(3044).content, [ConfigEnum.union2, ConfigEnum.union24]));
			this.descTxt.setHtmlText(TableManager.getInstance().getSystemNotice(3043).content);

			this.x=-17;
			this.y+=3;
		}

		private function onInput(e:TextEvent):void {

			if (this.nameTxt.text != "") {

				var by:ByteArray=new ByteArray();
				by.position=0;
				by.writeMultiByte(this.nameTxt.text, "cn-gb");
				by.position=0;

				var s:String=this.nameTxt.text;
				var str:Array=s.match(/[a-zA-Z]+/g);
				s=str.join(",");

				if (by.length > 10) {
					if (s.length % 2 == 0)
						this.nameTxt.text=by.readMultiByte(10, "cn-gb");
					else
						this.nameTxt.text=by.readMultiByte(11, "cn-gb");
				}
			}

		}


		private function onClick(e:MouseEvent):void {

			if (this.nameTxt.text != "") {
				if (this.nameTxt.text.length < 2) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(3037));
					return;
				}

//				if (this.nameTxt.text.length >= 7) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(3038));
//					return;
//				}

				PopupManager.showRadioConfirm(TableManager.getInstance().getSystemNotice(3076).content, ConfigEnum.union24 + "", ConfigEnum.union2 + "", function(i:int):void {

					Cmd_Guild.cm_GuildCreate(nameTxt.text, (i == 0 ? 1 : 0));
					Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
				}, null, false, "guildCreateSelect");


			}

		}



	}
}

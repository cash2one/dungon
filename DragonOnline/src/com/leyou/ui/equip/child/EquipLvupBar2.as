package com.leyou.ui.equip.child {
	
	
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;

	public class EquipLvupBar2 extends AutoSprite {

		private var descLbl:Label;

		public function EquipLvupBar2() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipLvupBar2.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.descLbl.htmlText=""+TableManager.getInstance().getSystemNotice(2628).content;
		}

		public function setDesc(s:String):void{
			this.descLbl.text=s;
		}


	}
}

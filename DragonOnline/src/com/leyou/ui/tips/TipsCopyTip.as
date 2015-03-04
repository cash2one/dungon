package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.data.copy.CopyData;

	public class TipsCopyTip extends AutoSprite implements ITip
	{
		private var desLbl:TextArea;
		
		private var expLbl:Label;
		
		private var moneyLbl:Label;
		
		private var energyLbl:Label;
		
		private var gulidLbl:Label;
		
		public function TipsCopyTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/dungeonStoryTips.xml"));
			inti();
		}
		
		private function inti():void{
			desLbl = getUIbyID("desLbl") as TextArea;
			expLbl = getUIbyID("expLbl") as Label;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;
			gulidLbl = getUIbyID("gulidLbl") as Label;
		}
		
		/**
		 * <T>更新信息</T>
		 * 
		 * @param info 信息
		 * 
		 */		
		public function updateInfo(info:Object):void{
			var copyData:CopyData = info as CopyData;
			desLbl.setText(copyData.copyTable.des);
			expLbl.text = copyData.copyTable.exp+"";
			moneyLbl.text = copyData.copyTable.money+"";
			energyLbl.text = copyData.copyTable.energy+"";
			gulidLbl.text = copyData.copyTable.guild+"";
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
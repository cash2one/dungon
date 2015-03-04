package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.fieldboss.FieldBossTipInfo;
	
	public class TipsFieldBossTip extends AutoSprite implements ITip
	{
		private var nameLbl:Label;
		
		private var mapLbl:Label;
		
		private var refreshTLbl:Label;
		
		private var killNameLbl:Label;
		
		private var dropLbl:Label;
		
		private var pro1Lbl:Label;
		
		private var pro2Lbl:Label;
		
		private var pro3Lbl:Label
		
		private var pro4Lbl:Label;
		
		public function TipsFieldBossTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/dungeonBossOutTips.xml"));
			nameLbl = getUIbyID("nameLbl") as Label;
			mapLbl = getUIbyID("mapLbl") as Label;
			refreshTLbl = getUIbyID("refreshTLbl") as Label;
			killNameLbl = getUIbyID("killNameLbl") as Label;
			dropLbl = getUIbyID("dropLbl") as Label;
			pro1Lbl = getUIbyID("pro1Lbl") as Label;
			pro2Lbl = getUIbyID("pro2Lbl") as Label;
			pro3Lbl = getUIbyID("pro3Lbl") as Label;
			pro4Lbl = getUIbyID("pro4Lbl") as Label;
			dropLbl.multiline = true;
			dropLbl.wordWrap = true;
		}
		
		public function updateInfo(info:Object):void{
			var data:FieldBossTipInfo = info as FieldBossTipInfo;
			var tbInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(data.bossId);
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(tbInfo.monsterId);
			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(tbInfo.sceneId+"");
			nameLbl.text = monsterInfo.name +"[lv"+monsterInfo.level+"]";
			mapLbl.text = sceneInfo.name;
			refreshTLbl.text = data.status;
			killNameLbl.text = data.killName;
			dropLbl.text = tbInfo.dropDes;
			pro1Lbl.text = TableManager.getInstance().getItemInfo(tbInfo.item1).name + " *" + tbInfo.item1Num;
			pro2Lbl.text = TableManager.getInstance().getItemInfo(tbInfo.item2).name + " *" + tbInfo.item2Num;
			pro3Lbl.text = TableManager.getInstance().getItemInfo(tbInfo.item3).name + " *" + tbInfo.item3Num;
			pro4Lbl.text = TableManager.getInstance().getItemInfo(tbInfo.item4).name + " *" + tbInfo.item4Num;
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
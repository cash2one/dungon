package com.leyou.ui.collection.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.collectioin.CollectionData;
	
	import flash.events.MouseEvent;
	
	public class CollectionMap extends AutoSprite
	{
		private var _groupId:int;
		
		private var collectionLbl:Label;
		
		private var selectImg:Image;
		
		private var progressImg:Image;
		
		private var progressBgImg:Image;
		
		private var progressLbl:Label;
		
		private var completionImg:Image;
		
		private var bgImg:Image;
		
		private var _close:Boolean;
		
		public function CollectionMap(){
			super(LibManager.getInstance().getXML("config/ui/collection/mine1Btn.xml"));
			init();
		}
		
		public function get close():Boolean{
			return _close;
		}

		public function get groupId():int{
			return _groupId;
		}
		
		private function init():void{
			mouseEnabled = true;
			bgImg = getUIbyID("bgImg") as Image;
			collectionLbl = getUIbyID("collectionLbl") as Label;
			selectImg = getUIbyID("selectImg") as Image;
			progressImg = getUIbyID("progressImg") as Image;
			progressBgImg = getUIbyID("progressBgImg") as Image;
			progressLbl = getUIbyID("progressLbl") as Label;
			completionImg = getUIbyID("completionImg") as Image;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			selectImg.visible = false;
			completionImg.visible = false;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			selectImg.visible = false;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			selectImg.visible = true;
		}
		
		public function updateTable(info:TCollectionPreciousInfo):void{
			_groupId = info.groupId;
			if(info.frontGroup > 0){
				var finfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousByGroup(info.frontGroup);
				collectionLbl.text = StringUtil.substitute("收集{1}全部宝藏后开启", finfo.mapName);
			}
			bgImg.updateBmp(StringUtil.substitute("ui/mine/{1}.png", info.mapPic_S));
		}
		
		public function updateTaskCount(data:CollectionData):void{
			var cinfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousByGroup(_groupId);
			progressLbl.text = data.getTaskCNum(_groupId)+"/"+data.getTaskNum(_groupId);
			progressImg.scaleX = data.getTaskCNum(_groupId)/data.getTaskNum(_groupId);
			var pinfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousByGroup(cinfo.frontGroup);
			var fcc:int = data.getTaskCNum(cinfo.frontGroup);
			var fmc:int = data.getTaskNum(cinfo.frontGroup);
			completionImg.visible = (data.getTaskCNum(_groupId) == data.getTaskNum(_groupId));
			progressLbl.visible = !completionImg.visible;
			progressImg.visible = !completionImg.visible;
			progressBgImg.visible = !completionImg.visible;
			_close = (null != pinfo) && ((0 == fcc) || (fcc < fmc));
			if(_close){
				bgImg.filters = [FilterEnum.enable];
				collectionLbl.visible = true;
			}else{
				bgImg.filters = null;
				collectionLbl.visible = false;
			}
		}
	}
}
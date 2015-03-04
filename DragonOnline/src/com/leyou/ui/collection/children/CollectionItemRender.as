package com.leyou.ui.collection.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.collectioin.CollectionData;
	import com.leyou.data.collectioin.CollectionGroupTaskData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class CollectionItemRender extends AutoSprite
	{
		private var exitBtn:ImgButton;
		
		private var phyAttLbl:Label;
		
		private var magicAttLbl:Label;
		
		private var lifeLbl:Label;
		
		private var critLbl:Label;
		
		private var hitLbl:Label;
		
		private var slayLbl:Label;
		
		private var phyDefLbl:Label;
		
		private var magicDefLbl:Label;
		
		private var magicLbl:Label;
		
		private var tenacityLbl:Label;
		
		private var dodgeLbl:Label;
		
		private var guardLbl:Label;
		
		private var panel:Sprite;
		
		private var leftBtn:ImgButton;
		
		private var rightBtn:ImgButton;
		
		private var items:Vector.<CollectionItem>;
		private var progressImg:Image;
		
		private var progressBgImg:Image;
		
		private var progressLbl:Label;
		
		private var pw:int = 700;
		private var threshold:int;
		private var currentPage:int;
		
		private var _groupId:int;
		
		private var bgImg:Image;
		
		public function CollectionItemRender(){
			super(LibManager.getInstance().getXML("config/ui/collection/mine2Render.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			mouseEnabled = true;
			bgImg = getUIbyID("bgImg") as Image;
			exitBtn = getUIbyID("exitBtn") as ImgButton;
			phyAttLbl = getUIbyID("phyAttLbl") as Label;
			phyDefLbl = getUIbyID("phyDefLbl") as Label;
			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			lifeLbl = getUIbyID("lifeLbl") as Label;
			critLbl = getUIbyID("critLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			slayLbl = getUIbyID("slayLbl") as Label;
			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			magicLbl = getUIbyID("magicLbl") as Label;
			tenacityLbl = getUIbyID("tenacityLbl") as Label;
			dodgeLbl = getUIbyID("dodgeLbl") as Label;
			guardLbl = getUIbyID("guardLbl") as Label;
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			items = new Vector.<CollectionItem>();
			progressImg = getUIbyID("progressImg") as Image;
			progressBgImg = getUIbyID("progressBgImg") as Image;
			progressLbl = getUIbyID("progressLbl") as Label;
			
			panel = new Sprite();
			panel.scrollRect = new Rectangle(0, 0, pw, 276);
			addChild(panel);
			panel.x = 38;
			panel.y = 50;
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			leftBtn.visible = false;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "leftBtn":
					previousPage();
					break;
				case "rightBtn":
					nextPage();
					break;
			}
		}
		
		protected function nextPage():void{
			if(currentPage < Math.ceil(items.length/5)-1){
				scrollToX(++currentPage*pw);
			}
		}
		
		protected function previousPage():void{
			if(currentPage > 0){
				scrollToX(--currentPage*pw);
			}
		}
		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			leftBtn.visible = (threshold > 0);
			rightBtn.visible = (threshold < (Math.ceil(items.length/5)-1)*pw);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = panel.scrollRect;
			if((threshold - rect.x) > 35){
				rect.x += 35;
			}else if((threshold - rect.x) < 35){
				rect.x -= 35;
			}else{
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			panel.scrollRect = rect;
		}
		
		public function loadGroupId(groupId:int):void{
			currentPage = 0;
			var rect:Rectangle = panel.scrollRect;
			rect.x = 0;
			panel.scrollRect = rect;
			leftBtn.visible = false;
			rightBtn.visible = true;
			
			_groupId = groupId;
			var ginfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousByGroup(groupId);
			var url:String = StringUtil.substitute("ui/mine/{1}.jpg", ginfo.mapPic_B);
			bgImg.updateBmp(url);
			var index:int = 0;
			var itemsInfo:Object = TableManager.getInstance().getCollectionDic();
			for(var key:String in itemsInfo){
				var itemInfo:TCollectionPreciousInfo = itemsInfo[key];
				if(itemInfo.groupId == groupId){
					var item:CollectionItem = getItem(index);
					item.updateTable(itemInfo);
					index++;
				}
			}
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				var itemRender:CollectionItem = items[n];
				if(n >= index){
					if((null != itemRender) && panel.contains(itemRender)){
						panel.removeChild(itemRender);
						itemRender.die();
					}
				}
			}
			items.length = index;
			items.sort(compare);
			l = items.length;
			for(var m:int = 0; m < l; m++){
				var render:CollectionItem = items[m];
				panel.addChild(render);
				render.x = 140*m;
				render.y = (m%5%2)*124;
			}
		}
		
		private function compare(pitem:CollectionItem, nitem:CollectionItem):int{
			if(pitem.id > nitem.id){
				return 1;
			}else if(pitem.id < nitem.id){
				return -1;
			}
			return 0;
		}
		
		private function getItem(index:int):CollectionItem{
			if(index >= items.length){
				items.length = index+1;
			}
			var item:CollectionItem = items[index];
			if(null == item){
				item = new CollectionItem();
				items[index] = item;
			}
			return item;
		}
		
		public function updateInfo(data:CollectionData):void{
			var rate:Number = data.getTaskCNum(_groupId)/data.getTaskNum(_groupId);
			progressLbl.text = data.getTaskCNum(_groupId)+"/"+data.getTaskNum(_groupId);
			progressImg.scaleX = rate;
			progressLbl.visible = (1 != rate);
			progressImg.visible = (1 != rate);
			progressBgImg.visible = (1 != rate);
			var groupData:CollectionGroupTaskData = data.getTaskData(_groupId);
			for each(var item:CollectionItem in items){
				item.updateInfo(groupData);
			}
			var phyAtt:int;
			var magicAtt:int;
			var life:int;
			var crit:int;
			var hit:int;
			var slay:int;
			var phyDef:int;
			var magicDef:int;
			var magic:int;
			var tenacity:int;
			var dodge:int;
			var guard:int;
			for each(var it:CollectionItem in items){
				if(2 == it.status){
					var info:TCollectionPreciousInfo = TableManager.getInstance().getPreciousById(it.id);
					phyAtt += info.phyAtt;
					magicAtt += info.magicAtt;
					life += info.hp;
					crit += info.crit;
					hit += info.hit;
					slay += info.slay;
					phyDef += info.phyDef;
					magicDef += info.magicDef;
					magic += info.magic;
					tenacity += info.tenacity;
					dodge += info.dodge;
					guard += info.guard;
				}
			}
			phyAttLbl.text = phyAtt+"";
			magicAttLbl.text = magicAtt+"";
			lifeLbl.text = life+"";
			critLbl.text = crit+"";
			hitLbl.text = hit+"";
			slayLbl.text = slay+"";
			phyDefLbl.text = phyDef+"";
			magicDefLbl.text = magicDef+"";
			magicLbl.text = magic+"";
			tenacityLbl.text = tenacity+"";
			dodgeLbl.text = dodge+"";
			guardLbl.text = guard+"";
		}
	}
}
package com.leyou.ui.rank.child
{
	import com.ace.enum.PlayerEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.AutoScrollText;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Rank;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class RankListRender extends AutoSprite
	{
		private static const PAGE_COUNT:int = 12;
		
		private var labels:Vector.<RankRender>;
		
		private var beginX:int = 3;
		
		private var beginY:int = 53;
		
		//		private var labels_II:Vector.<RankLabel>;
		
		public var type:int;
		
		private var nameLbl:Label;
		
		private var desLbl:Label;
		
		private var typeCbx:ComboBox;
		
		private var currentPage:int = 1;
		
		private var selectLabel:RankRender;
		
		private var pageLbl:Label;
		
		private var prevBtn:ImgButton;
		
		private var nextBtn:ImgButton;
		
		private var value:int;
		
		private var totalPage:int;
		
		// 左半部分是否空闲
		private var useLeft:Boolean;
		
		private var threshold:int;
		
		public var isLock:Boolean;
		
		public var posionIndex:int;

		private var nameScroll:AutoScrollText;
		
		public function RankListRender(type:int){
			super(LibManager.getInstance().getXML("config/ui/rank/rankList.xml"));
			init(type);
		}
		
		private function init(type:int):void{
			mouseChildren = true;
			labels = new Vector.<RankRender>(PAGE_COUNT+1);
			nameLbl = getUIbyID("nameLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			typeCbx = getUIbyID("typeCbx") as ComboBox;
			pageLbl = getUIbyID("pageLbl") as Label;
			prevBtn = getUIbyID("prevBtn") as ImgButton;
			nextBtn = getUIbyID("nextBtn") as ImgButton;
			scrollRect = new Rectangle(0, 0, 380, 440);
			initByType(type);
			nameLbl.visible = false;
			nameScroll = new AutoScrollText();
			nameScroll.setScrollRect(150, 28);
			nameScroll.defaultTextFormat = nameLbl.defaultTextFormat;
			nameScroll.x = nameLbl.x;
			nameScroll.y = nameLbl.y;
			addChild(nameScroll);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			prevBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			typeCbx.addEventListener(DropMenuEvent.Item_Selected, onSortType);
			
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "prevBtn":
					if(currentPage-1 > 0){
						currentPage--;
						requestInfo(currentPage)
					}
					break;
				case "nextBtn":
					if(currentPage+1 <= totalPage){
						currentPage++;
						requestInfo(currentPage)
					}
					break;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			var label:RankRender = event.target as RankRender;
			if(null == label || label.free || label.isSelf){
				return;
			}
			label.showFunMenu();
			setSelectLabel(label)
		}
		
		protected function setSelectLabel(label:RankRender):void{
			if(null != label){
				UIManager.getInstance().rankWnd.showAvatar(label.avaStr, label.gender, label.vocation);
			}
			if((null == label) || (selectLabel == label)){
				return;
			}
			if(null != selectLabel){
				selectLabel.locked = false;
				selectLabel.onMouseOut(null);
			}
			selectLabel = label;
			selectLabel.onMouseOver(null);
			selectLabel.locked = true;
			UIManager.getInstance().rankWnd.playerName = selectLabel.getName();
			Cmd_Rank.cm_RAK_A(0, selectLabel.getName());
		}
		
		protected function onSortType(event:Event):void{
			value = typeCbx.value.uid;
			Cmd_Rank.cm_RAK_I(type, value, 1, 13)
		}
		
		public function initByType($type:int):void{
			type = $type;
			switch(type){
				case 1:// 战斗力
				case 4:// 装备
					typeCbx.list.addRends([{label: "全部", uid: 0},
						{label: "战士", uid: PlayerEnum.PRO_SOLDIER},
						{label: "法师", uid: PlayerEnum.PRO_MASTER},
						{label: "术士", uid: PlayerEnum.PRO_WARLOCK},
						{label: "游侠", uid: PlayerEnum.PRO_RANGER} ]);
					desLbl.text = (1 == type) ? "总战斗力" : "装备战斗力";
					break;
				case 2:// 坐骑
				case 3:// 翅膀
					typeCbx.list.addRends([{label: "全部", uid: 0},
						{label: "三阶", uid: 3},
						{label: "四阶", uid: 4},
						{label: "五阶", uid: 5},
						{label: "六阶", uid: 6},
						{label: "七阶", uid: 7},
						{label: "八阶", uid: 8},
						{label: "九阶", uid: 9},
						{label: "十阶", uid: 10} ]);
					desLbl.text = (2 == type) ? "坐骑战斗力" : "翅膀战斗力";
					break;
				case 5:// 军衔
					typeCbx.list.addRends([{label: "全部", uid: 0},
						{label: "列兵", uid: 2},
						{label: "中尉", uid: 3},
						{label: "上尉", uid: 4},
						{label: "中校", uid: 5},
						{label: "上校", uid: 6},
						{label: "中将", uid: 7},
						{label: "上将", uid: 8},
						{label: "元帅", uid: 9},
						{label: "大元帅", uid: 10}]);
					desLbl.text = "积分";
					break;
				case 6:
					typeCbx.list.addRends([{label: "全部", uid: 0},
						{label: "战士", uid: PlayerEnum.PRO_SOLDIER},
						{label: "法师", uid: PlayerEnum.PRO_MASTER},
						{label: "术士", uid: PlayerEnum.PRO_WARLOCK},
						{label: "游侠", uid: PlayerEnum.PRO_RANGER} ]);
					desLbl.text = "等级";
					break;
				case 7:
					typeCbx.list.addRends([{label: "全部", uid: 0},
						{label: "战士", uid: PlayerEnum.PRO_SOLDIER},
						{label: "法师", uid: PlayerEnum.PRO_MASTER},
						{label: "术士", uid: PlayerEnum.PRO_WARLOCK},
						{label: "游侠", uid: PlayerEnum.PRO_RANGER} ]);
					desLbl.text = "金币";
					break;
			}
		}
		
		public function addSwitchTimer():void{
			nameScroll.startScroll();
		}
		
		public function removeSwitchTimer():void{
			nameScroll.stopScroll();
		}
		
		public function loadRankList(obj:Object):void{
			totalPage = Math.ceil(obj.znum/PAGE_COUNT);
			pageLbl.text = currentPage+"/"+totalPage;
			nameScroll.setTextArray(obj.openname);
			
			var rankList:Array = obj.rankl;
			getFreeLabel(PAGE_COUNT).updateInfo(rankList.shift(), true);
			var l:int = rankList.length;
			for(var n:int = 0; n < PAGE_COUNT; n++){
				var rankLabel:RankRender = getFreeLabel(n);
				if(n < l){
					var rankData:Array = rankList[n];
					rankLabel.updateInfo(rankData);
				}else{
					rankLabel.clear();
				}
			}
			
			if(0 == rankList.length){
				return;
			}
			var sLabel:RankRender = labels[0];
			if(null == sLabel){
				sLabel = getFreeLabel(PAGE_COUNT);
			}
			setSelectLabel(sLabel);
		}
		
		private function getFreeLabel(index:int):RankRender{
			var label:RankRender = labels[index];
			if(null == label){
				label = new RankRender();
				label.type = type;
				labels[index] = label;
				addChild(label);
				label.x = beginX;
				label.y = beginY + index * 25;
				
				if(index >= PAGE_COUNT){
					label.y = beginY + PAGE_COUNT * 25 + 3;
				}
			}
			return label;
		}
		
		public function requestInfo(page:int):void{
			currentPage = page;
			Cmd_Rank.cm_RAK_I(type, value, PAGE_COUNT*(currentPage-1)+1, PAGE_COUNT*currentPage)
		}
	}
}
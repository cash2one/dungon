package com.leyou.ui.aution.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.utils.PropUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class AutionBuyRender extends AutoSprite {
		private static const ITEM_PAGE_COUNT_MAX:int=7;

		private var pageLbl:Label;
		private var nameTxt:TextInput;

		private var proCb:ComboBox;
		private var typeCb:ComboBox;
		private var levelCd:ComboBox;
		private var qualityCb:ComboBox;

		private var searchBtn:ImgButton;
		private var prviPageBtn:ImgButton;
		private var nextPageBtn:ImgButton;
		private var lvSortBtn:ImgLabelButton;
		private var priceSortBtn:ImgLabelButton;
//		private var transform:Transform;

		private var lvSortImg:Image;
		private var priceSortImg:Image;

		private var pageCount:int=1;
		public var currentPage:int=0;


		// 出售项目显示项目列表
		private var renders:Vector.<AutionBuyItemLable>;

		// 出售项目数据列表
		private var itemData:Vector.<AutionItemData>;

		private var sortType:int=-1;

		private var currentOrder:int=1;

		private var moneyOrder:int=2;

		private var levelOrder:int=2;

		private var profession:int=-1;

		private var quality:int=-1;

		private var level:int=-1;
		private var lv_low:int=-1;
		private var lv_max:int=-1;

		private var type:int=-1;
		private var isReset:Boolean;

		public function AutionBuyRender() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionBuyRender.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			pageLbl=getUIbyID("pageLbl") as Label;
			nameTxt=getUIbyID("nameTxt") as TextInput;

			proCb=getUIbyID("proCb") as ComboBox;
			typeCb=getUIbyID("typeCd") as ComboBox;
			levelCd=getUIbyID("levelCd") as ComboBox;
			qualityCb=getUIbyID("qualityCb") as ComboBox;
			searchBtn=getUIbyID("searchBtn") as ImgButton;
			prviPageBtn=getUIbyID("prviPageBtn") as ImgButton;
			nextPageBtn=getUIbyID("nextPageBtn") as ImgButton;

			lvSortBtn=getUIbyID("lvSortBtn") as ImgLabelButton;
			priceSortBtn=getUIbyID("priceSortBtn") as ImgLabelButton;

			lvSortImg=getUIbyID("lvSortImg") as Image;
			priceSortImg=getUIbyID("priceSortImg") as Image;

//			transform = new Transform();
			itemData=new Vector.<AutionItemData>();
			renders=new Vector.<AutionBuyItemLable>(ITEM_PAGE_COUNT_MAX);
			searchBtn.addEventListener(MouseEvent.CLICK, onClick);
			prviPageBtn.addEventListener(MouseEvent.CLICK, onClick);
			nextPageBtn.addEventListener(MouseEvent.CLICK, onClick);
			lvSortBtn.addEventListener(MouseEvent.CLICK, onClick);
			priceSortBtn.addEventListener(MouseEvent.CLICK, onClick);
			nameTxt.input.addEventListener(MouseEvent.CLICK, onInputSelect);
			pageLbl.text="1/1";

			// 不限,普通,优秀,精良,史诗,传说
//			var ql:Array = [{str: "不限", val: -1}, 
//				            {str: "普通", val: QualityEnum.QUA_COMMON}, 
//							{str: "优秀", val: QualityEnum.QUA_EXCELLENT}, 
//							{str: "精良", val: QualityEnum.QUA_TERRIFIC}, 
//							{str: "史诗", val: QualityEnum.QUA_INCREDIBLE}, 
//							{str: "传说", val: QualityEnum.QUA_LEGEND}];
//			qualityCb.setDataByArr(ql);
			qualityCb.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);

			// 不限,战士,法师,术士,游侠
//			var pl:Array = [{str: "不限", val: -1},
//				            {str: "战士", val: PlayerEnum.PRO_SOLDIER},
//							{str: "法师", val: PlayerEnum.PRO_MASTER},
//							{str: "术士", val: PlayerEnum.PRO_WARLOCK},
//							{str: "游侠", val: PlayerEnum.PRO_RANGER}];
//			proCb.setDataByArr(pl);
			proCb.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);

			// 不限,装备,道具,金币
//			var tl:Array = [{str: "不限", val: -1},
//							{str: "装备", val: 1},
//							{str: "道具", val: 2},
//				            {str: "金币", val: 3}];
//			typeCb.setDataByArr(tl);
			typeCb.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);

			// 不限20级分一段
//			var ll:Array = [{str: "不限",  val: -1},
//							{str: "1-20",  val: 1},
//							{str: "21-40", val: 2},
//							{str: "41-60", val: 3},
//							{str: "61-80", val: 4},
//							{str: "81-100",val: 5}];
//			levelCd.setDataByArr(ll);
			levelCd.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
//			test();
		}

		/**
		 * <T>点击输入框监听</T>
		 *
		 * @param evt 点击事件
		 *
		 */
		protected function onInputSelect(evt:MouseEvent):void {
			nameTxt.input.setSelection(0, nameTxt.text.length);
		}

		/**
		 * <T>点击事件</T>
		 *
		 * @param event 事件
		 *
		 */
		protected function onComboBoxClick(event:Event):void {
			var boxName:String=event.target.name;
			switch (boxName) {
				case "typeCd":
					if (type != typeCb.value.uid) {
						currentPage=0;
						type=typeCb.value.uid;
						if (!isReset) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						}
					}
					break;
				case "proCb":
					if (profession != proCb.value.uid) {
						currentPage=0;
						profession=proCb.value.uid;
						if (!isReset) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						}

					}
					break;
				case "levelCd":
					if (level != levelCd.value.uid) {
						currentPage=0;
						level=levelCd.value.uid;
						setLevelRange();
						if (!isReset) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						}

					}
					break;
				case "qualityCb":
					if (qualityCb != qualityCb.value.uid) {
						currentPage=0;
						quality=qualityCb.value.uid;
						if (!isReset) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						}
					}
					break;
			}
		}

		/**
		 * <T>设置等级范围</T>
		 *
		 */
		private function setLevelRange():void {
			switch (level) {
				case -1:
					lv_low=-1;
					lv_max=-1;
					break;
				case 1:
					lv_low=1;
					lv_max=20;
					break;
				case 2:
					lv_low=21;
					lv_max=40;
					break;
				case 3:
					lv_low=41;
					lv_max=60;
					break;
				case 4:
					lv_low=61;
					lv_max=80;
					break;
				case 5:
					lv_low=81;
					lv_max=100;
					break;
			}
		}

		private function hasSort():Boolean {
			return -1 != sortType || -1 != type || -1 != profession || -1 != quality || (-1 != lv_low && -1 != lv_max);
		}

		public function reset():void {
			isReset=true;
			sortType=-1;
			lvSortBtn.turnOff(false);
			priceSortBtn.turnOff(false);
			qualityCb.list.selectByInd(0);
			typeCb.list.selectByInd(0);
			levelCd.list.selectByInd(0);
			proCb.list.selectByInd(0);
			nameTxt.text=PropUtils.getStringById(1612);
			isReset=false;
//			sortType = -1;
//			type = -1;
//			profession = -1;
//			quality = -1;
//			lv_low = -1;
//			lv_max = -1;
		}

		/**
		 * <T>按钮点击监听</T>
		 *
		 * @param evt
		 *
		 */
		private function onClick(evt:MouseEvent):void {
			var btnName:String=evt.target.name;
			switch (btnName) {
				case "searchBtn":
					Cmd_Aution.cm_Aution_L(nameTxt.text);
					break;
				case "prviPageBtn":
					if (currentPage > 0) {
						currentPage--;
						if (hasSort()) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						} else {
							Cmd_Aution.cm_Aution_I(currentPage);
						}
					}
					break;
				case "nextPageBtn":
					if (currentPage < (pageCount - 1)) {
						currentPage++;
						if (hasSort()) {
							Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
						} else {
							Cmd_Aution.cm_Aution_I(currentPage);
						}
					}
					break;
				case "lvSortBtn":
					this.lvSortBtn.turnOn(false);
					this.priceSortBtn.turnOff(false);
					var m:Matrix=lvSortImg.transform.matrix;
					if (1 == levelOrder) {
						levelOrder=2;
						m.d=1;
						m.ty=m.ty - lvSortImg.height;
					} else {
						levelOrder=1;
						m.d=-1;
						m.ty=m.ty + lvSortImg.height;
					}
					lvSortImg.transform.matrix=m;
					sortType=2;
					currentOrder=levelOrder;
					Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
					break;
				case "priceSortBtn":
					this.lvSortBtn.turnOff(false);
					this.priceSortBtn.turnOn(false);
					var matrix:Matrix=priceSortImg.transform.matrix;
					if (1 == moneyOrder) {
						moneyOrder=2;
						matrix.d=1;
						matrix.ty=matrix.ty - priceSortImg.height;
					} else {
						moneyOrder=1;
						matrix.d=-1;
						matrix.ty=matrix.ty + priceSortImg.height;
					}
					priceSortImg.transform.matrix=matrix;
					sortType=4;
					currentOrder=moneyOrder;
					Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
					break;
			}
		}

//		public function test():void{
//			for (var i:int = 0; i < 7; i++) {
//				var list:AutionBuyItemLable = new AutionBuyItemLable();
//				list.y = 51 + i * 44;
//				renders.push(list);
//				addChild(list);
//			}
//		}

		/**
		 * <T>加载页面</T>
		 *
		 */
		private function initPage():void {
			if (currentPage > pageCount - 1) {
				currentPage=pageCount - 1;
			}
			pageLbl.text=(currentPage + 1) + "/" + pageCount;
			var dl:int=itemData.length;
			for (var n:int=0; n < ITEM_PAGE_COUNT_MAX; n++) {
				var render:AutionBuyItemLable=renders[n];
				if (n < dl) {
					if (null == render) {
						render=new AutionBuyItemLable();
						render.y=51 + n * 44;
						addChild(render);
						render.setBackGround(n);
						renders[n]=render;
					}
					render.visible=true;
					render.updateInfo(itemData[n], currentPage);
				} else {
					if (null != render) {
						render.visible=false;
//						if(contains(render)){
//							removeChild(render);
//						}
					}

				}
			}
		}

		/**
		 * <T>加载出售列表</T>
		 *
		 * @params cb 出售列表数据
		 * @params ct 总页数
		 * @params cc 当前页数
		 *
		 */
		public function loadInfo(cb:Array, ct:uint):void {
			pageCount=(0 == ct) ? 1 : ct;
			var length:int=cb.length;
			itemData.length=length;
			for (var n:int=0; n < length; n++) {
				var nativeData:Array=cb[n];
				var data:AutionItemData=itemData[n];
				if (null == data) {
					data=new AutionItemData();
					itemData[n]=data;
				}
				data.updata(nativeData);
			}
			initPage();
		}

		public function resetPage():void {
			currentPage=0;
			pageLbl.text="1/" + pageCount;
			reset();
		}

		// 刷新当前页面数据
		public function refreshPage():void {
			if (hasSort()) {
				Cmd_Aution.cm_Aution_F(sortType, type, profession, quality, lv_low, lv_max, currentPage, currentOrder);
			} else {
				Cmd_Aution.cm_Aution_I(currentPage);
			}
		}
	}
}

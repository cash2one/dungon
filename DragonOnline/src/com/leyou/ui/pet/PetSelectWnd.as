package com.leyou.ui.pet
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.pet.PetData;
	import com.leyou.ui.pet.children.PetHeadGrid;
	import com.leyou.ui.pet.children.PetIconGird;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class PetSelectWnd extends AutoWindow
	{
		private static const SKILL_COUNT:int = 10;
		
		private var leftBtn:ImgButton;
		
		private var pageLbl:Label;
		
		private var rightBtn:ImgButton;
		
		private var grids:Vector.<PetHeadGrid>;
		
		private var currentIndex:int;
		
		private var selectCall:Function;
		
		private var titleIILbl:Label;
		
		private var petList:Vector.<int>;
		
		public function PetSelectWnd(){
			super(LibManager.getInstance().getXML("config/ui/pet/serSelectWnd.xml"));
			init();
		}
		
		private function init():void{
			petList = new Vector.<int>();
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			pageLbl = getUIbyID("pageLbl") as Label;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			titleIILbl = getUIbyID("titleLbl") as Label;
			titleIILbl.text = PropUtils.getStringById(2200);
			
			leftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			grids = new Vector.<PetHeadGrid>(10);
			for(var n:int = 0; n < SKILL_COUNT; n++){
				var grid:PetHeadGrid = new PetHeadGrid();
				grids[n] = grid;
				pane.addChild(grid);
				grid.x = 27.35 + 48 * int(n%5);
				grid.y = 48.35 + 48 * int(n/5);
				grid.setSelectAble(false);
				grid.addEventListener(MouseEvent.CLICK, onSelectClick);
			}
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			hideBg();
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			updateInfo();
		}
		
		public function updateInfo():void{
			petList.length = 0;
			var data:PetData = DataManager.getInstance().petData;
			var petDic:Object = TableManager.getInstance().getPetDic();
			for(var key:String in petDic){
				var petInfo:TPetInfo = petDic[key];
				if(data.containsPet(petInfo.id)){
					petList.push(petInfo.id);
				}
			}
			var pc:int = Math.ceil(petList.length/SKILL_COUNT);
			if(pc <= 0){
				pc = 1;
			}
			pageLbl.text = "1/" + pc;
			
			var length:int = petList.length;
			for(var n:int = 0; n < length; n++){
				var grid:PetHeadGrid = grids[n];
				grid.updatePet(petList[n]);
			}
		}
		
		protected function onSelectClick(event:MouseEvent):void{
			var grid:PetIconGird = event.target as PetIconGird;
			if(0 >= grid.dataId){
				return;
			}
			UIManager.getInstance().petIconbar.updateCurrentGrid(grid.dataId);
			hide();
		}
		
		public function resize():void{
			x = UIEnum.WIDTH/2 - 360;
			y = UIEnum.HEIGHT - 304;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
		}
	}
}
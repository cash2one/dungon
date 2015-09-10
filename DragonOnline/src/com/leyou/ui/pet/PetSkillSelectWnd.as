package com.leyou.ui.pet
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetSkillInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.setting.child.AssistSkillGrid;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class PetSkillSelectWnd extends AutoWindow
	{
		private static const SKILL_COUNT:int = 10;
		
		private var leftBtn:ImgButton;
		
		private var pageLbl:Label;
		
		private var rightBtn:ImgButton;
		
		private var grids:Vector.<AssistSkillGrid>;
		
		private var skills:Vector.<TPetSkillInfo>;
		
		private var currentIndex:int;
		
		private var _petID:int;
		
		private var _pos:int;
		
		private var selectCall:Function;
		
		private var titleIILbl:Label;
		
		public function PetSkillSelectWnd(){
			super(LibManager.getInstance().getXML("config/ui/pet/serSelectWnd.xml"));
			init();
		}
		
		private function init():void{
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			pageLbl = getUIbyID("pageLbl") as Label;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			titleIILbl = getUIbyID("titleLbl") as Label;
			titleIILbl.text = PropUtils.getStringById(2201);
			
			leftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			grids = new Vector.<AssistSkillGrid>(10);
			for(var n:int = 0; n < SKILL_COUNT; n++){
				var grid:AssistSkillGrid = new AssistSkillGrid();
				grids[n] = grid;
				pane.addChild(grid);
				grid.x = 27.35 + 48 * int(n%5);
				grid.y = 48.35 + 48 * int(n/5);
				grid.isPetSkill = true;
				grid.addEventListener(MouseEvent.CLICK, onSkillClick);
			}
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			hideBg();
			
			skills = new Vector.<TPetSkillInfo>();
		}
		
		protected function onSkillClick(event:MouseEvent):void{
//			var grid:AssistSkillGrid = event.target as AssistSkillGrid;
			if(null != selectCall){
				selectCall.call(this, event.target);
			}
//			Cmd_Pet.cm_PET_S(_petID, grid.gid, _pos);
			hide();
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "leftBtn":
					if(currentIndex > 1){
						currentIndex--;
						showPage(currentIndex);
					}
					break;
				case "rightBtn":
					if(currentIndex < Math.ceil(skills.length/SKILL_COUNT)){
						currentIndex++;
						showPage(currentIndex);
					}
					break;
			}
		}
		
		private function showPage(index:int):void{
			var l:int = SKILL_COUNT+(index-1)*SKILL_COUNT;
			for(var n:int = (index-1)*SKILL_COUNT; n < l; n++){
				var grid:AssistSkillGrid = grids[n-(index-1)*SKILL_COUNT];
				try{
					var psinfo:TPetSkillInfo = skills[n];
					var skillInfo:TSkillInfo = TableManager.getInstance().getSkillById(psinfo.skillId1);
					grid.gid = psinfo.id;
					grid.updataInfo(skillInfo.id);
					grid.visible = true;
				}catch(e:RangeError){
					grid.visible = false;
				}
			}
			pageLbl.text = index+"/"+Math.ceil(skills.length/SKILL_COUNT);
		}
		
		public function updateInfo(pid:int, pos:int, $callBack:Function):void{
			_pos = pos;
			_petID = pid;
			selectCall = $callBack;
			var data:PetEntryData = DataManager.getInstance().petData.getPetById(pid);
			var petType:int = TableManager.getInstance().getPetInfo(pid).race;
			skills.length = 0;
			var petSkillDic:Object = TableManager.getInstance().getPetSkillDic();
			for(var key:String in petSkillDic){
				var petSkill:TPetSkillInfo = petSkillDic[key];
				if(((petSkill.race == petType) || (0 == petSkill.race)) && !data.containsSID(petSkill.id)){
					skills.push(petSkill);
				}
			}
			currentIndex = 1;
			showPage(currentIndex);
		}
	}
}
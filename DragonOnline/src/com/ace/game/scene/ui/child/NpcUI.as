/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-20 下午2:19:16
 */
package com.ace.game.scene.ui.child {
	import com.ace.ICommon.ILivingUI;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TNpcFunction;
	import com.ace.loader.child.SwfLoader;
	import com.ace.ui.auto.AutoSpriteII;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	//Npc头像上的ui
	public class NpcUI extends AutoSpriteII implements ILivingUI {

		private var mc:SwfLoader;
		private var titleNameLbl:Label; //称号
		private var nameLbl:Label; //玩家名称
		private var blodImg:Image; //没有血
		
		public function NpcUI() {
			super("config/ui/scene/titleNpcWnd.xml");
		}

		override protected function init():void {
			this.mc=this.getUIbyID("mc") as SwfLoader;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.blodImg=this.getUIbyID("blodImg") as Image;
			
			this.titleNameLbl.visible=false;
			this.titleNameLbl.filters=this.nameLbl.filters=[FilterEnum.hei_miaobian];
			this.titleNameLbl.y -= 8;
		}

		/**更新：根据race不同，显示不同的样式*/
		public function updata(info:LivingInfo):void {
		}

		/**调整ui的位置*/
		public function updataPs(livingBase:LivingBase):void {
			this.x=livingBase.avatarPs.x - 91;
			this.y=livingBase.avatarPs.y - 2 * livingBase.bInfo.radius - 115;
		}

		/**显示玩家名称*/
		public function showName(info:*):void {
			this.showIcoState(info.taskState);
			var tinfo:TLivingInfo = TableManager.getInstance().getLivingInfo(info.tId);
			if((null != tinfo) && (0 != tinfo.NPCfunction) && !this.mc.visible){
				this.mc.visible = true;
				this.mc.x = 52;
				this.mc.y = 8;
				var tfun:TNpcFunction = TableManager.getInstance().getNpcFuncInfo(tinfo.NPCfunction);
				this.mc.update(tfun.flagPnfId);
			}
			
			if((null != tinfo) && (5 == tinfo.npcType)){
				this.titleNameLbl.filters = [FilterUtil.NotifyOutterFilter];
				this.titleNameLbl.defaultTextFormat = FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE5);
				this.nameLbl.filters = [FilterUtil.NotifyOutterFilter];
				this.nameLbl.defaultTextFormat = FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE5);
			}
			
			if(PlayerEnum.RACE_COLLECT == info.race || ((null != tinfo) && (5 == tinfo.npcType))){
				this.nameLbl.text=info.name;
			}else{
				this.nameLbl.text=info.name + "[lv" + info.level + "]";
			}
//			this.nameLbl.text=info.name + "[lv" + info.level + "-" + info.id + "]";
			if (info.tileNames.length > 0) {
				for each(var t:String in info.tileNames){
					if(null != t && "" != t){
						this.titleNameLbl.visible=true;
						this.titleNameLbl.text=t;
						break;
					}
				}
			}
		}
		
		
		private function showIcoState(type:int):void {
			this.mc.visible=false;
			this.mc.x = 90;
			this.mc.y = 90;
//			if (Math.random() > 0.3)
//				type=PlayerEnum.NPC_TASK_ACCEPT;
			if (type == PlayerEnum.NPC_TASK_ACCEPT) {
				this.mc.update(99980);
				this.mc.visible=true;
			}
			if (type == PlayerEnum.NPC_TASK_COMPLETE) {
				this.mc.update(99982);
				this.mc.visible=true;
			}
			if (type == PlayerEnum.NPC_TASK_UNDONE) {
				this.mc.update(99981);
				this.mc.visible=true;
			}
		}

		public function showTitles(info:LivingInfo):void {
		}

		public function showPs(str:String):void {
		}

		/**更新血值*/
		public function updataHp(info:LivingInfo):void {
//			this.blodImg.setWH(42 * info.baseInfo.hp / info.baseInfo.maxHp, 4);
			//			this.blodImg.setWH(42 * Math.random(), 4);
		}

		override public function die():void {
			this.mc.die();
			this.parent.removeChild(this);
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}

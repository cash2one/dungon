package com.ace.game.scene.player {
	import com.ace.astarII.child.INode;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.utils.DebugUtil;

	public class Living extends OtherPlayerModel {
		public function Living() {
			super();
		}

		override protected function onMoveOver():void {
			super.onMoveOver();
//			this.ui.showPs(this.nowTilePt().toString());
		}
	/*override public function moveTo(node:INode, act:String, slow:Boolean=false):void {
		super.moveTo(node, act, slow);
		trace("要移动的位置" + node.x + "-" + node.y);
	}

	override protected function onMoveOver():void {
		super.onMoveOver();
		this.localNextStep();
	}

	override protected function getPnfInfo(id:int):TPnfInfo {
		var info:TPnfInfo;
		info=TableManager.getInstance().getPnfInfo(id);
		return info;
	}

	override protected function getSkillPnfId(skillId:int):int {
		return TableManager.getInstance().getSkillInfo(skillId).effectId;
	}

	override protected function getActsInfo(id:int):TActsInfo {
		return TableManager.getInstance().getActsInfo(id);
	}

	//子类负责实现
	override protected function getActInfo(id:int, actName:String="defaultAct"):TActInfo {
		var info:TActInfo;
		info=TableManager.getInstance().getPnfActInfo(id, actName);
		return info;
	}*/


	}
}
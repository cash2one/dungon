/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-20 上午11:07:18
 */
package com.ace.game.scene.ui {
	import com.ace.ICommon.ILivingUI;
	import com.ace.ICommon.ISyncPsUI;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.ReuseEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.manager.ReuseManager;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.ui.chat.ChatBubble;
	import com.ace.game.scene.ui.child.CarUI;
	import com.ace.game.scene.ui.child.ItemUI;
	import com.ace.game.scene.ui.child.LivingUI;
	import com.ace.game.scene.ui.child.MonsterUI;
	import com.ace.game.scene.ui.child.NpcUI;
	import com.ace.game.scene.ui.child.RareBoxUI;
	import com.ace.game.scene.ui.effect.BubbleEffect;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.utils.DebugUtil;
	import com.leyou.enum.ConfigEnum;
	
	import flash.display.DisplayObject;

	/**
	 * 人物头顶UI显示
	 * @author ace
	 *
	 */
	internal class UILayerModel extends SpriteNoEvt {
		protected var livingUILayer:SpriteNoEvt; //头像
		protected var chatLayer:SpriteNoEvt; //聊天的
		protected var effctLayer:SpriteNoEvt; //特效的

		protected var uiDic:Object;

		public function UILayerModel() {
			this.init();
		}

		private function init():void {
			this.uiDic={};

			this.livingUILayer=new SpriteNoEvt();
			this.chatLayer=new SpriteNoEvt();
			this.effctLayer=new SpriteNoEvt();

			this.addChild(this.livingUILayer);
			this.addChild(this.chatLayer);
			this.addChild(this.effctLayer);
		}

		/**添加人物头像名称UI*/
		public function addLivingUI(livingBase:LivingBase, force:Boolean=false):ILivingUI {
			/*
			1：唯一
			2：同步位置
			3：人物消失删除
			4：更新血蓝值、更新高度、更新名称，保存到人物内
			*/
			var livingUI:ILivingUI;
			if (livingBase.race == PlayerEnum.RACE_SHENQI)
				return null;
			if (livingBase.race == PlayerEnum.RACE_HUMAN) {
				livingUI=new LivingUI();
			} else if (livingBase.race == PlayerEnum.RACE_MONSTER) {
				if (TableManager.getInstance().getLivingInfo(livingBase.bInfo.tId).type == PlayerEnum.MONSTER_BOSS) {
					//boss
				} else {
				}
				force && (livingUI=new MonsterUI());
			} else if (livingBase.race == PlayerEnum.RACE_ESCORT) {
				livingUI=new CarUI();
			} else if (livingBase.race == PlayerEnum.RACE_COLLECT) {
				if (TableManager.getInstance().getLivingInfo(livingBase.bInfo.tId).type == PlayerEnum.MONSTER_BOX) {
					//宝箱
					livingUI=new RareBoxUI();
				} else {
					livingUI=new NpcUI();
				}
			} else if (livingBase.race == PlayerEnum.RACE_ITEM) {
				livingUI=new ItemUI();
			} else {
				livingUI=new NpcUI();
			}
			if (!livingUI)
				return null;
			this.livingUILayer.addChild(livingUI as DisplayObject);
			this.addToSync(livingBase, livingUI as DisplayObject);
			return livingUI;
		}

		private var tmpChatBubble:ChatBubble;
		private var tmpLivingBase:LivingBase;

		/**添加聊天泡泡*/
		public function addChat(livingName:String, msgs:String, isForce:Boolean=false):void {
			if (SceneCore.sceneModel.isHideAll && !isForce)
				return;
			tmpLivingBase=null;
			tmpLivingBase=SceneCore.sceneModel.getLivingBy(livingName);
			if (!tmpLivingBase)
				return;

			this.addChatII(tmpLivingBase, msgs);
		}

		public function addChatII(livingBase:LivingBase, msgs:String, isForce:Boolean=false):void {
			/*
			1：唯一||或者没有
			2：同步位置||不同步位置
			3：倒计时删除
			4：更新说话内容
			*/
			if (SceneCore.sceneModel.isHideAll && !isForce)
				return;

			if (msgs.indexOf("<font") == -1) {
				msgs="<font color='#FFFFFF' size='12'>" + msgs + "</font>";
			}
			if (ReuseManager.getInstance().chatDic.hasUsedRender(livingBase.id.toString())) {
				this.tmpChatBubble=ReuseManager.getInstance().chatDic.getUsedRenderOfKey(livingBase.id.toString()) as ChatBubble;
			} else {
				this.tmpChatBubble=ReuseManager.getInstance().chatDic.getFreeRender() as ChatBubble;
				this.tmpChatBubble.ownerId=livingBase.id;
				this.tmpChatBubble.useKey=livingBase.id.toString();
				ReuseManager.getInstance().chatDic.addToUse(this.tmpChatBubble);
				this.chatLayer.addChild(this.tmpChatBubble);
			}
			if (!this.tmpChatBubble)
				DebugUtil.throwError("特效不够用了");

			this.tmpChatBubble.showContent(msgs);
			this.tmpChatBubble.updataPs(livingBase);

			this.addToSync(livingBase, this.tmpChatBubble);
			this.tmpChatBubble=null;
		}

		private var tmpBubbleEffect:BubbleEffect;
		private var effectArr:Array=[];

		/**
		 * 显示人物伤害等特效
		 *
		 * @param livingBase 人物
		 * @param effectType 动画类型
		 * @param num 数字
		 * @param color 颜色
		 * @param str 文字
		 * @param ico ico图片
		 *
		 */
		public function addEffect(livingBase:LivingBase, effectType:int, num:int, color:String, str:String="", ico:String="", ptArr:Array=null, showZero:Boolean=false, strFront:Boolean=true, times:int=1):void {
			trace("显示人物伤害等特效：" + effectType, num, color, str, ico);
			if (SettingManager.getInstance().assitInfo.isHideSkill)
				return;
//			if (effectType != EffectEnum.BUBBLE_LINE && times == 1) {
//				this._addEffect(livingBase, effectType, num, color, str, ico, ptArr, showZero, strFront); //修改为同时播放 2014/5/7 9:56:54
//				return;
//			}
//			
			for (var i:int=0; i < times; i++) {
				if(this.effectArr.length>=ConfigEnum.common10)
					this.effectArr.shift();
				this.effectArr.push([livingBase, effectType, int(num / times), color, str, ico, ptArr, showZero, strFront]);
			}

//			this.effectArr.push([livingBase, effectType, num, color, str, ico, ptArr, showZero, strFront]);
			if (!DelayCallManager.getInstance().has(this, this.play)) {
				this.play();
			}
		}

		public function removeEffect(livingBase:LivingBase):void {
			for (var i:int=0; i < this.effectArr.length; i++) {
				if (this.effectArr[i][0] == livingBase) {
					this.effectArr.splice(i, 1);
					i--;
				}
			}

		}

		private function play():void {
//			trace("---------------paly")
			if (this.effectArr.length <= 0)
				return;
			this._addEffect.apply(this, this.effectArr.shift());
			if (!DelayCallManager.getInstance().has(this, this.play)) {
				DelayCallManager.getInstance().add(this, play, "", 3);
			}
		}

		private function _addEffect(livingBase:LivingBase, effectType:int, num:int, color:String, str:String="", ico:String="", ptArr:Array=null, showZero:Boolean=false, strFront:Boolean=true):void {
			/*
			1：不唯一
			2：同步位置||不同步位置
			3：倒计时删除
			*/
//			trace("属性改变：" + str + "---" + num);
			if (!livingBase || !SettingManager.getInstance().settingInfo.numEffect)
				return;
			this.tmpBubbleEffect=ReuseManager.getInstance().bubbleEffectDic.getFreeRender() as BubbleEffect;
			//			trace(ReuseManager.getInstance().bubbleEffectDic.toString());
			if (!this.tmpBubbleEffect)
				DebugUtil.throwError("特效不够用了");

			this.effctLayer.addChild(this.tmpBubbleEffect);
			this.tmpBubbleEffect.show(effectType, num, color, str, ico, ptArr, showZero, strFront);
			this.tmpBubbleEffect.x=livingBase.x - this.tmpBubbleEffect.width * 0.5;
			var offsetY:Number=(null == ptArr) ? livingBase.bInfo.radius : livingBase.bInfo.radius * 2;
			this.tmpBubbleEffect.y=livingBase.y - livingBase.bInfo.radius - this.tmpBubbleEffect.width * 0.5;
			if (null == ptArr) {
				this.tmpBubbleEffect.y=livingBase.y - livingBase.bInfo.radius * 2 - this.tmpBubbleEffect.width * 0.5;
			}
			this.tmpBubbleEffect.play(effectType);

			this.tmpBubbleEffect.useType=ReuseEnum.BUBBLE_EFFECT_TYPE;
			this.tmpBubbleEffect.useKey=ReuseEnum.bubbleKey(ReuseEnum.BUBBLE_EFFECT_TYPE, this.tmpBubbleEffect.name);
			ReuseManager.getInstance().bubbleEffectDic.addToUse(this.tmpBubbleEffect); //一个人有多个
			this.tmpBubbleEffect=null;
		}


		/**掉血特效播放完毕*/
		public function onBubbleEffectOver(render:BubbleEffect):void {
			ReuseManager.getInstance().bubbleEffectDic.addToFree(render);
			this.effctLayer.removeChild(render);
		}

		/**同步人物信息位置*/
		public function autoSyncPs(livingBase:LivingBase):void {
			tmpArr=this.uiDic[livingBase.id];
			var dis:ISyncPsUI;
			if (tmpArr == null)
				return;
			for (var i:int=0; i < tmpArr.length; i++) {
				dis=tmpArr[i];
				dis.updataPs(livingBase);
			}
		}

		/**同步显示隐藏信息*/
		public function autoSyncVisible(livingBase:LivingBase):void {
			tmpArr=this.uiDic[livingBase.id];
			var dis:ISyncPsUI;
			if (tmpArr == null)
				return;
			for (var i:int=0; i < tmpArr.length; i++) {
				dis=tmpArr[i];
				dis.visible=livingBase.visible;
			}
		}

		private var tmpArr:Array;

		/**添加到同步列表*/
		private function addToSync(livingBase:LivingBase, render:DisplayObject):void {
			if (this.uiDic[livingBase.id]) {
				tmpArr=this.uiDic[livingBase.id];
			} else {
				tmpArr=[];
				this.uiDic[livingBase.id]=tmpArr;
			}
			tmpArr.push(render);
		}

		public function changeSyncId(preId:int, currentId:int):void {
			tmpArr=this.uiDic[preId];
			if (tmpArr && preId != currentId) {
				delete this.uiDic[preId];
				this.uiDic[currentId]=tmpArr;
			}
		}

		/**
		 * 从同步列表内删除
		 * @param id livingId
		 * @param render 要删除的render
		 *
		 */
		public function removeFromSync(id:int, render:DisplayObject):void {
			tmpArr=this.uiDic[id];
			if (!tmpArr)
				return;
			if (tmpArr.indexOf(render) == -1)
				return;
			tmpArr.splice(tmpArr.indexOf(render), 1);
		}

	}
}

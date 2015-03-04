/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-25 上午10:34:35
 */
package com.ace.game.scene.ui.effect {
	import com.ace.ICommon.IUse;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.ReuseEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.reuse.ReUseModel;
	import com.ace.ui.img.child.Image;

	import flash.display.DisplayObject;

	//负责处理拼接为需要的图片
	public class BubbleModel extends ReUseModel {

		public function BubbleModel() {
			super();
			this.init();
		}

		private function init():void {
//			DebugUtil.addFlag(0, 0, this, 0x00FFFF, 4);
		}


		private var tmpImg:Image;
		private var tmpNumArr:Array;

//		private var tmpX:Number;
//		private var tmpY:Number;

		/**
		 *
		 * @param effectType 动画类型
		 * @param num 数字
		 * @param color 颜色
		 * @param str 文字
		 * @param ico ico图片
		 *
		 */
		public function show(effectType:int, num:int, color:String, str:String="", ico:String="", ptArr:Array=null, showZero:Boolean=false):void {
//			ico="20";
			if (null != ico && "" != ico) {
				this.addImg(PlayerEnum.URL_ICO_SKILL + ico + ".png", 36, 36);
			}

			if (null != str && "" != str) {
				this.addImg(PlayerEnum.URL_EFFECT_NUM + str + "_" + color + ".png");
			}

			if ((num == 0) && !showZero)
				return;
			this.addImg(PlayerEnum.URL_EFFECT_NUM + // 
				(num >= 0 ? EffectEnum.FILE_ADD_NUM : EffectEnum.FILE_SUB_NUM) + "_" + color + ".png");

			tmpNumArr=String(Math.abs(num)).split("");
			for (var i:int=0; i < tmpNumArr.length; i++) {
				this.addImg(PlayerEnum.URL_EFFECT_NUM + tmpNumArr[i].toString() + "_" + color + ".png");
			}
		}

		private function addImg(fileName:String, $w:Number=-1, $h:Number=-1):void {
			tmpImg=ReuseManager.getInstance().imgDic.getFreeRender() as Image;
//			tmpImg.opaqueBackground=0x333333;
			if (!tmpImg)
				return;
			tmpImg.useType=ReuseEnum.IMG_TYPE_BUBBLE;
			tmpImg.useKey=ReuseEnum.imgKey(ReuseEnum.IMG_TYPE_BUBBLE, tmpImg.name);
			ReuseManager.getInstance().imgDic.addToUse(tmpImg);
			tmpImg.updateBmp(fileName, null, false, $w, $h);
			tmpImg.x=this.width - 5;
			tmpImg.y=-tmpImg.height >> 1;
			this.addChild(tmpImg);
		}

		/**清除*/
		protected function clear():void {
			var obj:DisplayObject;
			while (this.numChildren) {
				obj=this.getChildAt(this.numChildren - 1);
				if (obj is Image) {
					ReuseManager.getInstance().imgDic.addToFree(obj as IUse);
				}
			}
//			ReuseManager.getInstance().imgDic.debug();
		}
	}
}

/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-12-2 下午2:31:40
 */
package com.leyou.utils {

	import com.ace.enum.EffectEnum;
	import com.ace.manager.LayerManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	
	import flash.geom.Point;

	public class EffectUtil {

		static private var effectNameDic:Object; //根据服务器的规则写的
		static private var propNameDic:Object; //根据文件名称规则写的

		static private function init():void {
			if (!effectNameDic) {
				effectNameDic={};
				effectNameDic[1]="";
				effectNameDic[2]=EffectEnum.BAO_JI;
				effectNameDic[3]=EffectEnum.SHAN_BI;
			}

			if (!propNameDic) {
				propNameDic={};
				propNameDic[1]="smsx";
				propNameDic[2]="mfsx";
				propNameDic[3]="jl";
				propNameDic[4]="wg";
				propNameDic[5]="wf";
				propNameDic[6]="fg";
				propNameDic[7]="ff";
				propNameDic[8]="bj";
				propNameDic[9]="rx";
				propNameDic[10]="mz";
				propNameDic[11]="sb";
				propNameDic[12]="bs";
				propNameDic[13]="sh";
				propNameDic[16]="pkz";
				propNameDic[17]="zf";
				propNameDic[18]="xy";
				propNameDic[19]="cy";
				propNameDic[20]="jy";
				propNameDic[21]="sd";
				propNameDic[22]="sm";
				propNameDic[23]="fl";
				propNameDic[24]="jl";
				propNameDic[29]="hl";
				propNameDic[31]="bg";
				propNameDic[32]="jb";
			}
		}

		static public function getEffectName(type:int):String {
			init();
			return effectNameDic[type];
		}

		static public function getPropName(type:int):String {
			init();
			return propNameDic[type];
		}


		public static function flyWordEffect(str:String, p:Point,color:String="#ffff00"):void {

			var b:Label=new Label();
			b.htmlText="<font color='"+color+"'>" + str + "</font>";
			LayerManager.getInstance().clientTipLayer.addChild(b);

			b.x=p.x;
			b.y=p.y;

			TweenMax.to(b, 4, {y: b.y - 40, alpha: 0, onComplete: complete});

			function complete():void {
				LayerManager.getInstance().clientTipLayer.removeChild(b);
			}

		}

		public static function flyImageEffect(img:Image, p:Point):void {
			 
			LayerManager.getInstance().clientTipLayer.addChild(img);
			
			img.x=p.x;
			img.y=p.y;
			
			TweenMax.to(img, 4, {y: img.y - 40, alpha: 0, onComplete: complete});
			
			function complete():void {
				LayerManager.getInstance().clientTipLayer.removeChild(img);
			}
			
		}
 

	}
}
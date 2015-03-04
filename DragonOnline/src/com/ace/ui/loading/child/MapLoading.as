/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-12-2 下午6:36:22
 */
package com.ace.ui.loading.child {
	import com.ace.ICommon.ILoading;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;

	public class MapLoading extends AutoSprite implements ILoading {
//		private var progressBar:ProgressBar;
		
		private static const PROGRESS_OFFSET:int = 45;
		private static const PROGRESS_VALID_WIDTH:int = 675;
		
		private var logoImg:Image;
		
		private var proressBgImg:Image;
		
		private var progressCoverImg:Image;
		
//		private var contanier:Sprite;
		
		private var pointLbl:Label;
		
		private var preProgress:Number;
		
		private var logoEffect:SwfLoader;
		
		private var progressLbl:Label;
		
		private var noticeLbl:Label;
		
		private var linkLbl:Label;
		
		private var bgImg:Image;

		public function MapLoading() {
			super(LibManager.getInstance().getXML("config/ui/loading/MapLoading.xml"));
			this.init();
		}

		private function init():void {
			mouseChildren = true;
//			this.progressBar=this.getUIbyID("progressBar") as ProgressBar;
			logoImg = getUIbyID("logoImg") as Image;
			proressBgImg = getUIbyID("progressBgImg") as Image;
			progressCoverImg = getUIbyID("progressCoverImg") as Image;
			pointLbl = getUIbyID("pointLbl") as Label;
			logoEffect = new SwfLoader(99959);
			addChild(logoEffect);
			progressLbl = getUIbyID("progressLbl") as Label;
			noticeLbl = getUIbyID("noticeLbl") as Label;
			linkLbl = getUIbyID("linkLbl") as Label;
			progressLbl.text = "0%";
			logoEffect.x = progressCoverImg.x - 75
			logoEffect.y = progressCoverImg.y - 78;
			progressCoverImg.scrollRect = new Rectangle(0, 0, PROGRESS_OFFSET, progressCoverImg.bitmapData.height);
			linkLbl.mouseEnabled = true;
			linkLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			bgImg = new Image();
			addChildAt(bgImg, 0);
			logoImg.x = 0;
			logoImg.y = 0;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if("StandAlone" != Capabilities.playerType){
				ExternalInterface.call("location.reload()");
			}else{
				System.exit(0);
			}
		}
		
		public function onLoading(byteNow:int, byteAll:int):void {
//			this.progressBar.updateProgress(Number((byteNow / byteAll).toFixed(2)));
			setProgress(byteNow / byteAll)
		}

		public function reset():void {
			logoImg.visible = true;
			var pid:int = int(Math.random()*10000)%7 + 1;
			var content:String = TableManager.getInstance().getPromptInfo(pid).des;
			pointLbl.text = content;
			setProgress(0);
			var surl:String = getBgUrl();
			bgImg.updateBmp(surl, onImgLoaded);
		}
		
		private function onImgLoaded():void{
			logoImg.visible = false;
		}
		
		private function getBgUrl():String{
			var ranNum:String = StringUtil.fillTheStr(int(Math.random()*10000)%2+1, 2, "0", true);
			var surl:String = "ui/wallpaper/loding_bg_{index}.jpg";
			surl = StringUtil.substitute(surl, ranNum);
			return surl;
		}
		
		private function setProgress(rate:Number):void{
			if(rate == preProgress){
				return;
			}
			if(isNaN(rate)){
				rate = 0.0;
			}
			if(rate > 1){
				rate = 1;
			}
			preProgress = rate;
			progressLbl.text = (preProgress*100).toFixed()+"%";
			var viewRect:Rectangle = progressCoverImg.scrollRect;
			var changeWidth:Number = PROGRESS_OFFSET + PROGRESS_VALID_WIDTH * preProgress;
			viewRect.width = changeWidth;
			progressCoverImg.scrollRect = viewRect;
			logoEffect.x = progressCoverImg.x - 75 + PROGRESS_VALID_WIDTH * preProgress;
		}
		
		public override function get width():Number{
			return 1000;
		}
		
		public override function get height():Number{
			return 600;
		}

		public function onLoaded():void {
		}

		public function showTip(str:String):void {
		}
	}
}
package com.leyou.ui.wing {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WingUnWnd extends AutoSprite {

		private var viewList:Array=[];
		private var buyBtn:ImgButton;

		private var wingAvatar:SwfLoader;

		public function WingUnWnd() {
			super(LibManager.getInstance().getXML("config/ui/wing/wingUnWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.viewList[PropUtils.getIndexByStr("物理攻击")]=this.getUIbyID("phAttLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("物理防御")]=this.getUIbyID("phDefLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("法术攻击")]=this.getUIbyID("magicAttLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("法术防御")]=this.getUIbyID("magicDefLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("生命上限")]=this.getUIbyID("hpLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("法力上限")]=this.getUIbyID("mpLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("暴击等级")]=this.getUIbyID("critLvLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("命中等级")]=this.getUIbyID("hitLvLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("闪避等级")]=this.getUIbyID("dodgeLvLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("韧性等级")]=this.getUIbyID("toughLvLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("守护等级")]=this.getUIbyID("guaidLvLbl") as Label;
			this.viewList[PropUtils.getIndexByStr("必杀等级")]=this.getUIbyID("killLvLbl") as Label;

			this.buyBtn=this.getUIbyID("buyBtn") as ImgButton;
			this.buyBtn.addEventListener(MouseEvent.CLICK, onClick);

			var infoXml:XML=LibManager.getInstance().getXML("config/table/Wing_Base.xml");
			var xml:XML=infoXml.data[0];

			for (var i:int=1; i <= 13; i++) {
				if (int(xml.attribute("W_AttID" + i)) == 3)
					continue;

				this.viewList[int(xml.attribute("W_AttID" + i)) - 1].text=xml.attribute("W_AttNum" + i);
			}

			this.wingAvatar=new SwfLoader(38099);
			this.addChild(this.wingAvatar);

			this.wingAvatar.x=210;
			this.wingAvatar.y=308;

			this.x=-12;
			this.y=2;
		}

		private function onClick(e:MouseEvent):void {
			PopupManager.showRadioConfirm(TableManager.getInstance().getSystemNotice(1216).content, "" + ConfigEnum.WingOpenCost,ConfigEnum.WingOpenBindCost + "",  function(type:int):void {
			 
				if (type == 0)
					Cmd_Market.cm_Mak_W(1);
				else
					Cmd_Market.cm_Mak_W(0);
				
			}, null, false, "openWingConfirm");
		}

		
		public function flyMovie():void{
			var mpt:Point = wingAvatar.localToGlobal(new Point(0, 0));
			var flyMovie:SwfLoader = new SwfLoader(ConfigEnum.WingShowModeID);
			//			flyMovie.playAct("stand", 6);
			flyMovie.x = mpt.x;
			flyMovie.y = mpt.y;
			LayerManager.getInstance().windowLayer.addChild(flyMovie);
			var endW:int = flyMovie.width;
			var endH:int = flyMovie.height;
			var beginX:int = flyMovie.x + flyMovie.width*0.5;
			var beginY:int = flyMovie.y + flyMovie.height*0.5;
			var endX:int = UIEnum.WIDTH*0.5;
			var endY:int = UIEnum.HEIGHT*0.5;
			TweenMax.to(flyMovie, 3, {bezierThrough: [{x:beginX, y:beginY}, {x: endX, y: endY}], width: endW*0.5, height: endH*0.5, ease: Expo.easeIn(1,10,1,1), onComplete:onMoveOver, onCompleteParams:[flyMovie]})
		}

		private function onMoveOver(mc:SwfLoader):void{
			if(LayerManager.getInstance().windowLayer.contains(mc)){
				LayerManager.getInstance().windowLayer.removeChild(mc);
			}
			mc.die();
		}


	}
}

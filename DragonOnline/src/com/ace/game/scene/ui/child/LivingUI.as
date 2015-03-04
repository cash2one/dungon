package com.ace.game.scene.ui.child {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.UIManager;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.PkMode;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;

	/**
	 * 场景上人物头顶UI
	 * @author ace
	 *
	 */
	public class LivingUI extends BaseLiving {

		private static var PfVipWidth:int;
		private var titleNameLbl:Label; //称号
		private var guildNameLbl:Label; //行会名称七个字
		private var teamImg:Image; //组队标识
		private var pfImg:Image;
		private var blodBgImg:Image;
		private var blodImg:ProgressImage;
		private var titles:Vector.<TitleRender>;
		private var nameLblWidth:int;
		private var _info:*;

		private var baseX:int;

		public function LivingUI() {
//			super("config/ui/scene/LivingUI.xml");
			super();
		}

		override protected function init():void {
			super.init();
			titleNameLbl=new Label("", FontEnum.getTextFormat("Purple14Center"));
			guildNameLbl=new Label("", FontEnum.getTextFormat("Green12center"));
			titleNameLbl.autoSize=TextFieldAutoSize.LEFT;
			guildNameLbl.autoSize=TextFieldAutoSize.LEFT;
			addChild(titleNameLbl);
			addChild(guildNameLbl);
			guildNameLbl.y = 17;
			teamImg = new Image("ui/team/flag_blue.png");
			elementImg = new Image();
			blodBgImg = new Image("ui/other/HP_BG_mini.png");
			pfImg = new Image();
			addChild(pfImg);
			addChild(teamImg);
			addChild(elementImg);
			addChild(blodBgImg);
			if (null == blodImg) {
				blodImg = new ProgressImage();
				addChild(blodImg);
				blodImg.updateBmp("ui/other/HP_Red_mini.png");
			}
			
			pfImg.visible = false;
			vipImg.visible = false;
			teamImg.visible = false;
			elementImg.visible = false;
			titleNameLbl.visible=false;
			guildNameLbl.visible = false;

			nameLbl.filters = [FilterEnum.hei_miaobian];
			titleNameLbl.filters = [FilterEnum.hei_miaobian];
			guildNameLbl.filters = [FilterEnum.hei_miaobian];
			
//			pfImg.updateBmp("ui/name/qq_vip_year_01.png");
//			pfImg.visible = true;
		}

		public override function addChild(child:DisplayObject):DisplayObject {
			return super.addChild(child);
		}

		/**调整ui的位置*/
		public override function updataPs(livingBase:LivingBase):void {
			x=Math.round(livingBase.avatarPs.x - nameLblWidth * 0.5 - baseX);
			y=Math.round(livingBase.avatarPs.y - 2 * livingBase.bInfo.radius - 60);
		}

		/**显示玩家名称*/
		public override function showName(info:*):void {
//			var str:String=info.name + "[" + info.id + "][lv" + info.level + "][" + info.speed + "]";
			_info = info;
			var str:String=info.name + "[lv" + info.level + "]";
			// 行会战争
			var guildInfo:Array = MyInfoManager.getInstance().guildArr;
			var guildWar:Boolean = guildInfo[1] && (guildInfo[0] == info.tileNames[0]);
			// 行会争霸
			var type:int=MapInfoManager.getInstance().type;
			var guildBattle:Boolean = ((type == SceneEnum.SCENE_TYPE_GUCJ) || (type == SceneEnum.SCENE_TYPE_CYCJ)) && (Core.me.info.guildName != info.tileNames[0]);
			if(guildWar || guildBattle){
				nameLbl.htmlText=StringUtil_II.getColorStr(str, getColor(PkMode.PK_COLOR_ORANGE));
			}else{
				nameLbl.htmlText=StringUtil_II.getColorStr(str, getColor(info.color));
			}
			// 更新元素状态
			elementImg.visible=true;
			switch (info.baseInfo.yuanS) {
				case 0:
					elementImg.visible=false;
					break;
				//0无元素 1金 2木 3水 4火 5土
				case 1:
					elementImg.updateBmp("ui/name/el_gold.png");
					break;
				case 2:
					elementImg.updateBmp("ui/name/el_wood.png");
					break;
				case 3:
					elementImg.updateBmp("ui/name/el_water.png");
					break;
				case 4:
					elementImg.updateBmp("ui/name/el_fire.png");
					break;
				case 5:
					elementImg.updateBmp("ui/name/el_dirt.png");
					break;
				default:
					trace("error")          
					break;
			}
			// 更新vip
			vipImg.visible=true;
			switch (info.vipLv) {
				case 0:
					vipImg.visible=false;
					break;
				default:
					vipImg.updateBmp("ui/name/vip" + info.vipLv + ".jpg");
					break;
			}
			// 更新组队状态
			var hasTeam:Boolean=UIManager.getInstance().teamWnd && UIManager.getInstance().teamWnd.compareTeamNoSelfPlayName(info.name);
			teamImg.visible=hasTeam;

//			UIManager.getInstance().chatWnd.chatNotice("-----isTencent = "+Core.isTencent);
			//平台VIP
			if(Core.isTencent){
//				UIManager.getInstance().chatWnd.chatNotice("-----pfVipType = "+info.pfVipType);
				pfImg.visible = (0 != info.pfVipType);
				var url:String;
				// 腾讯
				if(1 == info.pfVipType){
					url = StringUtil.substitute("ui/name/qq_vip_0{1}.png", info.pfVipLv);
					pfImg.updateBmp(url);
					PfVipWidth = 24; 
				}else if(2 == info.pfVipType){
					url = StringUtil.substitute("ui/name/qq_vip_year_0{1}.png", info.pfVipLv);
					pfImg.updateBmp(url);
					PfVipWidth = 39;
				}
			}
			adjustLocation();
		}

		public override function showPs(str:String):void {
		}

		/**更新血值*/
		public override function updataHp(info:LivingInfo):void {
			//			blodImg.setWH(42 * info.baseInfo.hp / info.baseInfo.maxHp, 4);
			//			if(blodImg.loaded){
			blodImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			//			}
		}


		//		private var tmpY:Number=429;

		private function showGuildName(str:String):void {
			if (str == "")
				return;
			guildNameLbl.visible=true;
			guildNameLbl.text=str;
			//			tmpY-=guildNameLbl.height;
			//			guildNameLbl.y=tmpY;
		}



		public override function showTitles(info:LivingInfo):void {
			removeTitle();
			showGuildName(info.tileNames[0]);
			var tInfo:TTitle;
			for (var i:int=1; i < info.tileNames.length; i++) {
				if (info.tileNames[i] == "")
					continue;
				tInfo=TableManager.getInstance().getTitleByID(info.tileNames[i]);
				if (tInfo == null)
					continue;
				if ("" == tInfo.Bottom_Pic) {
					titleNameLbl.visible=true;
					titleNameLbl.text=tInfo.name;
					titleNameLbl.textColor=com.ace.utils.StringUtil.strToHex(tInfo.fontColour);
					titleNameLbl.filters=[new GlowFilter(com.ace.utils.StringUtil.strToHex(tInfo.borderColour), 1, 1.3, 1.3, 7, 1)];
				} else {
					if (null == titles) {
						titles=new Vector.<TitleRender>();
					}
					var tr:TitleRender=new TitleRender();
					tr.updateInfo(tInfo);
					titles.push(tr);
					addChild(tr);
				}
			}
			switchVisible(!SettingManager.getInstance().assitInfo.isHideOther);
//			adjustLocation();
		}


		/**
		 * 调整各个位置
		 *
		 */
		protected override function adjustLocation():void {
			// 调整横向坐标
			baseX = nameLbl.x;
			var maxW:uint = nameLbl.width;
			if(vipImg.visible) {
				maxW += 34;
				vipImg.x = baseX - 34;
				baseX = vipImg.x;
			}
			if(pfImg.visible){
				maxW += PfVipWidth;
				pfImg.x = baseX - PfVipWidth;
				baseX = pfImg.x;
			}
			if(elementImg.visible){
				maxW += 25;
			}
			if(teamImg.visible){
				maxW += 16;
			}
			if (elementImg.visible) {
				elementImg.x=nameLbl.x +nameLbl.width;
				teamImg.x=elementImg.x + /*elementImg.width*/ 16;
			} else {
				teamImg.x = nameLbl.x +nameLbl.width;
			}
			titleNameLbl.x=baseX + (maxW - titleNameLbl.width) * 0.5;
			guildNameLbl.x=baseX + (maxW - guildNameLbl.width) * 0.5;
			blodBgImg.x=baseX + (maxW - /*blodBgImg.width*/ 42) * 0.5;
			blodImg.x=blodBgImg.x;

			// 调整纵向坐标
			guildNameLbl.y=nameLbl.y - guildNameLbl.height;
			if (guildNameLbl.visible) {
				titleNameLbl.y=guildNameLbl.y - titleNameLbl.height;
			} else {
				titleNameLbl.y=nameLbl.y - titleNameLbl.height;
			}
			//			nameLbl.y = guildNameLbl.y + guildNameLbl.height;
			vipImg.y=nameLbl.y + nameLbl.height * 0.5 - /*vipImg.height*/ 16 * 0.5;
			elementImg.y=nameLbl.y + nameLbl.height * 0.5 - /*elementImg.height*/ 16 * 0.5;
			teamImg.y=nameLbl.y + nameLbl.height * 0.5 - /*teamImg.height*/ 18 * 0.5;
			pfImg.y=nameLbl.y + nameLbl.height * 0.5 - 16;
			blodBgImg.y=nameLbl.y + nameLbl.height+3;
			blodImg.y=blodBgImg.y;

			if (titles && titles.length) {
				var baseY:Number=0;
				if (titleNameLbl.visible) {
					baseY=titleNameLbl.y;
				} else if (guildNameLbl.visible) {
					baseY=guildNameLbl.y;
				} else {
					baseY=nameLbl.y;
				}
				var l:int=titles.length;
				for (var n:int=0; n < l; n++) {
					titles[n].x=/*nameLbl.x + */baseX+(maxW - 189) * 0.5;
					titles[n].y=baseY - (n + 1) * 50;
				}
			}
			nameLblWidth=maxW;
		}

		private function removeTitle():void {
			guildNameLbl.visible=false;
			titleNameLbl.visible=false;
			while (titles && titles.length) {
				removeChild(titles.pop());
			}
		}

		override public function die():void {
			parent.removeChild(this);
		}
		
		public override function get livingName():String{
			if(null != _info){
				return _info.name;
			}
			return null;
		}
		
		public override function switchVisible($visible:Boolean):void{
			if ((null != titles) && titles.length) {
				var l:int=titles.length;
				for (var n:int=0; n < l; n++) {
					titles[n].visible = $visible;
				}
				titleNameLbl.visible = $visible;
			}
			adjustLocation();
		}
	}
}

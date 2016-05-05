package com.leyou.data.tips {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.leyou.util.ZDLUtil;

	/**
	 *需要tips内容显示的时候服务器主动下发给客户端，客户端缓存此信息

装备属性	其他属性以后再加

itemid   --物品id
qh       --强化等级
bd       --绑定
wg       --物攻
wf       --物防
fg       --法攻
ff       --法防
qh_wg       --强化物攻
qh_wf       --强化物防
qh_fg       --强化法攻
qh_ff       --强化法防
qh_sm       --强化生命
qh_fl       --强化法力

sm       --生命
fl       --法力
bj       --暴击
rx       --韧性
mz       --命中
sb       --闪避
bs       --必杀
sh       --守护
zdl      --战斗力
没有某项属性时 不发某属性

	 * @author Administrator
	 *
	 */
	public class TipsInfo {

		/**
		 *--物品id
		 */
		public var itemid:int=0;

		/**
		 *--强化等级
		 */
		public var qh:int=0;

		/**
		 * --绑定 1 是绑定 0 是未绑定
		 * @default
		 */
		public var bd:int=0;

		/**
		 * --物攻
		 * @default
		 */
		public var wg:int=0;

		/**
		 * --物防
		 * @default
		 */
		public var wf:int=0; //

		/**
		 * --法攻
		 * @default
		 */
		public var fg:int=0; //  

		/**
		 * --法防
		 * @default
		 */
		public var ff:int=0; // 

		/**
		 * --生命
		 * @default
		 */
		public var sm:int=0; //  

		/**
		 *  --法力
		 * @default
		 */
		public var fl:int=0; // 

		/**
		 * --暴击
		 * @default
		 */
		public var bj:int=0; //  

		/**
		 * --韧性
		 * @default
		 */
		public var rx:int=0; //  

		/**
		 * --命中
		 * @default
		 */
		public var mz:int=0; //  

		/**
		 * --闪避
		 * @default
		 */
		public var sb:int=0; //  

		/**
		 * --必杀
		 * @default
		 */
		public var bs:int=0; //  	

		/**
		 * --守护
		 * @default
		 */
		public var sh:int=0; //  

		/**
		 * --战斗力
		 * @default
		 */
		public var zdl:int=0;

		/**
		 * --强化物攻
		 */
		public var qh_wg:int;
		/**
		 * --强化物防
		 */
		public var qh_wf:int;
		/**
		 * --强化法攻
		 */
		public var qh_fg:int;
		/**
		 * --强化法防
		 */
		public var qh_ff:int;
		/**
		 * --强化生命
		 */
		public var qh_sm:int;
		/**
		 * --强化法力
		 */
		public var qh_fl:int;

		/**
		 * uid
		 */		
		public var uid:String;
		
		/**
		 *到期时间 
		 */		
		public var t:int=0;

		/**
		 *满战斗力 
		 */		
		public var mzdl:int=0;

		public var p:Object;
		
		/**
		 *限时时间 
		 */		
		public var dtime:int;
		
		/**
		 *祝福 
		 */		
		public var zf:int;
		
		/**
		 * ele当前元素类型
		 */		
		public var ele:int;
		
		/**
		 * elea元素攻击值
		 */		
		public var elea:int;
		 
		/**
		 *0 游戏币
1 绑定元宝
2 元宝
3 真气
4 碎片
5 荣誉
6 巨龙点数
7 功勋
		 */		
		public var moneyType:int=0;
		public var moneyNum:int=0;
		public var moneyItemid:int=0;
		
		/**
		 *0普通; 1,商店; 2,对比; 3,背包;9,其他;
		 */		
		public var istype:int=0;
		
		public var isdiff:Boolean=false;
		
		public var isUse:Boolean=false;
		
		public var isShowPrice:Boolean=true;
		
		/**
		 *人物身上的位置 
		 */		
 		public var playPosition:int=-1;
		
		public var otherPlayer:Boolean=false;
		
		public function TipsInfo(data:Object=null) {
			if (data == null)
				return;

			var key:String;
			for (key in data) {
				this[key]=data[key];
			}

			
			
		}

		/**
		 * <T>将数据序列化字符串</T>
		 * 
		 * @return 序列化对象
		 * 
		 */		
		public function serialize():String{
			var content:String = "{\"itemid\":"+itemid+",\"qh\":"+qh+",\"t\":"+t+",\"mzdl\":"+mzdl+",\"zdl\":"+zdl;
			for(var k:String in p){
				if(0 != p[k]){
					content += (",\"" + k + "\":" + p[k]);
				}
			}
			content+="}";
			return content;
		}
		
		/**
		 * <T>反序列化对象</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public function unserialize(obj:Object):void{
			p = new Object();
			for(var key:String in obj){
				if(hasOwnProperty(key)){
					this[key] = obj[key];
				}else{
					p[key] = obj[key];
				}
			}
		}
		
		public function strengthZdl(lv:int):uint{
//			var zdl:uint = (int(p[4])*zdlElement(4).rate + int(p[6])*zdlElement(6).rate + int(p[5])*zdlElement(5).rate + int(p[7])*zdlElement(7).rate + int(p[1])*zdlElement(1).rate + int(p[2])*zdlElement(2).rate) * Math.pow(1.09, lv) + int(p[11])*zdlElement(11).rate + int(p[10])*zdlElement(10).rate + int(p[8])*zdlElement(8).rate + int(p[9])*zdlElement(9).rate + int(p[12])*zdlElement(12).rate + int(p[13])*zdlElement(13).rate;
			var info:TEquipInfo = TableManager.getInstance().getEquipInfo(itemid);
			return ZDLUtil.computation(p[1], p[2], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], info.fixed_attack, info.fixed_defense, lv);
		}
		
		public function hasOwner():Boolean{
			if(null == p){
				return false;
			}
			var pc:int = 0;
			for(var key:String in p){
				if(0 != int(p[key])){
					pc++;
				}
			}
			return (0 != pc)
		}
		
		public function clear():void{
			itemid = 0;
			qh = 0;
			bd = 0;
			wg = 0;
			wf = 0;
			fg = 0;  
			ff = 0; 
			sm = 0;  
			fl = 0; 
			bj = 0;  
			rx = 0;
			mz = 0;  
			sb = 0;  
			bs = 0; 	
			sh = 0;  
			zdl = 0;
			qh_wg = 0;
			qh_wf = 0;
			qh_fg = 0;
			qh_ff = 0;
			qh_sm = 0;
			qh_fl = 0;
			uid="";
			t = 0;
			mzdl = 0;
			moneyType = 0;
			moneyNum = 0;
			moneyItemid = 0;
			istype = 0;
			isdiff=false;
			isUse=false;
			p = null;
		}
	}
}

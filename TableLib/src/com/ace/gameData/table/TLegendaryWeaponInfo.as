package com.ace.gameData.table
{
	public class TLegendaryWeaponInfo
	{
		public var id:int;
		
		// 1-战 2-法 3-术 4-游侠
		public var profession:int;
		
		// 1-武器 2-衣服
		public var type:int;
		
		public var productId:int;
		
		public var productImg:String;
		
		public var produceEImg:String;
		
		private var mixtureEquipList:Vector.<int> = new Vector.<int>();
		
		private var materialList:Vector.<int> = new Vector.<int>();
		
		private var materialNumList:Vector.<int> = new Vector.<int>();
		
		public var money:int;
		
		public var energy:int;
		
		public var honor:int;
		
		public var yb:int;
		
		
		public var weaponId:int;
		
		public var suit:int;
		
		public function TLegendaryWeaponInfo(xml:XML){
			id = xml.@Formula_ID;
			profession = xml.@profession;
			type = xml.@Formula_Type;
			productId = xml.@Product_ID;
			productImg = xml.@Product_Model1;
			produceEImg = xml.@Product_Model2;
			money = xml.@M_Money;
			energy = xml.@M_energy;
			honor = xml.@M_Honor;
			yb = xml.@M_YB;
			weaponId = xml.@Product_pnf1;
			suit = xml.@Product_pnf2;
			var equipId:int = xml.@equip1;
			if(0 != equipId){
				mixtureEquipList.push(equipId);
			}
			equipId = xml.@equip2;
			if(0 != equipId){
				mixtureEquipList.push(equipId);
			}
			equipId = xml.@equip3;
			if(0 != equipId){
				mixtureEquipList.push(equipId);
			}
			equipId = xml.@equip4;
			if(0 != equipId){
				mixtureEquipList.push(equipId);
			}
			
			var materialId:int = xml.@Mixture1;
			var materialNuum:int = xml.@M_Num1;
			if(0 != materialId){
				materialList.push(materialId);
				materialNumList.push(materialNuum);
			}
			
			materialId = xml.@Mixture2;
			materialNuum = xml.@M_Num2;
			if(0 != materialId){
				materialList.push(materialId);
				materialNumList.push(materialNuum);
			}
			
			materialId = xml.@Mixture3;
			materialNuum = xml.@M_Num3;
			if(0 != materialId){
				materialList.push(materialId);
				materialNumList.push(materialNuum);
			}
			
			materialId = xml.@Mixture4;
			materialNuum = xml.@M_Num4;
			if(0 != materialId){
				materialList.push(materialId);
				materialNumList.push(materialNuum);
			}
			
			materialId = xml.@Mixture5;
			materialNuum = xml.@M_Num5;
			if(0 != materialId){
				materialList.push(materialId);
				materialNumList.push(materialNuum);
			}
		}
		
		public function get mixtrueEquipLength():int{
			return mixtureEquipList.length;
		}
		
		public function getMixtrueEquip(idx:int):int{
			if((idx >= 0) && (idx < mixtureEquipList.length)){
				return mixtureEquipList[idx];
			}
			return -1;
		}
		
		public function get materialLength():int{ 
			return materialList.length;
		}
		
		public function getMaterial(idx:int):int{
			if((idx >= 0) && (idx < materialList.length)){
				return materialList[idx];
			}
			return -1;
		}
		
		public function getMaterialNum(idx:int):int{
			if((idx >= 0) && (idx < materialNumList.length)){
				return materialNumList[idx];
			}
			return -1;
		}
	}
}
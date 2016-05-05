package com.leyou.data.elementAdditional
{
	public class ElementData
	{
		public var ctype:int;
		
		public var stime:int;
		
		private var entries:Vector.<Elementry> = new Vector.<Elementry>();
		
		public function ElementData(){
		}
		
		public function getEntry(index:int):Elementry{
			return entries[index];
		}
		
		public function getEntryByType(type:int):Elementry{
			for each(var entry:Elementry in entries){
				if(entry.type == type){
					return entry;
				}
			}
			return null;
		}
		
		public function loadData_I(obj:Object):void{
			ctype = obj.cetype;
			stime = obj.suptime;
			var list:Array = obj.elelist;
			var length:int = list.length;
			entries.length = list.length;
			for(var n:int = 0; n < length; n++){
				var entry:Elementry = entries[n];
				if(null == entry){
					entry = new Elementry();
					entries[n] = entry;
				}
				entry.loadData(list[n]);
			}
		}
	}
}
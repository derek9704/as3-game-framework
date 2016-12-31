package com.brickmice.view.boyhero
{
	import com.brickmice.view.component.BmButton;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class StorageArmListItem extends Sprite
	{
		private var _mc:ResBoyHeroStorageArmList;
		private var _info:Object;
		private var _loadFunc:Function;
		
		public var countNow:int;
		public var id:int;
		public var weight:int;
		
		public function StorageArmListItem(info : Object, loadFunc:Function)
		{
			_info = info;
			_loadFunc = loadFunc;
			id = info.id;
			weight = info.weight;
			countNow = info.num;
			
			_mc = new ResBoyHeroStorageArmList;
			addChild(_mc);
			
			_mc._name.text = info.name;
			_mc._atk.text = info.attack;
			_mc._def.text = info.defense;
			_mc._weight.text = info.weight;
			_mc._count.text = info.num;
			
			new BmButton(_mc._loadBtn, function() : void
			{
				info.num = countNow;
				loadFunc(info);
			});
		}
		
		public function changeCount(num:int):void
		{
			countNow = num;
			_mc._count.text = num.toString();
		}
	}
}

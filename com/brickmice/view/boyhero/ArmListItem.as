package com.brickmice.view.boyhero
{
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class ArmListItem extends Sprite
	{
		private var _mc:ResBoyHeroArmList;
		private var _info:Object;
		private var _changeNumHandler:Function;
		
		public var countNow:int;
		public var id:int;
		public var weight:int;
		public var maxCount:int;
		
		public function ArmListItem(info : Object, storageCount : int, delFunc:Function, changeNumFunc:Function, getLeftVolumn:Function)
		{
			_info = info;
			_changeNumHandler = changeNumFunc;
			
			_mc = new ResBoyHeroArmList;
			addChild(_mc);
			
			id = info.id;
			weight = info.weight;
			_mc._name.text = info.name;
			_mc._atk.text = info.attack;
			_mc._def.text = info.defense;
			_mc._weight.text = info.weight;
			
			var count:int = info.num;
			maxCount = storageCount + count;
			
			countNow = count;
			_mc._count.text = count.toString();
			var input:BmInputBox = new BmInputBox(_mc._count, count.toString(), -1, true, maxCount, 0);
			input.onNumChange = inputCount;
			
			_mc._atk.text = (_info.attack * count).toString();
			_mc._weight.text = (_info.weight * count).toString();
			_mc._def.text = (_info.defense * count).toString();
			
			new BmButton(_mc._delBtn, function() : void
			{
				if(countNow <= 0) return;
				setCount(countNow - 1);
			});
			
			new BmButton(_mc._addBtn, function() : void
			{
				if(countNow >= maxCount) return;
				var leftVolumn:int = getLeftVolumn();
				var maxNum:int = Math.floor(leftVolumn / weight);
				if(!maxNum) return;
				setCount(countNow + 1);
			});
			
			new BmButton(_mc._minBtn, function() : void
			{
				setCount(0);
			});
			
			new BmButton(_mc._maxBtn, function() : void
			{
				var leftVolumn:int = getLeftVolumn();
				var maxNum:int = Math.floor(leftVolumn / weight);
				if(maxNum > maxCount - countNow) maxNum = maxCount - countNow;
				setCount(maxNum + countNow);
			});
			
			new BmButton(_mc._removeBtn, function() : void
			{
				setCount(0);
				delFunc(id);
			});
		}
		
		private function inputCount(count:int):void
		{
			countNow = count
			
			_mc._atk.text = (_info.attack * countNow).toString();
			_mc._weight.text = (_info.weight * countNow).toString();
			_mc._def.text = (_info.defense * countNow).toString();
			
			_changeNumHandler(id, maxCount - countNow);
		}
		
		private function setCount(count:int):void
		{
			countNow = count;
			_mc._count.text = count.toString();
			
			_mc._atk.text = (_info.attack * count).toString();
			_mc._weight.text = (_info.weight * count).toString();
			_mc._def.text = (_info.defense * count).toString();
			
			_changeNumHandler(id, maxCount - countNow);
		}
	}
}

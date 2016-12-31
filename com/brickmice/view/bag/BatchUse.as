package com.brickmice.view.bag
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class BatchUse extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BatchUse";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _maxBtn:MovieClip;
		private var _storageCount:TextField;
		private var _count:TextField;
		private var _minBtn:MovieClip;
		private var _itemName:TextField;
		private var _max:int;
		
		public function BatchUse(itemPos : int, callback:Function)
		{
			_mc = new ResBagUseWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			_itemName = _mc._itemName;
			_maxBtn = _mc._maxBtn;
			_storageCount = _mc._storageCount;
			_count = _mc._count;
			_minBtn = _mc._minBtn;
			
			var data:Object = Data.data.bag['plus'][itemPos];
			_storageCount.text = data.num;
			_itemName.text = data.name;
			_max = data.num;
			
			var input:BmInputBox = new BmInputBox(_count, data.num, -1, true, data.num, 1);
			Main.self.stage.focus = _count;
			_count.setSelection(data.num.toString().length, data.num.toString().length);	
			
			new BmButton(_yesBtn, function() : void
			{
				ConfirmMessage.callBack = callback;
				ModelManager.bagModel.useBagItem(itemPos, 'plus', int(_count.text), function():void{
					callback();
					closeWindow();
				});
			});
			
			new BmButton(_minBtn, function() : void
			{
				_count.text = '1';
			});
			
			new BmButton(_maxBtn, function() : void
			{
				_count.text = _max.toString();
			});
		}
	}
}
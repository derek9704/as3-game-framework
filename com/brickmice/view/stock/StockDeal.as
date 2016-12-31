package com.brickmice.view.stock
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.prompt.TextMessage;
	
	import flash.display.MovieClip;

	public class StockDeal extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "StockDeal";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		
		
		public function StockDeal(type : int, itemId:int, priceNow:int)
		{
			_mc = new ResStockDealWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			_mc._sell.visible = type == 1;
			_mc._buy.visible = type == 0;
			_mc._price.text = priceNow.toString();
			_mc._count.text = "0";
			_mc._totalPrice.text = "0";
			
			var storageNum:int = Data.data.storage.material.items[itemId].num;
			_mc._num.text = storageNum;
			_mc._volume.text = Data.data.storage.material.volume;
			
			var input1:BmInputBox = new BmInputBox(_mc._price, priceNow.toString(), 5, true, -1, 0);
			input1.onNumChange = setCount;
			
			var input2:BmInputBox = new BmInputBox(_mc._count, '1000', 9, true, -1, 0);
			input2.onNumChange = setCount;
			
			Main.self.stage.focus = _mc._count;
			_mc._count.setSelection(_mc._count.toString().length, _mc._count.toString().length);	
			
			setCount(0);
			
			new BmButton(_yesBtn, function() : void
			{
				if(_mc._price.text == 0){
					TextMessage.showEffect("价格不能为0", 2);
					return;
				}
				if(_mc._count.text == 0){
					TextMessage.showEffect("数量不能为0", 2);
					return;
				}			
				if(type == 1){
					ModelManager.stockModel.sellStock(itemId, int(_mc._price.text), int(_mc._count.text), function():void{
						closeWindow();
					});		
				}
				else{
					ModelManager.stockModel.buyStock(itemId, int(_mc._price.text), int(_mc._count.text), function():void{
						closeWindow();
					});				
				}
			});
		}
		
		private function setCount(count:int):void
		{
			_mc._totalPrice.text = int(_mc._price.text) * int(_mc._count.text);
		}
	}
}
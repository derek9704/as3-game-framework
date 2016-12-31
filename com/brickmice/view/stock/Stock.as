package com.brickmice.view.stock
{
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;

	public class Stock extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Stock";
		
		private var _mc:MovieClip;
		
		private var _ironStone:MovieClip;
		private var _moonStone:MovieClip;
		private var _nightStone:MovieClip;
		private var _lifeStone:MovieClip;
		
		private var _ironStone2:MovieClip;
		private var _moonStone2:MovieClip;
		private var _nightStone2:MovieClip;
		private var _lifeStone2:MovieClip;
		
		public function Stock(data : Object)
		{
			_mc = new ResStockMarketWindow;
			super(NAME, _mc);
			
			_ironStone = _mc._ironStone;
			_moonStone = _mc._moonStone;
			_nightStone = _mc._nightStone;
			_lifeStone = _mc._lifeStone;
			
			setDealItem(_ironStone, Consts.ID_IRON, 1);
			setDealItem(_moonStone, Consts.ID_MOONSTONE, 1);
			setDealItem(_nightStone, Consts.ID_NIGHTSTONE, 1);
			setDealItem(_lifeStone, Consts.ID_LIFESTONE, 1);
			
			_ironStone2 = _mc._ironStone2;
			_moonStone2 = _mc._moonStone2;
			_nightStone2 = _mc._nightStone2;
			_lifeStone2 = _mc._lifeStone2;
			
			setDealItem(_ironStone2, Consts.ID_IRON, 0);
			setDealItem(_moonStone2, Consts.ID_MOONSTONE, 0);
			setDealItem(_nightStone2, Consts.ID_NIGHTSTONE, 0);
			setDealItem(_lifeStone2, Consts.ID_LIFESTONE, 0);
		}
		
		private function setDealItem(dealItem:MovieClip, itemId:int, type:int):void
		{
			var dealData:Object;
			if(type == 1){
				dealData = Data.data.stock.sell[itemId];
				new BmButton(dealItem._sell, function():void{
					if (ViewManager.hasView(StockDeal.NAME)) return;
					var sellWin:BmWindow = new StockDeal(1, itemId, dealData.price);
					addChildCenter(sellWin);		
				});	
			}else{
				dealData = Data.data.stock.buy[itemId];
				new BmButton(dealItem._buy, function():void{
					if (ViewManager.hasView(StockDeal.NAME)) return;
					var sellWin:BmWindow = new StockDeal(0, itemId, dealData.price);
					addChildCenter(sellWin);		
				});	
			}
			dealItem._price.text = dealData.price;
			dealItem._rise.visible = dealData.trend == 1;
			dealItem._fall.visible = dealData.trend != 1;
		}
	
	}
}
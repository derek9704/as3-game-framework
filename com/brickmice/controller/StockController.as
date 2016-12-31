package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.stock.Stock;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class StockController
	{
		
		public function showStock():void
		{
			if (!ViewManager.hasView(Stock.NAME))
			{
				ModelManager.stockModel.getStockData(function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["stockMarket"]], function():void{
						var data:WindowData = new WindowData(Stock);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(Stock.NAME) as Stock).closeWindow();
			}
		}
		
	}
}

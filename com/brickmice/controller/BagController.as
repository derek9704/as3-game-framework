package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.bag.Bag;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	/**
	 * 口袋相关逻辑
	 * 
	 * @author derek
	 */
	public class BagController
	{
		
		public function showBag():void
		{
			if (!ViewManager.hasView(Bag.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["bag"]], function():void{
					var data:WindowData = new WindowData(Bag, {type:Bag.PLUS});
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Bag.NAME) as Bag).closeWindow();
			}
		}
		
	}
}

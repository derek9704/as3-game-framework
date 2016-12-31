package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.factory.Factory;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class FactoryController
	{
		public function showFactory(type:String):void
		{
			ModelManager.factoryModel.getFactoryData(type, function():void
			{	
				if (!ViewManager.hasView(Factory.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["factory"]], function():void{
						var data:WindowData = new WindowData(Factory, {"type" : type});
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(Factory.NAME) as Factory).setData(type);
				}
			});
		}
	}
}

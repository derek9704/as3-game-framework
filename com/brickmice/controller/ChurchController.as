package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.church.Church;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class ChurchController
	{
		public function showChurch():void
		{
			ModelManager.churchModel.getChurchData(function():void
			{	
				if (!ViewManager.hasView(Church.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["church"]], function():void{
						var data:WindowData = new WindowData(Church);
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(Church.NAME) as Church).setData();
				}
			});
		}
	}
}

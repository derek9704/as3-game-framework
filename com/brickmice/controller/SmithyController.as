package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.smithy.Smithy;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class SmithyController
	{
		public function showSmithy():void
		{
			if (!ViewManager.hasView(Smithy.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["smithy"]], function():void{
					var data:WindowData = new WindowData(Smithy);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Smithy.NAME) as Smithy).setData();
			}
		}
	}
}

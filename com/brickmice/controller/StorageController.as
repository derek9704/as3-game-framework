package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.storage.Storage;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class StorageController
	{
		public function showStorage(type:String):void
		{
			if (!ViewManager.hasView(Storage.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["storage"]], function():void{
					var data:WindowData = new WindowData(Storage, {"type" : type});
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Storage.NAME) as Storage).setData(type);
			}
		}
	}
}

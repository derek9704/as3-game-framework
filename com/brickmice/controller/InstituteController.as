package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.institute.Institute;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class InstituteController
	{
		public function showInstitute(type:String = "research"):void
		{
			ModelManager.instituteModel.getInstituteData(function():void
			{	
				if (!ViewManager.hasView(Institute.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["institute"]], function():void{
						var data:WindowData = new WindowData(Institute, {"type" : type});
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(Institute.NAME) as Institute).setData();
				}
			});
		}
	}
}

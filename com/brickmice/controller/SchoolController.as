package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.school.School;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class SchoolController
	{
		public function showSchool():void
		{
			ModelManager.schoolModel.getSchoolData(function():void
			{	
				if (!ViewManager.hasView(School.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["school"]], function():void{
						var data:WindowData = new WindowData(School);
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(School.NAME) as School).setData();
				}
			});
		}
	}
}

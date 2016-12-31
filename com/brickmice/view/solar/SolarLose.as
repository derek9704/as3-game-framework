package com.brickmice.view.solar
{
	import com.brickmice.view.battle.Battle;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;

	public class SolarLose extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarLose";
		
		private var _mc:MovieClip;
		
		public function SolarLose(pid:int, pName:String, data:Object, challengeData:Object = null)
		{
			_mc = new ResSolarLoseWindow;
			super(NAME, _mc);
			
			_mc._exp.text = data.dropExp ? data.dropExp : '0';
			
			new BmButton(_mc._cancelBtn, function():void{
				(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				closeWindow();
				(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).closeWindow();
			});
			new BmButton(_mc._repeatBtn, function():void{
				(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).setData(pid, pName, challengeData);
				(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				closeWindow();
			});
		}

	}
}
package com.brickmice.view.boss
{
	import com.brickmice.view.battle.Battle;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;

	public class BossLose extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BossLose";
		
		private var _mc:MovieClip;
		
		public function BossLose(data:Object)
		{
			_mc = new ResBossLoseWindow;
			super(NAME, _mc);
			
			_mc._exp.text = data.dropExp;

			new BmButton(_mc._btn, function():void{
				(ViewManager.retrieveView(Boss.NAME) as Boss).setData();
				if(ViewManager.hasView(Battle.NAME)){
					(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				}
				closeWindow();
			});
		}

	}
}
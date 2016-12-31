package com.brickmice.view.arena
{
	import com.brickmice.view.battle.Battle;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;

	public class ArenaWin extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ArenaWin";
		
		private var _mc:MovieClip;
		
		public function ArenaWin(data:Object)
		{
			_mc = new ResArenaWinWindow;
			super(NAME, _mc);
		
			_mc._honor.text = data.dropHonor;
			_mc._exp.text = data.dropExp;

			new BmButton(_mc._btn, function():void{
				(ViewManager.retrieveView(Arena.NAME) as Arena).setData();
				if(ViewManager.hasView(Battle.NAME)){
					(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				}
				closeWindow();
			});
		}

	}
}
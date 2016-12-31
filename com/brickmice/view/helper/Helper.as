package com.brickmice.view.helper
{
	import com.brickmice.view.component.BmWindow;
	
	import flash.display.MovieClip;
	import flash.text.TextField;


	public class Helper extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Helper";
		
		private var _mc:MovieClip;
		
		
		public function Helper(data : Object)
		{
			_mc = new ResHelperWindow;
			super(NAME, _mc);
			
			setData();
		}
		
		public function setData() : void
		{
			
		}
	}
}
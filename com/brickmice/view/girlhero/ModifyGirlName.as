package com.brickmice.view.girlhero
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ModifyGirlName extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ModifyGirlName";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _txt:TextField;
		
		
		public function ModifyGirlName(data : Object, callback:Function)
		{
			_mc = new ResGirlHeroModifyNameWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			_txt = _mc._txt;
			
			var name:String = (data.name as String).substr(-1, 1);
			
			var input:BmInputBox = new BmInputBox(_txt, name, 1);
			Main.self.stage.focus = _txt;
			_txt.setSelection(0, 1);	
			
			new BmButton(_yesBtn, function() : void
			{
				ModelManager.girlHeroModel.changeGirlHeroName(data.id, _txt.text, function():void{
					callback();
					closeWindow();
				});
			});
		}
	}
}
package com.brickmice.view.activity
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Guaji extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Guaji";
		
		private var _mc:MovieClip;
		private var _noticeInfo:McPanel;
		private var _headImg:McImage;
		private var _coins:Number = 0;
		private var _golden:Number = 0;
		private var _text:String = '';

		public function Guaji(data : Object)
		{
			_mc = new ResChuchaiWindow;
			super(NAME, _mc);

			_headImg = new McImage(Data.data.user.headImg + "b");
			addChildEx(_headImg, 44, 24);

			_noticeInfo = new McPanel('', 441, 278);
			addChildEx(_noticeInfo, 49, 130);

			_mc._coins.text = '0';
			_mc._golden.text = '0';

			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0x000000;
			tf.leading = 2;
			tf.font = 'SimSun';
			
			var txt:TextField = new TextField;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.width = 413;
			
			_mc._bar.addFrameScript((_mc._bar as MovieClip).totalFrames - 1, function():void{
				ModelManager.activityModel.finishGuaji(function():void{
					var data:Object = Data.data.guaji;
					if(data){
						_coins += int(data.coins);
						_mc._coins.text = _coins.toString();
						_golden += int(data.golden);
						_mc._golden.text = _golden.toString();
						_text = data.msg + '<br><br>' + _text;
						if(_text.length > 5000){
							var pos : int = _text.indexOf('<br><br>',4000);
							_text = _text.substr(0, pos);
						}
						txt.htmlText = _text;
						_noticeInfo.panel.removeAllChildren();
						_noticeInfo.addItem(txt);
						Data.data.guaji = null;
					}
				});
			});
			
			onClosed = function():void{
				_mc._bar.gotoAndStop(1);
			};
		}
	}
}
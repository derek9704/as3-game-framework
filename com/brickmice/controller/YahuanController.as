package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.view.component.prompt.YahuanMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.KeyValue;

	/**
	 * 
	 * @author derek
	 */
	public class YahuanController
	{
		private var _talkArr : Array = [];
		private var _textEffectArr : Vector.<KeyValue> = new Vector.<KeyValue>();
		private var _stopYahuan : Boolean = false;
		
		public function showYahuan(msg:String, from:int = 1):void
		{
			_talkArr.push(msg);

			if (!ViewManager.hasView(YahuanMessage.NAME) && !_stopYahuan)
			{
				Main.self.newbieBtn.visible = false;
				var data:WindowData = new WindowData(YahuanMessage, {"from":from, "callBack":yahuanCallBack}, true, 0, -20, CCanvas.rb, false);
				ControllerManager.windowController.showWindow(data);
			}
		}
		
		//暂停播放
		public function stopYahuan():void
		{
			_stopYahuan = true;
		}
		
		//开始播放
		public function continueYahuan():void
		{
			_stopYahuan = false;
			if (!ViewManager.hasView(YahuanMessage.NAME) && _talkArr.length)
			{
				Main.self.newbieBtn.visible = false;
				var data:WindowData = new WindowData(YahuanMessage, {"from":1, "callBack":yahuanCallBack}, true, 0, -20, CCanvas.rb, false);
				ControllerManager.windowController.showWindow(data);
			}
		}

		/**
		 * 获取数组中第一个元素并且从数组中删除
		 */
		private function getOneTalk() : String
		{
			var text : String = _talkArr.shift();
			
			return text;
		}

		/**
		 * 丫鬟面板回调的操作函数
		 */
		private function yahuanCallBack() : void
		{
			var window:YahuanMessage = ViewManager.retrieveView(YahuanMessage.NAME) as YahuanMessage;
			// 如果计数器大于
			if (_talkArr.length)
			{
				var textTalk : String = getOneTalk();

				if (textTalk == "")
				{
					yahuanCallBack();
				}
				else
				{
					window.beginMove(textTalk);
				}
			}
			else
			{
				window.closeWindow();
				Main.self.newbieBtn.visible = true;
			}
		}
	}
}
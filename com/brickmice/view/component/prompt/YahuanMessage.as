package com.brickmice.view.component.prompt
{
	import com.brickmice.Main;
	import com.brickmice.view.component.McLabelOneByOneCom;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.framework.ui.sprites.CWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 
	 * @author derek
	 */
	public class YahuanMessage extends CWindow
	{
		public static const NAME : String = "YahuanMessage";
		private var _callBack : Function;
		private var _textOnebyOneCom : McLabelOneByOneCom;
		private var _bg : ResMonroe;
		
		/**
		 * 丫鬟对话框
		 */
		public function YahuanMessage(data : Object)
		{
			_callBack = data.callBack;
			
			_bg = new ResMonroe();
			super(NAME, _bg.width, _bg.height, null, null, -1, -1);
			_bg._message.gotoAndStop(data.from);
			
			addChildEx(_bg);
			
			var windowLayer:WindowLayer = Main.self.windowLayer;
			windowLayer.addMaskClick(clickFunc);
			
			this.onClosed = function():void{
				windowLayer.removeMaskClick(clickFunc);
			};
			
			// 逐字显示组件
			_textOnebyOneCom = new McLabelOneByOneCom(_bg._message._txt, function() : void{}, 40);
			
			addEventListener(MouseEvent.CLICK, clickFunc);
			
			// 当舞台被加载完成后回调
			this.addEventListener(Event.ADDED_TO_STAGE, function(evt : Event) : void
			{
				_callBack();
			});
		}
		
		private function clickFunc(e:Event):void
		{
			if(_textOnebyOneCom.playing){
				_textOnebyOneCom.showAll();
				return;
			}
			_callBack();
		}

		/**
		 * 开始缓动
		 */
		public function beginMove(text : String) : void
		{
			parent.setChildIndex(this, parent.numChildren - 1);
			_bg._message._txt.htmlText = "";
			_textOnebyOneCom.play(text);
		}
	}
}

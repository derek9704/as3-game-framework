package com.brickmice.view.component
{
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class BmTextButton
	{
		private var _mc : MovieClip;
		private var _title:String;
		
		/**
		 * 设置某个mc为文本按钮
		 * ps:mc必须包含一个名为 "_txt" 的textfield.以用来显示文字._txt 必须在4帧都有效
		 *    mc的第一帧是普通样式.第二帧是mouse over的样式.第三帧是选择之后的样式.允许有第四帧禁用状态
		 *
		 * @param mc 被设置为按钮的mc
		 * @param title 按钮显示的文本
		 * @param click 按钮被单击的回调函数.格式同普通的click callback
		 */
		public function BmTextButton(mc:MovieClip, title:String, click:Function)
		{
			_mc = mc;
			_title = title;
			
			// 初始化mc
			mc.mouseChildren = false;
			mc.buttonMode = true;
			mc.useHandCursor = true;
			
			mc.gotoAndStop(1);
			mc._txt.text = title;
			
			var mouseClick:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				if(click != null) click(event);
			};
			mc.addEventListener(MouseEvent.CLICK, mouseClick);
			
			var mouseOverHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				mc.gotoAndStop(2);
				mc._txt.text = _title;
			};
			mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			var mouseOutHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				mc.gotoAndStop(1);
				mc._txt.text = _title;
			};
			mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			
			// 按下第三帧
			var mouseDownHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				
				// 当前
				mc.gotoAndStop(3);
				mc._txt.text = _title;
			};
			mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			// 抬起返回第二帧
			var mouseUpHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				// 当前
				mc.gotoAndStop(2);
				mc._txt.text = _title;
			};
			mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);	

		}
	
		public function set title(value:String):void
		{
			_title = value;
			_mc.gotoAndStop(1);
			_mc._txt.text = _title;
		}

		/**
		 * 设置按钮的状态
		 */
		public function set enable(enable:Boolean):void
		{
			_mc.enable = enable;
			
			if (!enable)
			{
				_mc.gotoAndStop(4);
				_mc._txt.text = _title;
			}
		}
	}
}

package com.brickmice.view.component
{
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class BmButton
	{
		private var _mc : MovieClip;
		
		//选中模式下使用
		private var _selected : Boolean = false;
		
		/**
		 * 按钮
		 * 
		 */
		public function BmButton(mc : MovieClip, click : Function = null, selectMode:Boolean = false, stopPropagation:Boolean = false)
		{
			_mc = mc;
			
			mc.buttonMode = true;
			mc.useHandCursor = true;
			mc.mouseChildren = false;
			
			var mouseOverHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				mc.gotoAndStop(2);
			};
			
			mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			var mouseOutHandler:Function = function(event:MouseEvent):void
			{
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				if(_selected)
					mc.gotoAndStop(3);
				else
					mc.gotoAndStop(1);
			};
			
			mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			
			// 进行.是否有第三帧的判断.有的话则绑定down和up的事件
			
			// 尝试跳转到第三帧
			mc.gotoAndStop(3);
			
			// 如果跳到第三帧.则存在第三帧.各种设置
			if (mc.currentFrame == 3)
			{
				// 按下第三帧
				var mouseDownHandler:Function = function(event:MouseEvent):void
				{
					if (mc.hasOwnProperty('enable') && !mc.enable)
					{
						return;
					}
					
					// 当前
					mc.gotoAndStop(3);
					
					if(selectMode) _selected = true;
				};
				mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
				if(!selectMode){
					// 抬起返回第二帧
					var mouseUpHandler:Function = function(event:MouseEvent):void
					{
						if (mc.hasOwnProperty('enable') && !mc.enable)
						{
							return;
						}
						// 当前
						mc.gotoAndStop(2);
					};
					mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);	
				}
			}
			
			var clickHandler:Function = function(event:MouseEvent):void
			{
				if(stopPropagation){
					event.stopImmediatePropagation();
					event.stopPropagation();
				}
				
				if (mc.hasOwnProperty('enable') && !mc.enable)
				{
					return;
				}
				if(click != null) click(event);
			};
			mc.addEventListener(MouseEvent.CLICK, clickHandler);
			
			// 默认帧.
			mc.gotoAndStop(1);
		}
		
		//选中模式用
		public function set selected(select:Boolean):void
		{
			if(_selected == select) return;
			_selected = select;
			_mc.gotoAndStop(select ? 3 : 1);
		}
	
		/**
		 * 设置按钮的状态
		 */
		public function set enable(enable:Boolean):void
		{
			_mc.enable = enable;
			
			FilterUtils.clearColorMask(_mc);
			
			if (!enable)
			{
				FilterUtils.setColorMask(_mc, 0xcccccc);
				_mc.gotoAndStop(1);
			}
		}
		
		/**
		 * 设置按钮是否显示
		 */
		public function set visible(bool:Boolean):void
		{
			_mc.visible = bool;
		}
	}
}

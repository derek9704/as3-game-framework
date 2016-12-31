package com.brickmice.view.component
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * TablePanel上的一个按钮.
	 * 请不要直接使用本类.在TabPanel类中.对本类进行了使用方法上的封装.
	 * 因此请直接使用TabPanel即可(项目中请使用已经被封装掉的TabPanel).
	 * 
	 * @author Derek
	 */	
	public class BmTabButton
	{
		
		private var _id : String;
		/**
		 * 背景
		 */
		private var _bg : MovieClip;
		
		public function BmTabButton(id : String, bgMc : MovieClip, callback : Function)
		{

			// 保存背景
			_bg = bgMc;
			
			// 保存ID
			_id = id;
			
			// 默认2
			status = 2;
			
			// 鼠标移入.如果是普通状态.则改成移入状态
			bgMc.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				if (bgMc.currentFrame == 2)
				{
					status = 3;
				}
			});
			
			// 鼠标移出.如果是移入状态.则改成普通状态
			bgMc.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				if (bgMc.currentFrame == 3)
				{
					status = 2;
				}
			});
			
			// 鼠标点击.
			bgMc.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				// 如果已经选择就返回
				if (bgMc.currentFrame == 1)
				{	
					return;
				}
				
				// 回调被选择的ID
				callback(_id);
				
				// 按钮设置为已选择
				status = 1;
				
			});
			bgMc.buttonMode = true;
		}
		
		/**
		 *  设置按钮状态
		 */
		public function set status(value : int) : void
		{
//			if(_bg._txt) {
//				if(value == 3)
//					_bg._txt.textColor = '0xBFAE86';
//				else
//					_bg._txt.textColor = '0x000000';
//			}
			_bg.gotoAndStop(value);
		}
		
		/**
		 *  设置按钮文本 _txt必须在三帧都有效
		 */
		public function set text(txt : String) : void
		{
			if(_bg._txt)
			{
				_bg._txt.mouseEnabled = false;
				_bg._txt.htmlText = txt;
			}
		}
		
		
		/**
		 *  设置按钮文本滤镜 _txt必须在三帧都有效
		 */
		public function set filter(filters:Array) : void
		{
			if(_bg._txt)
			{
				_bg._txt.filters = filters;
			}
		}
		
		
		/**
		 * id
		 */
		public function get id() : String
		{
			return _id;
		}
		
		public function set visible(flag:Boolean) : void
		{
			_bg.visible = flag;
		}
		
		/**
		 * id
		 */
		public function set id(id : String) : void
		{
			_id = id;
		}		
	}
}
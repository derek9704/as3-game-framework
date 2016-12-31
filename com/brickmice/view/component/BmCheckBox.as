package com.brickmice.view.component
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class BmCheckBox
	{
		private var _mc : MovieClip;
		
		/**
		 * 多选框
		 * 
		 * @param callback 单击的回调函数
		 * @param selected 默认是否选中
		 */
		public function BmCheckBox(mc:MovieClip, callback : Function = null, selected : Boolean = false)
		{

			// 禁用子对象的鼠标事件
			mc.mouseChildren = false;
			mc.buttonMode = true;

			// 构造并初始化值
			_mc = mc;
			_mc.gotoAndStop(selected ? 2 : 1);
			
			// 设定单击事件
			_mc.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				// 是否选中
				select = !select;
				
				if (callback != null)
					callback(select);
			});
		}
		
		/**
		 * 选中状态
		 */
		public function get select() : Boolean
		{
			return _mc.currentFrame == 2;
		}
		
		/**
		 * 选中状态
		 */
		public function set select(value : Boolean) : void
		{
			_mc.gotoAndStop(value ? 2 : 1);
		}
	}
}

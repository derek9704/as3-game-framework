package com.framework.ui.basic.sprite
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * 拖拽参数
	 */
	public class DragParameters
	{
		public var draggable:Boolean;
		public var onMove:Function;
		public var onOver:Function;
		public var onStart:Function;
		public var dragId:int;
		public var target:DisplayObject;
		public var xNoMove:Boolean;
		public var yNoMove:Boolean;

		public function set rect(val:Rectangle):void
		{
			_rect = val;
		}

		public function get rect():Rectangle
		{
			return _rect;
		}

		private var _rect:Rectangle;
		public var parent:*;
		public var x:int;
		public var y:int;
		public var index:int;
		public var mouseChildren:Boolean;
		public var mouseEnable:Boolean;

		/**
		 * 拖拽参数
		 *
		 */
		public function DragParameters(onMove:Function, onOver:Function, onStart:Function = null)
		{
			this.draggable = true;
			this.onMove = onMove;
			this.onOver = onOver;
			this.onStart = onStart;
		}
	}
}

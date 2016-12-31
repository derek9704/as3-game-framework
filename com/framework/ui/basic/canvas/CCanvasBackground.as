package com.framework.ui.basic.canvas
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * ccanvas的背景
	 * 
	 * @author derek
	 */
	public class CCanvasBackground extends Object
	{
		/**
		 * 创建CanvasBackground类的实例。
		 * @param target 目标对象
		 */
		public function CCanvasBackground(target : CCanvas)
		{
			_target = target;
			_bg = new Sprite();
			_target.addChildAt(_bg, 0);
		}

		/**
		 * 重绘背景。
		 * 
		 * @return target 目标Canvas
		 */
		public function redraw() : CCanvas
		{
			var g : Graphics = _bg.graphics;

			g.clear();

			if (_backgroundColor != null)
			{
				g.beginFill(uint(_backgroundColor), _backgroundAlpha);
				g.drawRect(0, 0, _target.cWidth, _target.cHeight);
				g.endFill();
			}

			if ( _borderWidth > 0)
			{
				g.lineStyle(1, _rightBorderColor);
				g.moveTo(_target.cWidth, 0);
				g.lineTo(_target.cWidth, _target.cHeight);
				g.lineStyle(1, _topBorderColor);
				g.moveTo(0, 0);
				g.lineTo(_target.cWidth, 0);
				g.lineStyle(1, _bottomBorderColor);
				g.moveTo(0, _target.cHeight);
				g.lineTo(_target.cWidth, _target.cHeight);
				g.lineStyle(1, _leftBorderColor);
				g.moveTo(0, 0);
				g.lineTo(0, _target.cHeight);
			}

			if (_background != null)
			{
				_bg.addChild(_background);
				_background.width = _target.cWidth;
				_background.height = _target.cHeight;
			}

			return _target;
		}

		/**
		 * 清除当前背景。
		 * 
		 * @return target 目标Canvas
		 */
		public function clear() : CCanvas
		{
			_backgroundColor = null;

			redraw();

			return _target;
		}

		/**
		 * 设置背景样式。
		 * 
		 * @param	backgroundColor 背景色
		 * @param	backgroundAlpha 背景Alpha值
		 * @param	borderWidth		边框粗细
		 * @param	borderColor		边框颜色
		 * @param	radius			圆角半径
		 * @return
		 */
		public function setStyle(backgroundColor : uint, backgroundAlpha : Number = 1.0, borderWidth : int = 0, borderColor : uint = 0) : CCanvas
		{
			return setStyleEx(backgroundColor, backgroundAlpha, borderWidth, borderColor);
		}

		/**
		 * 设置背景样式（扩展）。
		 * @param	backgroundColor 背景色
		 * @param	backgroundAlpha 背景Alpha值
		 * @param	borderWidth		边框粗细
		 * @param	borderColor		边框颜色
		 * @param	topLeftRaidus	左上角圆角半径
		 * @param	topRightRaidus	右上角圆角半径
		 * @param	bottomLeftRadius	左下角圆角半径
		 * @param	bottomRightRaidus	右下角圆角半径
		 * @return
		 */
		public function setStyleEx(backgroundColor : uint, backgroundAlpha : Number, borderWidth : int = 0, topBorderColor : int = 0, bottomBorderColor : int = -1, leftBorderColor : int = -1, rightBorderColor : int = -1) : CCanvas
		{
			_backgroundColor = backgroundColor;
			_backgroundAlpha = backgroundAlpha;

			_topBorderColor = topBorderColor;
			_bottomBorderColor = bottomBorderColor == -1 ? topBorderColor : bottomBorderColor;
			_leftBorderColor = leftBorderColor == -1 ? topBorderColor : leftBorderColor;
			_rightBorderColor = rightBorderColor == -1 ? topBorderColor : rightBorderColor;

			_borderWidth = borderWidth;

			return redraw();
		}

		/**
		 * 设置背景
		 */
		public function setBg(background : DisplayObject) : void
		{
			// 宽高值
			var w : Object = null;
			var h : Object = null;

			// 已经指定了canvas的宽高则使用canvas的宽高作为背景
			if (_target.cWidth is Number && _target.cHeight is Number && _target.cWidth > 0 && _target.cHeight > 0)
			{
				w = _target.cWidth;
				h = _target.cHeight;
			}
			_background = background;

			if (_target.cWidth < 1 || _target.cHeight < 1)
			{
				_target.cWidth = _background.width;
				_target.cHeight = _background.height;
			}

			redraw();
		}

		private var _target : CCanvas;
		private var _bg : Sprite;
		private var _backgroundColor : Object = null;
		// 背景颜色
		private var _backgroundAlpha : Number = 1.0;
		// 透明度
		private var _borderWidth : int;
		// 边框宽度
		// 四个边的颜色
		private var _topBorderColor : uint;
		private var _bottomBorderColor : uint;
		private var _leftBorderColor : uint;
		private var _rightBorderColor : uint;
		// 背景图片
		private var _background : DisplayObject;

		public function get background() : DisplayObject
		{
			return _background;
		}

		/**
		 * 背景颜色
		 */
		public function get backgroundColor() : Object
		{
			return _backgroundColor;
		}

		/**
		 * 背景颜色
		 */
		public function set backgroundColor(value : Object) : void
		{
			_backgroundColor = value;
			redraw();
		}

		/**
		 * 背景透明度
		 */
		public function get backgroundAlpha() : Number
		{
			return _backgroundAlpha;
		}

		/**
		 * 背景透明度
		 */
		public function set backgroundAlpha(value : Number) : void
		{
			_backgroundAlpha = value;
			redraw();
		}

		/**
		 * 边线宽度
		 */
		public function get borderWidth() : int
		{
			return _borderWidth;
		}

		/**
		 * 边线宽度
		 */
		public function set borderWidth(value : int) : void
		{
			_borderWidth = value;
			redraw();
		}
	}
}
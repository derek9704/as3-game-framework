package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;

	import flash.display.DisplayObject;

	/**
	 * 列表面板.可以添加若干显示项来显示
	 * 可以根据需求显示滚动条
	 * 
	 * @author derek
	 */
	public class ListPanel extends ScrollPanel
	{
		private var _horizontal : Boolean;
		private var _xSpace : int;
		private var _ySpace : int;
		private var _xItemCount : int;
		private var _yItemCount : int;
		private var _imgWidth : int;
		private var _imgHeight : int;
		private var _imageBg : Class;

		/**
		 * 构造函数
		 * 
		 * @param name 面板名字
		 * @param xItemCount x显示的数量
		 * @param yItemCount y显示的数量
		 * @param horizontal 水平方向扩展 or 垂直方向扩展
		 * @param xSpace x方向间隔
		 * @param ySpace y方向间隔
		 * @param imgBg 图片背景
		 * @param scrollBar 纵向滚动条
		 * @param hScrollBar 横向滚动条
		 */
		public function ListPanel(name : String, xItemCount : int, yItemCount : int, horizontal : Boolean, xSpace : int, ySpace : int, imgWidth : int, imgHeight : int, scrollBar : VerticalScrollBar, hScrollBar : HScrollBar, imageBg : Class = null)
		{
			var width : int = xItemCount * (imgWidth + xSpace) - xSpace;
			var height : int = yItemCount * (imgHeight + ySpace) - ySpace;

			if (horizontal)
			{
				height += hScrollBar.cHeight;
			}
			else
			{
				width += scrollBar.cWidth;
			}

			super(name, width, height, scrollBar, hScrollBar);

			if (horizontal)
			{
				vScrollBarEnable = false;
			}
			else
			{
				hScrollBarEnable = false;
			}

			_xItemCount = xItemCount;
			_yItemCount = yItemCount;

			_xSpace = xSpace;
			_ySpace = ySpace;
			_horizontal = horizontal;

			_imgWidth = imgWidth;
			_imgHeight = imgHeight;

			_imageBg = imageBg;
		}

		/**
		 * 清空panel
		 */
		public function clear() : void
		{
			setItems(new Vector.<DisplayObject>());
		}

		/**
		 * 设置图片
		 * 
		 * @param images 图片列表
		 */
		public function setItems(images : Vector.<DisplayObject>) : void
		{
			if (images == null)
				return;

			var len : int = images.length;
			var pWidth : int = cWidth;
			var pHeight : int = cHeight;
			var xCount : int = _xItemCount;
			var yCount : int = _yItemCount;

			// 需要添加滚动条?
			if (len > xCount * yCount)
			{
				// 根据对其方式.修正
				if (_horizontal)
				{
					xCount = Math.ceil(int(len / _yItemCount));

					pWidth = xCount * (_imgWidth + _xSpace) - _xSpace;
				}
				else
				{
					yCount = Math.ceil(int(len / _xItemCount));

					pHeight = yCount * (_imgHeight + _ySpace) - _ySpace;
				}
			}

			// 重设滚动面板
			panel.removeAllChildren();
			panel.cWidth = pWidth;
			panel.cHeight = pHeight;
			resize();

			// 重用了len.
			var count : int = xCount * yCount;

			// 遍历所有的..背景
			for (var i : int = 0; i < count; i++)
			{
				var imgX : int = (int(i % xCount)) * (_imgWidth + _xSpace);
				var imgY : int = (int(i / xCount)) * (_imgHeight + _ySpace);

				var canvas : CCanvas = new CCanvas(_imgWidth, _imgHeight);

				// 如果有图片.则加入图片
				if (i < len && images[i] != null)
				{
					canvas.addChild(images[i]);
				}
				else if (_imageBg != null)
				{
					// 如果有背景.则显示背景
					canvas.addChild(new _imageBg());
				}
//				trace(canvas.height);
				panel.addChildEx(canvas, imgX, imgY);
			}
		}
	}
}

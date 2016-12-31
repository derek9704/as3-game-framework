package com.framework.ui.sprites
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 提供了按钮的基本功能.封装了按钮的各种操作
	 *
	 * @deprecated 不应该直接继承本类.而应该根据按钮类型来继承 CImageButton 或 CTextButton
	 *
	 * @author derek
	 */
	public class CButton extends CSprite
	{
		private var _mc:MovieClip;

		/**
		 * 构造函数
		 *
		 * @param mc mc资源(第一帧普通状态.第二帧OVER状态(此帧可以没有).第三帧按下状态(此帧可以没有)).
		 * @param btnText 按钮上的文本
		 * @param frameIndex 默认帧index = 1
		 * @param muiltFrame 是否是多帧按钮.
		 * @param normalColor 普通状态文本颜色
		 * @param overColor 鼠标移入文本颜色
		 * @param embed 按钮文本是否嵌入字体
		 * @param textFormat 按钮文本格式
		 * @param filters 按钮文本的特效
		 */
		public function CButton(mc:MovieClip, btnText:String = '', frameIndex:int = 1, muiltFrame:Boolean = false, normalColor:int = -1, overColor:int = -1, embed:Boolean = false, textFormat:TextFormat = null, filters:Array = null)
		{
			super('', mc.width, mc.height);
			// 按钮背景

			bg.setBg(mc);
			// 保存mc
			_mc = mc;

			// 按钮模式
			mouseChildren = false;

			// 指定了按钮文本?
			if (btnText != '')
			{
				_btnTitle = new TextField();
				_btnTitle.mouseEnabled = false;
				_btnTitle.autoSize = TextFieldAutoSize.LEFT;
				_btnTitle.defaultTextFormat = textFormat;
				_btnTitle.filters = filters;
				_btnTitle.embedFonts = embed;
				_btnTitle.text = btnText;

				cWidth = _btnTitle.width + _margin * 2;

				// 按钮大小根据文本来调整
				addChildCenter(_btnTitle);
			}
			// 如果是多帧按钮
			if (muiltFrame)
			{
				evts.mouseOver(function(event:MouseEvent):void
				{
					if (_btnTitle != null && overColor > 0)
						_btnTitle.textColor = overColor;
					mc.gotoAndStop(2);
				});
				evts.mouseOut(function(event:MouseEvent):void
				{
					if (_btnTitle != null && normalColor > 0)
						_btnTitle.textColor = overColor;
					mc.gotoAndStop(1);
				});
				// 进行.是否有第三帧的判断.有的话则绑定down和up的事件
				// 尝试跳转到第三帧
				mc.gotoAndStop(3);
				// 如果跳到第三帧.则存在第三帧.各种设置
				if (mc.currentFrame == 3)
				{
					// 按下第三帧
					evts.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void
					{
						// 当前
						mc.gotoAndStop(3);
					});

					// 抬起返回第二帧
					evts.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void
					{
						if (_btnTitle != null && overColor > 0)
							_btnTitle.textColor = overColor;
						// 当前
						mc.gotoAndStop(2);
					});
				}
				// 默认帧.
				mc.gotoAndStop(frameIndex);
			}
			evts.addClick(function(event:MouseEvent):void
			{
				if (_click != null)
					_click(event);
			});
			evts.mouseOver(function(event:MouseEvent):void
			{
				if (_mouseOver != null)
					_mouseOver(event);
			});
			evts.mouseOut(function(event:MouseEvent):void
			{
				if (_mouseOut != null)
					_mouseOut(event);
			});
		}

		/**
		 * 设置按钮文本.非文本按钮无效
		 */
		public function set title(value:String):void
		{
			if (_btnTitle == null)
				return;
			_btnTitle.text = value;
		}

		/**
		 * 获取按钮文本.非文本按钮返回null
		 */
		public function get title():String
		{
			if (_btnTitle == null)
				return null;
			return _btnTitle.text;
		}

		/**
		 * 单击的回调函数
		 */
		public function set click(callback:Function):void
		{
			_click = callback;
		}

		/**
		 * 移入鼠标的回调函数
		 */
		public function set mouseOver(callback:Function):void
		{
			_mouseOver = callback;
		}

		/**
		 * 移出鼠标的回调函数
		 */
		public function set mouseOut(callback:Function):void
		{
			_mouseOut = callback;
		}

		/**
		 * 按钮文本在X方向的内边界
		 */
		public function get margin():int
		{
			return _margin;
		}

		/**
		 * 按钮文本在X方向的内边界
		 * 不建议修改本值
		 */
		public function set margin(margin:int):void
		{
			_margin = margin;
			cWidth = _btnTitle.width + _margin * 2;
			_btnTitle.x = _margin;
		}

		public override function set enable(value:Boolean):void
		{
			_mc.gotoAndStop(1);
			super.enable = value;
		}

		private var _mouseOut:Function;
		private var _click:Function;
		private var _mouseOver:Function;
		private var _margin:int = 6;
		private var _btnTitle:TextField;
	}
}

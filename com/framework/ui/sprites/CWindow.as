package com.framework.ui.sprites
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 窗体类.自带关闭按钮及背景设定的功能
	 *
	 * @author derek
	 */
	public class CWindow extends CSprite
	{
		private var _closeButton:CButton;
		private var _titleXOffset:int;

		/**
		 * 窗体的构造函数
		 *
		 * @param name 窗体名
		 * @param w 窗体宽度
		 * @param h 窗体高度
		 * @param bg 背景图片
		 * @param closeBtn 关闭按钮
		 * @param closeBtnXoffset 关闭按钮X偏移(基于右侧)
		 * @param closeBtnYoffset 关闭按钮Y偏移(基于顶端)
		 * @param headHeight 窗口头部高度.设置了高度之后.窗口才可以拖拽
		 */
		public function CWindow(name:String, w:uint, h:uint, bg:DisplayObject, closeBtn:CButton, closeBtnXoffset:int, closeBtnYoffset:int, headHeight:int = 0)
		{
			super(name, w, h, true);

			// bg可能为空.一些特殊的窗体会不需要背景
			if (bg != null)
			{
				bg.width = w;
				bg.height = h;
				// 加入背景.背景是独立于CHILD管理的.所以.要使用DOC的ADDCHILD
				addChild(bg);
			}
			if (headHeight > 0)
			{
				dragInfo.dragArea = new Rectangle(0, 0, w - closeBtn.cWidth - closeBtnXoffset, headHeight);
				dragInfo.drag = true;
			}

			_closeButton = closeBtn;

			// 关闭按钮也可能没有
			if (closeBtn == null)
				return;

			// 加入关闭按钮.关闭按钮位于窗体的右上10像素位置
			addChildEx(closeBtn, closeBtnXoffset, closeBtnYoffset, CCanvas.rt);

			// 关闭按钮的单击事件
			closeBtn.click = function(event:MouseEvent):void
			{
				closeWindow();
			};
		}

		/**
		 * 设置窗体的标题栏内容
		 *
		 * @param title 标题
		 * @param fontSize 字体大小
		 * @param fontColor 字体颜色
		 * @param font 字体
		 * @param letterSpacing 文字间隔
		 * @param embedFonts 是否嵌入字体
		 * @param glowColor 描边颜色 小于0 则没有描边
		 * @param glowStr 描边强度
		 * @param glowBlur 模糊度
		 * @param yOffset 标题文字Y方向偏移.
		 */
		public function setTitle(title:String, fontSize:int, fontColor:int, font:String, letterSpacing:int, embedFonts:Boolean, glowColor:int, glowStr:Number, glowBlur:Number, yOffset:int, titleXOffset:int = 0):void
		{
			var tf:TextFormat = new TextFormat();
			tf.size = fontSize;
			tf.color = fontColor;
			tf.font = font;
			tf.letterSpacing = letterSpacing;

			_title = new TextField();
			_title.defaultTextFormat = tf;
			_title.embedFonts = embedFonts;
			_title.multiline = false;
			_title.mouseEnabled = false;

			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.text = title;
			if (glowColor >= 0)
				FilterUtils.glow(_title, glowColor, glowStr, glowBlur);
			addChildH(_title, yOffset);

			_titleXOffset = titleXOffset;

			_title.x = (cWidth - titleXOffset - _title.width) / 2;
		}

		/**
		 * 关闭本窗口
		 */
		public function closeWindow():void
		{
			// 如果指定了.关闭相应函数
			if (onClose != null)
			{
				onClose(function(close:Boolean):void
				{
					closeWin(close);
				});
			}
			else
			{
				closeWin(true);
			}
		}

		private function closeWin(close:Boolean):void
		{
			if (!close)
				return;

			// 如果窗体是以model模式打开.这里会被指定为..关闭时候使用.
			if (onCloseModel != null)
				onCloseModel();

			// 如果有回调函数.则执行之
			if (_onClosed != null)
				_onClosed();

			// 移除窗体
			removeSelf();
		}

		/**
		 * 当窗口被关闭的回调函数
		 */
		public function set onClosed(callback:Function):void
		{
			_onClosed = callback;
		}

		private var _onClosed:Function;

		/**
		 * 关闭按钮是否显示
		 */
		public function set closeBtnVisible(value:Boolean):void
		{
			if (_closeButton == null)
				return;

			_closeButton.visible = value;
		}

		/**
		 * 当窗口关闭的回调函数.格式为 onClose(callback:Function):void;
		 * callback为当窗口关闭时调用的回调函数 格式为 callback(value:Boolean):void; value为是否允许关闭窗口.
		 *
		 * @example onClose = function(close:Function) : void {
		 *		ApplicationFacade.getInstance().showDialog('您确认要关闭窗口吗?',close);
		 *	}
		 *
		 *	close(value:Boolean):void;函数执行时.传入value.来指定是否允许关闭对话框
		 */
		public var onClose:Function;
		/**
		 * 当窗口为模式窗口.
		 * 关闭之后的回调函数
		 *
		 * !!本方法为.windowlayer调用.其他人不应该来进行调用.
		 */
		public var onCloseModel:Function;
		private var _title:TextField;

		public function get title():String
		{
			return _title == null ? '' : _title.text;
		}

		public function set title(title:String):void
		{
			if (_title == null)
				throw '窗口标题没有初始化';
			_title.text = title;
			_title.x = (cWidth - _titleXOffset - _title.width) / 2;
		}
	}
}

package com.framework.ui.basic.layer
{
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.CWindow;
	import com.framework.ui.sprites.WindowData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 显示窗口的层
	 *
	 * @author derek
	 */
	public class CWindowLayer extends CLayer
	{
		//记录独立窗口名
		private static var aloneWin : String = null;
		
		public function CWindowLayer(maskAlpha : Number, width : Object = null, height : Object = null, animation : Boolean = false)
		{
			super(width, height, animation);

			// 模式窗口用来屏蔽其他事件的遮罩(mask)
			_mask = new Sprite();
			_mask.visible = false;

			// 初始化遮罩层
			initMask(maskAlpha);
			// 加入遮罩
			addChild(_mask);

			// 当层被修改大小的时候的响应事件
			onResize = function():void
			{
				// 如果遮罩显示中.调整遮罩的大小以覆盖整个层
				if (_mask.visible)
				{
					_mask.width = cWidth;
					_mask.height = cHeight;
				}
			};
		}

		/**
		 * 清空所有窗体
		 */
		public function clear():void
		{
			// 移除所有窗体
			removeAllChildren();

			// 隐藏遮罩(遮罩是不在子对象管理中的)
			_mask.visible = false;
		}

		public function showMask():void
		{
			_mask.width = cWidth;
			_mask.height = cHeight;
			_mask.visible = true;
		}

		public function hideMask():void
		{
			_mask.visible = false;
		}
		
		public function addMaskClick(func:Function):void
		{
			_mask.addEventListener(MouseEvent.CLICK, func);
		}
		
		public function removeMaskClick(func:Function):void
		{
			_mask.removeEventListener(MouseEvent.CLICK, func);
		}

		/**
		 * 显示窗体
		 *
		 * @param item 被显示的窗体
		 * @param model 是否是模式窗口 =false
		 */
		public function addWindow(data:WindowData):void
		{
			// 模式窗体打开的时候.不允许再打开新窗体
			if (_mask.visible)
			{
//				return;
			}
			
			//如果是独立窗体
			if(data.alone)
			{
				var view:CSprite = ViewManager.retrieveView(aloneWin);
				if(view != null){
					(view as CWindow).closeWindow();
				}
				aloneWin = data.window.cName;
			}

			// 居中加入
			if (data.align == 0)
			{
				addChildCenter(data.window);
			}
			else
			{
				addChildEx(data.window, data.xoffset, data.yoffset, data.align);
			}

			// 如果窗体是模式的
			if (data.model)
			{
				// 当模式窗体被关闭的时候.隐藏遮罩
				data.window.onCloseModel = function():void
				{
					_mask.visible = false;
				};

				// 设定遮罩大小
				_mask.width = cWidth;
				_mask.height = cHeight;

				// 获取遮罩的index(在窗体的下面,以遮挡其他层)
				var zIndex:int = getChildIndex(data.window) - 1;

				// 如果index < 0 .则为0
				if (zIndex < 0)
					zIndex = 0;

				// 调整mask位置
				setChildIndex(_mask, zIndex);

				_mask.visible = true;
			}
		}

		/**
		 * 初始化遮罩
		 */
		private function initMask(maskAlpha:Number):void
		{
			// 画出来~
			_mask.graphics.beginFill(0x000000, maskAlpha);
			_mask.graphics.drawRect(0, 0, 100, 100);
			_mask.graphics.endFill();
		}

		/**
		 * 遮罩
		 */
		private var _mask:Sprite;
	}
}

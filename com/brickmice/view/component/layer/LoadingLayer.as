package com.brickmice.view.component.layer
{
	import com.framework.ui.basic.layer.CLayer;

	/**
	 * 显示Loading的层
	 *
	 * @author derek
	 */
	public class LoadingLayer extends CLayer
	{
		private var _loading:ResEffectLoading;
		private var _request:ResEffectRequest;

		public function LoadingLayer(width:Object = null, height:Object = null)
		{
			super(width, height);
			bg.setStyle(0x000000, 0.5);
			visible = false;
			// loading
			_loading = new ResEffectLoading();
			addChildEx(_loading);
			_loading.gotoAndStop(1);

			_request = new ResEffectRequest();
			addChildEx(_request);
			_request.gotoAndStop(1);
		}

		public function showLoading(show:Boolean, requestAbel:Boolean = false):void
		{
			visible = show;
			if (requestAbel)
			{
				_loading.visible = false;
				_request.visible = true;
				if (show)
				{
					_request.x = (cWidth) / 2;
					_request.y = (cHeight) / 2;
					_request.gotoAndPlay(1);
				}
				else
					_request.gotoAndStop(1);

				return;
			}

			_loading.visible = true;
			_request.visible = false;
			if (show)
			{
				_loading.x = (cWidth) / 2;
				_loading.y = (cHeight) / 2;

				_loading.gotoAndPlay(1);
			}
			else
				_loading.gotoAndStop(1);
		}

		public function setLoadingProcess(pre:int):void
		{
			_loading._txt.text = pre + "%";
		}
	}
}

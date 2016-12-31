package com.brickmice.view.research
{
	import com.framework.ui.basic.CScene;
	import com.framework.ui.basic.layer.CLayer;
	
	import flash.events.Event;

	/**
	 * @author derek
	 */
	public class ResearchScene extends CScene
	{
		/**
		 * 场景名字
		 */
		public static const NAME:String = "ResearchScene";
		private var _content:Research;
		private var _uiLayer:CLayer;

		/**
		 * 攻关场景
		 */
		public function ResearchScene()
		{
			// 构造试炼场景
			_content = new Research();

			super(NAME, _content.cWidth, _content.cHeight);

			// 设置场景内容
			setContent(_content);
			
			// 添加到舞台上的响应
			evts.addedToStage(onAddedToStage);
		}

		/**
		 * 添加到舞台的响应函数
		 */
		private function onAddedToStage(event:Event):void
		{
			// 关闭添加到舞台之后的监听
			evts.removeEventListener(onAddedToStage);

			_content.x = (cWidth - _content.cWidth) / 2;
			_content.y = (cHeight - _content.cHeight) / 2;
			
			//layer
			_uiLayer = new CLayer(cWidth < _content.cWidth ? cWidth : _content.cWidth, cHeight < _content.cHeight ? cHeight : _content.cHeight);
			_uiLayer.scaleMode = CLayer.none;
			addChildCenter(_uiLayer);
			_content.setData(_uiLayer);
		}
		
	}
}

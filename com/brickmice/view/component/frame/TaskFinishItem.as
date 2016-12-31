package com.brickmice.view.component.frame
{
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.McImage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;

	/**
	 * @author derek
	 */
	public class TaskFinishItem extends CSprite
	{
		private var _mc:ResTaskFinishItem;

		public function TaskFinishItem(data : Object)
		{
			_mc = new ResTaskFinishItem;
			addChildEx(_mc);
			
			//头像
			var _img : McImage = new McImage(data.img);
			addChildEx(_img, 2, 0);
			
			_mc._count.text = data.num;
			
			// 设置tip
			TipHelper.setTip(_img, Trans.transTips(data));
		}

	}
}

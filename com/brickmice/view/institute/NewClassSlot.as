package com.brickmice.view.institute
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McImage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.DateUtils;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	
	public class NewClassSlot extends CSprite
	{
		private var _mc:MovieClip;
		private var _img : McImage;
		
		public function NewClassSlot(data:Object, ticketName:String)
		{
			super('', 78, 107, false);
			
			_mc = new ResLessonItem;
			addChildEx(_mc);
			
			_mc._itemBox.gotoAndStop(1);
			
			//头像
			_img = new McImage(data.img);
			_img.mouseEnabled = false;
			addChildEx(_img, 2, -2);
			
			TipHelper.setTip(_mc, Trans.transClassTips(data, false, ticketName));
			
			_mc._name.text = data.classname;
			
			_mc._btn.hitArea = _mc;
			var btn:BmButton = new BmButton(_mc._btn, function():void{
				ModelManager.instituteModel.startInstituteResearch(data.subtype, data.id, function():void{
					NewbieController.refreshNewBieBtn(11, 3);
					ControllerManager.researchController.showResearch();
				});
			});
			var date:String = DateUtils.toShortDateString(new Date());
			if(ticketName != '' || data.learned2 == date) btn.enable = false;
			if(data.learned != 1 || data.learned2 == date){
				_mc._pay.visible = false;
			}else{
				_mc._pay._num.text = data.classlevel;
				_mc._name.visible = false;
			}
		}
	}
}
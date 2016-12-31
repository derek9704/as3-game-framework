package com.brickmice.view.bluesun
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	
	public class BlueSunSlot extends CSprite
	{
		private var _mc:MovieClip;
		private var _id:int;
		private var _buyBtn:BmButton;
		private var _img : McImage;
		
		public function BlueSunSlot()
		{
			super('', 84, 223, false);
			
			_mc = new ResBlueSunSlot;
			addChildEx(_mc);
			
			_mc._box.gotoAndStop(1);
			
			_buyBtn = new BmButton(_mc._buyBtn, function():void{
				ModelManager.equipModel.buyEquip(_id);
			});
		}
		
		public function setItem(data:Object):void
		{	
			removeChild(_img);
			if(data.type == "equip"){
				_mc._prop1Text.text = "意志力：";
				_mc._prop1.text = data.defense;
				_mc._coins.text = data.buyprice;
				_id = data.id;
				if(Data.data.user.honorLevel < data.special1){
					_buyBtn.enable = false;
					TipHelper.setTip(_mc._buyBtn, new McTip("玩家荣誉等级到达" + data.special1 + "级开启"));
				}else{
					_buyBtn.enable = true;
					TipHelper.clear(_mc._buyBtn);
				}
			}else{
				
			}
			
			//头像
			_img = new McImage(data.img);
			addChildEx(_img, 5, 15);
			
			// 设置tip
			TipHelper.setTip(_img, Trans.transTips(data));
		}
	}
}
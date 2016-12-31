package com.brickmice.view.brain
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	public class BrainSlot extends CSprite
	{
		public function BrainSlot()
		{
			super('', 94, 197, false);
		}
		
		public function setHero(data:Object, pos:int, callback:Function):void
		{
			removeAllChildren();
			
			var mc:*;
			if(data.type == "boy"){
				mc = new ResBoyBrain;
				addChildEx(mc);
				mc._name.text = data.name;
				mc._coins.text = data.coins;
				mc._dex.text = data.dex;
				mc._lead.text = data.lead;
				mc._spirit.text = data.spirit;
				mc._troop.text = data.troop;
				mc._colorBox.gotoAndStop(data.quality);
			}else{
				mc = new ResGirlBrain;
				addChildEx(mc);
				mc._name.text = data.name;
				mc._coins.text = data.coins;
				mc._create.text = data.iniCreate;
				mc._logic.text = data.iniLogic;
				mc._point.text = data.iniPointLimit;
				mc._colorBox.gotoAndStop(data.quality);				
			}
			
			//转化
			new BmButton(mc._transformationBtn, function():void{
				ModelManager.brainModel.transBrain(pos, callback);
			});
			UiUtils.setButtonEnable(mc._transformationBtn, data.isHired != 1);
			
			TipHelper.setTip(mc._transformationBtn, new McTip("将此大脑转化为宇宙币和矿石资源，转化奖励随荣誉等级提升"));
			
			if(Data.data.user.techLevel < 10) mc._transformationBtn.visible = false;
			
			//头像
			var _img : McImage = new McImage(data.img);
			addChildEx(_img, 11, 19);
			
			//talent
			if(data.talent){
				new BmButton(mc._talent);
				var msg:String = "天赋：" + data.talent.name + "（" + data.talent.describe + "）";
				TipHelper.setTip(mc._talent, new McTip(msg));
			}else{
				mc._talent.visible = false;
			}
		}
	}
}
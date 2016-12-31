package com.brickmice.view.research
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	
	import flash.display.MovieClip;

	public class ResearchTalent extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ResearchTalent";
		
		private var _mc:MovieClip;
		
		public function ResearchTalent(data : Object)
		{
			var hid:int = data.hid;
			var newTalent:Object = data.newTalent;
			var callback:Function = data.callback;
			
			_mc = new ResResearchTalentWindow;
			super(NAME, _mc);
			
			_mc._newTalentName.text = newTalent.name;
			_mc._newTalentDetail.text = newTalent.describe;
			_mc._newTalentLvl.text = talentLevelName(newTalent.level);
			
			var heroData:Object = Data.data.girlHero[hid];
			if(heroData.talent && heroData.talent.id){
				_mc._getTalentBtn.visible = false;
				_mc._oldTalentName.text = heroData.talent.name;
				_mc._oldTalentDetail.text = heroData.talent.describe;
				_mc._oldTalentLvl.text = talentLevelName(heroData.talent.level);
			}else{
				_mc._substituteTalentBtn.visible = false;
				_mc._oldTalentName.text = '';
				_mc._oldTalentDetail.text = '';		
				_mc._oldTalentLvl.text = '';
			}
			
			new BmButton(_mc._cancelBtn, function():void{
				closeWindow();
			});
			new BmButton(_mc._substituteTalentBtn, function():void{
				ModelManager.girlHeroModel.replaceGirlHeroTalent(hid, callback);
				closeWindow();
			});
			new BmButton(_mc._getTalentBtn, function():void{
				ModelManager.girlHeroModel.replaceGirlHeroTalent(hid, callback);
				closeWindow();
			});
		}
		
		private function talentLevelName(level:int):String
		{
			var str:String = '';
			switch(level)
			{
				case 1:
				{
					str = '低级天赋';
					break;
				}
				case 2:
				{
					str = '中级天赋';
					break;
				}
				case 3:
				{
					str = '高级天赋';
					break;
				}
				case 4:
				{
					str = '特级天赋';
					break;
				}
			}
			return str;
		}

	}
}
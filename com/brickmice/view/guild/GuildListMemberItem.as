package com.brickmice.view.guild
{
	import com.brickmice.data.Data;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class GuildListMemberItem extends Sprite
	{
		private var _mc:MovieClip;
		
		public function GuildListMemberItem(info : Object)
		{			
			_mc = new ResGuildListMemberItem;
			addChild(_mc);
			
			_mc._name.text = info.name;
			_mc._honorLvl.text = info.honorLevel;
			_mc._techLvl.text = info.techLevel;			
			switch(info.job)
			{
				case "0":
				{
					_mc._post.text = "会员";
					break;
				}
				case "1":
				{
					_mc._post.text = "理事";
					break;
				}
				case "2":
				{
					_mc._post.text = "盟主";
					break;
				}
			}
		}

	}
}

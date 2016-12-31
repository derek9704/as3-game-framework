package com.brickmice.view.planet
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class WarInfo extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "WarInfo";
		
		private var _mc:MovieClip;
		private var _warInfo:McPanel;

		public function WarInfo(data : Object)
		{
			_mc = new ResWarInfoWindow;
			super(NAME, _mc);
	
			_warInfo = new McPanel('', 282, 258);
			addChildEx(_warInfo, 41, 96);
			
			_mc._round.text = '';
			
			if(!data) return;
			
			_mc._round.text = data.round;
			
			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0x000000;
			tf.leading = 2;
			tf.font = 'SimSun';
			
			var txt:TextField = new TextField;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			txt.multiline = true;
			
			data.detail.reverse();
			for each (var battle:Object in data.detail) 
			{
				txt.htmlText += "回合" + battle.round 
					+ "<br>攻击方：" + data.attacker + " 损失" + battle.atkMouseLose + "兵力<br>攻击力：" 
					+ battle.atkOutputAttack + "<br>防御力：" + battle.atkOutputDefense
					+ "<br>参战兵力：" + battle.atkTotalMouse +  "<br>参战部队：" + battle.atkTotalTroop
					+ "<br>防御方：" + data.defenser + " 损失" 
					+ battle.defMouseLose + "兵力<br>攻击力：" + battle.defOutputAttack + "<br>防御力：" + battle.defOutputDefense
					+ "<br>参战兵力：" + battle.defTotalMouse +  "<br>参战部队：" + battle.defTotalTroop
					+ "<br>-----------------------------------<br>";
			}
			_warInfo.panel.removeAllChildren();
			_warInfo.addItem(txt);
		}
	}
}
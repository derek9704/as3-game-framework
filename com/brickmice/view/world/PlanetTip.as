package com.brickmice.view.world
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.framework.ui.sprites.CTip;
	import com.framework.utils.DateUtils;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 星球TIPS
	 * 
	 * @author derek
	 */
	public class PlanetTip extends CTip
	{
		
		private var _pid:int;
		
		/**
		 * 构造函数
		 */
		public function PlanetTip(pid : int)
		{			
			cWidth = 122;
			cHeight = 166;
			// 设定背景
			bg.setBg(new ResTipBg);
			_pid = pid;
		}
		
		private function setData(msg:String):void
		{
			// 构造文本
			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0xF1C976;
			tf.leading = 6;
			
			var txt : TextField = new TextField();
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.multiline = true;
			
			txt.htmlText = msg;
			
			// 如果超出了最高宽度.则进行折行处理
			if (txt.width > 250)
			{
				txt.width = 250;
				txt.wordWrap = true;
			}
			
			cWidth = txt.width + 10;
			cHeight = txt.textHeight + 25;
			
			addChildCenter(txt);
			txt.y -= 4;
		}
		
		public override function getData():void{
			removeAllChildren();
			var one:Object = Data.data.planet[_pid];
			var msg:String = '星球：' + one.name + '<br>阵营：' + one.unionName + '<br>等级：' + one.level + '<br>状态：' + (one.status == 'free' ? '和平' : '战争') + '<br>';
			//噩梦鼠状态
			var heroArr:Object = Data.data.boyHero;
			var houseHero:Array = [];
			var marchHero:Array = [];
			var attackHero:Array = [];
			for each(var hero:Object in heroArr) {
				if(!hero.planet.id || hero.planet.id != _pid) continue;
				if(hero.status == 'house'){
					houseHero.push(hero.name);
				}else if(hero.status == 'march'){
					marchHero.push(hero.name);
				}else if(hero.status == 'attack'){
					attackHero.push(hero.name);
				}
			}
			for (var i:int = 0; i < houseHero.length; i++) 
			{
				if(i == 0){
					msg += "驻扎噩梦鼠：" + houseHero[i];
				}else{
					msg +=' ' + houseHero[i];
				}
				if(i == houseHero.length - 1) msg += '<br>';
			}
			for (var j:int = 0; j < attackHero.length; j++) 
			{
				if(j == 0){
					msg += "进攻噩梦鼠：" + attackHero[j];
				}else{
					msg += ' ' + attackHero[j];
				}
				if(i == attackHero.length - 1) msg += '<br>';
			}
			for (var k:int = 0; k < marchHero.length; k++) 
			{
				if(k == 0){
					msg += "行军噩梦鼠：" + marchHero[k];
				}else{
					msg += ' ' + marchHero[k];
				}
				if(i == marchHero.length - 1) msg += '<br>';
			}
			
			if(one.union == Data.data.user.union || one.union == 4) {
				ModelManager.planetModel.getPlanetTipsData(_pid, function():void{
					var buyCD:Object = Data.data.planet[_pid].buyCD;
					if(!buyCD.leftTime){
						msg += "购买矿产：可购买<br>";
					}else{
						msg += "购买矿产：冷却中（" + DateUtils.toTimeString(parseInt(buyCD.leftTime)) + "）<br>";
					}
					var sellCD:Object = Data.data.planet[_pid].sellCD;
					if(!sellCD.leftTime){
						msg += "出售奶酪：可出售<br>";
					}else{
						msg += "出售奶酪：冷却中（" + DateUtils.toTimeString(parseInt(sellCD.leftTime)) + "）<br>";
					}
					if(Data.data.planet[_pid].discoveryFlag){
						msg += "探索情况：已探索<br>";
					}else{
						msg += "探索情况：未探索<br>";
					}
					setData(msg);
				});
			}else{
				setData(msg);
			}
		}
	}
}

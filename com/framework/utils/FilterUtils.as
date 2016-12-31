package com.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;

	/**
	 * 各种filter特效
	 * @author derek
	 */
	public class FilterUtils
	{
		/**
		 *  调整亮度
		 * @param obj
		 * @param value 取值范围-1~1,对应Flash内容制作工具里的-100%~100%
		 * 
		 */
		public static function setBrightness(obj:DisplayObject,value:Number = 0):void {
			var colorTransformer:ColorTransform = obj.transform.colorTransform
			var backup_filters:* = obj.filters
			if (value >= 0) {
				colorTransformer.blueMultiplier = 1-value
				colorTransformer.redMultiplier = 1-value
				colorTransformer.greenMultiplier = 1-value
				colorTransformer.redOffset = 255*value
				colorTransformer.greenOffset = 255*value
				colorTransformer.blueOffset = 255*value
			}else {
				value=Math.abs(value)
				colorTransformer.blueMultiplier = 1-value
				colorTransformer.redMultiplier = 1-value
				colorTransformer.greenMultiplier = 1-value
				colorTransformer.redOffset = 0
				colorTransformer.greenOffset = 0
				colorTransformer.blueOffset = 0
			}
	　　obj.transform.colorTransform = colorTransformer
	　　obj.filters = backup_filters
		}
		
		/**
		 * 返回一个加亮的特效
		 *
		 * @param level 亮度级别.1 = 100%.
		 */
		public static function createLight(level:Number):ConvolutionFilter
		{
			return new ConvolutionFilter(3, 3, [0, 0, 0, 0, level, 0, 0, 0, 0]);
		}

		/**
		 * 返回一个外发光效果,当str很高的时候.会实现描边效果
		 *
		 * @param color 发光颜色
		 * @param strength 强度
		 * @param blur 模糊
		 * @param alpha 透明度
		 */
		public static function createGlow(color:uint = 0xffffff, strength:Number = 8, blur:Number = 3, alpha:Number = 1):GlowFilter
		{
			return new GlowFilter(color, alpha, blur, blur, strength);
		}

		/**
		 * 返回一个阴影效果
		 *
		 * @param color 阴影颜色
		 * @param angle 阴影角度
		 * @param distance 阴影距离
		 * @param strength 强度
		 * @param blur 模糊
		 * @param alpha 透明度
		 */
		public static function createDropShadow(color:uint = 0x000000, angle:Number = 25, distance:Number = 4, strength:Number = 1, blur:Number = 1, alpha:Number = 1):DropShadowFilter
		{
			return new DropShadowFilter(distance, angle, color, alpha, blur, blur, strength);
		}

		/**
		 * 目标亮度增加
		 *
		 * @param target 目标对象
		 * @param level 亮度级别.1 = 100%.
		 */
		public static function light(target:DisplayObject, level:Number):void
		{
			addFilter(target, new ConvolutionFilter(3, 3, [0, 0, 0, 0, level, 0, 0, 0, 0]));
		}

		/**
		 * 外发光效果,当str很高的时候.会实现描边效果
		 *
		 * @param target 目标对象
		 * @param color 发光颜色
		 * @param strength 强度
		 * @param blur 模糊
		 * @param alpha 透明度
		 */
		public static function glow(target:DisplayObject, color:uint = 0xffffff, strength:Number = 8, blur:Number = 2, alpha:Number = 1):void
		{
			addFilter(target, new GlowFilter(color, alpha, blur, blur, strength));
		}

		/**
		 * 阴影效果
		 *
		 * @param target 目标对象
		 * @param color 阴影颜色
		 * @param angle 阴影角度
		 * @param distance 阴影距离
		 * @param strength 强度
		 * @param blur 模糊
		 * @param alpha 透明度
		 */
		public static function dropShadow(target:DisplayObject, color:uint = 0x000000, angle:Number = 25, distance:Number = 4, strength:Number = 1, blur:Number = 1, alpha:Number = 1):void
		{
			addFilter(target, new DropShadowFilter(distance, angle, color, alpha, blur, blur, strength));
		}

		/**
		 * 清除阴影
		 */
		public static function clearDropShadow(target:DisplayObject):void
		{
			clear(target, DropShadowFilter);
		}

		/**
		 * 渐变色(垂直)
		 *
		 * @param target 目标对象
		 * @param startColor 起始颜色
		 * @param endColor 结束颜色
		 */
		public static function gradientOverlay(target:DisplayObject, startColor:uint, endColor:uint):void
		{
			if (gradientOverlayShaderData === null)
			{
				gradientOverlayShaderData = new ByteArray();
				for (var byteIndex:int = 0; byteIndex < GRADIENT_OVERLAY_SHADER_DATA.length; byteIndex++)
					gradientOverlayShaderData.writeByte(GRADIENT_OVERLAY_SHADER_DATA[byteIndex]);
			}

			var shader:Shader = new Shader(gradientOverlayShaderData);
			shader.data.startColor.value = colorToVector(startColor);
			shader.data.endColor.value = colorToVector(endColor);
			shader.data.height.value = [target.height];

			addFilter(target, new ShaderFilter(shader));
		}

		/**
		 * 增加一个滤镜效果
		 *
		 * @param target 目标
		 * @param filter 特效
		 */
		public static function addFilter(target:DisplayObject, filter:*):void
		{
			var filters:Array = target.filters;
			if (filters === null)
				filters = [];
			filters.push(filter);
			target.filters = filters;
		}

		/**
		 * 清除目标的外发光
		 *
		 * @param target 目标
		 */
		public static function clearGlow(target:DisplayObject):void
		{
			clear(target, GlowFilter);
		}

		/**
		 * 清除高亮效果
		 *
		 * @param target 目标
		 */
		public static function clearLight(target:DisplayObject):void
		{
			clear(target, ConvolutionFilter);
		}

		/**
		 * 清除颜色遮罩
		 *
		 * @param target 目标
		 */
		public static function clearColorMask(target:DisplayObject):void
		{
			clear(target, ColorMatrixFilter);
		}

		/**
		 * 清除指定特效
		 *
		 * @param target 目标
		 * @param type 特效类型
		 */
		private static function clear(target:DisplayObject, type:Class):void
		{
			var filters:Array = target.filters;

			if (filters == null || filters.length == 0)
				return;

			var newFilters:Array = [];

			for each (var obj:Object in filters)
			{
				if (obj is type)
					continue;

				newFilters.push(obj);
			}

			target.filters = newFilters;
		}

		/**
		 * 设置颜色遮罩(即对象变成指定颜色.如禁用后的灰色)
		 *
		 * @param obj 对象
		 * @param color 颜色
		 * @param alpha 透明度
		 */
		public static function setColorMask(obj:DisplayObject, color:uint = 0xcccccc, alpha:Number = 1):void
		{
			var r:Number = ((color >> 16) % 256) / 255.0;
			var g:Number = ((color >> 8) % 256) / 255.0;
			var b:Number = (color % 256) / 255.0;

			addFilter(obj, new ColorMatrixFilter([r / 3, r / 3, r / 3, 0, 0, g / 3, g / 3, g / 3, 0, 0, b / 3, b / 3, b / 3, 0, 0, 0, 0, 0, alpha, 0]));
		}

		private static function colorToVector(color:uint):Array
		{
			var output:Array = new Array();
			output.push(Number((color & 0xff0000) >> 16) / 255);
			output.push(Number((color & 0xff00) >> 8) / 255);
			output.push(Number(color & 0xff) / 255);
			output.push(1.0);

			return output;
		}

		private static const GRADIENT_OVERLAY_SHADER_DATA:Array = [0xa5, 0x01, 0x00, 0x00, 0x00, 0xa4, 0x0f, 0x00, 0x47, 0x72, 0x61, 0x64, 0x69, 0x65, 0x6e, 0x74, 0x4f, 0x76, 0x65, 0x72, 0x6c, 0x61, 0x79, 0xa0, 0x0c, 0x6e, 0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x00, 0x00, 0xa0, 0x0c, 0x76, 0x65, 0x6e, 0x64, 0x6f, 0x72, 0x00, 0x00, 0xa0, 0x08, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x00, 0x01, 0x00, 0xa1, 0x01, 0x02, 0x00, 0x00, 0x0c, 0x5f, 0x4f, 0x75, 0x74, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x00, 0xa3, 0x00, 0x04, 0x73, 0x72, 0x63, 0x00, 0xa1, 0x01, 0x04, 0x01, 0x00, 0x0f, 0x73, 0x74, 0x61, 0x72, 0x74, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x00, 0xa1, 0x01, 0x04, 0x02, 0x00, 0x0f, 0x65, 0x6e, 0x64, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x00, 0xa1, 0x01, 0x01, 0x00, 0x00, 0x02, 0x68, 0x65, 0x69, 0x67, 0x68, 0x74, 0x00, 0xa1, 0x02, 0x04, 0x03, 0x00, 0x0f, 0x64, 0x73, 0x74, 0x00, 0x1d, 0x04, 0x00, 0xc1, 0x00, 0x00, 0x10, 0x00, 0x30, 0x05, 0x00, 0xf1, 0x04, 0x00, 0x10, 0x00, 0x1d, 0x06, 0x00, 0xf3, 0x05, 0x00, 0x1b, 0x00, 0x04, 0x00, 0x00, 0x10, 0x00, 0x00, 0x80, 0x00, 0x03, 0x00, 0x00, 0x10, 0x04, 0x00, 0x40, 0x00, 0x1d, 0x04, 0x00, 0x20, 0x00, 0x00, 0xc0, 0x00, 0x32, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x2a, 0x04, 0x00, 0x20, 0x00, 0x00, 0xc0, 0x00, 0x1d, 0x01, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x34, 0x00, 0x00, 0x00, 0x01, 0x80, 0x00, 0x00, 0x32, 0x04, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x32, 0x00, 0x00, 0x10, 0x3f, 0x80, 0x00, 0x00, 0x2a, 0x00, 0x00, 0x10, 0x04, 0x00, 0x80, 0x00, 0x1d, 0x01, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x34, 0x00, 0x00, 0x00, 0x01, 0x80, 0x00, 0x00, 0x32, 0x04, 0x00, 0x20, 0x3f, 0x80, 0x00, 0x00, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x32, 0x00, 0x00, 0x10, 0x3f, 0x80, 0x00, 0x00, 0x1d, 0x04, 0x00, 0x10, 0x00, 0x00, 0xc0, 0x00, 0x02, 0x04, 0x00, 0x10, 0x04, 0x00, 0x80, 0x00, 0x1d, 0x05, 0x00, 0xf3, 0x01, 0x00, 0x1b, 0x00, 0x03, 0x05, 0x00, 0xf3, 0x04, 0x00, 0xff, 0x00, 0x1d, 0x07, 0x00, 0xf3, 0x02, 0x00, 0x1b, 0x00, 0x03, 0x07, 0x00, 0xf3, 0x04, 0x00, 0xaa, 0x00, 0x1d, 0x08, 0x00, 0xf3, 0x05, 0x00, 0x1b, 0x00, 0x01, 0x08, 0x00, 0xf3, 0x07, 0x00, 0x1b, 0x00, 0x1d, 0x05, 0x00, 0xf3, 0x08, 0x00, 0x1b, 0x00, 0x03, 0x05, 0x00, 0xf3, 0x06, 0x00, 0xff, 0x00, 0x1d, 0x03, 0x00, 0xf3, 0x05, 0x00, 0x1b, 0x00,];
		private static var gradientOverlayShaderData:ByteArray;
	}
}

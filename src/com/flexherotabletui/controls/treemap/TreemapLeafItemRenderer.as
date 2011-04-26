package com.flexherotabletui.controls.treemap
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.core.mx_internal;
	
	import spark.components.LabelItemRenderer;

	/**
	 * Default label item renderer 
	 * @author C17911
	 */	
	public class TreemapLeafItemRenderer extends LabelItemRenderer implements ITreemapLeafItemRenderer  {
		
		private var _mapOwner:ITreemap;
		
		private var backgroundColor:uint = 0xEFEFEF;
		
		/**
		 * Default color for label text 
		 */		
		public var defaultTextColor:uint = 0x222222;
		/**
		 * Default color for label text when selected
		 */
		public var selectedTextColor:uint = 0xFFFFFF;
		
		/**
		 * Constructor 
		 */		
		public function TreemapLeafItemRenderer()
		{
			super();
			this.setStyle('textAlign','center');
			this.setStyle('color', this.defaultTextColor);
		}
		/**
		 * @inheritDoc
		 */		
		override public function set data(value:Object):void {
			super.data = value;
			if(this.mapOwner) {
				this.label = this.mapOwner.labelFunction(this.data);
				this.backgroundColor = this.mapOwner.colorFunction(this.data);
			}
		}
		/**
		 * @inheritDoc
		 */	
		public function set mapOwner(map:ITreemap):void {
			this._mapOwner = map;
		}
		
		public function get mapOwner():ITreemap {
			return this._mapOwner;
		}
		/**
		 * @inheritDoc
		 */	
		override public function set selected(value:Boolean):void {
			super.selected = value;
			if(this.selected) {
				this.setStyle('color',this.selectedTextColor);
			} else {
				this.setStyle('color',this.defaultTextColor);
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function drawBackground(unscaledWidth:Number, 
										  unscaledHeight:Number):void
		{
			// figure out backgroundColor
			// draw backgroundColor
			// the reason why we draw it in the case of drawBackground == 0 is for
			// mouse hit testing purposes
			graphics.clear();
			var useGradient:Boolean = true;
			if(useGradient) {
				var colors:Array = [backgroundColor, backgroundColor ];
				var alphas:Array = [1, .8];
				var ratios:Array = [0, 255];
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0 );
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			} else {
				graphics.beginFill(backgroundColor, 1);
			}
			// Selected and down states have a gradient overlay as well
			// as different separators colors/alphas
			var lineWidth:Number = .5;
			if (selected || down)
			{
				/*
				var colors:Array = [0x000000, 0x000000 ];
				var alphas:Array = [.2, .1];
				var ratios:Array = [0, 255];
				var matrix:Matrix = new Matrix();
				
				// gradient overlay
				matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0 );
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();*/
				lineWidth = 1;
				graphics.lineStyle(lineWidth, this.selectedTextColor);
			} else {
				graphics.lineStyle(lineWidth, this.defaultTextColor);
			}
			graphics.drawRect(0, 0, unscaledWidth - lineWidth, unscaledHeight - lineWidth);
			graphics.endFill();
		}
	}
}
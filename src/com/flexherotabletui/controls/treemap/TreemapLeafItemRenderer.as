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
		
		private var _mapOwner:Treemap;
		
		public function TreemapLeafItemRenderer()
		{
			super();
			this.setStyle('textAlign',"center");
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(this.mapOwner) {
				this.label = this.mapOwner.labelFunction(this.data);
				this.setStyle('backgroundColor', this.mapOwner.colorFunction(this.data));
			}
		}
		
		public function set mapOwner(map:Treemap):void {
			this._mapOwner = map;
		}
		
		public function get mapOwner():Treemap {
			return this._mapOwner;
		}
		/**
		 * @inheritDoc 
		 */		
		override protected function drawBackground(unscaledWidth:Number, 
										  unscaledHeight:Number):void
		{
			// figure out backgroundColor
			var backgroundColor:*;
			var downColor:* = getStyle("downColor");
			var drawBackground:Boolean = true;
			
			if (down && downColor !== undefined)
			{
				backgroundColor = downColor;
			}
			else if (selected)
			{
				backgroundColor = getStyle("selectionColor");
			}
			else if (hovered)
			{
				backgroundColor = getStyle("rollOverColor");
			}
			else if (showsCaret)
			{
				backgroundColor = getStyle("selectionColor");
			}
			else
			{
				backgroundColor = getStyle("backgroundColor");
			} 
			
			// draw backgroundColor
			// the reason why we draw it in the case of drawBackground == 0 is for
			// mouse hit testing purposes
			graphics.beginFill(backgroundColor, drawBackground ? 1 : 0);
			graphics.lineStyle(0.5,0x000000,0.5);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			var topSeparatorColor:uint;
			var topSeparatorAlpha:Number;
			var bottomSeparatorColor:uint;
			var bottomSeparatorAlpha:Number;
			
			// Selected and down states have a gradient overlay as well
			// as different separators colors/alphas
			if (selected || down)
			{
				var colors:Array = [0x000000, 0x000000 ];
				var alphas:Array = [.2, .1];
				var ratios:Array = [0, 255];
				var matrix:Matrix = new Matrix();
				
				// gradient overlay
				matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0 );
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
			
			// separators are a highlight on the top and shadow on the bottom
			topSeparatorColor = 0xFFFFFF;
			topSeparatorAlpha = .3;
			bottomSeparatorColor = 0x000000;
			bottomSeparatorAlpha = .3;
			
			
			// draw separators
			// don't draw top separator for down and selected states
			if (!(selected || down))
			{
				/*graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();*/
			}
			
			/*graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
			graphics.drawRect(0, unscaledHeight - (mx_internal::isLastItem ? 0 : 1), unscaledWidth, 1);
			graphics.endFill();*/
			
			
			// add extra separators to the first and last items so that 
			// the list looks correct during the scrolling bounce/pull effect
			// top
			/*if (itemIndex == 0)
			{
				graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
				graphics.drawRect(0, -1, unscaledWidth, 1);
				graphics.endFill(); 
			}*/
			// bottom
			/*if (mx_internal::isLastItem)
			{
				// we want to offset the bottom by 1 so that we don't get
				// a double line at the bottom of the list if there's a 
				// border
				graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, unscaledHeight + 1, unscaledWidth, 1);
				graphics.endFill(); 
			}*/
			
			
		}
	}
}
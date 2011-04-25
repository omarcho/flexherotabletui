package com.flexherotabletui.controls.treemap
{
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;

	/**
	 * Squary layout for treeemap.
	 * 
	 * Theory:
	 * we have to split the main region in sub-regions to provide a situable space for accomodate the squares representing the data.
	 * A simple approach will create an horizontal areas (of rectangles) or vertical, but is more easy to visualize when you create "squarified" areas 
	 * accomodating each on the best aspect ratio available.
	 * Initial:
	 * 		We have a rectangle of know area.
	 * 		Width (W) R+;
	 * 		Heigth (H) R+;
	 * Aspect Ratio is as follow (Ar) = W/H;
	 * 
	 * Best aspect ratio is calculated as follow: Math.max (w/h; h/w);
	 * 
	 * @see http://en.wikipedia.org/wiki/Treemapping
	 * @author c17911
	 */
	public class SquarifyLayout extends LayoutBase
	{
		
		public function SquarifyLayout()
		{
			super();
		}
		/**
		 * This is a temporal dataProvider 
		 */		
		public var dataProvider:Array;
		
		public var sizeField:String;
		
		
		/**
		 * @private
		 * The sum of the weight values for the remaining items that have not
		 * yet been positioned and sized.
		 */
		private var _totalRemainingWeightSum:Number = 0;
		
		/**
		 * @private
		 * The number of items remaining to be drawn.
		 */
		private var _itemsRemaining:int = 0;
		
		/**
		 * @inheritDoc 
		 */		
		override public function updateDisplayList(width:Number, height:Number):void {
			super.updateDisplayList(width, height);
			if(this.dataProvider  != null && this.dataProvider.length > 0 && this.sizeField != null) {
				squarify(this.dataProvider.concat(), new Rectangle(0,0, width, height));
				this.renderGraphics(this.dataProvider);
			}
		}
		/**
		 * Method to update and size LeafItems 
		 * @param rows
		 */		
		private function renderGraphics(rows:Array):void
		{
			var rowCount:int = rows.length;
			var leaf:TreemapLeafItemRenderer;
			for(var i:int = 0; i < rowCount; i++)
			{
				leaf = this.target.getChildAt(i) as TreemapLeafItemRenderer;
				leaf.width = this.dataProvider[i].width;
				leaf.height = this.dataProvider[i].height;
				leaf.x = this.dataProvider[i].x;
				leaf.y = this.dataProvider[i].y;
			}
		}
		/**
		 * @private
		 * The main squarify algorithm.
		 */
		private function squarify(items:Array, bounds:Rectangle):void
		{
			//item are already sorted
			//items = items.sortOn("weight", Array.DESCENDING | Array.NUMERIC);
			this._totalRemainingWeightSum = sumWeights(items, this.sizeField);
			this._itemsRemaining = items.length;
			var lastAspectRatio:Number = Number.POSITIVE_INFINITY;
			var lengthOfShorterEdge:Number = Math.min(bounds.width, bounds.height);
			var row:Array = [];
			var nextItem:Object;
			while(items.length > 0)
			{
				nextItem = items.shift();
				row.push(nextItem);
				var drawRow:Boolean = true;
				var aspectRatio:Number = calculateWorstAspectRatioInRow(row, lengthOfShorterEdge, bounds, this.sizeField, this._totalRemainingWeightSum, this._itemsRemaining);
				if(lastAspectRatio >= aspectRatio || isNaN(aspectRatio))
				{
					lastAspectRatio = aspectRatio;
					//if this is the last item, force the row to draw
					drawRow = items.length == 0;
				}
				else
				{
					//put the item back if the aspect ratio is worse than the previous one
					//we want to draw, of course
					items.unshift(row.pop());
				}
				
				if(drawRow)
				{	
					bounds = this.layoutRow(row, lengthOfShorterEdge, bounds);
					//reset for the next pass
					lastAspectRatio = Number.POSITIVE_INFINITY;
					lengthOfShorterEdge = Math.min(bounds.width, bounds.height);
					row = [];
					drawRow = false;
				}
			}
		}
		
		/**
		 * @private
		 * Draws a row of items
		 * 
		 * @param row						The items in the row
		 * @param lengthOfShorterEdge		the length, in pixels, of the edge of the remaining bounds on which to draw the row (the shorter one)
		 * @param bounds					The remaining bounds into which to draw items
		 */
		private function layoutRow(row:Array, lengthOfShorterEdge:Number, bounds:Rectangle):Rectangle
		{
			var horizontal:Boolean = (lengthOfShorterEdge == bounds.width);
			var lengthOfLongerEdge:Number = (horizontal ? bounds.height : bounds.width);
			var sumOfRowWeights:Number = sumWeights(row, this.sizeField);
			
			var lengthOfCommonItemEdge:Number = lengthOfLongerEdge * (sumOfRowWeights / this._totalRemainingWeightSum);
			if(isNaN(lengthOfCommonItemEdge))
			{
				if(this._totalRemainingWeightSum == 0)
				{
					lengthOfCommonItemEdge = lengthOfLongerEdge * row.length / this._itemsRemaining;
				}
				else
				{
					lengthOfCommonItemEdge = 0;
				}
			}
			
			var rowCount:int = row.length;
			var position:Number = 0;
			for(var i:int = 0; i < rowCount; i++)
			{
				var item:Object = row[i];
				var weight:Number = item[this.sizeField];
				
				var ratio:Number = weight / sumOfRowWeights;
				//if all nodes in a row have a weight of zero, give them the same area
				if(isNaN(ratio))
				{
					if(sumOfRowWeights == 0 || isNaN(sumOfRowWeights))
					{
						ratio = 1 / row.length;
					}
					else
					{
						ratio = 0;
					}
				}
				
				var lengthOfItemEdge:Number = lengthOfShorterEdge * ratio;
				
				if(horizontal)
				{
					item.x = bounds.x + position;
					item.y = bounds.y;
					item.width = lengthOfItemEdge;
					item.height = lengthOfCommonItemEdge;
				}
				else
				{
					item.x = bounds.x;
					item.y = bounds.y + position;
					item.width = Math.max(0, lengthOfCommonItemEdge);
					item.height = Math.max(0, lengthOfItemEdge);
				}
				position += lengthOfItemEdge;
				this._itemsRemaining--;
			}
			
			this._totalRemainingWeightSum -= sumOfRowWeights;
			return updateBoundsForNextRow(bounds, lengthOfCommonItemEdge);
		}
		/**
		 * @private
		 * Calculates the sum of weight values in an Array of
		 * TreeMapItemLayoutData instances.
		 */
		private static function sumWeights(row:Array, sizeField:String):Number
		{
				var sum:Number = 0;
				for each(var item:Object in row)
				{
					sum += item[sizeField];
				}
				return sum;
		}
		//## static methods area place here because they didnt change. they are like helpers ##
		
		
		/**
		 * @private
		 * Determines the worst (maximum) aspect ratio of the items in a row.
		 * 
		 * @param row						a row of items for which to calculate the worst aspect ratio
		 * @param lengthOfShorterEdge		the length, in pixels, of the edge of the remaining bounds on which to draw the row (the shorter one)
		 * @return							the worst aspect ratio for the items in the row
		 */
		private static function calculateWorstAspectRatioInRow(row:Array, lengthOfShorterEdge:Number, bounds:Rectangle, sizeField:String, totalRemainingWeightSum:Number, itemsRemaining:int):Number
		{
			if(row.length == 0)
			{
				throw new ArgumentError("Row must contain at least one item. If you see this message, please file a bug report.");
			}
			
			if(lengthOfShorterEdge == 0)
			{
				return Number.MAX_VALUE;
			}
			
			var totalArea:Number = bounds.width * bounds.height;
			var lengthSquared:Number = lengthOfShorterEdge * lengthOfShorterEdge;
			
			//special case where there is zero weight (to avoid divide by zero problems)
			if(totalRemainingWeightSum == 0)
			{
				var oneItemArea:Number = totalArea * (1 / itemsRemaining);
				var rowAreaSquared:Number = Math.pow(oneItemArea * row.length, 2);
				return Math.max(lengthSquared * oneItemArea / rowAreaSquared, rowAreaSquared / (lengthSquared * oneItemArea));
			}
			
			var firstItem:Object = row[0];
			var firstItemArea:Number = totalArea * (firstItem[sizeField] / totalRemainingWeightSum);
			var maxArea:Number = firstItemArea;
			var minArea:Number = firstItemArea;
			var sumOfAreas:Number = firstItemArea;
			var rowCount:int = row.length;
			var item:Object;
			var area:Number;
			for(var i:int = 1; i < rowCount; i++)
			{
				item = row[i];
				area = totalArea * (item[sizeField] / totalRemainingWeightSum);
				minArea = Math.min(area, minArea);
				maxArea = Math.max(area, maxArea);
				sumOfAreas += area;
			}
			
			// max(w^2 * r+ / s^2, s^2 / (w^2 / r-))
			var sumSquared:Number = sumOfAreas * sumOfAreas;
			return Math.max(lengthSquared * maxArea / sumSquared, sumSquared / (lengthSquared * minArea));
		}
		
		/**
		 * @private
		 * After a row is drawn, the bounds must be made smaller to draw the
		 * next row.
		 */
		private static function updateBoundsForNextRow(bounds:Rectangle, modifier:Number):Rectangle
		{
			if(bounds.width > bounds.height)
			{
				var newWidth:Number = Math.max(0, bounds.width - modifier);
				bounds.x -= (newWidth - bounds.width);
				bounds.width = newWidth;
			}
			else
			{
				var newHeight:Number = Math.max(0, bounds.height - modifier);
				bounds.y -= (newHeight - bounds.height);
				bounds.height = newHeight;
			}
			return bounds;
		}
		
	}
}
package tl.adapters.starling
{

	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.errors.MissingContextError;

	import tl.view.IView;
	import tl.view.IViewContainerAdapter;

	public class StarlingViewContainerAdapter extends Sprite implements IViewContainerAdapter
	{
		protected var mClipRect : Rectangle;

		public function get numViews() : uint
		{
			return numChildren;
		}

		public function StarlingViewContainerAdapter()
		{
		}

		public function addView( view : IView ) : void
		{
			addChild( view.face as DisplayObject );
		}

		public function addViewAtIndex( view : IView, index : int ) : void
		{
			addChildAt( view.face as DisplayObject, index );
		}

		public function setViewIndex( view : IView, index : int ) : void
		{
			setChildIndex( view.face as DisplayObject, index );
		}

		public function removeView( view : IView ) : void
		{
			removeChild( view.face as DisplayObject );
		}

		public function removeViewAt( index : int ) : void
		{
			removeChildAt( index );
		}

		override public function render( support : RenderSupport, alpha : Number ) : void
		{
			if ( mClipRect == null )
			{
				super.render( support, alpha );
			}
			else
			{
				var context : Context3D = Starling.context;
				if ( context == null )
				{
					throw new MissingContextError();
				}

				support.finishQuadBatch();
				context.setScissorRectangle( mClipRect );

				super.render( support, alpha );

				support.finishQuadBatch();
				context.setScissorRectangle( null );
			}
		}

		override public function hitTest( localPoint : Point, forTouch : Boolean = false ) : DisplayObject
		{
			// without a clip rect, the sprite should behave just like before
			if ( mClipRect == null )
			{
				return super.hitTest( localPoint, forTouch );
			}

			// on a touch test, invisible or untouchable objects cause the test to fail
			if ( forTouch && (!visible || !touchable) )
			{
				return null;
			}

			var globalPoint : Point = localToGlobal( localPoint );

			if ( mClipRect.contains( globalPoint.x * contentScaleX, globalPoint.y * contentScaleY ) )
			{
				return super.hitTest( localPoint, forTouch );
			}
			else
			{
				return null;
			}
		}

		public function get viewScrollRect() : Rectangle
		{
			if ( mClipRect )
			{
				var scaleX : Number = contentScaleX;
				var scaleY : Number = contentScaleY;

				return new Rectangle( mClipRect.x / scaleX, mClipRect.y / scaleY,
						mClipRect.width / scaleX, mClipRect.height / scaleY );
			}
			else
			{
				return null;
			}
		}

		public function set viewScrollRect( value : Rectangle ) : void
		{
			if ( value )
			{
				var scaleX : Number = contentScaleX;
				var scaleY : Number = contentScaleY;

				if ( mClipRect == null )
				{
					mClipRect = new Rectangle();
				}
				mClipRect.setTo( scaleX * value.x, scaleY * value.y, scaleX * value.width, scaleY * value.height );
			}
			else
			{
				mClipRect = null;
			}
		}

		private function get contentScaleX() : Number
		{
			var currentStarling : Starling = Starling.current;
			return currentStarling.viewPort.width / currentStarling.stage.stageWidth;
		}

		private function get contentScaleY() : Number
		{
			var currentStarling : Starling = Starling.current;
			return currentStarling.viewPort.height / currentStarling.stage.stageHeight;
		}

	}
}

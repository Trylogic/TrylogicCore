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
	import tl.adapters.IViewContainerAdapter;

	public class StarlingViewContainerAdapter extends Sprite implements IViewContainerAdapter
	{
		protected var mClipRect : Rectangle;
		protected var scissorScrollRect : Rectangle;

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

		public function getViewIndex( view : IView ) : int
		{
			var faceAsDisplayObject : DisplayObject = view.face as DisplayObject;
			return faceAsDisplayObject.parent != this ? -1 : getChildIndex( faceAsDisplayObject );
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
				updateScissorClipRect();
				context.setScissorRectangle( scissorScrollRect );
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

			if ( mClipRect.contains( localPoint.x * Starling.contentScaleFactor, localPoint.y * Starling.contentScaleFactor ) )
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
			return mClipRect;
		}

		public function set viewScrollRect( value : Rectangle ) : void
		{
			mClipRect = value;
			updateScissorClipRect();
		}

		protected function updateScissorClipRect() : void
		{
			if ( mClipRect )
			{
				var scaleX : Number = Starling.contentScaleFactor;
				var scaleY : Number = Starling.contentScaleFactor;
				var globalPoint : Point = localToGlobal( new Point( x, y ) );
				if ( scissorScrollRect == null )
				{
					scissorScrollRect = new Rectangle( (globalPoint.x) * scaleX, (globalPoint.y) * scaleY, mClipRect.width * scaleX, mClipRect.height * scaleY );
				}
				else
				{
					scissorScrollRect.setTo( (globalPoint.x) * scaleX, (globalPoint.y) * scaleY, mClipRect.width * scaleX, mClipRect.height * scaleY );
				}
			}
			else
			{
				scissorScrollRect = null;
			}
		}

	}
}

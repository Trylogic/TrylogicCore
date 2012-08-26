package tl.adapters.nativeDisplayList
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import tl.view.IView;

	import tl.adapters.IViewContainerAdapter;

	public class NativeViewContainerAdapter extends Sprite implements IViewContainerAdapter
	{

		public function get numViews() : uint
		{
			return numChildren;
		}

		public function set viewScrollRect( value : Rectangle ) : void
		{
			super.scrollRect = value;
		}

		public function get viewScrollRect() : Rectangle
		{
			return super.scrollRect;
		}

		public function NativeViewContainerAdapter()
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
	}
}

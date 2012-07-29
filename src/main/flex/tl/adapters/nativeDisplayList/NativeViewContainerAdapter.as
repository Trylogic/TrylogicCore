package tl.adapters.nativeDisplayList
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import tl.view.IView;

	import tl.view.IViewContainerAdapter;

	public class NativeViewContainerAdapter extends Sprite implements IViewContainerAdapter
	{
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

		public function get numViews() : uint
		{
			return numChildren;
		}

		public function removeViewAt( index : int ) : void
		{
			removeChildAt( index );
		}
	}
}

package tl.view
{

	import flash.geom.Rectangle;

	import tl.adapters.IViewContainerAdapter;
	import tl.ioc.IoCHelper;

	[DefaultProperty("subViews")]
	public class ViewContainer extends AbstractView
	{

		protected var _subViews : Vector.<IView> = new Vector.<IView>();

		public function set viewScrollRect( value : Rectangle ) : void
		{
			(face as IViewContainerAdapter).viewScrollRect = value;
		}

		public function get viewScrollRect() : Rectangle
		{
			return (face as IViewContainerAdapter).viewScrollRect;
		}

		/**
		 * Inner childs.
		 *
		 * @param value
		 */
		public function set subViews( value : Vector.<IView> ) : void
		{
			value ||= new Vector.<IView>();


			_subViews = value;
			const faceAsViewContainerAdapter : IViewContainerAdapter = _face as IViewContainerAdapter;
			if ( faceAsViewContainerAdapter )
			{
				while ( faceAsViewContainerAdapter.numViews )
				{
					faceAsViewContainerAdapter.removeViewAt( 0 );
				}

				// TODO: optimize
				for ( var i : uint = 0; i < _subViews.length; i++ )
				{
					_subViews[i].controller.addViewToContainerAtIndex( faceAsViewContainerAdapter, i );
				}
			}
		}

		public final function get subViews() : Vector.<IView>
		{
			return _subViews.concat();
		}

		public function ViewContainer()
		{
		}

		override protected function lazyCreateFace() : IDisplayObject
		{
			var result : IViewContainerAdapter = IoCHelper.resolve( IViewContainerAdapter, this );
			for each ( var element : IView in _subViews )
			{
				element.controller.addViewToContainer( result );
			}
			return result;
		}
	}
}

package tl.view
{

	import flash.geom.Rectangle;

	import tl.adapters.IViewContainerAdapter;
	import tl.ioc.IoCHelper;

	[DefaultProperty("subViews")]
	public class ViewContainer extends AbstractView
	{

		use namespace viewInternal;

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
			var oldSubviews : Vector.<IView> = _subViews;
			_subViews = value;
			for each( var element : IView in oldSubviews )
			{
				if ( value.indexOf( element ) == -1 )
				{
					uninstallChildView( element );
				}
			}

			for ( var i : uint = 0; i < value.length; i++ )
			{
				installChildViewAtIndex( value[i], i );
			}
		}

		public final function get subViews() : Vector.<IView>
		{
			return _subViews.concat();
		}

		public function ViewContainer()
		{
		}

		viewInternal function installChildViewAtIndex( child : IView, index : int ) : void
		{
			if ( _face )
			{
				child.controller.addViewToContainerAtIndex( face as IViewContainerAdapter, index );
			}
		}

		viewInternal function uninstallChildView( child : IView ) : void
		{
			if ( _face )
			{
				child.controller.removeViewFromContainer( face as IViewContainerAdapter );
			}
		}

		override protected function lazyCreateFace() : IDisplayObject
		{
			var result : IViewContainerAdapter = IoCHelper.resolve( IViewContainerAdapter, this );
			for ( var i : uint = 0; i < _subViews.length; i++ )
			{
				_subViews[i].controller.addViewToContainerAtIndex( result, i );
			}
			return result;
		}
	}
}

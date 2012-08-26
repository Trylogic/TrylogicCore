package tl.view
{

	import mx.events.PropertyChangeEvent;

	import tl.adapters.IViewContainerAdapter;

	import tl.ioc.IoCHelper;

	[DefaultProperty("view")]
	public class SingleViewContainer extends AbstractView
	{
		protected var _view : IView;

		[Bindable(event="propertyChange")]
		override public function get face() : *
		{
			if ( _face == null )
			{
				_face = IoCHelper.resolve( IViewContainerAdapter, this );
				dispatchEvent( PropertyChangeEvent.createUpdateEvent( this, "face", null, _face ) );
			}

			return _face;
		}

		public function get view() : IView
		{
			return _view;
		}

		[Bindable]
		public function set view( value : IView ) : void
		{
			if ( _view )
			{
				_view.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, dispatchEvent );
				_view.controller.removeViewFromContainer( face );
			}

			_view = value;

			if ( _view )
			{
				_view.controller.addViewToContainer( face );
				_view.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, dispatchEvent, false, 0, true );
			}
		}

		public function SingleViewContainer()
		{
		}
	}
}

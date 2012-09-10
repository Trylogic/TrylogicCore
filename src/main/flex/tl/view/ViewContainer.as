package tl.view
{

	import flash.geom.Rectangle;

	import mx.events.PropertyChangeEvent;

	import tl.adapters.IViewContainerAdapter;

	import tl.ioc.IoCHelper;

	[DefaultProperty("subViews")]
	public class ViewContainer extends AbstractView implements IViewContainerAdapter
	{

		protected var _subViews : Vector.<IView> = new Vector.<IView>();

		public function set viewScrollRect( value : Rectangle ) : void
		{
			face.viewScrollRect = value;
		}

		public function get viewScrollRect() : Rectangle
		{
			return face.viewScrollRect;
		}

		public function get numViews() : uint
		{
			return _subViews.length;
		}

		/**
		 * Inner childs.
		 *
		 * @param value
		 */
		public function set subViews( value : Vector.<IView> ) : void
		{
			if ( value == null )
			{
				value = new Vector.<IView>();
			}

			var element : IView;

			for each ( element in _subViews.concat() )
			{
				if ( value.indexOf( element ) == -1 )
				{
					removeView( element );
				}
			}

			for each ( element in value )
			{
				if ( _subViews.indexOf( element ) == -1 )
				{
					addView( element );
				}
				else
				{
					setViewIndex( element, -1 );
				}
			}

			_subViews = value;
		}

		public final function get subViews() : Vector.<IView>
		{
			return _subViews.concat();
		}

		public function ViewContainer()
		{
		}

		public function addView( element : IView ) : void
		{
			if ( _subViews.indexOf( element ) != -1 )
			{
				return;
			}

			element.controller.addViewToContainer( face );
			_subViews.push( element );
		}

		public function addViewAtIndex( element : IView, index : int ) : void
		{
			addView( element );

			setViewIndex( element, index );
		}

		public function setViewIndex( element : IView, index : int ) : void
		{
			if ( _subViews.indexOf( element ) == -1 )
			{
				return;
			}

			// TODO: throw error if element is not our child
			element.controller.setViewIndexInContainer( face, index );
		}

		public function removeViewAt( index : int ) : void
		{
			removeView( _subViews[index] );
		}

		public function removeView( element : IView ) : void
		{
			if ( _subViews.indexOf( element ) == -1 )
			{
				return;
			}

			element.controller.removeViewFromContainer( face );

			_subViews.splice( _subViews.indexOf( element ), 1 );
		}

		override protected function lazyCreateFace() : *
		{
			return IoCHelper.resolve( IViewContainerAdapter, this );
		}
	}
}

package tl.viewController
{

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.events.PropertyChangeEvent;
	import mx.utils.object_proxy;

	import tl.adapters.IViewContainerAdapter;
	import tl.utils.describeTypeCached;
	import tl.view.IView;
	import tl.view.Outlet;

	use namespace object_proxy;
	use namespace outlet;

	public class ViewController extends EventDispatcher implements IVIewController
	{
		protected namespace lifecycle = "http://www.trylogic.ru/viewController/lifecycle";
		protected namespace viewControllerInternal = "http://www.trylogic.ru/viewController/internal";

		use namespace viewControllerInternal;

		viewControllerInternal var _viewInstance : IView;
		viewControllerInternal var _viewEventHandlers : Array;
		viewControllerInternal var _viewOutlets : Array;

		public function ViewController()
		{
		}

		public function addViewToContainer( container : IViewContainerAdapter ) : void
		{
			lifecycle::viewBeforeAddedToStage();

			container.addView( view );
		}

		public function addViewToContainerAtIndex( container : IViewContainerAdapter, index : int ) : void
		{
			addViewToContainer( container );

			setViewIndexInContainer( container, index );
		}

		public function setViewIndexInContainer( container : IViewContainerAdapter, index : int ) : void
		{
			container.setViewIndex( view, index < 0 ? (container.numViews + index) : index );
		}

		public function removeViewFromContainer( container : IViewContainerAdapter ) : void
		{
			lifecycle::viewBeforeRemovedFromStage();

			if ( viewIsLoaded )
			{
				container.removeView( view );
			}
		}

		[Event(name="removedFromStage")]
		viewControllerInternal function viewRemovedFromStage() : void
		{
			_viewInstance.destroy();

			initWithView( null );

			destroy();
		}

		public function initWithView( newView : IView ) : void
		{
			if ( newView == _viewInstance )
			{
				return;
			}

			uninstallView();
			lifecycle::viewUnloaded();

			_viewInstance = newView;

			if ( _viewInstance )
			{
				installView();

				internalViewLoaded();
				lifecycle::viewLoaded();
			}
		}

		public final function destroy() : void
		{
			lifecycle::destroy();
			internalDestroy();
		}

		[Event(name="propertyChange")]
		viewControllerInternal function onPropertyChange( event : PropertyChangeEvent ) : void
		{
			if ( _viewOutlets && _viewOutlets.indexOf( event.property.toString() ) != -1 )
			{
				setOutlet( String( event.property ) );
			}
		}

		lifecycle function viewBeforeAddedToStage() : void
		{
		}

		lifecycle function viewBeforeRemovedFromStage() : void
		{
		}

		lifecycle function viewLoaded() : void
		{
		}

		lifecycle function viewUnloaded() : void
		{
		}

		lifecycle function destroy() : void
		{
		}

		viewControllerInternal function internalViewLoaded() : void
		{
		}

		viewControllerInternal function internalDestroy() : void
		{
		}

		protected function get view() : IView
		{
			return _viewInstance;
		}

		viewControllerInternal function get viewIsLoaded() : Boolean
		{
			return _viewInstance != null;
		}

		viewControllerInternal function installView() : void
		{
			const myTypeDescription : XML = describeTypeCached( this );
			if ( _viewEventHandlers == null )
			{
				_viewEventHandlers = [];

				if ( Object( this ).constructor.prototype != ViewController.prototype )
				{
					myTypeDescription.method.
							( valueOf().metadata.( @name == "Event" ).length() > 0 ).
							( registerListener( metadata.arg.( @key == "name" ).@value.toString(), String( @name ) ) );
				}

				registerListener( "propertyChange", "onPropertyChange" );
				registerListener( "removedFromStage", "viewRemovedFromStage" );
			}

			if ( _viewOutlets == null )
			{
				_viewOutlets = [];

				if ( Object( this ).constructor.prototype != ViewController.prototype )
				{
					( myTypeDescription.variable + myTypeDescription.accessor.( @access != "readonly" ) ).
							( valueOf()["@uri"] == outlet ).
							( _viewOutlets.push( @name.toString() ) );
				}
			}

			for each( var outletName : String in _viewOutlets )
			{
				setOutlet( outletName );
			}

			for ( var eventName : String in _viewEventHandlers )
			{
				setHandler( eventName );
			}
		}

		viewControllerInternal function uninstallView() : void
		{
			for each( var outletName : String in _viewOutlets )
			{
				unsetOutlet( outletName );
			}

			if ( _viewInstance != null )
			{

				for ( var eventName : String in _viewEventHandlers )
				{
					unsetHandler( eventName );
				}
			}
		}

		viewControllerInternal function setOutlet( name : String ) : void
		{
			var outlet : Object = _viewInstance[name];
			this[name] = outlet is Outlet ? ( outlet as Outlet ).outletObject : outlet;
		}

		viewControllerInternal function unsetOutlet( name : String ) : void
		{
			this[name] = null;
		}

		viewControllerInternal function setHandler( name : String ) : void
		{
			_viewInstance.addEventListener( name, viewEventHandler );
		}

		viewControllerInternal function unsetHandler( name : String ) : void
		{
			_viewInstance.removeEventListener( name, viewEventHandler );
		}

		viewControllerInternal function registerListener( eventName : String, listener : String ) : void
		{
			if ( _viewEventHandlers[ eventName ] == null )
			{
				_viewEventHandlers[ eventName ] = [];
			}

			_viewEventHandlers[ eventName ].push( listener );
		}

		viewControllerInternal function viewEventHandler( e : Event ) : void
		{
			var methods : Array = _viewEventHandlers[e.type];
			if ( methods != null )
			{
				for each( var methodName : String in methods )
				{
					var destFunc : Function = this[methodName] as Function;
					if ( destFunc != null )
					{
						destFunc.apply( null, destFunc.length == 1 ? [e] : null );
					}
				}
			}
		}
	}

}

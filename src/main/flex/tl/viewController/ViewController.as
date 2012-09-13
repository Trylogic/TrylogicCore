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
	use namespace event;

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
			lifecycle::viewBeforeAddedToStage();

			container.addViewAtIndex( view, index );
		}

		public function setViewIndexInContainer( container : IViewContainerAdapter, index : int ) : void
		{
			container.setViewIndex( view, index );
		}

		public function removeViewFromContainer( container : IViewContainerAdapter ) : void
		{
			lifecycle::viewBeforeRemovedFromStage();

			if ( viewIsLoaded )
			{
				container.removeView( view );
			}
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

		viewControllerInternal function removedFromStage() : void
		{
			_viewInstance.destroy();

			initWithView( null );

			destroy();
		}

		viewControllerInternal function propertyChange( e : PropertyChangeEvent ) : void
		{
			if ( _viewOutlets && _viewOutlets.indexOf( e.property.toString() ) != -1 )
			{
				setOutlet( String( e.property ) );
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
					/*
					 myTypeDescription.method.
					 ( valueOf().metadata.( @name == "Event" ).length() > 0 ).
					 ( registerListener( metadata.arg.( @key == "name" ).@value.toString(), String( @name ) ) );
					 */

					myTypeDescription.method.
							( valueOf()["@uri"] == event ).
							( registerListener( String( @name ) ) );
				}

				registerListener( "propertyChange" );
				registerListener( "removedFromStage" );
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
			var outletObject : Object = _viewInstance[name];
			this.outlet::[name] = outletObject is Outlet ? ( outletObject as Outlet ).outletObject : outletObject;
		}

		viewControllerInternal function unsetOutlet( name : String ) : void
		{
			this.outlet::[name] = null;
		}

		viewControllerInternal function setHandler( name : String ) : void
		{
			_viewInstance.addEventListener( name, viewEventHandler );
		}

		viewControllerInternal function unsetHandler( name : String ) : void
		{
			_viewInstance.removeEventListener( name, viewEventHandler );
		}

		viewControllerInternal function registerListener( eventName : String ) : void
		{
			_viewEventHandlers[ eventName ] = true;
		}

		viewControllerInternal function viewEventHandler( e : Event ) : void
		{
			var destFunc : Function = this[e.type] as Function;
			destFunc.apply( null, destFunc.length == 1 ? [e] : null );
		}
	}

}

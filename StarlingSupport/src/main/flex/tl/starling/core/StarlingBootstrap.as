package tl.starling.core
{

	import flash.errors.IllegalOperationError;

	import mx.core.IStateClient2;

	import starling.core.Starling;

	import tl.actions.ActionDispatcher;

	import tl.actions.IActionDispatcher;

	import tl.bootloader.ApplicationLoader;
	import tl.core.IBootstrap;
	import tl.factory.ConstructorFactory;
	import tl.factory.ServiceFactory;
	import tl.factory.ActionDispatcherFactory;
	import tl.ioc.IoCHelper;
	import tl.starling.view.StarlingView;

	import tl.ioc.mxml.IAssociate;
	import tl.service.IService;
	import tl.utils.StatesImpl;

	[Frame(factoryClass="tl.starling.core.StarlingApplicationLoader")]
	public class StarlingBootstrap implements IBootstrap
	{
		{
			IoCHelper.registerType( IStateClient2, StatesImpl, ConstructorFactory );
			IoCHelper.registerType( IActionDispatcher, ActionDispatcher, ActionDispatcherFactory );
		}

		public var preloader : Class;

		public var subModules : Vector.<StarlingBootstrap>;

		public var applicationView : StarlingView;

		protected var initialized : Boolean = false;
		protected var _services : Vector.<IService>;

		public function set iocMap( value : Vector.<IAssociate> ) : void
		{
			for each( var assoc : IAssociate in value )
			{
				IoCHelper.registerAssociate( assoc );
			}
		}

		public function set services( value : Vector.<IService> ) : void
		{
			for each( var service : IService in value )
			{
				ServiceFactory.registerService( Object( service ).constructor, service );
			}

			_services = value;

			initServices();
		}

		public function StarlingBootstrap()
		{
		}

		public function initServices() : void
		{
			if ( !initialized )
			{
				return;
			}

			for each( var service : IService in _services )
			{
				if ( !service.initialized )
				{
					service.init();
				}
			}

			for each( var bootstrap : StarlingBootstrap in subModules )
			{
				bootstrap.initServices();
			}
		}

		public function init( applicationLoader : ApplicationLoader ) : void
		{
			if ( initialized )
			{
				throw new IllegalOperationError( "You can't call IBootstrap.init manually" );
			}

			if ( applicationView == null )
			{
				throw new ArgumentError( "applicationView of IBootstrap can't be null" );
			}

			initialized = true;
			initServices();
		}
	}
}

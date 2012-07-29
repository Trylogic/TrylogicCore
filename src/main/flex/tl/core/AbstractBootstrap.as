package tl.core
{

	import flash.errors.IllegalOperationError;

	import mx.core.IStateClient2;

	import tl.factory.ConstructorFactory;
	import tl.factory.ServiceFactory;
	import tl.ioc.*;
	import tl.ioc.mxml.IAssociate;
	import tl.service.IService;
	import tl.utils.StatesImpl;
	import tl.view.IView;

	[Frame(factoryClass="tl.core.TrylogicApplicationLoader")]
	public class AbstractBootstrap implements IBootstrap
	{
		{
			IoCHelper.registerType( IStateClient2, StatesImpl, ConstructorFactory );
		}

		// Sorry. Not properly tested yet :-[
		//public var subModules : Vector.<IBootstrap>;

		public var applicationView : IView;

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
			if(value == _services)
			{
				return;
			}

			for each( var service : IService in value )
			{
				ServiceFactory.registerService( Object( service ).constructor, service );
			}

			_services = value;

			initServices();
		}

		public function AbstractBootstrap()
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

			/* See comment at subModules declaration
			for each( var bootstrap : IBootstrap in subModules )
			{
				bootstrap.initServices();
			}
			*/
		}

		public function init( applicationLoader : TrylogicApplicationLoader ) : void
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

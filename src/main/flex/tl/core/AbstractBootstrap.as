﻿package tl.core
{

	import flash.errors.IllegalOperationError;

	import mx.core.IStateClient2;

	import tl.factory.ConstructorFactory;
	import tl.factory.SingletonFactory;
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

		public var applicationViewClass : Class;

		protected var _applicationView : IView;
		protected var initialized : Boolean = false;
		protected var _services : Vector.<IService>;

		protected function get applicationView() : IView
		{
			if ( applicationViewClass == null )
			{
				throw new ArgumentError( "applicationViewClass of IBootstrap can't be null" );
			}

			return _applicationView ||= new applicationViewClass();
		}

		public function set iocMap( value : Vector.<IAssociate> ) : void
		{
			for each( var assoc : IAssociate in value )
			{
				IoCHelper.registerAssociate( assoc );
			}
		}

		public function set services( value : Vector.<IService> ) : void
		{
			if ( value == _services )
			{
				return;
			}

			for each( var service : IService in value )
			{
				IoCHelper.registerSingleton( Object( service ).constructor, service );
			}

			_services = value;
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

			initialized = true;
			initServices();
		}
	}
}

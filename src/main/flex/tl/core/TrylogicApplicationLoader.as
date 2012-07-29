package tl.core
{

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import mx.core.IFlexModuleFactory;
	import mx.core.RSLData;

	import tl.factory.SingletonFactory;
	import tl.ioc.IoCHelper;

	public class TrylogicApplicationLoader extends MovieClip implements IFlexModuleFactory
	{
		public function TrylogicApplicationLoader()
		{
			init();
		}

		protected function init() : void
		{
			addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}

		protected function enterFrameHandler( event : Event ) : void
		{
			if ( framesLoaded >= totalFrames )
			{
				IEventDispatcher( event.currentTarget ).removeEventListener( event.type, arguments.callee );

				nextFrame();
				initApplication();
				loadApplication();
			}
		}

		protected function initApplication() : void
		{
			IoCHelper.registerSingleton( Stage, this.stage );

			IoCHelper.registerType( IBootstrap, ApplicationDomain.currentDomain.getDefinition( info()["mainClassName"] ) as Class, SingletonFactory );

			IoCHelper.registerSingleton( TrylogicApplicationLoader, this );
		}

		protected function loadApplication() : void
		{
			( IoCHelper.resolve( IBootstrap ) as IBootstrap ).init( this );
		}

		public function get allowDomainsInNewRSLs() : Boolean
		{
			return false;
		}

		public function set allowDomainsInNewRSLs( value : Boolean ) : void
		{
		}

		public function get allowInsecureDomainsInNewRSLs() : Boolean
		{
			return false;
		}

		public function set allowInsecureDomainsInNewRSLs( value : Boolean ) : void
		{
		}

		public function get preloadedRSLs() : Dictionary
		{
			return null;
		}

		public function addPreloadedRSL( loaderInfo : LoaderInfo, rsl : Vector.<RSLData> ) : void
		{
		}

		public function allowDomain( ...rest ) : void
		{
		}

		public function allowInsecureDomain( ...rest ) : void
		{
		}

		public function callInContext( fn : Function, thisArg : Object, argArray : Array, returns : Boolean = true ) : *
		{
			return null;
		}

		public function create( ...rest ) : Object
		{
			return null;
		}

		public function getImplementation( interfaceName : String ) : Object
		{
			return null;
		}

		public function info() : Object
		{
			return null;
		}

		public function registerImplementation( interfaceName : String, impl : Object ) : void
		{
		}
	}
}
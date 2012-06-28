package tl.starling.core
{

	import flash.display.Stage;

	import starling.core.Starling;

	import tl.ioc.IoCHelper;
	import tl.service.IService;

	public class StarlingService extends Starling implements IService
	{
		[Inject]
		public var globalStage : Stage;

		private var _initialized : Boolean = false;

		public function StarlingService()
		{
			IoCHelper.injectTo( this );

			super( StarlingScene, globalStage );
		}

		public function init() : void
		{
			start();
			_initialized = true;
		}

		public function get initialized() : Boolean
		{
			return _initialized;
		}
	}
}

package tl.adapters.starling
{

	import starling.animation.Juggler;

	import starling.core.Starling;

	import tl.core.TrylogicApplicationLoader;
	import tl.factory.SingletonFactory;
	import tl.ioc.IoCHelper;

	public class StarlingApplicationLoader extends TrylogicApplicationLoader
	{
		protected var starling : Starling;

		public function StarlingApplicationLoader()
		{
		}

		override protected function loadApplication() : void
		{
			starling = new Starling( StarlingScene, stage );

			IoCHelper.registerSingleton( Starling, starling );
			IoCHelper.registerSingleton( Juggler, starling.juggler );

			starling.start();
		}
	}
}

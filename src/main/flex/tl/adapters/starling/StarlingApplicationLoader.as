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

import tl.adapters.starling.StarlingBootstrap;
import tl.adapters.starling.StarlingViewContainerAdapter;
import tl.core.IBootstrap;
import tl.core.TrylogicApplicationLoader;
import tl.ioc.IoCHelper;

class StarlingScene extends StarlingViewContainerAdapter
	{

		public function StarlingScene()
		{
			var bootstrap : StarlingBootstrap = IoCHelper.resolve( IBootstrap );

			bootstrap.init( IoCHelper.resolve( TrylogicApplicationLoader ) );

			( bootstrap as StarlingBootstrap ).applicationView.controller.addViewToContainer( this );
		}
	}
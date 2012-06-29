package tl.starling.core
{

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;

	import starling.animation.Juggler;

	import starling.core.Starling;

	import tl.bootloader.ApplicationLoader;
	import tl.core.IBootstrap;
	import tl.core.TrylogicStage;
	import tl.factory.SingletonFactory;
	import tl.ioc.IoCHelper;

	public class StarlingApplicationLoader extends ApplicationLoader
	{
		public var starling : Starling;

		public function StarlingApplicationLoader()
		{
		}

		override protected function loadApplication() : void
		{
			nextFrame();
			removeChild( DisplayObject( preloader ) );

			IoCHelper.registerType( ApplicationLoader, ApplicationLoader, SingletonFactory );
			SingletonFactory.registerImplementation( ApplicationLoader, this );

			IoCHelper.registerType( Stage, TrylogicStage );
			IoCHelper.resolve( Stage, this );

			IoCHelper.registerType( IBootstrap, ApplicationDomain.currentDomain.getDefinition( info()["mainClassName"] ) as Class, SingletonFactory );

			IoCHelper.registerType(Starling, Starling, SingletonFactory);
			IoCHelper.registerType(Juggler, Juggler, SingletonFactory);

			starling = new Starling(StarlingScene, stage);
			SingletonFactory.registerImplementation(Starling, starling);
			SingletonFactory.registerImplementation(Juggler, starling.juggler);

			starling.start();
		}
	}
}

package tl.starling.core
{

	import starling.display.Sprite;

	import tl.bootloader.ApplicationLoader;

	import tl.core.IBootstrap;
	import tl.ioc.IoCHelper;

	public class StarlingScene extends Sprite
	{

		public function StarlingScene()
		{
			var bootstrap : StarlingBootstrap = IoCHelper.resolve(IBootstrap);

			bootstrap.init(IoCHelper.resolve(ApplicationLoader));

			StarlingBootstrap( bootstrap ).applicationView.controller.addViewToContainer( this );
		}
	}
}

package tl.starling.core
{

	import starling.display.Sprite;

	import tl.core.IBootstrap;
	import tl.ioc.IoCHelper;
	import tl.starling.core.StarlingBootstrap;

	public class StarlingScene extends Sprite
	{
		[Inject]
		public var bootstrap : IBootstrap;


		public function StarlingScene()
		{
			IoCHelper.injectTo( this );

			StarlingBootstrap( bootstrap ).applicationView.controller.addViewToContainer( this );
		}
	}
}

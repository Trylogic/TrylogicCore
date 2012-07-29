package tl.adapters.starling
{

	import tl.core.IBootstrap;
	import tl.core.TrylogicApplicationLoader;
	import tl.ioc.IoCHelper;

	public class StarlingScene extends StarlingViewContainerAdapter
	{

		public function StarlingScene()
		{
			var bootstrap : StarlingBootstrap = IoCHelper.resolve( IBootstrap );

			bootstrap.init( IoCHelper.resolve( TrylogicApplicationLoader ) );

			( bootstrap as StarlingBootstrap ).applicationView.controller.addViewToContainer( this );
		}
	}
}

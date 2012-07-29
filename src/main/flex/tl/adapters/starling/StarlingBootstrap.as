package tl.adapters.starling
{

	import tl.core.AbstractBootstrap;
	import tl.ioc.IoCHelper;
	import tl.view.IViewContainerAdapter;

	[Frame(factoryClass="tl.adapters.starling.StarlingApplicationLoader")]
	public class StarlingBootstrap extends AbstractBootstrap
	{
		{
			IoCHelper.registerType( IViewContainerAdapter, StarlingViewContainerAdapter );
		}

		public function StarlingBootstrap()
		{
		}
	}
}

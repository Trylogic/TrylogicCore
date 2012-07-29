package tl.factory
{

	import flash.utils.Dictionary;

	import tl.ioc.IoCHelper;

	import tl.service.IService;

	public class ServiceFactory
	{
		private static const services : Dictionary = new Dictionary();

		public static function makeInstance( type : Class, forInstance : Object = null ) : Object
		{
			return services[type];
		}

		public static function registerService( type : Class, serviceInstance : IService ) : void
		{
			services[type] = serviceInstance;
			IoCHelper.registerType( type, type, ServiceFactory );
		}
	}
}

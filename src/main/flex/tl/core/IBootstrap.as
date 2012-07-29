package tl.core
{

	import tl.ioc.mxml.IAssociate;
	import tl.service.IService;

	public interface IBootstrap
	{
		function set iocMap( value : Vector.<IAssociate> ) : void;

		function set services( value : Vector.<IService> ) : void;

		function initServices() : void;

		function init( applicationLoader : TrylogicApplicationLoader ) : void;
	}
}

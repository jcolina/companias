package talleresCompania2010.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	
	public class IdiomaAplicacion
	{
		private var dataXML:XMLList;
		private var saludo:XML;
		private var nombre:XML;
		
		public function IdiomaAplicacion(pais:String)
		{
			try {
				var loader:URLLoader = new URLLoader();
				loader.load(new URLRequest("idioma/idiomaApp" + pais + ".xml"));
				loader.addEventListener(Event.COMPLETE, loaderService); 
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{
					Alert.show("Problemas con carga de archivo del idioma de :" + event.text.toString() + pais);
				});   	       	
	        }catch (error:Error) {
	          	Alert.show("Problemas con carga de archivo del idioma de " + pais);
	        }
		}
		
		private function loaderService(event:Event):void {
			dataXML = XMLList(event.target.data);
			Application.application.objIdiomaAplicacion = this;
			Application.application.loginCorrecto();
		}
		
		public function getFrase(nodo:String):String {
			return dataXML.child(nodo).toString();
		}
	}
}
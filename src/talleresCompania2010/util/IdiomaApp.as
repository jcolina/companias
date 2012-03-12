package talleresCompania2010.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	import talleresCompania2010.Modulos.modLogin;
	
	
	public class IdiomaApp
	{
		private static var dataXML:XMLList;
		private var saludo:XML;
		private var nombre:XML;
		private var IDSubPerfil:String;
		private var objModLogin:modLogin;
		public static const SEPARADOR_VALUES:String = "#$#";
		public static const ENTER_TAG:String = "[enter]";
		public static const ENTER_VALUE:String = "\n";
		
		public function IdiomaApp(pais:String, IDSubPerfil:String, objModLogin:modLogin)
		{
			this.objModLogin = objModLogin;
			this.IDSubPerfil = IDSubPerfil;
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
			Application.application.loginCorrecto()
				objModLogin.btnLogin.enabled = true;
			
		}
		
			public static function getText(texto:String):String {
			if(replaceEnter(dataXML.child(texto).toString()) != ""){
				return replaceEnter(dataXML.child(texto).toString());
			}else{
				return "TEXTO NO ENCONTRADO";
			}
		}
		
		public static function replaceEnter(texto:String):String {
			return texto.split(ENTER_TAG).join(ENTER_VALUE);
		}
		
		public static function getTextReplace(texto:String, parametros:Array):String {
			var returnText:String = dataXML.child(texto).toString();
			for(var i:int = 0; i < parametros.length; i++){
				var listaTemp:Array = parametros[i].split(SEPARADOR_VALUES);
				returnText = returnText.split("${" + listaTemp[0] + "}").join(listaTemp[1]);
			}
			return replaceEnter(returnText);
		}
		
		public static function getValueReplace(key:String, value:String):String{
			return key + SEPARADOR_VALUES + value;
		}
	}
}
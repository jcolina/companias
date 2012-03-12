package talleresCompania2010.util
{
	import mx.core.Application;
	
	import talleresCompania2010.Componentes.comWait;
	
	public final class BrowserUtil
	{
		public static const PARAMETRO_TALLER:String = "Taller";
		public static const PARAMETRO_LOCAL:String = "Local";
		public static const PARAMETRO_PATENTE:String = "Patente";
		public static const PARAMETRO_SINIESTRO:String = "Siniestro";
		
		public static var objComWait:comWait;
		
		public static function getTaller():String{			
			if(Application.application.ObjDatosUrl != null){
				return Application.application.ObjDatosUrl[PARAMETRO_TALLER];
			}
			return null;
		}
		
		public static function setNullTaller():void{			
			Application.application.ObjDatosUrl[PARAMETRO_TALLER] = null;
		}
		
		public static function getLocal():String{			
			if(Application.application.ObjDatosUrl != null){
				return Application.application.ObjDatosUrl[PARAMETRO_LOCAL];
			}
			return null;
		}
		
		public static function setNullLocal():void{			
			Application.application.ObjDatosUrl[PARAMETRO_LOCAL] = null;
		}
		
		public static function getPatente():String{			
			if(Application.application.ObjDatosUrl != null){
				return Application.application.ObjDatosUrl[PARAMETRO_PATENTE];
			}
			return null;
		}
		
		public static function setNullPatente():void{			
			Application.application.ObjDatosUrl[PARAMETRO_PATENTE] = null;
		}
		
		public static function getSiniestro():String{			
			if(Application.application.ObjDatosUrl != null){
				return Application.application.ObjDatosUrl[PARAMETRO_SINIESTRO];
			}
			return null;
		}
		
		public static function setNullSiniestro():void{			
			Application.application.ObjDatosUrl[PARAMETRO_SINIESTRO] = null;
		}
		
		public static function showWaitMessage():void{
			objComWait = new comWait();
			objComWait.patente = getPatente();
			objComWait.siniestro = getSiniestro();
			Application.application.createPopUpManager(objComWait);
		}
		
		public static function closeWaitMessage():void{
			if(objComWait != null){
				Application.application.closePopUp(objComWait);
			}
		}
		
		public static function getEncodeURL(taller:String, local:String, patente:String, siniestro:String):String{
			return Application.application.encriptarBase64(PARAMETRO_TALLER + "=" + taller + "&" + PARAMETRO_LOCAL + "=" + local + "&" + PARAMETRO_PATENTE + "=" + patente + "&" + PARAMETRO_SINIESTRO + "=" + siniestro).replace("\n", "");
		}
	}
}
package talleresCompania2010.businessLogic
{
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	
	public class DatosContacto
	{		
		private const RESULT_FORMAT:String = "e4x";
		private const WSDL:String = "DatosEmail";
		private const OPERATION:String = "OpPlantillas";
		private const MESSAGE_ABSTRACT_FUNCTION:String = IdiomaApp.getText('datos_contacto_metodo_abs');
		public var isRepuesto:Boolean = false;
				
		public function solDatosContacto():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS(WSDL, OPERATION);
			parametrosWS.IDUsuario = Application.application.ObjDatosLogin.IDUsuario;
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;				
			ws.OpPlantillas.resultFormat = RESULT_FORMAT;
			ws.OpPlantillas.send(parametrosWS.IDUsuario,
								parametrosWS.IDVehiculo);
		    ws.OpPlantillas.addEventListener(ResultEvent.RESULT, cargarDatosContacto);
		    ws.OpPlantillas.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_contacto_datos_title'));
		    });		
		}
		
		private function cargarDatosContacto(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			var objDatosContacto:Object = new Object();		
			
			//Se setean todos los datos al objeto Datos Contacto		
			objDatosContacto.IDPersona = listaDatosWS[0].IDPersona;
			objDatosContacto.Nombre = listaDatosWS[0].Nombre;
			objDatosContacto.Apellido = listaDatosWS[0].Apellido;
			objDatosContacto.Celular = listaDatosWS[0].Celular;			
			objDatosContacto.Fono = listaDatosWS[0].Fono;
			objDatosContacto.Email = listaDatosWS[0].Email;
			objDatosContacto.IDVehiculo = listaDatosWS[0].IDVehiculo;
			objDatosContacto.Patente = listaDatosWS[0].Patente;
			objDatosContacto.Marca = listaDatosWS[0].Marca;
			objDatosContacto.Modelo = listaDatosWS[0].Modelo;
			objDatosContacto.Entrega = listaDatosWS[0].Entrega;
			objDatosContacto.Hora = listaDatosWS[0].Hora;
			objDatosContacto.IDRecep = listaDatosWS[0].IDRecep;
			objDatosContacto.Mail_recep = listaDatosWS[0].Mail_recep;
			objDatosContacto.Num_Orden = listaDatosWS[0].Num_Orden;
			objDatosContacto.Num_Cono = listaDatosWS[0].Num_Cono;
			objDatosContacto.Local = listaDatosWS[0].Local;
			objDatosContacto.Siniestro = listaDatosWS[0].Siniestro;
			objDatosContacto.Limite = listaDatosWS[0].Limite;
			objDatosContacto.CiaEmail = listaDatosWS[0].CiaEmail;			
			objDatosContacto.IDLiquidador = listaDatosWS[0].IDLiquidador;	
			objDatosContacto.NomLiquidador = listaDatosWS[0].NomLiquidador;				
			objDatosContacto.MailLiquidador = listaDatosWS[0].MailLiquidador;				
			objDatosContacto.Gestor = Application.application.formatoGestores(listaDatosWS[0].Gestor);
			
			Application.application.parametrosCorreo = listaDatosWS[0].Campos;
			Application.application.ObjDatosContacto = objDatosContacto;
			extraFunction(listaDatosWS);
		}
		
		public function extraFunction(listaDatosWS:ArrayCollection):void{
			throw new IllegalOperationError(MESSAGE_ABSTRACT_FUNCTION);
		}	
	}
}
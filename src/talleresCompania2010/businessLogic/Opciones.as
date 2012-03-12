package talleresCompania2010.businessLogic
{

	import Notificacion.com.notifications.Notification;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modOpciones;
	import talleresCompania2010.util.IdiomaApp;

	public class Opciones
	{
		private var ObjModOp:modOpciones;
		public var IsUpdatePass:Boolean;

		public function Opciones(ObjModOp:modOpciones)
		{
			this.ObjModOp = ObjModOp;
			sendOpciones();
		}
		
		public function sendOpciones():void{
			var parametrosWS:Object = new Object();
			parametrosWS.IDUsuario = Application.application.idUsuario;
			var ws:WebService = Application.application.getWS("UpdateInfo","OpBuscarPersona");	
			ws.OpBuscarPersona.resultFormat = "e4x";
			ws.OpBuscarPersona.send(parametrosWS.IDUsuario);
		    ws.OpBuscarPersona.addEventListener("result", desplegar_datos);
		    ws.OpBuscarPersona.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('opciones_alert_title_lista'));
		    });
		}


		private function desplegar_datos(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
    		if(listaDatosWS != null){
				ObjModOp.txtCelular.text = listaDatosWS[0].Celular;
				ObjModOp.txtEmail.text = listaDatosWS[0].Email;	
				Application.application.formatoCelular(ObjModOp.txtCelular);
    		}
		}
		
		public function actualizarDatos():void{			
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("UpdateInfo","OpUpdateInfo");
			ws.OpUpdateInfo.resultFormat = "e4x";
			
			parametrosWS.Rut =  Application.application.idUsuario;
			parametrosWS.Email = ObjModOp.txtEmail.text;
			parametrosWS.Celular = Application.application.formatoPuntos(ObjModOp.txtCelular.text);
			parametrosWS.Seleccion = "0";
			
			if(IsUpdatePass){				
				parametrosWS.Pass = Application.application.encriptarBase64(ObjModOp.txtNewPass.text);
			}else{
				parametrosWS.Pass = Application.application.pass;
			}
			ws.OpUpdateInfo.send(parametrosWS.Rut,	
									parametrosWS.Email,
									parametrosWS.Celular,
									parametrosWS.Pass,
									parametrosWS.Seleccion);
		    ws.OpUpdateInfo.addEventListener("result", actualizaexito);
		    ws.OpUpdateInfo.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('opciones_alert_title_actualizacion'));
		    });	
		}
		
		private function actualizaexito(event:ResultEvent):void {
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS[0].Return == 1){
				if(IsUpdatePass){
					Application.application.pass = Application.application.encriptarBase64(ObjModOp.txtNewPass.text);
				}
				Notification.show(IdiomaApp.getText('opciones_alert_actualizacion_exitosa'), IdiomaApp.getText('general_aviso_title'));
				Application.application.email = ObjModOp.txtEmail.text;
				Application.application.celular = Application.application.formatoPuntos(ObjModOp.txtCelular.text);
				Application.application.closePopUp(ObjModOp);
			}else{
				Alert.show(IdiomaApp.getText('opciones_alert_actualizacion_fallo'),IdiomaApp.getText('general_error'));
			}			
		}
	}
}
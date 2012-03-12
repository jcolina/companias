package talleresCompania2010.Modulos.Documentos.businessLogic
{
	import Notificacion.com.notifications.Notification;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	import mx.utils.ObjectUtil;
	
	import talleresCompania2010.Modulos.Documentos.modUpDocumentosSolicitud;
	import talleresCompania2010.businessLogic.Email;
	import talleresCompania2010.util.IdiomaApp;
	
	public class UpSolicitudDocumentos
	{
		private var objModSolicitudDocumentos:modUpDocumentosSolicitud;
		private var objEmail:Email;
		
		public function UpSolicitudDocumentos(objModSolicitudDocumentos:modUpDocumentosSolicitud)
		{
			this.objModSolicitudDocumentos = objModSolicitudDocumentos;
			this.solListaEtapas();
		}
		
		private function solListaEtapas():void {
			var listaEtapas:ArrayCollection = new ArrayCollection(ObjectUtil.copy(Application.application.listaTareas.source) as Array);
			listaEtapas.addItemAt({ID: 0, Nombre: "Otra"},0);
			objModSolicitudDocumentos.cboEtapa.dataProvider = listaEtapas;
			objModSolicitudDocumentos.cboEtapa.labelField = "Nombre";
		}
		
		public function updateSolicitud():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("Documentos", "OpUpEstado");
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			parametrosWS.IDUsuario = Application.application.ObjDatosLogin.IDUsuario;			
			parametrosWS.IDSolicitud = Application.application.ObjDatosSolicitud.IDSolicitud;			
			ws.OpUpEstado.resultFormat = "e4x";
			ws.OpUpEstado.send(
								parametrosWS.IDVehiculo,
								parametrosWS.IDUsuario,
								parametrosWS.IDSolicitud
								);
		    ws.OpUpEstado.addEventListener("result", updateSolicitudResponse);
		    ws.OpUpEstado.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('up_solicitud_documento_alert_title_actua'));
		    });		
		}
		
		private function updateSolicitudResponse(event:ResultEvent):void {
			if(Application.application.XMLToArray(event)[0].Retorno == "1"){	
				Notification.show(IdiomaApp.getText('up_solicitud_documento_not_exitosa'), IdiomaApp.getText('general_aviso_title'));		
				Application.application.reloadListaDocumentos();
				this.objEmail = new Email(extraFunction);
			}else{
				Alert.show(IdiomaApp.getText('up_solicitud_documento_not_actua_error'), IdiomaApp.getText('ingresa_solicitud_alert_title_error'));	
			}
		}
		
		public function extraFunction():void{			
			this.objEmail.reemplazarValor(Email.DOCUMENTOS_TAG, Application.application.ObjDatosSolicitud.NombreTipo);
			this.objEmail.reemplazarValor(Email.FECHA_ENTREGA_TAG, Application.application.ObjDatosSolicitud.FechaEsperada);
			
			if(Application.application.ObjDatosSolicitud.EmailResponsable != ""){
				this.objEmail.notificacionAutomatica(Email.FINALIZAR_SOLICITUD, Application.application.ObjDatosSolicitud.EmailResponsable);
			}
		}
	}
}
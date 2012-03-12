package talleresCompania2010.Modulos.Documentos.businessLogic
{
	import Notificacion.com.notifications.Notification;
	
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.Documentos.modSolicitudes;
	import talleresCompania2010.businessLogic.Email;
	import talleresCompania2010.util.IdiomaApp;
	
	public class IngresarSolicitud
	{
		private var objModSolicitud:modSolicitudes;
		private var objEmail:Email;
		
		public function IngresarSolicitud(objModSolicitud:modSolicitudes)
		{
			this.objModSolicitud = objModSolicitud;
			this.solListaSolicitud();
			this.solListaTipoDocumento();
			this.solListaRecepcionista();
		}
		
		private function solListaRecepcionista():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("ListaTareas", "OpRecepcionistas");
			parametrosWS.IDTaller = Application.application.getIDTallerPerfil();
			parametrosWS.IDLocal = Application.application.getIDLocalPerfil();				
			ws.OpRecepcionistas.resultFormat = "e4x";
			ws.OpRecepcionistas.send(
										parametrosWS.IDTaller, 
										parametrosWS.IDLocal);
		    ws.OpRecepcionistas.addEventListener("result", cargarListaRecepcionista);
		    ws.OpRecepcionistas.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('ingresa_solicitud_alert_title_recep'));
		    });		
		}
		
		private function cargarListaRecepcionista(event:ResultEvent):void {
			objModSolicitud.cboResponsable.dataProvider = Application.application.XMLToArray(event);
			objModSolicitud.cboResponsable.labelField = "NomRecep";
		}
		
		private function solListaSolicitud():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("Documentos", "OpGrilla");
			parametrosWS.IDTaller = Application.application.getIDTallerPerfil();
			parametrosWS.IDLocal = Application.application.getIDLocalPerfil();
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;			
			ws.OpGrilla.resultFormat = "e4x";
			ws.OpGrilla.send(
								parametrosWS.IDTaller,
								parametrosWS.IDLocal,
								parametrosWS.IDVehiculo
								);
		    ws.OpGrilla.addEventListener("result", cargarListaSolicitudes);
		    ws.OpGrilla.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('ingresa_solicitud_alert_title_sol'));
		    });
		}
		
		private function cargarListaSolicitudes(event:ResultEvent):void {			
			objModSolicitud.gridSolicitudes.dataProvider = Application.application.XMLToArray(event);		
		}
		
		private function solListaTipoDocumento():void {
			if(Application.application.listaDocumentos == null){
				listaTipoDocumento();	
			}else{
				cargarComboTipoDocumento();
			}
		}
		
		private function listaTipoDocumento():void {
			var ws:WebService = Application.application.getWS("Documentos", "OpDocumentos");			
			ws.OpDocumentos.resultFormat = "e4x";
			ws.OpDocumentos.send();
		    ws.OpDocumentos.addEventListener("result", cargarListaTipoDocumento);
		    ws.OpDocumentos.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('ingresa_solicitud_alert_title_sol'));
		    });
		}
		
		private function cargarListaTipoDocumento(event:ResultEvent):void {		
			Application.application.listaDocumentos = Application.application.XMLToArray(event);	
			cargarComboTipoDocumento();		
		}
		
		private function cargarComboTipoDocumento():void {			
			objModSolicitud.cboTipoDocumento.dataProvider = Application.application.listaDocumentos;		
			objModSolicitud.cboTipoDocumento.labelField = "NombreDocumento";
		}
		
		
		public function addSolicitud():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("Documentos", "OpUploadDoc");
			parametrosWS.IDUsuario = Application.application.ObjDatosLogin.IDUsuario;
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			parametrosWS.FechaEstimada = DateField.dateToString(objModSolicitud.dtFechaEsperada.selectedDate, "YYYY-MM-DD");
			parametrosWS.IDTipoDocumento = objModSolicitud.cboTipoDocumento.selectedItem.IDTipoDocumento;
			parametrosWS.IDUsuarioResponsable = objModSolicitud.cboResponsable.selectedItem.ID;			
			ws.OpUploadDoc.resultFormat = "e4x";
			ws.OpUploadDoc.send(
								parametrosWS.IDUsuario,
								parametrosWS.IDVehiculo,
								parametrosWS.FechaEstimada,
								parametrosWS.IDTipoDocumento,
								parametrosWS.IDUsuarioResponsable
								);
		    ws.OpUploadDoc.addEventListener("result", addSolicitudResponse);
		    ws.OpUploadDoc.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('ingresa_solicitud_alert_title_sol_ingreso'));
		    });
		}
		
		private function addSolicitudResponse(event:ResultEvent):void {		
			if(Application.application.XMLToArray(event)[0].Retorno == "1"){
				Notification.show(IdiomaApp.getText('ingresa_solicitud_not_exitoso'), IdiomaApp.getText('general_aviso_title'));
				this.objEmail = new Email(extraFunction);
				Application.application.reloadListaDocumentos();
			}else{
				Alert.show(IdiomaApp.getText('ingresa_solicitud_not_fail'), IdiomaApp.getText('ingresa_solicitud_alert_error'));
			}
		}
		
		public function extraFunction():void{
			this.objEmail.reemplazarValor(Email.DOCUMENTOS_TAG, objModSolicitud.cboTipoDocumento.text);
			this.objEmail.reemplazarValor(Email.FECHA_ENTREGA_TAG, objModSolicitud.dtFechaEsperada.text);
			
			if(objModSolicitud.lblEmailResponsable.text != ""){
				this.objEmail.notificacionAutomatica(Email.INGRESO_SOLICITUD, objModSolicitud.lblEmailResponsable.text);
			}
		}
	}
}
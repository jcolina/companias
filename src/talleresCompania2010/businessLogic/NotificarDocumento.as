package talleresCompania2010.businessLogic
{	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.Documentos.modNotificarDocumento;
	import talleresCompania2010.util.BrowserUtil;
	import talleresCompania2010.util.IdiomaApp;
	
	public class NotificarDocumento
	{
		private var ObjModNot:modNotificarDocumento;
		private var movilAsegurado:String = "";
		private var SMS:String = "";
		private var mail:Mail;
		private var paten:String;
		private var ObjParams:Object = new Object();
		private var datosPlantillas:ArrayCollection;
		private var objEmail:Email;

		
		public function NotificarDocumento(ObjModNot:modNotificarDocumento) {
			this.ObjModNot = ObjModNot;
			this.objEmail = new Email(listaPlantillas);
			this.solListaEmail();
		}
		
		private function solListaEmail():void{
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("MailAgenda", "OpMailsContacto");
			ws.OpMailsContacto.resultFormat = "e4x";
			parametrosWS.IDLocal = Application.application.getIDLocalPerfil();
			parametrosWS.IDTaller = Application.application.getIDTallerPerfil();
			parametrosWS.IDCompania = 0;
			ws.OpMailsContacto.send(parametrosWS.IDLocal,
							parametrosWS.IDTaller,
							parametrosWS.IDCompania);
			ws.OpMailsContacto.addEventListener(ResultEvent.RESULT, listaEmailResponse);
			ws.OpMailsContacto.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				Alert.show(IdiomaApp.getText("general_alert_fault_message_ws"), IdiomaApp.getText("lib_com_notificar_ws_lista_email_title"));
			});				
		}
		
		private function listaEmailResponse(event:ResultEvent):void{
			ObjModNot.txtCC.dataProvider = Application.application.XMLToArray(event);
		}
		private function listaPlantillas():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("EmailLotus", "getPlantillas", 5);
			ws.getPlantillas.resultFormat = "e4x"; 
			parametrosWS.Tipo = Application.application.CARGA_DOCUMENTO;
			parametrosWS.Taller =  Application.application.TALLER_DEFAULT;
			parametrosWS.Compania = Application.application.idCompania;
			ws.getPlantillas.send(	parametrosWS.Tipo,
									parametrosWS.Taller,
									parametrosWS.Compania);
			ws.getPlantillas.addEventListener(ResultEvent.RESULT, cargarListaPlantillas);
			ws.getPlantillas.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('notificar_documento_alert_title_plantilla'));
			});			
		}
		
		private function cargarListaPlantillas(event:ResultEvent):void {
			try{
				var listaDatosWS:ArrayCollection = Application.application.formatoListaMail(event.result.getPlantillasReturn);
				this.objEmail.reemplazarValor(Email.DOCUMENTOS_TAG, Application.application.documentos);
				
				var patente:String = Application.application.ObjVehiculo.Patente;
				var siniestro:String = Application.application.ObjVehiculo.NumeroSiniestro;
				var taller:String = Application.application.mlPrincipal.child.cbTaller.selectedLabel;
				var local:String = Application.application.mlPrincipal.child.cbLocales.selectedLabel;
				
				this.objEmail.reemplazarValor(Email.URL_APLICACION_TAG, Application.application.getUrlServer("urlAplicacion") + "#" + BrowserUtil.getEncodeURL(taller, local, patente, siniestro));
				
			    ObjModNot.txAsunto.text = this.objEmail.reemplazarValorPlantilla(listaDatosWS[0].Asunto);
				ObjModNot.txCuerpo.text = this.objEmail.reemplazarValorPlantilla(listaDatosWS[0].Cuerpo);
				
			}catch(e:Error){							
				Alert.show(IdiomaApp.getText('notificar_documento_alert_error_carga_tipo'), IdiomaApp.getText('notificar_documento_alert_error_carga_tipo_title'));
			}
		}
		
		public function sendMail():void {
			var listMailCc:String = ObjModNot.txtCC.text;
			ObjModNot.btnSendMail.enabled = false;
		    var listMailTo:String = ObjModNot.txMails.text;
		    
			if(listMailTo != null){
				if(Application.application.validar([ObjModNot.vlCC, ObjModNot.vlCuerpo, ObjModNot.vlAsunto])){
					
					this.objEmail.sendEmail(listMailTo, 
											listMailCc, Email.CARGA_DOCUMENTO,
											Email.TALLER_DEFAULT,
											Application.application.idCompania,
											Application.application.ObjVehiculo.IDVehiculo,
											"", 
											envioOK,
											faultFunction);
				}else{
					faultFunction();
				}
			}else{
				Alert.show(IdiomaApp.getText('notificar_documento_alert_seleccionar_destino'),IdiomaApp.getText('general_aviso_title'));
				faultFunction();
			}
		}		
		
		public function faultFunction():void{
			ObjModNot.btnSendMail.enabled = true;
		}
		
		private function envioOK():void {
			ObjModNot.btnSendMail.enabled = true;
			Application.application.updateModBitacoraMail();
			Application.application.closePopUp(ObjModNot);
		}		
	}
}
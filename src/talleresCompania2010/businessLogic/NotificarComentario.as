package talleresCompania2010.businessLogic{
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modNotificarComentario;
	import talleresCompania2010.util.IdiomaApp;
	
	public class NotificarComentario extends DatosContacto{
		
		private var ObjModNot:modNotificarComentario;
		private var movilAsegurado:String = "";
		private var mail:Mail;
		private var paten:String;
		private var objEmail:Email;
		
		public function NotificarComentario(ObjModNot:modNotificarComentario) {
			this.ObjModNot = ObjModNot;
			this.objEmail = new Email(solMails);
			solListaEmail();
		}

		private function solListaEmail():void{
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("MailAgenda", "OpMailsContacto");
			ws.OpMailsContacto.resultFormat = "e4x";
			parametrosWS.IDLocal = 0;
			parametrosWS.IDTaller = 0;
			parametrosWS.IDCompania = Application.application.idCompania;
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
		
		private function solMails():void {
			try{		
				var parametrosWS:Object = new Object();
				parametrosWS.Tipo = "CIA";
				parametrosWS.IDUsuario = Application.application.idUsuario;
				parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
				var ws:WebService = Application.application.getWS("ContactoTaller","OpContactos");	
				ws.OpContactos.resultFormat = "e4x";
				ws.OpContactos.send(parametrosWS.Tipo,
										parametrosWS.IDUsuario,
										parametrosWS.IDVehiculo);
			    ws.OpContactos.addEventListener("result", cargarMails);
			    ws.OpContactos.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('notificar_comentario_alert_title_carga'));
		    });
			}catch(e:Error){
				Alert.show(IdiomaApp.getText('notificar_comentario_alert_notifica')+" "+e.message, e.name);
			}
		}
		
		private function cargarMails(event:ResultEvent):void {
			try{
	        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
				if(listaDatosWS != null){
					if(listaDatosWS[0].Gestortaller != null){
						ObjModNot.chkGestorTaller.selectedField = listaDatosWS[0].Gestortaller;
						ObjModNot.chkGestorTaller.enabled = true;
					}	
					if(listaDatosWS[0].Compania != null){
						ObjModNot.chkCompania.selectedField = listaDatosWS[0].Compania;
						ObjModNot.chkCompania.enabled = true;
					}
					if(listaDatosWS[0].Liquidador != null){
						ObjModNot.chkLiquidador.selectedField = listaDatosWS[0].Liquidador;
						ObjModNot.chkLiquidador.enabled = true;
					}	
					if(listaDatosWS[0].MailPropio != null){
						ObjModNot.chkYo.selectedField = listaDatosWS[0].MailPropio;
						ObjModNot.chkYo.enabled = true;
					}	
					if(listaDatosWS[0].Mail_recep != null){
					ObjModNot.chkRecepcionista.selectedField = listaDatosWS[0].Mail_recep;
					ObjModNot.chkRecepcionista.enabled = true;
				}
				}
			}catch(e:Error){
				Alert.show(e.name+" "+e.message);
			}			
		}
		
		public function sendMail():void {
			var parametrosWS:Object = new Object();
			var listMailTo:String = this.objEmail.listMailTo([ObjModNot.chkCompania, ObjModNot.chkGestorTaller, ObjModNot.chkLiquidador, ObjModNot.chkYo,ObjModNot.chkRecepcionista]);
			var listMailCc:String = ObjModNot.txtCC.text;

			if(listMailTo != null){
				if(Application.application.validar([ObjModNot.vlCC])){
					this.objEmail.reemplazarValor(Email.COMENTARIO_TAG, ObjModNot.comentario);
					this.objEmail.sendEmail(listMailTo, listMailCc, Email.COMENTARIO, 
											Email.TALLER_DEFAULT, 
											Application.application.idCompania, 
											Application.application.ObjVehiculo.IDVehiculo, "",
											resultFunction,	faultFunction);
				}else{
					ObjModNot.btnSendMail.enabled = true;
					Alert.show(IdiomaApp.getText('notificar_comentario_alert_verficicar_comentario'), IdiomaApp.getText('general_aviso_title'));
				}
			}else{
				ObjModNot.btnSendMail.enabled = true;
				Alert.show(IdiomaApp.getText('notificar_comentario_alert_debe_seleccionar'), IdiomaApp.getText('general_aviso_title'));
			}
		}
		
		public function faultFunction():void{
			ObjModNot.btnSendMail.enabled = true;
		}
		
		private function resultFunction():void {
			ObjModNot.btnSendMail.enabled = true;
			Application.application.updateModBitacoraMail();		
			Application.application.closePopUp(ObjModNot); 
		}
	}
}
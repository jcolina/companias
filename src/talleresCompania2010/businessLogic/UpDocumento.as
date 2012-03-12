package talleresCompania2010.businessLogic
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	import mx.utils.ObjectUtil;
	
	import talleresCompania2010.Modulos.Documentos.modNotificarDocumento;
	import talleresCompania2010.Modulos.Documentos.modUpDocumentos;
	import talleresCompania2010.util.IdiomaApp;
	
	public class UpDocumento
	{
	    private var ObjModUpDoc:modUpDocumentos;
		private var movilAsegurado:String = "";
		private var SMS:String = "";
		private var mail:Mail;
		private var paten:String;
		private var ObjParams:Object = new Object();
		private var datosPlantillas:ArrayCollection;
		
		public function UpDocumento(ObjModUpDoc:modUpDocumentos)
		{
			this.ObjModUpDoc = ObjModUpDoc;
			solMails();
			solListaEtapas();
			solListaTipoDocumento();
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
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('up_documento_alert_listar'));
		    });
		}
		
		private function cargarComboTipoDocumento():void {			
			ObjModUpDoc.cbCategoria.dataProvider = Application.application.listaDocumentos;		
			ObjModUpDoc.cbCategoria.labelField = "NombreDocumento";
		}
		
		private function cargarListaTipoDocumento(event:ResultEvent):void {		
			Application.application.listaDocumentos = Application.application.XMLToArray(event);	
			cargarComboTipoDocumento();		
		}
		
		private function solListaEtapas():void {
			var listaEtapas:ArrayCollection = new ArrayCollection(ObjectUtil.copy(Application.application.listaTareas.source) as Array);
			listaEtapas.addItemAt({ID: 0, Nombre: "Otra"},0);
			ObjModUpDoc.cboEtapa.dataProvider = listaEtapas;
			ObjModUpDoc.cboEtapa.labelField = "Nombre";
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
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('up_documento_alert_carga_mail_listar'));
		    });
			}catch(e:Error){
				Alert.show(IdiomaApp.getText('up_documento_not_com')+" "+e.message, e.name);
			}
		}
		
		private function cargarMails(event:ResultEvent):void {
			try{
	        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
				if(listaDatosWS != null){
					if(listaDatosWS[0].Gestortaller != null){
						ObjModUpDoc.chkGestorTaller.selectedField = listaDatosWS[0].Gestortaller;
						ObjModUpDoc.chkGestorTaller.enabled = true;
					}	
					if(listaDatosWS[0].Compania != null){
						ObjModUpDoc.chkCompania.selectedField = listaDatosWS[0].Compania;
						ObjModUpDoc.chkCompania.enabled = true;
					}
					if(listaDatosWS[0].Liquidador != null){
						ObjModUpDoc.chkLiquidador.selectedField = listaDatosWS[0].Liquidador;
						ObjModUpDoc.chkLiquidador.enabled = true;
					}	
					if(listaDatosWS[0].MailPropio != null){
						ObjModUpDoc.chkYo.selectedField = listaDatosWS[0].MailPropio;
						ObjModUpDoc.chkYo.enabled = true;
					}
					if(listaDatosWS[0].Mail_recep != null){
					ObjModUpDoc.chkRecepcionista.selectedField = listaDatosWS[0].Mail_recep;
					ObjModUpDoc.chkRecepcionista.enabled = true;
				}	
				}
			}catch(e:Error){
				Alert.show(e.name + " " + e.message);
			}			
		}
		
		public function abrirNotificacion():void{
			var modNoti:modNotificarDocumento = new modNotificarDocumento();
			modNoti.documentos = Application.application.documentos;
			Application.application.createPopUpManager(modNoti);
			modNoti.setPara(concadMail());
		}
				
		private function concadMail():String{
			var temp:String = "";
			if (ObjModUpDoc.txCompania.text != ""){
				temp = ObjModUpDoc.txCompania.text;
			}
			
			if(temp != "" && ObjModUpDoc.txGestorTaller.text != ""){
				temp += "," + ObjModUpDoc.txGestorTaller.text;
			}else if(ObjModUpDoc.txGestorTaller.text!= ""){
				temp = ObjModUpDoc.txGestorTaller.text;
			}
			
			if(temp != "" && ObjModUpDoc.txLiquidador.text != ""){
				temp += "," + ObjModUpDoc.txLiquidador.text;
			}else if(ObjModUpDoc.txLiquidador.text != ""){
				temp = ObjModUpDoc.txLiquidador.text;
			}
			
			if(temp != "" && ObjModUpDoc.txYo.text != ""){
				temp += "," + ObjModUpDoc.txYo.text;
			}else if(ObjModUpDoc.txYo.text != ""){
				temp = ObjModUpDoc.txYo.text;
			}
			if(temp != "" && ObjModUpDoc.txRecepcionista.text != ""){
				temp += "," + ObjModUpDoc.txRecepcionista.text;
			}else if(ObjModUpDoc.txRecepcionista.text != ""){
				temp = ObjModUpDoc.txRecepcionista.text;
			}
			return temp;
		}
	}
}
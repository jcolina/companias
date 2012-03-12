package talleresCompania2010.businessLogic{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import  mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modBitacoraMail;
	import talleresCompania2010.util.IdiomaApp;
	
	public class MailBitacora{
		private var objModBitacoraMail:modBitacoraMail;
		
		public function MailBitacora(objModBitacora:modBitacoraMail){
			objModBitacoraMail = objModBitacora;	
			cargarServices();
		}
		//-------------------------------------
		public function cargarServices():void{
			var parametrosWS:Object = new Object();	
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			var ws:WebService = Application.application.getWS("BitacoraMails","OpMailsVehiculo");
			ws.OpMailsVehiculo.resultFormat = "e4x";
			ws.OpMailsVehiculo.send(parametrosWS.IDVehiculo);
		    ws.OpMailsVehiculo.addEventListener("result", cargarGrilla);
		    ws.OpMailsVehiculo.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mail_bitacora_title_mail_lista'));
		    });
		}
		
		private function cargarGrilla(event:ResultEvent):void{			
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null) {
				
/* 				var Datos:ArrayCollection;
				
				if(ObjResult.L.R is ObjectProxy) {
					Datos = new ArrayCollection([ObjResult.L.R]);
				}else{
					Datos = ObjResult.L.R;
				} */
				objModBitacoraMail.gridMailBitacora.dataProvider = listaDatosWS;
				objModBitacoraMail.gridMailBitacora.addEventListener(ListEvent.ITEM_CLICK, cargaMail); 
			}
		}
		
		//---------------------------------------------------
		private function cargaMail(event:ListEvent):void{
			/*
			objModBitacoraMail.txtEmisor.text = event.itemRenderer.data.emisor; 
			objModBitacoraMail.txtDestinatario.text = event.itemRenderer.data.destinatario;
			*/
			objModBitacoraMail.txtAsunto.text = event.itemRenderer.data.asunto;
			objModBitacoraMail.txtMensaje.text = event.itemRenderer.data.mensaje;
			
		}
	}
}
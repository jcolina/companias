package talleresCompania2010.Modulos.Factura.Classes
{
	import Notificacion.com.notifications.Notification;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	

	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.Factura.modFacturaInfo;
	
	public class FacturaInfo
	{
		private var objModFacturaInfo:modFacturaInfo;
		
		public function FacturaInfo(objModFacturaInfo:modFacturaInfo)
		{
			this.objModFacturaInfo = objModFacturaInfo;
		}
		
		public function guardarFacturas(cadena:String):void{
			var parametrosWS:Object = new Object();
			parametrosWS.IDUsuario = Application.application.ObjDatosLogin.IDUsuario;
			parametrosWS.Cadena = cadena;
			parametrosWS.Accion = this.objModFacturaInfo.ACCION_ADD;
			var ws:WebService = Application.application.getWS("Factura","OpNewFactura");	
			ws.OpNewFactura.resultFormat = "e4x";
			ws.OpNewFactura.send(
								parametrosWS.IDUsuario,
								parametrosWS.Cadena,
								parametrosWS.Accion
								);
		    ws.OpNewFactura.addEventListener(ResultEvent.RESULT, guardarFacturasResponse);
		    ws.OpNewFactura.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('factura_info_title_alert_guarda'));
		    });
		}
		
		private function guardarFacturasResponse(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null){
				if(listaDatosWS[0].Return == 1){
					Notification.show(IdiomaApp.getText('factura_info_fact_guardada'), IdiomaApp.getText('general_aviso_title'));
					//Application.application.objComFactura.mlFacturaOpciones.child.chkSeleccion.selected = false;
					//event:MouseEvent
					Application.application.mlFacturaOpciones.child.chkSeleccion.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					//onCheckedSeleccion
					//Application.application.ObjDatosFactura = null;
					Application.application.updateGrillaFactura();
				}
			}else{
				Alert.show(IdiomaApp.getText('factura_info_fact_problema_info'), IdiomaApp.getText('general_error'));
			}
		}

	}
}
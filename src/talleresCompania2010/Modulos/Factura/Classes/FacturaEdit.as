package talleresCompania2010.Modulos.Factura.Classes
{
	import Notificacion.com.notifications.Notification;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.Factura.modFacturaEdit;
	
	public class FacturaEdit
	{
		private var objModFacturaEdit:modFacturaEdit;
		
		public function FacturaEdit(objModFacturaEdit:modFacturaEdit)
		{
			this.objModFacturaEdit = objModFacturaEdit;
			this.solListaFacturas();
		}
		
		private function solListaFacturas():void{
			var parametrosWS:Object = new Object();
			parametrosWS.IDVehiculo = Application.application.ObjDatosFactura.IDVehiculo;
			var ws:WebService = Application.application.getWS("Factura","OpGrilFactura");	
			ws.OpGrilFactura.resultFormat = "e4x";
			ws.OpGrilFactura.send(parametrosWS.IDVehiculo);
		    ws.OpGrilFactura.addEventListener(ResultEvent.RESULT, cargarListaFactura);
		    ws.OpGrilFactura.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('factura_edit_alert_title_lista_grilla'));
		    });
		}
		
		private function cargarListaFactura(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			objModFacturaEdit.dtgFacturasEdit.dataProvider = listaDatosWS;
			if(listaDatosWS != null){
				this.objModFacturaEdit.cnvButon.visible = true;
				this.objModFacturaEdit.cnvEdit.visible = true;
				this.objModFacturaEdit.cnvGuardar.visible = true;
			}
		}
		
		public function editFacturas(cadena:String):void{
			var parametrosWS:Object = new Object();
			parametrosWS.IDUsuario = Application.application.ObjDatosLogin.IDUsuario;
			parametrosWS.Cadena = cadena;
			parametrosWS.Accion = this.objModFacturaEdit.ACCION_EDITAR;
			var ws:WebService = Application.application.getWS("Factura","OpNewFactura");	
			ws.OpNewFactura.resultFormat = "e4x";
			ws.OpNewFactura.send(
								parametrosWS.IDUsuario,
								parametrosWS.Cadena,
								parametrosWS.Accion
								);
		    ws.OpNewFactura.addEventListener(ResultEvent.RESULT, editFacturasResponse);
		    ws.OpNewFactura.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('factura_edit_alert_editar_fact'));
		    });
		}
		
		private function editFacturasResponse(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null){
				if(listaDatosWS[0].Return == 1){
					Notification.show(IdiomaApp.getText('factura_edit_alert_actualizada'), IdiomaApp.getText('general_aviso_title'));
					Application.application.updateGrillaFactura();
				}
			}else{
				Alert.show(IdiomaApp.getText('factura_edit_alert_problema_actua'), IdiomaApp.getText('general_error'));
			}
		}
	}
}
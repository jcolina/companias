package talleresCompania2010.Modulos.Factura.Classes
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.Factura.modFacturaInfo;
	import talleresCompania2010.Modulos.Factura.modFacturaPrincipal;
	
	public class Principal
	{
		private var objModPrincipal:modFacturaPrincipal;
		private var objDatosFactura:Object;
		
		public function Principal(objModPrincipal:modFacturaPrincipal)
		{
			this.objModPrincipal = objModPrincipal;
			this.solListaFacturas();
		}
		
		public function solListaFacturas():void{
			var parametrosWS:Object = new Object();
			var dtInicio:Object;
			var dtTermino:Object;
			
			this.objDatosFactura = Application.application.ObjDatosFactura;
			
			try{
				dtInicio = Application.application.mlFacturaOpciones.child.dtInicio;
				dtTermino = Application.application.mlFacturaOpciones.child.dtTermino;
			}catch(e:Error){
				//Ignorado				
			}			
			
			if(dtInicio == null || dtTermino == null){
				var hoy:Date = new Date();
				dtInicio = new Object();
				dtTermino = new Object();
				dtInicio.selectedDate = new Date(hoy.getFullYear(), hoy.getMonth());
				dtTermino.selectedDate = hoy;
			}
			
			parametrosWS.IDTaller = 0;
			parametrosWS.IDLocal = 0;
			parametrosWS.IDCia = Application.application.ObjDatosLogin.IDCompania;
			parametrosWS.Inicio = DateField.dateToString(dtInicio.selectedDate, "YYYY-MM-DD");
			parametrosWS.Termino = DateField.dateToString(dtTermino.selectedDate, "YYYY-MM-DD");
			var ws:WebService = Application.application.getWS("Factura","OpListFactura");	
			ws.OpListFactura.resultFormat = "e4x";
			ws.OpListFactura.send(parametrosWS.IDTaller,
								parametrosWS.IDLocal,
								parametrosWS.IDCia,
								parametrosWS.Inicio,
								parametrosWS.Termino);
		    ws.OpListFactura.addEventListener("result", cargarListaFactura);
		    ws.OpListFactura.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('principal_title_alert_lista'));
		    });
		}
		
		private function cargarListaFactura(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			objModPrincipal.adgFactura.dataProvider = listaDatosWS;
			
			//Posiciona en el item seleccionado
			if(this.objDatosFactura != null){
				var IDVehiculo:int = this.objDatosFactura.IDVehiculo;
				var index:int;
				for(var i:int = 0; i < listaDatosWS.length; i++){
					if(listaDatosWS[i].IDVehiculo == IDVehiculo){
						index = i;
					}
				}
				this.objModPrincipal.adgFactura.selectedIndex = index;
				this.objModPrincipal.adgFactura.scrollToIndex(index);
			}
		}
		
		public function cargarModuloFacturas(objItemClick:Object):void{
			Application.application.ObjDatosFactura = objItemClick;
			Application.application.crearModulo(Application.application.mlFacturaDerecho.child.mlFactura.child.mlFacturaEdit, modFacturaInfo.URL_FACTURA_EDIT);				
		}
	}
}
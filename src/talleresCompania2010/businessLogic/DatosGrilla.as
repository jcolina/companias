package talleresCompania2010.businessLogic
{
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modPrincipal;
	import talleresCompania2010.util.BrowserUtil;
	import talleresCompania2010.util.PosicionarCombo;
	import talleresCompania2010.util.IdiomaApp;
	
	public class DatosGrilla
	{
		private var ObjModPrincipal:modPrincipal
		private var listEstados:ArrayCollection;
	//	private var lastAsyncToken:AsyncToken;
		private var datosRed:ArrayCollection;
		private var datosYellow:ArrayCollection;
		private var datosBlue:ArrayCollection;
		private var datosGris:ArrayCollection;
		private var perdidaTotal:ArrayCollection;
		private var pendRepuesto:ArrayCollection;
		private var listaDatosGrilla:ArrayCollection;
		
		public function DatosGrilla(modPrincipalObj:modPrincipal)
		{
			this.ObjModPrincipal = modPrincipalObj;
			solTalleres();
			solListaEstados();
		}
		
		private function solListaEstados():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("ListaEstados","EstadoVehiculo");
			ws.EstadoVehiculo.resultFormat = "e4x";
			ws.EstadoVehiculo.send();
		    ws.EstadoVehiculo.addEventListener("result", cargaListaEstados);
		    ws.EstadoVehiculo.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_title_lista_estado'));
		    });
		}
		
		private function cargaListaEstados(event:ResultEvent):void{
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
    		if(listaDatosWS != null){
				var dataSortField:SortField = new SortField();
				dataSortField.name = "IDEstado";
				dataSortField.numeric = true;
				var ObjSort:Sort = new Sort();
				ObjSort.fields = [dataSortField];
				listEstados=listaDatosWS;
				listEstados.sort = ObjSort;
				listEstados.refresh();
			}else {listEstados = new ArrayCollection();
			}			
		}
		
		private function solTalleres():void{
			var parametrosWS:Object = new Object();
			parametrosWS.IDCompania = Application.application.idCompania;
			var ws:WebService = Application.application.getWS("ListaTalleres","OpListaTalleres");	
			ws.OpListaTalleres.resultFormat = "e4x";
			ws.OpListaTalleres.send(parametrosWS.IDCompania);
		    ws.OpListaTalleres.addEventListener("result", cargarTalleres);
		    ws.OpListaTalleres.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_title_lista_talleres'));
		    });
		}
		
		private function cargarTalleres(event:ResultEvent):void{
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
    		if(listaDatosWS != null){
				ObjModPrincipal.cbTaller.dataProvider = listaDatosWS;
				ObjModPrincipal.cbTaller.labelField = "NombreTaller";
				
				if(BrowserUtil.getTaller() != null){					
					posicionarTaller();
				}else{
					BrowserUtil.closeWaitMessage();
				}
    		}
		}
				
		private function posicionarTaller():void{
			BrowserUtil.showWaitMessage();
			if(PosicionarCombo.posicionarCombo(ObjModPrincipal.cbTaller, BrowserUtil.getTaller(), "NombreTaller")){
				ObjModPrincipal.cbTaller.dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}else{
				Alert.show(IdiomaApp.getText('datos_grilla_no_cargo_vehiculo'), IdiomaApp.getText('datos_grilla_posci'));	
				BrowserUtil.closeWaitMessage();
				BrowserUtil.setNullLocal();
				BrowserUtil.setNullPatente()
				BrowserUtil.setNullSiniestro();
			}
			BrowserUtil.setNullTaller();
		}
		
		
		public function solLocales():void{
			var parametrosWS:Object = new Object();		
			var ws:WebService = Application.application.getWS("ListadoLocales","OpListaLocales");
			parametrosWS.IDTaller = ObjModPrincipal.cbTaller.selectedItem.IDTaller;	
			ws.OpListaLocales.resultFormat = "e4x";
			ws.OpListaLocales.send(parametrosWS.IDTaller);
		    ws.OpListaLocales.addEventListener("result", cargarLocales);
		    ws.OpListaLocales.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_title_lista_locales'));
		    });
		}
		
		private function cargarLocales(event:ResultEvent):void{
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null){
				ObjModPrincipal.cbLocales.prompt = IdiomaApp.getText('general_prompt');
				ObjModPrincipal.cbLocales.dataProvider = listaDatosWS;
				ObjModPrincipal.cbLocales.labelField = "Direccion";
				
				if(BrowserUtil.getLocal() != null){					
					posicionarLocal();
				}else{
					BrowserUtil.closeWaitMessage();
				}
			}
		}
		
		private function posicionarLocal():void{
			if(PosicionarCombo.posicionarCombo(ObjModPrincipal.cbLocales, BrowserUtil.getLocal(), "Direccion")){
				ObjModPrincipal.cbLocales.dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}else{
				Alert.show(IdiomaApp.getText('datos_grilla_no_cargo_vehiculo_local'), IdiomaApp.getText('datos_grilla_posci_local'));	
				BrowserUtil.setNullPatente();
				BrowserUtil.setNullSiniestro();
				BrowserUtil.closeWaitMessage();
			}
			BrowserUtil.setNullLocal();
		}
		
		public function solGrillaCompania():void{
			if(ObjModPrincipal.cbTaller.selectedIndex != -1 && ObjModPrincipal.cbLocales.selectedIndex != -1){
				limpia();
				datosPersona();
				capacidadLocal();
				guardarCiaTaller();
				var parametrosWS:Object = new Object();	
				var ws:WebService = Application.application.getWS("ListadoVehiculos","GrillaTest");
				parametrosWS.IDLocal = this.getSelectedItemLocal();	
				parametrosWS.IDCompania	= Application.application.idCompania;			
				parametrosWS.IDTaller = "0";
				parametrosWS.Patente = "0";
				ws.GrillaTest.send(parametrosWS.IDTaller,
									parametrosWS.IDLocal,
									parametrosWS.IDCompania,
									parametrosWS.Patente);
				ws.GrillaTest.resultFormat = "e4x";
			    ws.GrillaTest.addEventListener(ResultEvent.RESULT, cargarGrilla);		
			    ws.GrillaTest.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
			    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_title_lista_talleres'));
			    });	
			}else{
				Alert.show(IdiomaApp.getText('datos_grilla_selec_taller_local'), IdiomaApp.getText('general_aviso_title'));
			}
		}
		
		public function solGrillaPatente():void{
			guardarCiaTaller();
			ObjModPrincipal.cbTaller.selectedIndex = -1;
			ObjModPrincipal.cbLocales.selectedIndex = -1;
			var parametrosWS:Object = new Object();	
			parametrosWS.IDCompania = Application.application.idCompania;			
 			parametrosWS.Patente = ObjModPrincipal.txPatente.text;	
			var ws:WebService = Application.application.getWS("ListadoVehiculos","GrillaTest");
			ws.GrillaTest.send(parametrosWS.IDTaller="0",
								parametrosWS.IDLocal = 0,
								parametrosWS.IDCompania,
								parametrosWS.Patente);
			ws.GrillaTest.resultFormat = "e4x";
		    ws.GrillaTest.addEventListener("result", cargarGrilla);		
		    ws.GrillaTest.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_title_alert_lista_patente'));
		    });
		}
	/* 	
		public function solGrillaPatenteCia():void{
			guardarCiaTaller();
			ObjModPrincipal.cbTaller.selectedIndex = -1;
			ObjModPrincipal.cbLocales.selectedIndex = -1;
			var parametrosWS:Object = new Object();	
			parametrosWS.IDCompania = Application.application.idCompania;
			parametrosWS.patente = ObjModPrincipal.txPatente.text;
			var ws:WebService = Application.application.getWS("PatenteCia");
			ws.OpBusPatCia.resultFormat = "e4x";
			ws.OpBusPatCia.send(parametrosWS.IDCompania,parametrosWS.Patente);
		    ws.OpBusPatCia.addEventListener("result", cargarGrilla);		
		    ws.OpBusPatCia.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show("Se produjo un error en la llamada al servicio", "Lista Por Patente");
		    });
		} */

		private function cargarGrilla(event:ResultEvent):void {	
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null) {
		/*	if(event.result is ObjectProxy) {Datos = new ArrayCollection([event.result]);}else{Datos = ArrayCollection(event.result);} */
				ObjModPrincipal.txSiniestro.enabled = true;
				var dataSortField:SortField = new SortField();
				dataSortField.name = "IDVehiculo";
				dataSortField.numeric = true;			
				var ObjSort:Sort = new Sort();
				ObjSort.fields = [dataSortField];
				listaDatosWS = formatoFecha(listaDatosWS);
				addDetails(listaDatosWS);				
				ObjSort.reverse();
				listaDatosWS.sort = ObjSort;
				listaDatosWS.refresh();				
				listaDatosGrilla = listaDatosWS;
				var ObjHData:HierarchicalData = new HierarchicalData(listaDatosWS);
				ObjModPrincipal.clmPatente.dataField = "Patente";
				ObjModPrincipal.clmPendRepu.dataField = "PendienteRepuesto";
				ObjModPrincipal.clmDocumento.dataField = "Documentos";	
				ObjModPrincipal.clmMarca.dataField = "Marca";
				ObjModPrincipal.clmModelo.dataField = "Modelo";
				ObjModPrincipal.clmSiniestro.dataField = "NumeroSiniestro";
				ObjModPrincipal.clmNomContacto.dataField = "IDAsegurado";
				ObjModPrincipal.clmFIngreso.dataField = "FechaIngreso";
				ObjModPrincipal.clmFEntrega.dataField = "FechaEntrega";
				ObjModPrincipal.clmEstado.dataField = "Descripcion";
				ObjModPrincipal.clmEtapa.dataField = "Etapa";
				/** modificado **/
				ObjModPrincipal.clmRecepcionista.dataField = "Recep";
			//	ObjModPrincipal.ADGRender.dataField = "detail";
				ObjModPrincipal.grillaPrincipal.dataProvider = null;
				ObjModPrincipal.grillaPrincipal.dataProvider = ObjHData;
				alertas(listaDatosWS);
				posicionarVehiculo();
				
			}else{
				ObjModPrincipal.txSiniestro.enabled = false;
				ObjModPrincipal.grillaPrincipal.dataProvider = null;
				Alert.show(IdiomaApp.getText('mod_filtro_prom_etapas_ini_alert'), IdiomaApp.getText('general_aviso_title'));
				ObjModPrincipal.lnkRed.label = "0 Veh.";
				ObjModPrincipal.lnkYellow.label = "0 Veh.";
				ObjModPrincipal.lnkBlue.label = "0 Veh.";
				ObjModPrincipal.lnkPerdidaTotal.label = "0 Veh.";
				ObjModPrincipal.lnkPendRepuesto.label = "0 Veh.";
				datosRed = null;
				datosYellow = null;
				datosBlue = null;
				datosGris = null;
				perdidaTotal = null;
				pendRepuesto = null;
				Application.application.unloadModsTareas();
				Application.application.descargarAllDocumentos();
			}			
		}
		
		private function posicionarVehiculo():void {
			if(BrowserUtil.getPatente() != null || BrowserUtil.getSiniestro() != null){
				for(var i:int = 0; i < listaDatosGrilla.length; i++){
					if(listaDatosGrilla[i].Patente == BrowserUtil.getPatente() && listaDatosGrilla[i].NumeroSiniestro == BrowserUtil.getSiniestro()){
						ObjModPrincipal.grillaPrincipal.selectedIndex = i;
						ObjModPrincipal.grillaPrincipal.validateNow();
						ObjModPrincipal.grillaPrincipal.scrollToIndex(i);						
						Application.application.mlDerecho.child.accDerechoMain.selectedIndex = 1;
						ObjModPrincipal.grillaPrincipal.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, true, false));
					}
				}
			}
			BrowserUtil.setNullPatente();
			BrowserUtil.setNullSiniestro();
			BrowserUtil.closeWaitMessage();
		}
		
		public function datosPersona():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("Persona","OPContactoTaller");
			parametrosWS.IDLocal = this.getSelectedItemLocal();	
			ws.OPContactoTaller.resultFormat = "e4x";
			ws.OPContactoTaller.send(parametrosWS.IDLocal);
		    ws.OPContactoTaller.addEventListener("result", cargaPersona);
		    ws.OPContactoTaller.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('datos_grilla_no_encontro_encargado'),IdiomaApp.getText('general_aviso_title'));
		    });
		}
				
		public function cargaPersona(event:ResultEvent):void {
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			var rnombre:String;
			var rapellido:String;
			var rfono:String;
			var rcelular:String;
			var remail:String;
			if(listaDatosWS != null){
				rnombre = listaDatosWS[0].nombre;
				rapellido = listaDatosWS[0].apellido;
				rfono = listaDatosWS[0].fono;
				rcelular = listaDatosWS[0].celular;
				remail = listaDatosWS[0].email;
			}
			if(rnombre == null)rnombre = "";
			if(rapellido == null)rapellido = "";
			if(rfono == null)rfono = "";
			if(rcelular == null)rcelular = "";
			if(remail == null)remail = "";
			Application.application.infolb.text = IdiomaApp.getText('datos_grilla_encargado_taller')+" "+rnombre+" "+rapellido
					+"  -  "+IdiomaApp.getText('general_telefono')+" : "+rfono+"  -  "+IdiomaApp.getText('mod_opciones_calular')+" : "+rcelular+"  -  "+IdiomaApp.getText('mod_opciones_email')+" : "+remail;
		}
		
		public function solListaFiltros(color:String):void {
			Application.application.unloadModsTareas();
			limpia();
			if(color.toUpperCase() == "ROJO")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(datosRed);
			else if(color.toUpperCase() == "AMARILLO")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(datosYellow);
			else if(color.toUpperCase() == "AZUL")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(datosBlue);
			else if(color.toUpperCase() == "GRIS")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(datosGris);
			else if(color.toUpperCase() == "PERDIDATOTAL")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(perdidaTotal);
			else if(color.toUpperCase() == "PENDREPUESTO")ObjModPrincipal.grillaPrincipal.dataProvider = new HierarchicalData(pendRepuesto); 
		}
		
		private function formatoFecha(Datos:ArrayCollection):ArrayCollection {
			var aux:Date;
			var datosAux:ArrayCollection = Datos;
			if(datosAux != null){
				for (var name:String in datosAux){
					if(datosAux[name].FechaIngreso != null){
						aux = DateField.stringToDate(datosAux[name].FechaIngreso, "DD-MM-YYYY");
						datosAux[name].FechaIngreso = cambiarDia(aux);
					}
					if(datosAux[name].FechaEntrega != null){
						aux = DateField.stringToDate(datosAux[name].FechaEntrega, "DD-MM-YYYY");
						datosAux[name].FechaEntrega = cambiarDia(aux);
					}
				}
			}
			return datosAux;
		}
		
		private function cambiarDia(fecha:Date):String {
			var str:String = ObjModPrincipal.formatDate.format(fecha);
			if(str.indexOf("Mon") != -1)return str.replace("Mon", "Lun");
			else if(str.indexOf("Tue") != -1)return str.replace("Tue", "Mar");
			else if(str.indexOf("Wed") != -1)return str.replace("Wed", "Mie");
			else if(str.indexOf("Thu") != -1)return str.replace("Thu", "Jue");
			else if(str.indexOf("Fri") != -1)return str.replace("Fri", "Vie");
			else if(str.indexOf("Sat") != -1)return str.replace("Sat", "Sab");
			else if(str.indexOf("Sun") != -1)return str.replace("Sun", "Dom");	
			return str;
		}
		
		private function addDetails(Datos:ArrayCollection):void{
			if(Datos != null) {				
				for(var name:String in Datos){
					var children:Array;
					var detail:ArrayCollection = new ArrayCollection();
					var myObj:Object = new Object();
					myObj.FechaIngreso = Datos[name].FechaIngreso;
					myObj.Estado = Datos[name].Descripcion;
					myObj.Patente = Datos[name].Patente;
					myObj.FechaEntrega = Datos[name].FechaEntrega;
					myObj.IDVeh = Datos[name].IDVehiculo;
					myObj.Pos = name;
					if(listEstados != null)myObj.ListaEstados = listEstados;
					detail.addItem(myObj);
					children = [{detail:detail}];
					Datos[name].children = children;
				}
			}
		}
		
		private function alertas(listVeh:ArrayCollection):void {
			if(listVeh != null){
				datosGris = new ArrayCollection();
				datosRed = new ArrayCollection();
				datosYellow = new ArrayCollection();
				datosBlue = new ArrayCollection();
				perdidaTotal = new ArrayCollection();
				perdidaTotal = new ArrayCollection();
				pendRepuesto = new ArrayCollection();
				for(var x:String in listVeh){
					if(String(listVeh[x].EstadosTareas).toUpperCase() == "ROJO")datosRed.addItem(listVeh[x]);
					else if(String(listVeh[x].EstadosTareas).toUpperCase() == "AMARILLO")datosYellow.addItem(listVeh[x]);
					else if(String(listVeh[x].EstadosTareas).toUpperCase() == "AZUL")datosBlue.addItem(listVeh[x]);	
					else if(String(listVeh[x].EstadosTareas).toUpperCase() == "GRIS")datosGris.addItem(listVeh[x]);
					if(String(listVeh[x].Descripcion).toUpperCase() == "PERDIDA TOTAL")perdidaTotal.addItem(listVeh[x]);					
					if(String(listVeh[x].PendienteRepuesto).toUpperCase() == "SI")pendRepuesto.addItem(listVeh[x]);
				}
				ObjModPrincipal.lnkPerdidaTotal.label = perdidaTotal.length + " Veh.";
				ObjModPrincipal.lnkRed.label = datosRed.length + " Veh.";
				ObjModPrincipal.lnkGray.label = datosGris.length + " Veh."
				ObjModPrincipal.lnkYellow.label = datosYellow.length + " Veh.";
				ObjModPrincipal.lnkBlue.label = datosBlue.length + " Veh.";
				ObjModPrincipal.lnkPendRepuesto.label = pendRepuesto.length + " Veh.";
			}
		}
		
		private function guardarCiaTaller():void{
			Application.application.taller = ObjModPrincipal.cbTaller.text;
			Application.application.local = ObjModPrincipal.cbLocales.text;
		}
		
		public function limpia():void {		
			Application.application.infolb.text = "";
			ObjModPrincipal.txPatente.text = "";
			ObjModPrincipal.txSiniestro.text = "";
		}
		
		public function updateItem(obj:Object):void{
			try{
				ObjModPrincipal.grillaPrincipal.dataProvider.itemUpdated(obj);
				//cargaDataProviderGrid();
			}catch(e:Error){
				Alert.show("DatosGrilla.as > reemplazarItemVeh(): "+e.message, e.name);
			}			
		}	

//---------------------------------------------------------servicio
				        		
		public function capacidadLocal():void{	
		
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("ListadoLocales","OpCapacidad");
			parametrosWS.Id_local =  this.getSelectedItemLocal();	
			parametrosWS.Capacidad ="-1";
			ws.OpCapacidad.resultFormat = "e4x"; 		
			ws.OpCapacidad.send(parametrosWS.Id_local, parametrosWS.Capacidad);				       
		    ws.OpCapacidad.addEventListener("result", CapacidadLocalResult); 
		    ws.OpCapacidad.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('datos_grilla_capacidad'));
		    });
		}
		
		private function CapacidadLocalResult(event:ResultEvent):void{
			try{
	    		var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);   
	        	if(listaDatosWS != null) {
					ObjModPrincipal.capacidadlb.text = IdiomaApp.getText('datos_grilla_capacidad_actual')+" " + listaDatosWS[0].Capacidad;
				}else {
	            	Alert.show(IdiomaApp.getText('datos_grilla_capacidad_error_obtener'));
	            }
	        }catch(err:Error){
	    		Alert.show(IdiomaApp.getText('datos_grilla_capacidad_error_servicio')+err.toString(),IdiomaApp.getText('datos_grilla_capacidad'));
	    	}	
		}
		
		public function solListaTareas():void {
			var ws:WebService = Application.application.getWS("ListaTareas", "ListaTareas");
			var parametrosWS:Object = new Object();
			ws.ListaTareas.resultFormat = "e4x";
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			ws.ListaTareas.send(parametrosWS.IDVehiculo);
			ws.ListaTareas.addEventListener("result", cargarListaTareas);
			ws.ListaTareas.addEventListener("fault", function(event:FaultEvent):void{
				Alert.show(IdiomaApp.getText('general_fallo_ws'),IdiomaApp.getText('datos_grilla_title_lista_tareas'));
			});
		}
		
		private function cargarListaTareas(event:ResultEvent):void {
			Application.application.listaTareas = Application.application.XMLToArray(event);
		}	
		
		private function getSelectedItemLocal():String {
			return ObjModPrincipal.cbLocales.selectedIndex == -1 ? "0" : ObjModPrincipal.cbLocales.selectedItem.IDLocal;
		}	
		
		private function getSelectedItemTaller():String {
			return ObjModPrincipal.cbTaller.selectedIndex == -1 ? "0" : ObjModPrincipal.cbTaller.selectedItem.IDTaller;
		}	
				
	}
}
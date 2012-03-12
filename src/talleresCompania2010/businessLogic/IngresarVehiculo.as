package talleresCompania2010.businessLogic
{
	/* import flash.events.MouseEvent;
	
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.validators.Validator;
	
	import talleresCompania2010.Modulos.modIngresarVeh;
	
	public class IngresarVehiculo
	{
		private var ObjModIngVeh:modIngresarVeh;
		private var _arrayValidators:Array;
		
		public function IngresarVehiculo(ObjModIngVeh:modIngresarVeh){
			this.ObjModIngVeh = ObjModIngVeh;
			solDatos();
		}
		
		public function set  arrayValidators(arrayValidators:Array):void {
			this._arrayValidators = arrayValidators;
		}
		
 		private function solDatos():void {
 			var ObjParams:Object;
			ObjModIngVeh.serviceLiquidadores.url = Application.application.getUrlService("Liquidadores");
			ObjModIngVeh.serviceLiquidadores.send();
			ObjModIngVeh.serviceLiquidadores.addEventListener(ResultEvent.RESULT, cargaComboLiquidadores, false, 0, true);
			ObjModIngVeh.serviceLocales.url = Application.application.getUrlService("Locales");
			ObjParams = new Object();
			ObjParams.IDTaller = Application.application.idTaller;
			ObjModIngVeh.serviceLocales.send(ObjParams);
			ObjModIngVeh.serviceLocales.addEventListener(ResultEvent.RESULT, cargarDatosLocal, false, 0, true);
			ObjModIngVeh.serviceRoles.url = Application.application.getUrlService("Roles");
			ObjModIngVeh.serviceRoles.send();
			ObjModIngVeh.serviceRoles.addEventListener(ResultEvent.RESULT, crearRoles, false, 0, true);
		} 
		
		public function saveVeh(event:MouseEvent):void {
			try {
				var errors:Array = Validator.validateAll(_arrayValidators);
				if(!errors.length == 0){
					var err:ValidationResultEvent;
					var errorMsg:Array = new Array();
					for each (err in errors) {
						errorMsg.push(Object(err.currentTarget.source).name +": " + err.message);
					}
					Alert.show(errorMsg.join("\n\n"), "Formulario Invalido...");
					return;
				}
				
				if(listaRoles() == null){
					Alert.show("Debe seleccionar al menos 1 Rol.", "Formulario Invalido...");
					return;
				}
				
				ObjModIngVeh.serviceIngresarVeh.url = Application.application.getUrlService("IngresarVehiculo");
				
				var ObjParams:Object = new Object();
				ObjParams.Rut = ObjModIngVeh.txRut.text;
				ObjParams.Nombre = ObjModIngVeh.txNombre.text;
				ObjParams.Apellido = ObjModIngVeh.txApellido.text;
				ObjParams.Celular = ObjModIngVeh.txCelular.text;
				ObjParams.Telefono = ObjModIngVeh.txFonoFijo.text;
				ObjParams.Email = ObjModIngVeh.txMail.text;
				ObjParams.ListaRoles = listaRoles();
				ObjParams.Patente = ObjModIngVeh.txPatente.text;
				ObjParams.Marca = ObjModIngVeh.txMarca.text;
				ObjParams.Modelo = ObjModIngVeh.txModelo.text;
				ObjModIngVeh.dtIngreso.text = ObjModIngVeh.dtIngreso.text;
				ObjParams.FechaIngreso = DateField.dateToString(ObjModIngVeh.dtIngreso.selectedDate, "YYYY-MM-DD");
				ObjParams.IDLocal = Application.application.idLocal;
				ObjParams.NumeroSiniestro = ObjModIngVeh.txNroSiniestro.text;
				ObjParams.IDCompania = 2;
				ObjParams.IDUsuario = Application.application.idUsuario;
				ObjParams.IDLiquidador = ObjModIngVeh.cbLiquidador.selectedItem.ID;
				
				ObjModIngVeh.serviceIngresarVeh.send(ObjParams);
				ObjModIngVeh.serviceIngresarVeh.addEventListener(ResultEvent.RESULT, successCallService,false,0,true);
				ObjModIngVeh.serviceIngresarVeh.addEventListener(FaultEvent.FAULT, errorIngresar,false,0,true);
			}catch (error:Error){
				trace(error.message);
				Alert.show("SE PRODUJO UN ERROR DURANTE LA EJECUCION", "ERROR");
			}
			
		}
		
		private function cargaComboLiquidadores(event:ResultEvent):void {
			if(event.result.Listado != null) {
				ObjModIngVeh.cbLiquidador.prompt = "(Seleccione...)";
				ObjModIngVeh.cbLiquidador.labelField = "nombre";
				ObjModIngVeh.cbLiquidador.dataProvider = event.result.Listado.Resultado;
			}			
		}
		
		private function cargarDatosLocal(event:ResultEvent):void {
			if(event.result.Listado != null) {
				ObjModIngVeh.txLocal.text = event.result.Listado.Resultado.NombreLocal;
				ObjModIngVeh.txDirLocal.text = event.result.Listado.Resultado.Direccion;
			}			
		}
		
		private function crearRoles(event:ResultEvent):void {
			if(event.result.Listado != null) {
				for(var x:String in event.result.Listado.Resultado) {
					var childGrid:Array = ObjModIngVeh.gridRoles.getChildren();
					if(childGrid.length > 0){
						var childRow:Array = GridRow(childGrid[(childGrid.length - 1)]).getChildren();
						if(childRow.length == 1){
							var ObjItem2:GridItem = new GridItem();
							ObjItem2.styleName = "Roles";
							var chkRol2:CheckBox = new CheckBox();
							chkRol2.label = event.result.Listado.Resultado[x].Descripcion;
							chkRol2.selectedField = event.result.Listado.Resultado[x].ID;
							GridItem(GridRow(childGrid[(childGrid.length - 1)]).addChild(ObjItem2)).addChild(chkRol2);
						}else{
							var ObjRow1:GridRow = new GridRow();
							ObjRow1.styleName = "Roles";
							var ObjItem1:GridItem = new GridItem();
							ObjItem1.styleName = "Roles";
							var chkRol1:CheckBox = new CheckBox();
							chkRol1.label = event.result.Listado.Resultado[x].Descripcion;
							chkRol1.selectedField = event.result.Listado.Resultado[x].ID;
							GridItem(GridRow(ObjModIngVeh.gridRoles.addChild(ObjRow1)).addChild(ObjItem1)).addChild(chkRol1);
						}
					}else{
						var ObjRow:GridRow = new GridRow();
						ObjRow.styleName = "Roles";
						var ObjItem:GridItem = new GridItem();
						ObjItem.styleName = "Roles";
						var chkRol:CheckBox = new CheckBox();
						chkRol.label = event.result.Listado.Resultado[x].Descripcion;
						chkRol.selectedField = event.result.Listado.Resultado[x].ID;
						GridItem(GridRow(ObjModIngVeh.gridRoles.addChild(ObjRow)).addChild(ObjItem)).addChild(chkRol);
					}
					
				}
			}
		}
		
		private function listaRoles():String {
			var lista:String;
			var childGrid:Array = ObjModIngVeh.gridRoles.getChildren();
			for(var x:String in childGrid){
				var childRow:Array = GridRow(childGrid[x]).getChildren();
				for(var y:String in childRow){
					var childItem:Array = GridItem(childRow[y]).getChildren();
					for(var z:String in childItem){
						if(childItem[z] is CheckBox){
							if(CheckBox(childItem[z]).selected){
								if(lista != null){
									lista = lista + "|" + CheckBox(childItem[z]).selectedField;
								}else
									lista = CheckBox(childItem[z]).selectedField;
							}
						}
					}
				}
			}
			return lista;
		}
		
		public function searchRut():void {
			ObjModIngVeh.serviceSearchRut.url = Application.application.getUrlService("SearchRut");
			var ObjParams:Object = new Object();
			ObjParams.IDPersona = ObjModIngVeh.txRut.text;
			ObjModIngVeh.serviceSearchRut.send(ObjParams);
			ObjModIngVeh.serviceSearchRut.addEventListener(ResultEvent.RESULT, cargarDatosContacto, false, 0, true);
			ObjModIngVeh.serviceSearchRut.addEventListener(FaultEvent.FAULT, errorCallService, false, 0, true);

		}
		
		private function cargarDatosContacto(event:ResultEvent):void {
			if(event.result.Listado != null) {
				ObjModIngVeh.txNombre.text = event.result.Listado.Resultado.Nombre;
				ObjModIngVeh.txApellido.text = event.result.Listado.Resultado.Apellido;
				ObjModIngVeh.txCelular.text = event.result.Listado.Resultado.Celular;
				ObjModIngVeh.txMail.text = event.result.Listado.Resultado.Email;
				ObjModIngVeh.txFonoFijo.text = event.result.Listado.Resultado.Telefono;
			}else{
				ObjModIngVeh.txNombre.text = "";
				ObjModIngVeh.txApellido.text = "";
				ObjModIngVeh.txCelular.text = "";
				ObjModIngVeh.txMail.text = "";
				ObjModIngVeh.txFonoFijo.text = "";
			}
			
			ObjModIngVeh.griDatosContacto.visible = true;
		}
		
		private function errorCallService(event:FaultEvent):void {
			trace(event.message);
			Alert.show("Se produjo un error en la llamada al servicio", "Aviso");
		}
		
		private function errorIngresar(event:FaultEvent):void {
			trace(event.message);
			Alert.show("Se produjo un error al tratar de ingresar el Vehiculo.", "Aviso");
		}
		
		private function successCallService(event:ResultEvent):void {
//			Alert.show("Actualización Exitosa", "Aviso");
			Application.application.updateGrillaPrincipal();
			ObjModIngVeh.closePopUp();
		}
		
	} */
}
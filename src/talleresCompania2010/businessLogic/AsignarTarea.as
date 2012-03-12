package talleresCompania2010.businessLogic
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import  mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modAsignarTarea;
	
	public class AsignarTarea
	{
		private var ObjModAsignarTarea:modAsignarTarea;
		private var listTareas:ArrayCollection;
		private var datosVehObj:Object;
		
		
		public function AsignarTarea(ObjModAsignarTarea:modAsignarTarea)
		{
			this.ObjModAsignarTarea = ObjModAsignarTarea;
			solListaTareas();	
			solResponsables();
			datosVehObj = Application.application.ObjVehiculo;
//			Alert.show(datosVehObj.Patente + " *** " + datosVehObj.IDVehiculo);
		}
		
		
		//-----------------------------------------------------------------------------------
		
		private function solListaTareas():void {
			parametrosWS = new Object();
			var ws:WebService = Application.application.getWS("ListaTareas","ListaTareas");
			ws.ListaTareas.resultFormat = "e4x";
			ws.ListaTareas.send();
		    ws.ListaTareas.addEventListener("result", crearChecks);
		    ws.ListaTareas.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('asignar_tareas_sol_tarea'));
		}

		private function crearChecks(event:ResultEvent):void {
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			var myCheckBox:CheckBox;
			var myComboBox:ComboBox;
			var myHRuleIzq:HRule;
			var rowGridDisplayObj:DisplayObject;
			
			if (listaDatosWS != null){
				ObjModAsignarTarea.serviceListaTareas.clearResult(false);
				for (var name:String in listaDatosWS){					
					myCheckBox = new CheckBox();
					myCheckBox.label = listaDatosWS[name].Nombre;
					myCheckBox.selectedField = listaDatosWS[name].ID;
					myCheckBox.name = "myCheckBox";
					myCheckBox.addEventListener(MouseEvent.CLICK, addCampos, false, 0, true);
					

					/* myHRuleIzq = new HRule();
					myHRuleIzq.percentWidth = 100;
					myHRuleIzq.styleName = "tareas"; */
					
					var myGridRow:GridRow;
					var myGridItem:GridItem;
					
					myGridRow = new GridRow();
					myGridRow.percentWidth = 100;
					rowGridDisplayObj = ObjModAsignarTarea.gridTareas.addChild(myGridRow);
					myGridItem  = new GridItem();
					rowGridDisplayObj = GridRow(rowGridDisplayObj).addChild(myGridItem);
					myGridItem = GridItem(rowGridDisplayObj);
					myGridItem.percentWidth = 100;
					myGridItem.addChild(myCheckBox);
					
/* 					modAsignarTareaObj.myVBoxIzq.addChild(myCheckBox);
					modAsignarTareaObj.myVBoxIzq.addChild(myComboBox);
					modAsignarTareaObj.myVBoxIzq.addChild(myHRuleIzq); */
					
					
				}
			}
		}
		//-------------------------------------------------------------------------------
		
		private function addCampos(event:MouseEvent):void {
/* 			var a:Array = modAsignarTareaObj.gridTareas.getChildren();
			for (var x:String in a){
				Alert.show(GridRow(a[x]).name);
			} */
			
			var myComboBox:ComboBox;
			var myTextInput:TextInput;
			var myLabel:Label;
			var DisplayObj:DisplayObject;
			
			var index:int = ObjModAsignarTarea.gridTareas.getChildIndex(DisplayObject(GridRow(GridItem(CheckBox(event.target).parent).parent)));
			
//			Alert.show(index.toString());
			
/* 			var myHRuleDer:HRule = new HRule();
			myHRuleDer.percentWidth = 100;
			myHRuleDer.styleName = "tareas"; */
			
			
			if(CheckBox(event.target).selected){
				myComboBox = new ComboBox();
				myComboBox.name = "myComboBox";
				
 				if (ObjModAsignarTarea.serviceResponsables.lastResult.Listar != null){
					myComboBox.dataProvider = ObjModAsignarTarea.serviceResponsables.lastResult.Listar.Responsables;
					myComboBox.labelField = "Descripcion";
				} 
				
				myTextInput = new TextInput();
				myTextInput.name = "myTextInput";
				myTextInput.width = 35;
				myTextInput.restrict = "0-9";
				
				
				myLabel = new Label();
				myLabel.text = IdiomaApp.getText('asignar_tareas_horas');
				myLabel.name = "myLabel";
				myLabel.styleName = "tareas";
				
//				Alert.show(GridRow(GridItem(CheckBox(event.target).parent).parent));
				
				DisplayObj = GridRow(GridItem(CheckBox(event.target).parent).parent).parent.getChildAt(index);
				
				var myGridItem1:GridItem = GridItem(GridRow(DisplayObj).addChild(new GridItem()));
				myGridItem1.percentWidth = 100;
				myGridItem1.addChild(myComboBox);

				var myGridItem2:GridItem = GridItem(GridRow(DisplayObj).addChild(new GridItem()));
				myGridItem2.percentWidth = 100;
				myGridItem2.addChild(myTextInput);
				myGridItem2.addChild(myLabel);
				
				
/* 			var aa:Array = GridItem(a).getChildren();
			for (var x:String in aa){
				Alert.show(aa[x].name);
			} */
							
			}else{
				DisplayObj = ObjModAsignarTarea.gridTareas.getChildAt(index);
				var myGridItemTemp:GridItem;
				GridRow(DisplayObj).removeChildAt(2);
				GridRow(DisplayObj).removeChildAt(1);
				
/* 				var childrenRow:Array = GridRow(DisplayObj).getChildren();
				for (var x:String in childrenRow){
					var childrenItem:Array = GridItem(childrenRow[x]).getChildren();
					Alert.show(GridRow(DisplayObj).getChildIndex(childrenRow[x]).toString());
					if(childrenRow[x].name == "myLabel" || childrenRow[x].name == "myComboBox" || childrenRow[x].name == "myInputText") {
						GridRow(DisplayObj).removeChild(childrenRow[x]);
					}
				} */

			}
/* 			for (var name:String in listTareas){
				var check:CheckBox = new CheckBox();
				if(modAsignarTareaObj.myVBoxIzq.getChildAt(int(name)).isPrototypeOf(CheckBox)){
					check = CheckBox(modAsignarTareaObj.myVBoxIzq.getChildAt(int(name)));
					if(check.selected){
						myComboBox = new ComboBox();
						modAsignarTareaObj.myVBoxIzq.addChildAt(myComboBox,int(name));
					}
				}
			} */
		}
		
/* 		private function solResponsables():void {
			ObjModAsignarTarea.serviceResponsables.url = Application.application.getUrlService("Responsables");
			ObjModAsignarTarea.serviceResponsables.send();
			ObjModAsignarTarea.serviceResponsables.addEventListener(FaultEvent.FAULT, errorCallService, false, 0, true);
		}
		
		public function updateTareas():void {
			ObjModAsignarTarea.serviceUpdateTareas.url = Application.application.getUrlService("UpdateTareas");
			var childrenGrid:Array = ObjModAsignarTarea.gridTareas.getChildren();
			var ObjParams:Object = new Object();
			var strTareas:String;
			
			for (var x:String in childrenGrid) {
				var childrenRow:Array = GridRow(childrenGrid[x]).getChildren();
				for (var y:String in childrenRow) {
					var childrenItem:Array = GridItem(childrenRow[y]).getChildren();
					for (var z:String in childrenItem) {
						if(childrenItem[z].className == "CheckBox"){
							if(CheckBox(childrenItem[z]).selected){
								var Row:GridRow = GridRow(GridItem(CheckBox(childrenItem[z]).parent).parent);
								
								if(TextInput(GridItem(Row.getChildAt(2)).getChildByName("myTextInput")).text == ""){
									TextInput(GridItem(Row.getChildAt(2)).getChildByName("myTextInput")).text = "0";
								}
									
								if(ObjParams.Patente == null){
									ObjParams.Patente = datosVehObj.Patente;
								}
								if(ObjParams.ListaTareas == null){
									ObjParams.ListaTareas = CheckBox(childrenItem[z]).selectedField + "#" + 
										ComboBox(GridItem(Row.getChildAt(1)).getChildByName("myComboBox")).selectedItem.IDPerfilAcceso +
										"#" + TextInput(GridItem(Row.getChildAt(2)).getChildByName("myTextInput")).text;
								}else {
									ObjParams.ListaTareas = ObjParams.ListaTareas + "|"  + CheckBox(childrenItem[z]).selectedField + "#" + 
										ComboBox(GridItem(Row.getChildAt(1)).getChildByName("myComboBox")).selectedItem.IDPerfilAcceso +
										"#" + TextInput(GridItem(Row.getChildAt(2)).getChildByName("myTextInput")).text;
								}
								
/* 								ObjModAsignarTarea.serviceUpdateTareas.request.TipoTareaIDTipoTarea = CheckBox(childrenItem[z]).selectedField;
								ObjModAsignarTarea.serviceUpdateTareas.request.Responsable = ComboBox(GridItem(Row.getChildAt(1)).getChildByName("myComboBox")).text;
								ObjModAsignarTarea.serviceUpdateTareas.request.duracion = TextInput(GridItem(Row.getChildAt(2)).getChildByName("myTextInput")).text;
								ObjModAsignarTarea.serviceUpdateTareas.request.VehiculoIDVehiculo = datosVehObj.IDVehiculo; */
							}
						}
						
					}
				}
			}
			if(ObjParams.ListaTareas != null){
				
				ObjParams.IDUsuario = Application.application.idUsuario;
				ObjParams.Imei = "imei";
				ObjParams.Comentario = "Asignacion de tareas por flex.";
				
				ObjModAsignarTarea.serviceUpdateTareas.send(ObjParams);
 				ObjModAsignarTarea.serviceUpdateTareas.addEventListener(ResultEvent.RESULT, successCallService,false,0,true);
				ObjModAsignarTarea.serviceUpdateTareas.addEventListener(FaultEvent.FAULT, errorCallService,false,0,true);  
			}else
				Alert.show(IdiomaApp.getText('asignar_tareas_debe'), IdiomaApp.getText('general_aviso_title'));

		}
		
		private function errorCallService(event:FaultEvent):void {
			trace(event.message);
			Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('general_aviso_title'));
		}
		
		private function successCallService(event:ResultEvent):void {
			Application.application.updateModListTask();
			Application.application.updateModBitacora();
			Alert.show(IdiomaApp.getText('asignar_tareas_creada'), IdiomaApp.getText('general_aviso_title'));
		} */
		
		

	}
}
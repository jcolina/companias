package talleresCompania2010.businessLogic
{
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import  mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.modListaTareas;
	
	public class ListaTareas
	{
		private var ObjModListaT:modListaTareas;
		private var ObjGridTareas:Grid;
		
		public function ListaTareas(ObjModListaT:modListaTareas)
		{
			this.ObjModListaT = ObjModListaT;
			solListaTareas();
		}
		
		private function crearHeaderGrid():void {
			ObjGridTareas = new Grid();
			ObjGridTareas.percentWidth = 95;
			ObjGridTareas.percentHeight = 95;
			ObjGridTareas.setStyle("top", 0);
			ObjGridTareas.name = "gridLista";
			
			var ObjLabel:Label = new Label();
			ObjLabel.text = " *";
			ObjLabel.styleName = "tareas";
			
			var ObjGridItem:GridItem = new GridItem();
			ObjGridItem.percentWidth = 100;
			ObjGridItem.setStyle("horizontalAlign", "center");
			
			
			var ObjGridRow:GridRow = new GridRow();
			ObjGridRow.percentWidth = 100;
			
			ObjGridRow = GridRow(ObjGridTareas.addChild(ObjGridRow));
			
			GridItem(ObjGridRow.addChild(ObjGridItem)).addChild(ObjLabel);
			
			ObjLabel = new Label();
			ObjLabel.text = IdiomaApp.getText('general_descripcion');
			ObjLabel.styleName = "tareas";
			
			ObjGridItem = new GridItem();
			ObjGridItem.percentWidth = 100;
			
			GridItem(ObjGridRow.addChild(ObjGridItem)).addChild(ObjLabel);
			
			ObjLabel = new Label();
			ObjLabel.text = IdiomaApp.getText('general_dia');
			ObjLabel.styleName = "tareas";
			
			ObjGridItem = new GridItem();
			ObjGridItem.percentWidth = 100;
			
			GridItem(ObjGridRow.addChild(ObjGridItem)).addChild(ObjLabel);
			
			ObjLabel = new Label();
			ObjLabel.text = IdiomaApp.getText('mod_solicitudes_responsable');
			ObjLabel.styleName = "tareas";
			
			ObjGridItem = new GridItem();
			ObjGridItem.percentWidth = 100;
			
			GridItem(ObjGridRow.addChild(ObjGridItem)).addChild(ObjLabel);
			
			ObjModListaT.cvGrid.addChild(ObjGridTareas);		
		}
		
		private function crearDatosGrilla(listaDatosWS:ArrayCollection):void {
				if(listaDatosWS != null) {
				var childrenGrid:Array;
				var ObjCheckBox:CheckBox;
				
				for (var x:String in listaDatosWS) {
					var ObjRow:GridRow = new GridRow();
					ObjRow.percentWidth = 100;
					
					var ObjItem:GridItem = new GridItem();
					ObjItem.percentWidth = 100;
					
					var ObjText:Text;
					
					ObjRow = GridRow(ObjGridTareas.addChild(ObjRow));
					ObjItem.setStyle("horizontalAlign", "center");
					ObjItem = GridItem(ObjRow.addChild(ObjItem));
					
					if(int(listaDatosWS[x].Finalizada) == 1){
						ObjCheckBox = new CheckBox();
						ObjCheckBox.selected = true;
						ObjCheckBox.selectedField = listaDatosWS[x].IDTarea;
						ObjCheckBox.enabled = false;
						ObjItem.addChild(ObjCheckBox)
					}else {
						ObjCheckBox = new CheckBox();
						ObjCheckBox.selectedField = listaDatosWS[x].IDTarea;
						ObjCheckBox.enabled = false;
						ObjItem.addChild(ObjCheckBox)
					}
					
					ObjItem = new GridItem();
					ObjItem.percentWidth = 100;
					
					ObjItem = GridItem(ObjRow.addChild(ObjItem));
					ObjText = new Text();
					ObjText.text = listaDatosWS[x].Descripcion;
					ObjItem.addChild(ObjText);
					
					ObjItem = new GridItem();
					ObjItem.percentWidth = 100;
					
					ObjItem = GridItem(ObjRow.addChild(ObjItem));
					ObjText = new Text();
					ObjText.text = listaDatosWS[x].Duracion;
					ObjItem.addChild(ObjText);
					
					ObjItem = new GridItem();
					ObjItem.percentWidth = 100;
					
					ObjItem = GridItem(ObjRow.addChild(ObjItem));
					ObjText = new Text();
					ObjText.text = listaDatosWS[x].Responsable;
					ObjItem.addChild(ObjText);
					
				}
					
			}else {
				var ObjRow2:GridRow = new GridRow();
				ObjRow2.percentWidth = 100;
				
				var ObjItem2:GridItem = new GridItem();
				ObjItem2.percentWidth = 100;
				ObjItem2.colSpan = 4;
				ObjItem2.setStyle("horizontalAlign", "center");
				
				
				ObjItem2 = GridItem(GridRow(ObjGridTareas.addChild(ObjRow2)).addChild(ObjItem2));
				
				var ObjText2:Text = new Text();
				ObjText2.text = IdiomaApp.getText('lista_tareas_no_etapas');
				
				ObjItem2.addChild(ObjText2);
			}
			
		}
		//---------------------------------------------------------------------------------------
		public function solListaTareas():void {
			var parametrosWS:Object = new Object();
			var ws:WebService = Application.application.getWS("ListadoTareas","ListadosdeTareas");
			ws.ListadosdeTareas.resultFormat = "e4x"; 
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			ws.ListadosdeTareas.send(parametrosWS.IDVehiculo);
			ws.ListadosdeTareas.addEventListener("result", crearGrilla);
			ws.ListadosdeTareas.addEventListener("fault", function(event:FaultEvent):void{
				Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('lista_tareas_alert_title_listado'));
			});
		}
		
		private function crearGrilla(event:ResultEvent):void {
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			ObjModListaT.cvGrid.removeAllChildren();
			crearHeaderGrid();
			crearDatosGrilla(listaDatosWS);
			ObjModListaT.serviceListaTareas.removeEventListener(ResultEvent.RESULT, crearGrilla);
		}
		//-----------------------------------------------------------------
		private function errorCallService(event:FaultEvent):void {
			trace(event.message);
			Alert.show(IdiomaApp.getText('general_fallo_ws'));
			ObjModListaT.serviceListaTareas.removeEventListener(FaultEvent.FAULT, errorCallService);
		}

	}
}
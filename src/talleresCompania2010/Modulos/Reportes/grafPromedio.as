package talleresCompania2010.Modulos.Reportes{
	import excel.ExcelExport;
	
	import flash.display.DisplayObject;
	
	import mx.charts.events.ChartItemEvent;
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.Reportes.Componentes.comGraficoProm;
	
	
	public class grafPromedio{
		
		public var objGraficoProm:modRepPromedio;
		private var _objParamGraProm:Object = new Object();
		
		public function grafPromedio(_objGrafProm:modRepPromedio){
			objGraficoProm = _objGrafProm;
			this.loadServicio();
		}
			
		private function GraficoPromTaller(event:ChartItemEvent):void{
			objParamGraProm = event.hitData.item;
			var graficoDetalleProm:comGraficoProm = new comGraficoProm();
			graficoDetalleProm.ObjParamGraficoProm = objParamGraProm;
			createPopUpManager(graficoDetalleProm, objParamGraProm.D); 					
		}
		
		public function set objParamGraProm(_objParam:Object):void{
			_objParamGraProm = _objParam;
		}
		
		public function get objParamGraProm():Object{
			return _objParamGraProm; 
		} 
		
		private function loadServicio():void{
			var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
			var ws:WebService = Application.application.getWS("RepVeh","OpTpPro");
			ws.OpTpPro.resultFormat = "e4x";
			ws.OpTpPro.send(parametrosWS.IDTipoTarea,
							parametrosWS.Marca,
							parametrosWS.IDCompania,
							parametrosWS.IDZona,
							parametrosWS.IDTaller,
							parametrosWS.IDLocal);
		    ws.OpTpPro.addEventListener("result", cargaDataProvider);
		    ws.OpTpPro.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('graf_promedio_error_alert_carga'), IdiomaApp.getText('graf_promedio_error_alert_carga_title'));
		    });
		}
			
		private function cargaDataProvider(event:ResultEvent):void{			
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			var arregloLeyenda:ArrayCollection = new ArrayCollection();
			
			if(listaDatosWS != null){
				objGraficoProm.linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "H");
			    objGraficoProm.myChart.dataProvider = listaDatosWS;
			    eventoClick();
			    /*
			    if(listaDatosWS.length == 1)
					objGraficoProm.linearAxis.maximum = getColumMayor(listaDatosWS);
					
			    objGraficoProm.myChartProm.width = objGraficoProm.cnvContenedor.width - 10;
			    */
			}			
		}
		
		private function eventoClick():void{
			objGraficoProm.myChart.addEventListener(ChartItemEvent.ITEM_CLICK, GraficoPromTaller);
		}
				
		public function createPopUpManager(Obj:Object, titulo:String):void {
			var myObj:TitleWindow = TitleWindow(Obj);
			myObj.title = titulo;
			PopUpManager.addPopUp(myObj, DisplayObject(objGraficoProm.parentApplication), true);
			PopUpManager.centerPopUp(myObj);
		}
		
		public function graficoExcel():void{
			if(objGraficoProm.myChart.dataProvider != null){
				var date:String = Application.application.getSerialFecha();
				ExcelExport.export(objGraficoProm.myChart.dataProvider, IdiomaApp.getText('graf_promedio_promedio_etapa') + " " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_etapa'), value:"D"}, {header:IdiomaApp.getText('general_hora_promedio'), value:"H"}]});
			}else{
				Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
			}
		}
	}
}
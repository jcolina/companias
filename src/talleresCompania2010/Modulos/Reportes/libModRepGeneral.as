// ActionScript file
import excel.ExcelExport;

import mx.charts.events.ChartItemEvent;
import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.Modulos.Reportes.Componentes.comGraficoDetalle;
import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;


public var paramGraGeneral:Object= new Object();

private function initMod():void {
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;	
	var ws:WebService = Application.application.getWS("RepVeh","OpGrafPorcentaje");	
	ws.OpGrafPorcentaje.resultFormat = "e4x";
	ws.OpGrafPorcentaje.send(parametrosWS.IDTipoTarea,
							parametrosWS.Marca,
							parametrosWS.IDCompania,
							parametrosWS.IDZona,	
							parametrosWS.IDTaller,
							parametrosWS.IDLocal);
    ws.OpGrafPorcentaje.addEventListener("result", datosGrafico);
    ws.OpGrafPorcentaje.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_rep_general_title_alert_rep'));
    });
}

private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);	
	if(listaDatosWS != null){
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "Procesados");
		myChart.dataProvider = listaDatosWS;
		total.text = getTotalGrafGeneral(listaDatosWS);
		//linearAxis.maximum = getColumMayor(listaDatosWS) + 20;
		//if(listaDatosWS.length == 1)
			
		//myChart.width = cnvContenedor.width - 10;
	}
}

private function getTotalGrafGeneral(datos:ArrayCollection):String{
 	var total:int = 0;
	for(var i:int = 0; i < datos.length; i++){
		total = total + datos[i].Procesados;
	}
	return total.toString();
}

private function showDetalle(e:ChartItemEvent):void {
	try{
		paramGraGeneral = e.hitData.item;
		var comGraDetalle:comGraficoDetalle = new comGraficoDetalle();	
		var myObj:TitleWindow = TitleWindow(comGraDetalle);
		myObj.title = paramGraGeneral.NombreTaller;
		PopUpManager.addPopUp(myObj, DisplayObject(this.parentApplication), true);
		PopUpManager.centerPopUp(myObj);
	}catch(e:Error){
		Alert.show(IdiomaApp.getText('mod_rep_general_alert_abrir'));
	}
}

// Hack to prevent propagation of the ChartItemEvent.CHANGE as it is in conflict with IndexChangedEvent.CHANGE
private function canvasInit(): void{
	this.addEventListener(ChartItemEvent.CHANGE, chartItemEventChange, true, 0, true);
}

private function chartItemEventChange(event: Event): void{
	event.stopImmediatePropagation();
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('mod_rep_general_etapas')+" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_etapa'), value:"NombreTaller"}, {header:IdiomaApp.getText('mod_rep_general_cant_vehi'), value:"Procesados"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('mod_rep_general_etapas')+" " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}
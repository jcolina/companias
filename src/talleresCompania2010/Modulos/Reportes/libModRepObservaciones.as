// ActionScript file
import excel.ExcelExport;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;



public var paramGraGeneral:Object = new Object();

private function initMod():void {
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
	var ws:WebService = Application.application.getWS("RepVeh","OpGraficoEstadosVehiculos");
	ws.OpGraficoEstadosVehiculos.resultFormat = "e4x";
	ws.OpGraficoEstadosVehiculos.send(parametrosWS.IDCia,
									  parametrosWS.IDTaller,
									  parametrosWS.IDLocal,
									  parametrosWS.Marca,
									  parametrosWS.IDZon	
	);
    ws.OpGraficoEstadosVehiculos.addEventListener("result", datosGrafico);
    ws.OpGraficoEstadosVehiculos.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'),IdiomaApp.getText('mod_rep_observaciones_title_alert_error'));
    });
}

private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	if(listaDatosWS != null){
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "Total_Observacion");
		myChart.dataProvider = listaDatosWS;
		/*
		if(listaDatosWS.length == 1)
			
		myChart.width = cnvContenedor.width - 10;
		*/
	    lbTotal.text = IdiomaApp.getText('mod_rep_observaciones_total_vehiculos')+ " " + listaDatosWS[0].Tot_General;
	}
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('general_observaciones')+" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_observacion'), value:"Observacion"}, {header:IdiomaApp.getText('general_observacion_total'), value:"Total_Observacion"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'),IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('general_observaciones') +" "+ date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}
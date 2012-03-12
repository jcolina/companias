// ActionScript file
import excel.ExcelExport;

import mx.charts.HitData;
import mx.charts.series.BarSeries;
import mx.charts.series.items.BarSeriesItem;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;

private function initMod():void{
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
	var ws:WebService = Application.application.getWS("Reporte","OpCambiosFechas");
	ws.OpCambiosFechas.resultFormat = "e4x";
	
	ws.OpCambiosFechas.send(parametrosWS.IDCia,
								parametrosWS.Inicio,
								parametrosWS.Termino,
								parametrosWS.IDLocal,
								parametrosWS.IDTaller);
    ws.OpCambiosFechas.addEventListener(ResultEvent.RESULT, datosGrafico);
    ws.OpCambiosFechas.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_rep_cambio_fecha_title_alert_cambio'));
    });
}

private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		if(listaDatosWS.length > 3){
			myChart.height = listaDatosWS.length * 135;	
		}
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "Total");
		myChart.dataProvider = listaDatosWS;		
	}
}

 
private function chartDataTipFunction(hitData:HitData):String {
	var info:String = ""; 
	try{
		var item:BarSeriesItem = BarSeriesItem(hitData.chartItem);    
	    var series:BarSeries = BarSeries(hitData.element);   	
	
	    info = "<b>" + series.displayName + "</b>\n\n" + 
				IdiomaApp.getText('mod_rep_cambio_fecha_sobre') + " " +"<b>" + item.item.Muestra + "</b>"+ " "+IdiomaApp.getText('mod_rep_cambio_fecha_produjo')+" "+"<b>" + item.item.Total + "</b>"+ IdiomaApp.getText('mod_rep_cambio_fecha_cambio')+" "+"<b>" + item.item.Dato + "</b>\n" 
	    ; 
	} catch(e:Error){
		//Ignorada, cuando muestra el efecto del grafico tira un error
	}
	
	return  info;
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('mod_rep_cambio_fecha_cambio_tot_fecha') +"  " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_grid_taller'), value:"Dato"}, {header:IdiomaApp.getText('mod_rep_cambio_fecha_cambio_tot_fecha'), value:"Total"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('mod_rep_cambio_fecha_cambio_tot_fecha')+ " " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

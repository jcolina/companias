// ActionScript file
import excel.ExcelExport;

import mx.charts.HitData;
import mx.charts.events.ChartItemEvent;
import mx.charts.series.BarSeries;
import mx.charts.series.items.BarSeriesItem;
import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.IdiomaApp;
import talleresCompania2010.Modulos.Reportes.Componentes.comGraficoNotificaciones;
import talleresCompania2010.util.ImageChartExport;

public var paramGraGeneral:Object= new Object();

private function initMod():void{
	this.canvasInit();
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;	
	var ws:WebService = Application.application.getWS("Reporte","OpPromNotificaciones");
	ws.OpPromNotificaciones.resultFormat = "e4x";
	ws.OpPromNotificaciones.send(parametrosWS.IDCia,
								parametrosWS.FecInicio,
								parametrosWS.FecTer,
								parametrosWS.IDTaller,
								parametrosWS.IDLocal);
    ws.OpPromNotificaciones.addEventListener("result", datosGrafico);
    ws.OpPromNotificaciones.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('lib_mod_rep_prom_not_alert_title_grefico'));
    });
}

private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		if(listaDatosWS.length > 3){
			myChart.height = listaDatosWS.length * 135;	
		}
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "Promedio");
		myChart.dataProvider = listaDatosWS;	
	}	
}

private function showDetalle(e:ChartItemEvent):void {
	try{
		paramGraGeneral = e.hitData.item;
		var comGraNotificaciones:comGraficoNotificaciones = new comGraficoNotificaciones();	
		var myObj:TitleWindow = TitleWindow(comGraNotificaciones);
		myObj.title = paramGraGeneral.Nombre;
		PopUpManager.addPopUp(myObj, DisplayObject(this.parentApplication), true);
		PopUpManager.centerPopUp(myObj);
	}catch(e:Error){
		Alert.show(IdiomaApp.getText('lib_mod_rep_prom_not_alert_error'));
	}
}

// Hack to prevent propagation of the ChartItemEvent.CHANGE as it is in conflict with IndexChangedEvent.CHANGE
private function canvasInit(): void{
	this.addEventListener(ChartItemEvent.CHANGE, chartItemEventChange, true, 0, true);
}

private function chartItemEventChange(event: Event): void{
	event.stopImmediatePropagation();
}

private function chartDataTipFunction(hitData:HitData):String {
	 var info:String = ""; 
	try{
		var item:BarSeriesItem = BarSeriesItem(hitData.chartItem);    
	    var series:BarSeries = BarSeries(hitData.element);   	
	
	    info = "<b>" + series.displayName + "</b>\n" + 
				"<b>" + IdiomaApp.getText('lib_mod_rep_prom_not_taller') + " " + "</b>" + item.yValue + "\n" +
				"<b>" + IdiomaApp.getText('lib_mod_rep_prom_not_promedio') + " " + "</b>" + item.xValue + "\n" + 
				"<b>" + IdiomaApp.getText('lib_mod_rep_prom_not_tot_vehi') + " " + "</b>" + item.item.TotalVh + "\n" +
				"<b>" + IdiomaApp.getText('lib_mod_rep_prom_not_tot_mail') + " " + "</b>" + item.item.TotalEmail + "\n"
	    ; 
	} catch(e:Error){
		//Ignorada, cuando muestra el efecto del grafico tira un error
	}
    
    return  info;
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('lib_mod_rep_prom_not_prom_noti') +" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_grid_taller'), value:"Nombre"}, {header:IdiomaApp.getText('general_grid_taller_rut'), value:"id"}, {header:IdiomaApp.getText('general_grid_prom_noti'), value:"Promedio"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('general_grid_prom_noti') + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'),IdiomaApp.getText('general_aviso_title'));
	}
}

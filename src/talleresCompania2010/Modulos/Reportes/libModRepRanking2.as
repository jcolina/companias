// ActionScript file
import excel.ExcelExport;

import mx.charts.HitData;
import mx.charts.series.BarSeries;
import mx.charts.series.items.BarSeriesItem;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.graphics.SolidColor;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.IdiomaApp;
import talleresCompania2010.util.ImageChartExport;

private const RED_COLOR:String = "16711680";
private const LIGHT_GREY_COLOR:String = "12106684";

private function initMod():void{
	this.barCia.displayName += " " + Application.application.ObjDatosLogin.nombreTaller;
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
	var ws:WebService = Application.application.getWS("Reporte","OpRankingTalleresV2");
	ws.OpRankingTalleresV2.resultFormat = "e4x";
	
	ws.OpRankingTalleresV2.send(parametrosWS.IDCia,
								parametrosWS.FecInicio,
								parametrosWS.FecTer);
    ws.OpRankingTalleresV2.addEventListener(ResultEvent.RESULT, datosGrafico);
    ws.OpRankingTalleresV2.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('lib_mod_rep_ranking2_tit_alert'));
    });
}

/*
 * var listaDatosWS:ArrayCollection = new ArrayCollection();	
	var obj:Object = new Object();
	
	for(var i:int = 0; i < 70; i++){
		obj = new Object();
		obj.Total = i + 2;
		obj.Dato = "Taller " + i;
		listaDatosWS.addItem(obj);
	}
	*/

private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		if(listaDatosWS.length > 3){
			myChart.height = listaDatosWS.length * 135;
		}
		linearAxis.maximum = getColumMayor(listaDatosWS);
		myChart.dataProvider = listaDatosWS;
	}
}

private function getColumMayor(datos:ArrayCollection):int{
	var mayor:int = 0; 
	for each(var i:Object in datos){
		if (mayor < i.TiempoCia){
			mayor = i.TiempoCia;
		}
		if (mayor < i.TiempoOtraCia){
			mayor = i.TiempoOtraCia;
		}
	}
	
	if(mayor < 10){
		mayor = mayor + 2;
	}else{	
		if(mayor < 20){
			mayor = mayor + 5;
		}else{
			if(mayor < 100){
				mayor = mayor + 10;
			}else{
				mayor = mayor + 20;
			}
		}
	}
	return mayor;
}

private function chartDataTipFunction(hitData:HitData):String {
	 var info:String = ""; 
	try{
		var item:BarSeriesItem = BarSeriesItem(hitData.chartItem);    
	    var series:BarSeries = BarSeries(hitData.element);
	   	var total:String = "";
	   	
	   	switch (SolidColor(item.fill).color.toString()){
	   		case RED_COLOR:
	   			total += item.item.TotVhCia;
	   		break;
	   		case LIGHT_GREY_COLOR:
	   			total += item.item.TotVhOtraCia;
	   		break;
	   	}
	
	    info = "<b>" + series.displayName + "</b>\n" + 
	    					"<b>" + IdiomaApp.getText('lib_mod_rep_ranking2_local') + " " + "</b>" + item.yValue.replace("\n", " - ").replace("\r", "") + "\n" +
	    					"<b>" + IdiomaApp.getText('lib_mod_rep_ranking2_promedio') + " " + "</b>" + item.xValue + "\n" + 
	    					"<b>" + IdiomaApp.getText('lib_mod_rep_ranking2_mje_cantidad') + " "+ "</b>" + total + "\n"
	    ; 
	} catch(e:Error){
		//Ignorada, cuando muestra el efecto del grafico tira un error
	}
    
    return  info;
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('lib_mod_rep_ranking2_ranking') + " " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_locales'), value:"Detalle"}, {header:barCia.displayName, value:"TiempoCia"}, {header:IdiomaApp.getText('lib_mod_rep_ranking2_promedio_cia'), value:"TiempoOtraCia"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('lib_mod_rep_ranking2_ranking') + " " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

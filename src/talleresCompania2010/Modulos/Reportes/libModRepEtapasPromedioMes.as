// ActionScript file
import excel.ExcelExport;

import mx.charts.HitData;
import mx.charts.series.ColumnSeries;
import mx.charts.series.items.ColumnSeriesItem;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;

private const RED_COLOR:String = "16711680";
private const BLUE_COLOR:String = "255";
private const DARK_GREY_COLOR:String = "9474707";
private const LIGHT_GREY_COLOR:String = "12106684";

private function initMod():void{
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;	
	var ws:WebService = Application.application.getWS("Reporte","OpReporteMeses");
	ws.OpReporteMeses.resultFormat = "e4x";
	
	ws.OpReporteMeses.send(parametrosWS.IDCia,
							parametrosWS.IDTaller,
							parametrosWS.IDLocal,
							parametrosWS.Marca,
							parametrosWS.FechaInicio,
							parametrosWS.FechaTermino);
    ws.OpReporteMeses.addEventListener("result", datosGrafico);
    ws.OpReporteMeses.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_etapas_promedio_mes_alert_title_repor'));
    });
}


private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
		
	if(listaDatosWS != null){
		//cambiarIdiomaMeses(listaDatosWS);
		linearAxis.maximum = getColumMayor(listaDatosWS);
		cambiarIdiomaMeses(listaDatosWS);
		myChart.dataProvider = listaDatosWS;	
		//listaDatosWS = cambiarIdiomaMeses(listaDatosWS);
		//cambiarIdiomaMeses(listaDatosWS);
	}
}

private function getColumMayor(datos:ArrayCollection):int{
	var mayor:int = 0; 
	for each(var i:Object in datos){
		if (mayor < i.TiempoCiaAnt){
			mayor = i.TiempoCiaAnt;
		}
		if (mayor < i.TiempoCiaAct){
			mayor = i.TiempoCiaAct;
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

private function cambiarIdiomaMeses(datos:ArrayCollection):void{
	var objTemp:Object = new Object();
	var strMes:String = datos[0].Detalle;
	var mesAnterior:String = strMes.substr(0,8);
	var mesActual:String = strMes.substr(9,8);
	
	mesAnterior = stringMes(mesAnterior.substr(0,3)) + mesAnterior.substr(4);
	mesActual = stringMes(mesActual.substr(0,3)) + mesActual.substr(4);
	
	
	this.colMesAnterior.displayName = mesAnterior;
	this.colMesActual.displayName = mesActual;
	this.colMesAnteriorOtraCia.displayName = IdiomaApp.getText('general_otras_companias') + " " + mesAnterior;
	this.colMesActualOtraCia.displayName = IdiomaApp.getText('general_otras_companias') + " "+ mesActual;
	
	objTemp.TiempoCiaAnt = datos[0].TiempoCiaAnt;
	objTemp.TotVhCiaAnt = datos[0].TotVhCiaAnt;
	objTemp.TiempoOtraCiaAnt = datos[0].TiempoOtraCiaAnt;
	objTemp.TotVhOtraCiaAnt = datos[0].TotVhOtraCiaAnt;
	objTemp.TiempoCiaAct = datos[0].TiempoCiaAct;
	objTemp.TotVhCiaAct = datos[0].TotVhCiaAct;
	objTemp.TiempoOtraCiaAct = datos[0].TiempoOtraCiaAct;
	objTemp.TotVhOtraCiaAct = datos[0].TotVhOtraCiaAct;
	objTemp.Detalle = mesAnterior + "/" + mesActual;
	
	datos.setItemAt(objTemp, 0);
	
	//datos.addItemAt(objTemp, 0);
}


private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		var mesAnterior:String = Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaInicio.label;
		var mesAnteriorOtro:String = IdiomaApp.getText('general_otras_companias') + " " + mesAnterior;
		var mesActual:String = Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaTermino.label;
		var mesActualOtro:String = IdiomaApp.getText('general_otras_companias') + " " + mesActual;
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('mod_etapas_promedio_mes_prom') + " " + date + ".xls", {colsValues:[
																										{header:IdiomaApp.getText('general_etapa'), value:"Detalle"},
																										{header:mesAnterior, value:"TiempoCiaAnt"}, 
																										{header:mesAnteriorOtro, value:"TiempoOtraCiaAnt"},
																										{header:mesActual, value:"TiempoCiaAct"},
																										{header:mesActualOtro, value:"TiempoOtraCiaAct"}
																										]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('mod_etapas_promedio_mes_prom') + " " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function chartDataTipFunction(hitData:HitData):String {
    var item:ColumnSeriesItem = ColumnSeriesItem(hitData.chartItem);    
    var series:ColumnSeries = ColumnSeries(hitData.element);
    //Alert.show(ObjectUtil.toString(SolidColor(item.fill).color));
   	var total:String = "";
   	
   	switch (SolidColor(item.fill).color.toString()){
   		case RED_COLOR:
   			total += item.item.TotVhCiaAnt;
   		break;
   		case BLUE_COLOR:
   			total += item.item.TotVhCiaAct;
   		break;
   		case DARK_GREY_COLOR:
   			total += item.item.TotVhOtraCiaAct;
   		break;
   		case LIGHT_GREY_COLOR:
   			total += item.item.TotVhOtraCiaAnt;
   		break;
   	}
    
    var info:String = "<b>" + series.displayName + "</b>\n" + 
    					"" + item.xValue + "\n" +
    					"<b>"+  IdiomaApp.getText('mod_etapas_promedio_mes_tiempo') + " "+"</b>" + item.yValue + "\n" + 
    					"<b>"+  IdiomaApp.getText('mod_etapas_promedio_mes_total') + " "+"</b>"  + total + "\n"
    ; 
    return  info;
}

private function stringMes(strMes:String):String{
	switch(strMes.toUpperCase()){
		case "JAN":
			return IdiomaApp.getText('general_ene') + " ";
		break;
		case "FEB":
			return IdiomaApp.getText('general_feb') + " ";
		break;
		case "MAR":
			return IdiomaApp.getText('general_mar') + " ";
		break;
		case "APR":
			return IdiomaApp.getText('general_abr') + " ";
		break;
		case "MAY":
			return IdiomaApp.getText('general_may') + " ";
		break;
		case "JUN":
			return IdiomaApp.getText('general_jun') + " ";
		break;
		case "JUL":
			return IdiomaApp.getText('general_jul') + " ";
		break;
		case "AUG":
			return IdiomaApp.getText('general_ago') + " ";
		break;
		case "SEP":
			return IdiomaApp.getText('general_sep') + " ";
		break;
		case "OCT":
			return IdiomaApp.getText('general_oct') + " ";
		break;
		case "NOV":
			return IdiomaApp.getText('general_nov') + " ";
		break;
		case "DEC":
			return IdiomaApp.getText('general_dic') + " ";
		break;
		default :
			return "";
		break;
		
	}
}


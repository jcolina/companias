// ActionScript file
// ActionScript file
import excel.ExcelExport;

import mx.charts.events.ChartItemEvent;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.IdiomaApp;
import talleresCompania2010.util.ImageChartExport;

private function initMod():void{
	this.canvasInit();
	var ws:WebService = Application.application.getWS("Reporte","OpRankingTalleres");
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
	ws.OpRankingTalleres.resultFormat = "e4x";
	ws.OpRankingTalleres.send(parametrosWS.IDCia,
								parametrosWS.FecInicio,
								parametrosWS.FecTer);
    ws.OpRankingTalleres.addEventListener("result", datosGrafico);
    ws.OpRankingTalleres.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('lib_mod_re_ranking_title_alert'));
    });
}
	
private function datosGrafico(event:ResultEvent):void {
	var arrMejores:ArrayCollection = new ArrayCollection();
	var arrPeores:ArrayCollection = new ArrayCollection();
	
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		var strTemp:String = "";
		var objTemp:Object;
		
		txTiempoPromedioTotal.text += listaDatosWS[0].Media;
		
		for each(var obj:Object in listaDatosWS){
			strTemp = obj.Nombre;
			objTemp = new Object();
			
			objTemp.Nombre = strTemp.substr(3);
			objTemp.Promedio = obj.Promedio;
			
			if (strTemp.substr(0,2) == "0-"){
				arrMejores.addItem(objTemp);
			}
			else{
				if (strTemp.substr(0,2) == "1-"){
					arrPeores.addItem(objTemp);
				}
			}	
		}
		
		liMyChartMejores.maximum = Application.application.getColumMayor(arrMejores, "Promedio");
		myChartMejores.dataProvider = arrMejores; 
		//caMyChartMejores.dataProvider = arrMejores; 
		
		liMyChartPeores.maximum = Application.application.getColumMayor(arrPeores, "Promedio");
		myChartPeores.dataProvider = arrPeores;	
		//caMyChartPeores.dataProvider = arrPeores;
		
		/*
		if(arrMejores.length == 1)
			liMyChartMejores.maximum = Application.application.getColumMayor(listaDatosWS, "Promedio");
		
		if(arrPeores.length == 1)
			liMyChartPeores.maximum = getColumMayor(listaDatosWS);
			*/
	}
}

// Hack to prevent propagation of the ChartItemEvent.CHANGE as it is in conflict with IndexChangedEvent.CHANGE
private function canvasInit(): void{
	this.addEventListener(ChartItemEvent.CHANGE, chartItemEventChange, true, 0, true);
}

private function chartItemEventChange(event: Event): void{
	event.stopImmediatePropagation();
}

private function graficoExcelMejores():void{
	if(myChartMejores.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChartMejores.dataProvider, IdiomaApp.getText('lib_mod_re_ranking_mejores') + " " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_locales'), value:"Nombre"}, {header:IdiomaApp.getText('lib_mod_re_ranking_promedio'), value:"Promedio"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoExcelPeores():void{
	if(myChartPeores.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChartPeores.dataProvider, IdiomaApp.getText('lib_mod_re_ranking_peores') + " " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_locales'), value:"Nombre"}, {header:IdiomaApp.getText('lib_mod_re_ranking_promedio'), value:"Promedio"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImageMejores():void{
	if(myChartMejores.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChartMejores, chartContainerMejores, IdiomaApp.getText('lib_mod_re_ranking_mejores')+ " " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImagePeores():void{
	if(myChartPeores.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChartPeores, chartContainerPeores, IdiomaApp.getText('lib_mod_re_ranking_peores') + " " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

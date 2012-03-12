// ActionScript file
import excel.ExcelExport;

import flash.events.KeyboardEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.mxml.WebService;

import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;


public var ObjParamDetalle:Object = new Object();

private function initMod():void {
	//por etapa
	var ObjParamGraficoGeral:Object = Application.application.mlReporte.child.paramGraGeneral;
	var objFiltrosIdCom:Object = Application.application.mlDerechoReporte.child.ObjParams;

	
	if (objFiltrosIdCom != null){
		ObjParamDetalle.IDCompania = objFiltrosIdCom.IDCompania;
	}else{
		ObjParamDetalle.IDCompania = Application.application.idCompania;
	}
	if (objFiltrosIdCom != null){
		ObjParamDetalle.Marca= objFiltrosIdCom.Marca;
	}else{
		ObjParamDetalle.Marca = 0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamDetalle.IDZona = objFiltrosIdCom.IDZona;
	}else{
		ObjParamDetalle.IDZona = 0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamDetalle.IDTaller = objFiltrosIdCom.IDTaller;
	}else{
		ObjParamDetalle.IDTaller = 0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamDetalle.IDLocal = objFiltrosIdCom.IDLocal;
	}else{
		ObjParamDetalle.IDLocal = 0;	
	}		

	ObjParamDetalle.IDTipoTarea = ObjParamGraficoGeral.IDTareaPorcent;
	var ws:WebService = Application.application.getWS("RepVeh","OpGrafPorcentaje");	
	ws.OpGrafPorcentaje.resultFormat = "e4x";
	ws.OpGrafPorcentaje.send(
								ObjParamDetalle.IDTipoTarea,
								ObjParamDetalle.Marca,
								ObjParamDetalle.IDCompania,
								ObjParamDetalle.IDZona,
								ObjParamDetalle.IDTaller,
								ObjParamDetalle.IDLocal);
								
    ws.OpGrafPorcentaje.addEventListener("result", datosGrafico);
    ws.OpGrafPorcentaje.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('general_reporte'));
    });
	
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	
}

private function cerrarDialog(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		cerrarWin();
	} 
}

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
		var mayor1:int = 0;
		var mayor2:int = 0;
		var mayor3:int = 0;
		for(var i:int = 0; i < datos.length; i++){
			if (mayor1 < datos[i].IDTareaPorcent){
				mayor1 = datos[i].IDTareaPorcent;
			}
		}
		for(i= 0; i < datos.length; i++){
			if (mayor2 < datos[i].Procesados){
				mayor2 = datos[i].Procesados;
			}
		}
		for(i = 0; i < datos.length; i++){
			if (mayor3 < datos[i].TotalVehiculos){
				mayor3 = datos[i].TotalVehiculos;
			}
		}
		if (mayor1 > mayor2)mayor=mayor1;
		else if (mayor2>mayor3)mayor=mayor2;
		if (mayor1<mayor3)mayor= mayor3;
		
		if(mayor > 20)
			mayor = mayor + 20;
		else
			if(mayor < 20)
			mayor = mayor + 5;
		return mayor;
}

public function cerrarWin():void{
	Application.application.closePopUp(this);
}


private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider,  IdiomaApp.getText('general_detalle_etapa')+" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_etapa'), value:"NombreTaller"}, {header:IdiomaApp.getText('com_grafico_detalle_cantidad_actual'), value:"Procesados"}]} );
	}else{
		Alert.show( IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'),  IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('general_detalle_etapa')+" " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

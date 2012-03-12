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

public var ObjParamNotificaciones:Object = new Object();

private function initCom():void {	
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);

	var ObjParamGraficoGeral:Object = Application.application.mlReporte.child.paramGraGeneral;
	var objFiltrosIdCom:Object = Application.application.mlDerechoReporte.child.ObjParams;
	
	//Alert.show(ObjectUtil.toString(objFiltrosIdCom));
	
	if (objFiltrosIdCom != null){
		ObjParamNotificaciones.IDCia = objFiltrosIdCom.IDCia;
		ObjParamNotificaciones.IDTaller = ObjParamGraficoGeral.id;
		ObjParamNotificaciones.FecInicio = objFiltrosIdCom.FecInicio;
		ObjParamNotificaciones.FecTer = objFiltrosIdCom.FecTer;
	}else{
		ObjParamNotificaciones.IDCia = Application.application.idCompania;
		ObjParamNotificaciones.IDTaller = 0;
		ObjParamNotificaciones.FecInicio = Application.application.fechaToString(new Date(2010, 0, 12));
		ObjParamNotificaciones.FecTer = Application.application.fechaToString(new Date);
	}
	ObjParamNotificaciones.IDLocal = "0";
	var ws:WebService = Application.application.getWS("Reporte","OpPromNotificaciones");	
	ws.OpPromNotificaciones.resultFormat = "e4x";
	ws.OpPromNotificaciones.send(ObjParamNotificaciones.IDCia,
									ObjParamNotificaciones.FecInicio,
									ObjParamNotificaciones.FecTer,
									ObjParamNotificaciones.IDTaller,
									ObjParamNotificaciones.IDLocal);
    ws.OpPromNotificaciones.addEventListener("result", datosGrafico);
    ws.OpPromNotificaciones.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('general_reporte'));
    });

}

private function cerrarDialog(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		cerrarWin();
	} 
}


private function datosGrafico(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "Promedio");
		myChart.dataProvider = listaDatosWS;
	}
}	

public function cerrarWin():void{
	Application.application.closePopUp(this);
}


private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('com_grafico_notificaciones_detalle_noti')+" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_grid_local'), value:"Nombre"}, {header:IdiomaApp.getText('com_grafico_notificaciones_promedio_noti'), value:"Promedio"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('com_grafico_notificaciones_detalle_noti')+" " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

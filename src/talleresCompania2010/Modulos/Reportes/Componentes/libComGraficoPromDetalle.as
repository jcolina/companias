// ActionScript file
import excel.ExcelExport;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.mxml.WebService;

import talleresCompania2010.util.ImageChartExport;
import talleresCompania2010.util.IdiomaApp;

private var ObjParamServicioDetalle:Object = new Object();
private var ObjParamGrafProm:Object = new Object();

public function set ObjParamGraficoProm(paramGraProm:Object):void{
	ObjParamGrafProm = paramGraProm;	
}

private function initMod():void {
	
	var objFiltrosIdCom:Object = Application.application.mlDerechoReporte.child.ObjParams;

	if (objFiltrosIdCom != null){
		ObjParamServicioDetalle.IDCompania=objFiltrosIdCom.IDCompania;
	}else{
		ObjParamServicioDetalle.IDCompania=Application.application.idCompania;
	}
	if (objFiltrosIdCom != null){
		ObjParamServicioDetalle.Marca= objFiltrosIdCom.Marca;
	}else{
		ObjParamServicioDetalle.Marca=0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamServicioDetalle.IDZona= objFiltrosIdCom.IDZona;
	}else{
		ObjParamServicioDetalle.IDZona=0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamServicioDetalle.IDTaller = objFiltrosIdCom.IDTaller;
	}else{
		ObjParamServicioDetalle.IDTaller = 0;	
	}
	if (objFiltrosIdCom != null){
		ObjParamServicioDetalle.IDLocal = objFiltrosIdCom.IDLocal;
	}else{
		ObjParamServicioDetalle.IDLocal = 0;	
	}

	ObjParamServicioDetalle.IDTipoTarea = ObjParamGrafProm.I;
	var ws:WebService = Application.application.getWS("RepVeh","OpTpPro");	
	ws.OpTpPro.resultFormat = "e4x";
	ws.OpTpPro.send(ObjParamServicioDetalle.IDTipoTarea,
					ObjParamServicioDetalle.Marca,
					ObjParamServicioDetalle.IDCompania,
					ObjParamServicioDetalle.IDZona,
					ObjParamServicioDetalle.IDTaller,
					ObjParamServicioDetalle.IDLocal);
    ws.OpTpPro.addEventListener("result", datosGrafico);
    ws.OpTpPro.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show( IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('com_grafico_prom_detalle_alert_title'));
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
		linearAxis.maximum = Application.application.getColumMayor(listaDatosWS, "H");		
		myChart.dataProvider = listaDatosWS;
	}
}

public function cerrarWin():void{
	PopUpManager.removePopUp(this);
}

private function graficoExcel():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(myChart.dataProvider, IdiomaApp.getText('com_grafico_prom_detalle_prom_etapa')+" " + date + ".xls", {colsValues:[{header:IdiomaApp.getText('general_grid_taller'), value:"D"}, {header:IdiomaApp.getText('com_grafico_prom_detalle_hora_prom'), value:"H"}]});
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('com_grafico_prom_detalle_prom_etapa')+" " + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}
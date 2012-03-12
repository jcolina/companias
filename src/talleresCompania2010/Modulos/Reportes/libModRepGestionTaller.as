// ActionScript file
import excel.ExcelExport;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.IdiomaApp;

private function initMod():void{
	llamarWSGestionTaller();
}

private function llamarWSGestionTaller():void{
	var parametrosWS:Object = Application.application.mlDerechoReporte.child.ObjParams;
	var ws:WebService = Application.application.getWS("Reporte","OpDetalleVh");
	ws.OpDetalleVh.resultFormat = "e4x";
	ws.OpDetalleVh.send(
		parametrosWS.IDCompania,
		parametrosWS.Inicio,
		parametrosWS.Termino,
		parametrosWS.IDLocal,
		parametrosWS.IDTaller
	);
	ws.OpDetalleVh.addEventListener("result", datosGestionTaller);
    ws.OpDetalleVh.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_rep_gestion_taller_alert_title_error'));
    });
}

private function datosGestionTaller(event:ResultEvent):void{
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	if(listaDatosWS != null){
		adgTalleres.dataProvider = listaDatosWS;	
	}else{
		Alert.show(IdiomaApp.getText('mod_rep_gestion_taller_alert_no_fechas'), IdiomaApp.getText('general_aviso_title'));
	}
}

public function graficoExcel():void{
	if(adgTalleres.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(adgTalleres, IdiomaApp.getText('mod_rep_gestion_taller_rep_vei_gen')+ " " + date + ".xls", {});
	}else{
		Alert.show(IdiomaApp.getText('mod_rep_gestion_taller_listado_vacio'), IdiomaApp.getText('general_aviso_title'));
	}
}
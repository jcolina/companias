// ActionScript file
import mx.controls.Alert;
import mx.core.Application;
import mx.events.ListEvent;

import talleresCompania2010.Modulos.Documentos.businessLogic.IngresarSolicitud;
import talleresCompania2010.util.IdiomaApp;

private const labelTipoDocumento:String = IdiomaApp.getText('general_tipo')+"\n"+IdiomaApp.getText('general_documento');
private const labelEmailResponsable:String = IdiomaApp.getText('general_grid_email')+"\n"+IdiomaApp.getText('mod_solicitudes_responsable');
private const labelFechaEsperada:String = IdiomaApp.getText('general_fecha')+"\n"+IdiomaApp.getText('mod_solicitudes_esperada');
private var objIngresoSolicitud:IngresarSolicitud;

private function initMod():void{
	if(Application.application.ObjVehiculo != null){
		objIngresoSolicitud = new IngresarSolicitud(this);
		iniciarFechas();
	}	
}

private function colorRows(Data:Object, Column:AdvancedDataGridColumn):Object {	
	switch(Data.Color){
		case "Rojo":
			return {rowColor:0xF55353, fontWeight:"bold"};
			break;
		default:
			return {rowColor:null};
			break;
	}
}

private function iniciarFechas():void{
	dtFechaEsperada.dayNames = Application.application.DIAS_CALENDARIO;
   	dtFechaEsperada.monthNames = Application.application.MESES_CALENDARIO;	
	dtFechaEsperada.formatString = "DD/MM/YYYY";
	dtFechaEsperada.selectedDate = new Date();
}

private function activarEmail(event:ListEvent):void{
	if(event.currentTarget.selectedItem.EmailResponsable != null){		
		lblEmailResponsable.text = event.currentTarget.selectedItem.EmailResponsable;
		rowEmail.visible = true;
	}else{
		rowEmail.visible = false;
		lblEmailResponsable.text = "";
	}
}

private function addSolicitud():void{
	if(Application.application.validar([vlResponsable, vlTipoDocumento])){
		objIngresoSolicitud.addSolicitud();
	}
}

private function onClickGrid(event:ListEvent):void{	
	if(Application.application.ObjVehiculo != null){
		Application.application.ObjDatosSolicitud = event.currentTarget.selectedItem;
		var objModDocumentosSolicitud:modUpDocumentosSolicitud = new modUpDocumentosSolicitud();	
		Application.application.createPopUpManager(objModDocumentosSolicitud);
		objModDocumentosSolicitud.lblTipo.text = Application.application.ObjDatosSolicitud.NombreTipo;
	}else{
		Alert.show(IdiomaApp.getText('mod_solicitudes_alert_vehi'), IdiomaApp.getText('general_aviso_title'));
	}
}

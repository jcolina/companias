// ActionScript file

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.Modulos.Agenda.classes.events.CustomEvents;
import talleresCompania2010.Modulos.Agenda.classes.model.DataHolder;
import talleresCompania2010.Modulos.Agenda.classes.utils.CommonUtils;
import talleresCompania2010.Modulos.modDetalleAgenda;
import talleresCompania2010.util.IdiomaApp;

/* Current date will be bound all views */
[Bindable]
private var currentDate:Date;			


/* Function will execute on creation complete of main.mxml */
private function initMod():void{
	monthView.visible = false;
	lblMes.visible = false;
	cargarDatos();
}


private function cargarDatos():void {
	var parametrosWS:Object = new Object();		
	var ws:WebService = Application.application.getWS("AgendaCia","OPCuentaAgenda");
	parametrosWS.IDCompania = Application.application.idCompania;
	ws.OPCuentaAgenda.resultFormat = "e4x";
	ws.OPCuentaAgenda.send(parametrosWS.IDCompania);
    ws.OPCuentaAgenda.addEventListener("result", datosAgenda);
    ws.OPCuentaAgenda.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'),IdiomaApp.getText('general_agenda'));
    });
}

private function datosAgenda(event:ResultEvent):void {
 	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event)		
	if(listaDatosWS != null){	
		for(var i:int; i < listaDatosWS.length; i++){				
			listaDatosWS[i].fecha = CommonUtils.stringToDate(listaDatosWS[i].fecha);
		}		
		DataHolder.getInstance().dataProvider = listaDatosWS;		
	}

	monthView.addEventListener(CustomEvents.MONTH_VIEW_CLICK, onMonthViewClick);
	monthView.visible = true;
	lblMes.visible = true;

	var dtTemp:Date = new Date();
	changeMonth(dtTemp.getFullYear(), dtTemp.getMonth());
}

// function fires when a cell is being clicked from the Month View
private function onMonthViewClick(event:CustomEvents):void {
	if(DataHolder.getInstance().buscarDatos(CommonUtils.stringToDate(event.object.date.toString()).toString())){		
		var objModDetalleAgenda:modDetalleAgenda = new modDetalleAgenda();
		objModDetalleAgenda.setfecha(event.object.date);
		Application.application.createPopUpManager(objModDetalleAgenda);
	}
}

private function changeMonth(year:int, month:int):void{
	currentDate = new Date(year, month, 1);
	monthView.currentMonth = currentDate.getMonth();
	monthView.currentYear = currentDate.getFullYear();
	displayMeses();
}

private function nextMonth():void {
	var year:int;
	var month:int;
	if(currentDate.getMonth() == 11){
		year = currentDate.getFullYear() + 1;
		month = 0;
	}else {
		year = currentDate.getFullYear();
		month = currentDate.getMonth() + 1;
	}
	changeMonth(year, month);
}

private function lastMonth():void {
	var year:int;
	var month:int;

	if(currentDate.getMonth() == 0){
		year = currentDate.getFullYear() - 1;
		month = 11;
	}else {
		year = currentDate.getFullYear();
		month = currentDate.getMonth() - 1;
	}
	changeMonth(year, month);
}

private function presentMonth():void {
	var dtTemp:Date = new Date();
	changeMonth(dtTemp.getFullYear(), dtTemp.getMonth());
}

private function displayMeses():void {
	var mes:String = "";

	switch (currentDate.getMonth()){
		case 0:
			mes = IdiomaApp.getText('general_enero');
			break;
		case 1:
			mes = IdiomaApp.getText('general_febrero');
			break;
		case 2:
			mes = IdiomaApp.getText('general_marzo');
			break;
		case 3:
			mes = IdiomaApp.getText('general_abril');
			break;
		case 4:
			mes = IdiomaApp.getText('general_mayo');
			break;
		case 5:
			mes = IdiomaApp.getText('general_junio');
			break;
		case 6:
			mes = IdiomaApp.getText('general_julio');
			break;
		case 7:
			mes = IdiomaApp.getText('general_agosto');
			break;
		case 8:
			mes = IdiomaApp.getText('general_septiembre');
			break;
		case 9:
			mes = IdiomaApp.getText('general_octubre');
			break;
		case 10:
			mes = IdiomaApp.getText('general_noviembre');
			break;
		case 11:
			mes = IdiomaApp.getText('general_diciembre');
			break;		
	}

	lblMes.text = mes + " " + currentDate.getFullYear();	
}



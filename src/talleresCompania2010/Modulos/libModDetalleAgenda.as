// ActionScript file
import flash.utils.*;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
private var idtaller:String;
private var fecha:String;
import flash.xml.XMLDocument;

import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.ResultEvent;
import mx.controls.DateField;
import mx.collections.ArrayCollection;
import mx.utils.ObjectProxy;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;
import flash.events.MouseEvent;
import mx.controls.AdvancedDataGrid;
import mx.events.ListEvent;
import  mx.rpc.soap.mxml.WebService;

import talleresCompania2010.util.IdiomaApp;

private var dt:Date;
public var Datos1:ArrayCollection;
private var fe:String;



public function setfecha(fecha:String): void {
	this.fecha = fecha;
}

public function getfecha(): String {
	return this.fecha;
}

private function initMod():void {
	
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	//var id:String = this.getidtaller();
	fe = this.getfecha();	
	//Alert.show("Fecha Recibida : "+fe);
	
	
	
	var parametrosWS:Object = new Object();		
	var ws:WebService = Application.application.getWS("DetalleAgenda","OPDetalleAgenda");
	parametrosWS.fecha = fe;
	parametrosWS.IDCompania = Application.application.idCompania;
	ws.OPDetalleAgenda.resultFormat = "e4x";
	ws.OPDetalleAgenda.send(parametrosWS.fecha,
							parametrosWS.IDCompania);
    ws.OPDetalleAgenda.addEventListener("result", datosTaller);
    ws.OPDetalleAgenda.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('detalle_agenda_alert_detalle'));
    });
}

//-----------------------------------------------------------
private function cerrarDialog(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		closePopUp();
	} 
}

private function datosTaller(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);	
	gc.source = listaDatosWS
	gc.refresh();
	var fec:String = this.getfecha();
	lbfecha.text = fec;
	//myADG0.dataProvider = event.result.L.R;
	var cant:int = 0;
	var res:int = 0;
	var vu:int = listaDatosWS.length;
	var obj:Object = new Object();
	obj = listaDatosWS;
	var i:Number = 0;
	if(vu == 0) {
		lbtotal.text = ""+obj.total;
	}else{
		while (i < vu){
			res = listaDatosWS.source[i].total;
			cant = cant + res;
			i++;
			//Alert.show("cantidad : "+cant);
		}
		lbtotal.text = ""+cant;
	}
	myADG0.expandAll();
}

public function closePopUp():void {
	PopUpManager.removePopUp(this);
}
/*
private function errorCallService(event:FaultEvent):void {
	Alert.show("Se produjo un error en el servicio.", "Advertencia");
}


 private function clickRow(event:ListEvent):void {
	
	var ObjTaller:Object = new Object();
	ObjTaller = AdvancedDataGrid(event.currentTarget).selectedItem;
	//Alert.show("prueba taller "+ObjectUtil.toString(ObjTaller));
	
	var idtall:String = ObjTaller.idtaller;
	var fech:String = ObjTaller.fecha;
	
	serviceDetalleTaller.url = Application.application.getUrlService("DetalleAgeTall");
	var Parametros:Object = new Object();
	Parametros.IDTaller = idtall;
	Parametros.FechaEntrega = fech;
	serviceDetalleTaller.send(Parametros);
	serviceDetalleTaller.addEventListener(ResultEvent.RESULT, detalleTaller, false, 0, true);
	serviceDetalleTaller.addEventListener(FaultEvent.FAULT, errorCallService, false, 0, true);
				
		
}


private function detalleTaller(event:ResultEvent):void {
	
	gc.source = event.result.L.R;
	gc.refresh();
	
} */
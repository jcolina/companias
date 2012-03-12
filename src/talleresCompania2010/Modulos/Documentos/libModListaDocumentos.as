// ActionScript file
import flash.events.MouseEvent;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.ListEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

private const ACTA_ENTREGA:String = "Acta de entrega";
private const FACTURA:String = "Factura";
private const PRESUPUESTO:String = "Presupuesto";
private const FOTOS:String = "Fotos";
private const DENUNCIO:String = "Denuncio";
private const OTROS:String = "Otros";
private const COMPROBANTE:String = "Comprobante";

private var countActaEntrega:int;
private var countFactura:int;
private var countPresupuesto:int;
private var countFotos:int;
private var countDenuncio:int;
private var countOtros:int;
private var countComprobante:int;

import talleresCompania2010.util.IdiomaApp;

public function openDoc(urlDoc:String):void{
	var url :URLRequest = new URLRequest(urlDoc);
	navigateToURL(url, "_blank");
}

public function initMod():void {
	if(Application.application.ObjVehiculo != null) {
		httpCargaLista();
	}
	btnUpDoc.addEventListener(MouseEvent.CLICK, dialogUpDoc);
}


private function httpCargaLista():void{
	var objVeh:Object = Application.application.ObjVehiculo;
	httpListaDoc.url =Application.application.getUrlServiceAlfresco("alfrescoListDocument");
	httpListaDoc.url += "/vid=" + objVeh.IDVehiculo + "&filter=All?format=atom&alf_ticket=" + Application.application.ticket;
	httpListaDoc.send();
	httpListaDoc.addEventListener(ResultEvent.RESULT, cargaGrillaDoc);
	httpListaDoc.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{});
}

private function abrirDoc(event:ListEvent):void {
	if((event.currentTarget).selectedItem.link != null){
		var objItemDoc:Object = AdvancedDataGrid(event.currentTarget).selectedItem;
		openDoc(objItemDoc.link);
	}
	gridListaDocumentos.expandAll();
}



private function cargaGrillaDoc(event:ResultEvent):void {
	if(event.result.L != null){
		if(!event.result.L.R.hasOwnProperty("list")){
			event.result.L.R.fecha = isoToDate(event.result.L.R.fecha);
			//event.result.L.R.link=event.result.L.R.link.replace("192.168.1.168:8080","190.196.70.29");
			event.result.L.R.link +="?alf_ticket=" + Application.application.ticket;
			contadorTipos(event.result.L.R.grupo);
		}else{
			for(var i:int = 0 ; i < event.result.L.R.length;i++){
				 event.result.L.R[i].fecha = isoToDate(event.result.L.R[i].fecha);
				 //event.result.L.R[i].link=event.result.L.R[i].link.replace("192.168.1.168:8080","190.196.70.29");
				 event.result.L.R[i].link+="?alf_ticket=" + Application.application.ticket;
				 contadorTipos(event.result.L.R[i].grupo);
			}
		}		
		
		event = formatConteo(event);
		
		groupCollec.source = event.result.L.R;
		clmTipo.dataField = "tipo";
		clmTitulo.dataField = "titulo";
		clmFecha.dataField = "fecha";
		clmLink.dataField = "link";
		Date.parse(clmFecha);
		groupCollec.refresh();
	}
}

private function formatConteo(event:ResultEvent):ResultEvent {
	if(event.result.L != null){
		if(!event.result.L.R.hasOwnProperty("list")){
			event.result.L.R.grupo = formatGrupo(event.result.L.R.grupo);
		}else{
			for(var i:int = 0 ; i < event.result.L.R.length;i++){
				event.result.L.R[i].grupo = formatGrupo(event.result.L.R[i].grupo);
			}
		}
		return event;
	}		
	return null;
}

private function contadorTipos(tipo:String):void {
	switch (tipo){
		case ACTA_ENTREGA:
			countActaEntrega++;
		break;
		case FACTURA:
			countFactura++;
		break;
		case PRESUPUESTO:
			countPresupuesto++;
		break;
		case FOTOS:
			countFotos++;
		break;
		case DENUNCIO:
			countDenuncio++;
		break;
		case OTROS:
			countOtros++;
		break;
		case COMPROBANTE:
			countComprobante++;
		break;
	}
}

private function formatGrupo(grupo:String):String {
	switch (grupo){
		case ACTA_ENTREGA:
			return grupo + " (" + countActaEntrega + ")";
		break;
		case FACTURA:
			return grupo + " (" + countFactura + ")";
		break;
		case PRESUPUESTO:
			return grupo + " (" + countPresupuesto + ")";
		break;
		case FOTOS:
			return grupo + " (" + countFotos + ")";
		break;
		case DENUNCIO:
			return grupo + " (" + countDenuncio + ")";
		break;
		case OTROS:
			return grupo + " (" + countOtros + ")";
		break;
		case COMPROBANTE:
			return grupo + " (" + countComprobante + ")";
		break;
	}
	return "";
}

private function dialogUpDoc(event:MouseEvent):void {
	if(Application.application.ObjVehiculo != null){
		var objModDocumentos:modUpDocumentos = new modUpDocumentos();
		Application.application.createPopUpManager(objModDocumentos);
	}else{
		Alert.show(IdiomaApp.getText('mod_lista_documento_alert'), IdiomaApp.getText('general_aviso_title'));
	}	
}

public function reloadListaDocumentos():void{
	httpCargaLista();
}

private function buildToolTip(item:Object):String{
	var myString:String = "";
	if(item != null){
		if (item.hasOwnProperty("etapa")){
			myString = myString + IdiomaApp.getText('mod_lista_documento_etapa')+" " + item.etapa;	
		}
	}
	return myString;
}

//----------------parsexmldate

private function isoToDate(value:String):String {
    var dateStr:String = value;
    dateStr = dateStr.replace(/\-/g, "/");
    var fecha:Array = dateStr.split("T"); //Alert.show(ObjectUtil.toString(fecha));
    //dateStr = dateStr.replace("T", " ");
   // dateStr = dateStr.replace("Z", " GMT-0000");
   // Alert.show("hola"+fecha[0]);
    //return new Date(Date.parse(fecha[0]));estestetstetstetstetste!!!!
    return fecha[0];
}


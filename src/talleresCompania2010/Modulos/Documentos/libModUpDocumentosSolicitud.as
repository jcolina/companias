// ActionScript file
import mx.core.Application;
import mx.controls.Alert;

import talleresCompania2010.Modulos.Documentos.businessLogic.UpSolicitudDocumentos;
import talleresCompania2010.util.IdiomaApp;	

//private const categoriasDoc:Array = ["Acta de entrega","Factura", "Presupuesto", "Fotos", "Denuncio","Otros"];
private var objSolicitudDocumentos:UpSolicitudDocumentos;


private function initMod():void {
	objSolicitudDocumentos = new UpSolicitudDocumentos(this);
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarWin);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarWin);
	comUpFileSolicitud.objUpDocumentosSolicitud = this;
}

public function cerrarDialog():void{
	Application.application.closePopUp(this);
}

private function cerrarWin(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		cerrarDialog();
	} 
}

private function sendEmail():void{	
	Application.application.ObjVehiculo.Documentos = "SI";
	Application.application.updateVehiculo(Application.application.ObjVehiculo);
	Application.application.updateModBitacora();
	objSolicitudDocumentos.updateSolicitud();
}

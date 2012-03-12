// ActionScript file
import mx.controls.Alert;
import mx.core.Application;
import mx.events.ListEvent;

import talleresCompania2010.Modulos.Factura.Classes.Principal;
import talleresCompania2010.util.IdiomaApp;

private var objPrincipal:Principal;

private function initMod():void{
	this.objPrincipal = new Principal(this);
}

private function onClickGrid(event:ListEvent):void{
	var objItemClick:Object = event.currentTarget.selectedItem;
	
	if(objItemClick != null){
		if(!Application.application.mlFacturaOpciones.child.chkSeleccion.selected){
			if(Application.application.ObjDatosFactura == null){
				objPrincipal.cargarModuloFacturas(objItemClick);
			}else{
				if(Application.application.ObjDatosFactura.IDVehiculo != objItemClick.IDVehiculo){
					objPrincipal.cargarModuloFacturas(objItemClick);
				}
			}
		}
	}
}

public function cargarGrilla():void{
	this.objPrincipal.solListaFacturas();
}
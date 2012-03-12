// ActionScript file
import mx.collections.ArrayCollection;
import mx.core.Application;


private function asignarSeleccion():void{
	data.Seleccion = chkCambio.selected;
	
	if(data.Seleccion){
		addItemVehiculo();
	}else{
		deleteItemVehiculo();
	}
}

private function asignarFalse():void{
	chkCambio.selected = data.Seleccion;
}

private function deleteItem():void{
	var listaFactura:ArrayCollection = Application.application.mlFacturaDerecho.child.mlFactura.child.dataListaFactura;
	
	for(var i:int = 0; i < listaFactura.length; i++){
		if(listaFactura[i].IDFactura == data.IDFactura){
			listaFactura.removeItemAt(i);
		}
	}
}

private function addItemVehiculo():void{
	var listaVehiculo:ArrayCollection = Application.application.mlFacturaDerecho.child.mlFactura.child.dataListaVehiculo;
	var objTempVehiculo:Object = new Object();
	objTempVehiculo.IDVehiculo = data.IDVehiculo;
	objTempVehiculo.Patente = data.Patente;
	objTempVehiculo.Siniestro = data.Siniestro;
	listaVehiculo.addItem(objTempVehiculo);
}

private function deleteItemVehiculo():void{
	var listaVehiculo:ArrayCollection = Application.application.mlFacturaDerecho.child.mlFactura.child.dataListaVehiculo;
	
	for(var i:int = 0; i < listaVehiculo.length; i++){
		if(listaVehiculo[i].IDVehiculo == data.IDVehiculo){
			listaVehiculo.removeItemAt(i);
		}
	}
}
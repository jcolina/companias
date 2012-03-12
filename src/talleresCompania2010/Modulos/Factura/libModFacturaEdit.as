// ActionScript file
import mx.controls.Alert;
import mx.core.Application;
import mx.events.ListEvent;

import talleresCompania2010.Modulos.Factura.Classes.FacturaEdit;
import talleresCompania2010.util.IdiomaApp;

private var objFacturaEdit:FacturaEdit;
public const ACCION_EDITAR:String = "UP";

private function initMod():void{
	this.objFacturaEdit = new FacturaEdit(this);
}

private function editFactura():void{
	if(Application.application.validar([vlFacturaEdit, vlGrillaFactura, vlMontoEdit])){
		var objItemClick:Object = dtgFacturasEdit.selectedItem;
		
		var objTemp:Object = new Object();
		objTemp.IDFactura = objItemClick.IDFactura;
		objTemp.Factura = txtFacturaEdit.text;
		objTemp.Monto = txtMontoEdit.text;	
		objTemp.Accion = ACCION_EDITAR;	
		dtgFacturasEdit.dataProvider.setItemAt(objTemp, dtgFacturasEdit.selectedIndex);
	}
}

private function onClickGrid(event:ListEvent):void{
	var objItemClick:Object = event.currentTarget.selectedItem;
	
	if(objItemClick != null){
		this.txtFacturaEdit.text = objItemClick.Factura;
		this.txtMontoEdit.text = objItemClick.Monto;
	}
}

private function getListGrid():String{
	var listaGrid:String = "";
	
	for(var i:int = 0; i < dtgFacturasEdit.dataProvider.length; i++){
		if(dtgFacturasEdit.dataProvider[i].Accion == ACCION_EDITAR){
			listaGrid += "|" + dtgFacturasEdit.dataProvider[i].IDFactura + "#" +
						dtgFacturasEdit.dataProvider[i].Factura + "#" +
						dtgFacturasEdit.dataProvider[i].Monto;
		} 
	}
	
	if(listaGrid.length != 0){
		listaGrid = listaGrid.substr(1, listaGrid.length);
	}
	
	return listaGrid;
}

private function guardarCambios():void{
	var listaGrid:String = this.getListGrid();
	if(listaGrid != ""){
		this.objFacturaEdit.editFacturas(listaGrid);
	}else{
		Alert.show(IdiomaApp.getText('mod_factura_info_agregar_modificar'), IdiomaApp.getText('general_aviso_title'));
	}
}

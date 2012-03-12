// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.Modulos.Factura.Classes.FacturaInfo;
import talleresCompania2010.util.IdiomaApp;


public static const URL_FACTURA_EDIT:String = "talleresCompania2010/Modulos/Factura/modFacturaEdit.swf";
public const ACCION_ADD:String = "IN";

[Bindable]
public var dataListaFactura:ArrayCollection = new ArrayCollection();

[Bindable]
public var dataListaVehiculo:ArrayCollection = new ArrayCollection();

private var countFactura:int;
private var objFacturaInfo:FacturaInfo;

private function initMod():void{
	this.objFacturaInfo = new FacturaInfo(this);
}

private function addFactura():void{
	if(Application.application.validar([vlFactura, vlValor])){
		var objTemp:Object = new Object();
		objTemp.IDFactura = ++countFactura;
		objTemp.Numero = txtFactura.text;
		objTemp.Monto = txtMonto.text;		
		dataListaFactura.addItem(objTemp);
		txtFactura.text = "";
		txtMonto.text = "";
	}
}

private function guardarFacturas():void{
	if(validarGrillas()){
		//Alert.show(this.getListGrid());
		objFacturaInfo.guardarFacturas(this.getListGrid());
	}
}

private function getListGrid():String{
	var listaGrid:String = "";
	
	for(var i:int = 0; i < dtgFacturas.dataProvider.length; i++){
		for(var j:int = 0; j < dtgVehiculos.dataProvider.length; j++){
			listaGrid += "|" + dtgVehiculos.dataProvider[j].IDVehiculo + "#" +
						dtgFacturas.dataProvider[i].Numero + "#" +
						dtgFacturas.dataProvider[i].Monto;
		}
	}
	
	if(listaGrid.length != 0){
		listaGrid = listaGrid.substr(1, listaGrid.length);
	}
	
	return listaGrid;
}

private function validarGrillas():Boolean{
	if(this.dtgFacturas.dataProvider.length < 1){
		Alert.show(IdiomaApp.getText('mod_factura_info_agregar_fact'), IdiomaApp.getText('general_aviso_title'));
		return false;
	}
	
	if(this.dtgVehiculos.dataProvider.length < 1){
		Alert.show(IdiomaApp.getText('mod_factura_info_agregar_vincular'), IdiomaApp.getText('general_aviso_title'));
		return false;
	}
	
	return true;
}


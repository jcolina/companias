// ActionScript file
import excel.ExcelExport;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.util.DateFieldUtil;
import talleresCompania2010.util.IdiomaApp;

private function initMod():void{
	var hoy:Date = new Date();
	DateFieldUtil.iniciarDateField([dtInicio, dtTermino]);
	this.dtInicio.selectedDate = new Date(hoy.getFullYear(), hoy.getMonth());
	this.dtTermino.selectedDate = hoy;
}

private function onCheckedSeleccion(event:MouseEvent):void{
	//this.btnIngresar.visible = event.currentTarget.selected;
	if(!event.currentTarget.selected){
		var lista:ArrayCollection = Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider;
		
		for(var i:int = 0; i < lista.length; i++){
			lista[i].Seleccion = false;
		}
		
		//Limpia la grilla de vehículos y facturas
		Application.application.mlFacturaDerecho.child.mlFactura.child.dataListaFactura = new ArrayCollection();
		Application.application.mlFacturaDerecho.child.mlFactura.child.dataListaVehiculo = new ArrayCollection();
	}
	
	//Limpia el objeto de datos
	Application.application.ObjDatosFactura = null;
	
	//Muestra la columna de check de la grilla
	Application.application.mlFacturaPrincipal.child.columCheck.visible = event.currentTarget.selected;
	
	//Muestra el módulo de opciones según corresponda
	var tabDerecho:Object = Application.application.mlFacturaDerecho.child.mlFactura.child.tabMain;
	(event.currentTarget.selected) ? tabDerecho.selectedIndex = 1 : tabDerecho.selectedIndex = 0;
	
	//Limpia el modulo de editar facturas
	if(tabDerecho.selectedIndex == 1){		
		Application.application.removerModulo(Application.application.mlFacturaDerecho.child.mlFactura.child.mlFacturaEdit);
	}
	
	//Desmarca la grilla
	Application.application.mlFacturaPrincipal.child.adgFactura.selectedIndex = -1;
}

private function onChangeFiltro():void {
	if (this.txtFiltro.text != "") {
		Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider.filterFunction = processFilter;
    } else {
        Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider.filterFunction = null;
    }
    Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider.refresh();
    
    if(Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider.length == 0){
    	Application.application.removerModulo(Application.application.mlFacturaDerecho.child.mlFactura.child.mlFacturaEdit);
    	Application.application.ObjDatosFactura = null;
    }
}

private function processFilter(item:Object):Boolean {
	try{
		if(rdbPatente.selected){
			return item.Patente.toUpperCase().indexOf(txtFiltro.text.toUpperCase()) != -1;
		}
		
		if(rdbSiniestro.selected){
			return item.Siniestro.toString().toUpperCase().indexOf(txtFiltro.text.toUpperCase()) != -1;
		}
		
		if(rdbCompania.selected){
			return item.Cia.toUpperCase().indexOf(txtFiltro.text.toUpperCase()) != -1;
		}
	} catch(e:Error){
		//Ignorado
	}	
    return false;
}

private function onClickFechas():void{
	if(this.dtInicio.selectedDate.getTime() > this.dtTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_factura_opciones_fecha_ini'), IdiomaApp.getText('general_aviso_title'));
		return;
	}
	Application.application.mlFacturaPrincipal.child.cargarGrilla();
}


public function graficoExcel():void{
	if(Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ExcelExport.export(Application.application.mlFacturaPrincipal.child.adgFactura.dataProvider, IdiomaApp.getText('general_facturas') + " " + date + ".xls", {colsValues:[
																																		{header: IdiomaApp.getText('Patente'), value:"Patente"},
																																		{header: IdiomaApp.getText('general_siniestro'), value:"Siniestro"}, 
																																		{header: IdiomaApp.getText('Liquidador'), value:"Liquidador"},
																																		{header: IdiomaApp.getText('general_fecha_ingreso'), value:"FecIng"}, 
																																		{header: IdiomaApp.getText('general_fecha_entrega'), value:"FecEnt"}, 
																																		{header: IdiomaApp.getText('general_facturas'), value:"Factura"}
																																		]});
	}else{
		Alert.show(IdiomaApp.getText('mod_factura_opciones_listado_no_vacio'), IdiomaApp.getText('general_aviso_title'));
	}
}
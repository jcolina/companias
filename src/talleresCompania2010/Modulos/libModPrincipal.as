// ActionScript file
import excel.ExcelExport;

import flash.events.MouseEvent;

import mx.collections.IHierarchicalCollectionView;
import mx.containers.TitleWindow;
import mx.controls.AdvancedDataGrid;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.Application;
import mx.core.ClassFactory;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.utils.ObjectUtil;

import talleresCompania2010.Modulos.*;
import talleresCompania2010.businessLogic.DatosGrilla;
import talleresCompania2010.util.ADG.ADGItemRenderCustom;
import talleresCompania2010.util.IdiomaApp;


private var DatosGrillaObj:DatosGrilla;

private function initMod():void {
	DatosGrillaObj = new DatosGrilla(this);
}

public function cargarGrilla():void {
	DatosGrillaObj.solGrillaCompania();
	DatosGrillaObj.limpia();
	unloadModsTareas();
	Application.application.descargarAllDocumentos();
}

/** modificado **/
private function cargarGrillaPorSiniestro():void {
	if(grillaPrincipal.dataProvider != null){
		if(txSiniestro.text != ""){
			IHierarchicalCollectionView(grillaPrincipal.dataProvider).filterFunction = acFilterFunction;
			IHierarchicalCollectionView(grillaPrincipal.dataProvider).refresh();
		}else{
			IHierarchicalCollectionView(grillaPrincipal.dataProvider).filterFunction = null;
			IHierarchicalCollectionView(grillaPrincipal.dataProvider).refresh();
		}
	}else{
		Alert.show(IdiomaApp.getText('mod_principal_debe_cargada'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function acFilterFunction(item:Object):Boolean{
    var nroSiniestro:Object = item.NumeroSiniestro;
    var isMatch:Boolean = false;
    if(nroSiniestro.toString().search(txSiniestro.text) != -1){
    	isMatch = true;
    }
    return isMatch;
} 

private function cargarGrillaPorPatente():void {
	if(txPatente.text != ""){
		DatosGrillaObj.solGrillaPatente();
		txSiniestro.text = "";
	}else{
		Alert.show( IdiomaApp.getText('mod_principal_debe_cargada_patente'), IdiomaApp.getText('general_aviso_title'));
	}
}

private function clickRow(event:ListEvent):void {
	var item:Object = AdvancedDataGrid(event.currentTarget).selectedItem;
	
	if (item.IDVehiculo != null) {
		var isOpen:Boolean = AdvancedDataGrid(event.currentTarget).isItemOpen(item);
		if(Application.application.ObjVehiculo != item){
			if(!isOpen){
				Application.application.ObjVehiculo = item;
				Application.application.showTareas();
			//	AdvancedDataGrid(event.target).expandItem(item, true, true);
			}else {
				Application.application.ObjVehiculo = item;
				Application.application.showTareas();
			//	AdvancedDataGrid(event.target).expandItem(item, false, true);
			}
		}else{
		//	AdvancedDataGrid(event.target).expandItem(item, !event.target.isItemOpen(item), true);
		}
	}else{
			var ObjParentItem:Object = grillaPrincipal.getParentItem(item);
 			if(Application.application.ObjVehiculo != ObjParentItem){
				Application.application.ObjVehiculo = ObjParentItem;
				Application.application.showTareas(); 
			}
	}
	
	DatosGrillaObj.solListaTareas();
		
}

public function createPopUpManager(Obj:Object):void {
	var myObj:TitleWindow = TitleWindow(Obj);
	PopUpManager.addPopUp(myObj, DisplayObject(this.parentApplication), true);
	PopUpManager.centerPopUp(myObj);
}

private function colorRows(Data:Object, Column:AdvancedDataGridColumn):Object {
	switch(Data.EstadosTareas){
		case "Rojo":
			return { rowColor:0xF55353, fontWeight:"bold" };
			break;
		case "Amarillo":
			return { rowColor:0xE0EE5E, fontWeight:"bold" };
			break;
		case "Azul":
			return { rowColor:0x3399FF, fontWeight:"bold" };
			break;
		case "Gris":
			return { rowColor:0xa4a3a3, fontWeight:"bold" };
			break;			
		default:
			return {rowColor:null};
			break;
	}
}

private function triggerADGUpdate():void {
	grillaPrincipal.itemRenderer = new ClassFactory(ADGItemRenderCustom);
}

private function cargarGrillaPorFiltros(event:MouseEvent):void {
	switch(event.target.id){
		case "lnkRed":
			DatosGrillaObj.solListaFiltros("Rojo");
			break;
		case "lnkYellow":
			DatosGrillaObj.solListaFiltros("Amarillo");
			break;
		case "lnkBlue":
			DatosGrillaObj.solListaFiltros("Azul");
			break;
		case "lnkGray":
			DatosGrillaObj.solListaFiltros("Gris");
			break;
		case "lnkPerdidaTotal":
			DatosGrillaObj.solListaFiltros("PerdidaTotal");
			break;	
		case "lnkPendRepuesto":
			DatosGrillaObj.solListaFiltros("PendRepuesto");
			break;			
	}
}

private function unloadModsTareas():void {
	Application.application.unloadModsTareas();
}

public function updateItem(item:Object):void{
	try{
		DatosGrillaObj.updateItem(item);
	}catch(e:Error){
		Alert.show("libModPrincipal.as > replaceItemGrilla : "+e.message, e.name);
	}
}

public function updateGrilla(event:MouseEvent = null):void {
	DatosGrillaObj.solGrillaCompania();
	unloadModsTareas();
	Application.application.descargarAllDocumentos();
}

private function solLocales():void {
	txSiniestro.enabled = false;
	capacidadlb.text = "";
	grillaPrincipal.dataProvider = null;
	DatosGrillaObj.solLocales();
	DatosGrillaObj.limpia();
}

private function saveTaller(event:ListEvent):void{
	//Alert.show("guardo taller");
	Application.application.taller = cbTaller.text;
} 

private function saveLocal(event:ListEvent):void{
	Application.application.local = cbLocales.text;	
}

 private function exportToExcel():void{  
 	if(grillaPrincipal.dataProvider != null){
 		var nameFile:String = IdiomaApp.getText('mod_principal_debe_listado') + DateField.dateToString(new Date(),"DD-MM-YYYY") + ".xls";
 		ExcelExport.export(grillaPrincipal, nameFile, {});
 	}else{
 		Alert.show(IdiomaApp.getText('mod_principal_debe_no_datos_grilla'), IdiomaApp.getText('general_aviso_title'));
 	}
}

private function OrdenaFechaIngreso(PrimeraFecha:Object, SegundaFecha:Object):int {
	var FechaMayor:Date = StringAFecha(PrimeraFecha.FechaIngreso);
	var FechaMenor:Date = StringAFecha(SegundaFecha.FechaIngreso);
	return ObjectUtil.dateCompare(FechaMayor, FechaMenor);
}

private function OrdenaFechaEntrega(PrimeraFecha1:Object, SegundaFecha1:Object):int {
	var FechaMayor1:Date = StringAFecha(PrimeraFecha1.FechaEntrega);
	var FechaMenor1:Date = StringAFecha(SegundaFecha1.FechaEntrega);
	return ObjectUtil.dateCompare(FechaMayor1, FechaMenor1);
}

private function StringAFecha(fecha:String):Date{
	if(fecha == null){
		return null;
	}else{
		var subfecha:String = fecha.substring(4,12);
		return DateField.stringToDate(subfecha, "DD-MM-YY");
	}
}
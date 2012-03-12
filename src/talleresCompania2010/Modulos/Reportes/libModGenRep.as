// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.ModuleEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;

import talleresCompania2010.util.IdiomaApp;

[Embed(source="/assets/BarChart.png")]
public var iconSymbolItem:Class; 
private var _ObjParams:Object;

private const URL_FILTRO_ALL:String = "talleresCompania2010/Modulos/Reportes/Filtros/modFiltroAll.swf";
private const URL_FILTRO_PROM_ETAPAS:String = "talleresCompania2010/Modulos/Reportes/Filtros/modFiltroPromEtapas.swf";
private const URL_FILTRO_FECHAS:String = "talleresCompania2010/Modulos/Reportes/Filtros/modFiltroFechas.swf";

public var listaTalleres:ArrayCollection;
public var listaMarcas:ArrayCollection;
public var listaZonas:ArrayCollection;

public function get ObjParams():Object {
	return _ObjParams;
}

private function initMod():void{
	cboReportes.dataProvider = listReportes();
	cboReportes.labelField = "titulo";
	cboReportes.selectedIndex = 1;
	mostrarFiltros();
	//loadGraficoGeneralIni();
	//cargarFecha();
}

private function listReportes():ArrayCollection {
	var list:ArrayCollection = new ArrayCollection([
									{titulo: IdiomaApp.getText('combo_reportes_opcion_obser'), icon: iconSymbolItem, form:"formTaller", Rep:1},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_etapas'), icon: iconSymbolItem, form:"formTaller", Rep:3},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_prom'), icon: iconSymbolItem, form:"formTaller", Rep:4},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_prom_mes'), icon: iconSymbolItem, form:"formTaller", Rep:5},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_ranking_talleres'), icon: iconSymbolItem, form:"formTaller", Rep:6},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_ranking_talleres_v'), icon: iconSymbolItem, form:"formTaller", Rep:10},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_ranking_prom_noti'), icon: iconSymbolItem, form:"formTaller", Rep:7},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_ranking_prom_todos'), icon: iconSymbolItem, form:"formTaller", Rep:8},
									{titulo: IdiomaApp.getText('combo_reportes_opcion_tiempo_ranking_total'), icon: iconSymbolItem, form:"formTaller", Rep:9}
									]);
	return list;
}

private function setListTalleres():void {
	if(this.listaTalleres != null){		
		try{
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.dataProvider = listaTalleres;
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.labelField = "NombreTaller";
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.addEventListener(ListEvent.CHANGE, solLocales);
		}catch(e:Error){
			//Error ignorado, puede que la respuesta de un web services llegue cuando hay otro 
			//modulo cargado
		}		
	}else{
		solListTalleres();
	}
}

private function solListTalleres():void {
	var parametrosWS:Object = new Object();
	var ws:WebService = Application.application.getWS("ListaTalleres","OpListaTalleres");	
	parametrosWS.IDCompania = Application.application.idCompania;
	ws.OpListaTalleres.resultFormat = "e4x";
	ws.OpListaTalleres.send(parametrosWS.IDCompania);
    ws.OpListaTalleres.addEventListener("result", cargarTalleres);
    ws.OpListaTalleres.addEventListener("fault", solLocales);
}

private function cargarTalleres(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	if(listaDatosWS != null){
		var objTaller:Object = new Object();
		objTaller.NombreTaller = "Sin Filtro";
		objTaller.IDTaller = "0";
		listaDatosWS.addItemAt(objTaller,0);
		this.listaTalleres = listaDatosWS;
		this.setListTalleres();
	}
}

public function solLocales(event:ListEvent):void {
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex != -1){
		var parametrosWS:Object = new Object();
		var ws:WebService = Application.application.getWS("ListadoLocales","OpListaLocales");
		parametrosWS.IDTaller = Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedItem.IDTaller;			
		//parametrosWS.IDCompania = Application.application.idCompania;
		ws.OpListaLocales.resultFormat = "e4x";
		ws.OpListaLocales.send(parametrosWS.IDTaller);
	    ws.OpListaLocales.addEventListener("result", cargarLocales);
	    ws.OpListaLocales.addEventListener("fault", function(event:FaultEvent):void{
	    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_gen_rep_tit_alert_title_reporte'));
	    });
	}
}

private function cargarLocales(event:ResultEvent):void {
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	if(listaDatosWS != null){
		var objTaller:Object = new Object();
		objTaller.Direccion = "Sin Filtro";
		objTaller.IDLocal = "0";
		listaDatosWS.addItemAt(objTaller,0);
		
		try{
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.dataProvider = listaDatosWS;
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.labelField = "Direccion";
		}catch(e:Error){
			//Error ignorado, puede que la respuesta de un web services llegue cuando hay otro 
			//modulo cargado
		}
	}else{
		Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.dataProvider = null;
	}
}

private function setListaMarcas():void {
	if(this.listaMarcas != null){
		try{
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.dataProvider = listaMarcas;
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.labelField = "Ma";
		}catch(e:Error){
			//Error ignorado, puede que la respuesta de un web services llegue cuando hay otro 
			//modulo cargado
		}
	}else{
		solListaMarcas();
	}
}

private function solListaMarcas():void {
	var parametrosWS:Object = new Object();
	var ws:WebService = Application.application.getWS("ListaParamGraf","OpListadoMarca");
	parametrosWS.IDCompania = Application.application.idCompania;
	ws.OpListadoMarca.resultFormat = "e4x";
	ws.OpListadoMarca.send(parametrosWS.IDCompania);
    ws.OpListadoMarca.addEventListener("result", cargaMarcas);
    ws.OpListadoMarca.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_gen_rep_tit_alert_title_lista'));
    });
}

private function cargaMarcas(event:ResultEvent):void{
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		var objTaller:Object = new Object();
		objTaller.Ma = "Sin Filtro";
		listaDatosWS.addItemAt(objTaller,0);
		this.listaMarcas = listaDatosWS;
		this.setListaMarcas();
	}
}

private function setListaZonas():void {
	if(this.listaZonas != null){
		try{
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.dataProvider = listaZonas;
			Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.labelField = "Zo";
		}catch(e:Error){
			//Error ignorado, puede que la respuesta de un web services llegue cuando hay otro 
			//modulo cargado
		}	
	}else{
		solListaZonas();
	}
}

private function solListaZonas():void{
	var parametrosWS:Object = new Object();
	var ws:WebService = Application.application.getWS("ListaParamGraf","OpListadoZona");	
	parametrosWS.IDCompania = Application.application.idCompania;
	ws.OpListadoZona.resultFormat = "e4x";
	ws.OpListadoZona.send(parametrosWS.IDCompania);
    ws.OpListadoZona.addEventListener("result", cargaZonas);
    ws.OpListadoZona.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_gen_rep_tit_alert_title_lista_ta'));
    });
}
private function cargaZonas(event:ResultEvent):void{
	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
	
	if(listaDatosWS != null){
		var objTaller:Object = new Object();
		objTaller.Zo = "Sin Filtro";
		objTaller.Id = "0";
		listaDatosWS.addItemAt(objTaller,0);
		this.listaZonas = listaDatosWS;
		this.setListaZonas();
	}
}

private function loadGraficoObservaciones():void{
	_ObjParams = new Object();
	_ObjParams.IDCia = Application.application.idCompania;
	
	_ObjParams.IDTaller = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex != -1){
		_ObjParams.IDTaller = Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedItem.IDTaller;
	}
	
	_ObjParams.IDLocal = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedIndex != -1){
		_ObjParams.IDLocal = Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedItem.IDLocal;
	}

	_ObjParams.Marca = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedIndex != -1 && Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.text != "Sin Filtro"){
		_ObjParams.Marca = Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedItem.Ma;
	}
							
	_ObjParams.IDZon = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedIndex != -1){
		_ObjParams.IDZon = Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedItem.Id;
	}
						
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepObservaciones.swf");
}

private function loadGraficoGeneralIni():void{	 
	_ObjParams = new Object();
	_ObjParams.IDCompania = Application.application.idCompania;
	_ObjParams.IDTipoTarea = 0;
	
	_ObjParams.IDTaller = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex != -1){
		_ObjParams.IDTaller = Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedItem.IDTaller;
	}
	
	_ObjParams.IDLocal = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedIndex != -1){
		_ObjParams.IDLocal = Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedItem.IDLocal;
	}

	_ObjParams.Marca = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedIndex != -1 && Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.text != "Sin Filtro"){
		_ObjParams.Marca = Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedItem.Ma;
	}
							
	_ObjParams.IDZona = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedIndex != -1){
		_ObjParams.IDZona = Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedItem.Id;
	}
	
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepGeneral.swf");
}

private function loadGraficoPromIni():void{
	_ObjParams = new Object();
	_ObjParams.IDCompania = Application.application.idCompania;
	_ObjParams.IDTipoTarea = 0;
	
	_ObjParams.IDTaller = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex != -1){
		_ObjParams.IDTaller = Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedItem.IDTaller;
	}
	
	_ObjParams.IDLocal = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedIndex != -1){
		_ObjParams.IDLocal = Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedItem.IDLocal;
	}

	_ObjParams.Marca = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedIndex != -1 && Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.text != "Sin Filtro"){
		_ObjParams.Marca = Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedItem.Ma;
	}
							
	_ObjParams.IDZona = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedIndex != -1){
		_ObjParams.IDZona = Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedItem.Id;
	}
	
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepPromedio.swf");

}

private function loadGraficoPromedioMes():void{
	_ObjParams = new Object();
	_ObjParams.IDCia = Application.application.idCompania;
	_ObjParams.FechaInicio = formatoFechaInicio();
	_ObjParams.FechaTermino = formatoFechaTermino();
	
	_ObjParams.IDTaller = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex != -1){
		_ObjParams.IDTaller = Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedItem.IDTaller;
	}
	
	_ObjParams.IDLocal = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedIndex != -1){
		_ObjParams.IDLocal = Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.selectedItem.IDLocal;
	}

	_ObjParams.Marca = 0;
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedIndex != -1 && Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.text != "Sin Filtro"){
		_ObjParams.Marca = Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedItem.Ma;
	}

	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepEtapasPromedioMes.swf");
}

private function loadGraficoRanking():void{
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate.getTime() > Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'),IdiomaApp.getText('general_aviso_title'));
		return;
	}
	
	_ObjParams = new Object();
	_ObjParams.FecInicio = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate);					
	_ObjParams.FecTer = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate);
	_ObjParams.IDCia = Application.application.idCompania;
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepRanking.swf");
}

private function loadGraficoRanking20():void{
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate.getTime() > Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'), IdiomaApp.getText('general_aviso_title'));
		return;
	}
	
	_ObjParams = new Object();
	_ObjParams.FecInicio = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate);					
	_ObjParams.FecTer = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate);
	_ObjParams.IDCia = Application.application.idCompania;
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepRanking20.swf");
}

private function loadGraficoPromNotificaciones():void{	
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate.getTime() > Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'), IdiomaApp.getText('general_aviso_title'));
		return;
	}
	
	_ObjParams = new Object();
	_ObjParams.IDTaller = 0;
	_ObjParams.IDLocal = 0;
	_ObjParams.FecInicio = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate);					
	_ObjParams.FecTer = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate);
	_ObjParams.IDCia = Application.application.idCompania;
	
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepPromNotificaciones.swf");
}

private function loadGestionTaller():void{
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate.getTime() > Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'), IdiomaApp.getText('general_aviso_title'));
		return;
	}
					
	_ObjParams = new Object();
	_ObjParams.Inicio = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate);					
	_ObjParams.Termino = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate);
	_ObjParams.IDCompania = Application.application.idCompania;
	_ObjParams.IDLocal = 0;	
	_ObjParams.IDTaller = 0;	
	
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepGestionTaller.swf");
}

private function loadGraficoCambiosFecha():void{
	if(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate.getTime() > Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate.getTime()){
		Alert.show(IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'), IdiomaApp.getText('mod_gen_rep_tit_fecha_inicio'));
		return;
	}
	
	//http://192.168.1.102:9763/services/Reportes/OpCambiosFechas?Idcia=2&Inicio=2011-07-01&Termino=2011-09-06&Idlocal=0&Idtaller=0
	
	_ObjParams = new Object();
	_ObjParams.IDCia = Application.application.idCompania;
	_ObjParams.Inicio = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate);					
	_ObjParams.Termino = Application.application.fechaToString(Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate);
	_ObjParams.IDLocal = 0;
	_ObjParams.IDTaller = 0;	
	
	Application.application.crearModulo(Application.application.mlReporte, "talleresCompania2010/Modulos/Reportes/modRepCambioFecha.swf");
}

private function clearListener():void{
	mlFiltro.removeEventListener(ModuleEvent.READY, listenerAll);
	mlFiltro.removeEventListener(ModuleEvent.READY, listenerPromEtapas);
	mlFiltro.removeEventListener(ModuleEvent.READY, clearFechas);
}

private function filtrosPromEtapas():void {
	if(mlFiltro.url != URL_FILTRO_PROM_ETAPAS){
		clearListener();
		mlFiltro.addEventListener(ModuleEvent.READY, listenerPromEtapas);
		Application.application.crearModulo(mlFiltro, URL_FILTRO_PROM_ETAPAS);
	}else{
		clearCombosPromEtapas();
	}
}

private function listenerPromEtapas(event:ModuleEvent):void{
	//Alert.show("listenerPromEtapas");
	Application.application.mlDerechoReporte.child.mlFiltro.child.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePromEtapas);
}

private function onCreationCompletePromEtapas(event:FlexEvent):void{
	//Alert.show("onCreationCompletePromEtapas");
	setListTalleres();
	setListaMarcas();
	showGrafico();
}

private function clearCombosPromEtapas():void{
	Application.application.mlDerechoReporte.child.mlFiltro.child.cbTalleres.selectedIndex = -1;
	Application.application.mlDerechoReporte.child.mlFiltro.child.cbLocales.dataProvider = null;
	Application.application.mlDerechoReporte.child.mlFiltro.child.cbMarcas.selectedIndex = -1;
	showGrafico();
}

private function filtrosAll():void {	
	if(mlFiltro.url != URL_FILTRO_ALL){
		clearListener();
		mlFiltro.addEventListener(ModuleEvent.READY, listenerAll);
		Application.application.crearModulo(mlFiltro, URL_FILTRO_ALL);
	}else{
		clearCombosAll();
	}
}

private function listenerAll(event:ModuleEvent):void{
	//Alert.show("listenerAll");
	Application.application.mlDerechoReporte.child.mlFiltro.child.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteAll);
}

private function onCreationCompleteAll(event:FlexEvent):void{
	setListTalleres();
	setListaMarcas();
	setListaZonas();
	showGrafico();
}

private function clearCombosAll():void{
	clearCombosPromEtapas();
	Application.application.mlDerechoReporte.child.mlFiltro.child.cbZonas.selectedIndex = -1;
}

private function filtrosFechas():void {	
	if(mlFiltro.url != URL_FILTRO_FECHAS){
		clearListener();
		mlFiltro.addEventListener(ModuleEvent.READY, clearFechas);
		Application.application.crearModulo(mlFiltro, URL_FILTRO_FECHAS);
	}else{
		onCreationCompleteFechas();
	}
}

private function clearFechas(event:ModuleEvent = null):void{
	Application.application.mlDerechoReporte.child.mlFiltro.child.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteFechas);
}

private function onCreationCompleteFechas(event:FlexEvent = null):void{	
	var fechaActual:Date = new Date();
	var primerDiaMesActual:Date = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1);
	
	if(cboReportes.selectedItem.Rep == 6 || cboReportes.selectedItem.Rep == 10){
		Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate = new Date(fechaActual.getTime() - (86400000 * 30));
	}else{
		Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaInicio.selectedDate = primerDiaMesActual;
	}
	
	Application.application.mlDerechoReporte.child.mlFiltro.child.dtfFechaTermino.selectedDate = fechaActual;
	showGrafico();
}

private function showGrafico():void {
	if(cboReportes.selectedIndex != -1){
		switch(cboReportes.selectedItem.Rep){
			case 1:
				loadGraficoObservaciones();	
			break;
			case 3:
				loadGraficoGeneralIni();
			break;
			case 4:
				loadGraficoPromIni();
			break;
			case 5:
				loadGraficoPromedioMes();
			break;
			case 6:
				loadGraficoRanking();
			break;
			case 7:
				loadGraficoPromNotificaciones();
			break;
			case 8:
				loadGestionTaller();
			break;
			case 9:
				loadGraficoCambiosFecha();
			break;
			case 10:
				loadGraficoRanking20();
			break;
		}
	}
}


private function mostrarFiltros():void {
	if(cboReportes.selectedIndex != -1){
		switch(cboReportes.selectedItem.Rep){
			case 1:
			case 3:
			case 4:
				filtrosAll();
			break;
			case 5:
				filtrosPromEtapas();
			break;
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
				filtrosFechas();
			break;
		}
	}
}

private function formatoFechaInicio():String{
	return Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaInicio.label.substr(3,4) + "-" + Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaInicio.label.substr(0,2) + "-" + "01";
}

private function formatoFechaTermino():String{
	return Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaTermino.label.substr(3,4) + "-" + Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFechaTermino.label.substr(0,2) + "-" + "01";
}
// ActionScript file

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.mxml.WebService;

import talleresCompania2010.Modulos.Liquidador.Componente.comLiquidador;
import talleresCompania2010.Modulos.Liquidador.businessLogic.ModLiquidador;


import talleresCompania2010.util.IdiomaApp;

public var objModLiquidador:ModLiquidador;
public var Indice:int;

public var comPop:comLiquidador;
[Bindable]
public var listaLiquidadores:ArrayCollection;


public static const ACCION_INSERTAR:String="IN";
public static const ACCION_UPDATE:String="UP";
public static const ACCION_DELETE:String="DEL";


public function initMod():void{	
	
	objModLiquidador = new ModLiquidador(this); 
	listarLiquidadores();
}		

public function agregarLiquidador():void{	
	var comPopUp:comLiquidador = new comLiquidador();
	comPopUp.listaLiquidador = listaLiquidadores;
	comPopUp.Accion=ACCION_INSERTAR;
	comPopUp.Index=GridLiquidadores.selectedIndex;
	Application.application.createPopUpManager(comPopUp);
	comPopUp.BtnModificaLiquidador.enabled=false;
	comPopUp.title=IdiomaApp.getText('mod_liquidador_pop_title_agre');
}

public function eliminarLiquidador():void{
	var comPopUp:comLiquidador = new comLiquidador();
	comPopUp.listaLiquidador = listaLiquidadores;
	comPopUp.Accion=ACCION_DELETE;
	comPopUp.Index=GridLiquidadores.selectedIndex;
	if(GridLiquidadores.selectedIndex == -1 ){
  		Alert.show(IdiomaApp.getText('mod_liquidador_alert_selec_liq'));
  	}
  	else{
  		Application.application.createPopUpManager(comPopUp);
  		comPopUp.BtnAgregaLiquidador.label=IdiomaApp.getText('mod_liquidador_pop_title_eli');
  	}
}

public function modificarLiquidador():void{	
	var comPopUp:comLiquidador = new comLiquidador();	
	comPopUp.listaLiquidador = listaLiquidadores;
	comPopUp.Accion=ACCION_UPDATE;
	comPopUp.Index=GridLiquidadores.selectedIndex;
	comPopUp.personaSeleccionada=GridLiquidadores.selectedItem;
	if(GridLiquidadores.selectedIndex == -1 ){
  		Alert.show(IdiomaApp.getText('mod_liquidador_alert_selec_liq'),IdiomaApp.getText('mod_liquidador_pop_title_mod'));
  	}
  	else{
  		Application.application.createPopUpManager(comPopUp);
  		comPopUp.BtnAgregaLiquidador.enabled=false;
  		comPopUp.title=IdiomaApp.getText('mod_liquidador_pop_title_mod');
  	}			
}

public function DobleClickGrillaModificar():void{		   
	var comPopUp:comLiquidador = new comLiquidador();
	comPopUp.listaLiquidador = listaLiquidadores;
	comPopUp.Accion=ACCION_UPDATE;
	comPopUp.Index=GridLiquidadores.selectedIndex;
	comPopUp.personaSeleccionada=GridLiquidadores.selectedItem;
	if(GridLiquidadores.selectedIndex == -1 ){
  		Alert.show(IdiomaApp.getText('mod_liquidador_alert_selec_liq'),IdiomaApp.getText('mod_liquidador_pop_title_mod'));
  	}
  	else{
  		Application.application.createPopUpManager(comPopUp);
  		comPopUp.BtnAgregaLiquidador.enabled=false;
  		comPopUp.title=IdiomaApp.getText('mod_liquidador_pop_title_mod');
  	}	
}

public function modificarLiquidadorFinPopUp():void{			  
	var comPopUp:comLiquidador = new comLiquidador();	
	comPopUp.listaLiquidador = listaLiquidadores;
	comPopUp.Accion=ACCION_UPDATE;
	comPopUp.Index=GridLiquidadores.selectedIndex;
	Application.application.createPopUpManager(comPopUp);
	comPopUp.BtnAgregaLiquidador.label=IdiomaApp.getText('mod_liquidador_pop_title_mod');
}

public function listarLiquidadores():void{
	var parametros:Object=new Object();
	parametros.IDCompania = Application.application.idCompania;	
	var ws:WebService = Application.application.getWS("Liquidador2","OpMuestraLiqCia");	
	ws.OpMuestraLiqCia.resultFormat = "e4x";
	ws.OpMuestraLiqCia.send(parametros.IDCompania);
    ws.OpMuestraLiqCia.addEventListener("result", CargaLiquidadores);
    ws.OpMuestraLiqCia.addEventListener("fault", function(event:FaultEvent):void{
    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_liquidador_title_alert_lista'));
    });
}

public function CargaLiquidadores(event:ResultEvent):void{
	
	   if(event != null){
	   	listaLiquidadores=Application.application.XMLToArray(event);		
		GridLiquidadores.dataProvider=listaLiquidadores;
	   }
	   else{
	   	Alert.show(IdiomaApp.getText('mod_liquidador_alert_no_datos'),IdiomaApp.getText('mod_liquidador_title_alert_sin_reg'));
	   }
		
}
		
public function guardaCambios():void{
	var parametros:Object=new Object();	
	if( armaCadena() != ""){
		parametros.cadena=armaCadena();
	    var ws:WebService = Application.application.getWS("Liquidador2","OpAgreMod");
	    ws.OpAgreMod.send(parametros.cadena);
	    ws.OpAgreMod.resultFormat = "e4x";
	    ws.OpAgreMod.addEventListener("result", resultadoAM);
		ws.OpAgreMod.addEventListener("fault", function(event:FaultEvent):void{
		Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('mod_liquidador_title_alert_guarda'));
			    });		   
	   // Alert.show("Datos Ingresados","Guarda Cambios");
	    listarLiquidadores();
	}
	else{
		Alert.show(IdiomaApp.getText('mod_liquidador_alert_no_datos_mod'),IdiomaApp.getText('mod_liquidador_title_alert_guarda'));
	}	
}		

public function resultadoAM(event:ResultEvent):void{	
	var lista:ArrayCollection = Application.application.XMLToArray(event);
	if(lista[0].retorno == '0'){
		Alert.show(IdiomaApp.getText('mod_liquidador_alert_reg_creado'),IdiomaApp.getText('mod_liquidador_alert_title_ingresa'));
	}
	if(lista[0].retorno == '3'){
		Alert.show(IdiomaApp.getText('mod_liquidador_alert_reg_modificado'),IdiomaApp.getText('mod_liquidador_pop_title_mod'));
	}
	//Alert.show(ObjectUtil.toString(lista));
}
		
public function armaCadena():String{
	var cadenaLiquidador:String="";
	var i:int;
	//separador de campo #$#
	var sepC:String="#$#";
	//separador Liquidador
	var sepL:String="#|#";
	//separador valor
	var sepV:String="#:#";		
	if(listaLiquidadores != null ){
		for(i=0; i<listaLiquidadores.length; i++){		
  		var liquidador:Object = listaLiquidadores.getItemAt(i)
  		if(liquidador.cargado=="NO" && liquidador.accion=="IN"){
  			cadenaLiquidador+="id_persona"+sepV+liquidador.id_persona+sepC+
  							"nombre"+sepV+liquidador.nombre+sepC+
  							"apellido"+sepV+liquidador.apellido+sepC+
  							"celular"+sepV+liquidador.celular+sepC+
  							"email"+sepV+liquidador.email+sepC+
  							"fono"+sepV+liquidador.fono+sepC+
  							"cargado"+sepV+liquidador.cargado+sepC+
  							"accion"+sepV+liquidador.accion+sepC+
  							"id_per"+sepV+""+sepC+
  							"id_compania"+sepV+Application.application.idCompania+sepC+sepL;
  		}
  		if(liquidador.cargado=="NO" && liquidador.accion=="UP" ){
  			cadenaLiquidador+="id_persona"+sepV+liquidador.id_persona+sepC+
  							"nombre"+sepV+liquidador.nombre+sepC+
  							"apellido"+sepV+liquidador.apellido+sepC+
  							"celular"+sepV+liquidador.celular+sepC+
  							"email"+sepV+liquidador.email+sepC+
  							"fono"+sepV+liquidador.fono+sepC+
  							"cargado"+sepV+liquidador.cargado+sepC+
  							"accion"+sepV+liquidador.accion+sepC+
  							"id_per"+sepV+liquidador.id_per+sepC+
  							"id_compania"+sepV+Application.application.idCompania+sepC+sepL;
  		}  		
	  }	
	}
	
	//Alert.show(cadenaLiquidador);	
	return cadenaLiquidador;
}		

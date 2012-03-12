// ActionScript file
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.PopUpButton;
import mx.core.Application;
import talleresCompania2010.util.IdiomaApp;

//public var objModGeneradorRep:modGeneradorRep;
private var fechaActual:Date;
private var nuevaFecha:Date;
public var objPopUp:PopUpButton;

private function initCom():void{
	fechaActual = new Date();
	nuevaFecha = new Date();
	lblAnio.text = fechaActual.fullYear.toString();
	btnAtras.label = "<";
	btnSiguiente.label = ">";
	iniciarAnio(nuevaFecha);
	//objModGeneradorRep.popUpFecha.label = formaFechaInicial();
}

private function onClose():void{
	objPopUp.close();
}

private function enviarData(event:MouseEvent):void{
	objPopUp.label = formaFecha(event);
	this.onClose();
	//this.parentApplication.label = formaFecha(event);
	//Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFecha.label = formaFecha(event);
	//Application.application.mlDerechoReporte.child.mlFiltro.child.popUpFecha.close();
}

private function lastYear():void{
	nuevaFecha = new Date();
	if(fechaActual.fullYear == nuevaFecha.fullYear){
		habilitaBotones();
	}
 	fechaActual.setFullYear(fechaActual.fullYear - 1);
	lblAnio.text = String(fechaActual.fullYear);
}

private function nextYear():void{
	nuevaFecha = new Date();
	if(fechaActual.fullYear != nuevaFecha.fullYear){
		fechaActual.setFullYear(fechaActual.fullYear + 1);
		lblAnio.text = String(fechaActual.fullYear);
		iniciarAnio(nuevaFecha);
	}
 	
}

private function iniciarAnio(nuevaFecha:Date):void{
	if(fechaActual.fullYear == nuevaFecha.fullYear){
		switch(nuevaFecha.month){
			case 0:
				btnFebrero.visible = false;
				btnMarzo.visible = false;
				btnAbril.visible = false;
				btnMayo.visible = false;
				btnJunio.visible = false;
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 1:
				btnMarzo.visible = false;
				btnAbril.visible = false;
				btnMayo.visible = false;
				btnJunio.visible = false;
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 2:
				btnAbril.visible = false;
				btnMayo.visible = false;
				btnJunio.visible = false;
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 3:
				btnMayo.visible = false;
				btnJunio.visible = false;
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 4:
				btnJunio.visible = false;
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 5:
				btnJulio.visible = false;
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 6:
				btnAgosto.visible = false;
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 7:
				btnSeptiembre.visible = false;
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 8:
				btnOctubre.visible = false;
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 9:
				btnNoviembre.visible = false;
				btnDiciembre.visible = false;
			break;
			case 10:
				btnDiciembre.visible = false;
			break;
			default:
				habilitaBotones();
			break;
		}
	}else{
		habilitaBotones();
	}
}

private function habilitaBotones():void{
	btnEnero.visible = true;
	btnFebrero.visible = true;
	btnFebrero.visible = true;
	btnMarzo.visible = true;
	btnAbril.visible = true;
	btnMayo.visible = true;
	btnJunio.visible = true;
	btnJulio.visible = true;
	btnAgosto.visible = true;
	btnSeptiembre.visible = true;
	btnOctubre.visible = true;
	btnNoviembre.visible = true;
	btnDiciembre.visible = true;
}


private function buscaNumeroMes(event:MouseEvent):int{
	var mes:int = 0;
	var arrBotones:ArrayCollection = new ArrayCollection([{boton:"btnEnero", numero:1},
														  {boton:"btnFebrero", numero:2},
														  {boton:"btnMarzo", numero:3},
														  {boton:"btnAbril", numero:4},
														  {boton:"btnMayo", numero:5},
														  {boton:"btnJunio", numero:6},
														  {boton:"btnJulio", numero:7},
														  {boton:"btnAgosto", numero:8},
														  {boton:"btnSeptiembre", numero:9},
														  {boton:"btnOctubre", numero:10},
														  {boton:"btnNoviembre", numero:11},
														  {boton:"btnDiciembre", numero:12}
														  ]);
	
	for(var i:int = 0; i < arrBotones.length; i++){
		if(event.target.toString().indexOf(arrBotones[i].boton) != -1){
			mes = arrBotones[i].numero;
		}
	}
	
	return mes;
}


private function formaFecha(event:MouseEvent):String{
	var mes:String = buscaNumeroMes(event).toString();
	if(mes.length < 2){
		mes = "0" + mes;
	}
	return mes + "/" + lblAnio.text;
}
// ActionScript file
import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.Modulos.modNotificarComentario;
import talleresCompania2010.businessLogic.Bitacora;

import talleresCompania2010.util.IdiomaApp;

private var ObjBitacora:Bitacora;
private var objNotiComentario:modNotificarComentario;

private function initMod():void {
	ObjBitacora = new Bitacora(this);
}

private function addComment(event:Event):void {
	if(txAreaComment.text != ""){
		ObjBitacora.sendComentario();
		if (checkNotificar.selected){
			objNotiComentario = new modNotificarComentario();
			objNotiComentario.comentario = txAreaComment.text;
			Application.application.createPopUpManager(objNotiComentario);
		}
	}else{
		Alert.show(IdiomaApp.getText('mod_bitacora_alert_ingresa_comentario'),IdiomaApp.getText('mod_bitacora_alert_ingresa_comentario_alert'));
		return;
	}	
	txAreaComment.text="";
}

public function reloadBitacora():void {
	ObjBitacora.solBitacora();
}
// ActionScript file
import com.hillelcoren.utils.StringUtils;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ItemClickEvent;
import mx.managers.PopUpManager;

import talleresCompania2010.businessLogic.NotificarDocumento;
import talleresCompania2010.util.IdiomaApp;

private var ObjNotificar:NotificarDocumento;
private var patente:String;
private var tipoMail:String = "8";
public var documentos:String;

private function initMod():void {
	ObjNotificar = new NotificarDocumento(this);
	
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
}

private function cerrarDialog(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		closePopUp();
	} 
}

public function setPatente(patente:String): void {
	this.patente = patente;
}
public function setPara(para:String): void {
	this.txMails.text = para;
}

public function set mailCargar(_mailCargar:String):void{
	tipoMail = _mailCargar;
}

public function get mailCargar():String{
	return tipoMail;
}

public function getPatente(): String {
	return this.patente;
}

private function mostrarAsunto(event:ItemClickEvent):void {
	if(event.label == IdiomaApp.getText('mod_notificar_documento_perso')){
		txAsunto.visible = true;
	}else
		txAsunto.visible = false;
}

public function closePopUp():void {
	PopUpManager.removePopUp(this);
}

public function closePopUpTEMP(event:CloseEvent):void {
	if(event.detail == Alert.NO){
		//Sigue mostrando el PopUp
	}else{
		PopUpManager.removePopUp(this);
	}
}

private function aviso(event:MouseEvent):void {
	btnSendMail.enabled = false;
	ObjNotificar.sendMail();
//	Alert.show("Modo piloto, no se envía ningún eMail.","Aviso",4,null,closePopUpTEMP);
}
private function dropDownLabelFunction( item:Object ):String
{
	var string:String = item.Correo;
	var searchStr:String = txtCC.searchText;
	
	var returnStr:String = StringUtils.highlightMatch( string, searchStr );
	
	if (txtCC.selectedItems.getItemIndex( item ) >= 0)
	{
		returnStr = "<font color='" + Consts.COLOR_TEXT_DISABLED + "'>" + returnStr + "</font>";
	}
	
	return returnStr;
}

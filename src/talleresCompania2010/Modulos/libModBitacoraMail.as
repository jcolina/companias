// ActionScript file
import mx.controls.Alert;
import mx.managers.PopUpManager;

import talleresCompania2010.businessLogic.MailBitacora;
import talleresCompania2010.util.IdiomaApp;

public static var objBitacoraMails:MailBitacora;

public function initModBitacora():void{
	objBitacoraMails = new MailBitacora(this);
}

public function reloadBitacoraMail():void {
	objBitacoraMails.cargarServices();
}
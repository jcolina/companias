import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.util.IdiomaApp;
import talleresCompania2010.businessLogic.Opciones;


import talleresCompania2010.util.IdiomaApp;
private var ObjOp:Opciones;


private function initMod():void {	
	ObjOp = new Opciones(this);
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarDialog);
}

private function actualizarDatos():void{
	if(txtActualPass.text != "" || txtNewPass.text != "" || txtReNewPass.text != ""){		
		if(txtActualPass.text == ""){
			Alert.show(IdiomaApp.getText('mod_opciones_ingresa_antigua'), IdiomaApp.getText('general_aviso_title'));
		}else{
			if(txtNewPass.text == ""){
				Alert.show(IdiomaApp.getText('mod_opciones_ingresa_nueva'), IdiomaApp.getText('general_aviso_title'));
			}else{
				if(txtReNewPass.text == ""){
					Alert.show(IdiomaApp.getText('mod_opciones_reingresa_nueva'), IdiomaApp.getText('general_aviso_title'));
				}else{
					if(Application.application.encriptarBase64(txtActualPass.text) != Application.application.pass){
						Alert.show(IdiomaApp.getText('mod_opciones_contra_no_corresponde'), IdiomaApp.getText('general_error'));
					}else{
						if(txtNewPass.text != txtReNewPass.text){
							Alert.show(IdiomaApp.getText('mod_opciones_contra_no_corresponde_coinciden'), IdiomaApp.getText('general_aviso_title'));
						}else{
							ObjOp.IsUpdatePass = true;
							ObjOp.actualizarDatos();
						}						
					}
				}
			}
		}
	}else{
		ObjOp.IsUpdatePass = false;
		ObjOp.actualizarDatos();
	}	
}

private function cerrarDialog(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		Application.application.closePopUp(this);
	} 
}

private function formatoCelular():void{
	Application.application.formatoCelular(txtCelular);
}

private function sacarPuntosCelular():void{
	txtCelular.text = Application.application.formatoPuntos(txtCelular.text);
}

// ActionScript file
import Notificacion.com.notifications.Notification;

import flash.events.MouseEvent;

import mx.core.Application;
import mx.controls.Alert;

import talleresCompania2010.businessLogic.Email;
import talleresCompania2010.businessLogic.UpDocumento;
import talleresCompania2010.util.Validar;
import talleresCompania2010.util.IdiomaApp;

//private const categoriasDoc:Array = ["Acta de entrega","Factura", "Presupuesto", "Fotos", "Denuncio","Otros"];
private var ObjUpDoc:UpDocumento;
private var patente:String;
private var tipoMail:String="";
// Initalize
private function initApp():void {
	ObjUpDoc = new UpDocumento(this);
	this.addEventListener(KeyboardEvent.KEY_DOWN, cerrarWin);
	this.parentApplication.addEventListener(KeyboardEvent.KEY_DOWN, cerrarWin);
	comUpFile.objUpDocumentos = this;
}

public function cerrarDialog():void{
	Application.application.closePopUp(this);
}

private function cerrarWin(event:KeyboardEvent):void{
	if (event.keyCode == 27){
		cerrarDialog();
	} 
}

public function validarDatos():Boolean{
	var arrCampos:Array = [vlCategoria, vlTitulo];
	var validador:Validar= new Validar();
	
	if (!validador.validarCampos(arrCampos, IdiomaApp.getText('mod_up_documentos_val_faltan'))){
		return false;
	}
	return true;
}


private function mostrarMail(event:MouseEvent):void {
  	if(CheckBox(event.currentTarget).selected){
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_gestor_taller') ){
			txGestorTaller.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_compania') ){
			txCompania.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('Liquidador')){
			txLiquidador.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_yo') ){
			txYo.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
			if(CheckBox(event.currentTarget).label ==  IdiomaApp.getText('general_recepcionista') ){
			txRecepcionista.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
	}else{
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_gestor_taller') ){
			txGestorTaller.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_compania')){
			txCompania.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('Liquidador')){
			txLiquidador.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_yo') ){
			txYo.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_recepcionista') ){
			txRecepcionista.text = "";
			return;
		}
	}
}

private function mandaMail():void{
	if(chkCompania.selected == false && chkGestorTaller.selected == false
		&& chkLiquidador.selected == false && chkYo.selected == false && chkRecepcionista == false){
		Notification.show(IdiomaApp.getText('mod_up_documentos_not_cargado'),IdiomaApp.getText('general_documentos'));
	}else{
		var docs:String = IdiomaApp.getText('mod_up_documentos_tipo')+" " + cbCategoria.text + "\n" +
							IdiomaApp.getText('mod_up_documentos_documento')+" " + txTitulo.text;
		docs +="\n" + IdiomaApp.getText('mod_up_documentos_archivos')+" " + "\n";
		//Alert.show(ObjectUtil.toString(comUpFile.listFiles.dataProvider));
 		for (var i:int = 0; i < comUpFile.listFiles.dataProvider.length; i++){
			docs += comUpFile.listFiles.dataProvider[i].name+" ";
			docs += comUpFile.listFiles.dataProvider[i].size;
			
			if((i + 1) < comUpFile.listFiles.dataProvider.length){
				docs += "\n";
			}
		}
		
		if(docs.length >= 500){
			docs = docs.substr(0, 500) + "\n" + IdiomaApp.getText('mod_up_documentos_mas_documentos');
		}
		
		Application.application.documentos = docs + Email.ENTER;
		ObjUpDoc.abrirNotificacion();
	}
	
	
	Application.application.ObjVehiculo.Documentos = "SI";
	Application.application.updateVehiculo(Application.application.ObjVehiculo);
	Application.application.updateModBitacora();
	
}

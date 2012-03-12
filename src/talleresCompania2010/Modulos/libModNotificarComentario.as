// ActionScript file
import com.hillelcoren.utils.StringUtils;

import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

import talleresCompania2010.businessLogic.NotificarComentario;
import talleresCompania2010.util.IdiomaApp;

private var ObjNotificar:NotificarComentario;
private var patente:String;
private var tipoMail:String="";
public var comentario:String;

private function initMod():void {
	ObjNotificar = new NotificarComentario(this);
}

private function mostrarMail(event:MouseEvent):void {
  	if(CheckBox(event.currentTarget).selected){
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('mod_notificar_gestor_taller') ){
			txGestorTaller.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_compania')  ){
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
			if(CheckBox(event.currentTarget).label == IdiomaApp.getText("general_recepcionista")){
			txRecepcionista.text = CheckBox(event.currentTarget).selectedField;
			return;
		}
	}else{
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('mod_notificar_gestor_taller') ){
			txGestorTaller.text = ""; 
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_compania')  ){
			txCompania.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('Liquidador')){
			txLiquidador.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText('general_yo')){
			txYo.text = "";
			return;
		}
		if(CheckBox(event.currentTarget).label == IdiomaApp.getText("general_recepcionista")){
			txRecepcionista.text = "";
			return;
		}
	}
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

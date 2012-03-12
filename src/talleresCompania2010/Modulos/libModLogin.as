// ActionScript file

import flash.system.Capabilities;

import mx.core.Application;

import talleresCompania2010.businessLogic.Login;
import talleresCompania2010.util.Analytic;
import talleresCompania2010.util.IdiomaAppBrowser;
import talleresCompania2010.util.PopUpAyuda;

private var LoginObj:Login;

private function initMod():void {
	LoginObj = new Login(this);
	Analytic.getInstance().trackPageview("Login");
	Analytic.getInstance().trackPageview("Vehículos");
	cargarDefaultText();

}

private function sendLogin():void {
	LoginObj.sendLogin();
}

private function onMouseOver():void {
	lblAyuda.setStyle("color", 0x85ebf7);
}

private function onMouseOut():void {
	lblAyuda.setStyle("color", 0xffffff);
}

private function abrirReporteError():void {
	PopUpAyuda.show();
	//Analytic.getInstance().trackPageview("Login");
}


private function setTextosApplication():void {
	//Application.application.lnkAyuda.toolTip = IdiomaAppBrowser.getText('principal_ayuda');
	Application.application.lnklogout.toolTip = IdiomaAppBrowser.getText('principal_finalizar_sesion');
	//Application.application.lblSoporte.text = IdiomaAppBrowser.getText('principal_lbl_soporte');
	Application.application.lnkSoporte.label = IdiomaAppBrowser.getText('mod_login_lbl_soporte');
	Application.application.cvVehiculos.label = IdiomaAppBrowser.getText('aplication_tab_vehiculo');
	Application.application.cvAgenda.label = IdiomaAppBrowser.getText('aplication_tab_agenda');
	Application.application.cvTabReporte.label = IdiomaAppBrowser.getText('aplication_tab_reportes');
	Application.application.cvTabFactura.label = IdiomaAppBrowser.getText('aplication_tab_factura');
	Application.application.cvLiquidador.label = IdiomaAppBrowser.getText('aplication_tab_liquidador');
	
	panel.title = IdiomaAppBrowser.getText('mod_login_panel_title');
	lblUsuario.text = IdiomaAppBrowser.getText('mod_login_lbl_usuario');
	lblPass.text = IdiomaAppBrowser.getText('mod_login_lbl_pass');
	txlogin.name = IdiomaAppBrowser.getText('mod_login_txt_usuario');
	txpassword.name = IdiomaAppBrowser.getText('mod_login_txt_pass');
	btnLogin.label = IdiomaAppBrowser.getText('mod_login_boton_ingresar');
	chkStored.label = IdiomaAppBrowser.getText('mod_login_check_recordar');
	lblAyuda.text = IdiomaAppBrowser.getText('mod_login_lbl_soporte');
	validUser.requiredFieldError = IdiomaAppBrowser.getText('mod_login_vl_usuario');
	validPass.requiredFieldError = IdiomaAppBrowser.getText('mod_login_vl_pass');
	
}

private function cargarDefaultText():void {
	var paisIdioma:String;
	if (Capabilities.language.toString().toUpperCase().indexOf("PT") != -1){
		paisIdioma = "Brazil";
	}else{
		paisIdioma = "Chile";
	}
	new IdiomaAppBrowser(paisIdioma, setTextosApplication);
}
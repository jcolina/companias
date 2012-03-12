// ActionScript file

// ***Solución Error***
import mx.managers.HistoryManager;
private var hist:HistoryManager;
import mx.managers.IDragManager;
import flash.system.System;
private var iDragManager:IDragManager;
// *** Fin ***
import talleresCompania2010.util.IdiomaAppBrowser;

import talleresCompania2010.util.IdiomaApp;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import mx.controls.Alert;
import mx.modules.ModuleLoader;
import alfresco.webscript.FailureEvent;
import alfresco.webscript.SuccessEvent;
import alfresco.webscript.WebScriptService;
import mx.controls.Alert;
import mx.core.Application;
import mx.utils.ObjectUtil;
import mx.events.ListEvent;
import talleresCompania2010.Modulos.modTareas;
import flash.display.DisplayObject;
import talleresCompania2010.Modulos.modAsignarTarea;
import mx.managers.PopUpManager;
import talleresCompania2010.Modulos.modPrincipal;
import talleresCompania2010.Modulos.modBitacora;
import talleresCompania2010.Modulos.modListaTareas;
import talleresCompania2010.Modulos.modDatosContacto;
import mx.events.ItemClickEvent;
import mx.formatters.SwitchSymbolFormatter;
import flash.events.MouseEvent;
import mx.core.IFlexDisplayObject;
import mx.rpc.http.mxml.HTTPService;
import mx.rpc.events.ResultEvent;
import talleresCompania2010.Modulos.modOpciones;
import mx.events.CloseEvent;
import mx.containers.TitleWindow;
import talleresCompania2010.Modulos.modDerechoMain;
//import talleresCompania2010.util.WSHeaderSecurity;
import mx.collections.ArrayCollection;
import mx.utils.ObjectUtil;
import mx.utils.ArrayUtil;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.rpc.soap.mxml.WebService;
import talleresCompania2010.Modulos.modBitacoraMail;
import mx.utils.Base64Encoder;
import mx.utils.Base64Decoder;
import talleresCompania2010.util.IdiomaAplicacion;
import talleresCompania2010.util.WSHeaderSecurity;
import mx.controls.PopUpButton;
import talleresCompania2010.Modulos.Documentos.Componentes.comVisorImagen;
import talleresCompania2010.Modulos.Documentos.modGeneral;
import talleresCompania2010.util.Validar;
import mx.rpc.events.FaultEvent;
import talleresCompania2010.Modulos.Factura.modFacturaPrincipal;
import mx.managers.IBrowserManager;
import mx.utils.URLUtil;
import mx.managers.BrowserManager;
import talleresCompania2010.util.Analytic;
import mx.events.EffectEvent;
import mx.states.SetStyle;

private var _objIdiomaAplicacion:IdiomaApp;

//Definicion de constantes para la aplicacion
public const COMENTARIO:String = "3";
public const CARGA_DOCUMENTO:String = "8";
public const INGRESO_SOLICITUD:String = "16";
public const FINALIZAR_SOLICITUD:String = "17";
public const TALLER_DEFAULT:String = "0";
public const COMPANIA_DEFAULT:String = "0";
public const DIAS_CALENDARIO:Array = ['Do','Lu','Ma','Mi','Ju','Vi','Sa'];
public const MESES_CALENDARIO:Array = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo','Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre','Diciembre'];

//URL servicios
private var dataXML:XMLList;
private var urlService:XML;
private var urlServiceWsas:XML;
private var urlServiceLotus:XML;
private var urlServiceAlfresco:XML;

//Objetos de datos
private var _ObjDatosSolicitud:Object;
private var _ObjDatosLogin:Object;
private var _ObjDatosContacto:Object;
private var _ObjVehiculo:Object;
private var _ObjDatosFactura:Object;
private var _ObjDatosUrl:Object;
//Listas que se cargan una vez, se mantienen para no realizar muchas llamadas a servicios
private var _listaDocumentos:ArrayCollection;
private var _listaTareas:ArrayCollection;
//objetos de aplicación principal
private var _objComVisorImagen:comVisorImagen;

private var _idUsuario:int;
private var _idCompania:int
private var _rut:String;
private var _nombre:String;
private var _apellido:String;
private var _celular:String;
private var _email:String;
private var _user:String;
private var _pass:String;
private var _Pais:String;
private var listMailXMLDefault:XMLList;
public var taller:String;
public var local:String;
private var _isCargadoPrincipal:Boolean;
private var _isCargadoAgenda:Boolean;
private var _isCargadoReporte:Boolean;
private var ObjModOpciones:modOpciones;
private var WSSecurity:WSHeaderSecurity;
private var _tareasAsignadas:ArrayCollection;
private var _documentos:String;
//private var _objIdiomaAplicacion:IdiomaAplicacion;
private var _ticket:String;
private var _objBotonPopUp:PopUpButton;
private var _objBotonPopUp2:PopUpButton;
private var _objBotonPopUpDetalle:PopUpButton;
public var _tabPosition:int;
private var _parametrosCorreo:String;




	public function set objIdiomaAplicacion(_objIdiomaAplicacion:IdiomaApp):void{
		this._objIdiomaAplicacion = _objIdiomaAplicacion;	
	}
	
	public function get objIdiomaAplicacion():IdiomaApp{
		return this._objIdiomaAplicacion;
	}
	
	public function get parametrosCorreo():String{
		return this._parametrosCorreo;
	}
	
	public function set parametrosCorreo(_parametrosCorreo:String):void {
		this._parametrosCorreo = _parametrosCorreo;
	}

	public function set listaTareas(_listaTareas:ArrayCollection):void {
		this._listaTareas = _listaTareas;
	}
	
	public function get listaTareas():ArrayCollection {
		return this._listaTareas;
	}
	
	public function set tabPosition(_tabPosition:int):void {
		this._tabPosition = _tabPosition;
	}
	
	public function get tabPosition():int {
		return _tabPosition;
	} 
	
	public function get objComVisorImagen():comVisorImagen{
		return this._objComVisorImagen;
	}
	public function set objComVisorImagen(_objComVisorImagen:comVisorImagen):void {
		this._objComVisorImagen = _objComVisorImagen;
	}
	
	public function get ticket():String{
		return this._ticket;
	}
	public function set ticket(_ticket:String):void {
		this._ticket = _ticket;
	}

	public function set objWSSecurity(_objWSSecurity:WSHeaderSecurity):void{
		this.WSSecurity = _objWSSecurity;	
	}
	
	public function get objWSSecurity():WSHeaderSecurity{
		return this.WSSecurity;
	}

	
	public function set documentos(documentos:String):void{
		this._documentos = documentos;	
	}
	
	public function get documentos():String{
		return this._documentos;
	}

	public function set tareasAsignadas(listaTareasAsig:ArrayCollection):void{
		this._tareasAsignadas = listaTareasAsig;
	}
	
	public function get tareasAsignadas():ArrayCollection{
		return this._tareasAsignadas;
	}
	
	public function set idUsuario(idUsuario:int):void {
		this._idUsuario = idUsuario;
	}
	
	public function get idUsuario():int {
		return _idUsuario;
	}
	
 	public function set ObjVehiculo(ObjVehiculo:Object):void {
		this._ObjVehiculo = ObjVehiculo;
	} 
	
 	public function get ObjVehiculo():Object {
		return _ObjVehiculo;
	} 
	
	public function set ObjDatosContacto(_ObjDatosContacto:Object):void{
		this._ObjDatosContacto = _ObjDatosContacto;	
	}
	
	public function get ObjDatosContacto():Object{
		return this._ObjDatosContacto
	}
	
	public function set ObjDatosLogin(_ObjDatosLogin:Object):void{
		this._ObjDatosLogin = _ObjDatosLogin;	
	}
	
	public function get ObjDatosLogin():Object{
		return this._ObjDatosLogin;
	}
	
	public function set ObjDatosSolicitud(_ObjDatosSolicitud:Object):void{
		this._ObjDatosSolicitud = _ObjDatosSolicitud;	
	}
	
	public function get ObjDatosSolicitud():Object{
		return this._ObjDatosSolicitud;
	}
	
	public function set ObjDatosFactura(_ObjDatosFactura:Object):void{
		this._ObjDatosFactura = _ObjDatosFactura;	
	}
	
	public function get ObjDatosFactura():Object{
		return this._ObjDatosFactura;
	}
	
	public function set ObjDatosUrl(_ObjDatosUrl:Object):void {
		this._ObjDatosUrl = _ObjDatosUrl;
	} 
	
 	public function get ObjDatosUrl():Object {
		return _ObjDatosUrl;
	} 
	
	public function set idCompania(idCompania:int):void {
		this._idCompania = idCompania;
	}
	
	public function get idCompania():int {
		return this._idCompania;
	}
	
	public function set rut(rut:String):void {
		this._rut = rut;
	}
	
	public function get rut():String {
		return this._rut;
	}
	
	public function set nombre(nombre:String):void {
		this._nombre = nombre;
	}
	
	public function get nombre():String {
		return this._nombre;
	}
	
	public function set apellido(apellido:String):void {
		this._apellido = apellido;
	}
	
	public function get apellido():String {
		return this._apellido;
	}
	
	public function set celular(celular:String):void {
		this._celular = celular;
	}
	
	public function get celular():String {
		return this._celular;
	}
	
	public function set email(email:String):void {
		this._email = email;
	}
	
	public function get email():String {
		return this._email;
	}
	
	public function set user(user:String):void {
		this._user = user;
	}
	
	public function get user():String {
		return this._user;
	}
	
	public function set pass(pass:String):void {
		this._pass = pass;
	}
	
	public function get pass():String {
		return this._pass;
	}
	
	public function set Pais(_Pais:String):void {
		this._Pais = _Pais;
	}
	
	public function get Pais():String {
		return this._Pais;
	}
	
	public function set listaDocumentos(_listaDocumentos:ArrayCollection):void {
		this._listaDocumentos = _listaDocumentos;
	}
	
	public function get listaDocumentos():ArrayCollection {
		return this._listaDocumentos;
	}
	
	public function set isCargadoPrincipal(isCargadoPrincipal:Boolean):void {
		this._isCargadoPrincipal = isCargadoPrincipal;
	}
	
	public function get isCargadoPrincipal():Boolean {
		return _isCargadoPrincipal;
	}
	
	public function set isCargadoAgenda(isCargadoAgenda:Boolean):void {
		this._isCargadoAgenda = isCargadoAgenda;
	}
	
	public function get isCargadoAgenda():Boolean {
		return _isCargadoAgenda;
	}
	
	public function set isCargadoReporte(isCargadoReporte:Boolean):void {
		this._isCargadoReporte = isCargadoReporte;
	}
	
	public function get isCargadoReporte():Boolean {
		return _isCargadoReporte;
	} 
	
	private function cargarData():void {
		try {
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest("data/dataService.xml"));
         	loader.addEventListener(Event.COMPLETE, loaderService, false, 0, true);	         	
        }catch (error:Error) {
          	Alert.show(IdiomaAppBrowser.getText("application_problamas_carga_archi"));
        }
	}

	private function initApp():void {
		cargarData();
		this.objWSSecurity = new WSHeaderSecurity();
	}
	
	private function setUrl():void {
		var bm:IBrowserManager;
		bm = BrowserManager.getInstance();		
		this.ObjDatosUrl = URLUtil.stringToObject(this.desencriptarBase64(bm.fragment), "&");
	}
		
	private function loaderService(event:Event):void {
		dataXML = XMLList(event.target.data);
		urlService = XML(dataXML.child("urlServer"));
		urlServiceWsas = XML(dataXML.child("urlServerWsas"));
		urlServiceLotus = XML(dataXML.child("urlServerLotus"));
		urlServiceAlfresco = XML(dataXML.child("urlServerAlfresco"));
	}
		
	private function loadXMLMailDefault(event:Event):void{
		listMailXMLDefault = XMLList(event.target.data);
	}	
		
	public function getUrlServer(nameService:String):String{
		return dataXML.child(nameService).toString();
	}	
	
	public function getUrlService(service:String):String {
		return urlService.toString() + dataXML.child("service").(attribute("name") == service).toString();
	}
	
	public function getUrlServiceWsas(service:String):String{
		return urlServiceWsas.toString() + dataXML.child("service").(attribute("name") == service).toString();
	}
	
	public function getUrlServiceAlfresco(service:String):String{
		return urlServiceAlfresco.toString() + dataXML.child("service").(attribute("name") == service).toString();
	}
	
	public function getUrlServiceLotus(service:String):String {			
		return urlServiceLotus.toString() + dataXML.child("service").(attribute("name") == service).toString();
	}
	
	public function getOnlyService(service:String):String {
		return dataXML.child("service").(attribute("name") == service).toString();
	}
	
	public function getOnlyServiceEsb(service:String):String {
		return urlService.toString() + dataXML.child("service").(attribute("name") == service).toString();
	}
		
	
	
	public function crearModulo(mod:ModuleLoader, url:String):void {
		if(mod != null){
			if(mod.url){
				mod.unloadModule();
			}
		}
		
		mod.url = url;
		mod.loadModule();
	}
	
	public function removerModulo(mod:ModuleLoader):void {
		mod.unloadModule();
	}
	
	public function loginCorrecto():void {
		mlModLogin.unloadModule();
		hdPanelSuperior.visible = true;
		hdPanel.visible = true;
		crearModulo(mlPrincipal, "talleresCompania2010/Modulos/modPrincipal.swf");
	//	crearModulo(mlDerecho, "talleresCompania2010/Modulos/modTareas.swf");
		crearModulo(mlDerecho, "talleresCompania2010/Modulos/modDerechoMain.swf");
		isCargadoPrincipal = true;
		loginAlfresco();
		cvLiquidador.label = IdiomaApp.getText('Liquidador');
		
	}
	
	public function showTareas():void {
		var ObjModTareas:modTareas = modTareas(modDerechoMain(mlDerecho.child).mlTareas.child);
//		ObjModTareas.loadModulo(ObjModTareas.mlModTareas, "talleresCompania2010/Modulos/modAsignarTarea.swf");
		ObjModTareas.loadModulo(ObjModTareas.mlModTareas2, "talleresCompania2010/Modulos/modListaTareas.swf");
		ObjModTareas.loadModulo(ObjModTareas.mlModTareas3, "talleresCompania2010/Modulos/modBitacora.swf");
		ObjModTareas.loadModulo(ObjModTareas.mlModTareas5, "talleresCompania2010/Modulos/modBitacoraMail.swf");
		ObjModTareas.loadModulo(ObjModTareas.mlModTareas4, "talleresCompania2010/Modulos/modDatosContacto.swf");
		
		var ObjModDerechoMain:modDerechoMain = modDerechoMain(mlDerecho.child);
		ObjModDerechoMain.loadModulo(ObjModDerechoMain.mlDocumentos, "talleresCompania2010/Modulos/Documentos/modGeneral.swf");
	}
	
	public function reloadListaDocumentos():void{
		var ObjModDerechoMain:modDerechoMain = modDerechoMain(mlDerecho.child);		
		crearModulo(ObjModDerechoMain.mlDocumentos, "talleresCompania2010/Modulos/Documentos/modGeneral.swf");
		//this.tabPosition = tabPosition;
	}
	
	public function updateModListTask():void {
		var ObjModTareas:modTareas = modTareas(modDerechoMain(mlDerecho.child).mlTareas.child);
		if(ObjModTareas.mlModTareas2.child is modListaTareas){
			modListaTareas(ObjModTareas.mlModTareas2.child).reloadTask();
			ObjModTareas.tabTareas.selectedIndex = 1;
		}
	}

	public function updateModBitacora():void {
		var ObjModTareas:modTareas = modTareas(modDerechoMain(mlDerecho.child).mlTareas.child);
		if(ObjModTareas.mlModTareas3.child is modBitacora){
			modBitacora(ObjModTareas.mlModTareas3.child).reloadBitacora();
		}
	}
	
	public function updateModBitacoraMail():void {
		var ObjModTareas:modTareas = modTareas(modDerechoMain(mlDerecho.child).mlTareas.child);
		if(ObjModTareas.mlModTareas5.child is modBitacoraMail){
			modBitacoraMail(ObjModTareas.mlModTareas5.child).reloadBitacoraMail();
		}
	}
	
	public function updateGrillaPrincipal():void {
		modPrincipal(mlPrincipal.child).updateGrilla();
//		modPrincipal(mlPrincipal.child).
	}
	
	public function updateGrillaFactura():void {
		modFacturaPrincipal(mlFacturaPrincipal.child).cargarGrilla();
	}
	
	public function updateVehiculo(objVehiculo:Object):void{
		modPrincipal(mlPrincipal.child).updateItem(objVehiculo);
	}
	
	public function unloadModsTareas():void {
		var ObjModTareas:modTareas = modTareas(modDerechoMain(mlDerecho.child).mlTareas.child);
		ObjModTareas.unloadAllMods();
	}
	
	public function descargarAllDocumentos():void {
		var objModGeneral:modGeneral = modGeneral(modDerechoMain(mlDerecho.child).mlDocumentos.child);
		
		if(objModGeneral != null){
			removerModulo(objModGeneral.mdlDocumentos);
			removerModulo(objModGeneral.mdlImagenes);
			removerModulo(objModGeneral.mdlSolicitudes);
		}
	}
	
	public function seleccionTab(e:Event):void{
		try{
			var almacenaIndex:String = e.currentTarget.selectedIndex;
	         switch (almacenaIndex) {
	            case "0":
	    			if(!isCargadoPrincipal){
	                    crearModulo(mlPrincipal, "talleresCompania2010/Modulos/modPrincipal.swf");
						crearModulo(mlDerecho, "talleresCompania2010/Modulos/modTareas.swf");
						isCargadoPrincipal = true;
	        		}
	        		this.infolb.visible = true;
	        		Analytic.getInstance().trackPageview("Vehículos");
                break;
	            case "1":
            		//if(!isCargadoAgenda){
                     crearModulo(mlAgenda, "talleresCompania2010/Modulos/Agenda/modAgenda.swf");
	                     //isCargadoAgenda = true;
              		//}
              		this.infolb.visible = false;
              		Analytic.getInstance().trackPageview("Agenda");
                break;
	            case "2":
            		//if(!isCargadoReporte){
                 	crearModulo(mlDerechoReporte, "talleresCompania2010/Modulos/Reportes/modGeneradorRep.swf");
                     	//isCargadoReporte = true;
              		//}
              		this.infolb.visible = false;
              		Analytic.getInstance().trackPageview("Reportes");
                 break;
                 case "3":
            		//if(!isCargadoReporte){
                 	crearModulo(mlFacturaPrincipal, "talleresCompania2010/Modulos/Factura/modFacturaPrincipal.swf");
                 	crearModulo(mlFacturaOpciones, "talleresCompania2010/Modulos/Factura/modFacturaOpciones.swf");
                 	crearModulo(mlFacturaDerecho, "talleresCompania2010/Modulos/Factura/modFacturaInterfaz.swf");
                     	//isCargadoReporte = true;
              		//}
              		this.infolb.visible = false;
              		Analytic.getInstance().trackPageview("Facturas");
                 break;
                   case "4":
            		//if(!isCargadoReporte){
                 	crearModulo(mlLiquidadorPrincipal, "talleresCompania2010/Modulos/Liquidador/modLiquidadorPrincipal.swf");
                 	//crearModulo(mlFacturaOpciones, "talleresCompania2010/Modulos/Factura/modFacturaOpciones.swf");
                 	//crearModulo(mlFacturaDerecho, "talleresCompania2010/Modulos/Factura/modFacturaInterfaz.swf");
                     	//isCargadoReporte = true;
              		//}
              		this.infolb.visible = false;
                 break;
	         }
		}catch(e:Error){
			Alert.show("libTalleresCompania.as > seleccionTab" + e.message, e.name); 
		}
	}	
	
	public function createPopUpManager(Obj:Object):void {
		try{
			var myObj:TitleWindow = TitleWindow(Obj);
			PopUpManager.addPopUp(myObj, DisplayObject(this), true);
			PopUpManager.centerPopUp(myObj);
		}catch(e:Error){
			Alert.show(e.message+" "+e.name);
		}
	}

	public function closePopUp(obj:IFlexDisplayObject):void {
		PopUpManager.removePopUp(obj);
	}
	
public function formatoTelefono(cajaTexto:Object):void{
	var temp:String	= "";
	var texto:String = formatoPuntos(cajaTexto.text);
	
	if(texto.length == 7){
		temp = formatoTextoTelefono(texto);
	}
	else{
		if(texto.length == 8){
			temp = formatoTextoTelefonoRegion(texto);
		}
		else{
			temp = texto;
			if(temp.length >= 8){
				//temp = temp.substr(0,8);
				temp = formatoTextoTelefonoRegion(temp);
			}				
		}
	}
		cajaTexto.text = temp;
}

private function formatoTextoTelefono(texto:String):String{
	var temp:String = "";
	
	temp = texto.substr(0,3) + "." + 
		texto.substr(3,2) + "." + 
		texto.substr(5,2);
		return temp;
}

private function formatoTextoTelefonoRegion(texto:String):String{
	var temp:String = "";
	
	temp = texto.substr(0,2) + "." + 
		texto.substr(2,2) + "." + 
		texto.substr(4,2) + "." + 
		texto.substr(6,texto.length - 1);
		return temp;
}

	
	public function formatoCelular(cajaTexto:Object):void{
	var temp:String	= "";
	var texto:String = cajaTexto.text;
	if(texto.length == 8){
		temp = formatoTextoCelular(texto);
	}
	else{
		temp = formatoPuntos(texto);
		if(temp.length >= 8){
			//temp = temp.substr(0,8);
			temp = formatoTextoCelular(temp);
		}
			
	}
		cajaTexto.text = temp;
}

private function formatoTextoCelular(texto:String):String{
	var temp:String = "";
	
	temp = texto.substr(0,1) + "." +
		texto.substr(1,3) + "." + 
		texto.substr(4,2) + "." + 
		texto.substr(6,texto.length - 1);
		return temp;
}


public function formatoPuntos(texto:String):String{
	var temp:String = "";
	
	for(var i:int = 0; i < texto.length; i++){
		if(texto.substr(i,1) != "."){
			temp += texto.substr(i,1);
		}
				
	}
			
	return temp;
}

public function solicitarHttp(nombreServicio:String):HTTPService{
	var httpServicio:HTTPService = new HTTPService();
	
	httpServicio.method = "POST";
	httpServicio.showBusyCursor  = true;
	httpServicio.requestTimeout = 500;
	httpServicio.url = getUrlService(nombreServicio);	
			
	return httpServicio;
}

public function isArrayPadre(event:ResultEvent, nodo:String):Boolean{
	var res:Boolean=false;
	for each(var i:Object in event.result.L){
		if (i.hasOwnProperty(nodo)){
			return res=true;
		}else{
			for each(var x:Object in event.result.L.R){
				if (x.hasOwnProperty(nodo)){
					return res=false;
				}
			}
		}
	}
	return res;	
}

public function isArrayPadreListado(event:ResultEvent, nodo:String):Boolean{
	var res:Boolean=false;
	for each(var i:Object in event.result.Listado){
		if (i.hasOwnProperty(nodo)){
			return res=true;
		}else{
			for each(var x:Object in event.result.Listado.Resultado){
				if (x.hasOwnProperty(nodo)){
					return res=false;
				}
			}
		}
	}
	return res;	
}

public function fechaToString(fecha:Date):String{
	var mes:String = (fecha.month + 1).toString();
	var dia:String = fecha.date.toString();
	
	if(mes.length < 2){
		mes = "0" + mes;
	}
	
	if(dia.length < 2){
		dia = "0" + dia;
	}
	return fecha.fullYear + "-" + mes + "-" + dia;
}

private function mostrarDialogo():void{   			
  	var escena:Sprite = Sprite (this)
  	var miDialogo:modOpciones = new modOpciones();
       
  	PopUpManager.addPopUp (miDialogo, escena, true);
  	PopUpManager.centerPopUp (miDialogo);
   	
}

public function openSite(event:Event):void
{
    var url :URLRequest = new URLRequest(getUrlServer("urlSoporte"));
    navigateToURL(url, "_blank");
}

public function openBrowser(url:String, tipo:String):void{
    var urlRequest:URLRequest = new URLRequest(url);
		navigateToURL(urlRequest,tipo);
}
 
public function cerrar_sesion(event:Event):void
{
   	Alert.okLabel = "Sí";
   	Alert.cancelLabel = "No";
  	Alert.show(IdiomaAppBrowser.getText("application_esta_seguro"), IdiomaAppBrowser.getText("application_lert_title_aviso"),
    Alert.OK | Alert.CANCEL, this,
    alertListener, null, Alert.OK);
 
}
 
private function alertListener(eventObj:CloseEvent):void {       
    if (eventObj.detail==Alert.OK) {
        var url :URLRequest = new URLRequest(getUrlServer("urlAplicacion"));
		navigateToURL(url,"_self")
		
    }
}

public function getWS(nombreWsdl:String, nombreOperacion:String = null, servicio:int = 1):WebService{
	/*
	variable servicio
	1: Dataservices
	2: Mushup
	3: Wsas
	4: Alfresco
	5: Lotus
	 * */
	try{
		var wsdl:String;
		var endpointURI:String;
		var ws:WebService; 
		
		/*
		switch (servicio) {
			case 1: 
				wsdl = getUrlService(nombreWsdl);
				//ws.endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"SOAP11Binding");
				endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/" + nombreOperacion + getUrlServer("dataServicesEndPoint"));
			break;
			case 2: 
				wsdl = getUrlServiceWsas(nombreWsdl);
				endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl", getUrlServer("mashupEndPoint"));
			break;
			case 5: 
				wsdl = getUrlServiceLotus(nombreWsdl); 
				endpointURI = getUrlServiceLotus(nombreWsdl);
			break;
		}
		*/
		/*
		switch (servicio) {
			case 1: 
				wsdl = getOnlyServiceEsb(nombreWsdl) + "?wsdl";
				//ws.endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"SOAP11Binding");
				endpointURI = getOnlyServiceEsb(nombreWsdl) + "." + getOnlyService(nombreWsdl) + getUrlServer("dataServicesEndPoint");
			break;
			case 2: 
				wsdl = getOnlyServiceEsb(nombreWsdl) + "?wsdl";
				//ws.endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"SOAP11Binding");
				endpointURI = getOnlyServiceEsb(nombreWsdl) + "." + getOnlyService(nombreWsdl) + getUrlServer("dataServicesEndPoint");
			break;
			case 3:
				wsdl = getUrlServiceWsas(nombreWsdl);
				endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl","." + nombreOperacion + getUrlServer("wsasEndPoint"));
				//ws.endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"HttpsSoap11Endpoint");
			break;
			case 5: 
				wsdl = getUrlServiceLotus(nombreWsdl); 
				endpointURI = getUrlServiceLotus(nombreWsdl);
			break;
		}
		*/
		
		switch (servicio) {
			case 1: 
				wsdl = getUrlService(nombreWsdl);
				//ws.endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"SOAP11Binding");
				endpointURI = getUrlService(nombreWsdl).replace("?wsdl", getUrlServer("dataServicesEndPoint"));
			break;
			case 2: 
				wsdl = getUrlServiceWsas(nombreWsdl);
				//ws.endpointURI = getUrlService(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"SOAP11Binding");
				endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl", getUrlServer("dataServicesEndPoint"));
			break;
			case 3:
				var service:String = getOnlyService(nombreWsdl).replace("?wsdl", "");
				wsdl = getUrlServiceWsas(nombreWsdl);
				endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl", "") + "." + service + getUrlServer("wsasEndPoint");
				//endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl","." + nombreOperacion + getUrlServer("wsasEndPoint"));
				//ws.endpointURI = getUrlServiceWsas(nombreWsdl).replace("?wsdl","/"+nombreOperacion+"HttpsSoap11Endpoint");
			break;
			case 5: 
				wsdl = getUrlServiceLotus(nombreWsdl); 
				endpointURI = getUrlServiceLotus(nombreWsdl);
			break;
		}
		ws = new WebService();
		ws.showBusyCursor = true;		
		ws.wsdl = wsdl; 
		ws.endpointURI = endpointURI;
		
		if(getUrlServer("transport").toUpperCase() == "HTTPS"){
			ws.addHeader(this.objWSSecurity.getWSHeader(getUrlServer("UserName"), getUrlServer("UserPass")));
		}		
		
		ws.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
			var message:String = 
								IdiomaAppBrowser.getText("application_dir_web_incorrecta")+"\n\n" +
								"wsdl: " + wsdl + "\n" + 
								"endpointURI: " + endpointURI;
			//Alert.show(message);
			trace(message);
			//Alert.show(ObjectUtil.toString(event));
		});
		
		ws.loadWSDL();
		//ws.addHeader(this.WSSecurity.getWSHeader(getUrlServer("UserName"), getUrlServer("UserPass")));
	}catch(e:Error){
		Alert.show(IdiomaAppBrowser.getText("application_problema_wsdl") + e.message + " " + e.name, "WSDL");
	}
	return ws;
}

public function encriptarBase64(ps:String):String{
	var benq:Base64Encoder = new Base64Encoder();
    benq.encode(ps);
    ps = benq.toString();
    return(ps);
}

public function desencriptarBase64(deco:String):String{
	var benq:Base64Decoder = new Base64Decoder();
	var arrByte:ByteArray;
	benq.decode(deco);
	arrByte = benq.toByteArray();
	return(arrByte.toString());
}
	
public function XMLToArray(event:ResultEvent):ArrayCollection{ 
		var listaSalida:ArrayCollection = null;
	try{
		if(event.result != null){
		    var nsRegEx:RegExp = new RegExp(" xmlns(?:.*?)?=\".*?\"", "gim"); 		    
		    var regNil:RegExp = new RegExp(" xsi(?:.*?)?=\".*?\"", "gim");
		    var resultXML:XMLDocument = new XMLDocument(String(event.result).replace(nsRegEx, "").replace(regNil, ""));
		    var decoder:SimpleXMLDecoder = new SimpleXMLDecoder();
		    var data:Object = decoder.decodeXML(resultXML);
		    var array:Array = ArrayUtil.toArray(data.L.R);
		    listaSalida = new ArrayCollection(array);
		}
	}catch( e:Error){
		listaSalida = null;
	}
	return listaSalida;   
    
}


public function loginAlfresco():void {
   // Create the web script object
   var url:String =  getUrlServiceAlfresco("alfrescoLogin");
   var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onLoginSuccess, onLoginFailure, false);

  	 // Build the parameter object
   	var params:Object = new Object();
  	params.u = getUrlServer("alfUserName");
  	params.pw = getUrlServer("alfUserPass");

	   // Execute the web script
	webScript.execute(params);
}
		
public function onLoginSuccess(event:SuccessEvent):void {
   // Get the ticket from the results
   this._ticket = event.result.ticket;
//	Alert.show(ObjectUtil.toString(event));
}

public function onLoginFailure(event:FailureEvent):void {		
   // Get the error details from the failure event
   var code:String = event.fault.faultCode;
   var message:String = event.fault.faultString;
   var details:String = event.fault.faultDetail;
}

	//------------------------mail
public function formatoListaMail(texto:String):ArrayCollection{
	var listaTexto:Array = texto.split("|");
	var tmpArray:Array;
	var listaDatos:ArrayCollection = new ArrayCollection();
	var objTemp:Object = new Object();
	
	for(var i:int = 0; i < listaTexto.length; i++){
		tmpArray = new String(listaTexto[i]).split("#");
		objTemp = new Object();
		objTemp.Tipo = tmpArray[0];
		objTemp.Descripcion = tmpArray[1];
		objTemp.Asunto = tmpArray[2];
		objTemp.Cuerpo = tmpArray[3];		
		listaDatos.addItem(objTemp); 	
	}
	return listaDatos;
}

public function getIDTallerPerfil():String{
	var objModPrincipal:modPrincipal = modPrincipal(mlPrincipal.child);
	var IDTaller:String = "0";
	if(objModPrincipal.cbTaller.selectedIndex > -1){
		IDTaller = objModPrincipal.cbTaller.selectedItem.IDTaller;
	}
	return IDTaller;
}

public function getIDLocalPerfil():String{
	var objModPrincipal:modPrincipal = modPrincipal(mlPrincipal.child);
	var IDLocal:String = "0";
	if(objModPrincipal.cbLocales.selectedIndex > -1){
		IDLocal = objModPrincipal.cbLocales.selectedItem.IDLocal;
	}
	return IDLocal;
}

public function validar(validadores:Array):Boolean{
	var validador:Validar = new Validar();
	var ok:Boolean = true;
	
	if (!validador.validarCampos(validadores,IdiomaAppBrowser.getText("application_campos_requeridos"))){
		ok = false;			
	}	
	return ok;
}

public function formatoGestores(texto:String):String{
	var temp:String = "";
	if(texto != null){
		for(var i:int = 0; i < texto.length; i++){
			if(texto.substr(i,1) != '"' && texto.substr(i,1) != "{"  && texto.substr(i,1) != "}"){
				if(texto.substr(i,1) == ","){
					temp += "\n";
				}else{
					temp += texto.substr(i,1);
				}				
			}
		}
	}	
	return temp;
}

public function getSerialFecha():String{
	var dt:Date = new Date();
	var dia:String = dt.date.toString();
	var mes:String = (dt.month + 1).toString();
	var anio:String = dt.fullYear.toString();	
	dia.length < 2 ? dia = "0" + dia : dia;
	mes.length < 2 ? mes = "0" + mes : mes;
	var formato:String = dia + "." + mes + "." + anio;	
	return formato;
}

public function getColumMayor(datos:ArrayCollection, nodo:String):int{
	var mayor:Number = 0;
	for(var i:int = 0; i < datos.length; i++){
		if (mayor < datos[i][nodo]){
			mayor = datos[i][nodo];
		}
	}
	
	if(mayor < 10){
		mayor = mayor + 2;
	}else{	
		if(mayor < 20){
			mayor = mayor + 5;
		}else{
			if(mayor < 100){
				mayor = mayor + 10;
			}else{
				mayor = mayor + 20;
			}
		}
	}
	return mayor;
}

public function cambiaColor():void{
	
	
	Application.application.setStyle("ThemeColor",0xFF0000 );

}
public function agrandaGrillaF():void{
	if(agrandaGrilla.end()){
		achicaGrilla.play();
	}
	else{
		agrandaGrilla.play();
	}
	
	//agrandaGrilla.addEventListener(EffectEvent.EFFECT_START,
}

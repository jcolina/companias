package talleresCompania2010.businessLogic
{
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.Modulos.modLogin;
	import talleresCompania2010.util.IdiomaAplicacion;
	import talleresCompania2010.util.IdiomaAppBrowser;


	public class Login
	{
		private var modLoginObj:modLogin;
		private var tmp:String;
		private var parametrosWS:Object;
	
		private var sharedObject:SharedObject;
		private var objIdiomaAplicacion:IdiomaApp;
		
		public function Login(modLoginObj:modLogin)
		{
			this.modLoginObj = modLoginObj;
			setLogin();
		}
		
		private function setLogin():void{
			sharedObject = SharedObject.getLocal("applicationData");			
			if (sharedObject.data.user != null && sharedObject.data.pass != null){
					modLoginObj.txlogin.text = Application.application.desencriptarBase64(sharedObject.data.user);
					modLoginObj.txpassword.text = Application.application.desencriptarBase64(sharedObject.data.pass);
					modLoginObj.chkStored.selected = true;	
			}
		}

		public function sendLogin():void {
			if(Application.application.validar([modLoginObj.validUser, modLoginObj.validPass])){
				parametrosWS = new Object();
				var ws:WebService = Application.application.getWS("Login","OPLogin");
				parametrosWS.Login = modLoginObj.txlogin.text;
				parametrosWS.Password = Application.application.encriptarBase64(modLoginObj.txpassword.text); 	
				ws.OPLogin.resultFormat = "e4x";
				ws.OPLogin.send(parametrosWS.Login, parametrosWS.Password);
			    ws.OPLogin.addEventListener("result", validarLogin);
			    ws.OPLogin.addEventListener("fault", function(event:FaultEvent):void{
			    	Alert.show(IdiomaAppBrowser.getText("general_alert_fault_message_ws"),  IdiomaAppBrowser.getText("login_login_ws_fault_title"));
			    });
			}
		}

		private function validarLogin(event:ResultEvent):void{
        	var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
        	if(listaDatosWS != null){
        		if(listaDatosWS[0].idperfil == "3"){
        			var objDatosLogin:Object = new Object();
        			objDatosLogin.IDPerfil = listaDatosWS[0].idperfil;
    				objDatosLogin.DescripcionPerfil = desIdPerfil(listaDatosWS[0].idperfil);
    				objDatosLogin.IDUsuario = listaDatosWS[0].IDUsuario;
    				objDatosLogin.IDLocal = listaDatosWS[0].Codigo;
    				objDatosLogin.IDCompania = listaDatosWS[0].Codigo;
    				objDatosLogin.nombreTaller = listaDatosWS[0].Descripcion;
    				Application.application.lbTaller.text = listaDatosWS[0].Descripcion;
    				objDatosLogin.IDTaller = listaDatosWS[0].IDTaller;
    				objDatosLogin.nombre = listaDatosWS[0].Nombre;
    				objDatosLogin.apellido = listaDatosWS[0].Apellido;
    				objDatosLogin.celular = listaDatosWS[0].Celular;
    				objDatosLogin.rut = listaDatosWS[0].Rut;
    				objDatosLogin.email = listaDatosWS[0].Email;
    				objDatosLogin.user = listaDatosWS[0].User;
    				objDatosLogin.pass = listaDatosWS[0].pass;
    				
    				Application.application.ObjDatosLogin = objDatosLogin;
    					  
    				objDatosLogin.Pais = listaDatosWS[0].Pais;
        			Application.application.idUsuario = listaDatosWS[0].IDUsuario;
	        		Application.application.idCompania = listaDatosWS[0].Codigo;
	        		Application.application.lbTaller.text = listaDatosWS[0].Descripcion;
	        		Application.application.nombre = listaDatosWS[0].Nombre;
	        		Application.application.apellido = listaDatosWS[0].Apellido;
	        		Application.application.celular = listaDatosWS[0].Celular;
	        		Application.application.rut = listaDatosWS[0].Rut;
	        		Application.application.email = listaDatosWS[0].Email;
	        		Application.application.user = listaDatosWS[0].User;
	        		Application.application.pass = listaDatosWS[0].pass;
	        		Application.application.Pais = listaDatosWS[0].Pais;
	        		

	        		
	        		if(modLoginObj.chkStored.selected){
	        			sharedObject.data.user = Application.application.encriptarBase64(modLoginObj.txlogin.text);
 						sharedObject.data.pass = Application.application.encriptarBase64(modLoginObj.txpassword.text);
	        		}else{
	        			sharedObject.clear();
	        		}
	        		
	        		Application.application.lnkopciones.label = listaDatosWS[0].Nombre + " " + listaDatosWS[0].Apellido;
	        		
        			objIdiomaAplicacion = new IdiomaApp(listaDatosWS[0].Pais, listaDatosWS[0].IDSubPerfil, this.modLoginObj);	
				
				}
        		else{
        			Alert.show(IdiomaAppBrowser.getText("login_usuario_invalido"), IdiomaAppBrowser.getText("general_alert_title"));
        		}
            }else {
            	Alert.show(IdiomaAppBrowser.getText("login_usuario_invalido"),IdiomaAppBrowser.getText("general_alert_title"));
            }
		}
		
		private function desIdPerfil(idParam:int):String{
			var descripId:String;
			switch (idParam ){
				case 1:
					descripId = "Administrador";
					break;
				case 2:
					descripId = "Local";
					break;					
				case 3:
					descripId = "Compania";
					break;
				case 4:
					descripId = "Liquidador";
					break;
				case 5:
					descripId = "Taller";
					break;
				default:
					descripId = "";
					break;	
			}
			return descripId;					
		} 
	}
}
package talleresCompania2010.businessLogic
{
	import Notificacion.com.notifications.Notification;
	import talleresCompania2010.util.IdiomaApp;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	public class Email extends DatosContacto
	{
		/**
		 * Constantes
		 *
		 */
		 
	 	public static const SEPARATOR_ARRAY:String = "#|#";
		public static const SEPARATOR_VALUES:String = "#$#";
		public static const ENTER:String = "[enter]";
		public static const ENTER_VALUE:String = "\n";
		
		/**
		 * 
		 * Tag Values
		 * 
		*/
		 
		public static const COMENTARIO_TAG:String = "[comentario]";
		public static const REPUESTO_TAG:String = "[repuesto]";
		public static const ESTADO_REPUESTO_TAG:String = "[estadoRepuesto]";
		public static const NOMBRE_USUARIO_TAG:String = "[nombreUsuario]";
		public static const DOCUMENTOS_TAG:String = "[documentos]";
		public static const FECHA_ENTREGA_TAG:String = "[fechaEntrega]";
		public static const HORA_ENTREGA_TAG:String = "[horaEntrega]";
		public static const GESTORES_TAG:String = "[gestores]";
		public static const ETAPA_TAG:String = "[etapa]";
		public static const ID_CAMBIO_TAG:String = "[ID_CAMBIO]";
		public static const MOTIVO_CAMBIO_TAG:String = "[MOTIVO_CAMBIO]";
		public static const MAIL_USUARIO_TAG:String = "[mailUsuario]";
		public static const URL_APLICACION_TAG:String = "[urlAplicacion]";
		public static const TALLER_ENTREGA_TAG:String = "[tallerEntrega]";
		public static const DIRECCION_LOCAL_TAG:String = "[direccionLocal]";
		public static const PASS_USUARIO_TAG:String = "[passUsuario]";
		 
		/**
		 * 
		 * Notification Values
		 * 
		*/
		
		public static const FINALIZAR_ETAPA_TERMINACION:String = "1";
		public static const INICIO_DE_ETAPA:String = "2";
		public static const COMENTARIO:String = "3";
		public static const FECHA_ENTREGA:String = "5";
		public static const FINALIZACION_ETAPA:String = "6";
		public static const CAMBIO_FECHA_ENTREGA:String = "7";
		public static const CARGA_DOCUMENTO:String = "8";
		public static const INGRESO_USUARIO:String = "9";
		public static const REPUESTO:String = "10";
		public static const LLEGADA_REPUESTO:String = "11";
		public static const INGRESO_SOLICITUD:String = "16";
		public static const FINALIZAR_SOLICITUD:String = "17";
		public static const COMPANIA_DEFAULT:String = "0";
		public static const TALLER_DEFAULT:String = "0";
		
		/**
		 * Variables
		 *
		 */
		 
		private var callBackInitFunction:Function;		
		public var parametrosCorreo:String;
		
		public function Email(callBackInitFunction:Function, isRepuesto:Boolean = false)
		{
			this.callBackInitFunction = callBackInitFunction;
			this.isRepuesto = isRepuesto;
			this.solDatosContacto();
		}
		
		override public function extraFunction(listaDatosWS:ArrayCollection):void{
			this.isRepuesto = false;
			this.setParametrosCorreo();
			this.callBackInitFunction();
		}
		
		public function sendEmail(Para:String, Cc:String, Tipo:String, Taller:String, Compania:String, IDVehiculo:String, SMS:String = "", resultFunction:Function = null, faultFunction:Function = null):void{
			var ws:WebService = Application.application.getWS("MailReg", "envioMail", 2);
			ws.envioMail.resultFormat = "e4x";
			
			var IDUsuario:String = Application.application.ObjDatosLogin.IDUsuario;
			var IDLocal:String = Application.application.ObjDatosLogin.IDLocal;	

			ws.envioMail.send(IDUsuario,
							  Para,
							  Cc,
							  Tipo,
							  Taller,
							  Compania,
							  this.parametrosCorreo,
							  SMS,
							  IDLocal,
							  IDVehiculo);
			ws.envioMail.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{
				var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
				switch (listaDatosWS[0].Estado.toString()){
					case "0":
						Alert.show(IdiomaApp.getText('email_no_envio'),IdiomaApp.getText('general_error'));
						if(faultFunction != null){
							faultFunction();
						}
					break;
					case "1":
						//Notificación de email exitoso
						Notification.show(IdiomaApp.getText('email_enviado_a')+" " + listaDatosWS[0].Email.replace("@smsf", ""), IdiomaApp.getText('email_envio'), Notification.NOTIFICATION_EMAIL_ICON);
						//Notificación de SMS exitoso
						if(SMS != ""){
							Notification.show(IdiomaApp.getText('email_enviado_a_sms')+" "+ SMS.replace("@smsf", ""), IdiomaApp.getText('email_envio_mje'), Notification.NOTIFICATION_SMS_ICON);
						}
						//Ejecuta una función si es correcto el envío
						if(resultFunction != null){
							resultFunction();
						}
					break;
				}
			});
			ws.envioMail.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('email_envio'));
				//Ejecuta una función si no es correcto el envío
				if(faultFunction != null){
					faultFunction();
				}
			});
		}
		
		public function notificacionAutomatica(tipo:String, para:String = null):void{	
			var taller:String = Application.application.ObjDatosLogin.IDTaller;
			var compania:String = Application.application.ObjVehiculo.IDCompania;			
			var IDVehiculo:String = Application.application.ObjVehiculo.IDVehiculo;			
			var SMS:String;
			
			if(para == null){
				 SMS = this.SMS(Application.application.ObjDatosContacto.Celular);
				 para = Application.application.ObjDatosContacto.Email;
			}else{
				SMS = "";
			}
			
			this.sendEmail(para, "", tipo, taller, compania, IDVehiculo, SMS);
		}
		
		public function SMS(celularContacto:String):String{
			var _sms:String = "";
			if (celularContacto != null && celularContacto != ""){
				_sms = Application.application.formatoPuntos(IdiomaApp.getText('CodigoPaisCelular') + celularContacto + "@smsf");
			}
			return _sms;
		}
		
		public function reemplazarValorPlantilla(plantilla:String):String{
			var tempArray:Array = this.parametrosCorreo.split(SEPARATOR_ARRAY);
			
			for(var i:int = 0; i < tempArray.length; i++){
				var tempListArray:Array = tempArray[i].split(SEPARATOR_VALUES);
				var objTemp:Object = new Object();
				plantilla = plantilla.split(tempListArray[0]).join(tempListArray[1]);
			}
			return plantilla.split(ENTER).join(ENTER_VALUE);
		}
		
		public function reemplazarValor(keyToReplace:String, valueToReplace:String):void{
			var tempArray:Array = this.parametrosCorreo.split(SEPARATOR_ARRAY);
			var returnText:String = "";
			for(var i:int = 0; i < tempArray.length; i++){
				var tempListArray:Array = tempArray[i].split(SEPARATOR_VALUES);
				if(tempListArray[0] == keyToReplace){
					tempListArray[1] = valueToReplace;
				}
				returnText += tempListArray[0] + SEPARATOR_VALUES + tempListArray[1] + SEPARATOR_ARRAY;
			}
			this.parametrosCorreo = returnText.substr(0, returnText.length - 3);
			//this.agregarValoresNoEnviados();
			Application.application.parametrosCorreo = this.parametrosCorreo;
		}
		
		public function agregarValor(key:String, value:String):void{
			if(value == null || value == ""){
				value = IdiomaApp.getText('email_sin_info');
			}
				this.parametrosCorreo += SEPARATOR_ARRAY + key + SEPARATOR_VALUES + value;
				Application.application.parametrosCorreo = this.parametrosCorreo;
		}
		
		private function agregarValoresNoEnviados():void{
			agregarValor(COMENTARIO_TAG, "");
			agregarValor(REPUESTO_TAG, "");
			agregarValor(ESTADO_REPUESTO_TAG, "");
			agregarValor(NOMBRE_USUARIO_TAG, Application.application.ObjDatosLogin.nombre + " " + Application.application.ObjDatosLogin.apellido);
			agregarValor(DOCUMENTOS_TAG, "");
			agregarValor(ID_CAMBIO_TAG, "");
			agregarValor(URL_APLICACION_TAG, "");
			reemplazarValor(GESTORES_TAG, Application.application.formatoGestores(this.getValorCorreo(GESTORES_TAG)));
		}
		
		public function getValorCorreo(keyToFind:String):String{
			var tempArray:Array = this.parametrosCorreo.split(SEPARATOR_ARRAY);
			var returnText:String = "";
			for(var i:int = 0; i < tempArray.length; i++){
				var tempListArray:Array = tempArray[i].split(SEPARATOR_VALUES);
				if(tempListArray[0] == keyToFind){
					return tempListArray[1];
				}
			}
			return returnText;
		}
				
		private function setParametrosCorreo():void{
			this.parametrosCorreo = Application.application.parametrosCorreo;
			this.agregarValoresNoEnviados();
		}
		
		//Genera una lista de email en base a checkBox
		public function listMailTo(listaCheck:Array):String {
			var listMail:String;
			
			for(var i:int = 0; i < listaCheck.length; i++){
				if(listaCheck[i].selected){
					if(listMail != null){
						listMail = listMail + ", " + listaCheck[i].selectedField;
					}else {
						listMail = listaCheck[i].selectedField;
					}
				}
			}
			
			return listMail;
		}
	}
}
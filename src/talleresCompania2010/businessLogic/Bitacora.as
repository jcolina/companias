package talleresCompania2010.businessLogic
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.modBitacora;
	import talleresCompania2010.util.IdiomaApp;
	import talleresCompania2010.util.StringHelper;
	
	
	public class Bitacora {
		
		private var ObjModBitacora:modBitacora;
		private var ObjGridBitacora:Grid;
		private var time:Timer;		
		
		public function Bitacora(ObjModBitacora:modBitacora) {
				this.ObjModBitacora = ObjModBitacora;
				solBitacora();
				setTiempo();
				
		}
		
		//----------------------------------------------------------------------
		//INicia el timer 
		public function setTiempo():void{
			time = new Timer(10000);
			time.addEventListener(TimerEvent.TIMER,tiemp);
			time.start();
		}
		//funcion a ejecutar cuando esta el timer	
		public function tiemp(evt:TimerEvent):void{
			solBitacora();
		}
		public function solBitacora():void {
			var parametrosWS:Object = new Object();		
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			var ws:WebService = Application.application.getWS("Bitacora","OpHistorico");
			ws.OpHistorico.resultFormat = "e4x";
			ws.OpHistorico.send(parametrosWS.IDVehiculo);
		    ws.OpHistorico.addEventListener("result", cargarGrilla);
		    ws.OpHistorico.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('bitacora_alert_title_carga'));
		    });
		}
		
		private function cargarGrilla(event:ResultEvent):void {
        	var Datos:ArrayCollection = Application.application.XMLToArray(event);
			var i:int=0;			
			var objetoComentario:Object;
			var arregloComentario:ArrayCollection = new ArrayCollection;
			if(Datos != null) {
				//ObjModBitacora.myGridBitacora.dataProvider = Datos;
				for(i=0;i <= Datos.length -1;i++){	
				objetoComentario = new Object;				
				objetoComentario.usuario = Datos[i].NombreUsuario;
				objetoComentario.comentario = Datos[i].Comentario;			
				objetoComentario.fecha = RetornaFecha(Datos[i].FechaAccion,Datos[i].Tiempo);
				arregloComentario.addItem(objetoComentario);
				}
				ObjModBitacora.myList.dataProvider = arregloComentario;
				
			}
		}
		private function RetornaFecha(fecha:String,tiempo:String):String{
			var hace:String = " "+IdiomaApp.getText("bitacora_comentario_hace")+" ";			
			var res:uint;			
			var fechaNueva:String;
			var fechaTiempo:Date = new Date;	
			var fechaPost:Date = new Date;			
			//convertir la fecha de que viene a Date (String a Date)	
			fechaPost=isoToDate(cortaFecha(fecha));						
			fechaTiempo=isoToDate(cortaFecha(tiempo));
			var fechaResta:Date = new Date;			
			var miliFecPost:Number = fechaPost.getTime();
			var miliFecActual:Number = fechaTiempo.getTime();
			var Dias:int = (miliFecActual-miliFecPost) /1000/60/60/24  ;
			var Meses:int = Dias / 30;			
			if (Dias <= 0){
				var resMin:uint;
				var resHor:uint;				
				res = Math.abs(miliFecPost-miliFecActual);
				//Total Horas Transcurridas
				resHor = res/1000/60/60;
				//Total Horas Transcurridas
				resMin = res/1000/60;
				if(resHor > 0){
					if(resHor == 1){
						fechaNueva = cambiarDia(fechaPost)+hace+resHor+" "+IdiomaApp.getText("bitacora_comentario_hora");
					}
					else {							
					fechaNueva = cambiarDia(fechaPost)+hace+resHor+" "+IdiomaApp.getText("bitacora_comentario_horas");
					}
				}			
				else if(resHor <= 0){
					if(resMin == 0){
						fechaNueva = cambiarDia(fechaPost)+hace+" "+IdiomaApp.getText("bitacora_comentario_segun");
					}
					else if(resMin == 1){
						fechaNueva = cambiarDia(fechaPost)+hace+resMin+" "+IdiomaApp.getText("bitacora_comentario_minuto");						
					}
					else{						
					fechaNueva = cambiarDia(fechaPost)+hace+resMin+" "+IdiomaApp.getText("bitacora_comentario_minutos");
					}
				}						
			}
			else{
				if(Meses <= 0){
					var dia:String=IdiomaApp.getText("bitacora_comentario_dias_apro");
						if(Dias > 1){
							fechaNueva = cambiarDia(fechaPost)+hace+Dias+" "+dia;
						}
						else{
							fechaNueva=cambiarDia(fechaPost)+" "+IdiomaApp.getText("bitacora_comentario_ayer");
						}		
					}
				else{
					if(Meses == 1){
						fechaNueva = cambiarDia(fechaPost)+hace+Meses+" "+IdiomaApp.getText("bitacora_comentario_mes");
					}
					else
					{
						fechaNueva = cambiarDia(fechaPost)+hace+Meses+" "+IdiomaApp.getText("bitacora_comentario_meses");
					}
				}	
			}				
			return fechaNueva;
		}	
		
		private function cortaFecha(fec:String):String{
			var fecSinEspa:String="";			
			fecSinEspa=fec.substring(0,19)+"Z";			
			return fecSinEspa;
		}		
		private function isoToDate(value:String):Date {
                var dateStr:String = value;
                dateStr = dateStr.replace(/\-/g, "/");
                dateStr = dateStr.replace("T", " ");               
                dateStr = dateStr.replace("Z", " GMT-0000");
                //Alert.show(dateStr.toString());
                return new Date(Date.parse(dateStr));
            }	
		private function cambiarDia(fecha:Date):String {
			var str:String = ObjModBitacora.formatDate.format(fecha);
			if(str.indexOf("Mon") != -1)
				return str.replace("Mon", IdiomaApp.getText("datos_grilla_dia_lunes"));
			else if(str.indexOf("Tue") != -1)
				return str.replace("Tue", IdiomaApp.getText("datos_grilla_dia_martes"));
			else if(str.indexOf("Wed") != -1)
				return str.replace("Wed", IdiomaApp.getText("datos_grilla_dia_miercoles"));
			else if(str.indexOf("Thu") != -1)
				return str.replace("Thu", IdiomaApp.getText("datos_grilla_dia_jueves"));
			else if(str.indexOf("Fri") != -1)
				return str.replace("Fri", IdiomaApp.getText("datos_grilla_dia_viernes"));
			else if(str.indexOf("Sat") != -1)
				return str.replace("Sat", IdiomaApp.getText("datos_grilla_dia_sabado"));
			else if(str.indexOf("Sun") != -1)
				return str.replace("Sun", IdiomaApp.getText("datos_grilla_dia_domingo"));	
			
			return str;
		}
		

		public function sendComentario():void {
			var ObjStringHelper:StringHelper = new StringHelper();
			if(ObjStringHelper.trim(ObjModBitacora.txAreaComment.text, " ") == ""){
				Alert.show(IdiomaApp.getText('bitacora_debe_ingresar_com'), IdiomaApp.getText('bitacora_debe_ingresar_com_title'));
				return;
			}
			var parametrosWS:Object = new Object();
			parametrosWS.IDUsuario = Application.application.idUsuario;
			parametrosWS.Comentario = ObjModBitacora.txAreaComment.text;
			parametrosWS.IDVehiculo = Application.application.ObjVehiculo.IDVehiculo;
			var ws:WebService = Application.application.getWS("Comentario","OpComentario");
			ws.OpComentario.resultFormat = "e4x";
			ws.OpComentario.send(
									parametrosWS.IDVehiculo,
									parametrosWS.IDUsuario,								
									parametrosWS.Comentario);
		    ws.OpComentario.addEventListener("result", reloadBitacora);
		    ws.OpComentario.addEventListener("fault", function(event:FaultEvent):void{
		    	Alert.show(IdiomaApp.getText('general_fallo_ws'),IdiomaApp.getText('bitacora_envio_comentario_title'));
		    });
			
		}
		
		private function reloadBitacora(event:ResultEvent):void {
			ObjModBitacora.txAreaComment.text = "";
			solBitacora();
		}

		//------------------------------------------------------------------------------------
/* 		private function errorCallService(event:FaultEvent):void {
			trace(event.message);
			Alert.show("Se produjo un error en la llamada al servicio", "Aviso");
		} 
		
		private function successCallService(event:ResultEvent):void {
			Alert.show("Actualización Exitosa", "Aviso");
		}*/

	}
}
package talleresCompania2010.businessLogic
{
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import talleresCompania2010.Modulos.*;
	import talleresCompania2010.util.IdiomaApp;
	
	
	public class Contacto extends DatosContacto
	{
		private var ObjModCont:modDatosContacto;
		private var DatosGrillaObj:DatosGrilla;
		private var idvehi:int;
		
		public function Contacto(ObjModCont:modDatosContacto)
		{
			this.ObjModCont = ObjModCont;
			this.buscaContacto();
		}
		
		//----------------------------------------------------------------------------------------p


		public function buscaContacto():void{
				var parametrosWS:Object = new Object();
				parametrosWS = Application.application.ObjVehiculo;
				var ws:WebService = Application.application.getWS("Contacto","OpContacto");	
				ws.OpContacto.resultFormat = "e4x";
				ws.OpContacto.send(parametrosWS.IDVehiculo);
			    ws.OpContacto.addEventListener("result", desplegar_datos);
			    ws.OpContacto.addEventListener("fault", function(event:FaultEvent):void{
			    	Alert.show(IdiomaApp.getText('general_fallo_ws'), IdiomaApp.getText('contacto_title_alert_cont'));
			    });
		}
		
		//override public function extraFunction(listaDatosWS:ArrayCollection):void{
		private function desplegar_datos(event:ResultEvent):void{
			var listaDatosWS:ArrayCollection = Application.application.XMLToArray(event);
			if(listaDatosWS != null) {
				var datosContacto:Object= new Object();	
				//ObjModCont.btnbuscarcn.enabled = false;	
				//ObjModCont.btnactualizar.enabled = true;
				ObjModCont.txtnombrecn.text = listaDatosWS[0].Nombre;
				ObjModCont.txtapellidocn.text = listaDatosWS[0].Apellido;
				ObjModCont.txtcelularcn.text = listaDatosWS[0].Celular;
				Application.application.formatoCelular(ObjModCont.txtcelularcn);
				ObjModCont.txtemailcn.text = listaDatosWS[0].Email;
				ObjModCont.txttelefonocn.text = listaDatosWS[0].Telefono;
				Application.application.formatoTelefono(ObjModCont.txttelefonocn);
				ObjModCont.lblrutmod.text = listaDatosWS[0].idpersona;
				ObjModCont.txtpatentecn.text = listaDatosWS[0].Patente;
				ObjModCont.txtsiniestrocn.text = listaDatosWS[0].Siniestro;
				ObjModCont.lblLiquidadorText.text = listaDatosWS[0].NomLiquidador;			
				datosContacto.nombre = listaDatosWS[0].Nombre;
				datosContacto.apellido = listaDatosWS[0].Apellido;
				datosContacto.celular = listaDatosWS[0].Celular;
				datosContacto.mail = listaDatosWS[0].Email;
				datosContacto.telefono = listaDatosWS[0].Telefono;
				datosContacto.rut = listaDatosWS[0].idpersona;
				datosContacto.patente = listaDatosWS[0].Patente;
				datosContacto.numSiniestro = listaDatosWS[0].Siniestro;
				datosContacto.nomLiquidador = listaDatosWS[0].NomLiquidador;	
				
				Application.application.ObjDatosContacto = datosContacto;
				
			}else{
				Alert.show(IdiomaApp.getText('contacto_cont_no_encontrado'),IdiomaApp.getText('general_aviso_title'));
			}
		}
	}
}
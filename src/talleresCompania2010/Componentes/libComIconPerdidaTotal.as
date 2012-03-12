// ActionScript file
import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.Modulos.modPrincipal;

import talleresCompania2010.util.IdiomaApp;

override public function set data(value:Object):void {
	super.data = value;
}

public function init():void{
	try{
		if (data != null){
		//	Application.application.comIconPendienteR = this;
			[Embed(source='../../assets/PendRepu/clock_red.png')]
		    var imgPendiente:Class;
			if (data.PendienteRepuesto == "SI"){
		 		imgPendRepuesto.source = new imgPendiente(); 
		 		imgPendRepuesto.toolTip = "Tiene " + IdiomaApp.getText('general_repuesto') + " pendientes"; 
			}else{
				imgPendRepuesto.source = "";
			}
		}
	}catch(e:Error){
		Alert.show("libComIconPerdidaTotal.as > init() :" +e.message, e.name);
	}
} 
/*
public function iconoPerdida(bMostrar:Boolean):void{
	try{
		var objPrincipal:modPrincipal;
		objPrincipal = modPrincipal(Application.application.mlPrincipal.child);
		var obj:Object = new Object(); 
		obj = objPrincipal.itemParent();
		if(bMostrar){
			obj.PendienteRepuesto = "SI";
			objPrincipal.updateItem(obj);
		}else{
			obj.PendienteRepuesto = "NO";
			objPrincipal.updateItem(obj);
		}
	}catch(e:Error){
		Alert.show("libComIconPerdidaTotal.as > iconoPerdida :" +e.message, e.name);
	}
} */
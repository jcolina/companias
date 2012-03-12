// ActionScript file
import flash.events.Event;

import mx.core.Application;
import talleresCompania2010.util.IdiomaApp;

private function initMod():void {
	if(Application.application.ObjVehiculo != null){
		tabTareas.selectedIndex = Application.application.tabPosition;
	}else{
		Application.application.descargarAllDocumentos();
	}	
}

private function setTabPosition(event:Event):void {
	Application.application.tabPosition = event.currentTarget.selectedIndex;
}
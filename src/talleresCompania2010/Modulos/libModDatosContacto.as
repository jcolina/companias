import flash.events.MouseEvent;

import mx.core.Application;

import talleresCompania2010.businessLogic.Contacto;
import talleresCompania2010.util.IdiomaApp;

private var ObjContacto:Contacto;

private function initMod():void{	
	ObjContacto = new Contacto(this);
}


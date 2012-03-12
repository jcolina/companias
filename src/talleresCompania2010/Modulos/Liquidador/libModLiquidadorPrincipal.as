// ActionScript file


import flash.external.ExternalInterface;

import talleresCompania2010.Modulos.Liquidador.modLiquidadorPrincipal;

public var ObjModLiquidadorPrincipal:modLiquidadorPrincipal;
public function initMod():void{
		
	this.ObjModLiquidadorPrincipal= modLiquidadorPrincipal(this);
}
private function callJavaScript():void {
    //ExternalInterface.call("sayHelloWorld");
     ExternalInterface.call("llama");
    
}
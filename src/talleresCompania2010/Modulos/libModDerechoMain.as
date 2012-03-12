// ActionScript file
import mx.modules.ModuleLoader;

import talleresCompania2010.util.IdiomaApp;
public function loadModulo(mod:ModuleLoader, url:String):void {
	if(mod != null) {
		if(mod.url) {
			mod.unloadModule();
		}
		mod.url = url;
		mod.loadModule();
	}
//	tabTareas.selectedIndex = 1;
	
}
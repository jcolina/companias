// ActionScript file
import talleresCompania2010.businessLogic.Tareas;
import talleresCompania2010.util.IdiomaApp;



private var TareasObj:Tareas;

private function initMod():void {
	TareasObj = new Tareas(this);
}

private function cargarGrilla():void {
	
}

public function loadModulo(mod:ModuleLoader, url:String):void {
	if(mod != null) {
		if(mod.url) {
			mod.unloadModule();
		}
	}
//	tabTareas.selectedIndex = 1;
	mod.url = url;
	mod.loadModule();
}


public function unloadAllMods():void {
	if(mlModTareas2.url){
		mlModTareas2.unloadModule();
	}
	if(mlModTareas3.url){
		mlModTareas3.unloadModule();
	}	
	if(mlModTareas4.url){
		mlModTareas4.unloadModule();
	}
	if(mlModTareas5.url){
		mlModTareas5.unloadModule();
	}
}
 
// ActionScript file
import talleresCompania2010.businessLogic.ListaTareas;

private var ObjListaTareas:ListaTareas;

private function initMod():void {
	ObjListaTareas = new ListaTareas(this);
}

public function reloadTask():void {
	ObjListaTareas.solListaTareas();
}
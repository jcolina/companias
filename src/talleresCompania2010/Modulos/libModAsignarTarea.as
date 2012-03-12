// ActionScript file
import talleresCompania2010.businessLogic.AsignarTarea;
import talleresCompania2010.util.IdiomaApp;

private var ObjAsignarTarea:AsignarTarea;

private function initMod():void {
	ObjAsignarTarea = new AsignarTarea(this);
}

private function updateTareas():void {
	ObjAsignarTarea.updateTareas();
}

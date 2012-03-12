package talleresCompania2010.Modulos.Liquidador.businessLogic
{
	import mx.collections.*;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.DragManager;
	
	import talleresCompania2010.Modulos.Liquidador.Componente.comLiquidador;
	import talleresCompania2010.Modulos.Liquidador.Modulos.modLiquidador;
	public class ComLiquidador
	{
		private var objComLiquidador:comLiquidador;
		public var objClaseModLiquidador:ModLiquidador;
		public var objNuevoLiquidador:Object;
		public var ObjModuloLiquidador:modLiquidador;
		 	public	var dm:DragManager;

		public function ComLiquidador(objComLiquidador:comLiquidador)
		{
			this.objComLiquidador = objComLiquidador;
			
		}
	}
}
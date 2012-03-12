package talleresCompania2010.Modulos.Liquidador.businessLogic
{
		import mx.collections.ArrayCollection;
		
		import talleresCompania2010.Modulos.Liquidador.Componente.comLiquidador;
		import talleresCompania2010.Modulos.Liquidador.Modulos.modLiquidador;
	public class ModLiquidador
	{
		
		public var objModLiquidador:modLiquidador;
		public var objClaseLiquidador:ModLiquidador;
		public var comPop:comLiquidador;
		public var Liquidadores:ArrayCollection;
		//public var ItemSelected:Object;
		public var ArrayContenedorLiquidadores:ArrayCollection;
		//public var ObjWS:WebServices;		
		
		
		
		public function ModLiquidador(objModLiquidador:modLiquidador):void
		{			
			
			this.objModLiquidador = objModLiquidador;	
			
		}
		
			
		
	

	}
}
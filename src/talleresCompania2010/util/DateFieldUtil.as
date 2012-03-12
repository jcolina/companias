package talleresCompania2010.util
{
	import mx.core.Application;
	
	public class DateFieldUtil
	{
		public static function iniciarDateField(listaDateField:Array):void{
			for(var i:int = 0; i < listaDateField.length; i++){
				listaDateField[i].formatString = "DD-MM-YYYY";				
				listaDateField[i].dayNames = Application.application.DIAS_CALENDARIO;
				listaDateField[i].monthNames = Application.application.MESES_CALENDARIO;
			}
		}
	}
}
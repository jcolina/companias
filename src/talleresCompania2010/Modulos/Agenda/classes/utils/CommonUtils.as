package talleresCompania2010.Modulos.Agenda.classes.utils
{
	import mx.controls.DateField;

	/**
	 * COMMON UTILS CLASS CONATINS ALL COMMON FUNCTIONS/VARIABLES
	 * WHICH COULD BE USED BY DIFFERENT CLASSES OR VIEWS
	*/

	public class CommonUtils
	{	
		public static const DIA_MILISECONDS:Number = 86400000;
		public static const HORA_MILISECONDS:Number = 3600000;

		// Constructor 
		public function CommonUtils()
		{
		}

		/**
		 * returns day count for a month 
		*/ 
		public static function getDaysCount(_intMonth:int, _intYear:int):int
		{
			_intMonth ++;
			switch (_intMonth)
			{
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					return 31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					return 30;
					break;
				case 2:
					if((_intYear % 4 == 0 && _intYear % 100 != 0) || _intYear % 400 ==0)
					{
						return 29;
					}
					else
					{
						return 28;
					}
					break;
				default:
					return -1;
			}
		}

		public static function stringToDate(date:String):Date {
			return new Date(DateField.stringToDate(date, "DD-MM-YYYY").getTime() + HORA_MILISECONDS);
		}

		public static function setHour(milisecondsDate:Number):Number {
			var dtHora:Date = new Date(milisecondsDate);
			dtHora.setHours(01,00,00);
			return dtHora.getTime();
		}

		public static function isCompareDate(fechaInicio:Number, fechaComparar:String, fechaTermino:Number):Boolean {
			var dtComparar:Number =  setHour(stringToDate(fechaComparar).getTime());
			fechaInicio = setHour(fechaInicio);
			fechaTermino = setHour(fechaTermino);

			//Comparamos que la fecha este dentro de la semana y el día
			if(dtComparar >= fechaInicio &&  dtComparar <= fechaTermino){
				 return true;
			}
			return false;
		}

		public static function compareDate(dt1:Date, dt2:String):Boolean {
			var number1:Number = setHour(dt1.getTime());
			var number2:Number = setHour(stringToDate(dt2).getTime());

			if(number1 == number2){
				 return true;
			}
			return false;
		}	
	}
}
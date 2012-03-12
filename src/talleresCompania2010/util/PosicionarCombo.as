package talleresCompania2010.util
{
	import mx.controls.ComboBox;
	
	public final class PosicionarCombo
	{
		
		static public function posicionarCombo(combo:ComboBox, key:String, columna:String):Boolean{
		  	var sDataValueCur:String = "";
		  	var isFind:Boolean = false; 	
	  		for( var i:int = 0; i < combo.dataProvider.length; i++ ){
		  		sDataValueCur = datoComparar(combo.dataProvider[i], columna);
		   	 	if(sDataValueCur == key){
		   	 		combo.selectedIndex = i;
		   	 		isFind = true;
		   	 	}
	  		}
	  		return isFind;	  	
  		}
  
		static private function datoComparar(combo:Object, key:String):String{
			switch(key.toUpperCase()){
				case "NOMBRE":
					return combo.Nombre;
		        break;
		    	case "ID":
		        	return combo.ID;
		        break;
		        case "DESCRIPCION":
		        	return combo.Descripcion;
		        break;
		        case "IDCOMPANIA":
		        	return combo.IDCompania;
		        break;
		        case "LABEL":
		        	return combo.label;
		        break;
		        case "NOMBRELIQUIDADOR":
					return combo.nombre;
		        break;
		        case "DETALLE":
					return combo.Detalle;
		        break;		
		        case "NAMELOC":
		        	return combo.NAMELOC;
		        break;	   
		        case "NOMBRETALLER":
		        	return combo.NombreTaller;
		        break; 
		        case "DIRECCION":
		        	return combo.Direccion;
		        break;	        
		    	default:
		        	return null;
		        break;
			}
		} 

	}
}
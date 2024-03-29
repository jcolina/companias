package talleresCompania2010.util {

	public class StringHelper {
	   
	    public function StringHelper() {
	    }
	
	    public function replace(str:String, oldSubStr:String, newSubStr:String):String {
	        return str.split(oldSubStr).join(newSubStr);
	    }
	
	    public function trim(str:String, char:String):String {
	        return trimBack(trimFront(str, char), char);
	    }
	
	    public function trimFront(str:String, char:String):String {
	        char = stringToCharacter(char);
	        if (str.charAt(0) == char) {
	            str = trimFront(str.substring(1), char);
	        }
	        return str;
	    }
	
	    public function trimBack(str:String, char:String):String {
	        char = stringToCharacter(char);
	        if (str.charAt(str.length - 1) == char) {
	            str = trimBack(str.substring(0, str.length - 1), char);
	        }
	        return str;
	    }
	
	    public function stringToCharacter(str:String):String {
	        if (str.length == 1) {
	            return str;
	        }
	        return str.slice(0, 1);
	    }
	}
}
package talleresCompania2010.util.myValidators
{
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	
	public class ValidarRut extends StringValidator {
		
		/**
		 *  @private
		 *  Boolean format property.
		 */
		private var __format:Boolean;
		
		/**
		 *  @private
		 *  Storage for the invalidCharError property.
		 */
		public static var __invalidCharError:String = "Caracteres inválidos";
		[Inspectable(category="Errors", defaultValue="Caracteres inválidos")]
		
		/**
		 *  @private
		 *  Storage for the invalidIDCLError property.
		 */
		public static var __invalidIDCLError:String = "El rut no es válido";
		[Inspectable(category="Errors", defaultValue="El rut no es válido")]
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ValidarRut() {
			super();
			__format = true;
			this.maxLength = "00.000.000-0".length;
			this.minLength = "0000000".length;
			this.tooLongError = "Muchos caracteres, formato no válido para el rut"
			this.tooShortError = "Muy pocos caracteres, formato no válido para el rut"
		}
		
		/**
		 *  Override of the base class <code>doValidation()</code> method
		 *  to validate a String.
		 *
		 *  <p>You do not call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method.</p>
		 *
		 *  @param value Object to validate.
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function doValidation(value:Object):Array { 
			var results:Array = super.doValidation(value);
			
			var val:String = value ? String(value) : "";
			
			if (results.length > 0 || ((val.length == 0) && !required))
				return results;
			else
				return validateIDCL(this, value, null);
		}
		
		/**
		 *  Convenience method for calling a validator.
		 *  Each of the standard Flex validators has a similar convenience method.
		 *
		 *  @param validator The IDCLValidator instance.
		 *
		 *  @param value A field to validate.
		 *
		 *  @param baseField Text representation of the subfield
		 *  specified in the <code>value</code> parameter.
		 *  For example, if the <code>value</code> parameter specifies
		 *  value.mystring, the <code>baseField</code> value
		 *  is <code>"mystring"</code>.
		 *
		 *  @return An Array of ValidationResult objects, with one
		 *  ValidationResult  object for each field examined by the validator. 
		 *
		 *  @see mx.validators.ValidationResult
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function validateIDCL(validator:ValidarRut,
											value:Object,
											baseField:String = null):Array
		{
			var results:Array = StringValidator.validateString(this, value, null);
			
			var val:String = value ? String(value) : "";
			
			if (results.length > 0 || ((val.length == 0) && !required))
				return results;
			else
				return validateFormat(value);
		}
		
		/**
		 *  @private    
		 */
		private function validateFormat(value:Object):Array {
			
			//clean up and format the string
			var results:Array = [];
			var val:String = value != null ? String(value) : "";
			var cleanRut:String = cleanUP(val);
			var dv:String = cleanRut.charAt(cleanRut.length-1);
			var rutArray:Array = cleanRut.substring(0,cleanRut.length-1).split("").reverse();
			
			//validate if theres any invalid char in the string array, and return the results
			for(var i:int = 0; i < rutArray.length; i++){ 
				if(isNaN(rutArray[i])) {
					results.push(new ValidationResult(true, null, "invalidChar", ValidarRut.__invalidCharError)); 
					return results;
				}
			} 
			
			var iterator:Number = 2;
			var acumulator:Number = 0;
			
			//validate the ID CL, based on mod 11 rule
			for(i = 0; i < rutArray.length; i++){ 
				if(iterator == 8) iterator = 2;
				acumulator += rutArray[i]*iterator;
				iterator++;
			} 
			
			var dvCalculated:Number = 11-(acumulator%11);
			
			//check the digit against 10/k
			if(dvCalculated == 10 && dv.toLocaleLowerCase() == "k" || dvCalculated.toString() == dv.toLocaleLowerCase() || dvCalculated == 11 && dv == "0") {
				// if format = true, then format the string
				if(this.format && this.property.toLowerCase() == "text" && results.length < 1)
					this.source.text = getIDFullFormated(this.source.text);
				return results;
			}
			else
				results.push(new ValidationResult(true, null, "invalidIDCL", ValidarRut.__invalidIDCLError)); 
			
			return results;
		}
		
		
		/**
		 *  Convenience method for calling a validator.
		 *
		 *  @param value, to format the ID.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getIDFullFormated(value:String):String {
			var cleanedString:String = cleanUP(value);
			var formatedString:String = "";
			var stringArray:Array = cleanedString.substr(0,cleanedString.length-1).split("").reverse();
			var dv:String = cleanedString.charAt(cleanedString.length-1);
			for(var i:int=0;i<stringArray.length;i++) {
				if(i%3 == 0 && i != 0) formatedString += ".";
				formatedString += stringArray[i].toString();
			}
			formatedString = formatedString.split("").reverse().join("");
			formatedString += "-" + dv;
			return formatedString;
		}
		
		/**
		 *  @private    
		 */
		private static function cleanUP(value:String):String {
			var dashRegEx:RegExp = /-/;
			var dotRegEx:RegExp = /\./;
			var cleanRegEx:RegExp = / /;
			
			for (var i:int = 0;i < value.length; i++)
				value = value.replace(dashRegEx,"").replace(dotRegEx,"").replace(cleanRegEx,"");
			
			return value;
		}
		
		/** 
		 *  Property to format the ID if everything works fine
		 *  than the <code>format</code> property.
		 *
		 *  @default "Caracteres inválidos"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get format():Boolean {
			return __format;
		}
		
		public  function set format(value:Boolean): void {
			__format = value;
		}
		
		/** 
		 *  Error message when the String has a invalid char.
		 *  
		 *  @default "El rut no es válido"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get invalidCharError():String {
			return __invalidCharError;
		}
		
		/**
		 *  @private
		 */
		public  function set invalidCharError(value:String): void {
			__invalidCharError = value;
		}
		
		/** 
		 *  Error message when the String ID CL is not valid.
		 *  
		 *  @default "El rut no es válido"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get invalidIDCLError():String {
			return __invalidIDCLError;
		}
		
		/**
		 *  @private
		 */
		public  function set invalidIDCLError(value:String): void {
			__invalidIDCLError = value;
		}
		
	}
}
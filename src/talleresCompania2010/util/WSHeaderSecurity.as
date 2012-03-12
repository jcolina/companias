package talleresCompania2010.util
{
	import flash.sampler.NewObjectSample;
	import mx.rpc.soap.SOAPHeader;
	
	public class WSHeaderSecurity
	{		
		private var userName:String;
		private var userPass:String;
		private const nsUri:String = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
		private const nsSecurityUtility:String = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd";						
		private const localName:String = "Security";
		private const nsPasswordType:String = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText";
		private var userToken:String = "UsernameToken-"+Math.round(Math.random()*999999).toString();
		
		public function WSHeaderSecurity()
		{
		}
		
		public function getWSHeader(userName:String, userPass:String):SOAPHeader{
			this.userName = userName;
			this.userPass = userPass;
			return new SOAPHeader(this.getQname(), this.getContent());
		}
				
		private function getQname():QName{
			return new QName(this.nsUri, this.localName); 
		}
		
		private function getContent():XML{
			return  <wsse:Security xmlns:wsse={this.nsUri} xmlns:u={this.nsSecurityUtility}>
						<wsse:UsernameToken wsu:Id={this.userToken} xmlns:wsu={this.nsSecurityUtility}> 
							<wsse:Username>{this.userName}</wsse:Username> 
							<wsse:Password Type={this.nsPasswordType}>{this.userPass}</wsse:Password>                                                                                                                            
						</wsse:UsernameToken> 
						<u:Timestamp>
						</u:Timestamp>
					</wsse:Security>
	    }
	}
}
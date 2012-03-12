package talleresCompania2010.businessLogic
{

	public class Mail
	{
		
		private var From:String;
		private var To:Array;
		private var Cc:Array;
		private var Subject:String;
		private var Body:String;
		
		public function Mail()
		{
		}
		
		public function set emisor(From:String):void {
			this.From = From;
		}
		
		public function get emisor():String {
			return From;
		}
		
		public function set para(To:Array):void {
			this.To = To;
		}
		
		public function get para():Array {
			return To;
		}
		
		public function set copia(Cc:Array):void {
			this.Cc = Cc;
		}
		
		public function get copia():Array {
			return Cc;
		}
		
		public function set asunto(Subject:String):void {
			this.Subject = Subject;
		}
		
		public function get asunto():String {
			return Subject;
		}
		
		public function set cuerpo(Body:String):void {
			this.Body = Body;
		}
		
		public function get cuerpo():String {
			return Body;
		}

	}
}
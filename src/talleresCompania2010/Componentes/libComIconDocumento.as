// ActionScript file

public function init():void{	
	if (data != null){
		[Embed(source='../../assets/clip.png')]
	    var imgDoc:Class;
		if (data.Documentos == "SI"){
	 		imgDocumento.source = new imgDoc(); 
	 		imgDocumento.toolTip = "Tiene documentos asociados"; 
		}else{
			imgDocumento.source = "";
		}
	}
} 

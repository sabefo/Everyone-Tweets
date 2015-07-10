$(document).ready(function() {
	// Este código corre después de que `document` fue cargado(loaded) 
	// completamente.
	// Esto garantiza que si amarramos(bind) una función a un elemento 
	// de HTML este exista ya en la página.
	$("#send_tweet").on("submit", function(event){
		event.preventDefault();
		ser = $("#send_tweet").serialize();

   	$.post("tweet_media", ser, function(string){
   		// ESTAMOS PREGUNTANDO AL SERVIDOR SI YA SE ENVIO, TARDAMOS +3000+ ms EN HACERLO
      setTimeout(function(){
				$.get("/status/" + string, function(data) {
					$("#message").text(data);
				});
      }, 3000);
    });
	});
});

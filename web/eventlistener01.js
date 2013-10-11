var len = 0;
var rank = 1;
var max = 50;
var div;
var paddingTop = 15;


window.addEventListener("message", receiveMessage);  
function receiveMessage (event) {
  var data = event.data;
  if (data.recipient == 'JSfirst') {
	div = new Array(20);
	for (var i = 0; i < 20; i++) {
  	  div[i] = new Array(3);
	}
	
	for (var i = 0; i < 20; i++) {
		for (var j = 0; j < 3; j++) {
	  	  div[i][j] = document.createElement('div');
	      div[i][j].className = "blockOutput block" + j;
	  	  div[i][j].style.top = (paddingTop + i*40) + 'px';
		}
		div[i][0].textContent = rank + i;
		div[i][1].textContent = data.name;
		div[i][2].textContent = data.score;
	}
	len = 20;
	var response = {recipient: 'DART', rank: rank};
    window.postMessage(response, "*");
  } else if (data.recipient == 'JSsecond') {
    for (var i = 0; i < len; i++) {
      for (var j = 0; j < 3; j++) {
        $("#rank").append(div[i][j]);
      }
    }
    window.removeEventListener('message', receiveMessage);
  }
}
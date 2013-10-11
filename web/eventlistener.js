var len = 0;
var rank = 0;
var max = 50;
var div;
var paddingTop = 10;

window.addEventListener("message", receiveMessage);  
    
function receiveMessage (event) {
  var data = event.data;
  if (data.recipient == 'JSfirst') {
    var UserLink = Parse.Object.extend("UserLink");
    var userLink = new UserLink();
    userLink.set("score", data.score);
    userLink.set("name", data.name);
    var query = new Parse.Query(UserLink);
    query.lessThan("rank", max + 1);
    query.ascending("rank");
   	query.find({
      success: function(results) {
       	len = results.length;
        div = new Array(results.length + 1);
        for (var i = 0; i < results.length + 1; i++) {
          div[i] = new Array(3);
        }
        if (results.length == 0) {
          userLink.set("rank", 1);
          rank = 1;
          userLink.save();
          for (var j = 0; j < 3; j++) {
            div[0][j] = document.createElement('div');
            div[0][j].className = "blockOutput block" + j;
            div[0][j].style.top = paddingTop + 'px';
          }
          div[0][0].textContent = rank;
          div[0][1].textContent = data.name;
          div[0][2].textContent = data.score;
          len = 1;
       	} else {
          for (var i = results.length - 1; i >= 0; i--) {
            for (var j = 0; j < 3; j++) {
              div[i][j] = document.createElement('div');
              div[i][j].className = "blockOutput block" + j;
              div[i][j].style.top = (paddingTop + i*42) + 'px';
            }
            div[i][0].textContent = results[i].get('rank');
            div[i][1].textContent = results[i].get('name');
            div[i][2].textContent = results[i].get('score');
            if (data.score > results[i].get('score')) {
              rank = i+1;
            }
          }
          for (var j = 0; j < 3; j++) {
            div[results.length][j] = document.createElement('div');
            div[results.length][j].className = "blockOutput block" + j;
            div[results.length][j].style.top = (paddingTop + (results.length)*42) + 'px';
          }
          if (rank != 0) {
            div[results.length][0].textContent = results.length + 1;
            for (var i = results.length; i >= rank; i--) {
              div[i][1].textContent = div[i-1][1].textContent;
              div[i][2].textContent = div[i-1][2].textContent;
              results[i-1].set("rank", i + 1);
              results[i-1].save();
            }
            div[rank-1][1].textContent = data.name;
            div[rank-1][2].textContent = data.score;
         		userLink.set("rank", rank);
            userLink.save();
            len = results.length;
            if (len < max) {
              len++;
            }
          } else if (results.length < max) {
            div[results.length][0].textContent = results.length + 1;
            div[results.length][1].textContent = data.name;
            div[results.length][2].textContent = data.score;
            rank = results.length + 1;
        	userLink.set("rank", rank);
            userLink.save();
            len = results.length + 1;
          }
        }
        var response = {recipient: 'DART', rank: rank};
        window.postMessage(response, "*");
      }
  });  	
  } else if (data.recipient == 'JSsecond') {
    for (var i = 0; i < len; i++) {
      for (var j = 0; j < 3; j++) {
        $("#rank").append(div[i][j]);
      }
    }
    window.removeEventListener('message', receiveMessage);
  }
}
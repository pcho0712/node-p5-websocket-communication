//
//
// JSON.parse() string.
//

var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: process.env.PORT || 5000 });

console.log("listening port : "+ process.env.PORT || 5000);

wss.on('connection', function connection(ws) {
    console.log('connection');

    ws.on('message', function incoming(message) {
        //receiving JSON object - message
        console.log('received: %s', message);
        c2s_json = JSON.parse(message);



        //creating json by copying
        s2c_json = c2s_json;

        //appending server property
        date = new Date();
        s2c_json.server_time = date.toTimeString().split(' ')[0] + "." + date.getTime()%1000;//unix-time
        s2c_json.message = "hello from ws-server";
        s2c_json.clients_available = wss.clients.size;

        

        //sending object
        ws.send( JSON.stringify(s2c_json) );
        console.log('sent: %s', s2c_json );

        wss.clients.forEach( ws_client => {
            ws_client.send( JSON.stringify(s2c_json) );
        });
//        s.clients.forEach(client => {
//            client.send('接続しているクライアント全てに送信');
//        });



        //terminate on_message
        console.log(' ');


    });

    ws.on('close', function() {
        console.log('close');
    });
});
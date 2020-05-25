# node-p5-websocket-communication

WebSocket Server on node.js for Broadcasting JSON 

## architecture

(websocket_client / p5) 
-- {json / ws} -->
(websocket_server / node / heroku)
-- {json / ws} --> 
(websocket_client / p5)


## remaining tasks
- Processing Clients
  - encupsulating communication components (ie. websocket, json etc) into a utility class
  - asynchronous visualization for incoming json

- Other Clients
 - make a simple sample in other platforms (eg. touch-designer, html+js etc.)
 
- WebSocket Server on Node
  - html visualization

## usage-200525

1. launch ws_client_A
2. launch ws_client_B

(demo-video) https://youtu.be/GFv-NpQKzsg

[![](http://img.youtube.com/vi/GFv-NpQKzsg/0.jpg)](http://www.youtube.com/watch?v=GFv-NpQKzsg "node-p5-websocket-communication")



## misc
2020-05-25 Takatoshi Yoshida

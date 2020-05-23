/*
example: websocket-p5-node-communication 
 (original) https://qiita.com/tkyko13/items/869652e956e0cd463b60
 2020-05-23 @Takatoshi Yoshida
 
 p5-library: websockets
 */
import websockets.*;
//import org.json.JSONArray;



WebsocketClient wsc;
String s2c_msg = "";
String s2c_log = "";
String c_name = "client_A";
String timestamp = "";
JSONObject s2c_jso;


//util
String getTimestamp() {
  String ret = "";
  ret += hour();
  ret += ':';
  ret += minute();
  ret += ':';
  ret += second();
  ret += '.';
  ret += millis()%1000;


  return ret;
}



//main
void setup() {
  size(400, 400);

  wsc= new WebsocketClient(this, "ws://localhost:5000");

  //sending message on opening connection
  JSONObject c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("message", "opening connection");
  wsc.sendMessage(c2s_jso.toString());
}


void draw() {
  background(255);

  //display s2c message
  fill(255, 0, 80);
  text("s2c_log: "+ c_name, 20, 20);
  fill(0);
  line(20, 22, 120, 22);
  text(s2c_log, 20, 40);
  print(' ');

  //update values
  timestamp = getTimestamp();

  //generate values
  ArrayList values = new ArrayList();
  //float[] values;
  for (int idx = 0; idx < 10; idx++) {
    values.add(random(10));
  }

  //create JSON object  
  JSONObject c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("client_time", timestamp);
  
  JSONArray jsa_values = new JSONArray();
  for(int i=0; i< values.size() ;i++){
    jsa_values.append((float) values.get(i));
  }  
  c2s_jso.setJSONArray("values", jsa_values); 


  //send c2s message
  if (frameCount % 60 == 0) {
    wsc.sendMessage(c2s_jso.toString());
    println("sent: ",c2s_jso.toString());
  }
}


void keyPressed() {
  JSONObject c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("key_event", key);
  wsc.sendMessage(c2s_jso.toString());
}



void webSocketEvent(String s2c_msg) {
  println("received", s2c_msg);
  JSONObject s2c_jso = parseJSONObject(s2c_msg);
  JSONArray s2c_values = s2c_jso.getJSONArray("values");
  if( s2c_jso.getString("message") != null ){
    s2c_log += s2c_jso.getString("message")  + "\n";
  }
   
}

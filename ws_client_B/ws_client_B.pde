/*
example: websocket-p5-node-communication 
 (original) https://qiita.com/tkyko13/items/869652e956e0cd463b60
 2020-05-23 @Takatoshi Yoshida
 
 p5-library: websockets
 */
import websockets.*;
//import org.json.JSONArray;


//String target_url = "ws://localhost:5000";
String target_url = "ws://fathomless-brook-91328.herokuapp.com";


WebsocketClient wsc;
String s2c_msg = "";
String s2c_log = "";
String c_name = "client_B";
String timestamp = "";
JSONObject s2c_jso;
JSONObject c2s_jso; 

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

  wsc= new WebsocketClient(this, target_url);


  //sending message on opening connection
  s2c_jso = new JSONObject();
  c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("message", "opening connection");
  wsc.sendMessage(c2s_jso.toString());
}


void display_s2c_text(JSONObject _s2c_jso, PVector _disp_pos) {

  pushMatrix();
  translate(_disp_pos.x, _disp_pos.y);

  //display control
  fill(20,200,20);
  text("WebSocket Server at "+target_url,0,0);
  
  color c_color = color(0, 0, 0);
  if (!_s2c_jso.isNull("client_name")) {
    String s2c_c_name = _s2c_jso.getString("client_name");
    if (s2c_c_name.equals("client_A")) {
      translate(0, 0);
      c_color = color(255, 30, 30);
    } 
    if (s2c_c_name.equals("client_B")) {
      translate(200, 0);
      c_color = color(30, 30, 255);
    }
  }

  //title
  if (!_s2c_jso.isNull("client_name")) {
    String s2c_c_name = _s2c_jso.getString("client_name");
    //display title
    fill(c_color);
    text("client_name: "+ s2c_c_name, 0, 20);
    fill(80);
    line(0, 22, 120, 22);
  }

  //values
  if (!_s2c_jso.isNull("values")) {
    JSONArray jsa_s2c_values = _s2c_jso.getJSONArray("values");
    ArrayList s2c_values = new ArrayList();
    for (int i=0; i<jsa_s2c_values.size(); i++) {
      s2c_values.add( jsa_s2c_values.getFloat(i) );
    }

    //display values  
    for (int i=0; i<jsa_s2c_values.size(); i++) {
      fill(0);
      text(""+s2c_values.get(i), 0, 40+i*20);
    }
  }
  popMatrix();
}


void draw() {
  background(255);

  //display s2c message
  fill(0);
  text("s2c_log: "+ c_name, 20, 330);
  text(s2c_log, 20, 370);

  /* START: Vizualize S2C */

  display_s2c_text(s2c_jso, new PVector(20, 20));

  /* END: Vizualize S2C */

  /* START: CREATE C2S */



  //update values
  timestamp = getTimestamp();

  //generate values
  ArrayList values = new ArrayList();
  //float[] values;
  int len_of_values = floor(random(8, 12));
  for (int idx = 0; idx < len_of_values; idx++) {
    values.add(noise( millis()+0.05*idx ));
  }

  //create JSON object  
  JSONObject c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("client_time", timestamp);

  JSONArray jsa_values = new JSONArray();
  for (int i=0; i< values.size(); i++) {
    jsa_values.append((float) values.get(i));
  }  
  c2s_jso.setJSONArray("values", jsa_values); 


  //send c2s message
  if (frameCount % 60 == 0) {
    wsc.sendMessage(c2s_jso.toString());
    println("sent: ", c2s_jso.toString());
  }

  /* END: CREATE C2S */
}


void keyPressed() {
  JSONObject c2s_jso = new JSONObject();
  c2s_jso.put("client_name", c_name);
  c2s_jso.put("key_event", key);
  wsc.sendMessage(c2s_jso.toString());
}



void webSocketEvent(String s2c_msg) {
  println("received", s2c_msg);
  s2c_jso = parseJSONObject(s2c_msg);
  if ( s2c_jso.getString("message") != null ) {
    s2c_log += s2c_jso.getString("message")  + "\n";
  }
}

const express = require('express')
const app = express()
const mongoose = require('mongoose');
const graphqlExpress = require("express-graphql");
const schema = require('./graphql/movSchema')
const movs = require('./models/mov')
const cors = require('cors')
let users = [];


/******************** MONGODB ***************************** */

mongoose.connect('mongodb://dnscont02.southcentralus.azurecontainer.io:27017/LocalDB', (err) => {
    if (err) throw err;
    console.log("connected to mongo");
})

app.listen(app.get('port'),  () =>{
  console.log("Node app is running at localhost:" + app.get('port'))
});

const http = require("http").Server(app);
const io = require("socket.io")(http);

const ChatSchema = mongoose.Schema({
	_id: String,
	mov: String,
	RegisterDate: String,
	Duration: String,
	place: String
});

const ChatModel = mongoose.model("movs", ChatSchema);
let messages = [];
function getdata(){
   ChatModel.find((err, result) => {
    if (err) throw err;
    messages = result;
  }).sort('-RegisterDate');
  return messages;
}

io.on("connection", socket => {

setInterval(() => {
    socket.emit('loggedIn', {messages: getdata()})
}, 500)

	/*socket.emit('loggedIn', {
		messages: messages*/
	

	socket.on('newuser', username => {
		//console.log(`${username} has arrived at the party.`);
		socket.username = username;
		
		users.push(socket);

		io.emit('userOnline', socket.username);
	});

	socket.on('msg', msg => {
		let message = new ChatModel({
			username: socket.username,
			msg: msg
		});

		message.save((err, result) => {
			if (err) throw err;

      messages.push(result);
			io.emit('msg', result);
		});
	});
	
	// Disconnect
	socket.on("disconnect", () => {
		console.log(`${socket.username} has left the party.`);
		io.emit("userLeft", socket.username);
		users.splice(users.indexOf(socket), 1);
	});
});


http.listen(process.env.PORT || 3002, () => {
	console.log("Listening on port %s", process.env.PORT || 3001);
});


app.get('/clients', (req, res) => {
  res.send(Object.keys(io.sockets.clients().connected))
})


/******************** GRAPHQL ***************************** */
app.use(cors())
app.use('/graphql', graphqlExpress({
    schema,
    graphiql: true
}));

app.get('/', (req, res) => {

    res.send("hello world ! ")

})


/**************** MQTT **************************** */
var mqtt = require('mqtt');
var client = mqtt.connect("mqtt://34.70.164.156:1883", { clientId: "mqttjs01local" });
//var client = mqtt.connect("mqtt://192.168.0.15:1883", { clientId: "docker" });
var count =0;
console.log("connected flag  " + client.connected);

//handle incoming messages
client.on('message', function (topic, message, packet) {
    console.log("message is " + message);
    console.log("topic is " + topic);
});


client.on("connect", function () {
    console.log("connected  " + client.connected);

})

//handle errors
client.on("error", function (error) {
    console.log("Can't connect" + error);
    process.exit(1)
});

//publish
function publish(topic, msg, options) {
    console.log("publishing", msg);

    if (client.connected == true) {
        console.log("cliente conectado: publicando "+topic)
        client.publish(topic, msg, options);

    }
}

console.log("connected flag  " + client.connected);

var options = {
    retain: true,
    qos: 1
};

var topic = "get/gpsdata";
var message = "test message";

//notice this is printed even before we connect
console.log("end of script");
var timer_id;

  app.post('/arriba', function (req, res) {
    publish("get/arriba", "ADELANTE", options);
    //timer_id = setInterval(function () { publish(topic, message, options); }, 5000);
    res.send('[POST]Saludos desde express');
  });
 

var uuid = require('uuid');
var moment = require('moment');
/************************brazo*************************************************/

app.post('/barriba', function (req, res) {
  publish("get/arriba", "ADELANTE", options);

  var movi = new ChatModel({_id:uuid.v1(),mov:"adelante",RegisterDate:moment().format("YYYY-MM-DD hh:mm:ss"),Duration:"00:00:01",place:"brazo mioelectrico"});
  // save model to database
  movi.save(function (err, mov) {
    if (err) return console.error(err);
    console.log(mov.mov + " saved to collection.");
  });

  res.send('movimiento adelante guardado');
});
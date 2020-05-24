var mosca = require('mosca')



var moscaSettings = {
  port: 1883
};

var server = new mosca.Server(moscaSettings);
server.on('ready', setup);

// fired when a message is published
server.on('published', function(packet, client) {
  console.log('Published', packet.topic,packet.payload);
  });
  // fired when a client connects
  server.on('clientConnected', function(client) {
  console.log('Client Connected:', client.id);
  });
  
  // fired when a client disconnects
  server.on('clientDisconnected', function(client) {
  console.log('Client Disconnected:', client.id);
  });

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running')
}


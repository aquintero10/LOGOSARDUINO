<template>
	<div id="app">
		<div class="header">
			<h1>Reporte carro arduino LOGOS</h1>
		<tablu v-bind:messages="messages" />
	
	</div>
</template>

<script>
import io from 'socket.io-client';
import ChatRoom from './components/ChatRoom';
import tablu from './components/tabla';


export default {
	name: 'app',
	components: {
		ChatRoom,
		tablu
	},
	data: function () {
		return {
			username: "",
			socket: clientsConnection(),
			messages: [],
			users: []
		}
	},
	methods: {
		joinServer: function () {
			this.socket.on('loggedIn', data => {
				this.messages = data.messages;
				this.users = data.users;
				this.socket.emit('newuser', this.username);
			});

			this.listen();
		},
		listen: function () {

			this.socket.on('msg', message => {
				this.messages.push(message);
			});
		},
		sendMessage: function (message) {
			this.socket.emit('msg', message);
		},

	},
	mounted: function () {

		this.username = "Anonymous";
		this.joinServer();
	},

}

function clientsConnection(){
	var hosts = [{port:"3001"},{port:"3002"},{port:"3003"},{port:"3004"},{port:"3005"}]

	for (var i in hosts.get) {
		var name = 'ns' + i;
		(function (name) {
			x[name] = io.connect("http://dnscont01.southcentralus.azurecontainer.io/",hosts.get[i].port, { 'force new connection':true });
			x[name].on('connect', function () {
				console.log(x[name].socket.options.host + ' connected')
			});
		})(name);
	}
}



</script>

<style lang="scss">
body {
	font-family: 'Avenir', Helvetica, Arial, sans-serif;
	color: #2C3E50;
	margin: 0;
	padding: 0;
}

#app {
	display: flex;
	flex-direction: column;
	height: 100vh;
	width: 100%;
	max-width: 768px;
	margin: 0 auto;
	padding: 15px;
	box-sizing: border-box;
}
</style>

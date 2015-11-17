module.exports = {
	save:function(name, callback){
		//save the user
		var user = {
			id: "2222"
		}
			callback(name);
	},
	
	get:function(id, callback){
		//get the user
		var user ={
			name: "cesar",
			id: id
		}
		callback(id);
	}
}
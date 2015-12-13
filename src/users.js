module.exports={
	save: function(name,callback){
		var user={
			id: "2222"
			name:name
		}
		callback(name);
	}

	get:function(id,callback){
		// get a user
		var user ={
			name: "cesar",
			id: id
		}
        callback(id);
	}
}


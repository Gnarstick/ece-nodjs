var user = require('../lib/users.js');
var should = require('should');

describe('user', function() {
  describe('get()', function() {
    it('should get without error', function(done) {
      user.get('toto', function() {
		  // test
		  done();
	  });
    });
  });
});
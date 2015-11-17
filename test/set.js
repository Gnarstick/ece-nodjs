var user = require('../lib/users.js');
var should = require('should');

describe('user', function() {
  describe('save()', function() {
    it('should save without error', function(done) {
      user.save('22', function() {
		  // test
		  done();
	  });
    });
  });
});
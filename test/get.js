var user = require('../lib/users.js');
var should = require('should');

describe('user', function() {
  describe('get()', function() {
    it('should get without error', function(done) {
      user.get('22', function(result) {
		  // test
		  result.should.equal('22');
		  result.should.be.Int;
		  done();
	  });
    });
  });
});
var user = require('../lib/users.js');
var should = require('should');

describe('user', function() {
  describe('save()', function() {
    it('should save without error', function(done) {
      user.save('toto', function(result) {
		  // test
		  result.should.be.String;
		  result.should.equal('toto');
		  done();
	  });
    });
  });
});
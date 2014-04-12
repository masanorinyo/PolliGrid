var IndexPage = require('./IndexPage');

describe('myapp',function(){

	var page = new IndexPage();

	beforeEach(function(){

		// reads the page first
		page.get();
		
	});

	describe('index',function(){
		
		it('should display Flippy Survey',function(){
			
			expect(page.getTitle()).toBe('Flippy Survey');

		});

		// it('should display hello when the page loads up',function(){
			
		// 	expect(page.sayHello()).toBe('hello');

		// });


	});



});
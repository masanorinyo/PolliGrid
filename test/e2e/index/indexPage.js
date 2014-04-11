function IndexPage() {
  
  this.hello = element(by.binding('hello'));

  this.get = function () {
    browser.get('/#');
  };

  this.getTitle = function () {
    return browser.getTitle();
  };

  this.sayHello = function () {
    return this.hello.getText();
  }
}

module.exports = IndexPage;
## Reprise for jQuery, AJAX, and Others...

### Selector Style
- input: CSS selector as a string
- output: jQuery object (array-like) containing all elements that match the selector
- example: `$('li.someClass')`

### HTML Style
- input html code as a string
- output: jQuery object containing the top level elements you built
- example: `$('<li class=someClass></li>')`

### Wrapper Style
- input: Unwrapped html element or array of several elements
- output: jQuery object wrapping those elements, giving you access to jQuery methods
- example: `$(someHTMLVariable)`

### Ready Style
- input: function to run when DOM is fully loaded
- output: nothing
- example: $(() => alert('DOM is fully loaded'))

### Some methods
- addClass
- append
- attr & data
- css 
- eq 
- hide & show
- html 
- click & on
  - Bonus: slideUp
  
### RoadMap
- Rails MVC - still all relevant, just tweaking the views
- Past: Server-side rendering of html + erb (web pages)
- Future: Client-side rendering of html + json (web service)

### Enter AJAX
- Updates webpage without reloading all of it
- Sends HTTP requests and receives responses in the background
- Single Page Application (SPA) + Web API
- Stop writing it as:
```javascript
$.ajax({
  //...
})
```
- Instead, use axios etc. 

### Ajax Fundamentals
- Only required key is url
- Possible dataTypes: xml, html, scrupt, json, text

### Promises
- Introduced in ES6
- Promises represent the eventual completion (or failure) of an asynchronous operation, and its resulting behavior.
- Only has 3 statuses: fulfilled, rejected, pending

### Other topics to explore
- Code splitting (webpack)
- Microservice Architecture
  - Recap: 
    - Web pages (html file with js files loaded into it)
    - Web services (data (endpoints etc))
  - Microservices can section out a single task (have different servers for different tasks)
  - Ruby on Rails uses monolithic codebase
  - Serverless framework (has a bunch of microservices)
- Apache Kafka
- Hypernova (Airbnb packages that provides react server-side)
- Reconciliation == diffing algorithm in react
- black hat => DEF CON

### Event
1. `event delegation`: pattern of installing a single event handler on a parent element to catch events on its children
2. `event propgation`: after an event triggers on the deepest possible element, it then triggers on its parents in nesting order, aka the `bubbling principle`
- Capture phase => target phase => bubble phase
- To stop the bubbling, use `event.stopPropagation()`

### Side Note
1. `target`: deepest element event triggered on
2. `currentTarget`: element with event listener
3. You can manually trigger events
  - Vanilla: `someElement.dispatchEvent(event)`
  - jQuery: `$el.trigger(event)`

### History
- `history` returns JavaScript object that provides an interface for manipulating the browser history 
  - `window.history`
- Think of `history` as a stack

### Side Note
- ES8 nomenclature for promises

```javascript
async function x() {
  let result = await y();
  return result;
}
// Same as above
// y().then(result => x());

async function y() {
  return someValue;
}
```
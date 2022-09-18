var data;

$.get('input.json', function(d) {
  data = JSON.parse(d);
  // loop through all books
  console.log(data);
});

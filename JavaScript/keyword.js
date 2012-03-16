/** http://ariya.ofilabs.com/2012/03/most-popular-javascript-keywords.html **/

// use with Node.js and http://esprima.org/

// node keyword.js myapp.js mylib.js others/*.js | sort | uniq -c | sort -nr
// or
// find /path/to/dir -type f -name '*.js' -exec node keyword.js '{}' + |
//   sort | uniq -c |  sort -nr


var fs = require('fs'),
    esprima = require('esprima'),
    files = process.argv.splice(2);
 
files.forEach(function (filename) {
    var content = fs.readFileSync(filename, 'utf-8'),
        tokens = esprima.parse(content, { tokens: true }).tokens;
 
    tokens.forEach(function (token) {
        if (token.type === 'Keyword') {
            console.log(token.value);
        }
    });
});




// Get all ghostinspector suites
// https://github.com/ghost-inspector/node-ghost-inspector
// npm i ghost-inspector

const API_KEY = process.env.GHOSTINSPECTOR_API_KEY || '';
console.log('API_KEY:', API_KEY);

const fs = require('fs');
const GhostInspector = require('ghost-inspector')(API_KEY);

function execute() {
  return GhostInspector.getSuites()
    .then((suites) => {
      return Promise.all(suites.map((suite) => {
        console.log(suite.name, suite._id);
        const filename = `suite-${suite.name.replace(/\s+/g, '-').toLowerCase()}.json`;
        // downloadSuiteSeleniumHtml .zip
        // downloadSuiteSeleniumJson .zip
        // downloadSuiteSeleniumSide .side
        return GhostInspector.downloadSuiteSeleniumSide(suite._id, filename)
          .then((something) => {
            console.log(typeof something);

            const json = fs.readFileSync(filename, 'utf8');
            const data = JSON.parse(json);
            fs.writeFileSync(filename, JSON.stringify(data, null, '  '), 'utf8');

            return something;
          })
          .catch((error) => {
            console.error('Could not download test suite from GhostInspector');
            console.error(error);
          });
        })
      );
    })
    .catch((error) => {
      console.error('Could not fetch test suites from GhostInspector');
      console.error(error);
    });
}

execute();

const doResponse = (_request) => (response) => {
  const characters = [];
  const result = btoa(JSON.stringify({ characters }));
  const h = `stack run -- "${result}"`;
  require('child_process').exec(h, (error, stdout, stderr) => {
    if(stderr || error || stdout === undefined || stdout === null){
      response.status(404);
    } else {
      response.setHeader('content-type', 'text/plain');
      response.send(`${new Date().getMilliseconds()} ${stdout}`);
    }
  });
};

require('express')()
  .use(require('body-parser').json())
  .get('/', (request, response) => {
    doResponse(request)(response);
  }).post('/', (request, response) => {
    doResponse(request)(response);
  }).listen(80, () => {
    console.log('App listening on port 80');
  });


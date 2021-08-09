require('express')()
  .use(require('body-parser').json())
  .get('/', (_request, response) => {
    response.send('hello');
  }).post('/', (request, response) => {
    const { body } = request;
    response.send(`${body}`);
  }).listen(80, () => {
    console.log('App listening on port 80');
  });


const FormData = require("form-data");
const fs = require("fs");
const https = require("https");

let data = null;
process.stdin.on("data", d => {
  if(!data)
    data = d;
  else
    data = Buffer.concat([data,d], data.length + d.length);
});
process.stdin.on('end', () => {
  let mimetype = "image/png";
  let fileExt = "png";
  let amount = "7";
  const argv = process.argv;
  argv.forEach((elem, index) => {
    if(elem === "--type") {
      mimetype = argv[index + 1];
    } else if (elem === "--ext") {
      fileExt = argv[index+1];
    } else if (elem === "--amount") {
      amount = argv[index+1];
    }
  });
  const form_data = new FormData();
  form_data.append('datafile', data, {
    filename: 'file.' + fileExt,
    contentType: mimetype,
    knownLength: data.length
  });
  const h = {
      ...form_data.getHeaders(),
      Authorization: process.env.TOKEN,
  };
 const r =  https.request({
    method: 'post',
    host: 'i.liz3.net',
    path: '/add/' + amount,
    headers:  h,
  }, res => {
    res.on('data', d => {
      process.stdout.write(`https://i.liz3.net/d/${d}`);
    })

  })

  form_data.pipe(r);

})

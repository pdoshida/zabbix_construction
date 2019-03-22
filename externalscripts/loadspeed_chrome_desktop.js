var page = require('webpage').create(),
    system = require('system'),
    t,
    adress;

if (system.args.length === 1) {
    console.log('Usage: loadspeed.js <some URL>');
}

t = Date.now();
address = system.args[1];

page.settings = {
  userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
};

page.open(address, function(status) {
    if (status !== 'success') {
        console.log('FAIL to load the address');
    } else {
        t = Date.now() - t;
        console.log(t);
    }
    phantom.exit();
});

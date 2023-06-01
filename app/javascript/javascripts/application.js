// Entry point for the build script in your package.json
// The entry point is the file that Webpack will look for to start building your assets. By default, Webpack will look for a file named application.js in the app/javascript/packs directory. This is the file that Rails generates for you when you run rails webpacker:install.
// 
// If you want to change the name of this file, you can do so by updating the entry key in the webpacker configuration file. For example, if you wanted to change the entry point to app/javascript/application.js, you would update the entry key in config/webpacker.yml to look like this:

import '../stylesheets/application.scss'

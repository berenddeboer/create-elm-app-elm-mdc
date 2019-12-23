'use strict';

const path = require('path');
const fs = require('fs');

const appDirectory = fs.realpathSync(process.cwd());
const resolveApp = relativePath => path.resolve(appDirectory, relativePath);

module.exports = {
  configureWebpack: (config, env) => {
    // Manipulate the config object and return it.
    // There should be a better way to have Elm code reside somewhere else
    // than elm directory.
    config.module.rules[3].include = resolveApp('./elm')
    return config;
  }
}

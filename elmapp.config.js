'use strict';

const path = require('path');
const fs = require('fs');
const merge = require('webpack-merge');
const autoprefixer = require('autoprefixer');
//const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const appDirectory = fs.realpathSync(process.cwd());
const resolveApp = relativePath => path.resolve(appDirectory, relativePath);

module.exports = {
  configureWebpack: (config, env) => {
    // Manipulate the config object and return it.
    // There should be a better way to have Elm code reside somewhere else
    // than elm directory.
    config.module.rules[3].include = resolveApp('./elm')

    const my_config = {
      module: {
        rules: [ {
          test: /\.scss$/,
          use: [
            require.resolve('style-loader'),
            {
              loader: require.resolve('css-loader'),
              options: {
                importLoaders: 1,
                //minimize: true,
                sourceMap: env == "development"
              },
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                // Necessary for external CSS imports to work
                // https://github.com/facebookincubator/create-react-app/issues/2677
                ident: 'postcss',
                plugins: () => [
                  require('postcss-flexbugs-fixes'),
                  autoprefixer({
                    flexbox: 'no-2009',
                  }),
                ],
              },
            },
            {
              loader: 'sass-loader',
              options: {
                implementation: require('dart-sass'),
                fiber: require('fibers'),
                importer: require('./material-sass-importer'),
                //includePaths: ["elm-mdc/node_modules"]
              }
            },
          ]
        }]
      }
    }

    return merge(config, my_config);
  }
}

const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');
const glob = require('glob');

module.exports = {
  mode: 'production',
  entry: {
    'bundle.js': glob
      .sync('build/static/?(js|css)/main.*.?(js|css)')
      .map((f) => path.resolve(__dirname, f))
  },
  output: {
    filename: 'build/static/js/bundle.min.js'
  },
  module: {
    rules: [
      {
        test: /\.(css|sass|scss)$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      }
    ]
  },
  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin()]
  }
};

const path = require('path');
const fs = require('fs');
let { version } = require('./package');
/* eslint-disable no-undef */
module.exports = {
  require: [path.resolve(__dirname, 'styleguide/setup.sh')],
  printBuildInstructions(config) {
    console.log(`Style guide published to ${config.styleguideDir}. Something else interesting.`);
  },
  styles: function () {
    return {
      logo: {
        logo: {
          // we can now change the color used in the logo item to use the theme's `link` color
          color: 'white'
        }
      }
    };
  },
  skipComponentsWithoutExample: true,
  sections: [
    {
      name: 'Home',
      external: true,
      href: 'https://home.ddkits.com'
    },
    {
      name: 'Introduction',
      content: 'docs/introduction.md'
    },
    {
      name: 'Documentation',
      description:
        'API Doc Pro UI Render, is the smallest and fastest Async and Open API UI rendering, using React and Bootstrap.',
      sections: [
        {
          name: 'Installation',
          content: 'docs/installation.md',
          description: 'Simple to use'
        },
        {
          name: 'Configuration',
          content: 'docs/configuration.md'
        },
        {
          name: 'DDKits Editor',
          external: true,
          href: 'https://DDKits.com'
        }
      ]
    },
    {
      name: 'Demo',
      components: 'src/app.js'
      //   defaultExample: true,
    },
    {
      name: 'Contributors',
      content: 'docs/contributors.md'
      //   defaultExample: true,
    },
    {
      name: 'Core',
      components: '*.sh',
      defaultExample: false,
      sectionDepth: 0
    },
    {
      name: 'Templates',
      components: 'ddkits-files/**/*.sh',
      defaultExample: false,
      sectionDepth: 2
    },
    {
      name: 'Helpers',
      components: 'ddkits-files/ddkits/*.sh',
      defaultExample: false,
      sectionDepth: 0
    }
  ],
  moduleAliases: {
    'rsg-example': path.resolve(__dirname, 'src')
  },
  version,
  ribbon: {
    text: 'Sponsor Me!',
    url: 'https://opencollective.com/reallexi'
  },
  defaultExample: false,
  webpackConfig: {
    module: {
      rules: [
        {
          test: /\.jsx?$/,
          exclude: /node_modules/,
          loader: 'babel-loader'
        },
        {
          test: /\.css$/,
          use: ['style-loader', 'css-loader']
        },
        {
          test: /\.scss$/,
          use: ['style-loader', 'css-loader', 'sass-loader']
        },
        {
          test: /\.sh$/,
          use: ['text-loader']
        }
      ]
    }
  },
  // Don't include an Object.assign ponyfill, we have our own
  // pagePerSection: process.env.NODE_ENV !== 'production',
  mountPointId: 'DDKits',
  tocMode: 'collapse', //'collapse' | 'expand'
  exampleMode: 'collapse', // 'hide' | 'collapse' | 'expand'
  usageMode: 'hide', // 'hide' | 'collapse' | 'expand',
  updateExample(props, exampleFilePath) {
    // props.settings are passed by any fenced code block, in this case
    const { settings, lang } = props;
    // "../mySourceCode.sh"
    if (settings?.file && typeof settings.file === 'string') {
      // "absolute path to mySourceCode.sh"
      const filepath = path.resolve(exampleFilePath, settings.file);
      // displays the block as static code
      settings.static = true;
      // no longer needed
      delete settings.file;
      return {
        content: fs.readFileSync(filepath, 'utf8'),
        settings,
        lang
      };
    }
    return props;
  },
  theme: {
    color: {
      base: '#000000',
      light: '#0f3452',
      lightest: '#ccc',
      link: '#282c34',
      linkHover: '#343a40',
      focus: 'rgba(22, 115, 177, 0.25)',
      border: '#e8e8e8',
      name: '#f8f9fa',
      type: '#905',
      error: '#c00',
      baseBackground: '#ccc',
      codeBackground: '#000',
      sidebarBackground: '#fff',
      ribbonBackground: '#000',
      ribbonText: '#fff',
      // Based on default Prism theme
      codeBase: '#fff',
      codeComment: '#6d6d6d',
      codePunctuation: '#999',
      codeProperty: '#905',
      codeDeleted: '#905',
      codeString: '#690',
      codeInserted: '#690',
      codeOperator: '#9a6e3a',
      codeKeyword: '#1673b1',
      codeFunction: '#DD4A68',
      codeVariable: '#e90'
    },
    spaceFactor: 10,
    sidebarWidth: 300,
    maxWidth: 1400,
    fontFamily: {
      base: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"'
    }
  }
};

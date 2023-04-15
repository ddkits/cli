To configure the basic usage of APIDocPro UI render for any of the specifications, what you need to do is to import the package 

### CDN
```html
Coming soon!!
```


### React

```text
// React Component
import { ApiDocPro } from 'openapi-asyncapi-ui-render'
// Custom Theme can be clones from No theme example when needed
import * as THEME from 'openapi-asyncapi-ui-render/theme/noTheme/noTheme';
// Styles import
// import 'openapi-asyncapi-ui-render/theme/default/assets/styles/apidocpro-styles.scss';

   <ApiDocPro
        title="APIDocPro OpenAPI/AysncAPI UI"
        rightRegion // Bool default true
        leftRegion // Bool default true
        header // Bool default true
        theme={THEME} // Object of const default can be clones for new theme design or contribute
        spec={spec} // string
      />
```
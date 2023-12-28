# React-Native-Pictures

<div align="center">
  <video src="https://github.com/PierreCapo/react-native-pictures/assets/26744253/515ab32a-f0a2-4771-ad07-f494eee4e78d"></video>
</div>

React Native Pictures is a comprehensive toolkit for handling images within your React Native application. Our goal is to provide a modern, efficient codebase using Swift and Kotlin, offering common solutions for image-related features in your React Native app.

This library integrates a custom native iOS implementation and utilizes [PhotoView](https://github.com/Baseflow/PhotoView) on Android. Please note that this project is in its early stages—expect breaking changes before the release of v1.

## Installation

```sh
npm install react-native-pictures
```

## Usage

Here's a simple example to showcase how you can use React Native Pictures in your app:

```js
import PictureManager from 'react-native-pictures';

// ...

const imageUrl = "https://images.unsplash.com/photo-1462331940025-496dfbfc7564"
const result = PictureManager.openPictureViewer(imageUrl);
```

## Roadmap

- **Custom Android Implementation:** Replace PhotoView with a custom implementation, as PhotoView is no longer maintained.
- **Native Component Integration:** Transition from Activity/UIViewController to View/UIView for seamless embedding within React Native screens. This will allow greater flexibility for consumer applications.
- **Image Cropping Feature:** Implement a cropping feature to leverage the pan and zoom capabilities, making it easier to integrate an image cropping screen.


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

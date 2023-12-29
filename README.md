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

Here's a simple example to showcase how you can use React Native Pictures in your app.
It's recommended that the viewer takes the entire available space:

```js
import {PictureViewer} from 'react-native-pictures';

// ...

<PictureViewer
  imageUrl={"https://w.wallhaven.cc/full/r4/wallhaven-r42m09.jpg"}
  style={{
    width: "100%",
    height: "100%"
  }}
/>
```

## API

### PictureViewer

| Props | Type | Description |
| --- | --- | --- |
| imageUrl | string | The remote image url you want to see |
| style | ViewStyle | Style of PictureViewer.

## Roadmap

- **More controls:** Add ability to display local images, gesture event listeners, etc.
- **Custom Android Implementation:** Replace PhotoView with a custom implementation, as PhotoView is no longer maintained.
- **Image Cropping Feature:** Implement a cropping feature to leverage the pan and zoom capabilities, making it easier to integrate an image cropping screen.


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

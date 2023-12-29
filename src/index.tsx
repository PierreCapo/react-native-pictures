import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-pictures' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type PicturesProps = {
  style?: ViewStyle;
  imageUrl: string;
};

const ComponentName = 'PicturesView';

export const PicturesViewer =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<PicturesProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { PicturesViewer } from 'react-native-pictures';

export default function App() {
  return (
    <View style={styles.container}>
      <PicturesViewer
        style={styles.box}
        imageUrl={'https://w.wallhaven.cc/full/r4/wallhaven-r42m09.jpg'}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
  },
  box: {
    width: '100%',
    height: '100%',
    marginVertical: 20,
  },
});

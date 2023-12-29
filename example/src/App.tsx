import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { PicturesView } from 'react-native-pictures';

export default function App() {
  return (
    <View style={styles.container}>
      <PicturesView
        style={styles.box}
        imageUrl={
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564'
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'red',
  },
  box: {
    width: '100%',
    height: '100%',
    marginVertical: 20,
  },
});

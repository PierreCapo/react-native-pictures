import * as React from 'react';

import { StyleSheet, View, Text, Pressable } from 'react-native';
import { openPictureViewer } from 'react-native-pictures';

export default function App() {
  return (
    <View style={styles.container}>
      <Pressable
        onPress={() => {
          openPictureViewer(
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'
          );
        }}
        style={{
          height: 50,
          paddingHorizontal: 32,
          borderRadius: 12,
          backgroundColor: 'cyan',
          justifyContent: 'center',
          alignItems: 'center',
        }}
      >
        <Text>Click me</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

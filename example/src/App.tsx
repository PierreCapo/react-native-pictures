import * as React from 'react';

import { StyleSheet, View, Text, Pressable } from 'react-native';
import { openPictureViewer } from 'react-native-pictures';

export default function App() {
  return (
    <View style={styles.container}>
      <Pressable
        onPress={() => {
          openPictureViewer(
            'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=2422&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
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

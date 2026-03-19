import React from 'react';
import { Alert, Button, Text, View, StyleSheet } from 'react-native';
import { TossLogin } from 'react-native-toss';

export default function App() {
  const [status, setStatus] = React.useState<string>('Ready');

  React.useEffect(() => {
    TossLogin.configure('YOUR_APP_KEY');
  }, []);

  const onPressLogin = async () => {
    const available = await TossLogin.isLoginAvailable();

    if (!available) {
      Alert.alert(
        '토스앱이 설치되어 있지 않습니다.',
        '토스앱을 설치하시겠습니까?',
        [
          { text: '취소' },
          {
            text: '설치',
            onPress: () => TossLogin.moveToBridgePageForNoApp(),
          },
        ]
      );
      return;
    }

    setStatus('Logging in...');
    const result = await TossLogin.login();

    switch (result.type) {
      case 'success':
        setStatus(`Success: ${result.authCode}`);
        break;
      case 'cancelled':
        setStatus('Cancelled');
        break;
      case 'error':
        setStatus(`Error: [${result.code}] ${result.message}`);
        break;
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.status}>{status}</Text>
      <Button title="토스로 로그인" onPress={onPressLogin} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  status: {
    fontSize: 16,
    marginBottom: 20,
    textAlign: 'center',
  },
});

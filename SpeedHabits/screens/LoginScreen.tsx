import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  Dimensions,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useNavigation } from '@react-navigation/native';

const { width } = Dimensions.get('window');

const LoginScreen = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigation = useNavigation();

  const handleLogin = () => {
    // Dummy login - replace with Firebase later
    if (email === 'test@speedhabits.com' && password === 'speedrun') {
      Alert.alert('Logged In!', 'Welcome back, speedrunner!', [
        { text: 'OK', onPress: () => navigation.goBack() }
      ]);
    } else {
      Alert.alert('Error', 'Use test@speedhabits.com / speedrun');
    }
  };

  return (
    <LinearGradient colors={['#0a0a0a', '#1a1a2e']} style={styles.container}>
      <Text style={styles.title}>LOGIN</Text>
      <Text style={styles.subtitle}>Enter your speedrun credentials</Text>
      
      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="test@speedhabits.com"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
        />
        <TextInput
          style={styles.input}
          placeholder="speedrun"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </View>

      <TouchableOpacity style={styles.loginButton} onPress={handleLogin}>
        <Text style={styles.loginText}>LOGIN →</Text>
      </TouchableOpacity>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 40, justifyContent: 'center' },
  title: { 
    fontSize: 40, fontWeight: '900', color: '#fff', 
    textAlign: 'center', letterSpacing: 3 
  },
  subtitle: { 
    fontSize: 16, color: '#a0a0a0', textAlign: 'center', 
    marginBottom: 40, marginTop: 8 
  },
  inputContainer: { gap: 16, marginBottom: 32 },
  input: {
    backgroundColor: 'rgba(255,255,255,0.1)',
    padding: 16,
    borderRadius: 12,
    color: '#fff',
    fontSize: 16,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.2)',
  },
  loginButton: {
    backgroundColor: '#00d4ff',
    paddingVertical: 18,
    borderRadius: 25,
    alignItems: 'center',
  },
  loginText: { fontSize: 18, fontWeight: '800', color: '#0a0a0a' },
});

export default LoginScreen;

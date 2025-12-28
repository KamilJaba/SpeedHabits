import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
  Animated,
  ScrollView,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

type RootStackParamList = {
  Welcome: undefined;
  Login: undefined;
};

type NavigationProp = NativeStackNavigationProp<RootStackParamList>;

const { width, height } = Dimensions.get('window');

const WelcomeScreen = () => {
  const navigation = useNavigation<NavigationProp>();
  const fadeAnim = React.useRef(new Animated.Value(0)).current;
  const timerAnim = React.useRef(new Animated.Value(0)).current;

  React.useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 1000,
        useNativeDriver: true,
      }),
      Animated.loop(
        Animated.timing(timerAnim, {
          toValue: 1,
          duration: 2000,
          useNativeDriver: true,
        })
      ),
    ]).start();
  }, []);

  const SpeedrunTimer = () => {
    const rotatingValue = timerAnim.interpolate({
      inputRange: [0, 1],
      outputRange: ['0deg', '360deg'],
    });

    return (
      <Animated.View style={[styles.timerContainer, { opacity: fadeAnim }]}>
        <LinearGradient
          colors={['#00d4ff', '#0099cc']}
          style={styles.timerGradient}
        >
          <Animated.View
            style={[
              styles.timerIcon,
              {
                transform: [{ rotate: rotatingValue }],
              },
            ]}
          >
            <Text style={styles.timerText}>⏱️</Text>
          </Animated.View>
        </LinearGradient>
        <Text style={styles.timerLabel}>SPEEDRUN MODE</Text>
      </Animated.View>
    );
  };

  const HabitBlock = ({ title, time, color }: { title: string; time: string; color: string }) => (
    <View style={[styles.habitBlock, { backgroundColor: color }]}>
      <Text style={styles.habitTitle}>{title}</Text>
      <Text style={styles.habitTime}>{time}</Text>
    </View>
  );

  return (
    <LinearGradient colors={['#0a0a0a', '#1a1a2e', '#16213e']} style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <Animated.View style={{ opacity: fadeAnim }}>
          <View style={styles.header}>
            <Text style={styles.title}>SPEEDHABITS</Text>
            <Text style={styles.subtitle}>Race Your Best Times</Text>
          </View>

          <SpeedrunTimer />

          <View style={styles.habitsSection}>
            <Text style={styles.sectionTitle}>Your Speedrun Routine</Text>
            <View style={styles.habitsGrid}>
              <HabitBlock title="Wake Up" time="5:42 AM PB" color="#ff6b6b" />
              <HabitBlock title="Gym Flow" time="38m 12s" color="#4ecdc4" />
              <HabitBlock title="Code Sprint" time="2h 14m" color="#45b7d1" />
              <HabitBlock title="Meal Prep" time="14m 33s" color="#f9ca24" />
            </View>
          </View>

          <TouchableOpacity 
            style={styles.ctaButton}
            onPress={() => navigation.navigate('Login')}
          >
            <Text style={styles.ctaText}>START SPEEDRUN →</Text>
          </TouchableOpacity>

          <Text style={styles.footer}>Beat yesterday. Race tomorrow.</Text>
        </Animated.View>
      </ScrollView>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    padding: 30,
    paddingTop: 60,
    alignItems: 'center',
  },
  header: {
    alignItems: 'center',
    marginBottom: 40,
  },
  title: {
    fontSize: 48,
    fontWeight: '900',
    backgroundColor: 'rgba(255,255,255,0.1)',
    color: '#fff',
    letterSpacing: 4,
    textShadowColor: 'rgba(0,0,0,0.5)',
    textShadowOffset: { width: 2, height: 2 },
    textShadowRadius: 10,
  },
  subtitle: {
    fontSize: 18,
    color: '#a0a0a0',
    marginTop: 8,
    fontWeight: '600',
  },
  timerContainer: {
    alignItems: 'center',
    marginBottom: 50,
  },
  timerGradient: {
    width: 120,
    height: 120,
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#00d4ff',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.3,
    shadowRadius: 20,
    elevation: 10,
  },
  timerIcon: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: 'rgba(255,255,255,0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  timerText: {
    fontSize: 32,
    fontWeight: 'bold',
  },
  timerLabel: {
    fontSize: 14,
    color: '#00d4ff',
    marginTop: 12,
    fontWeight: '700',
    letterSpacing: 2,
  },
  habitsSection: {
    alignItems: 'center',
    width: '100%',
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '800',
    color: '#fff',
    marginBottom: 24,
  },
  habitsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    width: '100%',
  },
  habitBlock: {
    width: (width - 90) / 2,
    height: 100,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
    justifyContent: 'space-between',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 16,
    elevation: 8,
  },
  habitTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#fff',
  },
  habitTime: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.8)',
    fontWeight: '600',
  },
  ctaButton: {
    backgroundColor: '#00d4ff',
    paddingHorizontal: 40,
    paddingVertical: 18,
    borderRadius: 30,
    marginTop: 20,
    shadowColor: '#00d4ff',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.4,
    shadowRadius: 20,
    elevation: 10,
  },
  ctaText: {
    fontSize: 18,
    fontWeight: '800',
    color: '#0a0a0a',
    letterSpacing: 1,
  },
  footer: {
    fontSize: 14,
    color: '#a0a0a0',
    marginTop: 40,
    fontStyle: 'italic',
  },
});

export default WelcomeScreen;

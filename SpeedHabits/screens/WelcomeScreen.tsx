import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
  Animated,
  ScrollView,
  Modal,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useColorScheme } from 'react-native';

type RootStackParamList = {
  Welcome: undefined;
  Login: undefined;
};

type NavigationProp = NativeStackNavigationProp<RootStackParamList>;

const { width: screenWidth } = Dimensions.get('window');

const WelcomeScreen = () => {
  const navigation = useNavigation<NavigationProp>();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  
  const [showRoutines, setShowRoutines] = useState(false);

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
          duration: 3000,
          useNativeDriver: true,
        })
      ),
    ]).start();
  }, []);

[image:37]

  const StatsCard = () => {
    const rotatingValue = timerAnim.interpolate({
      inputRange: [0, 1],
      outputRange: ['0deg', '360deg'],
    });

    return (
      <Animated.View style={[styles.statsCard, styles.iOSShadow, { opacity: fadeAnim }]}>
        <View style={styles.statsHeader}>
          <Text style={[styles.statsTitle, styles.systemFontSemibold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
            Speedrun summaries
          </Text>
          <TouchableOpacity 
            style={styles.showMoreButton}
            onPress={() => setShowRoutines(true)}
            activeOpacity={0.7}
          >
            <Text style={[styles.showMoreText, styles.systemFontMedium, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
              Show all
            </Text>
          </TouchableOpacity>
        </View>

        <View style={styles.statsGrid}>
          <View style={styles.statItem}>
            <LinearGradient
              colors={isDark ? ['#2c2c2e', '#3c3c43'] : ['#f2f2f7', '#e5e5ea']}
              style={styles.statIcon}
            >
              <Animated.View
                style={[
                  styles.statIconInner,
                  { transform: [{ rotate: rotatingValue }] },
                ]}
              >
                <Text style={styles.statEmoji}>⏱️</Text>
              </Animated.View>
            </LinearGradient>
            <Text style={[styles.statLabel, styles.systemFontMedium, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
              This week
            </Text>
            <Text style={[styles.statValue, styles.systemFontBold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
              87% PB
            </Text>
            <Text style={[styles.statChange, styles.systemFontSemibold, { color: isDark ? '#34c759' : '#30d158' }]}>
              +12% better
            </Text>
          </View>

          <View style={styles.statItem}>
            <View style={[styles.statIcon, { backgroundColor: isDark ? '#2c2c2e' : '#f2f2f7' }]}>
              <Text style={styles.statEmoji}>📊</Text>
            </View>
            <Text style={[styles.statLabel, styles.systemFontMedium, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
              Consistency
            </Text>
            <Text style={[styles.statValue, styles.systemFontBold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
              5/7 days
            </Text>
            <Text style={[styles.statChange, styles.systemFontSemibold, { color: isDark ? '#ff9500' : '#ff9f0a' }]}>
              -1 day
            </Text>
          </View>

          <View style={styles.statItem}>
            <View style={[styles.statIcon, { backgroundColor: isDark ? '#2c2c2e' : '#f2f2f7' }]}>
              <Text style={styles.statEmoji}>🔥</Text>
            </View>
            <Text style={[styles.statLabel, styles.systemFontMedium, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
              Streak
            </Text>
            <Text style={[styles.statValue, styles.systemFontBold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
              12 days
            </Text>
            <Text style={[styles.statChange, styles.systemFontSemibold, { color: isDark ? '#34c759' : '#30d158' }]}>
              New PB!
            </Text>
          </View>
        </View>
      </Animated.View>
    );
  };

  const HabitBlock = ({ title, time, change, isImproved }: { 
    title: string; 
    time: string; 
    change: string; 
    isImproved: boolean;
  }) => (
    <TouchableOpacity activeOpacity={0.8}>
      <View style={[
        styles.habitCard, 
        styles.iOSCardShadow,
        { backgroundColor: isDark ? '#1c1c1e' : '#ffffff' }
      ]}>
        <Text style={[styles.habitTitle, styles.systemFontSemibold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
          {title}
        </Text>
        <Text style={[styles.habitTime, styles.systemFontBold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
          {time}
        </Text>
        <Text style={[
          styles.habitChange,
          styles.systemFontMedium,
          { 
            color: isImproved 
              ? (isDark ? '#34c759' : '#30d158')
              : (isDark ? '#ff453a' : '#ff453a')
          }
        ]}>
          {change}
        </Text>
      </View>
    </TouchableOpacity>
  );

  const RoutinesModal = () => (
    <Modal
      visible={showRoutines}
      transparent
      animationType="slide"
      onRequestClose={() => setShowRoutines(false)}
    >
      <View style={styles.modalOverlay}>
        <View style={[styles.modalCard, { backgroundColor: isDark ? '#000000' : '#f2f2f7', backdropFilter: 'blur(20px)' }]}>
          <View style={styles.modalHeader}>
            <Text style={[styles.modalTitle, styles.systemFontSemibold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
              All Speedruns
            </Text>
            <TouchableOpacity 
              style={styles.closeButton}
              onPress={() => setShowRoutines(false)}
            >
              <Text style={[styles.closeIcon, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>×</Text>
            </TouchableOpacity>
          </View>
          
          <ScrollView style={styles.modalList}>
            {[
              { title: 'Morning Routine', time: '42m 15s', change: '+3m 12s', improved: false },
              { title: 'Evening Wind Down', time: '28m 45s', change: '-1m 33s', improved: true },
              { title: 'Work Sprint', time: '2h 14m', change: '+8m', improved: false },
              { title: 'Weekend Flow', time: '1h 32m', change: '-4m 22s', improved: true }
            ].map((routine, i) => (
              <TouchableOpacity key={i} style={styles.modalItem}>
                <Text style={[styles.modalItemText, styles.systemFontSemibold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
                  {routine.title}
                </Text>
                <Text style={[styles.modalItemSub, styles.systemFontMedium, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
                  {routine.time} • {routine.change} vs last week
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>
      </View>
    </Modal>
  );

  const FAB = () => (
    <TouchableOpacity 
      style={[
        styles.fab,
        styles.iOSFABShadow,
        { 
          backgroundColor: isDark ? '#0a84ff' : '#007aff',
        }
      ]}
      activeOpacity={0.8}
    >
      <Text style={styles.fabIcon}>+</Text>
    </TouchableOpacity>
  );

  return (
    <>
      <LinearGradient
        colors={isDark 
          ? ['#000000', '#0f0f11', '#1c1c1e'] 
          : ['#fafbff', '#f5f7fa', '#e8edff']
        }
        style={styles.container}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
          contentInsetAdjustmentBehavior="automatic"
        >
          <Animated.View style={{ opacity: fadeAnim }}>
            {/* Large Title Header */}
            <View style={styles.header}>
              <Text style={[styles.largeTitle, styles.systemFontHeavy, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
                SpeedHabits
              </Text>
              <Text style={[styles.subtitle, styles.systemFontRegular, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
                Weekly progress at a glance
              </Text>
            </View>

            {/* Stats card */}
            <StatsCard />

            {/* Routines section */}
            <View style={styles.habitsSection}>
              <View style={styles.sectionHeaderRow}>
                <Text style={[styles.sectionTitle, styles.systemFontSemibold, { color: isDark ? '#f2f2f7' : '#1d1d1f' }]}>
                  Your Routines
                </Text>
                <Text style={[styles.sectionSubtitle, styles.systemFontRegular, { color: isDark ? '#8e8e93' : '#6e6e73' }]}>
                  Monday schedule
                </Text>
              </View>

              <View style={styles.habitsGrid}>
                <HabitBlock 
                  title="Gym - Back Workout" 
                  time="38m 12s PB" 
                  change="+2m 45s" 
                  isImproved={false}
                />
                <HabitBlock 
                  title="Code Sprint" 
                  time="2h 14m" 
                  change="-8m" 
                  isImproved={true}
                />
                <HabitBlock 
                  title="Meal Prep" 
                  time="14m 33s" 
                  change="+45s" 
                  isImproved={false}
                />
              </View>
            </View>

            <Text style={[styles.footer, styles.systemFontRegular, { color: isDark ? '#8e8e93' : '#86868b' }]}>
              Tap routine to start tracking
            </Text>
          </Animated.View>
        </ScrollView>

        {/* FAB */}
        <FAB />
      </LinearGradient>

      <RoutinesModal />
    </>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingTop: 80,
    paddingBottom: 120,
  },

  // iOS Native Shadows
  iOSShadow: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.06,
    shadowRadius: 20,
    elevation: 3,
  },
  iOSCardShadow: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 12,
    elevation: 2,
  },
  iOSFABShadow: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.3,
    shadowRadius: 20,
    elevation: 12,
  },

  // FAB
  fab: {
    position: 'absolute',
    right: 20,
    bottom: 32,
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  fabIcon: {
    fontSize: 28,
    fontWeight: '300',
    color: '#ffffff',
  },

  // Large Title Header (iOS style)
  header: {
    marginBottom: 44,
  },
  largeTitle: {
    fontSize: 40,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 17,
    marginTop: 8,
  },

  // Stats card
  statsCard: {
    borderRadius: 20,
    padding: 28,
    marginBottom: 32,
    backgroundColor: 'transparent',
  },
  statsHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  statsTitle: {
    fontSize: 20,
  },
  showMoreButton: {
    paddingHorizontal: 12,
    paddingVertical: 6,
  },
  showMoreText: {
    fontSize: 15,
  },
  statsGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  statItem: {
    alignItems: 'center',
    flex: 1,
    paddingHorizontal: 8,
  },
  statIcon: {
    width: 60,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  statIconInner: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#ffffff',
    justifyContent: 'center',
    alignItems: 'center',
  },
  statEmoji: {
    fontSize: 22,
  },
  statLabel: {
    fontSize: 13,
    marginBottom: 4,
    textAlign: 'center',
  },
  statValue: {
    fontSize: 22,
  },
  statChange: {
    fontSize: 13,
    marginTop: 2,
  },

  // Habits
  habitsSection: {
    marginBottom: 32,
  },
  sectionHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 20,
  },
  sectionSubtitle: {
    fontSize: 15,
  },
  habitsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginHorizontal: -8,
  },
  habitCard: {
    width: (screenWidth - 40 - 16) / 2,
    height: 108,
    borderRadius: 16,
    padding: 20,
    marginHorizontal: 8,
    marginBottom: 20,
    justifyContent: 'space-between',
  },
  habitTitle: {
    fontSize: 16,
  },
  habitTime: {
    fontSize: 17,
    marginTop: 4,
  },
  habitChange: {
    fontSize: 14,
    marginTop: 4,
  },

  footer: {
    fontSize: 15,
    textAlign: 'center',
    marginTop: 12,
  },

  // Modal (iOS sheet style)
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.3)',
    justifyContent: 'flex-end',
  },
  modalCard: {
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    padding: 28,
    maxHeight: '75%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  modalTitle: {
    fontSize: 24,
  },
  closeButton: {
    padding: 8,
  },
  closeIcon: {
    fontSize: 22,
  },
  modalList: {
    flex: 1,
  },
  modalItem: {
    paddingVertical: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: 'rgba(255,255,255,0.12)',
  },
  modalItemText: {
    fontSize: 17,
  },
  modalItemSub: {
    fontSize: 15,
    marginTop: 4,
  },

  // System font weights (iOS SF Pro)
  systemFontHeavy: {
    fontWeight: '800',
    fontFamily: Platform.select({ ios: 'SFProDisplay-Heavy', android: 'System' }),
  },
  systemFontBold: {
    fontWeight: '700',
    fontFamily: Platform.select({ ios: 'SFProDisplay-Bold', android: 'System' }),
  },
  systemFontSemibold: {
    fontWeight: '600',
    fontFamily: Platform.select({ ios: 'SFProText-Semibold', android: 'System' }),
  },
  systemFontMedium: {
    fontWeight: '500',
    fontFamily: Platform.select({ ios: 'SFProText-Medium', android: 'System' }),
  },
  systemFontRegular: {
    fontWeight: '400',
    fontFamily: Platform.select({ ios: 'SFProText-Regular', android: 'System' }),
  },
});

export default WelcomeScreen;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/time_capsule.dart';
import '../widgets/animated_garden_background.dart';
import '../widgets/capsule_card.dart';

/// Premium Capsule Garden Dashboard with mind-blowing animations
/// Features serene nature-inspired design with floating particles
class CapsuleGardenDashboard extends StatefulWidget {
  const CapsuleGardenDashboard({super.key});

  @override
  State<CapsuleGardenDashboard> createState() => _CapsuleGardenDashboardState();
}

class _CapsuleGardenDashboardState extends State<CapsuleGardenDashboard>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _headerController;
  late List<Animation<Offset>> _cardAnimations;
  late Animation<double> _headerOpacityAnimation;

  // Mock data for demonstration
  late List<TimeCapsule> _readyCapsules;
  late List<TimeCapsule> _growingCapsules;
  late List<TimeCapsule> _recentlyPlantedCapsules;
  late GardenStats _gardenStats;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateMockData();
    _startAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Create staggered animations for cards
    _cardAnimations = List.generate(8, (index) {
      final startTime = index * 0.1;
      final endTime = startTime + 0.6;
      
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          startTime.clamp(0.0, 1.0),
          endTime.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ));
    });
  }

  void _generateMockData() {
    final now = DateTime.now();
    
    _readyCapsules = [
      TimeCapsule(
        id: '1',
        title: 'Birthday wishes for Sarah',
        content: 'Hope your special day is wonderful!',
        recipientId: 'sarah_id',
        recipientName: 'Sarah',
        recipientInitial: 'S',
        plantedAt: now.subtract(const Duration(days: 30)),
        deliveryAt: now.subtract(const Duration(hours: 1)),
        growthStage: CapsuleGrowthStage.flowering,
        emoji: CapsuleGrowthStage.flowering.emoji,
        type: CapsuleType.birthday,
        isReady: true,
        progress: 1.0,
      ),
    ];

    _growingCapsules = [
      TimeCapsule(
        id: '2',
        title: 'Message to future me',
        content: 'Remember to stay positive!',
        recipientId: 'me_id',
        recipientName: 'Me',
        recipientInitial: 'M',
        plantedAt: now.subtract(const Duration(days: 60)),
        deliveryAt: now.add(const Duration(days: 180)),
        growthStage: CapsuleGrowthStage.tree,
        emoji: CapsuleGrowthStage.tree.emoji,
        type: CapsuleType.futureSelf,
        isReady: false,
        progress: 0.35,
      ),
      TimeCapsule(
        id: '3',
        title: 'Anniversary surprise',
        content: 'Happy anniversary my love!',
        recipientId: 'alex_id',
        recipientName: 'Alex',
        recipientInitial: 'A',
        plantedAt: now.subtract(const Duration(days: 10)),
        deliveryAt: now.add(const Duration(days: 4)),
        growthStage: CapsuleGrowthStage.sprout,
        emoji: CapsuleGrowthStage.sprout.emoji,
        type: CapsuleType.anniversary,
        isReady: false,
        progress: 0.78,
      ),
      TimeCapsule(
        id: '4',
        title: 'New Year reflection',
        content: 'Looking forward to growth this year',
        recipientId: 'me_id',
        recipientName: 'Me',
        recipientInitial: 'M',
        plantedAt: now.subtract(const Duration(days: 45)),
        deliveryAt: now.add(const Duration(days: 90)),
        growthStage: CapsuleGrowthStage.crystal,
        emoji: CapsuleGrowthStage.crystal.emoji,
        type: CapsuleType.personal,
        isReady: false,
        progress: 0.55,
      ),
      TimeCapsule(
        id: '5',
        title: 'Encouragement for mom',
        content: 'You are amazing and strong!',
        recipientId: 'mom_id',
        recipientName: 'Mom',
        recipientInitial: 'M',
        plantedAt: now.subtract(const Duration(days: 2)),
        deliveryAt: now.add(const Duration(days: 1)),
        growthStage: CapsuleGrowthStage.seed,
        emoji: CapsuleGrowthStage.seed.emoji,
        type: CapsuleType.encouragement,
        isReady: false,
        progress: 0.92,
      ),
    ];

    _recentlyPlantedCapsules = [
      TimeCapsule(
        id: '6',
        title: 'Graduation congratulations',
        content: 'So proud of your achievement!',
        recipientId: 'john_id',
        recipientName: 'John',
        recipientInitial: 'J',
        plantedAt: now,
        deliveryAt: now.add(const Duration(days: 330)),
        growthStage: CapsuleGrowthStage.seed,
        emoji: CapsuleGrowthStage.seed.emoji,
        type: CapsuleType.celebration,
        isReady: false,
        progress: 0.05,
      ),
      TimeCapsule(
        id: '7',
        title: 'Thank you note',
        content: 'Thank you for everything!',
        recipientId: 'dana_id',
        recipientName: 'Dana',
        recipientInitial: 'D',
        plantedAt: now.subtract(const Duration(hours: 1)),
        deliveryAt: now.add(const Duration(hours: 23)),
        growthStage: CapsuleGrowthStage.seed,
        emoji: CapsuleGrowthStage.seed.emoji,
        type: CapsuleType.gratitude,
        isReady: false,
        progress: 0.95,
      ),
    ];

    _gardenStats = GardenStats(
      totalPlanted: _readyCapsules.length + _growingCapsules.length + _recentlyPlantedCapsules.length,
      growing: _growingCapsules.length + _recentlyPlantedCapsules.length,
      ready: _readyCapsules.length,
      delivered: 12,
      recentlyPlanted: _recentlyPlantedCapsules.length,
      averageGrowthProgress: 0.65,
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _headerController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void _handlePlantNewCapsule() {
    HapticFeedback.mediumImpact();
    // TODO: Navigate to plant new capsule screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plant New Capsule feature coming soon!'),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }

  void _handleViewReady() {
    HapticFeedback.lightImpact();
    // TODO: Navigate to ready capsules screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View Ready Capsules feature coming soon!'),
        backgroundColor: AppColors.warmPeach,
      ),
    );
  }

  void _handleCapsuleTap(TimeCapsule capsule) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to capsule detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${capsule.title}'),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }

 

  Widget _buildGardenHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sageGreen, AppColors.sageGreenLight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌱', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Your Time Garden',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.pearlWhite,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Messages growing through time',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.pearlWhite.withAlpha(230),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Row(
            children: [
              _buildStatItem(
                _gardenStats.growing.toString(),
                'Growing',
              ),
              _buildStatDivider(),
              _buildStatItem(
                _gardenStats.ready.toString(),
                'Ready',
              ),
              _buildStatDivider(),
              _buildStatItem(
                _gardenStats.delivered.toString(),
                'Delivered',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.pearlWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.pearlWhite.withAlpha(204),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.pearlWhite.withAlpha(77),
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.spacingL,
        0,
        AppDimensions.spacingL,
        AppDimensions.spacingL,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      transform: Matrix4.translationValues(0, -12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              QuickActionButton(
                label: 'Plant New Capsule',
                emoji: '🌱',
                onTap: _handlePlantNewCapsule,
                isPrimary: true,
              ),
              const SizedBox(width: AppDimensions.spacingM),
              QuickActionButton(
                label: 'View Ready',
                emoji: '🎁',
                onTap: _handleViewReady,
                isPrimary: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGardenSection({
    required String title,
    required String emoji,
    required List<TimeCapsule> capsules,
    required int startIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  capsules.length.toString(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.spacingM,
              mainAxisSpacing: AppDimensions.spacingM,
              childAspectRatio: 0.75,
            ),
            itemCount: capsules.length,
            itemBuilder: (context, index) {
              final animationIndex = (startIndex + index).clamp(0, _cardAnimations.length - 1);
              return SlideTransition(
                position: _cardAnimations[animationIndex],
                child: CapsuleCard(
                  capsule: capsules[index],
                  onTap: () => _handleCapsuleTap(capsules[index]),
                  showAnimation: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: AnimatedGardenBackground(
        particleCount: 12,
        enableGradientShift: true,
        child: CustomScrollView(
          slivers: [
            // Garden Header
            SliverToBoxAdapter(child: _buildGardenHeader()),
            
            // Quick Actions
            SliverToBoxAdapter(child: _buildQuickActions()),
            
            // Ready to Open Section
            if (_readyCapsules.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingXL),
                sliver: SliverToBoxAdapter(
                  child: _buildGardenSection(
                    title: 'Ready to Open',
                    emoji: '🎉',
                    capsules: _readyCapsules,
                    startIndex: 0,
                  ),
                ),
              ),
            ],
            
            // Currently Growing Section
            if (_growingCapsules.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingXL),
                sliver: SliverToBoxAdapter(
                  child: _buildGardenSection(
                    title: 'Currently Growing',
                    emoji: '🌿',
                    capsules: _growingCapsules,
                    startIndex: _readyCapsules.length,
                  ),
                ),
              ),
            ],
            
            // Recently Planted Section
            if (_recentlyPlantedCapsules.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingHuge),
                sliver: SliverToBoxAdapter(
                  child: _buildGardenSection(
                    title: 'Recently Planted',
                    emoji: '🌰',
                    capsules: _recentlyPlantedCapsules,
                    startIndex: _readyCapsules.length + _growingCapsules.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
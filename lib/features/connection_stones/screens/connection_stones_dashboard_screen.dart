import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/connection_stone_model.dart';
import '../models/stone_type.dart';
import '../providers/connection_stones_provider.dart';
import '../widgets/stone_header_section.dart';
import '../widgets/quick_touch_bar.dart';
import '../widgets/stone_card.dart';
import '../widgets/floating_comfort_particles.dart';
import '../widgets/stone_visual_widget.dart';

/// Premium Connection Stones Dashboard - The magical heart of emotional connection
class ConnectionStonesDashboardScreen extends ConsumerStatefulWidget {
  const ConnectionStonesDashboardScreen({super.key});

  @override
  ConsumerState<ConnectionStonesDashboardScreen> createState() => 
      _ConnectionStonesDashboardScreenState();
}

class _ConnectionStonesDashboardScreenState 
    extends ConsumerState<ConnectionStonesDashboardScreen>
    with TickerProviderStateMixin {
  
  late ScrollController _scrollController;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final shouldShowFab = _scrollController.offset > 200;
    if (shouldShowFab != _showFab) {
      setState(() {
        _showFab = shouldShowFab;
      });
      
      if (_showFab) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stones = ref.watch(connectionStonesProvider);
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // Magical background particles
          const MagicalComfortBackground(
            enableBasicParticles: true,
            enableHearts: false,
            enableSparkles: true,
            primaryColor: AppColors.sageGreen,
            secondaryColor: AppColors.sageGreenLight,
          ),
          
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header section
              const SliverToBoxAdapter(
                child: StoneHeaderSection(),
              ),
              
              // Quick touch bar
              const SliverToBoxAdapter(
                child: QuickTouchBar(),
              ),
              
              // Collection header and stones grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    children: [
                      // Collection header
                      _buildCollectionHeader(),
                      
                      const SizedBox(height: AppDimensions.spacingM),
                      
                      // Stones grid
                      _buildStonesGrid(stones),
                      
                      const SizedBox(height: AppDimensions.spacingM),
                      
                      // Instructions
                      _buildInstructions(),
                      
                      // Bottom spacing for FAB
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: _showCreateStoneModal,
              backgroundColor: AppColors.sageGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(
                'Create Stone',
                style: AppTextStyles.button,
              ),
            ),
          );
        },
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCollectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Sacred Collection',
                style: AppTextStyles.featureHeading,
              ),
              
              const SizedBox(height: AppDimensions.spacingS),
              
              Text(
                'Touch stones to send comfort, tap to view details',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ],
          ),
        ),
        
        // Create stone button
        SizedBox(
          width: 100,
          child: ElevatedButton.icon(
          onPressed: _showCreateStoneModal,
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Create',
            style: AppTextStyles.button.copyWith(fontSize: 13),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sageGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ),
      ],
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 300))
      .slideX(begin: 0.3, end: 0.0);
  }

  Widget _buildStonesGrid(List<ConnectionStone> stones) {
    // Filter out quick access stones and add create card
    final gridStones = stones.where((stone) => !stone.isQuickAccess).toList();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 0.8,
      ),
      itemCount: gridStones.length + 1, // +1 for create card
      itemBuilder: (context, index) {
        if (index == gridStones.length) {
          return _buildCreateStoneCard();
        }
        
        final stone = gridStones[index];
        return StoneCard(
          stone: stone,
        ).animate(
          delay: Duration(milliseconds: index * 100),
        ).fadeIn(
          duration: const Duration(milliseconds: 600),
        ).slideY(
          begin: 0.3,
          end: 0.0,
          curve: Curves.easeOutBack,
        );
      },
    );
  }

  Widget _buildCreateStoneCard() {
    return GestureDetector(
      onTap: _showCreateStoneModal,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.warmCream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.stoneGray,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated create icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sageGreen.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.add,
                size: 32,
                color: AppColors.sageGreen,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.1, 1.1),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            Text(
              'Create New\nConnection Stone',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.sageGreen,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate(
      delay: const Duration(milliseconds: 800),
    ).fadeIn(
      duration: const Duration(milliseconds: 600),
    ).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.sageGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.sageGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.touch_app,
                color: AppColors.sageGreen,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Text(
                  'Press and hold any stone to send comfort to your friend',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.sageGreen,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.sageGreen,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Text(
                  'Tap a stone to view its details and touch history',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.sageGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 1000))
      .slideY(begin: 0.2, end: 0.0);
  }

  void _showCreateStoneModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CreateStoneModal(),
    );
  }
}

/// Modal for creating new connection stones
class CreateStoneModal extends ConsumerStatefulWidget {
  const CreateStoneModal({super.key});

  @override
  ConsumerState<CreateStoneModal> createState() => _CreateStoneModalState();
}

class _CreateStoneModalState extends ConsumerState<CreateStoneModal>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _previewController;
  StoneType _selectedStoneType = StoneType.roseQuartz;
  String _stoneName = '';
  String _friendName = '';
  String _intention = '';
  bool _addToQuickAccess = true;

  final _stoneNameController = TextEditingController();
  final _friendNameController = TextEditingController();
  final _intentionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _previewController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    // Set default stone name
    _stoneName = _selectedStoneType.displayName;
    _stoneNameController.text = _stoneName;
  }

  @override
  void dispose() {
    _previewController.dispose();
    _stoneNameController.dispose();
    _friendNameController.dispose();
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.modalShadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.stoneGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Title
              Text(
                'Create Connection Stone',
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Stone preview
              _buildStonePreview(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Stone type selector
              _buildStoneTypeSelector(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Form fields
              _buildFormFields(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Create button
              _buildCreateButton(),
            ],
            ),
          ),
        ),
      ),
    ).animate()
      .slideY(
        begin: 1.0,
        end: 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      )
      .fadeIn();
  }

  Widget _buildStonePreview() {
    return StoneCreationVisual(
      size: 100,
      primaryColor: _selectedStoneType.primaryColor,
      secondaryColor: _selectedStoneType.secondaryColor,
      emoji: _selectedStoneType.emoji,
    );
  }

  Widget _buildStoneTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Stone Type',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          children: StoneType.values.map((stoneType) {
            final isSelected = stoneType == _selectedStoneType;
            
            return GestureDetector(
              onTap: () => _selectStoneType(stoneType),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? stoneType.gradient : null,
                  color: isSelected ? null : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : stoneType.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(stoneType.emoji),
                    const SizedBox(width: AppDimensions.spacingS),
                    Text(
                      stoneType.displayName,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected 
                            ? Colors.white 
                            : stoneType.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: AppDimensions.spacingS),
        
        // Stone meaning
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: _selectedStoneType.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                _selectedStoneType.meaning,
                style: AppTextStyles.titleSmall.copyWith(
                  color: _selectedStoneType.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                _selectedStoneType.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Stone name
        TextField(
          controller: _stoneNameController,
          decoration: InputDecoration(
            labelText: 'Stone Name',
            hintText: 'Give your stone a personal name',
            prefixIcon: Text(_selectedStoneType.emoji),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) => setState(() => _stoneName = value),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Friend name
        TextField(
          controller: _friendNameController,
          decoration: InputDecoration(
            labelText: 'Friend Name',
            hintText: 'Who will receive comfort through this stone?',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) => setState(() => _friendName = value),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Intention (optional)
        TextField(
          controller: _intentionController,
          decoration: InputDecoration(
            labelText: 'Intention (Optional)',
            hintText: 'Set a special purpose for this stone',
            prefixIcon: const Icon(Icons.favorite_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 2,
          onChanged: (value) => setState(() => _intention = value),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Quick access toggle
        CheckboxListTile(
          title: Text(
            'Add to Quick Touch Bar',
            style: AppTextStyles.bodyMedium,
          ),
          subtitle: Text(
            'Access this stone quickly from any screen',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          value: _addToQuickAccess,
          onChanged: (value) => setState(() => _addToQuickAccess = value ?? true),
          activeColor: _selectedStoneType.primaryColor,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    final canCreate = _stoneName.isNotEmpty && _friendName.isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canCreate ? _createStone : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedStoneType.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingM + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.stoneGray,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_selectedStoneType.emoji),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              'Create Connection Stone',
              style: AppTextStyles.button,
            ),
          ],
        ),
      ),
    );
  }

  void _selectStoneType(StoneType stoneType) {
    setState(() {
      _selectedStoneType = stoneType;
      _stoneName = stoneType.displayName;
      _stoneNameController.text = _stoneName;
    });
  }

  void _createStone() {
    final newStone = ConnectionStoneFactory.create(
      stoneType: _selectedStoneType,
      name: _stoneName,
      friendName: _friendName,
      friendId: '${_friendName.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      intention: _intention.isNotEmpty ? _intention : null,
      isQuickAccess: _addToQuickAccess,
    );
    
    ref.read(connectionStonesProvider.notifier).addStone(newStone);
    
    Navigator.pop(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedStoneType.emoji} $_stoneName created! Connected to $_friendName',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: _selectedStoneType.primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
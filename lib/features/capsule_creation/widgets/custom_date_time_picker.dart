import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/time_capsule_creation_provider.dart';

/// Custom date and time picker with expandable design
/// Matches the HTML collapsible section perfectly
class CustomDateTimePicker extends ConsumerStatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const CustomDateTimePicker({
    super.key,
    required this.onDateTimeSelected,
  });

  @override
  ConsumerState<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends ConsumerState<CustomDateTimePicker>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _hoverController;
  late AnimationController _toggleController;
  
  late Animation<double> _expandAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _toggleRotation;

  bool _isExpanded = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _previewText = 'Select a date and time to see preview';

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    
    _borderColorAnimation = ColorTween(
      begin: AppColors.whisperGray,
      end: AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _toggleRotation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 180 degrees
    ).animate(CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _expandController.dispose();
    _hoverController.dispose();
    _toggleController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    HapticFeedback.selectionClick();
    
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
      _toggleController.forward();
      _hoverController.forward();
    } else {
      _expandController.reverse();
      _toggleController.reverse();
      _hoverController.reverse();
    }
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.sageGreen,
              onPrimary: AppColors.pearlWhite,
              surface: AppColors.pearlWhite,
              onSurface: AppColors.softCharcoal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _updatePreview();
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.sageGreen,
              onPrimary: AppColors.pearlWhite,
              surface: AppColors.pearlWhite,
              onSurface: AppColors.softCharcoal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      _updatePreview();
    }
  }

  void _updatePreview() {
    if (_selectedDate != null && _selectedTime != null) {
      final selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      final now = DateTime.now();
      final difference = selectedDateTime.difference(now);
      final days = difference.inDays;
      
      String previewText;
      if (days < 0) {
        previewText = 'Selected time is in the past. Please choose a future date.';
      } else if (days == 0) {
        previewText = 'Delivery today!';
      } else if (days == 1) {
        previewText = 'Delivery tomorrow!';
      } else {
        previewText = 'Delivery in $days days';
      }
      
      setState(() {
        _previewText = previewText;
      });
      
      if (days > 0) {
        widget.onDateTimeSelected(selectedDateTime);
      }
    } else {
      setState(() {
        _previewText = 'Select a date and time to see preview';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customDateTime = ref.watch(customDateTimeProvider);
    final isActive = customDateTime != null;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _expandController,
        _hoverController,
        _toggleController,
      ]),
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.cardPaddingLarge),
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.sageGreenWithOpacity(0.03)
                : AppColors.pearlWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: isActive 
                  ? AppColors.sageGreen
                  : _borderColorAnimation.value ?? AppColors.whisperGray,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive 
                    ? AppColors.sageGreenWithOpacity(0.1)
                    : AppColors.cardShadow,
                blurRadius: _isExpanded ? 16 : 8,
                offset: Offset(0, _isExpanded ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  onTap: _toggleExpanded,
                  onHover: (isHovered) {
                    if (isHovered && !_isExpanded) {
                      _hoverController.forward();
                    } else if (!isHovered && !_isExpanded) {
                      _hoverController.reverse();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingXL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title with icon
                        Row(
                          children: [
                            Text(
                              '📅',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: AppDimensions.spacingS),
                            Text(
                              'Custom Date & Time',
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.softCharcoal,
                              ),
                            ),
                          ],
                        ),
                        
                        // Toggle arrow
                        RotationTransition(
                          turns: _toggleRotation,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.sageGreen,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Expandable content
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spacingXL,
                    0,
                    AppDimensions.spacingXL,
                    AppDimensions.spacingXL,
                  ),
                  child: Column(
                    children: [
                      // Date and time inputs
                      Row(
                        children: [
                          // Date input
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.softCharcoalLight,
                                  ),
                                ),
                                
                                const SizedBox(height: AppDimensions.spacingXS),
                                
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    onTap: _selectDate,
                                    child: Container(
                                      padding: const EdgeInsets.all(AppDimensions.spacingM),
                                      decoration: BoxDecoration(
                                        color: AppColors.warmCream,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                        border: Border.all(
                                          color: AppColors.whisperGray,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedDate?.toString().split(' ')[0] ?? 'Select date',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: _selectedDate != null 
                                                  ? AppColors.softCharcoal
                                                  : AppColors.softCharcoalLight,
                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: AppColors.sageGreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: AppDimensions.spacingM),
                          
                          // Time input
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.softCharcoalLight,
                                  ),
                                ),
                                
                                const SizedBox(height: AppDimensions.spacingXS),
                                
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    onTap: _selectTime,
                                    child: Container(
                                      padding: const EdgeInsets.all(AppDimensions.spacingM),
                                      decoration: BoxDecoration(
                                        color: AppColors.warmCream,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                        border: Border.all(
                                          color: AppColors.whisperGray,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedTime?.format(context) ?? 'Select time',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: _selectedTime != null 
                                                  ? AppColors.softCharcoal
                                                  : AppColors.softCharcoalLight,
                                            ),
                                          ),
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: AppColors.sageGreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppDimensions.spacingM),
                      
                      // Preview text
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spacingS),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreenWithOpacity(0.05),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Text(
                          _previewText,
                          style: AppTextStyles.timeCapsulePreview.copyWith(
                            color: AppColors.sageGreen,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
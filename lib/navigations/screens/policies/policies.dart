import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> with SingleTickerProviderStateMixin {
  final List<PolicyCategory> _categories = [
    PolicyCategory(
      title: "Academic Policies",
      policies: [
        PolicyItem(
          title: "Attendance Requirement",
          content:
              "Students must attend at least 80% of lectures and practicals to qualify for the semester exams.",
        ),
        PolicyItem(
          title: "Examination & Grading",
          content:
              "Exams follow semester-wise grading. Passing requires minimum 40% marks in each subject.",
        ),
        PolicyItem(
          title: "Promotion Criteria",
          content:
              "Students must clear all previous semester backlogs to be eligible for a full scholarship. At least six students can receive this scholarship each year, with at least one recipient being a female student",
        ),
      ],
    ),
    PolicyCategory(
      title: "Code of Conduct",
      policies: [
        PolicyItem(
          title: "Behavior & Discipline",
          content:
              "Students are expected to maintain respectful behavior towards faculty and peers.",
        ),
        PolicyItem(
          title: "Anti-Plagiarism",
          content:
              "All submitted assignments must be original. Plagiarism results in disciplinary action.",
        ),
        PolicyItem(
          title: "Dress Code",
          content:
              "Formal or semi-formal attire is encouraged during college hours and events.",
        ),
      ],
    ),
    PolicyCategory(
      title: "Fee & Refund Policy",
      policies: [
        PolicyItem(
          title: "Fee Payment",
          content:
              "Fees must be paid before the start of each semester to avoid penalties.",
        ),
        PolicyItem(
          title: "Refund Rules",
          content:
              "Refunds will be processed only if withdrawal is made before the semester begins.",
        ),
      ],
    ),
    PolicyCategory(
      title: "Library & Resource Usage",
      policies: [
        PolicyItem(
          title: "Library Access",
          content:
              "Students can borrow up to 5 books at a time for 15 days. Late returns incur fines.",
        ),
        PolicyItem(
          title: "IT Resource Usage",
          content:
              "Computer labs are for academic use only. Unauthorized access or data alteration is prohibited.",
        ),
      ],
    ),
    PolicyCategory(
      title: "Anti-Ragging & Safety",
      policies: [
        PolicyItem(
          title: "Anti-Ragging",
          content:
              "Any form of ragging is strictly prohibited and punishable by law.",
        ),
        PolicyItem(
          title: "Health & Safety",
          content:
              "Students must follow all safety rules, wear masks during health emergencies, and inform the required department.",
        ),
      ],
    ),
    PolicyCategory(
      title: "Leave & Absence",
      policies: [
        PolicyItem(
          title: "Leave Application",
          content:
              "All leaves must be applied through the college Admin portal and approved by the concerned authority.",
        ),
        PolicyItem(
          title: "Maximum Absence",
          content:
              "Absence beyond 25% in a semester may lead to de-registration from exams.",
        ),
      ],
    ),
  ];

  String? _currentlyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: const Text("Policies"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, catIndex) {
          final category = _categories[catIndex];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(category.policies.length, (policyIndex) {
                    final policy = category.policies[policyIndex];
                    final uniqueId = '$catIndex-$policyIndex';
                    final isExpanded = _currentlyExpanded == uniqueId;

                    return _PolicyExpansionTile(
                      uniqueId: uniqueId,
                      title: policy.title,
                      content: policy.content,
                      isExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          if (expanded) {
                            _currentlyExpanded = uniqueId;
                          } else if (_currentlyExpanded == uniqueId) {
                            _currentlyExpanded = null;
                          }
                        });
                      },
                      theme: theme,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PolicyExpansionTile extends StatefulWidget {
  final String uniqueId;
  final String title;
  final String content;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final ThemeData theme;

  const _PolicyExpansionTile({
    Key? key,
    required this.uniqueId,
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.theme,
  }) : super(key: key);

  @override
  State<_PolicyExpansionTile> createState() => _PolicyExpansionTileState();
}

class _PolicyExpansionTileState extends State<_PolicyExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5));

    if (widget.isExpanded) {
      _controller.value = 0.5;
    }
  }

  @override
  void didUpdateWidget(covariant _PolicyExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onExpansionChanged(!widget.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      widget.content,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  crossFadeState:
                      widget.isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PolicyCategory {
  final String title;
  final List<PolicyItem> policies;

  PolicyCategory({required this.title, required this.policies});
}

class PolicyItem {
  final String title;
  final String content;

  PolicyItem({required this.title, required this.content});
}

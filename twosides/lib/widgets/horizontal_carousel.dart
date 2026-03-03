import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:twosides/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CarouselItem {
  final int index;
  final String iframe;
  //final String title;
  //final String subtitle;
  //final Color color;

  const CarouselItem({
    required this.index,
    required this.iframe,
    //required this.title,
    //required this.subtitle,
    //required this.color,
  });
}

// ─── Main Carousel Widget ──────────────────────────────────────────────────────

class HorizontalCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;

  const HorizontalCarousel({
    super.key,
    required this.items,
    this.itemWidth = 280,
    this.itemHeight = 280,
    this.itemSpacing = 16,
  });

  @override
  State<HorizontalCarousel> createState() => _HorizontalCarouselState();
}

class _HorizontalCarouselState extends State<HorizontalCarousel> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  double get _scrollStep => widget.itemWidth + widget.itemSpacing;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateArrowVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowVisibility() {
    final pos = _scrollController.position;
    setState(() {
      _canScrollLeft = pos.pixels > 0;
      _canScrollRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - _scrollStep).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + _scrollStep).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemHeight + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Scrollable list ──────────────────────────────────────
          ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            //padding: const EdgeInsets.symmetric(horizontal: 56),
            itemCount: widget.items.length,
            separatorBuilder: (_, __) =>
                SizedBox(width: widget.itemSpacing),
            itemBuilder: (context, index) =>
                _CarouselCard(item: widget.items[index], width: widget.itemWidth),
          ),

          // ── Left arrow ───────────────────────────────────────────
          Positioned(
            left: 8,
            bottom: 0,
            child: _NavArrow(
              icon: Icons.chevron_left_rounded,
              visible: _canScrollLeft,
              onTap: _scrollLeft,
            ),
          ),

          // ── Right arrow ──────────────────────────────────────────
          Positioned(
            right: 8,
            bottom: 0,
            child: _NavArrow(
              icon: Icons.chevron_right_rounded,
              visible: _canScrollRight,
              onTap: _scrollRight,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gradient Overlay ──────────────────────────────────────────────────────────

enum GradientDirection { left, right }

class _GradientFade extends StatelessWidget {
  final GradientDirection direction;

  const _GradientFade({required this.direction});

  @override
  Widget build(BuildContext context) {
    final isLeft = direction == GradientDirection.left;
    const bg = TwoSidesColors.backgroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            bg,
            bg.withOpacity(0.85),
            bg.withOpacity(0.0),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─── Navigation Arrow Button ───────────────────────────────────────────────────

class _NavArrow extends StatefulWidget {
  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  @override
  State<_NavArrow> createState() => _NavArrowState();
}

class _NavArrowState extends State<_NavArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !widget.visible,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? TwoSidesColors.secondaryColor.withOpacity(0.70)
                    : TwoSidesColors.secondaryColor.withOpacity(0.90),
                border: Border.all(
                  color: TwoSidesColors.textColor.withOpacity(_hovered ? 0.35 : 0.18),
                  width: 1,
                ),
              ),
              child: Icon(
                widget.icon,
                color: TwoSidesColors.textColor.withOpacity(_hovered ? 1.0 : 0.75),
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Carousel Card ─────────────────────────────────────────────────────────────

class _CarouselCard extends StatefulWidget {
  final CarouselItem item;
  final double width;

  const _CarouselCard({required this.item, required this.width});

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: HtmlWidget(
        '''${widget.item.iframe}''',
      ),
    );
  }
}
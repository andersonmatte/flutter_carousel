import 'dart:async';

import 'package:flutter/material.dart';

import 'responsive_option.dart';

/// A customizable carousel widget for displaying scrollable items.
/// Um widget de carrossel personalizável para exibir itens roláveis.
class FlutterCarousel<T> extends StatefulWidget {
  // List of items to display / Lista de itens a exibir
  final List<T> items;

  // Function to build each item / Função para construir cada item
  final Widget Function(BuildContext, T) itemBuilder;

  // Number of visible items per page / Número de itens visíveis por página
  final int numVisible;

  // Number of items to scroll per action / Número de itens por rolagem
  final int numScroll;

  // Enable infinite scrolling / Ativa rolagem infinita
  final bool circular;

  // Interval between auto scrolls / Intervalo para rolagem automática
  final Duration? autoplayInterval;

  // Responsiveness configuration / Configurações responsivas
  final List<ResponsiveOption>? responsiveOptions;

  // Horizontal or vertical scrolling / Rolagem horizontal ou vertical
  final Axis scrollDirection;

  // Show page indicator dots / Mostrar indicadores de página
  final bool showPaginator;

  const FlutterCarousel({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.numVisible = 3,
    this.numScroll = 3,
    this.circular = false,
    this.autoplayInterval,
    this.responsiveOptions,
    this.scrollDirection = Axis.horizontal,
    this.showPaginator = true,
  }) : super(key: key);

  @override
  _FlutterCarouselState<T> createState() => _FlutterCarouselState<T>();
}

class _FlutterCarouselState<T> extends State<FlutterCarousel<T>> {
  // Controls the page view / Controla o PageView
  late final PageController _pageController;
  // Index of the current page / Índice da página atual
  late int _currentPage;
  // Number of items per current page / Itens por página atual
  late int _itemsPerPage;
  // Timer for autoplay / Timer para autoplay
  Timer? _autoplayTimer;

  /// Calculates total number of pages
  /// Calcula o número total de páginas
  int get _pageCount => (widget.items.length / _itemsPerPage).ceil();

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(viewportFraction: 1);

    // Starts autoplay if interval is defined / Inicia autoplay se houver intervalo definido
    if (widget.autoplayInterval != null) {
      _autoplayTimer = Timer.periodic(widget.autoplayInterval!, (_) {
        _nextPage();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculates items per page based on screen width
    // Calcula os itens por página com base na largura da tela
    _itemsPerPage = _calculateItemsPerPage();
  }

  /// Determines how many items should be shown per page based on responsive options
  /// Determina quantos itens mostrar por página com base nas opções responsivas
  int _calculateItemsPerPage() {
    if (widget.responsiveOptions != null &&
        widget.responsiveOptions!.isNotEmpty) {
      double width = MediaQuery.of(context).size.width;
      for (var option in widget.responsiveOptions!) {
        if (width <= option.maxWidth) {
          return option.numVisible;
        }
      }
    }
    return widget.numVisible;
  }

  /// Goes to the next page, handling circular behavior and autoplay stop
  /// Vai para a próxima página, tratando comportamento circular e parando autoplay
  void _nextPage() {
    if (!mounted) return;
    int nextPage = _currentPage + 1;
    if (nextPage >= _pageCount) {
      if (widget.circular) {
        nextPage = 0;
      } else {
        nextPage = _pageCount - 1;
        _autoplayTimer?.cancel();
      }
    }
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Goes to the previous page, respecting circular behavior
  /// Vai para a página anterior, respeitando comportamento circular
  void _previousPage() {
    int prevPage = _currentPage - 1;
    if (prevPage < 0) {
      if (widget.circular) {
        prevPage = _pageCount - 1;
      } else {
        prevPage = 0;
      }
    }
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _autoplayTimer
        ?.cancel(); // Cancels autoplay when widget is disposed / Cancela autoplay ao destruir o widget
    _pageController.dispose(); // Dispose controller / Descarta o controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Recalculate items per page when rebuilding
    // Recalcula itens visíveis ao reconstruir
    _itemsPerPage = _calculateItemsPerPage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: PageView.builder(
            scrollDirection: widget.scrollDirection,
            controller: _pageController,
            itemCount: _pageCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              int startIndex = pageIndex * _itemsPerPage;
              int endIndex =
                  (startIndex + _itemsPerPage) > widget.items.length
                      ? widget.items.length
                      : startIndex + _itemsPerPage;
              List<T> visibleItems = widget.items.sublist(startIndex, endIndex);

              // Builds a row or column based on scroll direction
              // Constrói uma linha ou coluna com base na direção da rolagem
              return Flex(
                direction:
                    widget.scrollDirection == Axis.horizontal
                        ? Axis.horizontal
                        : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    visibleItems
                        .map(
                          (item) => Expanded(
                            child: widget.itemBuilder(context, item),
                          ),
                        )
                        .toList(),
              );
            },
          ),
        ),
        if (widget.showPaginator)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child:
                _buildPaginator(), // Builds pagination dots / Constrói os indicadores de página
          ),
        _buildNavigationButtons(),
        // Builds next/previous buttons / Constrói botões anterior/próximo
      ],
    );
  }

  /// Builds the pagination indicator dots
  /// Constrói os indicadores de página (bolinhas)
  Widget _buildPaginator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pageCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue : Colors.grey[400],
          ),
        );
      }),
    );
  }

  /// Builds previous and next navigation buttons
  /// Constrói os botões de navegação anterior e próximo
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousPage,
        ),
        IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _nextPage),
      ],
    );
  }
}

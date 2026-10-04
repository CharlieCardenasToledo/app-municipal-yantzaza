import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../common_widgets/yantzaza_remote_image.dart';

final class BusinessDetailScreen extends StatelessWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final data = _businesses[businessId] ?? _businesses['panaderia']!;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            tooltip: 'Ver carrito',
            onPressed: () => context.push('/cart'),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          YantzazaRemoteImage(
            url: data.imageUrl,
            height: 220,
            width: double.infinity,
            borderRadius: AppBorderRadius.radiusXxl,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Text(data.name, style: AppTypography.headlineMd)),
              const Icon(Icons.star_rounded, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(data.rating, style: AppTypography.titleSm.copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text('${data.category} · ${data.address}', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          Text(data.description, style: AppTypography.bodyLg),
          const SizedBox(height: 24),
          Text('Catálogo destacado', style: AppTypography.headlineSm),
          const SizedBox(height: 12),
          ...data.products.map((product) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryFixed,
                    child: Icon(product.icon, color: AppColors.primary),
                  ),
                  title: Text(product.name, style: AppTypography.titleMd),
                  subtitle: Text(product.detail),
                  trailing: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} añadido al carrito')),
                      );
                    },
                    child: Text(product.price),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Continuar al carrito'),
          ),
        ],
      ),
    );
  }
}

class _BusinessData {
  final String name;
  final String category;
  final String rating;
  final String address;
  final String description;
  final String imageUrl;
  final IconData icon;
  final List<_Product> products;

  const _BusinessData({
    required this.name,
    required this.category,
    required this.rating,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.products,
  });
}

class _Product {
  final String name;
  final String detail;
  final String price;
  final IconData icon;

  const _Product(this.name, this.detail, this.price, this.icon);
}

const _businesses = <String, _BusinessData>{
  'panaderia': _BusinessData(
    name: 'Mercado Municipal',
    category: 'Productos locales',
    rating: '4.8',
    address: 'Av. Iván Riofrío y 12 de Febrero · tel. 07 3035 289',
    description: 'Edificio municipal de dos pisos en el barrio Sur con comidas preparadas, productos frescos, ropa y menaje.',
    imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&w=1200&q=85',
    icon: Icons.storefront_rounded,
    products: [
      _Product('Ayampaco de tilapia', 'Envuelto en hoja de bijao y asado', '\$3.50', Icons.set_meal_rounded),
      _Product('Canasta de plátano y yuca', 'Productores del cantón', '\$5.00', Icons.shopping_basket_rounded),
    ],
  ),
  'ferreteria': _BusinessData(
    name: 'Ferias CIALCO',
    category: 'Agricultura',
    rating: '4.5',
    address: 'Circuitos alternativos de comercialización',
    description: 'Nueve puntos de venta directa de productores: plátano, papaya, piña, quesillo, panela granulada, yuca, pollos criollos y pulpas de frutas amazónicas.',
    imageUrl: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=1200&q=85',
    icon: Icons.eco_rounded,
    products: [
      _Product('Pitahaya amazónica', 'Canasta de temporada', '\$6.00', Icons.eco_rounded),
      _Product('Quesillo y panela granulada', 'Producción campesina', '\$4.50', Icons.shopping_basket_rounded),
    ],
  ),
  'farmacia': _BusinessData(
    name: 'Café, cacao y chocolate',
    category: 'Emprendimientos',
    rating: '4.9',
    address: 'Yantzaza · productores y artesanos',
    description: 'Café, cacao y chocolates artesanales del valle, junto con artesanías en balsa y tagua elaboradas por familias yantzacenses.',
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=85',
    icon: Icons.palette_rounded,
    products: [
      _Product('Chocolate artesanal', 'Cacao fino de aroma del cantón', '\$5.00', Icons.restaurant_rounded),
      _Product('Artesanía en balsa y tagua', 'Pieza elaborada a mano', '\$12.00', Icons.palette_rounded),
    ],
  ),
};

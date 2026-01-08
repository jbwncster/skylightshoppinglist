#!/usr/bin/env python3
"""
OpenFoodFacts API Integration for Linux
========================================

Official API: https://openfoodfacts.github.io/openfoodfacts-server/api/
GitHub: https://github.com/openfoodfacts
Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
Android App: https://github.com/openfoodfacts/openfoodfacts-androidapp
Python SDK: https://github.com/openfoodfacts/openfoodfacts-python

License: Open Database License (ODbL)
Attribution Required: Must show attribution in app per ODbL terms

Usage:
    api = OpenFoodFactsAPI()
    product = await api.get_product("3017620422003")
"""

import aiohttp
import asyncio
from typing import Optional, List, Dict, Any
from dataclasses import dataclass, field
from enum import Enum
import logging

logger = logging.getLogger(__name__)

# User-Agent following OpenFoodFacts guidelines
# Format: AppName/Version (Platform; URL)
USER_AGENT = "SkylightShoppingList/1.0 (Linux; https://github.com/YOUR_USERNAME/skylight-shopping-list)"

BASE_URL = "https://world.openfoodfacts.org"


class ItemCategory(Enum):
    """Product categories"""
    PRODUCE = "produce"
    DAIRY = "dairy"
    MEAT = "meat"
    PANTRY = "pantry"
    FROZEN = "frozen"
    BEVERAGES = "beverages"
    BAKERY = "bakery"
    SNACKS = "snacks"
    OTHER = "other"


@dataclass
class OFFNutriments:
    """
    Nutritional values per 100g
    Based on OpenFoodFacts API schema
    """
    energy_kcal_100g: Optional[float] = None
    energy_100g: Optional[float] = None
    fat_100g: Optional[float] = None
    saturated_fat_100g: Optional[float] = None
    carbohydrates_100g: Optional[float] = None
    sugars_100g: Optional[float] = None
    fiber_100g: Optional[float] = None
    proteins_100g: Optional[float] = None
    salt_100g: Optional[float] = None
    sodium_100g: Optional[float] = None
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'OFFNutriments':
        """Create from API response"""
        return cls(
            energy_kcal_100g=data.get('energy-kcal_100g'),
            energy_100g=data.get('energy_100g'),
            fat_100g=data.get('fat_100g'),
            saturated_fat_100g=data.get('saturated-fat_100g'),
            carbohydrates_100g=data.get('carbohydrates_100g'),
            sugars_100g=data.get('sugars_100g'),
            fiber_100g=data.get('fiber_100g'),
            proteins_100g=data.get('proteins_100g'),
            salt_100g=data.get('salt_100g'),
            sodium_100g=data.get('sodium_100g')
        )
    
    def to_nutrition_info(self, brand: Optional[str] = None) -> Dict[str, Optional[str]]:
        """Convert to local nutrition info format"""
        return {
            'calories': f"{self.energy_kcal_100g:.0f} kcal" if self.energy_kcal_100g else None,
            'protein': f"{self.proteins_100g:.1f} g" if self.proteins_100g else None,
            'carbs': f"{self.carbohydrates_100g:.1f} g" if self.carbohydrates_100g else None,
            'fat': f"{self.fat_100g:.1f} g" if self.fat_100g else None,
            'brand': brand,
            'ingredients': None
        }


@dataclass
class OFFProduct:
    """
    OpenFoodFacts Product
    Comprehensive model matching official API
    Reference: https://github.com/openfoodfacts/openfoodfacts-swift
    """
    code: str
    product_name: Optional[str] = None
    brands: Optional[str] = None
    categories: Optional[str] = None
    image_url: Optional[str] = None
    image_front_url: Optional[str] = None
    image_ingredients_url: Optional[str] = None
    image_nutrition_url: Optional[str] = None
    quantity: Optional[str] = None
    serving_size: Optional[str] = None
    ingredients_text: Optional[str] = None
    allergens: Optional[str] = None
    traces: Optional[str] = None
    labels: Optional[str] = None
    stores: Optional[str] = None
    countries: Optional[str] = None
    manufacturing_places: Optional[str] = None
    nutriments: Optional[OFFNutriments] = None
    nutriscore_grade: Optional[str] = None
    nova_group: Optional[int] = None
    ecoscore_grade: Optional[str] = None
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'OFFProduct':
        """Create from API response"""
        nutriments_data = data.get('nutriments')
        nutriments = OFFNutriments.from_dict(nutriments_data) if nutriments_data else None
        
        return cls(
            code=data.get('code', ''),
            product_name=data.get('product_name'),
            brands=data.get('brands'),
            categories=data.get('categories'),
            image_url=data.get('image_url'),
            image_front_url=data.get('image_front_url'),
            image_ingredients_url=data.get('image_ingredients_url'),
            image_nutrition_url=data.get('image_nutrition_url'),
            quantity=data.get('quantity'),
            serving_size=data.get('serving_size'),
            ingredients_text=data.get('ingredients_text'),
            allergens=data.get('allergens'),
            traces=data.get('traces'),
            labels=data.get('labels'),
            stores=data.get('stores'),
            countries=data.get('countries'),
            manufacturing_places=data.get('manufacturing_places'),
            nutriments=nutriments,
            nutriscore_grade=data.get('nutriscore_grade'),
            nova_group=data.get('nova_group'),
            ecoscore_grade=data.get('ecoscore_grade')
        )
    
    def categorize(self) -> ItemCategory:
        """Categorize product based on categories string"""
        if not self.categories:
            return ItemCategory.OTHER
        
        cats = self.categories.lower()
        
        if 'fruit' in cats or 'vegetable' in cats:
            return ItemCategory.PRODUCE
        elif 'dairy' in cats or 'milk' in cats or 'cheese' in cats or 'yogurt' in cats:
            return ItemCategory.DAIRY
        elif 'meat' in cats or 'fish' in cats or 'poultry' in cats:
            return ItemCategory.MEAT
        elif 'beverage' in cats or 'drink' in cats:
            return ItemCategory.BEVERAGES
        elif 'bakery' in cats or 'bread' in cats:
            return ItemCategory.BAKERY
        elif 'snack' in cats:
            return ItemCategory.SNACKS
        elif 'frozen' in cats:
            return ItemCategory.FROZEN
        elif 'canned' in cats or 'preserved' in cats:
            return ItemCategory.PANTRY
        
        return ItemCategory.PANTRY
    
    def to_pantry_item(self) -> Dict[str, Any]:
        """Convert to local pantry item format"""
        return {
            'id': self.code,
            'name': self.product_name or "Unknown Product",
            'quantity': self.quantity or "1",
            'category': self.categorize().value,
            'barcode': self.code,
            'image_url': self.image_front_url or self.image_url,
            'nutrition_info': self.nutriments.to_nutrition_info(self.brands) if self.nutriments else None
        }


class OpenFoodFactsAPI:
    """
    OpenFoodFacts API Client
    
    Provides access to the world's largest open food database.
    
    Features:
    - Product lookup by barcode
    - Product search by name
    - Image download
    - Full nutrition data
    
    GitHub Projects:
    - Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
    - Android App: https://github.com/openfoodfacts/openfoodfacts-androidapp
    - Python SDK: https://github.com/openfoodfacts/openfoodfacts-python
    - Server: https://github.com/openfoodfacts/openfoodfacts-server
    """
    
    def __init__(self, base_url: str = BASE_URL):
        self.base_url = base_url
        self.session: Optional[aiohttp.ClientSession] = None
    
    async def _get_session(self) -> aiohttp.ClientSession:
        """Get or create aiohttp session"""
        if self.session is None or self.session.closed:
            headers = {
                'User-Agent': USER_AGENT,
                'Accept': 'application/json'
            }
            self.session = aiohttp.ClientSession(headers=headers)
        return self.session
    
    async def close(self):
        """Close the session"""
        if self.session and not self.session.closed:
            await self.session.close()
    
    async def get_product(self, barcode: str) -> Optional[OFFProduct]:
        """
        Fetch product by barcode
        
        Args:
            barcode: Product barcode (EAN, UPC, etc.)
        
        Returns:
            OFFProduct if found, None otherwise
        
        Raises:
            aiohttp.ClientError: Network error
        """
        url = f"{self.base_url}/api/v2/product/{barcode}"
        
        try:
            session = await self._get_session()
            async with session.get(url) as response:
                if response.status == 200:
                    data = await response.json()
                    
                    if data.get('status') == 1 and data.get('product'):
                        return OFFProduct.from_dict(data['product'])
                    else:
                        logger.warning(f"Product {barcode} not found")
                        return None
                else:
                    logger.error(f"HTTP {response.status} for barcode {barcode}")
                    return None
        
        except aiohttp.ClientError as e:
            logger.error(f"Network error fetching product {barcode}: {e}")
            raise
    
    async def search_products(
        self, 
        query: str, 
        page: int = 1, 
        page_size: int = 20
    ) -> List[OFFProduct]:
        """
        Search products by name
        
        Args:
            query: Search query
            page: Page number (1-indexed)
            page_size: Number of results per page
        
        Returns:
            List of products
        """
        url = f"{self.base_url}/cgi/search.pl"
        params = {
            'search_terms': query,
            'page': page,
            'page_size': page_size,
            'json': 1
        }
        
        try:
            session = await self._get_session()
            async with session.get(url, params=params) as response:
                if response.status == 200:
                    data = await response.json()
                    products = data.get('products', [])
                    return [OFFProduct.from_dict(p) for p in products]
                else:
                    logger.error(f"HTTP {response.status} for search '{query}'")
                    return []
        
        except aiohttp.ClientError as e:
            logger.error(f"Network error searching '{query}': {e}")
            return []
    
    async def download_image(self, image_url: str) -> Optional[bytes]:
        """
        Download product image
        
        Args:
            image_url: URL of the image
        
        Returns:
            Image bytes if successful, None otherwise
        """
        try:
            session = await self._get_session()
            async with session.get(image_url) as response:
                if response.status == 200:
                    return await response.read()
                else:
                    logger.error(f"HTTP {response.status} downloading image")
                    return None
        
        except aiohttp.ClientError as e:
            logger.error(f"Error downloading image: {e}")
            return None


# Attribution information
OPENFOODFACTS_ATTRIBUTION = {
    'name': 'Open Food Facts',
    'description': 'Free, open, collaborative database of food products from around the world',
    'website': 'https://world.openfoodfacts.org',
    'github_org': 'https://github.com/openfoodfacts',
    'github_swift': 'https://github.com/openfoodfacts/openfoodfacts-swift',
    'github_android': 'https://github.com/openfoodfacts/openfoodfacts-androidapp',
    'github_python': 'https://github.com/openfoodfacts/openfoodfacts-python',
    'github_server': 'https://github.com/openfoodfacts/openfoodfacts-server',
    'license': 'Open Database License (ODbL)',
    'stats': {
        'products': '3,000,000+',
        'countries': '180+',
        'contributors': '50,000+'
    }
}


def get_attribution_text() -> str:
    """Get formatted attribution text for display"""
    return f"""Powered by {OPENFOODFACTS_ATTRIBUTION['name']}

{OPENFOODFACTS_ATTRIBUTION['description']}

• {OPENFOODFACTS_ATTRIBUTION['stats']['products']} products
• {OPENFOODFACTS_ATTRIBUTION['stats']['countries']} countries
• {OPENFOODFACTS_ATTRIBUTION['stats']['contributors']} contributors

License: {OPENFOODFACTS_ATTRIBUTION['license']}

Learn more: {OPENFOODFACTS_ATTRIBUTION['website']}
Contribute: {OPENFOODFACTS_ATTRIBUTION['github_org']}
"""


# Example usage
async def example_usage():
    """Example of using the API"""
    api = OpenFoodFactsAPI()
    
    try:
        # Fetch product by barcode
        product = await api.get_product("3017620422003")  # Nutella
        if product:
            print(f"Found: {product.product_name}")
            print(f"Brand: {product.brands}")
            print(f"Category: {product.categorize()}")
            if product.nutriments:
                print(f"Calories: {product.nutriments.energy_kcal_100g} kcal/100g")
        
        # Search products
        results = await api.search_products("chocolate")
        print(f"Found {len(results)} chocolate products")
        
        # Show attribution
        print("\n" + get_attribution_text())
    
    finally:
        await api.close()


if __name__ == "__main__":
    asyncio.run(example_usage())

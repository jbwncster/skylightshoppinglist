package com.skylight.shoppinglist.ui.components

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Info
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

/**
 * OpenFoodFacts Attribution Component
 * 
 * Required per OpenFoodFacts guidelines to show attribution
 * when using their API and data.
 * 
 * GitHub: https://github.com/openfoodfacts
 * License: Open Database License (ODbL)
 */

@Composable
fun OpenFoodFactsAttribution(
    modifier: Modifier = Modifier,
    showGitHubLink: Boolean = true
) {
    val uriHandler = LocalUriHandler.current
    
    Card(
        modifier = modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = Color(0xFF85C88A).copy(alpha = 0.1f)
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Powered by text
            Text(
                text = "Powered by",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            
            // Logo and name (clickable)
            TextButton(
                onClick = { 
                    uriHandler.openUri("https://world.openfoodfacts.org") 
                }
            ) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_shopping_cart),
                    contentDescription = null,
                    tint = Color(0xFF85C88A),
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Open Food Facts",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF85C88A)
                )
            }
            
            // Description
            Text(
                text = "Free, open database of food products from around the world",
                style = MaterialTheme.typography.bodySmall,
                textAlign = TextAlign.Center,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            
            // Stats
            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                modifier = Modifier.padding(top = 4.dp)
            ) {
                StatsChip(
                    label = "3M+",
                    description = "Products"
                )
                StatsChip(
                    label = "180+",
                    description = "Countries"
                )
                StatsChip(
                    label = "Free",
                    description = "Forever"
                )
            }
            
            // Links
            if (showGitHubLink) {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.padding(top = 8.dp)
                ) {
                    TextButton(
                        onClick = { 
                            uriHandler.openUri("https://github.com/openfoodfacts") 
                        }
                    ) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_github),
                            contentDescription = "GitHub",
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("GitHub")
                    }
                    
                    TextButton(
                        onClick = { 
                            uriHandler.openUri("https://github.com/openfoodfacts/openfoodfacts-swift") 
                        }
                    ) {
                        Text("Swift SDK")
                    }
                    
                    TextButton(
                        onClick = { 
                            uriHandler.openUri("https://github.com/openfoodfacts/openfoodfacts-androidapp") 
                        }
                    ) {
                        Text("Android App")
                    }
                }
            }
            
            // Contribute button
            OutlinedButton(
                onClick = { 
                    uriHandler.openUri("https://world.openfoodfacts.org/contribute") 
                },
                modifier = Modifier.padding(top = 4.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Info,
                    contentDescription = null,
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text("Contribute Data")
            }
            
            // License info
            Text(
                text = "Data available under the Open Database License (ODbL)",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f),
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(top = 4.dp)
            )
        }
    }
}

@Composable
private fun StatsChip(label: String, description: String) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF85C88A)
        )
        Text(
            text = description,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

/**
 * Compact attribution for product detail screens
 */
@Composable
fun OpenFoodFactsCompactAttribution(
    modifier: Modifier = Modifier
) {
    val uriHandler = LocalUriHandler.current
    
    TextButton(
        onClick = { 
            uriHandler.openUri("https://world.openfoodfacts.org") 
        },
        modifier = modifier
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_shopping_cart),
            contentDescription = null,
            tint = Color(0xFF85C88A),
            modifier = Modifier.size(16.dp)
        )
        Spacer(modifier = Modifier.width(4.dp))
        Text(
            text = "Data from Open Food Facts",
            style = MaterialTheme.typography.labelSmall
        )
    }
}

/**
 * Bottom sheet with full OpenFoodFacts info
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OpenFoodFactsInfoSheet(
    onDismiss: () -> Unit
) {
    val uriHandler = LocalUriHandler.current
    
    ModalBottomSheet(
        onDismissRequest = onDismiss
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Text(
                text = "About Open Food Facts",
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold
            )
            
            // Description
            Text(
                text = "Open Food Facts is a free, open, collaborative database of food products from around the world. " +
                       "It's like Wikipedia for food - a community-driven project that anyone can contribute to.",
                style = MaterialTheme.typography.bodyMedium
            )
            
            // How it works
            Card {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "How It Works",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )
                    
                    InfoRow(
                        icon = "📱",
                        title = "Scan Barcodes",
                        description = "Use our app to scan products"
                    )
                    
                    InfoRow(
                        icon = "📝",
                        title = "Add Information",
                        description = "Contribute nutrition facts and ingredients"
                    )
                    
                    InfoRow(
                        icon = "🌍",
                        title = "Help Everyone",
                        description = "Your contributions help people worldwide"
                    )
                }
            }
            
            // GitHub repositories
            Text(
                text = "Open Source Projects",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )
            
            GitHubRepoCard(
                name = "openfoodfacts-swift",
                description = "iOS SDK for OpenFoodFacts API",
                url = "https://github.com/openfoodfacts/openfoodfacts-swift",
                uriHandler = uriHandler
            )
            
            GitHubRepoCard(
                name = "openfoodfacts-androidapp",
                description = "Official Android app",
                url = "https://github.com/openfoodfacts/openfoodfacts-androidapp",
                uriHandler = uriHandler
            )
            
            GitHubRepoCard(
                name = "openfoodfacts-server",
                description = "Backend server and API",
                url = "https://github.com/openfoodfacts/openfoodfacts-server",
                uriHandler = uriHandler
            )
            
            // Action buttons
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedButton(
                    onClick = { 
                        uriHandler.openUri("https://world.openfoodfacts.org/contribute") 
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Contribute")
                }
                
                Button(
                    onClick = { 
                        uriHandler.openUri("https://github.com/openfoodfacts") 
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("View on GitHub")
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
private fun InfoRow(
    icon: String,
    title: String,
    description: String
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            text = icon,
            style = MaterialTheme.typography.headlineMedium
        )
        Column {
            Text(
                text = title,
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = description,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun GitHubRepoCard(
    name: String,
    description: String,
    url: String,
    uriHandler: androidx.compose.ui.platform.UriHandler
) {
    OutlinedCard(
        onClick = { uriHandler.openUri(url) },
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_github),
                contentDescription = "GitHub",
                modifier = Modifier.size(32.dp)
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = name,
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = description,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Icon(
                painter = painterResource(id = R.drawable.ic_arrow_forward),
                contentDescription = "Open",
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

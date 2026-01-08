using Microsoft.Maui;
using Microsoft.Maui.Hosting;
using Microsoft.Maui.Controls;

namespace SkylightShoppingList;

/// <summary>
/// Skylight Shopping List - Windows Store App (.NET MAUI)
/// 
/// Features:
/// - Camera scanning with Windows.Media.Capture
/// - Barcode scanning with ZXing.Net.Maui
/// - Skylight API integration
/// - OpenFoodFacts API integration
/// - Fluent Design System
/// </summary>
public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
                fonts.AddFont("SegoeUI.ttf", "SegoeUI");
            })
            .UseMauiCommunityToolkit()
            .UseBarcodeReader();

        // Register services
        builder.Services.AddSingleton<ISkylightApiService, SkylightApiService>();
        builder.Services.AddSingleton<IOpenFoodFactsService, OpenFoodFactsService>();
        builder.Services.AddSingleton<IPantryRepository, PantryRepository>();
        builder.Services.AddSingleton<ICameraService, CameraService>();
        builder.Services.AddSingleton<IBarcodeService, BarcodeService>();
        
        // Register ViewModels
        builder.Services.AddTransient<LoginViewModel>();
        builder.Services.AddTransient<ShoppingListViewModel>();
        builder.Services.AddTransient<CameraScanViewModel>();
        builder.Services.AddTransient<PantryViewModel>();
        builder.Services.AddTransient<SettingsViewModel>();
        
        // Register Pages
        builder.Services.AddTransient<LoginPage>();
        builder.Services.AddTransient<MainPage>();
        builder.Services.AddTransient<ShoppingListPage>();
        builder.Services.AddTransient<CameraScanPage>();
        builder.Services.AddTransient<PantryPage>();
        builder.Services.AddTransient<SettingsPage>();

#if DEBUG
        builder.Logging.AddDebug();
#endif

        return builder.Build();
    }
}

public class App : Application
{
    public App()
    {
        InitializeComponent();

        // Check if authenticated
        var hasAuth = Preferences.Get("has_auth", false);
        
        MainPage = hasAuth 
            ? new AppShell() 
            : new NavigationPage(new LoginPage());
    }
}

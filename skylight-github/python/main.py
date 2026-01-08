#!/usr/bin/env python3
"""
Skylight Shopping List - Linux Application
Built with GTK4, Python, and modern Linux technologies

Features:
- Camera scanning with OpenCV
- Barcode scanning with pyzbar
- OpenFoodFacts API integration
- Skylight API sync
- Manual photo upload
- Native Linux look & feel
"""

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, GLib, Gio, GdkPixbuf

import sys
import os
import json
import requests
from pathlib import Path
from typing import Optional, List, Dict
import threading

# Import local modules
from lib.skylight_api import SkylightAPI
from lib.openfoodfacts_api import OpenFoodFactsAPI
from lib.camera_scanner import CameraScanner
from lib.barcode_scanner import BarcodeScanner
from lib.pantry_manager import PantryManager

APP_ID = "com.skylight.shoppinglist"
APP_NAME = "Skylight Shopping List"
VERSION = "1.0.0"

class SkylightShoppingListApp(Adw.Application):
    """Main application class"""
    
    def __init__(self):
        super().__init__(
            application_id=APP_ID,
            flags=Gio.ApplicationFlags.FLAGS_NONE
        )
        
        # Services
        self.skylight_api: Optional[SkylightAPI] = None
        self.openfoodfacts_api = OpenFoodFactsAPI()
        self.camera_scanner = CameraScanner()
        self.barcode_scanner = BarcodeScanner()
        self.pantry_manager = PantryManager()
        
        # State
        self.is_authenticated = False
        self.current_list = None
        
    def do_activate(self):
        """Called when the application is activated"""
        win = self.props.active_window
        if not win:
            win = MainWindow(application=self)
        win.present()


class MainWindow(Adw.ApplicationWindow):
    """Main application window"""
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        
        self.app = self.get_application()
        
        # Window properties
        self.set_title(APP_NAME)
        self.set_default_size(1200, 800)
        
        # Check authentication
        if self.check_auth():
            self.build_main_ui()
        else:
            self.build_login_ui()
    
    def check_auth(self) -> bool:
        """Check if user is authenticated"""
        config_path = Path.home() / ".config" / "skylight-shopping-list" / "auth.json"
        
        if config_path.exists():
            try:
                with open(config_path) as f:
                    auth_data = json.load(f)
                    self.app.skylight_api = SkylightAPI(
                        frame_id=auth_data['frame_id'],
                        auth_token=auth_data['auth_token'],
                        auth_type=auth_data['auth_type']
                    )
                    self.app.is_authenticated = True
                    return True
            except Exception as e:
                print(f"Auth check failed: {e}")
        
        return False
    
    def build_login_ui(self):
        """Build login interface"""
        # Header bar
        header = Adw.HeaderBar()
        
        # Content
        content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=24)
        content.set_margin_top(48)
        content.set_margin_bottom(48)
        content.set_margin_start(48)
        content.set_margin_end(48)
        content.set_halign(Gtk.Align.CENTER)
        content.set_valign(Gtk.Align.CENTER)
        
        # Title
        title = Gtk.Label()
        title.set_markup("<span size='xx-large' weight='bold'>Skylight Shopping List</span>")
        content.append(title)
        
        subtitle = Gtk.Label(label="Scan your pantry & sync with Skylight")
        subtitle.add_css_class("dim-label")
        content.append(subtitle)
        
        # Info box
        info_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        info_box.set_margin_top(24)
        info_box.add_css_class("card")
        
        info_title = Gtk.Label()
        info_title.set_markup("<b>Setup Instructions</b>")
        info_title.set_xalign(0)
        info_box.append(info_title)
        
        instructions = [
            "1. Use Proxyman or Charles Proxy",
            "2. Capture Skylight app traffic",
            "3. Copy Authorization header",
            "4. Find your Frame ID in API calls",
            "5. Enter credentials below"
        ]
        
        for instruction in instructions:
            label = Gtk.Label(label=instruction)
            label.set_xalign(0)
            label.add_css_class("dim-label")
            info_box.append(label)
        
        content.append(info_box)
        
        # Frame ID
        frame_id_entry = Gtk.Entry()
        frame_id_entry.set_placeholder_text("Frame ID")
        frame_id_entry.set_margin_top(24)
        content.append(frame_id_entry)
        
        # Auth Type
        auth_type_row = Adw.ComboRow()
        auth_type_row.set_title("Auth Type")
        auth_type_model = Gtk.StringList.new(["Bearer", "Basic"])
        auth_type_row.set_model(auth_type_model)
        content.append(auth_type_row)
        
        # Token
        token_entry = Gtk.PasswordEntry()
        token_entry.set_placeholder_text("Auth Token")
        token_entry.set_show_peek_icon(True)
        content.append(token_entry)
        
        # Connect button
        connect_btn = Gtk.Button(label="Connect to Skylight")
        connect_btn.add_css_class("suggested-action")
        connect_btn.add_css_class("pill")
        connect_btn.set_margin_top(12)
        connect_btn.connect("clicked", self.on_login, 
                          frame_id_entry, auth_type_row, token_entry)
        content.append(connect_btn)
        
        # Main layout
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.append(header)
        box.append(content)
        
        self.set_content(box)
    
    def build_main_ui(self):
        """Build main application interface"""
        # Header bar with view switcher
        header = Adw.HeaderBar()
        
        view_switcher = Adw.ViewSwitcher()
        view_switcher.set_policy(Adw.ViewSwitcherPolicy.WIDE)
        header.set_title_widget(view_switcher)
        
        # Menu button
        menu_btn = Gtk.MenuButton()
        menu_btn.set_icon_name("open-menu-symbolic")
        header.pack_end(menu_btn)
        
        # View stack
        stack = Adw.ViewStack()
        view_switcher.set_stack(stack)
        
        # Shopping List page
        shopping_page = self.build_shopping_list_page()
        stack.add_titled(shopping_page, "shopping", "Shopping List")
        stack.get_page(shopping_page).set_icon_name("view-list-symbolic")
        
        # Camera Scan page
        camera_page = self.build_camera_scan_page()
        stack.add_titled(camera_page, "camera", "Camera Scan")
        stack.get_page(camera_page).set_icon_name("camera-photo-symbolic")
        
        # Pantry page
        pantry_page = self.build_pantry_page()
        stack.add_titled(pantry_page, "pantry", "Pantry")
        stack.get_page(pantry_page).set_icon_name("folder-symbolic")
        
        # Settings page
        settings_page = self.build_settings_page()
        stack.add_titled(settings_page, "settings", "Settings")
        stack.get_page(settings_page).set_icon_name("preferences-system-symbolic")
        
        # Main layout
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.append(header)
        box.append(stack)
        
        self.set_content(box)
    
    def build_shopping_list_page(self) -> Gtk.Widget:
        """Build shopping list page"""
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        box.set_margin_start(24)
        box.set_margin_end(24)
        
        # List selector
        list_row = Adw.ComboRow()
        list_row.set_title("Select List")
        box.append(list_row)
        
        # Add item entry
        add_box = Gtk.Box(spacing=12)
        add_entry = Gtk.Entry()
        add_entry.set_placeholder_text("Add item to list...")
        add_entry.set_hexpand(True)
        add_box.append(add_entry)
        
        add_btn = Gtk.Button(label="Add")
        add_btn.add_css_class("suggested-action")
        add_box.append(add_btn)
        box.append(add_box)
        
        # Items list
        listbox = Gtk.ListBox()
        listbox.add_css_class("boxed-list")
        box.append(listbox)
        
        scrolled.set_child(box)
        return scrolled
    
    def build_camera_scan_page(self) -> Gtk.Widget:
        """Build camera scan page with manual upload"""
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=24)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        box.set_margin_start(24)
        box.set_margin_end(24)
        box.set_halign(Gtk.Align.CENTER)
        
        # Title
        title = Gtk.Label()
        title.set_markup("<span size='xx-large' weight='bold'>Scan Your Pantry</span>")
        box.append(title)
        
        subtitle = Gtk.Label(
            label="Take a photo or upload an image to detect items"
        )
        subtitle.add_css_class("dim-label")
        box.append(subtitle)
        
        # Image preview
        self.preview_image = Gtk.Picture()
        self.preview_image.set_size_request(640, 480)
        self.preview_image.set_content_fit(Gtk.ContentFit.CONTAIN)
        box.append(self.preview_image)
        
        # Buttons
        button_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        button_box.set_size_request(400, -1)
        
        # Take Photo button
        take_photo_btn = Gtk.Button(label="📸 Take Photo")
        take_photo_btn.add_css_class("pill")
        take_photo_btn.add_css_class("suggested-action")
        take_photo_btn.connect("clicked", self.on_take_photo)
        button_box.append(take_photo_btn)
        
        # Upload Photo button (NEW)
        upload_photo_btn = Gtk.Button(label="📁 Upload Photo")
        upload_photo_btn.add_css_class("pill")
        upload_photo_btn.connect("clicked", self.on_upload_photo)
        button_box.append(upload_photo_btn)
        
        # Scan Barcode button
        scan_barcode_btn = Gtk.Button(label="🏷️ Scan Barcode")
        scan_barcode_btn.add_css_class("pill")
        scan_barcode_btn.connect("clicked", self.on_scan_barcode)
        button_box.append(scan_barcode_btn)
        
        # Scan Image button
        self.scan_image_btn = Gtk.Button(label="🔍 Scan for Items")
        self.scan_image_btn.add_css_class("pill")
        self.scan_image_btn.set_sensitive(False)
        self.scan_image_btn.connect("clicked", self.on_scan_image)
        button_box.append(self.scan_image_btn)
        
        box.append(button_box)
        
        scrolled.set_child(box)
        return scrolled
    
    def build_pantry_page(self) -> Gtk.Widget:
        """Build pantry page"""
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        box.set_margin_start(24)
        box.set_margin_end(24)
        
        # Search
        search_entry = Gtk.SearchEntry()
        search_entry.set_placeholder_text("Search pantry items...")
        box.append(search_entry)
        
        # Category filter
        category_box = Gtk.Box(spacing=6)
        categories = ["All", "Produce", "Dairy", "Meat", "Pantry", "Frozen", "Other"]
        for category in categories:
            btn = Gtk.ToggleButton(label=category)
            btn.add_css_class("pill")
            category_box.append(btn)
        box.append(category_box)
        
        # Items grid
        flow_box = Gtk.FlowBox()
        flow_box.set_valign(Gtk.Align.START)
        flow_box.set_selection_mode(Gtk.SelectionMode.NONE)
        box.append(flow_box)
        
        scrolled.set_child(box)
        return scrolled
    
    def build_settings_page(self) -> Gtk.Widget:
        """Build settings page"""
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        box.set_margin_start(24)
        box.set_margin_end(24)
        
        # Connection info
        prefs_group = Adw.PreferencesGroup()
        prefs_group.set_title("Connection")
        
        frame_id_row = Adw.ActionRow()
        frame_id_row.set_title("Frame ID")
        if self.app.skylight_api:
            frame_id_row.set_subtitle(self.app.skylight_api.frame_id)
        prefs_group.add(frame_id_row)
        
        box.append(prefs_group)
        
        # Logout button
        logout_btn = Gtk.Button(label="Logout")
        logout_btn.add_css_class("destructive-action")
        logout_btn.connect("clicked", self.on_logout)
        box.append(logout_btn)
        
        scrolled.set_child(box)
        return scrolled
    
    # Event handlers
    
    def on_login(self, button, frame_id_entry, auth_type_row, token_entry):
        """Handle login button click"""
        frame_id = frame_id_entry.get_text().strip()
        auth_type = ["Bearer", "Basic"][auth_type_row.get_selected()]
        token = token_entry.get_text().strip()
        
        if not frame_id or not token:
            self.show_error_dialog("Please fill in all fields")
            return
        
        # Save credentials
        config_dir = Path.home() / ".config" / "skylight-shopping-list"
        config_dir.mkdir(parents=True, exist_ok=True)
        
        auth_data = {
            'frame_id': frame_id,
            'auth_token': token,
            'auth_type': auth_type
        }
        
        with open(config_dir / "auth.json", 'w') as f:
            json.dump(auth_data, f)
        
        # Initialize API
        self.app.skylight_api = SkylightAPI(frame_id, token, auth_type)
        self.app.is_authenticated = True
        
        # Rebuild UI
        self.build_main_ui()
    
    def on_take_photo(self, button):
        """Handle take photo button"""
        image_path = self.app.camera_scanner.capture_photo()
        if image_path:
            self.load_image(image_path)
    
    def on_upload_photo(self, button):
        """Handle upload photo button (NEW)"""
        dialog = Gtk.FileDialog()
        
        # Set filters for image files
        filters = Gio.ListStore.new(Gtk.FileFilter)
        
        image_filter = Gtk.FileFilter()
        image_filter.set_name("Image Files")
        image_filter.add_mime_type("image/jpeg")
        image_filter.add_mime_type("image/png")
        image_filter.add_mime_type("image/gif")
        image_filter.add_mime_type("image/webp")
        filters.append(image_filter)
        
        dialog.set_filters(filters)
        dialog.set_title("Select Photo")
        
        dialog.open(self, None, self.on_file_selected)
    
    def on_file_selected(self, dialog, result):
        """Handle file selection"""
        try:
            file = dialog.open_finish(result)
            if file:
                image_path = file.get_path()
                self.load_image(image_path)
        except Exception as e:
            print(f"File selection error: {e}")
    
    def load_image(self, image_path: str):
        """Load and display image"""
        try:
            self.preview_image.set_filename(image_path)
            self.current_image_path = image_path
            self.scan_image_btn.set_sensitive(True)
        except Exception as e:
            self.show_error_dialog(f"Failed to load image: {e}")
    
    def on_scan_barcode(self, button):
        """Handle scan barcode button"""
        # Open camera for barcode scanning
        pass
    
    def on_scan_image(self, button):
        """Handle scan image button"""
        if not hasattr(self, 'current_image_path'):
            return
        
        button.set_sensitive(False)
        button.set_label("Scanning...")
        
        def scan_thread():
            try:
                items = self.app.camera_scanner.scan_image(self.current_image_path)
                GLib.idle_add(self.on_scan_complete, items)
            except Exception as e:
                GLib.idle_add(self.show_error_dialog, f"Scan failed: {e}")
            finally:
                GLib.idle_add(button.set_sensitive, True)
                GLib.idle_add(button.set_label, "🔍 Scan for Items")
        
        thread = threading.Thread(target=scan_thread)
        thread.start()
    
    def on_scan_complete(self, items: List[str]):
        """Handle scan completion"""
        # Show results dialog
        dialog = ResultsDialog(self, items, self.current_image_path)
        dialog.present()
    
    def on_logout(self, button):
        """Handle logout"""
        config_path = Path.home() / ".config" / "skylight-shopping-list" / "auth.json"
        if config_path.exists():
            config_path.unlink()
        
        self.app.is_authenticated = False
        self.build_login_ui()
    
    def show_error_dialog(self, message: str):
        """Show error dialog"""
        dialog = Adw.MessageDialog.new(self)
        dialog.set_heading("Error")
        dialog.set_body(message)
        dialog.add_response("ok", "OK")
        dialog.present()


class ResultsDialog(Adw.Window):
    """Dialog to show scan results"""
    
    def __init__(self, parent, items: List[str], image_path: str):
        super().__init__()
        
        self.set_title("Scan Results")
        self.set_default_size(600, 500)
        self.set_transient_for(parent)
        self.set_modal(True)
        
        # Build UI
        # ... (implementation details)


def main():
    """Main entry point"""
    app = SkylightShoppingListApp()
    return app.run(sys.argv)


if __name__ == "__main__":
    sys.exit(main())

#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  GDBusProxy* settings_portal;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// GTK3 doesn't follow the desktop color scheme for the window decorations,
// so we set the dark theme preference from the XDG settings portal ourselves.
static constexpr char kAppearanceNamespace[] = "org.freedesktop.appearance";
static constexpr char kColorSchemeKey[] = "color-scheme";
static constexpr guint32 kColorSchemePreferDark = 1;

static void apply_color_scheme(GVariant* value) {
  gboolean dark = g_variant_is_of_type(value, G_VARIANT_TYPE_UINT32) &&
                  g_variant_get_uint32(value) == kColorSchemePreferDark;
  g_object_set(gtk_settings_get_default(), "gtk-application-prefer-dark-theme",
               dark, nullptr);
}

static void settings_portal_signal_cb(GDBusProxy* proxy,
                                      const gchar* sender_name,
                                      const gchar* signal_name,
                                      GVariant* parameters,
                                      gpointer user_data) {
  if (g_strcmp0(signal_name, "SettingChanged") != 0) {
    return;
  }
  const gchar* name_space = nullptr;
  const gchar* key = nullptr;
  g_autoptr(GVariant) value = nullptr;
  g_variant_get(parameters, "(&s&sv)", &name_space, &key, &value);
  if (g_strcmp0(name_space, kAppearanceNamespace) == 0 &&
      g_strcmp0(key, kColorSchemeKey) == 0) {
    apply_color_scheme(value);
  }
}

static void follow_color_scheme(MyApplication* self) {
  self->settings_portal = g_dbus_proxy_new_for_bus_sync(
      G_BUS_TYPE_SESSION, G_DBUS_PROXY_FLAGS_DO_NOT_LOAD_PROPERTIES, nullptr,
      "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop",
      "org.freedesktop.portal.Settings", nullptr, nullptr);
  if (self->settings_portal == nullptr) {
    return;
  }
  g_signal_connect(self->settings_portal, "g-signal",
                   G_CALLBACK(settings_portal_signal_cb), nullptr);

  // ReadOne returns the value directly, the deprecated Read used by older
  // portals wraps it in another variant.
  g_autoptr(GVariant) result = g_dbus_proxy_call_sync(
      self->settings_portal, "ReadOne",
      g_variant_new("(ss)", kAppearanceNamespace, kColorSchemeKey),
      G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr);
  gboolean wrapped = FALSE;
  if (result == nullptr) {
    result = g_dbus_proxy_call_sync(
        self->settings_portal, "Read",
        g_variant_new("(ss)", kAppearanceNamespace, kColorSchemeKey),
        G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr);
    wrapped = TRUE;
  }
  if (result == nullptr) {
    return;
  }
  g_autoptr(GVariant) value = nullptr;
  g_variant_get(result, "(v)", &value);
  if (wrapped && g_variant_is_of_type(value, G_VARIANT_TYPE_VARIANT)) {
    g_autoptr(GVariant) inner = g_variant_get_variant(value);
    apply_color_scheme(inner);
  } else {
    apply_color_scheme(value);
  }
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "Podku");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "Podku");
  }

  gtk_window_set_default_size(window, 1280, 720);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);

  follow_color_scheme(self);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_object(&self->settings_portal);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}

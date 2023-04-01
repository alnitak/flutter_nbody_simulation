//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <n_body/n_body_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) n_body_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NBodyPlugin");
  n_body_plugin_register_with_registrar(n_body_registrar);
}

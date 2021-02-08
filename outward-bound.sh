#!/bin/bash

while read -r i; do
  dir=${i%/*}
  [[ -f ${dir}/wp-config.php ]] &&
    cp "${dir}/wp-config.php" "${dir}/htdocs/wp-config.php"
  [[ -f ${dir}/htdocs/wp-config.php ]] &&
    sed -i "/\/\* GridPane \*\//,/include __DIR__ . '\/user-configs.php';/d" "${dir}/htdocs/wp-config.php"
  mu_plugins_dir="${dir}/htdocs/wp-content/mu-plugins"
  [[ -f ${mu_plugins_dir}/wp-cli-login-server.php ]] && rm "${mu_plugins_dir}/wp-cli-login-server.php"
  [[ -f ${mu_plugins_dir}/wp-fail2ban.php ]] && rm "${mu_plugins_dir}/wp-fail2ban.php"
  for gp_mu_plugin in "${mu_plugins_dir}"/*gridpane*; do
    [ -e "$gp_mu_plugin" ] &&
      rm -rf "$gp_mu_plugin"
  done
done <<<"$(find /var/www -name wp-config.php)"

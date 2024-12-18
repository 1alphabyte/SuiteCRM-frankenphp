#!/bin/bash

flag=/app/.installed-flag

if [ ! -f $flag ]; then
	suite_db_host=${suite_db_host:-db}
	suite_db_user=${suite_db_user:-user}
	suite_db_password=${suite_db_password:-password}
	suite_password=${suite_password:-password}
	suite_user=${suite_user:-admin}
	suite_db=${suite_db:-suitecrm}
	suite_host=${SERVER_NAME:-localhost}

	/app/bin/console suitecrm:app:install \
		-U $suite_db_user \
		-P $suite_db_password \
		-H $suite_db_host \
		-N $suite_db \
		-u $suite_user \
		-p $suite_password \
		-S $suite_host \
		--no-interaction \
		&& touch $flag
fi

frankenphp run --config /etc/caddy/Caddyfile --adapter caddyfile

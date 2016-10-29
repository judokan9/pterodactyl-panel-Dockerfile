#!/bin/ash
set -e

echo "Getting ready to start. Waiting 15 seconds for mariadb to start if you are using docker compose"

sleep 15

if [ "$1" = 'supervisord' ]; then

    if [ ! -e .env ]; then
        echo "env not found. Copying from example"
        cp .env.example .env
        php artisan key:generate
        php artisan pterodactyl:env --dbhost=$db_host --dbport=$db_port --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --url=$panel_url --timezone=$timezone

        case "$email_driver" in
            mail)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email
            echo "PHP Mail was chosen"
            ;;

            mandrill)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
            echo "Mandrill was chosen"
            ;;

            postmark)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
            echo "Postmark was chosen"
            ;;

            mailgun)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --host=$email_domain
            echo "Mailgun was chosen"
            echo "$email_driver $panel_email $email_username $email_domain"
            ;;

            smtp)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --password=$email_pass --host=$email_domain --port=$email_port
            echo "smtp was chosen"
            echo "$email_driver $panel_email $email_user $email_pass $email_domain $email_port"
            ;;

            *)
            echo "There was an error and you need to run the container again with the email information"
         esac
            php artisan migrate --force
            php artisan db:seed --force
            php artisan pterodactyl:user --email=$admin_email --password=$admin_pass --admin=$admin_stat
    elif [ ! -s .env ]; then
        echo "env empty"
        echo "Generating new .env file"
        php artisan key:generate
        php artisan pterodactyl:env --dbhost=$db_host --dbport=$db_port --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --url=$panel_url --timezone=$timezone

        case "$email_driver" in
            mail)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email
            echo "PHP Mail was chosen"
            ;;

            mandrill)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
            echo "Mandrill was chosen"
            ;;

            postmark)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
            echo "Postmark was chosen"
            ;;

            mailgun)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --host=$email_domain
            echo "Mailgun was chosen"
            echo "$email_driver $panel_email $email_username $email_domain"
            ;;

            smtp)
            php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --password=$email_pass --host=$email_domain --port=$email_port
            echo "smtp was chosen"
            echo "$email_driver $panel_email $email_user $email_pass $email_domain $email_port"
            ;;

            *)
            echo "There was an error and you need to run the container again with the email information"
         esac
            php artisan migrate --force
            php artisan db:seed --force
            php artisan pterodactyl:user --email=$admin_email --password=$admin_pass --admin=$admin_stat
    else
        echo "env found if it is correct then the panel should work"
    fi
fi

exec "$@"

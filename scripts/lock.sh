FULL_NAME=$(getent passwd "$USER" | cut -d ':' -f 5 | cut -d ',' -f 1)
MESSAGE="Bem vindo de volta, $FULL_NAME!"

case "$1" in
    suspend)
        systemctl suspend
        physlock -d -p "$MESSAGE"
        ;;
    hibernate)
        systemctl hibernate
        physlock -d -p "$MESSAGE"
        ;;
    "")
        physlock -p "$MESSAGE"
        ;;
    *)
        echo "Uso: $0 [suspend|hibernate]"
        exit 2
        ;;
esac

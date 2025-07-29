FULL_NAME=$(getent passwd "$USER" | cut -d ':' -f 5 | cut -d ',' -f 1)
MESSAGE="Bem vindo de volta, $FULL_NAME!"

case "$1" in
    suspend)
        if systemctl suspend; then
            physlock -d -p "$MESSAGE"
        else
            notify-send              \
                -i system-suspend    \
                -a lock              \
                "Falha ao suspender" \
                "Não foi possível suspender."
        fi
        ;;
    hibernate)
        if systemctl hibernate; then
            physlock -d -p "$MESSAGE"
        else
            notify-send             \
                -i system-suspend   \
                -a lock             \
                "Falha ao hibernar" \
                "Não foi possível hibernar. Verifique se há memória suficiente."
        fi
        ;;
    "")
        physlock -p "$MESSAGE"
        ;;
    *)
        echo "Uso: $0 [suspend|hibernate]"
        exit 2
        ;;
esac


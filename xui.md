https://habr.com/ru/articles/735536/

# Update settings
1. Settings -> port
1. Settings -> path
1. Settings -> password

# Create inbound

- shadowsocks
    * protocol -> shadowsocks
    * port -> any
    * client settings -> any (empty or default)
    * encryption -> 2022-blacke3-aes-256-gcm
    * other settings empty or default

- vless
    * protocol -> vless
    * port -> 443
    * reality -> turn on
    * client -> flow -> xtls-rprx-vision
    * keys -> generate with "Get new keys"

# Herramienta de Subnetting Automático en Bash

QuickSh es una herramienta en Bash que permite calcular información de la red a partir de una dirección IP y su máscara de red en notación CIDR. Proporciona la clase de la dirección, la máscara de red, la primera y última dirección IP de la subred, y el número total de hosts disponibles.

## Características

- Determina la clase de la dirección IP.
- Calcula la máscara de red.
- Obtiene la primera dirección IP (Network ID).
- Obtiene la última dirección IP (Broadcast ID).
- Calcula el número total de hosts disponibles en la subred.

## Uso

Para ejecutar la herramienta, simplemente necesitas pasar una dirección IP con su notación CIDR como argumento. Ejemplo:

```bash
./bashcanner.sh 192.168.0.1/24
```

## Ejemplo de Salida

```plaintext
[!] Dirección IP especificada: 192.168.0.1/24
--------------------------------------------------------------------------------
[+] Información de la red:
[+] Clase: C
[+] Mascara de red: 255.255.255.0
[+] Primera direccion IP (Network ID): 192.168.0.0
[+] Ultima direccion IP (Broadcast ID): 192.168.0.255
[+] Hosts totales: 254
--------------------------------------------------------------------------------
Herramienta creada por: Ernesto Ramos (h4xthan) :)
```

## Instalación

No requieres de dependencias especiales para ejecutar esta herramienta. Solo necesitas tener `bash` y `bc` instalados.

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install -y bc
```

### Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S bc
```

## Contribuciones

Si deseas contribuir a este proyecto, siéntete libre de abrir un pull request o reportar issues en el repositorio.
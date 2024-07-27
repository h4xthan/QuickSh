#!/usr/bin/env bash

# Colores
verde="\e[0;32m\033[1m"
terminar="\033[0m\e[0m"
rojo="\e[0;31m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
purpura="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
gris="\e[0;37m\033[1m"

# Ctrl + C

ctrl_c(){
	echo -e "\n\n${rojo}[!]${terminar} ${purpura}Saliendo...${terminar}\n"
	exit 1
}

trap ctrl_c INT

# Variables

ip="$1"

# Funciones

obtener_clase() {
 
  if [ $octeto1 -ge 1 ] && [ $octeto1 -le 126 ]; then
    echo -e "\n${verde}[+]${terminar} ${purpura}Clase:${terminar} ${azul}A${terminar}"
  elif [ $octeto1 -ge 128 ] && [ $octeto1 -le 191 ]; then
    echo -e "\n${verde}[+]${terminar} ${purpura}Clase:${terminar} ${azul}B${terminar}"
  elif [ $octeto1 -ge 192 ] && [ $octeto1 -le 223 ]; then
    echo -e "\n${verde}[+]${terminar} ${purpura}Clase:${terminar} ${azul}C${terminar}"
  else
    echo -e "\n$rojo[!]${terminar} ${purpura}CIDR${terminar} ${rojo}invalido${terminar}${purpura}.${terminar}"
  fi
 
}

mascara_red() {

  mascaraRed=""
  octeto_comp=$((cidr / 8))
  octeto_parc=$((cidr % 8))

  for ((i = 0; i < 4; i++)); do
    if [ $i -lt $octeto_comp ]; then
      mascaraRed+="255"
    elif [ $i -eq $octeto_comp ]; then
      mascaraRed+=$(( 256 - (2 ** (8 - octeto_parc)) ))
    else
      mascaraRed+="0"
    fi

    if [ $i -lt 3 ]; then
      mascaraRed+="."
    fi
  done

  echo -e "${verde}[+]${terminar} ${purpura}Mascara de red:${terminar} ${azul}$mascaraRed${terminar}"
}

# Calcular primera direccion IP
primer_ip() {

  IFS='.' read -r -a octetos_ip <<< "$ip"
  IFS='.' read -r -a octetos_mascara <<< "$mascaraRed"
  ip_bin=""
  mascara_bin=""

  # IP y mascara de red a binario

  for octeto in "${octetos_ip[@]}"; do
    ip_bin+=$(printf "%08d" "$(echo "obase=2;$octeto" | bc)")
  done

  for octeto in "${octetos_mascara[@]}"; do
    mascara_bin+=$(printf "%08d" "$(echo "obase=2;$octeto" | bc)")
  done

  # Calcular direccion de red

  red_bin=""
  for ((i = 0; i < 32; i++)); do
    red_bin+=$(( ${ip_bin:i:1} & ${mascara_bin:i:1} ))
  done

  # Conversion de red, de binario a decimal

  id_red=""
  for ((i = 0; i < 4; i++)); do
    octeto=$((2#${red_bin:i*8:8}))
    id_red+="$octeto"

    if [ $i -lt 3 ]; then
      id_red+="."
    fi
  done

  echo -e "${verde}[+]${terminar} ${purpura}Primera direccion IP (${terminar}${azul}Network ID${terminar}${purpura}):${terminar} ${azul}$id_red${terminar}"
}

ultima_ip() {

  IFS='.' read -r -a octetos_ip <<< "$ip"
  IFS='.' read -r -a octetos_mascara <<< "$mascaraRed"
  ip_bin=""
  mascara_bin=""

  # IP y mascara de red a binario

  for octeto in "${octetos_ip[@]}"; do
    ip_bin+=$(printf "%08d" "$(echo "obase=2;$octeto" | bc)")
  done

  for octeto in "${octetos_mascara[@]}"; do
    mascara_bin+=$(printf "%08d" "$(echo "obase=2;$octeto" | bc)")
  done

  # Calcular direccion de red

  red_bin=""
  broad_bin=""

  for ((i = 0; i < 32; i++)); do
    red_bin+=$(( ${ip_bin:i:1} & ${mascara_bin:i:1} ))
    broad_bin+=$(( ${ip_bin:i:1} | (1 - ${mascara_bin:i:1}) )) 
  done

  # Conversion de red, de binario a decimal

  id_broad=""
  for ((i = 0; i < 4; i++)); do
    octeto=$((2#${broad_bin:i*8:8}))
    id_broad+="$octeto"

    if [ $i -lt 3 ]; then
      id_broad+="."
    fi
  done

  echo -e "${verde}[+]${terminar} ${purpura}Ultima direccion IP (${terminar}${azul}Network ID${terminar}${purpura}):${terminar} ${azul}$id_broad${terminar}"

}

total_hosts() {

  resta=$((32 - $cidr))
  host_totales=$((2 ** $resta - 2))

  echo -e "${verde}[+]${terminar} ${purpura}Hosts totales:${terminar} ${azul}$host_totales${terminar}\n"
}

# Codigo

if [ $ip ]; then
  octeto1=$(echo "$ip" | tr '/' '.' | cut -d "." -f 1)
	octeto2=$(echo "$ip" | tr '/' '.' | cut -d "." -f 2)
	octeto3=$(echo "$ip" | tr '/' '.' | cut -d "." -f 3)
	octeto4=$(echo "$ip" | tr '/' '.' | cut -d "." -f 4)
  cidr=$(echo "$ip" | cut -d "/" -f 2)

  if [ $cidr -ge 1 ] && [ $cidr -le 32 ]; then
    echo -e "\n${azul}[!]${terminar} ${purpura}Direccion IP especificada:${terminar} ${azul}$ip${terminar}\n"
    for i in $(seq 1 80); do echo -ne "${rojo}-"; done; echo -ne "${terminar}"
    echo -e "\n\n${verde}[+]${terminar} ${purpura}Informacion de la red:${terminar}"
    obtener_clase
    mascara_red
    primer_ip
    ultima_ip
    total_hosts
    for i in $(seq 1 80); do echo -ne "${rojo}-"; done; echo -ne "${terminar}"; echo
      echo -e "\n${purpura}Herramienta creada por:${terminar} ${azul}Ernesto Ramos${terminar} ${purpura}(${terminar}${azul}h4xthan${terminar}${purpura})${terminar} ${verde}:)${terminar}\n"
  else
    echo -e "\n${rojo}[!]${terminar} ${purpura}Has introducido un CIDR invalido.${terminar}\n"
    exit 1
  fi
else
	echo -e "\n${rojo}[!]${terminar} ${purpura}No has especificado una IP valida. Ejemplo:${terminar} ${azul}./bashcanner.sh 192.168.0.1/24${terminar} ${purpura}(colocando el CIDR)${terminar}\n"
  exit 1
fi



#!/bin/bash

sajat_ip()
{
    curl ipinfo.io --silent -o response.json
}


masik_ip()
{
    curl ipinfo.io/$1 --silent -o response.json
}
#sajat_ip

help()
{
    cat << END
    $0 [opciók]
	-s: Saját adatok letöltése
	-b: Letöltött adatok kiíratása
	-m: Adatok szűrése, ip cím és hostname kiíratása
	-o <ip> Másik IP cím lekérése
	-h: Segítség
END
}

beolvas()
{
    if [ -f response.json ]
    then
	cat response.json | jq
    else
	echo "Nincs response.json fájl!"
	exit 1
    fi
}

#beolvas

szur()
{
    if [ -f response.json ]
    then
	ip=$(cat response.json | jq .ip)
	hostn=$(cat response.json | jq .hostname)
	echo "IP: $ip"
	echo "HOSTNAME: $hostn"
    else
	echo "Ninc response.json fájl!"
	exit 1
    fi
}

#szur

while getopts ":sbmho" PARAM
do
    case $PARAM in

	s)
	sajat_ip
	echo "Saját adatok letöltve!"
	exit
	;;

	b)
	beolvas
	;;

	m)
	szur
	;;

	o)
	ip=$OPTARG
	masik_ip $ip
	;;

	h)
	help
	;;

	:)
	echo "$OPTARG vár paramétert!"
	exit
	;;

	*)
	echo "Érvénytelen paraméter!"
	exit 1
	;;

    esac
done

shift $(($OPTIND-1))


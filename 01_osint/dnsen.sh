#!/bin/bash

domain=""
while getopts "d:" opt; do
	case $opt in
		d) domain="$OPTARG" ;;
		*) echo "Example: $0 -d <domain>"; exit 1 ;;
	esac
done

if [ -z "$domain" ]; then
	echo "Error: Parameter -d (domain) required."
	exit 1
fi

check_ban() {
    if echo "$1" | grep -Ei "No match for" > /dev/null; then
        echo "Whois banned, try again later... "
        return 1
    fi
    return 0
}

echo "DNS enumeration $domain"
sleep 2

echo ""
echo "=== WHOIS INFORMATION ==="

whois_raw=$(whois -H "$domain")

if ! check_ban "$whois_raw"; then
    echo "$whois_raw"
else
    reg_url=$(echo "$whois_raw" | grep -iE "Registrar WHOIS Server:|whois:" | head -n 1 | awk '{print $NF}')

    if [ -n "$reg_url" ]; then
        sleep 2
        echo "--- Detailed Registrar Info (via $reg_url) ---"
        whois_detail=$(whois -h "$reg_url" -H "$domain")
        echo "$whois_detail"
        check_ban "$whois_detail"
    else
        echo "Notice: Registrar WHOIS server not found. Showing initial info:"
        echo "$whois_raw"
    fi
fi

echo ""
sleep 1

echo ""
echo "=== HOST INFORMATION ==="
echo "--- NS Records ---"
host -t ns "$domain"
echo ""
sleep 1

echo "--- MX Records ---"
host -t mx "$domain"
echo ""
sleep 1

echo "=== RESULT DNSRECON ==="
echo "--- Std Record ----"
dnsrecon -d "$domain" -t std
echo ""
sleep 1

echo "--- Srv Records ----"
dnsrecon -d "$domain" -t srv
echo ""

echo "--- Brt Records ----"
dnsrecon -d "$domain" -t brt
echo ""

echo "======================="

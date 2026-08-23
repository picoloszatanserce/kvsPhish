from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse
import subprocess

HOST = "127.0.0.1"
PORT = 8000

selected_form = "form1.html"
domain = "brak"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            with open(selected_form, "r", encoding="utf-8") as f:
                html = f.read().replace("{{DOMAIN}}", domain)
            self._send(html, "text/html")
            return

        self.send_error(404)

    def do_POST(self):
        if self.path == "/submit":
            length = int(self.headers.get("Content-Length", 0))
            data = self.rfile.read(length).decode()
            parsed = urllib.parse.parse_qs(data)

            print("\n--- ODEBRANE DANE ---")
            for key, value in parsed.items():
                print(f"{key}: {value[0]}")
            print("---------------------\n")

            subprocess.run(["python3", "script.py"] + [v[0] for v in parsed.values()])

            self._send("Dane odebrane i przekazane do programu.", "text/plain")
            return

        self.send_error(404)

    def _send(self, content, ctype):
        self.send_response(200)
        self.send_header("Content-type", ctype)
        self.end_headers()
        self.wfile.write(content.encode("utf-8"))

server = HTTPServer((HOST, PORT), Handler)
print(f"Serwer działa na http://{HOST}:{PORT}")
server.serve_forever()

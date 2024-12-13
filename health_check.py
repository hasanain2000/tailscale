from http.server import BaseHTTPRequestHandler, HTTPServer

class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Healthy")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 80), HealthCheckHandler)
    server.serve_forever()

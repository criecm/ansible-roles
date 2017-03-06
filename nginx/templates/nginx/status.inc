location /nginx_status {
	stub_status on;
	allow 147.94.19.0/24;
	allow 127.0.0.1/32;
	allow 10.0.3.0/24;
	deny all;
}


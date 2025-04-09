1. make it executable
   
```bash
   chmod +x setup_nginx_reverse_proxy.sh
```
 2.	Run the script as sudo: 
 
 ```bash
    chmod +x setup_nginx_reverse_proxy.sh
```


What This Script Does:

	1.	Creates a Configuration File: It sets up an Nginx server block that listens on port 80 and proxies requests to a backend server.
	2.	Links the Configuration: Activates the configuration by linking it to `/etc/nginx/sites-enabled`.
	3.	Tests Configuration: Ensures there are no syntax errors in the new configuration.
	4.	Restarts Nginx: Applies the changes by restarting the Nginx service.
 
You can modify variables like `BACKEND_SERVER` and `SERVER_NAME` at the top of the script to suit your specific needs.

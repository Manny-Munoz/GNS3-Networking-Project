;
; Zone file example for quetzal.gt.com
; This is an example. You will likely need to modify this document based on the server you are configuring.
; Change the "gt" part to the country code of your server (e.g., "cr", "us", "mx") and update the IP addresses as needed.
; After making your changes, rename the file to match the zone (e.g., db.gt.com).
;
; Debian/Ubuntu:
; - Move the file: mv ./db.gt.com /etc/bind/
; - Add the zone to /etc/bind/named.conf.local using your preferred editor (vim, nano, vi):
;   zone "gt.com" {
;     type master;
;     file "/etc/bind/db.gt.com";
;   };
;
; Rocky Linux / openSUSE:
; - Move the file: mv ./db.gt.com /var/named/   (Rocky) or /var/lib/named/   (openSUSE)
; - Add the zone to /etc/named.conf:
;   zone "gt.com" {
;     type master;
;     file "/var/named/db.gt.com";      (Rocky)
;     file "/var/lib/named/db.gt.com";  (openSUSE)
;   };
;

$TTL    604800
@       IN      SOA     quetzal.gt.com. root.quetzal.gt.com. (
                          1         ; Serial
                          604800    ; Refresh
                          86400     ; Retry
                          2419200   ; Expire
                          604800 )  ; Negative Cache TTL
;
                IN      NS      quetzal.gt.com.
quetzal         IN      A       172.16.0.10
admin.quetzal   IN      A       172.16.0.10
www.quetzal     IN      A       172.16.0.10
notas.quetzal   IN      A       172.16.0.10
samba.quetzal   IN      A       172.16.0.11
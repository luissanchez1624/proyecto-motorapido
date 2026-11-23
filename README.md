# Proyecto final de Sistemas Operativos
## MotoRápido - Taller y almacén de motocicletas

### 1. Descripción del proyecto

Para nuestro proyecto final escogimos un taller y almacén de motocicletas llamado MotoRápido. La idea fue crear un servidor que ayudara a organizar la información del negocio, como las ventas, los clientes, las reparaciones y los documentos importantes.

Para hacerlo utilizamos Ubuntu Server instalado en una máquina virtual de VirtualBox. Desde Windows nos conectamos al servidor por medio de SSH, lo que nos permitió trabajar y realizar las configuraciones sin necesidad de hacerlo directamente desde la máquina virtual.

Durante el proyecto creamos diferentes usuarios y grupos, organizamos las carpetas según las áreas del negocio y configuramos permisos para que cada empleado pudiera acceder solamente a la información que necesita. También creamos un servicio de monitoreo, programamos copias de seguridad automáticas y realizamos algunas configuraciones para mejorar la seguridad del servidor.

### 2. Objetivo del proyecto

Configurar un servidor Ubuntu Server para MotoRápido, donde podamos organizar los archivos del negocio, controlar el acceso de los empleados, realizar copias de seguridad y mantener el servidor funcionando de manera segura.

### 3. Herramientas utilizadas

Para realizar este proyecto utilizamos las siguientes herramientas:

- **Windows:** es el sistema operativo de nuestro computador principal.
- **VirtualBox:** lo utilizamos para crear la máquina virtual donde instalamos Ubuntu.
- **Ubuntu Server:** es el sistema operativo que configuramos para administrar la información de MotoRápido.
- **SSH:** nos permite conectarnos al servidor desde Windows sin tener que trabajar directamente en la ventana de VirtualBox.
- **systemd:** lo utilizamos para configurar el servicio de monitoreo del servidor.
- **tar:** nos permite comprimir las carpetas y crear copias de seguridad.
- **cron:** lo utilizamos para programar los respaldos automáticos.
- **Git y GitHub:** los utilizaremos para guardar y compartir la documentación del proyecto.


### 4. Usuarios, grupos y permisos

Para organizar mejor la información de MotoRápido, creamos diferentes usuarios y grupos según las funciones que tendría cada empleado dentro del negocio.

Los usuarios que creamos fueron: luis, admin, soporte, invitado, ventas y mecanico.

También creamos cinco grupos para organizar los permisos:

- **administradores:** pertenece el usuario admin.
- **administracion:** pertenecen admin y soporte.
- **soporte:** pertenecen admin y soporte.
- **taller:** pertenecen mecanico y admin.
- **ventas:** pertenecen ventas y admin.

La idea de utilizar estos grupos fue evitar que todos los empleados pudieran entrar a cualquier carpeta del servidor.

### 4.1. Carpetas del negocio

Dentro de la ruta `/srv/motorapido` creamos cinco carpetas para guardar la información de las diferentes áreas.

| Carpeta | Grupo | Permisos |
|---|---|---|
| clientes | ventas | 2770 |
| documentos | administracion | 2770 |
| reparaciones | taller | 2770 |
| reportes | administracion | 2770 |
| ventas | ventas | 2770 |

Utilizamos los permisos 2770 porque permiten que el propietario y los usuarios del grupo correspondiente trabajen con los archivos, mientras que los demás usuarios no tienen acceso.

Por ejemplo, el usuario mecanico puede trabajar en la carpeta reparaciones porque pertenece al grupo taller. En cambio, el usuario ventas tiene acceso a las carpetas que corresponden a su grupo.

También realizamos pruebas con diferentes usuarios para comprobar que los permisos funcionaran correctamente. Algunos pudieron acceder a las carpetas autorizadas, mientras que otros recibieron un mensaje de permiso denegado.

De esta manera, buscamos proteger la información del negocio y evitar que los empleados puedan modificar archivos que no corresponden a sus funciones.### 3. Herramientas utilizadas

- Windows: computador desde el cual trabajamos.
- VirtualBox: programa utilizado para crear la máquina virtual.
- Ubuntu Server: sistema operativo que utilizamos como servidor.
- SSH: nos permitió conectarnos a Ubuntu desde Windows.
- systemd: lo utilizamos para crear y administrar nuestro servicio de monitoreo.
- tar: herramienta que usamos para comprimir los archivos y crear los respaldos.
- cron: lo utilizamos para programar los respaldos automáticos.
- Git y GitHub: herramientas para guardar y compartir la documentación del proyecto.



### 5. Servicio de monitoreo del servidor

Para MotoRápido creamos un servicio que nos permite llevar un registro del funcionamiento del servidor.

Primero hicimos un script llamado `motorapido-monitor.sh`, que se encuentra en la ruta `/usr/local/bin/`.

Este script guarda cada 60 segundos algunos datos importantes, como la fecha, el nombre del servidor, cuánto tiempo lleva encendido y un mensaje que indica que está funcionando.

Toda esta información queda registrada en el archivo:

`/srv/motorapido/reportes/estado_servidor.log`

Después configuramos el servicio `motorapido-monitor.service` utilizando systemd, para que el script pudiera ejecutarse automáticamente sin tener que iniciarlo manualmente cada vez.

También configuramos `Restart=always` y `RestartSec=5`, para que el servicio vuelva a iniciarse después de 5 segundos si se detiene.

Para comprobar que funcionaba, revisamos su estado con el comando:

`sudo systemctl status motorapido-monitor.service`

El resultado mostró `active (running)`, lo que significa que el servicio estaba funcionando correctamente.

Además, realizamos una prueba deteniendo su proceso y comprobamos que systemd lo iniciaba nuevamente.

Finalmente, después de actualizar y reiniciar Ubuntu Server, verificamos que el servicio se había iniciado automáticamente.

Este monitoreo nos ayuda a tener un registro básico del servidor y a comprobar que el servicio continúa funcionando sin necesidad de ejecutarlo manualmente.




### 6. Copias de seguridad y restauración

Para evitar que MotoRápido pierda información importante, configuramos un sistema de copias de seguridad automáticas.

Primero creamos un script llamado `respaldar-motorapido.sh`, ubicado en `/usr/local/sbin/`.

Este script toma la carpeta `/srv/motorapido`, donde se encuentra la información del negocio, y crea una copia comprimida utilizando el comando `tar`.

Los respaldos se guardan en:

`/var/backups/motorapido`

Cada copia tiene la fecha y la hora en su nombre, para poder identificar cuándo se realizó.

También configuramos un archivo llamado `respaldo.log`, donde queda registrado si la copia se realizó correctamente con el mensaje `OK` o si ocurrió algún problema con el mensaje `FALLO`.

### 6.1. Respaldos automáticos con cron

Para no tener que realizar las copias manualmente todos los días, utilizamos `cron`, que permite programar tareas automáticas en Ubuntu.

Configuramos la siguiente programación:

`0 2 * * * /usr/local/sbin/respaldar-motorapido.sh`

Esto significa que el servidor realizará una copia de seguridad todos los días a las 2:00 de la mañana.

Para comprobar que funcionaba, primero programamos temporalmente los respaldos cada minuto.

Después revisamos que se generaran nuevos archivos y que aparecieran los registros con `OK`.

Cuando terminamos las pruebas, dejamos nuevamente la programación diaria a las 2:00 a. m.

### 6.2. Prueba de restauración

También realizamos una prueba para comprobar que los respaldos realmente funcionaran.

Para esto, tomamos una copia de seguridad y la restauramos en una carpeta diferente, sin modificar los archivos originales.

Después utilizamos el comando `diff -r` para comparar los archivos restaurados con los originales.

El resultado confirmó que los archivos eran iguales y que la copia se había realizado correctamente.

Esta prueba fue importante porque no basta con crear respaldos; también debemos asegurarnos de que podamos recuperar la información cuando sea necesario.

Con esta configuración, MotoRápido cuenta con una forma de proteger sus archivos y recuperarlos en caso de que se borren o se presente algún problema.




### 7. Seguridad básica del servidor

Para proteger la información de MotoRápido, realizamos algunas configuraciones de seguridad en Ubuntu Server.

**Actualización del sistema**

Primero utilizamos los comandos `sudo apt update` y `sudo apt upgrade` para actualizar los paquetes del sistema operativo.

Después de instalar las actualizaciones, reiniciamos el servidor y comprobamos que estaba utilizando el kernel `7.0.0-44-generic`.

También verificamos que nuestro servicio de monitoreo siguiera funcionando después del reinicio.

**Permisos de las carpetas**

Revisamos que las carpetas de MotoRápido no tuvieran permisos 777, ya que estos permitirían que cualquier usuario pudiera modificar su contenido.

Para comprobarlo utilizamos:

`sudo find /srv/motorapido -type d -perm -0002 -ls`

El comando no mostró ninguna carpeta con permisos de escritura para cualquier usuario.

**Permisos de administrador**

Comprobamos que el usuario `luis` tiene permisos para administrar el servidor mediante `sudo`.

También revisamos el grupo `sudo` y encontramos que `luis` era su único integrante directo.

Esto nos ayuda a mantener separados los permisos de administración del servidor y los permisos que necesitan los empleados del negocio.

**Acceso remoto mediante SSH**

Para administrar Ubuntu desde Windows utilizamos una conexión SSH.

Revisamos su configuración y comprobamos que permite la autenticación mediante contraseña y mediante claves SSH.

También verificamos que la cuenta `root` tiene su contraseña bloqueada, por lo que no se puede iniciar sesión con esa cuenta utilizando una contraseña.

**Importancia de estas medidas**

Estas configuraciones nos permiten reducir el riesgo de que usuarios no autorizados modifiquen archivos, evitar cambios innecesarios en el sistema y mantener el servidor actualizado.

De esta manera, buscamos que la información de MotoRápido esté mejor protegida y que cada empleado tenga acceso solamente a lo que necesita para trabajar.



### 8. Solución de problemas

Durante la administración del servidor pueden presentarse algunos problemas. Por eso, dejamos algunos comandos que nos permiten revisar qué está pasando y buscar una solución.

**Problema 1. Un usuario no puede entrar a una carpeta**

Primero debemos revisar los permisos de la carpeta utilizando:

`ls -ld /srv/motorapido/*`

También podemos comprobar a qué grupos pertenece el usuario con:

`groups nombre_usuario`

Si el usuario no tiene acceso, debemos revisar si realmente necesita entrar a esa carpeta antes de cambiar sus permisos.

**Problema 2. El servicio de monitoreo deja de funcionar**

Podemos revisar su estado utilizando:

`sudo systemctl status motorapido-monitor.service`

Si el servicio está detenido, podemos intentar iniciarlo nuevamente con:

`sudo systemctl restart motorapido-monitor.service`

Después revisamos otra vez su estado para comprobar que esté funcionando.

**Problema 3. No se generan los respaldos**

Primero revisamos que cron esté funcionando:

`sudo systemctl status cron`

Después comprobamos la programación de los respaldos:

`sudo crontab -l`

También podemos revisar el registro:

`sudo cat /var/backups/motorapido/respaldo.log`

Si aparece `FALLO`, debemos revisar el script y los permisos de las carpetas.

**Problema 4. No podemos conectarnos por SSH**

Si no podemos entrar desde Windows, primero revisamos que la máquina virtual de Ubuntu esté encendida y tenga conexión de red.

Desde la consola de Ubuntu podemos comprobar el servicio SSH con:

`sudo systemctl status ssh`

También podemos consultar la dirección IP del servidor con:

`hostname -I`

Después intentamos conectarnos nuevamente desde Windows utilizando la dirección IP correcta.

**Problema 5. El servidor necesita actualizaciones**

Para comprobar las actualizaciones disponibles utilizamos:

`sudo apt update`

`apt list --upgradable`

Si existen actualizaciones pendientes, podemos instalarlas con:

`sudo apt upgrade`

Antes de reiniciar el servidor debemos comprobar que no haya tareas importantes ejecutándose.

Con estos comandos podemos identificar algunos problemas básicos y realizar las primeras comprobaciones sin tener que configurar todo el servidor nuevamente.


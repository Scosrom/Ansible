# Configuración de un Host de Windows para Ansible
Este documento detalla la configuración requerida antes de que Ansible pueda comunicarse con un host de Microsoft Windows.

- Requisitos del Host

Para que Ansible pueda comunicarse con un host de Windows y utilizar módulos de Windows, el host de Windows debe cumplir con estos requisitos básicos de conectividad:

**Requisitos del sistema operativo:** En general, Ansible puede administrar versiones de Windows bajo el soporte actual y extendido de Microsoft. Esto incluye Windows 10, 11, Windows Server 2016, 2019 y 2022.

**PowerShell y .NET Framework:** Es necesario instalar PowerShell 5.1 o más reciente y al menos .NET Framework 4.0 en el host de Windows.

**WinRM:** Es necesario crear y activar un listener de WinRM. Consulta la sección WinRM Listener para más detalles.

- Actualización de PowerShell y .NET Framework

Ansible requiere PowerShell versión 5.1 y .NET Framework 4.6 o más reciente para funcionar correctamente. Si la imagen base del sistema operativo no cumple con estos requisitos, puedes utilizar el script Upgrade-PowerShell.ps1 para actualizarlos.


```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "Administrador"
$password = "Contraseña"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

&$file -Version 5.1 -Username $username -Password $password -Verbose

```
Una vez completada la actualización, se recomienda volver a establecer la política de ejecución a su valor predeterminado:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
```

Elimina el inicio de sesión automático.

```
$reg_winlogon_path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $reg_winlogon_path -Name AutoAdminLogon -Value 0
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultUserName -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultPassword -ErrorAction SilentlyContinue
```
### Hotfix de Memoria de WinRM

En PowerShell v3.0, hay un error que limita la cantidad de memoria disponible para el servicio WinRM. Utiliza el script Install-WMF3Hotfix.ps1 para instalar un hotfix en hosts afectados como parte del proceso de arranque o de imagen del sistema. Sin este hotfix, Ansible no puede ejecutar ciertos comandos en el host de Windows.

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Install-WMF3Hotfix.ps1"
$file = "$env:temp\Install-WMF3Hotfix.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose
```


### Configuración de WinRM
WinRM (Windows Remote Management) es el servicio que permite la comunicación remota con hosts de Windows. Para que Ansible pueda conectarse al host de Windows, es necesario configurar el servicio WinRM. Hay dos componentes principales que gobiernan cómo Ansible puede interactuar con el host de Windows: el listener y la configuración del servicio.

- Listener de WinRM

Los servicios de WinRM escuchan las solicitudes en uno o más puertos. Cada uno de estos puertos debe tener un listener creado y configurado.

Para ver los listeners actuales que se están ejecutando en el servicio WinRM, puedes ejecutar el siguiente comando:

```
winrm enumerate winrm/config/Listener
```

Esto dará como resultado algo similar a:

```
Escuchador
    Dirección = *
    Transporte = HTTP
    Puerto = 5985
    Nombre de host
    Habilitado = true
    Prefijo de URL = wsman
    Huella del certificado
    Escuchando en = 10.0.2.15, 127.0.0.1, 192.168.56.155, ::1, fe80::5efe:10.0.2.15%6, fe80::5efe:192.168.56.155%8, fe80::
ffff:ffff:fffe%2, fe80::203d:7d97:c2ed:ec78%3, fe80::e8ea:d765:2c69:7756%7
...
```

Este comando mostrará la configuración de los listeners activos, incluyendo detalles como la dirección, el transporte, el puerto y el prefijo de URL.

- Configuración del Servicio WinRM

Puedes controlar el comportamiento del componente de servicio WinRM, incluidas las opciones de autenticación y las configuraciones de memoria. Para obtener una salida de las opciones de configuración del servicio actual, ejecuta el siguiente comando:

```
winrm get winrm/config/Service
```
Este comando mostrará las configuraciones actuales del servicio, como el SDDL raíz, el número máximo de operaciones concurrentes, el tiempo de espera de enumeración, etc.


## Configuración un inventario para windows

/etc/hosts
![image](https://github.com/Scosrom/Ansible/assets/114906778/896eb9e6-c4cc-4d60-95d5-5a0ed1cbb355)


archivo inventario
![image](https://github.com/Scosrom/Ansible/assets/114906778/a8c5273c-8a10-46e3-b04a-095718192e36)


Comprobamos:

![image](https://github.com/Scosrom/Ansible/assets/114906778/99c063b9-375a-40c1-a696-62347971cd4b)


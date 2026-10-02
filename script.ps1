Import-Module ActiveDirectory
    Write-Host "ES RECOMENDABLE SEGUIR EL PASO A PASO DEL MENU"

# En el punto 1 solo se muestra por pantalla el menú.

    do {
    # 1) Menu.
    Write-Host "1. Informacion del dominio"
    Write-Host "2. Crear OU"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"

# En el punto 2 el usuario eligirá la opción que quiera realizar.

    # 2) Opcion.
    $opcion = Read-Host "Elige una opcion"

<# En el punto 3, en la opción 1 guardo los datos en variables para luegos mostrarlas con Write-Host
en la opción 2 se almacenará en una variable lo que escriba el usuario para posteriormente cuando se crea la OU se haga con el valor que escribio el usuario
en la opción 3 se hará de forma similar a la anterior tanto para guardar el valor de la OU dentro de la ruta como la creación del grupo que el usuario desee
en la opción 4 se hará similar a los anteriores, el usuario guardará sus datos en variables y con ellas crearemos el usuario.
en la opción 5 saldrá del bucle
#>

    # 3) Se ejecuta una de estas opciones.
    switch ($opcion) {
        "1" { 
        $Equipo = $env:COMPUTERNAME
        $Dominio = (Get-ADDomain).DNSRoot
        $OU = (Get-ADOrganizationalUnit -Filter *).Count
        $Grupos = (Get-ADGroup -Filter *).Count
        $Usuarios = (Get-ADUser -Filter *).Count
        Write-Host "$Equipo"
        Write-Host "$Dominio"
        Write-Host "Hay $OU"
        Write-Host "Hay $Grupos"
        Write-Host "Hay $Usuarios"
         }




        "2" { 
        $NombreOU = Read-Host "Escriba el nombre de la unidad organizativa que desees crear"
        New-ADOrganizationalUnit -Name $NombreOU
        Write-Host "Se ha creado correctamente la unidad organizativa" 
        
        }







        "3" {
      $OU = Read-Host "Especifica la OU donde quieras añadir este grupo (Tienes que haber creada una anteriormente o saber la OU a la que quieres añadir este grupo, si no dara error)"
      $Dominio = (Get-ADDomain).DistinguishedName
      $RutaFinal = "OU=$OU,$Dominio"
      $NombreGrupo = Read-Host "Escriba el nombre del grupo que desees crear"
      New-ADGroup -Name $NombreGrupo -GroupScope Global -Path $RutaFinal
      Write-Host "Se ha creado correctamente el grupo" 
        }
        "4" {
        
        $OU = Read-Host "Especifica la OU donde quieras añadir este usuario (Tienes que haber creada una anteriormente o saber la OU a la que quieres añadir este usuario, si no dara error)"
        $Dominio = (Get-ADDomain).DistinguishedName
        $Nombre = Read-Host "Escriba su nombre a continuacion:"
        $NombreInicioSesion = Read-Host "Escriba su nombre para el inicio sesion:"
        $NombreInicioSesion1 = Read-Host "Escriba un identificador de inicio de sesion: (Ej. josedavids@josedavids.aws)"
        $Contrasena = Read-Host "Escriba la contraseña a continuacion:" -AsSecureString
        $RutaFinal = "OU=$OU,$Dominio"
        
        
        New-ADUser -Name $Nombre -SamAccountName $NombreInicioSesion -UserPrincipalName $NombreInicioSesion1 -Path $RutaFinal -AccountPassword $Contrasena -Enabled $True -ChangePasswordAtLogon $True


        $Grupo = Read-Host "Especifica el grupo al que quieras añadir este usuario, debera estar en la misma OU:"
        Add-ADGroupMember -Identity "$Grupo" -Members "$NombreInicioSesion"
        
        Write-Host "Usuario registrado correctamente y añadido al grupo pertinente" }
        "5" { Write-Host "Adios" }
        default { Write-Host "Opcion no valida, pulse uno de los numeros para continuar" }
    }

} while ($opcion -ne "5")
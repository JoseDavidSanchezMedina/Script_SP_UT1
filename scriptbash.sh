#!/bin/bash

echo "Antes de comenzar rellene los siguientes datos"

#guardo los datos del dominio en variables para que resulte mas fácil a la hora de ejecutar los cambios y serviría en cualquier dominio ya que el que lo ejecuta tendrá que rellenar los datos claves

read -p "Escriba la URI de su servidor (ldap://localhost): " ldap_host
read -p "Escriba el DN del administrador (Ej. cn=admin,dc=josedavids2026,dc=ldap ): " ldap_dnadmin
read -p "Escriba la DN base del dominio (Ej. dc=josedavids2026,dc=ldap): " ldap_dndominio

#Muestro la lista de los datos antes de los cambios

ldapsearch -x -H "$ldap_host" -D "$ldap_dnadmin" -W -b "$ldap_dndominio" "(objectClass=inetOrgPerson)" cn mail


option=0

while [ "$option" -ne 4 ]; do


	echo "MENU"
 	echo "1. Opcion 1"
 	echo "2. Opcion 2"
 	echo "3. Opcion 3"
 	echo "4. Salir"

	read -p "Elige una opción: " option


	case $option in

		1)
			# En esta parte pido los nombres de usuario y ou para almacenarlos, luego con echo añado lo que necesito para poder modificar correctamente el archivo y creo un archivo con > y meto esos datos en ese archivo. Luego ejecuto el archivo y lo borro cuando ha hecho su cometido

			read -p "Introduce el nombre del usuario del que quieras eliminar su email: " usuario
			read -p "Introduce el nombre de la OU: " ou

			echo -e "dn: uid=$usuario,ou=$ou,$ldap_dndominio\nchangetype: modify\ndelete: mail" > eliminar_correo.ldif

			ldapmodify -x -H "$ldap_host" -D "$ldap_dnadmin" -W -f eliminar_correo.ldif

			rm -f eliminar_correo.ldif
			
			echo "Has eliminado correctamente el mail del usuario $usuario"
			
			;;
		2)
			# Similar al anterior lo único que cambia es el modify ya no es delete sino replace para reemplazarlo por el solicitado en el ejercicio

			read -p "Introduce el nombre del usuario del que quieras reemplazar su email: " usuario
			read -p "Introduce el nombre de la OU: " ou
			
			echo -e "dn: uid=$usuario,ou=$ou,$ldap_dndominio\nchangetype: modify\nreplace: mail\nmail: prueba@nombre2026.ldap" > reemplazar_correo.ldif
			
			ldapmodify -x -H "$ldap_host" -D "$ldap_dnadmin" -W -f reemplazar_correo.ldif
			
			rm -f reemplazar_correo.ldif
	
			echo "Haz reemplazado correctamente el mail del usuario $usuario"
			
			;;

		3) 
			# Con este comando muestra el estado después de eliminar y reemplazar en las dos primeras opciones, también permite buscar por usuario. Si el parámetro queda vacio mostrara todos debido a -z que ve si la variable está vacia.
			
			read -p "Introduce el nombre del usuario que quieras buscar(si no pones nada mostrará todos): " usuario_buscar

    			if [ -z "$usuario_buscar" ]; then
        			ldapsearch -x -H "$ldap_host" -D "$ldap_dnadmin" -W -b "$ldap_dndominio" "(objectClass=inetOrgPerson)" cn mail

    			else
        			ldapsearch -x -H "$ldap_host" -D "$ldap_dnadmin" -W -b "$ldap_dndominio" "(&(objectClass=inetOrgPerson)(uid=$usuario_buscar))" cn mail

    			fi

    			;;
		4)  
			# Al haber iniciado el bucle con while [ "$option" -ne 4 ] en esta opción se saldrá de este
			
			echo "Saliendo... Adios"
			;;

		*)	
			# Para cuando haya un numero que no sea estos 4 marque que la opción no es valida
			echo "opcion no valida"
			;;

	esac
			
done
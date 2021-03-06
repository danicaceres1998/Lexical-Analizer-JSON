# Analizador Lexico, Sintactico y Traductor de JSON
_Lenguaje_: Ruby<br/>
_Versión Utilizada_: 2.7.2<br/>
_Versión Mínima_ >= 2.5.0<br/>

**¿Por qué Ruby?**<br/>
Ruby es un lenguaje de programación dinámico e interpretado, enfocado a la simplicidad y productividad. Gracias a su elegante sintaxis, que se siente natural, es muy fácil escribir y leer código Ruby, es por ello que elegí este lenguaje para poder realizar un desarrollo ágil y robusto. Otra de las razones principales por la que se eligió este lenguaje es gracias a que soporta el manejo de expresiones regulares como tipo de dato, lo cual facilita la validación de tokens.

_**Instrucciones:**_<br/>
**Uso en Linea**<br/>
En el caso de no querer instalar nada, puede acceder a la página de [Replit/Ruby](https://replit.com/languages/ruby) y usar el interprete en linea. _OBS_: Al parecer no se puede realizar clonaciones de repositorios de GitHub mediante "git clone" en esta plataforma, es por ello que se debe de copiar a mano el contenido de los scripts. Si desea probar todos los scripts de una sola vez, utilizar solamente la terminal de la interfaz web y copiar el contenido de los archivos con sus respectivos nombres usando solamente el editor vim (_anlexer.rb_ , *simbols_helper.rb*, _parser.rb_, _translator.rb_ y _source.json_). Si desea probar de manera individual los scripts seguir las indicaciones que se encuentran a continuación.

**Instalación**<br/>
Para instalar Ruby puede ir a [ruby-lang.org/downloads](https://www.ruby-lang.org/en/downloads/) y elegir la version minima requerida o superior (se recomienda la version utilizada documentada mas arriba). Para mas información puede revisar la [Documentación](https://www.ruby-lang.org/es/documentation/installation/), en la misma se encuentran instaladores para los distintos Sistemas Operativos. Una vez instalado el interprete de Ruby, puede clonar el repositorio, moverse al directorio del repositorio y ejecutar los scripts mediante el comando de ejecución de cada script.

# Analizador Lexico JSON
_Autor_: Juan Daniel Ojeda Cáceres<br/>
_Ejecución_: ruby anlexer.rb source.json<br/>
_Resultado_: output.txt (script genera o edita dicho archivo, en pantalla se muestra la ubicación del mismo con algunos detalles)

**Uso en Linea**<br/>
Acceder a [Replit/Ruby](https://replit.com/languages/ruby) y usar el interprete en linea, para ello debe de copiar los scripts a mano mediante el editor de texto y la terminal de la interfaz web (en la terminal a través de vim). Debe de copiar los archivos _anlexer.rb_ (el contenido de este script debe de ir directamente en el editor), *simbols_helper.rb* y _source.json_ (el contenido de estos dos útlimos se deben de copiar a través de vim con sus respectivos nombres). Una vez copiados los archivos, ya puede correr el comando de ejecución ya explicado anteriormente (en este caso seria "_ruby main.rb source.json_").

**Uso local**<br/>
Si ya se instaló en interprete de Ruby, clonar el repositorio, moverse al directorio del repositorio y ejecutar el comando de ejecución ya especificado anteriormente.

# Analizador Sintactico JSON
_Autores_: Juan Daniel Ojeda Cáceres, Mario Ruben Villalba<br/>
_Ejecución_: ruby parser.rb source.json<br/>
_Resultado_: el resultado de compilación se mostrara en pantalla

**Uso en Línea**<br/>
Acceder a [Replit/Ruby](https://replit.com/languages/ruby) y usar el interprete en linea, para ello debe de copiar los scripts a mano mediante el editor de texto y la terminal de la interfaz web (en la terminal a través de vim). Para poder correr el script en linea se deben de copiar los archivos _parser.rb_ (el contenido de este script debe de ir directamente en el editor), _anlexer.rb_ , *simbols_helper.rb* y _source.json_ (en estos tres últimos archivos se debe de copiar el contenido de los mismos a través del editor vim de la terminal, como ya fue explicado en las especificaciones del analizador léxico). Una vez copiados los archivos, ya puede correr el comando de ejecucion (en este caso seria "_ruby main.rb source.json_").

**Uso local**<br/>
Si ya se instaló en interprete de Ruby, clonar el repositorio, moverse al directorio del repositorio y ejecutar el comando de ejecución ya especificado anteriormente.

# Traductor de JSON a XML
_Autores_: Juan Daniel Ojeda Cáceres, Mario Ruben Villalba<br/>
_Ejecución_: ruby translator.rb source.json<br/>
_Resultado_: el resultado de la traducción se encuentra en el archivo output.xml (el script muestra en pantalla el path al archivo).

**Uso en Linea**<br/>
Acceder a [Replit/Ruby](https://replit.com/languages/ruby) y usar el interprete en linea, para ello debe de copiar los scripts a mano mediante el editor de texto y la terminal de la interfaz web (en la terminal a través de vim). Para poder correr el script en linea se deben de copiar los archivos _translator.rb_ (el contenido de este script debe de ir directamente en el editor), _parser.rb_, _anlexer.rb_ , *simbols_helper.rb* y _source.json_ (en estos cuatro últimos archivos se debe de copiar el contenido de los mismos a través del editor vim de la terminal, como ya fue explicado en las especificaciones del analizador léxico y sintáctico). Una vez copiados los archivos, ya puede correr el comando de ejecucion (en este caso seria "_ruby main.rb source.json_").

**Uso local**<br/>
Si ya se instaló en interprete de Ruby, clonar el repositorio, moverse al directorio del repositorio y ejecutar el comando de ejecución ya especificado anteriormente.
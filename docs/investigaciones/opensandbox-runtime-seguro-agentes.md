# OpenSandbox como runtime seguro para agentes

> Estado: conocimiento evaluado / candidato futuro  
> Fecha de revisión: 2026-08-17  
> Proyecto: [OpenSandbox](https://github.com/opensandbox-group/OpenSandbox)  
> Licencia: Apache 2.0

## Resumen ejecutivo

OpenSandbox es una plataforma open source para crear entornos de ejecución aislados y descartables destinados a aplicaciones y agentes de IA.

Su función dentro de MatiOS no sería reemplazar el orquestador, la memoria ni los modelos. Sería la **capa de ejecución segura** en la que un agente puede clonar repositorios, modificar código, instalar dependencias, ejecutar pruebas, navegar con un browser o levantar una preview sin recibir acceso irrestricto al host ni a producción.

La herramienta está alineada con la arquitectura deseada para MatiOS, especialmente con:

- separación estricta entre DEV y PROD;
- Git como fuente de verdad;
- ejecución autónoma mediante agentes;
- revisión humana mediante pull requests;
- trabajos programados o nocturnos;
- reducción del impacto de código generado, errores o prompt injection.

No es una prioridad para el MVP inicial de Agentis. Conviene evaluarla cuando MatiOS empiece a ejecutar código de manera autónoma o a operar tareas simultáneas para varios proyectos o clientes.

## Qué resuelve

OpenSandbox proporciona una API uniforme para:

- crear, renovar y destruir sandboxes;
- ejecutar comandos y código;
- leer y escribir archivos;
- aplicar límites de CPU, memoria y tiempo de vida;
- controlar el tráfico de red de entrada y salida;
- ejecutar navegadores con Chrome o Playwright;
- ofrecer escritorios remotos mediante VNC o VS Code Web;
- conectar agentes mediante SDK, CLI o MCP;
- usar Docker localmente y Kubernetes al escalar;
- reforzar el aislamiento con gVisor, Kata Containers o Firecracker;
- inyectar credenciales sin exponer el secreto directamente al workload;
- observar y auditar la ejecución.

Cuenta con SDK para Python, TypeScript/JavaScript, Java/Kotlin, C#/.NET y Go.

## Qué no resuelve

OpenSandbox no es una plataforma completa de agentes y no reemplaza:

- **MatiOS Core:** coordinación, razonamiento y selección de tareas;
- **Memory Curator:** clasificación y persistencia de conocimiento;
- **n8n:** automatizaciones, triggers y orquestación;
- **Git:** conocimiento estable y revisión de cambios;
- **PostgreSQL:** históricos, eventos y estados operativos;
- **pgvector:** recuperación semántica derivada;
- **Codex, Claude o Gemini:** modelos y agentes que deciden o generan;
- **aprobación humana:** promoción de cambios a producción.

Su responsabilidad es limitada y concreta: ofrecer un lugar controlado donde los agentes puedan actuar.

## Encaje arquitectónico propuesto

```text
MatiOS Core / Planificador
            ↓
       n8n / Orquestador
            ↓
  Codex / Claude / Gemini
            ↓
        OpenSandbox
   ┌────────┼─────────┐
   ↓        ↓         ↓
 código    tests    browser
   └────────┼─────────┘
            ↓
      Pull request
            ↓
     Revisión humana
            ↓
        Producción
```

OpenSandbox debe ubicarse fuera de los servicios productivos. Los sandboxes tendrían permisos mínimos, TTL, cuotas y acceso de red explícitamente limitado.

## Relación con Railway DEV y PROD

OpenSandbox **no reemplaza** los ambientes DEV y PROD persistentes previstos en Railway. Las tres capas cumplen responsabilidades distintas y se complementan:

| Capa | Duración | Responsabilidad |
|---|---|---|
| OpenSandbox | Temporal y descartable | El agente modifica código, instala dependencias, ejecuta tests y valida una tarea con permisos mínimos. |
| Railway DEV | Persistente | Integra y prueba la aplicación completa con API, bot, n8n, PostgreSQL, pgvector y credenciales exclusivamente DEV. |
| Railway PROD | Persistente | Ejecuta la versión aprobada para uso real con servicios, datos y credenciales de producción. |

El flujo de promoción recomendado es:

```text
OpenSandbox
    ↓ código + tests + pull request
Railway DEV
    ↓ validación integral + aprobación humana
Railway PROD
```

Reglas:

- OpenSandbox no debe conectarse directamente a Railway PROD.
- DEV y PROD deben conservar instancias separadas de API/bot, PostgreSQL, pgvector, n8n, datos y credenciales.
- El mismo artefacto o commit validado en DEV debe promoverse a PROD; no se reconstruye manualmente un cambio distinto.
- La destrucción del sandbox no afecta DEV ni PROD.
- OpenSandbox puede reemplazar un entorno local temporal usado para programar o probar, pero no los servicios persistentes desplegados en Railway.

## Caso de uso principal para MatiOS

### Trabajo autónomo nocturno

1. MatiOS selecciona una investigación o mejora priorizada.
2. n8n inicia el flujo.
3. Se crea un sandbox con límites de tiempo, CPU, memoria y red.
4. El agente clona el repositorio correspondiente en una rama.
5. Implementa la tarea y ejecuta validaciones.
6. Si corresponde, levanta una preview y la revisa con Playwright.
7. Produce un resumen, evidencia de pruebas y un pull request.
8. El sandbox se destruye.
9. Matías revisa y decide si promueve el cambio.

### Otros usos posibles

- probar skills y prompts con entornos reproducibles;
- evaluar distintos agentes sobre una misma tarea;
- procesar archivos no confiables;
- construir demos aisladas para clientes de Agentis;
- ejecutar migraciones o scripts de prueba sin tocar el VPS principal;
- permitir que un agente navegue en un entorno con alcance restringido.

## Seguridad

Un contenedor Docker convencional mejora el aislamiento, pero no debe interpretarse como una frontera perfecta para workloads hostiles.

Para una futura operación multiusuario o con datos sensibles:

- no montar el socket Docker dentro del sandbox;
- usar credenciales de vida corta y alcance mínimo;
- denegar acceso a red por defecto y habilitar solo destinos necesarios;
- limitar CPU, RAM, disco, procesos y duración;
- no montar carpetas de producción;
- registrar comandos, imágenes, red y artefactos;
- fijar imágenes por digest y verificar su procedencia;
- evaluar gVisor, Kata o Firecracker según el riesgo;
- destruir los entornos al finalizar;
- exigir revisión humana antes de cualquier promoción a PROD.

## Costos y realidad operativa

La licencia es gratuita, pero la operación no lo es.

Los costos incluyen:

- servidor, CPU, RAM, disco y transferencia;
- imágenes y almacenamiento de artefactos;
- Kubernetes si se necesita escala;
- observabilidad, backups y mantenimiento;
- APIs de los modelos utilizados;
- consumo adicional de browsers y escritorios completos.

Por eso no debe incorporarse solamente por popularidad. Tiene sentido cuando el valor del aislamiento y la automatización supera su complejidad operativa.

## Estrategia de adopción

### Etapa 1 — Ahora

- Mantener Docker Compose separado por proyecto y cliente.
- Continuar priorizando el recorrido funcional completo de MatiOS y el MVP vendible de Agentis.
- No introducir Kubernetes ni OpenSandbox como requisito base.

### Etapa 2 — Prueba técnica

Construir una prueba pequeña y reproducible:

1. iniciar OpenSandbox localmente con Docker;
2. crear un sandbox con TTL y recursos limitados;
3. clonar un repositorio de prueba;
4. pedirle a un agente que modifique un archivo;
5. ejecutar tests;
6. recuperar el diff y los logs;
7. destruir el sandbox.

### Etapa 3 — Integración con MatiOS

Adoptarlo si la prueba demuestra:

- aislamiento práctico respecto del host;
- integración simple con el agente elegido;
- trazabilidad suficiente;
- tiempos y costos aceptables;
- creación confiable de artefactos o pull requests;
- operación estable sin aumentar demasiado el mantenimiento.

### Etapa 4 — Escala

Evaluar Kubernetes y runtimes reforzados únicamente cuando existan:

- varios agentes concurrentes;
- múltiples clientes;
- código o archivos de terceros;
- workloads no confiables;
- necesidad real de cuotas, scheduling y aislamiento superior.

## Decisión actual

**Registrar OpenSandbox como candidato recomendado para la futura capa de ejecución segura de MatiOS, pero no incorporarlo todavía al stack obligatorio.**

Prioridad actual:

1. completar el MVP funcional de MatiOS;
2. lanzar el primer producto vendible de Agentis;
3. implementar ejecución autónoma controlada;
4. probar OpenSandbox como runtime;
5. escalar el aislamiento solo cuando el uso lo justifique.

## Fuentes

- [Repositorio oficial](https://github.com/opensandbox-group/OpenSandbox)
- [Documentación oficial](https://open-sandbox.ai/)
- [Configuración del servidor](https://github.com/opensandbox-group/OpenSandbox/blob/main/server/configuration.md)
- [Guía de despliegue Kubernetes](https://github.com/opensandbox-group/OpenSandbox/blob/main/kubernetes/docs/HELM-DEPLOYMENT.md)

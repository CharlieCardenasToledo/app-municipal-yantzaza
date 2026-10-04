# Mi Yantzaza

MVP web del GAD Municipal de Yantzaza (Zamora Chinchipe, Ecuador) para servicios,
participación ciudadana, comercio local, agenda comunitaria, turismo y seguimiento
demostrativo del recolector. Identidad del **Valle de las Luciérnagas**: paleta
tomada de la bandera cantonal (verde `#0C8E36`, rojo `#E40613`, amarillo `#FEED01`).

## Incluye

- Mapa de Yantzaza con OpenStreetMap (centro en el Parque Central) y rutas viales mediante OSRM.
- Seguimiento animado del recolector con destino y tiempo estimado de llegada.
- Calendario real de recolección diferenciada: tacho verde (lun/mié/vie), negro (mar/dom) y azul (jue), con aviso de "hoy toca".
- Reporte de incidentes, horarios, alertas por crecidas del río Zamora y datos de atención del GAD.
- Pagos municipales con los canales en línea que publica el GAD (Megonline de Coop. Mego y CACPEY Digital).
- Estacionamiento rotativo **como propuesta** (Yantzaza no tiene hoy estacionamiento tarifado).
- Turismo: 17 lugares reales de Yantzaza, Chicaña y Los Encuentros con fotografías locales.
- Agenda: fiestas de cantonización (26 de febrero), Carnaval Chicaña Caliente, Sisay Pacha, mingas y deporte.
- Comercio local: Mercado Municipal, ferias CIALCO, café, cacao, pitahaya y ayampacos.
- Noticias tomadas de los boletines oficiales del GAD.
- Kit de campaña en `marketing/`: flyer, tríptico, carruseles, piezas para redes, capturas reales y reel.

## Ejecutar localmente

```bash
flutter pub get
flutter run -d chrome
```

```bash
flutter test
```

El mapa, el cálculo de rutas y algunas imágenes del comercio requieren conexión a internet.

## Publicación

El proyecto se despliega automáticamente en GitHub Pages mediante
`.github/workflows/deploy-pages.yml` cada vez que se actualiza la rama `main`.

## Investigación y fuentes

Los datos del cantón (población, coordenadas, contactos, horarios, eventos, riesgos) están
documentados con su fuente en [`docs/investigacion-yantzaza.md`](docs/investigacion-yantzaza.md).
Los créditos fotográficos están en [`TOURISM_IMAGE_CREDITS.md`](TOURISM_IMAGE_CREDITS.md).

- [GAD Municipal de Yantzaza](https://www.yantzaza.gob.ec/)
- [PDOT 2024-2027 de Yantzaza](https://www.yantzaza.gob.ec/images/PDyOT/DIAGNOSTICO.pdf)
- [OpenStreetMap](https://www.openstreetmap.org/) · [OSRM](https://project-osrm.org/)
- [Wikimedia Commons](https://commons.wikimedia.org/)

Propuesta desarrollada por Nekatek Labs S.A.S.

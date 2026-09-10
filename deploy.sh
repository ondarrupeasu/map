#!/usr/bin/env bash
# Regenera index.html desde el contenido canónico (missioncontrol/ecosistema.html)
# y lo publica en map.cinemafilmak.com (GitHub Pages).
# Uso:  bash ~/Proyectos/map/deploy.sh
set -e
cd "$(dirname "$0")"
ECO="$HOME/Proyectos/missioncontrol/ecosistema.html"
[ -f "$ECO" ] || { echo "No encuentro $ECO"; exit 1; }

cat > _head.part <<'EOF'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>CinemaFilmak — Mapa del ecosistema</title>
<meta name="description" content="Mapa visual de las apps, webs e infraestructura de CinemaFilmak.">
<link rel="manifest" href="manifest.json">
<link rel="icon" href="icon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="icon-180.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="Map">
<meta name="theme-color" content="#131210">
</head>
<body>
EOF
cat > _tail.part <<'EOF'

<!-- AppReportR: contador de visitas (sin cookies, sin IP). Va aquí (plantilla de deploy),
     no en ecosistema.html, para que quede solo en el mapa público y no en el Artifact privado. -->
<script>fetch('https://stats.cinemafilmak.com/px?s=map&e=view',{mode:'no-cors'}).catch(()=>{})</script>
</body>
</html>
EOF
cat _head.part "$ECO" _tail.part > index.html
rm _head.part _tail.part

if git diff --quiet && git diff --cached --quiet; then
  echo "Sin cambios que publicar."
  exit 0
fi
git add -A
git commit -q -m "Actualizar mapa del ecosistema"
git push -q
echo "Publicado → https://map.cinemafilmak.com  (Pages tarda ~1 min en reflejarlo)"

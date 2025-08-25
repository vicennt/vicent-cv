#!/usr/bin/env bash
set -euo pipefail

echo "=== Instalación de dependencias LaTeX para macOS ==="

# 1) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2) TeX: usa MacTeX-no-gui (distribución ligera sin apps gráficas)
if ! command -v xelatex >/dev/null 2>&1; then
  echo "Instalando MacTeX-no-gui..."
  brew install --cask mactex-no-gui
else
  echo "MacTeX ya instalado."
fi

# 3) Asegurar que /Library/TeX/texbin está en el PATH del usuario
if [[ ":$PATH:" != *":/Library/TeX/texbin:"* ]]; then
  echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zprofile
  export PATH="/Library/TeX/texbin:$PATH"
  echo "Añadido /Library/TeX/texbin al PATH."
fi

# 4) Usar tlmgr con PATH correcto bajo sudo
echo "Actualizando tlmgr y paquetes necesarios..."
sudo /usr/bin/env PATH="/Library/TeX/texbin:$PATH" tlmgr update --self || true
sudo /usr/bin/env PATH="/Library/TeX/texbin:$PATH" tlmgr install latexmk xetex fontspec paracol fontawesome5 academicons roboto lato

# 5) Verificar que el template principal existe
if [ ! -f src/main.tex ]; then
  echo "⚠️  Warning: src/main.tex not found. Please ensure your CV template is in place."
fi

echo "✅ Instalación completada. Prueba a compilar con: make build"
